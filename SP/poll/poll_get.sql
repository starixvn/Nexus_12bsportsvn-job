/*<info serverAlias="SSMS-sabasports" databaseType="2" executers="sabasports" isFunction="0" isNested="0"></info>*/

DROP PROCEDURE IF EXISTS poll_get;

DELIMITER //
CREATE DEFINER=`sabasports`@`%` PROCEDURE `poll_get`(
	IN QuestID INT,
    IN ThemeID INT,
    IN UserIP NVARCHAR(200)
    
     /*
		Creator: Hank@20240320
        Revisions: - 20240320@Hank: init
    */
)
BEGIN
	SELECT pq.id as ID, pq.question_id as QuestionID, pq.answer as Answer, pq.answer_name as AnswerName, pq.vote as Vote
    FROM wp_polls pq
    WHERE pq.question_id = QuestID
    ORDER BY pq.answer_name;
    
    SELECT p.id, p.name, p.answer_type as AnswerType, p.question as Question
    FROM wp_polls_question p
    WHERE p.id = QuestID;
    
    SELECT u.Id, u.question_id as QuestionId, u.user_ip as UserIP, u.answers as Answer
    FROM wp_polls_users u
    WHERE u.question_id = QuestID AND u.user_ip = UserIP LIMIT 0,1;
END

//
DELIMITER ;	