/*
Assignment:
Mini Case Study:
select the most popular client_id  based on a count of the number of users who have at least 50% of their events from the following list:
    ‘video call received’, ‘video call sent’, ‘voice call received’, ‘voice call sent’.

*/

select *
from ( select event_type , user_id , client_id , count ( user_id ) ,
        percent_rank () over ( partition by event_type order by count ( event_type ) ) *100 as rank
        from msevents
        group by event_type , user_id , client_id ) as tab
where rank >= 50
order by client_id desc
limit 1;