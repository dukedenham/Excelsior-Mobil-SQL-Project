/*
Project 1: Excelsior Mobile Project
Duke Denham
*/

Use [21WQ_BUAN4210_Lloyd_ExcelsiorMobile]

---Report Questions With Visualization---
--1--
--A

--This query returns the full name, minutes used, data used, texts used, and bill total for all subscribers. This is done by using an implicit inner join to
--connect the Subsriber, Last Month Usage, and Bill tables together by MIN since all tables have necessary information for the query. The Concat() and trim functions 
--are also used to combine the first and last names together into one column. Lastly, results are ordered by full names.

Select Concat(Rtrim(S.FirstName),' ',Ltrim(S.LastName)) as 'Full Name', LMU.Minutes, LMU.DataInMB, LMU.Texts, B.Total
From Subscriber as S, LastMonthUsage as LMU, Bill as B
Where S.MIN = LMU.MIN and LMU.MIN = B.MIN
Order by Concat(Rtrim(S.FirstName),' ',Ltrim(S.LastName));

--B

--This query returns the average minutes used, average data used, average texts used, and average bill totals of subscribers in each city. This is done using
--implicit inner joins, a 'Group by' clause to group all subcribers by city and find the average within each city rather than the average for all subcribers,
--and the Avg() function to find the averages.

Select S.City, Avg(LMU.Minutes) as 'Average Minutes', Avg(LMU.DataInMB) as 'Average Data Usage', Avg(LMU.Texts) as 'Average Texts', Avg(B.Total) as 'Average Bill Total'
From Subscriber as S, LastMonthUsage as LMU, Bill as B
Where S.MIN = LMU.MIN and LMU.MIN = B.MIN
Group by S.City
Order by S.City;

--C

--This query returns the sum of minutes used, data used, texts used, and bill totals of subscribers in each city. This is done using the exact methods as 1B,
--except the Sum() function is used instead.

Select S.City, Sum(LMU.Minutes) as 'Total Minutes', Sum(LMU.DataInMB) as 'Total Data Usage', Sum(LMU.Texts) as 'Total Texts', Sum(B.Total) as 'Total Bill Totals'
From Subscriber as S, LastMonthUsage as LMU, Bill as B
Where S.MIN = LMU.MIN and LMU.MIN = B.MIN
Group by S.City
Order by S.City;

--D

--This query returns the average minutes used, average data used, average texts used, and average bill totals of subscribers for each mobile plan. This is done
--with similar methods from previous problems, except the subsribers are grouped by plan name instead to find the averages for each plan.

Select S.PlanName, Avg(LMU.Minutes) as 'Average Minutes', Avg(LMU.DataInMB) as 'Average Data Usage', Avg(LMU.Texts) as 'Average Texts', Avg(B.Total) as 'Average Bill Total'
From Subscriber as S, LastMonthUsage as LMU, Bill as B
Where S.MIN = LMU.MIN and LMU.MIN = B.MIN
Group by S.PlanName
Order by S.PlanName;

--E

--This query returns the sum of minutes used, data used, texts used, and bill totals of subscribers for each mobile plan. This is with the same methods as previous
--problems: implicitly inner joining the Subcriber, Last Month Usage, and Bill tables, grouping by plan name, and using the Sum() function.

Select S.PlanName, Sum(LMU.Minutes) as 'Total Minutes', Sum(LMU.DataInMB) as 'Total Data Usage', Sum(LMU.Texts) as 'Total Texts', Sum(B.Total) as 'Total Bill Totals'
From Subscriber as S, LastMonthUsage as LMU, Bill as B
Where S.MIN = LMU.MIN and LMU.MIN = B.MIN
Group by S.PlanName
Order by S.PlanName;

---Report Questions Without Visualization---
--1--
--A

--This query returns the top 2 cities with the most customers in it. This is done by grouping all subscribers by city,
--counting how many subscribers are in each city, ordering the cities from most to least subscribers,
--then returning only the top 2 cities with the most subscribers.

Select Top 2 City
From Subscriber
Group by City
Order by Count(MIN) DESC, City;

--B

--This query returns the 3 cities with the least number of customers in it. This is done using the same process as 1A,
--except the results are ordered from least to most instead, and the query returns the top 3 instead of top 2.

Select Top 3 City
From Subscriber
Group by City
Order by Count(MIN) ASC, City;

--C

--This query returns all plans ordered from most to least used by subscribers using similar methods from 1A and 1B.

Select PlanName
From Subscriber
Group by PlanName
Order by Count(MIN) DESC;

--2--
--A

--This query returns all phone types and the number of customers that use each type of device available.
--This is done by grouping all subscribers by their phone type, counting how many use the type, then ordering it from
--most to least used phone type.

Select Type, Count(IMEI) as 'Number of Customers'
From Device
Group by Type
Order by Count(IMEI) DESC;

--B

--This query returns the first and last names of all customers using Apple, the least used phone type. This is done
--by joining the Subcriber, DirNums, and Device tables together to link phone types to names. Then, results are limited
--only to people with the Apple type and the first and last names are concatenated together.

Select Concat(Rtrim(S.FirstName),' ',Ltrim(S.LastName)) as 'Names of Customers With Apple'
From Subscriber as S, DirNums as DN, Device as D
Where S.MDN = DN.MDN and DN.IMEI = D.IMEI
and D.Type = 'Apple'
Order by 'Names of Customers With Apple';

--C

--This query returns customer names and year of phones only if their phone is older than 2018. This is done with the
--same method as 2B except results are limited to phones older than 2018 now and it links to the release year.

Select Concat(Rtrim(S.FirstName),' ',Rtrim(S.LastName)) as 'Names of Customers With Phones Older Than 2018', YearReleased
From Subscriber as S, DirNums as DN, Device as D
Where S.MDN = DN.MDN and DN.IMEI = D.IMEI
and D.YearReleased < 2018;

--3--

--This query returns the one city that's within the top 3 cities with the most data usage but also has no subscribers in it with unlimited mobile plans.
--This is first accomplished by limiting rows in the Subscriber table to subscribers that are in the top 3 data using cities using a subquery. Next, rows are
--limited only to subscribers that are in cities where no one has the UnlPrime mobile plan. This is done by using the 'not in' syntax and a subquery. The same
--proccess is repeated for the other two unlimited plans. After this, the only subscribers that are left are for the city of Bellevue.

Select Distinct City
From Subscriber
Where City in
	(Select Top 3 City
	From Subscriber as S, LastMonthUsage as LMU
	Where S.MIN = LMU.MIN
	Group by City
	Order by Sum(DataInMB) DESC)
And City not in
	(Select Distinct City
	From Subscriber
	Where PlanName = 'UnlPrime')
And City not in
	(Select Distinct City
	From Subscriber
	Where PlanName = 'UnlBasic')
And City not in
	(Select Distinct City
	From Subscriber
	Where PlanName = 'UnlSuper');

--4--
--A

--This query returns the first and last name of the customer with the most expensive bill. This is done using similar methods from previous problems such as
--linking the Subscriber and Bill tables, ordering by bill total in descending order, returning only the top row, and concatenating the first and last names.

Select Top 1 Concat(Rtrim(S.FirstName),' ',Rtrim(S.LastName)) as 'Customer With Most Expensive Bill'
From Subscriber as S, Bill as B
Where S.MIN = B.MIN
Order by B.Total DESC;

--B

--This query returns the plan name that brings in the most revenue, or in other words, the one with the highest aggregate bill total for subsribers. This is
--done using similar methods as before: linking the Subrcriber and Bill tables, grouping rows by plan name, ordering rows by the total sum of bill totals for
--each plan in descending order, then only returning the top result.

Select Top 1 S.PlanName
From Subscriber as S, Bill as B
Where S.MIN = B.MIN
Group by S.PlanName
Order by Sum(B.Total) DESC;

--5--
--A

--This query returns the area code with that uses the most minutes. This query uses similar methods as before, except this time, the Left() function is used
--to return only the first three digits of the phone numbers (the area code) and group rows by area code to find the total sum of minutes that each area code uses.

Select Top 1 Left(S.MDN, 3) as 'Area Code', Sum(LMU.Minutes) as 'Total Minutes Used'
From Subscriber as S, LastMonthUsage as LMU
Where S.MIN = LMU.MIN
Group by Left(S.MDN, 3)
Order by Sum(LMU.Minutes) DESC;

--B

--This query returns the cities with the largest difference between the user with the most minutes and the user with the least minutes in that city. Specifically,
--it returns only cities where the biggest minute user has to be using more than 700 minutes, and the smallest minute user has to be using less than 200.
--This is done using a Having clause that specifies the city group needs to meet these maximum/minimum requirements to be counted. Lastly, the results are ordered
--by the biggest difference to smallest difference (biggest (maximum minutes-minimum minutes) to smallest).

Select S.City
From Subscriber as S, LastMonthUsage as LMU
Where S.MIN = LMU.MIN
Group by S.City
Having Max(LMU.Minutes) > 700 and Min(LMU.Minutes) < 200
Order by Max(LMU.Minutes)-Min(LMU.Minutes) DESC;