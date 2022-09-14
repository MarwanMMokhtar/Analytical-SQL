/*

1. Select the userId of the longest session duration using time_stamp column.

2. For each song in this session Calculate the count of songs that the user played during 2 hours interval (1 hour before and 1 hour after)
    Hint: to convert epoch time to human readable timestamp use:
        timezone ( your timezone ex:' America / New_york ' ,  to_timestamp ( epoch_time / 1000 ) ).

*/

---------1.
select sessionid , session_duration 
from ( select sessionid , session_duration , rank() over (order by session_duration desc) rank
        from ( select distinct sessionid , sum (ts) over (partition by sessionid) session_duration
            from songs_events order by sessionid ) as tap ) as tap
where rank = 1;

---------2.
select distinct song , time ,
        count(song) over(partition by sessionid order by time range between
                         interval '1' hour preceding and interval '1' hour following) count
from (select * , timezone('Egypt' , to_timestamp(timestamp/1000)) as time
      from events) as tap
order by count desc , song;