CREATE TABLE `wp_email` (
  `ID` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `EmailTitle` varchar(200) NOT NULL DEFAULT '',
  `EmailContent` text NOT NULL,
  `EmbeddedLink` varchar(200) DEFAULT '',
  `SendDate` datetime DEFAULT NULL,
  `CreatedBy` bigint(20) unsigned NOT NULL,
  `CreatedDate` datetime DEFAULT NULL,
  `Status` int(11) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



CREATE TABLE `wp_email_detail` (
  `EmailId` bigint(20) unsigned NOT NULL,
  `UserId` bigint(20) unsigned NOT NULL,
  `TokenId` varchar(200) CHARACTER SET utf8 NOT NULL DEFAULT '',
  `EmailAddress` varchar(200) NOT NULL,
  `EmailTitle` varchar(200) NOT NULL,
  `EmailContent` text NOT NULL,
  `SendTime` datetime DEFAULT NULL,
  `UserClickedTime` datetime DEFAULT NULL,
  `RetryTime` datetime DEFAULT NULL,
  `IsUserClicked` tinyint(2) NOT NULL DEFAULT '0',
  `Status` tinyint(2) NOT NULL DEFAULT '0',
  PRIMARY KEY (`EmailId`,`UserId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
