module UserAgent
	LINUX=0
	BSD=1
	WIN32=2
	MAC=3
	SUNOS=4	
	OS_UNKNOWN=5
	PSP=6
	WII=7
	UBUNTU=8
	DEBIAN=9
	WINXP=10
	WIN2K=11
	VISTA=12
	PS3=13

	FIREFOX=0
	MSIE7=1
	MSIE=2
	SAFARI=3
	OPERA=4
	KHTML=5
	MOZILLA=6
	BROWSER_UNKNOWN=7
	PSP_BROWSER=8
	ICEWEASEL=9
	FIREFOX2=10
	FIREFOX15=11
	MINEFIELD=12
	FIREFOX3=13
	CHROME=14
	SONGBIRD=15
	PS3_BROWSER=16

	OS_IMAGES = [
		'linux.jpg',
		'bsd.jpg',
		'win32.jpg',
		'mac.jpg',
		'sunos.jpg',
		'unknown.jpg',
		'psp.jpg',
		'wii.jpg',
		'ubuntu.jpg',
		'debian.jpg',
		'win32.jpg',
		'win32.jpg',
		'vista.jpg',
		'ps3.jpg'
	]

	OS_NAMES = [
		'Linux',
		'BSD',
		'Windows',
		'Mac',
		'Solaris',
		'Unknown',
		'PSP',
		'Nintendo Wii',
		'Ubuntu',
		'Debian',
		'Windows XP',
		'Windows 2000',
		'Windows Vista',
		'Playstation 3'
	]

	BROWSER_IMAGES = [
		'firefox.jpg',
		'ie.jpg',
		'ie.jpg',
		'safari.jpg',
		'opera.jpg',
		'khtml.jpg',
		'mozilla.jpg',
		'unknown.jpg',
		'unknown.jpg',
		'iceweasel.jpg',
		'firefox.jpg',
		'firefox.jpg',
		'minefield.png',
		'firefox.jpg',
		'chrome.jpg',
		'songbird.jpg',
		'unknown.jpg'
	]

	BROWSER_NAMES = [
		'Firefox',
		'IE 7',
		'IE <= 6',
		'Safari',
		'Opera',
		'KHTML',
		'Mozilla',
		'Unknown',
		'PSP Browser',
		'GNU Iceweasel',
		'Firefox 2.0',
		'Firefox 1.5',
		'Minefield (FF 3.0b)',
		'Firefox 3.0',
		'Google Chrome',
		'Mozilla Songbird',
		'PS3 Browser'
	]
	
	class Parser
		
		attr_accessor :browser, :operating_system

		def initialize(ua)
			@ua = ua.downcase
			@browser = parse_browser
			@operating_system = parse_operating_system
		end
	
		def browser_image
			BROWSER_IMAGES[@browser]
		end
	
		def operating_system_image
			OS_IMAGES[@operating_system]
		end
	
		def browser_name
			BROWSER_NAMES[@browser]
		end
		
		def operating_system_name
			OS_NAMES[@operating_system]
		end
		
		def is_ff?
			return [ FIREFOX, FIREFOX15, FIREFOX2, FIREFOX3, MINEFIELD ].include?(@browser)
		end
		
		def is_ie?
			return [ MSIE, MSIE7 ].include?(browser)
		end

		private
		
		def parse_browser
			if @ua =~ /songbird/
				return SONGBIRD
			elsif @ua =~ /minefield/
				return MINEFIELD
			elsif @ua =~ /firefox\/3\.0/
				return FIREFOX3
			elsif @ua =~ /firefox\/2\.0/
				return FIREFOX2
			elsif @ua =~ /firefox\/1\.5/
				return FIREFOX15
			elsif @ua =~ /msie.7\.0/
				return MSIE7
			elsif @ua =~ /msie/
				return MSIE
			elsif @ua =~ /chrome/
				return CHROME
			elsif @ua  =~ /safari/
				return SAFARI
			elsif @ua =~ /firefox/
				return FIREFOX
			elsif @ua =~ /iceweasel/
				return ICEWEASEL
			elsif @ua =~ /opera/
				return OPERA
			elsif @ua =~ /khtml/
				return KHTML
			elsif @ua =~ /psp/
				return PSP_BROWSER
			elsif @ua =~ /playstation.3/
				return PS3_BROWSER
			elsif @ua =~ /gecko/
				return MOZILLA
			end
			return BROWSER_UNKNOWN
		end
	
		def parse_operating_system
			if @ua =~ /nt.5\.0/
				return WIN2K
			elsif @ua =~ /nt.5\.1/
				return WINXP
			elsif @ua =~ /nt.6/
				return VISTA
			elsif @ua =~ /debian/
				return DEBIAN
			elsif @ua =~ /ubuntu/
				return UBUNTU
			elsif @ua =~ /linux/
				return LINUX
			elsif @ua =~ /bsd/
				return BSD
			elsif @ua =~ /mac/
				return MAC
			elsif @ua =~ /win[32|dows]/
				return WIN32
			elsif @ua =~ /sunos/
				return SUNOS
			elsif @ua =~ /psp/
				return PSP
			elsif @ua =~ /nintendo.wii/
				return WII
			elsif @ua =~ /playstation.3/
				return PS3
			end
			return OS_UNKNOWN
		end
		
	end
end

