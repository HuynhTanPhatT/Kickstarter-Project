select top 20 *
from dbo.Cl_kicks_2016

/* 
	Data Description
- ID: Kickstarter project ID
- name: Name of project
- category: Category of project
- main_category: Main category of project
- goal: Fundraising goal
- pledged: Amount pledged
- state: State of project (successful, canceled, etc.)
- backers: Number of project backers
*/

select distinct(category)
from dbo.Cl_kicks_2016
order by category asc;

select distinct(main_category)
from dbo.Cl_kicks_2016

select distinct(currency)
from dbo.Cl_kicks_2016
order by currency asc;

select distinct(state)
from dbo.Cl_kicks_2016
order by state asc;

select distinct(country), count(*)
from dbo.Cl_kicks_2016
group by country
order by country asc;

-------------------------------------------------------------------------------------------------------------------------------------
--- Check Data Type
select	COLUMN_NAME, DATA_TYPE
from INFORMATION_SCHEMA.COLUMNS
where TABLE_NAME = 'Cl_kicks_2016' and TABLE_SCHEMA = 'dbo';
------------------------------------------------------------------------------------------------------------------------------------
/* 1. Danh mục nào có tỷ lệ thành công cao nhất? */

---- Chiến dịch thuộc lĩnh vực nào (Art, Technology, Games...) có tỷ lệ thành công cao?: 
--- Tỷ lệ thành công cao là số pct > avg pct
-- In Kicks Start 2016, Dance accounts the highest sucessful percentage compared to other categories with ~62%. 
-- Additionally, Theater is on rank 2 with 60%, Comics, Music, Art and Film & Video also with pct unders 60%
with sucess_category as(
select	[main_category],
		count(*) as total_projects,
		sum(case when [state] = 'successful' then 1 else 0 end) as sucess_projects
from dbo.Cl_kicks_2016
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


---- Danh mục nào có nhiều chiến dịch  nhưng tỷ lệ thành công lại thấp?
--- Thế nào là doanh mục có nhiều chiến dịch ?: > average number of projects
-- Film & Video : 37% || Publishing: 29% || Technology : 19% ||

------------------------------------------------------------------------------------------------------------------------------------
/* 2. Mức "goal" ảnh hưởng thế nào đến khả năng thành công? */
----Có mối quan hệ nào giữa mức goal quá cao và tỷ lệ thất bại?
select	main_category,
		goal, backers, pledged,
		(case
		when goal <= 1000 then 'Small'
		when goal <= 5000 then 'Medium'
		when goal <= 50000 then 'Large'
		else 'Enterprise-Level' end) as goal_range,
		state
into #temp_table2
from dbo.Cl_kicks_2016;

----Mục tiêu gọi vốn thấp (dưới 1,000 USD) có dễ thành công hơn không? 
-- with fundraising below 1,000  achieved  47,8% successful percentage based on the total of state_status. It means that if there are 2 small campaigns, one will meet the goal
-- Kickstarter with small fundraising goal below 1000 USD shows  the success percent up to 47.8%.  It shows that targeting small goal can  increase the percentage of getting fully funded
--, especially for new projects, startups or less backers
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

---- Nếu so với toàn bộ dataset, thì tỷ lệ nào trong group range sẽ chiếm nhiều nhất
with goal_range_pct as (
select	goal_range,
		count(*) as total_project,
		sum(case when state = 'successful' then 1 else 0 end) as sucess_projects
from #temp_table2
GROUP BY goal_range
)
select	*,
		round(sucess_projects * 100.0 / total_project,2) as success_pct,
		round(sucess_projects * 100.0 / (select sum(sucess_projects) from goal_range_pct),2) as total_success_rate_of_each_group
from goal_range_pct
order by success_pct desc;

------------------------------------------------------------------------------------------------------------------------------------
/* 5. Thời gian triển khai có ảnh hưởng không? */
---- Chiến dịch kéo dài bao nhiêu ngày thì thành công nhiều nhất?


with launched_Y_M_sucess as (
select	year(cast(launched as date)) as launched_year_camp,
		month(cast(launched as date)) as launched_month_camp,
		count(*) as total_projects,
		sum(case when state = 'successful' then 1 else 0 end) as success_projects
from dbo.Cl_kicks_2016
group by year(cast(launched as date)), month(cast(launched as date))
)
select *
into #temp_table3
from launched_Y_M_sucess


---- Năm nào có tỷ lệ chiến dịch thành công cao nhất?
select	launched_year_camp,
		sum(total_projects) as total_projects, sum(success_projects) as total_sucess_projects,
		round((sum(success_projects) * 100.0 / sum(total_projects)),2) as success_pct
from #temp_table3
where launched_year_camp != 1970
group by launched_year_camp
order by launched_year_camp;

---- Tháng nào trong năm có nhiều chiến dịch thành công nhất?
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
/* 4. Yếu tố địa lý */
----Quốc gia nào có nhiều chiến dịch thành công nhất?
-- US đứng đầu cả 3 bảng xếp hạng về chỉ số
-- Có 2 đất nước làm tôi khá là bất ngờ : NO có xếp hạng tổng dự án đã thực hiện là 5 -> nhưng mà tỷ lệ thành công chỉ có gần 5% xếp hạng 20 và số dự án thành cộng ở hạng 13
-- Còn LU thì ở vị trí chốt sổ ở tổng số dự án và dự án thành công => tuy nhiên đạt được tỷ lệ dự án thành công cao ở hạng 3
with country_projects as (
select	country,
		count(country) as total_projects,
		sum(case when state = 'successful' then 1 else 0 end) as success_projects,
		round(sum(case when state = 'successful' then 1 else 0 end) * 100.0 / count(country),2) as success_rate_per_country
from dbo.Cl_kicks_2016
group by country
)
select	*,
		DENSE_RANK() over (order by total_projects desc) as rank_total_projects,
		DENSE_RANK() over (order by success_projects desc) as rank_total_success_projects,
		DENSE_RANK() over (order by success_rate_per_country desc) as rank_success_rate
from country_projects
order by success_projects desc;
----Quốc gia nào có tỷ lệ thành công cao dù số lượng chiến dịch ít?: Chắc chắn là LU chỉ với 40 chiến dịch nhưng tỷ lệ thành công đặt tới 32.5%

------------------------------------------------------------------------------------------------------------------------------------
/* 3. Tỷ lệ gọi vốn thành công (pledged vs goal): */
With percentage_pledged as (
select	main_category,state,
		backers,
		pledged, goal, 
		round(pledged * 100.0 / goal,2) as pct_pledged
from dbo.Cl_kicks_2016
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

select count(*)
from #temp_table6
where funding_status = 'Fully funded' and pct_pledged > 100

---- Trung binh tỷ lệ gọi vốn của các chiến dịch:
	select main_category, sum(pct_pledged) / count(*) as rank_pct_pledged
	from #temp_table6
	group by main_category
	order by sum(pct_pledged) / count(*) desc;


----Trung bình, chiến dịch thành công gọi được bao nhiêu phần trăm so với mục tiêu?
--- On average, sucessfull fundraising campaigns accounts for ~878% compared to goal
select avg(avg_percent) as average_fundraising_pct
from (
select sum(pct_pledged) / count(pct_pledged) as avg_percent
from #temp_table6
where funding_status = 'Fully funded'
) as average_sucess_campaign;

----Có nhiều chiến dịch vượt xa mức goal không?: >=500% là vượt xa : 6.387
select	main_category, 
		pct_pledged
from #temp_table6
where (funding_status = 'Fully funded' and state = 'successful') and pct_pledged >= 500;

----are these failed projects failing because they don't have any backers or funding?
-- Phần lớn, các trường hợp đều là do backers dưới 100 và funding cũng rất thấp
-- Tuy nhiên: trường hợp của music, film và art có lượng backers và funding caom do đặt goal quá tầm nên dẫn đến tình trạng pct không đạt
select *
from #temp_table6
where funding_status in ('Not nearly funded' , 'Nearly funded') and state = 'failed'
order by backers desc,pct_pledged desc;

