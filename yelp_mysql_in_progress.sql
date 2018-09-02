To get the unique count of user_id in the table: friend
mysql> SELECT COUNT(DISTINCT user_id) FROM friend;
+-------------------------+
| COUNT(DISTINCT user_id) |
+-------------------------+
|                  760008 |
+-------------------------+
1 row in set (52.51 sec)


SELECT COUNT(neighborhood) FROM business;
+---------------------+
| COUNT(neighborhood) |
+---------------------+
|              174567 |
+---------------------+
1 row in set (0.11 sec)

SELECT COUNT(DISTINCT neighborhood) FROM business;
+------------------------------+
| COUNT(DISTINCT neighborhood) |
+------------------------------+
|                          409 |
+------------------------------+
1 row in set (0.13 sec)


The number of empty neighborhood in the table: business:
SELECT COUNT(*) FROM business WHERE neighborhood='';
+----------+
| COUNT(*) |
+----------+
|   106552 |
+----------+


To check where there are empty records in the table:business where either latitude = '' or longitude = '': 
SELECT COUNT(*) FROM business WHERE latitude='' OR longitude='';
+----------+
| COUNT(*) |
+----------+
|        0 |
+----------+
1 row in set (0.12 sec)



The following two queries are to check the count of unique latitudes when city='Richmond Hill'. As can be seen from below there are 395 unique
latitudes in the city. But the count of distinct neighborhoods is only 2 and that means that there are 393 missing neighborhoods in the city.

SELECT COUNT(DISTINCT latitude) FROM business WHERE city='Richmond Hill';
+--------------------------+
| COUNT(DISTINCT latitude) |
+--------------------------+
|                      395 |
+--------------------------+
1 row in set (0.07 sec)

mysql> SELECT COUNT(DISTINCT neighborhood) FROM business WHERE city='Richmond Hill';
+------------------------------+
| COUNT(DISTINCT neighborhood) |
+------------------------------+
|                            2 |
+------------------------------+
1 row in set (0.09 sec)


MYSQL counts empty records too: example: in the below query, as can be seen, there are only two type of neighborhoods: one is empty and 
another one is Brown's Corners in the city: Richmond Hill

SELECT DISTINCT neighborhood FROM business WHERE city='Richmond Hill';
+-----------------+
| neighborhood    |
+-----------------+
|                 |
| Brown's Corners |
+-----------------+
2 rows in set (0.12 sec)


There are repetetive latitude/longitude in the city='Richmond Hill'. As there are 888 latitude in total but only 395 are unique.
SELECT COUNT(latitude) FROM business WHERE city='Richmond Hill';
+-----------------+
| COUNT(latitude) |
+-----------------+
|             888 |
+-----------------+
1 row in set (0.06 sec)

In order to pull out latitude and longitude from the Richmond Hill when neighborhood is empty. Tried with Null but it did not work. but 
neighborhood='' works.
SELECT latitude AS lat, longitude AS longt FROM business WHERE city='Richmond Hill' AND neighborhood=Null;


To get the latitude and longitude from the city when neighborhood is empty. The idea is to get neighborhood details for these latitude and longitude, somehow!
SELECT latitude AS lat, longitude AS longt FROM business WHERE city='Richmond Hill' AND neighborhood='';

So there are only two non-null values in the neighborhood and the they belong to the neighborhood:"Brown's Corners"
SELECT latitude AS lat, longitude AS longt FROM business WHERE city='Richmond Hill' AND neighborhood !='';
+---------+----------+
| lat     | longt    |
+---------+----------+
| 43.8498 | -79.3477 |
| 43.8535 | -79.3371 |
+---------+----------+
2 rows in set (0.10 sec)


Is there any empty address in the table: business and if there is then are there latitude available for those addresses?
SELECT COUNT(latitude) FROM business WHERE city='Richmond Hill' AND address='';                        
+-----------------+
| COUNT(latitude) |
+-----------------+
|               6 |
+-----------------+

There is only one postal_code missing:
SELECT COUNT(longitude) FROM business WHERE city='Richmond Hill' AND postal_code='';

SELECT COUNT(DISTINCT name) FROM business WHERE city='Richmond Hill' and state='ON';
+----------------------+
| COUNT(DISTINCT name) |
+----------------------+
|                  821 |
+----------------------+

Trying to understand what does business_id in the table:photo mean? 
SELECT business_id FROM photo LIMIT 2\G;
*************************** 1. row ***************************
business_id: XQ0RIDqgnkXueL6y1CY3Cg
*************************** 2. row ***************************
business_id: XIg92ukZJn_1aiNx0OmusQ


Trying to understand what does id in the table:photo mean? looks like the id in the table:photo is equivalent to the id in the table:business. Meaning an id to tag
the photos with:
SELECT id FROM photo LIMIT 2\G;
*************************** 1. row ***************************
id: ---SnSf4OfUFfJmCxw1DZA
*************************** 2. row ***************************
id: --0uqWanwN31OkuuwJ1zjQ 

The business_id from table:checkin is equivalent to the business_id in the table:category and also equal to the business_id in the table:attribute
SELECT business_id FROM checkin LIMIT 2\G;
*************************** 1. row ***************************
business_id: 7KPBkxAOEtb3QeIL9PEErg
*************************** 2. row ***************************
business_id: 7KPBkxAOEtb3QeIL9PEErg



To find distinct categories in order to understand whether the neighborhood idea would work or not
SELECT COUNT(DISTINCT category) FROM category;
+--------------------------+
| COUNT(DISTINCT category) |
+--------------------------+
|                     1293 |
+--------------------------+

How many cities in the table:business have empty records? Answer: 1
SELECT * FROM business WHERE city=''\G;
*************************** 1. row ***************************
          id: Cr3LJ2sKGNKEYIAjmG7aCA
        name: Lululemon Athletica
neighborhood: New Town
     address: 57 George Street
        city: 
       state: EDH
 postal_code: EH2 2JG
    latitude: 55.9533
   longitude: -3.19933
       stars: 4
review_count: 5
     is_open: 1

How many distinct states are in the table:business?

SELECT COUNT(DISTINCT state) FROM business;
+-----------------------+
| COUNT(DISTINCT state) |
+-----------------------+
|                    68 |
+-----------------------+

What type of entries does the table: checkin have?

SELECT * FROM checkin LIMIT 2\G;
*************************** 1. row ***************************
         id: 1
business_id: 7KPBkxAOEtb3QeIL9PEErg
       date: Thursday-21:00
      count: 4
*************************** 2. row ***************************
         id: 2
business_id: 7KPBkxAOEtb3QeIL9PEErg
       date: Thursday-1:00
      count: 1

SELECT business_id,GROUP_CONCAT(hours) AS num_hours, COUNT(1) AS num_values FROM hours GROUP BY business_id LIMIT 5\G;
*************************** 1. row ***************************
business_id: --6MefnULPED_I942VcFNA
  num_hours: Monday|11:00-22:30,Tuesday|11:00-22:30,Friday|11:00-22:30,Wednesday|11:00-22:30,Thursday|11:00-22:30,Sunday|11:00-22:30,Saturday|11:00-22:30
 num_values: 7
*************************** 2. row ***************************
business_id: --7zmmkVg-IMGaXbuVd0SQ
  num_hours: Monday|16:00-22:00,Tuesday|16:00-22:00,Friday|12:00-23:00,Wednesday|16:00-22:00,Thursday|16:00-22:00,Sunday|12:00-20:00,Saturday|12:00-23:00
 num_values: 7
*************************** 3. row ***************************
business_id: --8LPVSo5i0Oo61X01sV9A
  num_hours: Friday|8:30-16:30,Tuesday|8:30-16:30,Thursday|8:30-16:30,Wednesday|8:30-16:30,Monday|8:30-16:30
 num_values: 5
*************************** 4. row ***************************
business_id: --9e1ONYQuAa-CB_Rrw7Tw
  num_hours: Monday|11:30-14:00,Tuesday|11:30-14:00,Friday|11:30-14:00,Wednesday|11:30-14:00,Thursday|11:30-14:00,Sunday|11:30-14:00,Saturday|11:30-14:00
 num_values: 7
*************************** 5. row ***************************
business_id: --ab39IjZR_xUf81WyTyHg
  num_hours: Monday|10:00-21:00,Tuesday|10:00-21:00,Friday|10:00-21:00,Wednesday|10:00-21:00,Thursday|10:00-21:00,Sunday|11:00-18:00,Saturday|10:00-21:00
 num_values: 7


 GROUP_CONCAT - example:
 SELECT * FROM category LEFT JOIN (SELECT checkin.business_id AS bd, GROUP_CONCAT(checkin.date) FROM checkin GROUP BY bd) AS t1 ON category.business_id = t1.bd LIMIT 5\G;
*************************** 1. row ***************************
                        id: 1
               business_id: FYWN1wneV18bWNgQjJ2GNg
                  category: Dentists
                        bd: FYWN1wneV18bWNgQjJ2GNg
GROUP_CONCAT(checkin.date): Wednesday-14:00,Wednesday-16:00,Wednesday-17:00,Wednesday-18:00,Wednesday-0:00,Wednesday-19:00,Wednesday-21:00,Wednesday-23:00,Wednesday-22:00,Friday-16:00,Friday-15:00,Friday-14:00,Friday-19:00,Friday-18:00,Thursday-22:00,Thursday-18:00,Thursday-16:00,Tuesday-18:00,Tuesday-16:00,Tuesday-14:00,Tuesday-20:00,Monday-14:00,Monday-18:00,Monday-17:00,Monday-23:00,Monday-21:00,Monday-20:00


SELECT hours.business_id AS bd1, GROUP_CONCAT(hours.hours) FROM hours GROUP BY bd1 LIMIT 2\G;
*************************** 1. row ***************************
                      bd1: --6MefnULPED_I942VcFNA
GROUP_CONCAT(hours.hours): Monday|11:00-22:30,Tuesday|11:00-22:30,Friday|11:00-22:30,Wednesday|11:00-22:30,Thursday|11:00-22:30,Sunday|11:00-22:30,Saturday|11:00-22:30

P.S.: should not leave space after GROUP_CONCAT and the field name. MYSQL throws an error!

Received this warning: Warning | 1260 | Row 164008 was cut by GROUP_CONCAT() when I tried to tried to run the following query:

SELECT * FROM category LEFT JOIN (SELECT checkin.business_id AS bd, GROUP_CONCAT(checkin.date) AS checkin_date FROM checkin GROUP BY bd) AS t1 ON category.business_id=t1.bd LEFT JOIN (SELECT hours.business_id AS bd1, GROUP_CONCAT(hours.hours) AS hour_det FROM hours GROUP BY bd1) AS t2 ON category.business_id=t2.bd1 LIMIT 3\G;
*************************** 1. row ***************************
          id: 1
 business_id: FYWN1wneV18bWNgQjJ2GNg
    category: Dentists
          bd: FYWN1wneV18bWNgQjJ2GNg
checkin_date: Wednesday-14:00,Wednesday-16:00,Wednesday-17:00,Wednesday-18:00,Wednesday-0:00,Wednesday-19:00,Wednesday-21:00,Wednesday-23:00,Wednesday-22:00,Friday-16:00,Friday-15:00,Friday-14:00,Friday-19:00,Friday-18:00,Thursday-22:00,Thursday-18:00,Thursday-16:00,Tuesday-18:00,Tuesday-16:00,Tuesday-14:00,Tuesday-20:00,Monday-14:00,Monday-18:00,Monday-17:00,Monday-23:00,Monday-21:00,Monday-20:00
         bd1: FYWN1wneV18bWNgQjJ2GNg
    hour_det: Friday|7:30-17:00,Tuesday|7:30-17:00,Thursday|7:30-17:00,Wednesday|7:30-17:00,Monday|7:30-17:00

SHOW WARNINGS; #to display warnings in mysql

I exported the result of a query into a csv file using the command:
SELECT * FROM table_name INTO OUTFILE '/Users/user_name/whichever_folder or even Desktop/file_name.csv' 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n';


SELECT state, GROUP_CONCAT(latitude), GROUP_CONCAT(longitude), GROUP_CONCAT(city) AS num_cities FROM business GROUP BY state LIMIT 10\G;

To export query result as a csv:
SELECT * FROM (SELECT state, GROUP_CONCAT(latitude) AS latitude, GROUP_CONCAT(longitude) AS longitude, GROUP_CONCAT(city) AS num_cities FROM business GROUP BY state LIMIT 10\G;
) INTO OUTFILE ''
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';

Not sure whether Distinct in the following query would be an ideal solution because it would be rather hard to pair the latitude and longitude
after exporting the query result into a csv:
SELECT city, GROUP_CONCAT(DISTINCT latitude) AS lat, GROUP_CONCAT(DISTINCT longitude) AS longt FROM business WHERE state="AZ" GROUP BY city ORDER BY city LIMIT 5\G
*************************** 1. row ***************************
 city: Ahwahtukee
  lat: 33.3427
longt: -111.984
*************************** 2. row ***************************
 city: Ahwatukee
  lat: 33.3045,33.3051,33.3053,33.3055,33.3123,33.3168,33.3176,33.3181,33.3201,33.3205,33.3307,33.3337,33.3427,33.3479,33.3486
longt: -112.036,-112.004,-112,-111.995,-111.993,-111.991,-111.984,-111.981,-111.979,-111.978,-111.977,-111.975
*************************** 3. row ***************************
 city: Ahwatukee Foothills Village
  lat: 33.3187
longt: -112.068
*************************** 4. row ***************************
 city: Anthem
  lat: 33.8023,33.8432,33.8435,33.844,33.8441,33.8444,33.8448,33.8489,33.8543,33.8546,33.858,33.8581,33.8589,33.861,33.864,33.8641,33.8644,33.8645,33.8646,33.8648,33.8649,33.865,33.8654,33.8655,33.8657,33.8658,33.8659,33.866,33.8663,33.8666,33.8667,33.8668,33.8669,33.8674,33.8675,33.8676,33.8686,33.8687,33.8688,33.8689,33.8693,33.8696,33.8697,33.8702,33.8705,33.8707,33.873,33.8739,33.874,33.8741,33.8754,33.876
longt: -112.155,-112.154,-112.152,-112.151,-112.15,-112.149,-112.148,-112.147,-112.142,-112.139,-112.137,-112.136,-112.135,-112.134,-112.129,-112.125,-112.112,-112.106,-112.099,-112.089
*************************** 5. row ***************************
 city: Arrowhead
  lat: 33.6398
longt: -112.213


So planning to group by the latitudes and longitudes by city and use a where condition to filter per state
SELECT city, GROUP_CONCAT(latitude) AS lat, GROUP_CONCAT(longitude) AS longt FROM business WHERE state="AZ" GROUP BY city ORDER BY city LIMIT 5\G
*************************** 1. row ***************************
 city: Ahwahtukee
  lat: 33.3427
longt: -111.984
*************************** 2. row ***************************
 city: Ahwatukee
  lat: 33.3337,33.3181,33.3427,33.3051,33.3045,33.3307,33.3168,33.3205,33.3201,33.3123,33.3486,33.3176,33.3479,33.3427,33.3053,33.3055
longt: -111.978,-111.984,-111.984,-111.991,-111.995,-111.979,-112.004,-111.977,-111.991,-112.036,-111.975,-111.981,-111.978,-111.984,-111.993,-112
*************************** 3. row ***************************
 city: Ahwatukee Foothills Village
  lat: 33.3187
longt: -112.068
*************************** 4. row ***************************
 city: Anthem
  lat: 33.866,33.8648,33.866,33.8645,33.8659,33.8546,33.844,33.8688,33.8658,33.8689,33.8641,33.8645,33.8655,33.8666,33.8655,33.8754,33.866,33.8489,33.8581,33.8589,33.8687,33.8644,33.874,33.8702,33.8666,33.8696,33.8669,33.8581,33.8663,33.864,33.8674,33.8688,33.865,33.8689,33.8739,33.8444,33.873,33.8657,33.8448,33.8581,33.865,33.8666,33.8668,33.8676,33.8739,33.8645,33.8687,33.8687,33.8707,33.8697,33.8658,33.8686,33.8705,33.8667,33.8693,33.8644,33.876,33.8674,33.865,33.8689,33.8675,33.8649,33.8648,33.8702,33.8646,33.8676,33.8654,33.8667,33.8741,33.8644,33.866,33.8543,33.861,33.858,33.8739,33.8649,33.8441,33.865,33.864,33.8432,33.8705,33.8663,33.8023,33.874,33.8435,33.8435,33.8432
longt: -112.134,-112.134,-112.137,-112.149,-112.135,-112.125,-112.136,-112.139,-112.139,-112.15,-112.136,-112.137,-112.137,-112.142,-112.147,-112.151,-112.137,-112.099,-112.112,-112.112,-112.139,-112.142,-112.15,-112.151,-112.137,-112.139,-112.142,-112.112,-112.148,-112.139,-112.148,-112.139,-112.139,-112.15,-112.15,-112.136,-112.149,-112.15,-112.134,-112.112,-112.139,-112.147,-112.137,-112.148,-112.15,-112.134,-112.152,-112.139,-112.151,-112.155,-112.134,-112.148,-112.148,-112.142,-112.152,-112.142,-112.154,-112.148,-112.139,-112.15,-112.147,-112.139,-112.15,-112.151,-112.139,-112.148,-112.136,-112.142,-112.15,-112.142,-112.137,-112.125,-112.089,-112.112,-112.15,-112.139,-112.106,-112.139,-112.139,-112.135,-112.15,-112.147,-112.129,-112.15,-112.136,-112.135,-112.135
*************************** 5. row ***************************
 city: Arrowhead
  lat: 33.6398
longt: -112.213



SELECT * FROM(SELECT city, GROUP_CONCAT(id) AS business_id, GROUP_CONCAT(name) As business_name, GROUP_CONCAT(latitude) AS lat, GROUP_CONCAT(longitude) AS longt FROM business WHERE state="AZ" 
GROUP BY city ORDER BY city)t1 INTO OUTFILE ''
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';


SELECT COUNT(DISTINCT city) FROM business WHERE state="AZ";
+----------------------+
| COUNT(DISTINCT city) |
+----------------------+
|                   88 |
+----------------------+


To export the query result into a txt file:
SELECT * FROM(SELECT city, GROUP_CONCAT(id) AS business_id, GROUP_CONCAT(name) As business_name, GROUP_CONCAT(latitude) AS lat, 
GROUP_CONCAT(longitude) AS longt FROM business WHERE state="AZ" GROUP BY city ORDER BY city)t1 
INTO OUTFILE 'path to file' FIELDS TERMINATED BY '\t' ENCLOSED BY '"' LINES TERMINATED BY ';';

No quotations over field names:
CREATE TABLE dbscan_yelp(city VARCHAR(255), business_id VARCHAR(22), business_name VARCHAR(255),lat float, longt float);



INSERT INTO dbscan_yelp(city, business_id, business_name, lat, longt)
SELECT city, GROUP_CONCAT(id) AS business_id, GROUP_CONCAT(name) As business_name, GROUP_CONCAT(latitude) AS lat,
ROUP_CONCAT(longitude) AS longt FROM business WHERE state="AZ" GROUP BY city ORDER BY city;



received an error:1406 Data too long for column...
solved it using the command: SET @@global.sql_mode= ''; 
and restarted the terminal. it worked but issued warnings.

example:
Warning | 1265 | Data truncated for column 'business_id' at row 18
fixed the issue using the following command:
ALTER TABLE dbscan_yelp MODIFY business_id VARCHAR(34);
ALTER TABLE dbscan_yelp MODIFY business_name VARCHAR(300);



Warning | 1260 | Row 63 was cut by GROUP_CONCAT()

CREATE TABLE dbscan_yelp(city VARCHAR(255), business_id VARCHAR(22), business_name VARCHAR(255),lat DOUBLE, longt DOUBLE);



create index idx_state_city on business (city,state);


select id,latitude,longitude from business where city = 'Toronto' and state = 'ON' limit 10;
+------------------------+----------+-----------+
| id                     | latitude | longitude |
+------------------------+----------+-----------+
| --DaPTJW3-tB1vP-PfdTEg |  43.6778 |  -79.4447 |
| --kinfHwmtdjz03g8B8z8Q |  43.7055 |  -79.3887 |
| --SrzpvFLwP_YFwB_Cetow |  43.8068 |  -79.2889 |
| -03HVYxkeYWaafEpNJo1SA |   43.703 |  -79.3975 |
| -0aOudcaAyac0VJbMX-L1g |  43.7732 |  -79.4426 |
| -0CCHBui57tZ_1y_14X-5Q |  43.6626 |  -79.4234 |
| -0d-BfFSU0bwLcnMaGRxYw |  43.6594 |  -79.4379 |
| -0DwB6Swi349EKfbBAOF7A |  43.6637 |  -79.4178 |
| -0M3o2uWBnQZwd3hmfEwuw |  43.6448 |  -79.5219 |
| -0NhdsDJsdarxyDPR523ZQ |  43.6491 |  -79.3806 |
+------------------------+----------+-----------+


select state,city , count(*) from business group by 1,2 order by 3 desc limit 10;
+-------+------------+----------+
| state | city       | count(*) |
+-------+------------+----------+
| NV    | Las Vegas  |    26798 |
| AZ    | Phoenix    |    17213 |
| ON    | Toronto    |    17210 |
| NC    | Charlotte  |     8554 |
| AZ    | Scottsdale |     8227 |
| PA    | Pittsburgh |     6354 |
| QC    | Montréal   |     5972 |
| AZ    | Mesa       |     5871 |
| NV    | Henderson  |     4463 |
| AZ    | Tempe      |     4263 |
+-------+------------+----------+


So the idea is to create_index on state and city and export details including latitude and longitude and later wrangle them using Pandas



To connect to a database
USE DATABASE;

To look at the list of databases available
SHOW DATABASES;

To look at the list of tables in a database
SHOW TABLES;


To check the index details from a table
SHOW INDEX FROM table_name 


select state,city , count(*) from business group by 1,2 order by 3 desc limit 10;
+-------+------------+----------+
| state | city       | count(*) |
+-------+------------+----------+
| NV    | Las Vegas  |    26798 |
| AZ    | Phoenix    |    17213 |
| ON    | Toronto    |    17210 |
| NC    | Charlotte  |     8554 |
| AZ    | Scottsdale |     8227 |
| PA    | Pittsburgh |     6354 |
| QC    | Montréal   |     5972 |
| AZ    | Mesa       |     5871 |
| NV    | Henderson  |     4463 |
| AZ    | Tempe      |     4263 |
+-------+------------+----------+


SELECT * FROM(SELECT * FROM business WHERE state='AZ' ORDER BY city)t1
INTO OUTFILE '/Users/chidam/Desktop/AZ_cities.txt'
FIELDS TERMINATED BY '\t' ENCLOSED BY '"' LINES TERMINATED BY ';';


Contents of table: tip
SELECT * FROM tip LIMIT 2\G;
*************************** 1. row ***************************
         id: 1
    user_id: zcTZk7OG8ovAmh_fenH21g
business_id: tJRDll5yqpZwehenzE2cSg
       text: Get here early enough to have dinner.
       date: 2012-07-15 00:00:00
      likes: 0
*************************** 2. row ***************************
         id: 2
    user_id: ZcLKXikTHYOnYt5VYRO5sg
business_id: jH19V2I9fIslnNhDzPmdkA
       text: Great breakfast large portions and friendly waitress. I highly recommend it
       date: 2015-08-12 00:00:00
      likes: 0

Contents of table: category
SELECT * FROM category LIMIT 2\G;
*************************** 1. row ***************************
         id: 1
business_id: FYWN1wneV18bWNgQjJ2GNg
   category: Dentists
*************************** 2. row ***************************
         id: 2
business_id: FYWN1wneV18bWNgQjJ2GNg
   category: General Dentistry


Contents of table: checkin
SELECT * FROM checkin LIMIT 2\G;
*************************** 1. row ***************************
         id: 1
business_id: 7KPBkxAOEtb3QeIL9PEErg
       date: Thursday-21:00
      count: 4
*************************** 2. row ***************************
         id: 2
business_id: 7KPBkxAOEtb3QeIL9PEErg
       date: Thursday-1:00
      count: 1


Contents of table: review
SELECT * FROM review LIMIT 2\G;
*************************** 1. row ***************************
         id: ----X0BIDP9tA49U3RvdSQ
business_id: Ue6-WhXvI-_1xUIuapl0zQ
    user_id: gVmUR8rqUFdbSeZbsg6z_w
      stars: 4
       date: 2014-02-17 00:00:00
       text: Red, white and bleu salad was super yum and a great addition to the menu! This location was clean with great service and food served at just the right temps! Kids pizza is always a hit too with lots of great side dish options for the kiddos! When I'm on this side of town, this will definitely be a spot I'll hit up again!
     useful: 1
      funny: 0
       cool: 0
*************************** 2. row ***************************
         id: ---0hl58W-sjVTKi5LghGw
business_id: Ae4ABFarGMaI5lk1i98A0w
    user_id: Y6qylbHq8QJmaCRSlKdIog
      stars: 4
       date: 2016-07-24 00:00:00
       text: Ate the momos during the momo crawl.. Was the best of the lot so decided to eat at the restaurant and the mutton thali was equally good!!
     useful: 0
      funny: 0
       cool: 0




Contents of table: user
What does the average_stars in the table: user mean?

SELECT * FROM user LIMIT 2\G;
*************************** 1. row ***************************
                id: ---1lKK3aKOuomHnwAkAow
              name: Monera
      review_count: 246
     yelping_since: 2007-06-04 00:00:00
            useful: 67
             funny: 22
              cool: 9
              fans: 15
     average_stars: 3.96
    compliment_hot: 2
   compliment_more: 3
compliment_profile: 2
   compliment_cute: 1
   compliment_list: 0
   compliment_note: 5
  compliment_plain: 9
   compliment_cool: 9
  compliment_funny: 9
 compliment_writer: 9
 compliment_photos: 0
*************************** 2. row ***************************
                id: ---94vtJ_5o_nikEs6hUjg
              name: Joe
      review_count: 2
     yelping_since: 2016-05-27 00:00:00
            useful: 0
             funny: 0
              cool: 0
              fans: 0
     average_stars: 5
    compliment_hot: 0
   compliment_more: 0
compliment_profile: 0
   compliment_cute: 0
   compliment_list: 0
   compliment_note: 0
  compliment_plain: 0
   compliment_cool: 0
  compliment_funny: 0
 compliment_writer: 0
 compliment_photos: 0



Contents of table: friend
SELECT * FROM friend LIMIT 2\G;
*************************** 1. row ***************************
       id: 1
  user_id: oMy_rEb0UBEmMlu-zcxnoQ
friend_id: cvVMmlU1ouS3I5fhutaryQ
*************************** 2. row ***************************
       id: 2
  user_id: oMy_rEb0UBEmMlu-zcxnoQ
friend_id: nj6UZ8tdGo8YJ9lUMTVWNw

Contents of table: attribute
SELECT * FROM attribute LIMIT 2\G;
*************************** 1. row ***************************
         id: 1
business_id: FYWN1wneV18bWNgQjJ2GNg
       name: AcceptsInsurance
      value: 1
*************************** 2. row ***************************
         id: 2
business_id: FYWN1wneV18bWNgQjJ2GNg
       name: ByAppointmentOnly
      value: 1

To check whether there are any null texts in the review table:
SELECT COUNT(*) FROM review WHERE review.text=Null;
Answer:
+----------+
| COUNT(*) |
+----------+
|        0 |
+----------+
Looks like there no empty values in the text field of the review table.


Count the distinct values of the field: category from the table category
SELECT COUNT(DISTINCT category) FROM category;
+--------------------------+
| COUNT(DISTINCT category) |
+--------------------------+
|                     1293 |
+--------------------------+


Number of records after joining the tables: review and user on review.user_id and user.id
SELECT COUNT(*) FROM review JOIN user ON review.user_id=user.id;
+----------+
| COUNT(*) |
+----------+
|  5261669 |
+----------+


Number of records in the table: user
SELECT COUNT(*) FROM user;
+----------+
| COUNT(*) |
+----------+
|  1326101 |
+----------+


To check if there are any Null texts in review table
SELECT COUNT(*) FROM review JOIN user ON review.user_id=user.id WHERE review.text=Null;
+----------+
| COUNT(*) |
+----------+
|        0 |
+----------+

Tried the same using right join
SELECT COUNT(*) FROM review RIGHT JOIN user ON review.user_id=user.id WHERE review.text=Null;
+----------+
| COUNT(*) |
+----------+
|        0 |
+----------+

And tried the same using left join
SELECT COUNT(*) FROM review LEFT JOIN user ON review.user_id=user.id WHERE review.text=Null;
+----------+
| COUNT(*) |
+----------+
|        0 |
+----------+

To join four tables: review, user, category, photo
SELECT r.business_id, r.stars, r.text, r.user_id, u.review_count, u.yelping_since, u.average_stars, c.category, p.label, p.caption FROM user u 
LEFT JOIN review r ON u.id=r.user_id 
LEFT JOIN category c ON r.business_id=c.business_id 
LEFT JOIN photo p ON c.business_id=p.business_id LIMIT 3\G;
*************************** 1. row ***************************
  business_id: RESDUcs7fIiihp38-d6_6g
        stars: 5
         text: Loads of food to choose from, of all styles. It's all fresh and great quality. Customer service is impeccable.
      user_id: -dpf6ryw-EsMKN_fhaiMbA
 review_count: 3
yelping_since: 2016-01-17 00:00:00
average_stars: 4.33
     category: Sandwiches
        label: food
      caption: 
*************************** 2. row ***************************
  business_id: RESDUcs7fIiihp38-d6_6g
        stars: 5
         text: Loads of food to choose from, of all styles. It's all fresh and great quality. Customer service is impeccable.
      user_id: -dpf6ryw-EsMKN_fhaiMbA
 review_count: 3
yelping_since: 2016-01-17 00:00:00
average_stars: 4.33
     category: Buffets
        label: food
      caption: 
*************************** 3. row ***************************
  business_id: RESDUcs7fIiihp38-d6_6g
        stars: 5
         text: Loads of food to choose from, of all styles. It's all fresh and great quality. Customer service is impeccable.
      user_id: -dpf6ryw-EsMKN_fhaiMbA
 review_count: 3
yelping_since: 2016-01-17 00:00:00
average_stars: 4.33
     category: Restaurants
        label: food
      caption: 

3 rows in set (2 min 5.34 sec) - not sure how to take this time consumption to run the query-is it too long and not optimum?
maybe I should group_concatenate the categories in the table: category as it is possible that a business_id has many categories.
Please Note: once you close the session the table disappears so you have to recreate it again if you need to


To create a temporary table to get the categories group_concatenated using category.business_id:
CREATE TEMPORARY TABLE category_temp SELECT business_id, GROUP_CONCAT(category) FROM category GROUP BY business_id;


Checking few records in the temporary table: category_temp:
SELECT * FROM category_temp LIMIT 3\G;
*************************** 1. row ***************************
           business_id: --6MefnULPED_I942VcFNA
GROUP_CONCAT(category): Chinese,Restaurants
*************************** 2. row ***************************
           business_id: --7zmmkVg-IMGaXbuVd0SQ
GROUP_CONCAT(category): Food,Breweries
*************************** 3. row ***************************
           business_id: --8LPVSo5i0Oo61X01sV9A
GROUP_CONCAT(category): Orthopedists,Weight Loss Centers,Sports Medicine,Health & Medical,Doctors


SELECT * FROM attribute LIMIT 2\G;
*************************** 1. row ***************************
         id: 1
business_id: FYWN1wneV18bWNgQjJ2GNg
       name: AcceptsInsurance
      value: 1
*************************** 2. row ***************************
         id: 2
business_id: FYWN1wneV18bWNgQjJ2GNg
       name: ByAppointmentOnly
      value: 1


