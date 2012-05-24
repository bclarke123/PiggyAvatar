#!/usr/bin/env ruby

class PiggyUpdater
	DAYS = {
		"1_2" => "normal",
		"2_14" => "valentines",
		"2_15" => "normal",
		"2_23" => "bday",
		"2_24" => "normal",
		"7_4" => "homer",
		"7_5" => "normal",
		"11_5" => "anon",
		"11_6" => "normal",
		"12_18" => "xmas",
		"12_26" => "normal",
		"12_31" => "newyear"
	}
	
	DIR = File.join(File.dirname(File.expand_path(__FILE__)), "images")

	def initialize(time)
		if (im = DAYS["#{time.month}_#{time.day}"])
			update_link "bg-#{im}.png"
		end
	end

	def update_link(im)
		link = File.join(DIR, "bg.png")
		File.delete(link) if File.exists? link
		File.symlink(im, link)
		puts "Changed piggy's background to #{im}"
	end
end

if $0 == __FILE__
	PiggyUpdater.new Time.now
end
