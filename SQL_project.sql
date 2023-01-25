use ig_clone ;

/* 1. Create an ER diagram or draw a schema for  the given database./*

I have created an ER diagram which contains 7 tables ig_clone database. 
Cardinality:
one to one  - None of the tables establishing one to one relationship
one to many - Tables that are maintaining one to many relationship are:
			  users-follows,users-likes,users-photo,users-comments,photos-comments,photos-phototags,photos-likes,tags-phototags
many to many -Tables that are maintaining one to many relationship are:
              photos-tags(junction table :photo_tags)
              user-photos(junction table :likes)
Cardinality between Tables  in solid lines represent the Stong Relationship &
dotted lines represent the weak Relationship between them .
       
---------------------------------------------

/* 2. We want to reward the user who has been around the longest, Find the 5 oldest users./*

select * from users
group by id
order by created_at desc limit 5;
---------------------------------------------

/* 3. To understand when to run the ad campaign, figure out the day of the week most users register on? /*

select date_format(created_at,'%W') as 'day_of_the_week' , count(*) as 'total_registration' from users
group by day_of_the_week
order by total_registration desc limit 3;
-----------------------------------------------

/* 4. To target inactive users in an email ad campaign, find the users who have never posted a photo./*

select u.id,u.username,p.id as 'photo_id' from users u
left join photos p on u.id=p.user_id
where p.id  IS NULL;
-----------------------------------------------

/* 5. Suppose you are running a contest to find out who got the most likes on a photo. Find out who won?/*

select u.username,p.id as 'photo_id',p.image_url ,count(*) as 'most_likes' from likes l
inner join users u  on l.user_id=u.id
inner join photos p on l.photo_id=p.id
group by photo_id
order by most_likes desc limit 1;
------------------------------------------

/* 6. The investors want to know how many times does the average user post./*

select round(((select count(*) from photos) / (select count(*) from users )),2) as 'average' ;
--------------------------------------------------

/* 7. A brand wants to know which hashtag to use on a post, and find the top 5 most used hashtags./*

select t.id,t.tag_name,count(t.tag_name ) as 'most_used_hashtags' from photo_tags pt 
inner join tags t on pt.tag_id = t.id
group by t.id
order by  most_used_hashtags desc limit 5; 
------------------------------------------------------                       

/* 8. To find out if there are bots, find users who have liked every single photo on the site./*

select u.id,u.username,count(u.id)  as 'total_likes_by_user'   from likes l 
inner join users u on l.user_id = u.id
group by u.id
having total_likes_by_user = ( select count(*) from photos );
------------------------------------------------------------

/* 9. To know who the celebrities are, find users who have never commented on a photo./*

select u.id,u.username,c.comment_text from users u
left join comments c on u.id = c.user_id
where c.id is null;
---------------------------------

/* 10. Now it's time to find both of them together, find the users who have never commented on any photo or have commented on every photo./*

select tableA.never_commented_user , tableB.always_commented_user from 

(select count(*) as 'never_commented_user' from(select u.id,u.username,c.comment_text from users u
left join comments c on u.id = c.user_id
where c.id is null) as total_number_of_users_without_comments
) as tableA

JOIN

(select count(*) as 'always_commented_user' from
(select u.id,u.username,c.comment_text from users u
left join comments c on u.id = c.user_id
where c.id is not null) as total_number_users_with_comments
)as tableB

