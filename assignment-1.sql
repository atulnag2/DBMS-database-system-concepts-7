-- Write queries in SQL, on the University schema, to answer each of the following questions:

-- 1. Find the names of all the instructors from Biology department

-- 2. Find the names of courses in Computer science department which have 3 credits

-- 3. For the student with ID 12345 (or any other value), show all course_id and title of all courses registered for by the student.

-- 4. As above, but show the total number of credits for such courses (taken by that student). Don't display the tot_creds value from the student table, you should use SQL aggregation on courses taken by the student.

-- 5. As above, but display the total credits for each of the students, along with the ID of the student; don't bother about the name of the student. (Don't bother about students who have not registered for any course, they can be omitted)

-- 6. Find the names of all students who have taken any Comp. Sci. course ever (there should be no duplicate names)

-- 7. Display the IDs of all instructors who have never taught a couse (Notesad1) Oracle uses the keyword minus in place of except; (2) interpret "taught" as "taught or is scheduled to teach")

-- 8. As above, but display the names of the instructors also, not just the IDs.

-- 9. You need to create a movie database. Create three tables, one for actors(AID, name), one for movies(MID, title) and one for actor_role(MID, AID, rolename). Use appropriate data types for each of the attributes, and add appropriate primary/foreign key constraints.

-- 10. Insert data to the above tables (approx 3 to 6 rows in each table), including data for actor "Charlie Chaplin", and for yourself (using your roll number as ID).

-- 11. Write a query to list all movies in which actor "Charlie Chaplin" has acted, along with the number of roles he had in that movie.

-- 12. Write a query to list all actors who have not acted in any movie

-- 13. List names of actors, along with titles of movies they have acted in. If they have not acted in any movie, show the movie title as null. (Do not use SQL outerjoin syntax here, write it from scratch.)
