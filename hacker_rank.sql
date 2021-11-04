--Revising the Select Query I
SELECT *
FROM CITY
WHERE CITY.COUNTRYCODE = 'USA' AND CITY.POPULATION > 100000;

--Revising the Select Query II
SELECT CITY.NAME
FROM CITY
WHERE CITY.COUNTRYCODE = 'USA' AND CITY.POPULATION > 120000;

--Select All
SELECT *
FROM CITY;

--Select By ID
SELECT *
FROM CITY
WHERE ID = 1661;

--Japanese Cities' Attributes
SELECT *
FROM CITY
WHERE COUNTRYCODE = 'JPN';

--Japanese Cities' Names
SELECT NAME
FROM CITY
WHERE COUNTRYCODE = 'JPN';

--Weather Observation Station 1
SELECT CITY, STATE
FROM STATION
WHERE LAT_N > 0 AND LONG_W > 0;

--Weather Observation Station 2
select round(sum(lat_n), 2), round(sum(long_w), 2)
from station

--Weather Observation Station 3
SELECT DISTINCT CITY
FROM STATION
WHERE ID % 2 = 0;

--Weather Observation Station 4
SELECT COUNT(CITY) - COUNT(DISTINCT CITY)
FROM STATION
WHERE LAT_N > 0 AND LONG_W > 0;

--Weather Observation Station 5
SELECT CITY, LENGTH(CITY)
FROM STATION
WHERE LENGTH(CITY) = (
SELECT MIN(LENGTH(CITY))
FROM STATION
) ORDER BY CITY 
LIMIT 1;

SELECT CITY, LENGTH(CITY)
FROM STATION
WHERE LENGTH(CITY) = (
SELECT MAX(LENGTH(CITY))
FROM STATION
) ORDER BY CITY
LIMIT 1;

--Weather Observation Station 6
SELECT DISTINCT CITY FROM STATION WHERE CITY REGEXP '^[aeiouAEIOU]';

--Weather Observation Station 7
SELECT DISTINCT CITY FROM STATION WHERE CITY REGEXP '[aeiouAEIOU]$';

--Weather Observation Station 8
SELECT DISTINCT CITY FROM STATION WHERE CITY REGEXP '^[aeiouAEIOU].*[aeiouAEIOU]$';

--Weather Observation Station 9
SELECT DISTINCT CITY FROM STATION WHERE CITY REGEXP '^[^aeiouAEIOU]';

--Weather Observation Station 10
SELECT DISTINCT CITY FROM STATION WHERE CITY REGEXP '[^aeiouAEIOU]$';

--Weather Observation Station 11
SELECT DISTINCT CITY FROM STATION WHERE CITY REGEXP '^[^aeiouAEIOU].*|.*[^aeiouAEIOU]$' AND LAT_N > 0 AND LONG_W > 0;

--Weather Observation Station 12
SELECT DISTINCT CITY FROM STATION WHERE CITY REGEXP '^[^aeiouAEIOU].*[^aeiouAEIOU]$' AND LAT_N > 0 AND LONG_W > 0;

--Weather Observation Station 13
select round(sum(lat_n), 4)
from station
where lat_n > 38.7880 and lat_n < 137.2345

--Weather Observation Station 14
select round(max(lat_n), 4)
from station
where lat_n < 137.2345

--Weather Observation Station 15
select round(long_w, 4)
from station
where lat_n = (select max(lat_n) from station where lat_n < 137.2345)

--Weather Observation Station 16
select round(min(lat_n), 4)
from station
where lat_n > 38.7780

--Weather Observation Station 17
select round(long_w, 4)
from station
where lat_n = (select min(lat_n) from station where lat_n > 38.7780)

--Weather Observation Station 18
select round((max(lat_n) - min(lat_n)) + (max(long_w) - min(long_w)), 4)
from station

--Weather Observation Station 19
select round(sqrt(power(max(lat_n) - min(lat_n), 2) + power(max(long_w) - min(long_w), 2)), 4)
from station

--Weather Observation Station 20
/* If the number of rows were even. I could just creae a separate of the above. 
Then, I could do a where = 0 with an and (row_num =xxx+1 or row_num=xxx-1)
returning two rows then sum(lat_n)/2 to give me an the median for an even */
select round(ct, 4)
from
(select lat_n as ct,
row_number() over (order by lat_n) as row_num
from
station) sub
where (select count(*)%2 from station)=1 and row_num = (select ceiling(count(lat_n)/2) from station)
--Additional Solution
select round(ct, 4)
from
(select 
 lat_n as ct,
 row_number() over (order by lat_n) as row_num
from
station) sub
where row_num = (select ceiling(count(lat_n)/2) from station)

--Higher Than 75 Marks
SELECT NAME FROM STUDENTS WHERE MARKS > 75 ORDER BY RIGHT(NAME, 3), ID;

--Employee Names
SELECT Name
FROM Employee
ORDER BY Name;

--Employee Salaries
SELECT Name
FROM Employee
WHERE Salary > 2000 AND Months < 10
ORDER BY Employee_Id;

--Type of Triangle
SELECT 
    CASE
        WHEN A + B > C AND B + C > A AND A + C > B THEN
            CASE
                WHEN A = B AND B = C THEN 'Equilateral'
                WHEN A = B OR B = C OR A = C THEN 'Isosceles'
                WHEN A <> B AND B <> C AND A <> C THEN 'Scalene'
            END
        ELSE 'Not A Triangle'
    END
FROM TRIANGLES;

--The PADS
SELECT CONCAT(Name,'(', SUBSTRING(Occupation, 1,1), ')')
FROM OCCUPATIONS ORDER BY Name ASC;

SELECT CONCAT('There are a total of ', COUNT(Occupation), ' ', LOWER(Occupation), 's.')
FROM OCCUPATIONS
GROUP BY Occupation ORDER BY COUNT(Occupation);

--Occupations
SET @d = 0, @p = 0, @s = 0, @a = 0;
SELECT MIN(DOCTOR_NAMES), MIN(PROFESSOR_NAMES), MIN(SINGER_NAMES), MIN(ACTOR_NAMES)
FROM
  (
    SELECT
      CASE WHEN OCCUPATION = 'Doctor' THEN NAME END AS DOCTOR_NAMES,
      CASE WHEN OCCUPATION = 'Professor' THEN NAME END AS PROFESSOR_NAMES,
      CASE WHEN OCCUPATION = 'Singer' THEN NAME END AS SINGER_NAMES,
      CASE WHEN OCCUPATION = 'Actor' THEN NAME END AS ACTOR_NAMES,
      CASE
        WHEN OCCUPATION = 'Doctor' THEN (@d := @d + 1)
        WHEN OCCUPATION = 'Professor' THEN (@p := @p + 1)
        WHEN OCCUPATION = 'Singer' THEN (@s := @s + 1)
        WHEN OCCUPATION = 'Actor' THEN (@a := @a + 1)
      END AS ROW_NUM
    FROM OCCUPATIONS
    ORDER BY NAME
  ) AS TEMP
GROUP BY ROW_NUM;
--Another Solution
set @r1=0, @r2=0, @r3=0, @r4=0;
select min(Doctor), min(Professor), min(Singer), min(Actor)
from(select 
case 
  when Occupation="Doctor" then (@r1:=@r1+1) 
  when Occupation="Professor" then (@r2:=@r2+1) 
  when Occupation="Singer" then (@r3:=@r3+1) 
  when Occupation="Actor" then (@r4:=@r4+1) 
end 
as RowNumber,
case when Occupation="Doctor" then Name end as Doctor,
case when Occupation="Professor" then Name end as Professor,
case when Occupation="Singer" then Name end as Singer,
case when Occupation="Actor" then Name end as Actor from OCCUPATIONS order by Name
) Temp group by RowNumber;

--Binary Tree Nodes
SELECT N,
IF (P IS NULL, 'Root',
IF ((SELECT COUNT(*) FROM BST
WHERE B.N=P)>0, 'Inner', 'Leaf'))
FROM BST AS B
ORDER BY N;
--Another Solution
SELECT N,
CASE
    WHEN P IS NULL THEN 'Root'
    WHEN N IN (SELECT DISTINCT P FROM BST) THEN 'Inner'
    ELSE 'Leaf'
END
FROM BST
ORDER BY N;

--New Companies
select company_code, founder,
(select count(distinct lead_manager_code) from lead_manager lm
    where lm.company_code = c.company_code),
(select count(distinct senior_manager_code) from senior_manager sm
    where sm.company_code = c.company_code),
(select count(distinct manager_code) from manager m
    where m.company_code = c.company_code),
(select count(distinct employee_code) from employee e
    where e.company_code = c.company_code)
from company as c
order by company_code;

--Revising Aggregations - The Count Function
select count(*)
from city
where population > 100000;

--Revising Aggregations - The Sum Function
select sum(population)
from city
where district = 'california';

--Revising Aggregations - Averages
select avg(population)
from city
where district = 'california';

--Average Population
select floor(avg(population))
from city

--Japan Population
select sum(population)
from city
where countrycode = 'jpn';

--Population Density Difference
select max(population) - min(population)
from city

--The Blunder
select ceil(avg(salary)- avg(replace(salary, '0', '')))
from employees

--Top Earners
select max(months * salary), count(*)
from employee
where months * salary = (select max(months * salary) from employee)

--Population Census 
select sum(city.population)
from city
join country
on country.code = city.countrycode
where country.continent = 'Asia';
--Additoional Solution
select sum(population)
from city
join
(select code
from country
where continent = 'Asia') as A
on A.code = city.countrycode

--African Cities
select name
from city
join
(select code
from country
where continent = 'Africa') as A
on A.code = city.countrycode
--Additional Solution
select city.name
from city
join
country
on country.code = city.countrycode
where country.continent = 'Africa'

--Average Population of Each Continent
select C.continent, floor(avg(city.population))
from city
join
(select code, continent
from 
country) as C
on C.code = city.countrycode
group by C.continent;
--Additional Solution
select country.continent, floor(avg(city.population))
from city
join
country
on country.code = city.countrycode
group by country.continent;

--The Report
select if(grade < 8, null, name), grade, marks
from students 
join grades
where students.marks between min_mark and max_mark
order by grade desc, name

--Top Competitors
select hackers.hacker_id, hackers.name
from hackers
join
submissions
on submissions.hacker_id = hackers.hacker_id
join
challenges
on challenges.challenge_id = submissions.challenge_id
join
difficulty
on difficulty.difficulty_level = challenges.difficulty_level
where difficulty.score = submissions.score
group by hackers.hacker_id, hackers.name
having count(hackers.hacker_id) > 1
order by count(hackers.hacker_id) desc, hackers.hacker_id asc

--Ollivander's Inventory
select wands.id, wands_property.age, wands.coins_needed, wands.power
from wands
join
wands_property
on wands_property.code = wands.code
where wands_property.is_evil != 1 and 
wands.coins_needed = (select min(coins_needed) from wands as min_coins
join
wands_property as wp
on min_coins.code = wp.code
where min_coins.power = wands.power
and
wp.age = wands_property.age)
order by wands.power desc, wands_property.age desc

--Challenges
select c.hacker_id, h.name, count(c.challenge_id) as count_challenges
from challenges c 
JOIN
hackers h 
on h.hacker_id = c.hacker_id
group by hacker_id, name
having
count_challenges = (select max(mx_table.counter)
from (
select hacker_id, count(challenge_id) as counter 
from challenges
group by hacker_id) as mx_table)
OR 
count_challenges in (select only_one.counter
from (
select hacker_id, count(challenge_id) as counter 
from challenges
group by hacker_id) as only_one
group by only_one.counter
having count(only_one.counter) = 1)
order by count_challenges desc, hacker_id

--Contest Leaderboard
select h.hacker_id as id, name, sum(m_score) as total_score
from
hackers as h 
join
(select hacker_id, max(score) as m_score from submissions
group by hacker_id, challenge_id) as max_score
on h.hacker_id = max_score.hacker_id
group by id, name
having total_score != 0
order by total_score desc, id asc

--Interviews
select cont.contest_id, cont.hacker_id, cont.name, sum(s_stats.total_submissions) as t_subs, 
sum(s_stats.total_accepted_submissions) as ta_subs, 
sum(v_stats.total_views) as tot_v, sum(v_stats.total_unique_views) as tot_uv
from contests as cont
join
colleges as coll
on coll.contest_id = cont.contest_id
join
challenges as chall
on chall.college_id = coll.college_id
left join
(select challenge_id, sum(total_views) as total_views, sum(total_unique_views) as total_unique_views
from view_stats
group by challenge_id) as v_stats
on v_stats.challenge_id = chall.challenge_id
left join
(select challenge_id, sum(total_submissions) as total_submissions,
sum(total_accepted_submissions) as total_accepted_submissions
from submission_stats
group by challenge_id) as s_stats
on s_stats.challenge_id = chall.challenge_id
group by contest_id, hacker_id, name
having (t_subs + ta_subs +
tot_v + tot_uv) != 0
order by cont.contest_id, cont.hacker_id, cont.name

--Draw The Triangle 1
DELIMITER //
CREATE PROCEDURE while_loop(number INT)
BEGIN
 
  WHILE number > 0 DO
  SELECT REPEAT("* ",number);
  SET number = number - 1;
  END WHILE;
 
END //
DELIMITER ;

--Draw The Triangle 2
DELIMITER //
CREATE PROCEDURE while_loop()
BEGIN
  declare number int default 1;
  WHILE number < 21 DO
  SELECT REPEAT("* ",number);
  SET number = number + 1;
  END WHILE;
 
END //
DELIMITER ;

--Print Prime Numbers
with recursive tblnums
as (
    select 2 as nums
    union all
    select nums+1 
    from tblnums
    where nums<1000)
    
select group_concat(tt.nums order by tt.nums separator '&')  as nums
from tblnums tt
where not exists 
    -- the num should not be divisible by any number less than it
    ( select 1 from tblnums t2 
    where t2.nums <= tt.nums/2 and mod(tt.nums,t2.nums)=0) 


































