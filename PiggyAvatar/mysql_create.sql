SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";

CREATE TABLE IF NOT EXISTS `view_stats` (
  `id` int(11) NOT NULL auto_increment,
  `ip_addr` varchar(15) NOT NULL,
  `referrer` text NOT NULL,
  `request_time` datetime NOT NULL,
  `user_agent` text NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=0;
