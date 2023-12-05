USE [mdb]
GO

/****** Object:  View [dbo].[vwFullDetail]    Script Date: 1/23/2020 8:58:14 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO











CREATE view [dbo].[vwFullDetail] as

select b.id, d.name as department_name,PARSENAME(d.name,2) as Region,PARSENAME(d.name,2) As Region1,PARSENAME(d.name,1) as branch,e.sym,

case when len(e.sym) - len(REPLACE(e.sym,'.','')) = 3 then PARSENAME(e.sym,4) when len(e.sym) - len(REPLACE(e.sym,'.','')) = 4 then 'FIRSTBANK NIGERIA' else NULL end  as Locatn,

---case when len(e.sym) - len(REPLACE(e.sym,'.','')) = 3 then PARSENAME(e.sym,3) when len(e.sym) - len(REPLACE(e.sym,'.','')) = 4 then PARSENAME(right(e.sym,len(e.sym)-CHARINDEX('.',e.sym)),4) else NULL end as Dept,

case when e.sym like '%IT payment Applications Support%' then 'Information Technology' when len(e.sym) - len(REPLACE(e.sym,'.','')) = 3 then PARSENAME(e.sym,3) when len(e.sym) - len(REPLACE(e.sym,'.','')) = 4 then PARSENAME(right(e.sym,len(e.sym)-CHARINDEX('.',e.sym)),4) else NULL end as Dept,

case when len(e.sym) - len(REPLACE(e.sym,'.','')) = 3 then PARSENAME(e.sym,2) else PARSENAME(right(e.sym,len(e.sym)-CHARINDEX('.',e.sym)),3) end as Dept1,

case when len(e.sym) - len(REPLACE(e.sym,'.','')) = 3 then PARSENAME(e.sym,2) else PARSENAME(right(e.sym,len(e.sym)-CHARINDEX('.',e.sym)),2) end as Unit,

case when len(e.sym) - len(REPLACE(e.sym,'.','')) = 3 then PARSENAME(e.sym,1) else PARSENAME(right(e.sym,len(e.sym)-CHARINDEX('.',e.sym)),1) end as issue_classification,

(select first_name + '  ' + last_name from ca_contact where ca_contact.contact_uuid = b.customer ) as customer,

(select first_name + '  ' + last_name from ca_contact where ca_contact.contact_uuid = b.log_agent ) as LogAgent,

(select first_name + '  ' + last_name from ca_contact where ca_contact.contact_uuid = b.assignee ) as Analyst,

(select  last_name from ca_contact where ca_contact.contact_uuid = b.group_id ) as Assignment,

b.summary as subject_id,

convert(nvarchar(4000),b.description) as description, b.ref_num as incident_id, b.sla_violation as count_of_breached,

case when b.sla_violation = '0' then 0 when b.sla_violation is null then ''   else 1 end as breached,

b.type,d.id as ca_site_id, b.time_spent_sum,e.tenant,b.priority,

b.solution as resolution,b.status, b.active_flag, b.target_closed_count, b.target_hold_count,b.target_resolved_count,

DATEADD(hh,1,dateadd(second, b.open_date, '1/1/1970')) [open_time] ,

DATEADD(second, b.close_date, '1/1/1970') [Resolve_Time] ,

DATEADD(second, b.resolve_date, '1/1/1970') [Expected_Resolution] ,

DATEADD(second, b.target_start_last, '1/1/1970') [target_start_last] ,

DATEADD(second, b.target_resolved_last, '1/1/1970') [target_resolved_last] ,

DATEADD(second, b.target_hold_last, '1/1/1970') [target_hold_last] ,

DATEADD(second, b.target_closed_last, '1/1/1970') [target_closed_last] ,

CASE b.status WHEN 'OP' THEN 'Open' WHEN 'AEUR' THEN 'Awaiting End User Response' WHEN 'AFEUC' THEN 'Awaiting End User Confirmation' WHEN 'CL' THEN 'Closed'

WHEN 'APP' THEN 'Work In Progress'  ELSE 'N/A' END AS status2,

case when b.sla_violation = '0' and b.status = 'CL'  then 'Achieved' when b.sla_violation in ('1','2') and b.status = 'CL' then 'Violated' else 'Outstanding' end as Assignee_SLA2

from

call_req b left join ca_site d  on  b.z_site = d.id  left join

ca_contact a on  a.contact_uuid = b.log_agent

left join prob_ctg e on e.persid = b.category

and e.id > 10000   

and b.open_date is not null and b.sla_violation is not null

GO
