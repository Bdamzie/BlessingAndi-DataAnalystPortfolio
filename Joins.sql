use Sample

select * from dbo.[contest table] ct;


select * from dbo.[challenges Table] ch;


select * from dbo.[College Table] co;


select * from dbo.Submission_stat_Table sst;


select sst.challenge_ID, Sum(sst.total_submission) AS Sum_of_total_submission,
	Sum(sst.total_accepted_submissions) AS Sum_of_total_accepted_submission 
FROM Submission_stat_Table sst
	
Group by challenge_ID;

select * from dbo.view_stats_table vst;

select vst.challenge_ID, Sum(vst.total_views) AS Sum_of_total_views,

Sum(vst.total_unique_views) AS Sum_of_total_unique_views FROM view_stats_table vst
	
Group by challenge_ID;

SELECT ct.contest_ID, ct.hacker_ID, ct.Name, 
SUM(ss.total_submission), Sum(ss.total_accepted_submissions),
SUM(vs.total_views), 
SUM(vs.total_unique_views)
FROM [contest table] AS ct

JOIN [College Table] col ON ct.contest_ID = col.contest_ID

JOIN [challenges Table] ch ON col.College_ID = ch.college_ID

LEFT JOIN (select ss.challenge_ID, Sum(ss.total_submission) AS Sum_of_total_submission,
	
Sum(ss.total_accepted_submissions) AS Sum_of_total_accepted_submission 
FROM Submission_stat_Table AS ss
	Group by challenge_ID) On ch.challenge_ID = ss.challenge_ID

LEFT JOIN (select vs.challenge_ID, Sum(vs.total_views) AS Sum_of_total_views,
	Sum(vs.total_unique_views) AS Sum_of_total_unique_views 
FROM view_stats_table vs
	Group by Challenge_ID) 0n ch.challenge_ID = vst.challenge_ID

GROUP BY ct.contest_ID, ct.hacker_ID, ct.Name

HAVING( Sum(sst.Sum_of_total_submission)+ 
	Sum(sst.Sum_of_total_accepted_submission)+
	Sum (vst.Sum_of_total_views)+ 
	
Sum(vst.Sum_of_total_unique_views)) > 0

ORDER BY Ct.contest_ID;
	

SELECT con.contest_id, con.hacker_id, con.name, SUM(sg.total_submissions), SUM(sg.total_accepted_submissions), SUM(vg.total_views), SUM(vg.total_unique_views)
FROM [contest table] AS con
JOIN [College Table] AS col ON con.contest_id = col.contest_id
JOIN [challenges Table] AS cha ON cha.college_id = col.college_id
LEFT JOIN
(SELECT ss.challenge_id, SUM(ss.total_submission) AS total_submissions, 
SUM(ss.total_accepted_submissions) AS total_accepted_submissions
FROM Submission_stat_Table AS ss 
GROUP BY ss.challenge_id) AS sg
ON cha.challenge_id = sg.challenge_id
LEFT JOIN
(SELECT vs.challenge_id, SUM(vs.total_views) AS total_views, SUM(vs.total_unique_views) AS total_unique_views
FROM view_stats_table AS vs GROUP BY vs.challenge_id) AS vg
ON cha.challenge_id = vg.challenge_id
GROUP BY con.contest_id, con.hacker_id, con.name
HAVING SUM(sg.total_submissions) +
       SUM(sg.total_accepted_submissions) +
       SUM(vg.total_views) +
       SUM(vg.total_unique_views) > 0
ORDER BY con.contest_id;
	
	
