alter table `sabasports`.`wp_polls`
   modify column `answer` VARCHAR(200)
   CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL ;
   
alter table `sabasports`.`wp_polls_question`
   modify column `question` TEXT,
   modify column `name` VARCHAR(512)
   CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL ;


DROP PROCEDURE IF EXISTS poll_get;

DELIMITER //

CREATE DEFINER=`sabasports`@`%` PROCEDURE `poll_get`(
	IN QuestID INT,
    IN ThemeID INT,
    IN UserIP NVARCHAR(200),
    OUT IsVoted TINYINT
)
BEGIN
	SET IsVoted = 0;
	select pq.id as ID, pq.question_id as QuestionID, pq.answer as Answer, pq.answer_name as AnswerName, pq.vote as Vote
    FROM wp_polls pq
    WHERE pq.question_id = QuestID
    ORDER BY pq.answer_name;
    
    SELECT p.id, p.name, p.answer_type as AnswerType, p.question as Question
    FROM wp_polls_question p
    WHERE p.id = QuestID;
    
    SELECT 1 INTO IsVoted FROM wp_polls_users WHERE question_id = QuestID AND user_ip = UserIP LIMIT 0,1;
END

//
DELIMITER ;	

DROP PROCEDURE IF EXISTS poll_vote;

DELIMITER //
CREATE DEFINER=`sabasports`@`%` PROCEDURE `poll_vote`(
	IN QuestId INT,
    IN AnswerId INT,
    IN UserIP  NVARCHAR(200),
    OUT ErrCode SMALLINT,
    OUT ErrMsg VARCHAR(100)
)
poll_vote: BEGIN 
	DECLARE pollId int;
    SET pollID = 0;
    SELECT p.id INTO pollID FROM wp_polls p where p.question_id = QuestId AND p.answer_name = AnswerId;
    
    IF (pollID = 0) THEN
		SET ErrCode = 1,
			ErrMsg = 'Answer does not exist';
        LEAVE poll_vote;
	END IF;
    
	UPDATE `wp_polls`
	SET
	`vote` = vote + 1
	WHERE `id` = pollID;
    
    INSERT INTO `wp_polls_users`
	(`user_ip`,
	`question_id`,
	`answers`)
	VALUES
	(UserIP,
	QuestId,
	AnswerId);


END

//
DELIMITER ;	