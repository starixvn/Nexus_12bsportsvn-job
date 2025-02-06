/*<info serverAlias="SSMS-sabasports" databaseType="2" executers="sabasports" isFunction="0" isNested="0"></info>*/

DROP PROCEDURE IF EXISTS poll_vote;

DELIMITER //
CREATE DEFINER=`sabasports`@`%` PROCEDURE `poll_vote`(
	IN QuestId INT,
    IN AnswerId INT,
    IN UserIP  NVARCHAR(200),
    OUT ErrCode SMALLINT,
    OUT ErrMsg VARCHAR(100)
     /*
		Creator: Hank@20240320
        Revisions: - 20240320@Hank: init
    */
)
poll_vote: BEGIN 
	DECLARE pollId INT;
    DECLARE userOldAnswer INT;
    SET pollID = 0;
    SET userOldAnswer = 0;
    SELECT p.id INTO pollID FROM wp_polls p where p.question_id = QuestId AND p.answer_name = AnswerId;
    
    IF (pollID = 0) THEN
		SET ErrCode = 1,
			ErrMsg = 'Answer does not exist';
        LEAVE poll_vote;
	END IF;
    SELECT pu.answers INTO  userOldAnswer FROM wp_polls_users pu WHERE pu.user_ip = UserIP AND pu.question_id = QuestId;
    
    IF(userOldAnswer = 0) 
    THEN
		INSERT INTO `wp_polls_users`
		(`user_ip`,
		`question_id`,
		`answers`)
		VALUES
		(UserIP,
		QuestId,
		AnswerId);
	ELSE
		UPDATE `wp_polls` as p
		SET
		`vote` = vote - 1
		WHERE p.question_id = QuestId AND p.answer_name = userOldAnswer ;
        
		UPDATE `wp_polls_users` as pu
		SET pu.answers = AnswerId
		WHERE pu.user_ip = UserIP AND pu.question_id = QuestId;
    END IF;
    
    UPDATE `wp_polls`
	SET
	`vote` = vote + 1
	WHERE `id` = pollID;
END

//
DELIMITER ;	