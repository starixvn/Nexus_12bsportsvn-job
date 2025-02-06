/*<info serverAlias="SSMS-sabasports" databaseType="2" executers="sabasports" isFunction="0" isNested="0"></info>*/
DROP PROCEDURE IF EXISTS get_posts;

DELIMITER //


CREATE DEFINER=`sabasports`@`%` PROCEDURE `get_posts`(
	/*
		Creator: Brian@20220913
        Revisions:
			- 20220913@Brian: init
            - 20240130@Hank: add param startItem, Limit
    */
	_fromDate DATETIME,
    _category INT,
    _subject INT,
    _startItem INT,
    _rowLimit INT
)
BEGIN
	IF _category = 3 THEN
		IF _subject = 0 THEN
			CALL get_api_recent_posts(_category, _fromDate, _startItem, _rowLimit);
		END IF;
        IF _subject = 2 THEN
			CALL get_soccer_posts(_category, _fromDate, _startItem, _rowLimit);
		END IF;
        IF _subject = 3 THEN
			CALL get_posts_by_subject('bong-ro', _category, _subject, _fromDate, _startItem, _rowLimit);
		END IF;
        IF _subject = 81 THEN
			CALL get_posts_by_subject('quan-vot', _category, _subject, _fromDate, _startItem, _rowLimit);
		END IF;
	END IF;
    IF _category = 4 THEN
		IF _subject = 0 THEN
			CALL get_posts_by_subject('video', _category, _subject, _fromDate, _startItem, _rowLimit);
		END IF;
        IF _subject = 2 THEN
			CALL get_posts_by_subject('video-bong-da', _category, _subject, _fromDate, _startItem, _rowLimit);
		END IF;
        IF _subject = 3 THEN
			CALL get_posts_by_subject('video-bong-ro', _category, _subject, _fromDate, _startItem, _rowLimit);
		END IF;
        IF _subject = 81 THEN
			CALL get_posts_by_subject('video-quan-vot', _category, _subject, _fromDate, _startItem, _rowLimit);
		END IF;
	END IF;
END

//
DELIMITER ;	