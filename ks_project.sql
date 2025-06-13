-------------------------------------------------------------------------------------------------------------------------------------
--- Check Data Type
select	COLUMN_NAME, DATA_TYPE
from INFORMATION_SCHEMA.COLUMNS
where TABLE_NAME = 'Cl_kicks_2016' and TABLE_SCHEMA = 'dbo';
-------------------------------------------------------------------------------------------------------------------------------------
/* Create a copy table to avoid affecting to the raw data */
Select *
into kicks_2016_copy
from dbo.Cl_kicks_2016

--Delete canceled - live, suspended
Delete from dbo.kicks_2016_copy
where state in ('live', 'canceled','suspended', 'undefined')
-------------------------------------------------------------------------------------------------------------------------------------
select top 20  *
from kicks_2016_copy

select distinct(category)
from kicks_2016_copy
order by category asc;

select distinct(main_category)
from kicks_2016_copy

select distinct(currency)
from kicks_2016_copy
order by currency asc;

select distinct(state)
from kicks_2016_copy
order by state asc;

select distinct(country), count(*)
from kicks_2016_copy
group by country
order by country asc;
------------------------------------------------------------------------------------------------------------------------------------
/* 1.  Which Category has the highest success percentage? How many projects have been successful? */
with sucess_category as(
select	[main_category],
		count(*) as total_projects,
		sum(case when [state] = 'successful' then 1 else 0 end) as sucess_projects
from dbo.kicks_2016_copy
group by [main_category]	
), sucess_rate as (
select	[main_category],
		total_projects,
		sucess_projects,
		(sucess_projects * 100.0 / total_projects) as sucess_rate
from sucess_category
), avg_metrics as (
select	avg(total_projects) avg_total,
		avg(sucess_rate) avg_pct
from sucess_rate
)
select	sr.main_category, 
		sr.total_projects, avg_total,
		sr.sucess_projects, 
		sr.sucess_rate, avg_pct,
		round(sucess_projects * 100.0/ (select sum(sucess_projects) from sucess_rate),2) as percentage_of_total_project
from sucess_rate sr
cross join avg_metrics avm
where sr.sucess_rate> avm.avg_pct
group by [main_category], total_projects, sucess_projects, sucess_rate, avg_total, avg_pct
order by sucess_rate desc;

------------------------------------------------------------------------------------------------------------------------------------
/* 2. How does the "goal" amount affect the likelihood of success? */
select	main_category,
		goal, backers, pledged,
		(case
		when goal <= 1000 then 'Small'
		when goal <= 10000 then 'Medium'
		when goal <= 50000 then 'Large'
		else 'Enterprise-Level' end) as goal_range,
		state
into #temp_table2
from dbo.kicks_2016_copy;

---- Are small goals under 1,000 more likely to succeed ? 
With small_goal as (
select	state, 
		count(state) as total_state_projects
from #temp_table2
where goal_range = 'Small'
group by state
)
select	*,
		round(total_state_projects * 100.0 / (select sum(total_state_projects) from small_goal),2) as success_pct
from small_goal
order by success_pct desc;

---- Which goal range has the highest success rate?
with goal_range_pct as (
select	goal_range,
		count(*) as total_project,
		sum(case when state = 'successful' then 1 else 0 end) as sucess_projects
from #temp_table2
GROUP BY goal_range
)
select	*,
		round(sucess_projects * 100.0 / total_project,2) as success_pct
from goal_range_pct
order by success_pct desc;

------------------------------------------------------------------------------------------------------------------------------------
/* 3. Success Rate of Fundraising (pledged / goal): */
With percentage_pledged as (
select	name, main_category,state,
		backers,
		pledged, goal, 
		round(pledged * 100.0 / goal,2) as pct_pledged
from dbo.kicks_2016_copy
where pledged is not null and goal is not null
),funding_status as (
select	*, 
		(case
		when pct_pledged >=100 then 'Fully funded'
		when pct_pledged between 75 and 99 then 'Nearly funded'
		else 'Not nearly funded' end) as funding_status
from percentage_pledged
)
select *
into #temp_table6
from funding_status;

---- Average fundraising percentage across campaigns 
select	main_category, sum(pct_pledged) / count(*) as rank_pct_pledged
from #temp_table6
group by main_category
order by sum(pct_pledged) / count(*) desc;

----Are there many projects that  exceeded their funding goals?: : 6.387
select	name, main_category,
		goal, pledged,
		pct_pledged
from #temp_table6
where (funding_status = 'Fully funded' and state = 'successful') and pct_pledged >= 500
group by name, goal, pledged, main_category, pct_pledged
order by pct_pledged desc;

---- Are these failed projects failing because they don't have any backers or funding?: 
select *
from #temp_table6
where  state = 'failed'
order by backers desc,pct_pledged desc;

------------------------------------------------------------------------------------------------------------------------------------


/* 4. Which country has the highest number of successful campaigns? */
----Which countries have a high success rate despite a low number of campaigns?
with country_projects as (
select	country,
		count(country) as total_projects,
		sum(case when state = 'successful' then 1 else 0 end) as success_projects,
		round(sum(case when state = 'successful' then 1 else 0 end) * 100.0 / count(country),2) as success_rate_per_country
from dbo.kicks_2016_copy
group by country
)
select	*,
		DENSE_RANK() over (order by total_projects desc) as rank_total_projects,
		DENSE_RANK() over (order by success_projects desc) as rank_total_success_projects,
		DENSE_RANK() over (order by success_rate_per_country desc) as rank_success_rate
from country_projects
order by success_projects desc;
------------------------------------------------------------------------------------------------------------------------------------

/* 5. Which year had the highest success rates ? */
with launched_Y_M_sucess as (
select	year(cast(launched as date)) as launched_year_camp,
		month(cast(launched as date)) as launched_month_camp,
		count(*) as total_projects,
		sum(case when state = 'successful' then 1 else 0 end) as success_projects
from dbo.kicks_2016_copy
group by year(cast(launched as date)), month(cast(launched as date))
)
select *
into #temp_table3
from launched_Y_M_sucess


select	launched_year_camp,
		sum(total_projects) as total_projects, sum(success_projects) as total_sucess_projects,
		round((sum(success_projects) * 100.0 / sum(total_projects)),2) as success_pct
from #temp_table3
where launched_year_camp != 1970
group by launched_year_camp
order by launched_year_camp;

/* 6. Which month has the highest successful projects ?*/
with rank_success_projects as (
select	*,
		DENSE_RANK() over (partition by launched_year_camp order by success_projects desc) as rank_success_projects
from #temp_table3
)
select	*
from rank_success_projects
where (rank_success_projects = 1) and (launched_year_camp <> 1970)
order by launched_year_camp asc;
------------------------------------------------------------------------------------------------------------------------------------
