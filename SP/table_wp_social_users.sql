CREATE TABLE `wp_social_users` (
  `ID` int(11) NOT NULL,
  `type` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `identifier` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `register_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `login_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `link_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `social_users_id` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`social_users_id`),
  KEY `ID` (`ID`,`type`),
  KEY `identifier` (`identifier`)
) ENGINE=InnoDB AUTO_INCREMENT=141 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
