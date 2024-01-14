-- explore the data to answer HR QS
select * from Absenteeism_at_work
select * from Reasons
select * from compensation
-- list employees with a healthy life style for special bounes	Q1
select id , age 
from Absenteeism_at_work
where Social_drinker = 0 and
Social_smoker = 0 and 
Body_mass_index < 25 
and Absenteeism_time_in_hours < (select avg( Absenteeism_time_in_hours) from Absenteeism_at_work)

-- find the most 3 reapeted reason for absence Q2
select top 3 r.Reason , count (a.id) as reapeted_num
from Reasons r join Absenteeism_at_work a
on r.Number = a.Reason_for_absence
group by r.Reason
order by reapeted_num desc

--list The most absent employees their age is less than 45 with reasons to check thier case Q3
select top 10 a.id , a.age ,r.reason ,a.Absenteeism_time_in_hours
from Absenteeism_at_work a join Reasons r
on a.Reason_for_absence =r.Number
where age < 45 
order by Absenteeism_time_in_hours desc

--list The most absent employees their age is above 55 with may be give them less working days Q4
select id,age,Absenteeism_time_in_hours
from Absenteeism_at_work
where age >55

-- is distance affcet absenteesim rate may be send them remotly 2 day of the week Q5
select id , Distance_from_Residence_to_Work,Absenteeism_time_in_hours
from Absenteeism_at_work
where Distance_from_Residence_to_Work > (select avg (Distance_from_Residence_to_Work)from Absenteeism_at_work)
and Absenteeism_time_in_hours in (select top 20 (Absenteeism_time_in_hours) from Absenteeism_at_work
order by Absenteeism_time_in_hours desc)

--Which season has the most absenteesim rate Q6
with cte_season as (
select Month_of_absence ,Absenteeism_time_in_hours,
case when Month_of_absence in (12,1,2) then 'winter'
when Month_of_absence in (3,4,5) then 'spring'
when Month_of_absence in (6,7,8) then 'summer'
when Month_of_absence in (9,10,11) then 'fall'
else 'unknowen' end as season_name
from Absenteeism_at_work )
select season_name,count(Absenteeism_time_in_hours) as absence_num
from cte_season 
group by season_name
order by absence_num desc

--calculating the new increace in non-smoking bouns for each employee with new budget (983,500$)
select count (*) as non_smokers
from Absenteeism_at_work
where Social_smoker = 0 
-- as the result is 686 and the increase will be .068/h so each emp 1414 $ bones increase

-------------------------------------------------------------------------------

--- "query for powerbi to make the visual hr dashboard"
select a.id ,a.age,a.Son,a.Social_drinker,a.Social_smoker, a.Reason_for_absence,
a.Month_of_absence , a.Absenteeism_time_in_hours, a.body_mass_index,
case when Month_of_absence in (12,1,2) then 'winter'
when Month_of_absence in (3,4,5) then 'spring'
when Month_of_absence in (6,7,8) then 'summer'
when Month_of_absence in (9,10,11) then 'fall'
else 'unknowen' end as season_name,
r.reason,
c.comp_hr
from Absenteeism_at_work a join reasons r
on a.Reason_for_absence =r.Number 
join compensation c 
on a.ID = c.ID

