use Sample


select * from dbo.[challenges Table] cha;


select * from dbo.[contest table] con;


select * from dbo.[College Table] col;


select * from dbo.Submission_stat_Table sst;


SELECT sst.challenge_id, SUM(sst.total_submission) AS Sum_of_Total_Submissions,
SUM(sst.total_accepted_submissions) AS Sum_of_Total_Accepted_Submissions

FROM dbo.Submission_stat_Table sst 

GROUP BY sst.challenge_ID;



select * from dbo.view_stats_table vst;

SELECT vst.challenge_id, SUM(vst.total_views) AS Sum_of_Total_Views, 
SUM(vst.total_unique_views) AS Sum_of_Total_Unique_Views

FROM dbo.view_stats_table vst 

GROUP BY vst.Challenge_ID;



SELECT con.contest_id, con.hacker_id, con.name,
SUM(submissions.Sum_of_Total_Submission), SUM(submissions.Sum_of_Total_Accepted_Submissions),

SUM(Sum_of_Total_Views), SUM(Sum_of_Total_Unique_Views)

FROM dbo.[contest table] con
JOIN dbo.[College Table] col ON con.contest_ID = col.contest_ID

JOIN dbo.[challenges Table] cha ON cha.college_ID = col.College_ID 

LEFT JOIN 
(SELECT sst.challenge_id, SUM(sst.total_submission) AS Sum_of_Total_Submission,

SUM(sst.total_accepted_submissions) AS Sum_of_Total_Accepted_Submissions
FROM dbo.Submission_stat_Table sst 
GROUP BY sst.challenge_ID) AS submissions ON Cha.challenge_ID = submissions.challenge_ID

LEFT JOIN
(SELECT vst.challenge_id, SUM(vst.total_views) AS Sum_of_Total_Views, SUM(vst.total_unique_views) 
AS Sum_of_Total_Unique_Views

FROM dbo.view_stats_table vst 
GROUP BY vst.Challenge_ID) AS views ON Cha.challenge_ID = views.Challenge_ID

GROUP BY con.contest_id, con.hacker_id, con.name


-- HAVING(SUM(submissions.Sum_of_Total_Submission) + SUM(submissions.Sum_of_Total_Accepted_Submissions) 
+ SUM(views.Sum_of_Total_Views) + SUM(views.Sum_of_Total_Unique_Views)) > 0

ORDER BY con.contest_id;



-- Removing null values;


SELECT con.contest_id, con.hacker_id, con.name,

(CASE WHEN SUM(submissions.Sum_of_Total_Submission)! = 0 THEN SUM(submissions.Sum_of_Total_Submission) ELSE 0 END) 
AS Total_Submissions,
(CASE WHEN SUM(submissions.Sum_of_Total_Accepted_Submissions)! = 0 THEN SUM(submissions.Sum_of_Total_Accepted_Submissions) ELSE 0 END) 
AS Total_Accepted_Submissions,
(CASE WHEN SUM(Sum_of_Total_Views)! = 0 THEN SUM(Sum_of_Total_Views) ELSE 0 END) 
AS Total_Views,
(CASE WHEN SUM(Sum_of_Total_Unique_Views)! = 0 THEN SUM(Sum_of_Total_Unique_Views) ELSE 0 END) 
AS Total_Unique_Views
FROM dbo.[contest table] con

JOIN dbo.[College Table] col ON con.contest_ID = col.contest_ID

JOIN dbo.[challenges Table] cha ON col.College_ID = cha.college_ID

LEFT JOIN 
(SELECT sst.challenge_id, SUM(sst.total_submission) AS Sum_of_Total_Submission,

SUM(sst.total_accepted_submissions) AS Sum_of_Total_Accepted_Submissions
FROM dbo.Submission_stat_Table sst 
GROUP BY sst.challenge_ID) AS submissions ON Cha.challenge_ID = submissions.challenge_ID

LEFT JOIN
(SELECT vst.challenge_id, SUM(vst.total_views) AS Sum_of_Total_Views, SUM(vst.total_unique_views) 
AS Sum_of_Total_Unique_Views
FROM dbo.view_stats_table vst 
GROUP BY vst.Challenge_ID) AS views ON Cha.challenge_ID = views.Challenge_ID

GROUP BY con.contest_id, con.hacker_id, con.name


--HAVING(SUM(submissions.Sum_of_Total_Submission) + SUM(submissions.Sum_of_Total_Accepted_Submissions) + 
SUM(views.Sum_of_Total_Views) + SUM(views.Sum_of_Total_Unique_Views) > 0

ORDER BY con.contest_id;