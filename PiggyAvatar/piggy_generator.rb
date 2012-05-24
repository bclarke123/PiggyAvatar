require 'rack'
require 'RMagick'
require 'geoip'
require 'parsedate'
require 'config'
require 'user_agent'

if Config::USE_DB
	require 'mysql'
	require 'socket'
end

class PiggyGenerator
	WIDTH = 150
	HEIGHT = 225

	APP_ROOT = File.dirname(File.expand_path(__FILE__))
	IMAGES = File.join(APP_ROOT, 'images')
	BG = File.join(IMAGES, 'bg.png')
	FLAG_DIR = File.join(IMAGES, 'flags')
	OS_DIR = File.join(IMAGES, 'oses')
	BROWSER_DIR = File.join(IMAGES, 'browsers')
	GEOIP = GeoIP.new(File.join(APP_ROOT, 'GeoIP.dat'))

	FONT = File.join(APP_ROOT, 'HAMMRTHN.TTF')
	FONT_COLOR = "#75466E"
	FONT_SIZE = 15

	RFC_1123 = "%a, %d %b %Y %H:%M:%S GMT"

	def self.process!(env)

		req = Rack::Request.new(env)
		headers = { 'Content-Type' => 'image/png' }

		addr = req.params['ip']
		silent = req.params['silent']
		req_addr = env['REMOTE_ADDR']
		req_ua = env['HTTP_USER_AGENT']
		req_referrer = env['HTTP_REFERRER']
		
		begin
			mod_time = File.mtime(BG)
			headers['Last-Modified'] = mod_time.strftime(RFC_1123)
			headers['Expires'] = (Time.now + 3600).strftime(RFC_1123)
				
			if env['HTTP_IF_MODIFIED_SINCE']
				since = ParseDate.parsedate(env['HTTP_IF_MODIFIED_SINCE'])
				since = Time.local(*since)
				return [ 304, headers, nil ] if since > mod_time
			end

			msg = (addr.nil? ? "you are in" : "#{addr} is")
			addr = env["REMOTE_ADDR"] if addr.nil?

			country = GEOIP.country(addr)
			country_code = country[3]
			country_name = country[5]
			ua = UserAgent::Parser.new(env['HTTP_USER_AGENT'].downcase)

			bg = get_im(BG)
			gc = Magick::Draw.new
			add_im(gc, bg, 0, 0)

			gc.font=FONT
			gc.fill(FONT_COLOR)
			gc.pointsize=FONT_SIZE
		
			if country_code and country_code != '--'
				flag = get_im(File.join(FLAG_DIR, "#{country_code.downcase}.png"))
				if flag
					flagx = WIDTH - flag.columns
					flagy = WIDTH - flag.rows				
					add_im(gc, flag, flagx - 5, flagy - 5)
				end
				gc.text(2,15, "Piggy says #{msg}\n#{country_name}")
			else
				gc.text(2,15, "Piggy doesn't know\nwhere you are!")
			end
		
			os = get_im(File.join(OS_DIR, ua.operating_system_image))
			browser = get_im(File.join(BROWSER_DIR, ua.browser_image))
		
			add_im(gc, os, 0, WIDTH)
			add_im(gc, browser, WIDTH / 2, WIDTH)

			if Config::USE_DB
				myaddr = TCPSocket.gethostbyname(Config::MY_HOSTNAME)[3]
				if !silent && myaddr != req_addr
					begin
						dbh = Mysql.real_connect(
							Config::DB_URL, 
							Config::DB_USER, 
							Config::DB_PASS, 
							Config::DB_NAME)

						req_addr = dbh.escape_string(req_addr || "")
						ua = dbh.escape_string(req_ua || "")
						ref = dbh.escape_string(req_referrer || "")

						res = dbh.query(get_last_hit_sql(req_addr))
						count = res.fetch_row[0].to_i

						if count == 0
							dbh.query(get_insert_sql(ref, ua, req_addr))
						end
					ensure
						dbh.close if dbh
					end
				end
			end

			canvas = Magick::Image.new(WIDTH, HEIGHT)
			gc.draw(canvas)
		
			body = canvas.to_blob { 
				self.format = 'PNG'
				self.quality = 75
				self.compression = Magick::ZipCompression
			}

			return [ 200, headers, body ]

		rescue Exception => e
			headers["Content-Type"] = "text/plain"
			return [ 500, headers, "#{e.message}\n#{e.backtrace}\n(#{APP_ROOT})" ]
		end	
	end

	def self.get_im(im)
		Magick::Image.read(im)[0]
	end
	
	def self.add_im(bg, addition, x, y)
		bg.composite(x, y, 0, 0, addition)
	end
	
	def self.get_last_hit_sql(addr)
		"select count(*) from view_stats " +
                "where ip_addr = '#{addr}' and DATE_SUB(NOW(), INTERVAL 5 MINUTE) <= request_time;"
	end

	def self.get_insert_sql(referrer, user_agent, address)
		"insert into view_stats(ip_addr, user_agent, referrer, request_time) " + 
		"values ('#{address}', '#{user_agent}', '#{referrer}', NOW());"
	end
end
