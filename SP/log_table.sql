CREATE TABLE `sabasports`.`wp_Log` (
  `Id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `ActorId` varchar(255) DEFAULT NULL,
  `ActionId` varchar(255) NOT NULL,
  `Data` longtext,
  `OldData` longtext,
  `LogDate` datetime DEFAULT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


CREATE TABLE `sabasports`.`wp_LogAction` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `ActionName` varchar(255) NOT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


INSERT INTO `sabasports`.`wp_LogAction`(`ActionName`) VALUES ('Update Banner');
INSERT INTO `sabasports`.`wp_LogAction`(`ActionName`) VALUES ('Send Test EDM');
INSERT INTO `sabasports`.`wp_LogAction`(`ActionName`) VALUES ('Update Profile');
