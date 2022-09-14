/*

1- Rank users according to the number of distinct songs they played.
    If two users shared the same counts, they should have the same rank.
    
2- Rank users according to the number of distinct songs they played.
    If two users shared the same counts, each user should have his/her own number.
    
3- Find the next song a user listened to during the session.
    PS: for the last song in the session print "No Next" .
    
4- Select the third highest userid who listened to paid songs.

5- Select the user, session, first song and last song played per session.

*/

-------1.
select userid , count (distinct song) ,
        dense_rank() over ( order by count (distinct song) desc ) as rank
from songs_events
group by userid;

-------2.
select userid , firstname , count (distinct song) ,
        row_number() over ( order by count (distinct song) desc ) as rank
from songs_events
group by userid , firstname;

-------3.
select userid , sessionid , ts , song ,
        lead(song , 1 , 'NoNext') over (partition by sessionid order by ts desc) as Next_Song
from songs_events
order by userid , sessionid , ts;

-------4.
select userid , firstname
from (select userid , firstname , count(distinct song) ,
      rank() over (order by count(distinct song) desc) as rank
      from songs_events
      where level = 'paid'
      group by userid , firstname
      order by rank) as tab
where rank = 3;

-------5.
select userid , sessionid , song ,
        first_value(song) over (partition by sessionid order by ts) as First_Song ,
        first_value(song) over (partition by sessionid order by ts desc) as Last_Song
from songs_events
where song is not null
order by userid , sessionid , ts;