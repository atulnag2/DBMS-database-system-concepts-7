-- 3.1 Write the following queries in SQL, using the university schema.
   
-- a. Find the titles of courses in the Comp. Sci. department that have 3 credits.
   SELECT * FROM course WHERE dept_name = 'Comp. Sci.' AND credits = 3;

-- b. Find the IDs of all students who were taught by an instructor named Einstein; make 
-- sure there are no duplicates in the result.
   SELECT takes.ID FROM takes,teaches 
   WHERE takes.course_id = teaches.course_id 
   AND teaches.ID = (SELECT id FROM instructor WHERE name = 'Einstein'); 

-- c. Find the highest salary of any instructor. 
   SELECT MAX(salary) FROM instructor;

-- d. Find all instructors earning the highest salary (there may be more than one with the same salary).
   SELECT * FROM instructor WHERE salary = (SELECT MAX(salary) FROM instructor);
   
-- e. Find the enrollment of each section that was offered in Fall 2017. 
   WITH course_section(course_id, sec_id) AS 
   (SELECT course_id,sec_id FROM section 
   WHERE semester = 'Fall' AND year = '2017')
   SELECT course_id,sec_id,COUNT(ID) as enrollment
   FROM course_section, takes
   WHERE takes.course_id = course_section.course_id
   AND takes.sec_id = course_section.sec_id
   GROUP BY course_section.course_id,course_section.sec_id; 
   

-- f. Find the maximum enrollment, across all sections, in Fall 2017. 
   WITH course_section(course_id, sec_id) AS 
   (SELECT course_id,sec_id FROM section 
   WHERE semester = 'Fall' AND year = '2017'),
   course_enrollment(course_id, sec_id, enrollment) AS (
   SELECT course_section.course_id,takes.sec_id,COUNT(ID) as enrollment
   FROM course_section, takes
   WHERE takes.course_id = course_section.course_id
   AND takes.sec_id = course_section.sec_id
   GROUP BY course_section.course_id,course_section.sec_id)
   SELECT MAX(enrollment) FROM course_enrollment;  
   
-- g. Find the sections that had the maximum enrollment in Fall 2017.
   WITH course_section(course_id, sec_id) AS 
   (SELECT course_id,sec_id FROM section 
   WHERE semester = 'Fall' AND year = '2017'),
   course_enrollment(course_id, sec_id, enrollment) AS (
   SELECT course_section.course_id,takes.sec_id,COUNT(ID) as enrollment
   FROM course_section, takes
   WHERE takes.course_id = course_section.course_id
   AND takes.sec_id = course_section.sec_id
   GROUP BY course_section.course_id,course_section.sec_id)
   SELECT course_id, sec_id, enrollment FROM course_enrollment 
   WHERE enrollment = (SELECT MAX(enrollment) FROM course_enrollment);  
   
-- 3.2 grade_points(grade, points)

-- a. Find the total grade points earned by the student with ID '12345', across
--    all courses taken by the student.
   SELECT SUM(points) as total_grade_points 
   FROM takes,grade_points WHERE ID = 12345
   AND takes.grade = grade_points.grade;

-- b.  Find the grade point average (GPA) for the above student, that is, the total
-- grade points divided by the total credits for the associated courses.
   SELECT SUM(points)/SUM(credits) as GPA
   FROM takes, grade_points, course WHERE ID = 12345
   AND takes.course_id = course.course_id
   AND takes.grade = grade_points.grade;
   
-- c. Find the ID and the grade-point average of each student.
   SELECT ID, SUM(points)/SUM(credits) as GPA
   FROM takes, grade_points, course WHERE
   takes.course_id = course.course_id
   AND takes.grade = grade_points.grade
   GROUP BY takes.ID;

-- 3.3 Write the following inserts, deletes, or updates in SQL, 
-- using the university schema.
-- a. Increase the salary of each instructor in the Comp. Sci. department by 10%.
   UPDATE instructor SET salary = salary * 1.1 WHERE dept_name = 'Comp. Sci.';

-- b. Delete all courses that have never been offered (i.e., do not occur in the
-- section relation).
   DELETE FROM course 
   WHERE course_id = 
   ( SELECT course_id FROM course 
   WHERE course_id NOT IN (SELECT course_id FROM section));
   
 
   SELECT COUNT(*) FROM course;

-- c. Insert every student whose tot_cred attribute is greater than 100 as an 
-- instructor in the same department, with a salary of $30,000 
   INSERT INTO instructor
    SELECT ID,name,dept_name,30000 
    FROM student WHERE tot_cred > 100;

-- 3.6 write a query that finds departments whose names contain the string “sci” as a
-- substring, regardless of the case.
   SELECT dept_name FROM department WHERE dept_name LIKE '%sci%';

-- 3.11 Write the following queries in SQL, using the university schema.
-- a. Find the ID and name of each student who has taken at least one Comp.Sci. course; make sure there are no duplicate names in the result.
   SELECT DISTINCT ID,name FROM student, takes, course  WHERE student.ID = takes.ID AND takes.course_id = course.course_id AND course.dept_name = 'Comp. Sci.';

-- b. Find the ID and name of each student who has not taken any course offered before 2017.
   SELECT ID, name FROM student WHERE student.ID NOT IN (SELECT ID FROM takes);


-- c. For each department, find the maximum salary of instructors in that department. You may assume that every department has at least one instructor.
   SELECT dept_name, MAX(salary) as Maximum_Salary FROM instructor GROUP BY dept_name;

-- d. Find the lowest, across all departments, of the per-department maximum salary computed by the preceding query.
   WITH max_salary(dept_name, salary) AS
   (SELECT dept_name, MAX(salary) 
   FROM instructor GROUP BY dept_name)
   SELECT MIN(salary) FROM max_salary ;


-- 3.12 Write the SQL statements using the university schema to perform the following operations:

-- a. Create a new course “CS-001”, titled “Weekly Seminar”, with 0 credits.
INSERT INTO course (course_id, title,dept_name, credits) 
VALUES ('CS-001','Weekly Seminar','Comp. Sci.', 0);
-- b. Create a section of this course in Fall 2017, with sec id of 1, and with the location of this section not yet specified.
INSERT INTO section (course_id, sec_id, semester, year) VALUES 
('CS-001', '1', 'Fall', 2017)
-- c. Enroll every student in the Comp. Sci. department in the above section.
INSERT INTO takes (id, course_id, sec_id, semester, year) 
SELECT student.id,'CS-001', '1', 'Fall', 2017
FROM student 
WHERE student.dept_name = 'Comp. Sci.'
-- d. Delete enrollments in the above section where the student’s ID is 12345.
DELETE FROM takes 
WHERE ID = '12345' AND (course_id, sec_id, semester, year) = ('CS-001', '1', 'Fall', 2017)
-- e. Delete the course CS-001. What will happen if you run this delete statement without first deleting offerings (sections) of this course?
DELETE FROM course
WHERE course_id = 'CS-001'; 
-- f. Delete all takes tuples corresponding to any section of any course with the word “advanced” as a part of the title; ignore case when matching the word with the title.
DELETE FROM takes
WHERE course_id IN (
    SELECT course_id
    FROM course
    WHERE LOWER(title) LIKE '%advanced%'
)

-- 3.24 Using the university schema, write an SQL query to find the name and ID of those Accounting students advised by an instructor in the Physics department.
SELECT s.id, s.name
FROM student AS s INNER JOIN advisor AS a ON s.id = a.s_id
                  INNER JOIN instructor AS i ON a.i_id = i.id
WHERE s.dept_name = 'Accounting' AND i.dept_name = 'Physics'; 

-- 3.25 Using the university schema, write an SQL query to find the names of those departments whose budget is higher than that of Philosophy. List them in alphabetic order
SELECT dept_name
FROM department
WHERE budget > (SELECT budget FROM department WHERE dept_name = 'Philosophy')
ORDER BY dept_name ASC;
-- 3.26 Using the university schema, use SQL to do the following: For each student who has retaken a course at least twice (i.e., the student has taken the course at least three times), show the course ID and the student’s ID.
-- Please display your results in order of course ID and do not display duplicate rows.
SELECT id,course_id 
FROM takes
GROUP BY id,course_id
HAVING COUNT(*) >= 3
ORDER BY course_id ASC; 

-- 3.27 Using the university schema, write an SQL query to find the IDs of those students who have retaken at least three distinct courses at least once (i.e, the student has taken the course at least two times).
WITH retakers(id,course_id,frequency) AS (
    SELECT id,course_id,COUNT(*) 
    FROM takes
    GROUP BY id,course_id
    HAVING COUNT(*) > 1
)
SELECT id
FROM retakers
GROUP BY id
HAVING COUNT(*) >= 3;

-- 3.28 Using the university schema, write an SQL query to find the names and IDs of those instructors who teach every course taught in his or her department (i.e., every course that appears in the course relation with the instructor’s department name). Order result by name.
SELECT id, name
FROM instructor AS i
WHERE NOT EXISTS (
    (SELECT course_id FROM course WHERE dept_name = i.dept_name)
    EXCEPT 
    (SELECT course_id FROM teaches WHERE teaches.id = i.id)
)
ORDER BY name ASC

-- 3.29 Using the university schema, write an SQL query to find the name and ID of each History student whose name begins with the letter ‘D’ and who has not taken at least five Music courses.
SELECT id,name
FROM student AS s
WHERE dept_name = 'History' 
    AND name LIKE 'D%'
    AND (
        SELECT COUNT(DISTINCT course_id)
        FROM takes
        WHERE takes.id = s.id AND 
            course_id IN (SELECT course_id FROM course WHERE dept_name = 'Music')
    ) < 5;

-- 3.31 Using the university schema, write an SQL query to find the ID and name of each instructor who has never given an A grade in any course she or he has taught. (Instructors who have never taught a course trivially satisfy this condition.)
SELECT id, name 
FROM instructor AS i
WHERE 'A' NOT IN (
    SELECT takes.grade
    FROM takes INNER JOIN teaches 
        ON (takes.course_id,takes.sec_id,takes.semester,takes.year) = 
           (teaches.course_id,teaches.sec_id,teaches.semester,teaches.year)
    WHERE teaches.id = i.id
)

-- 3.32 Rewrite the preceding query, but also ensure that you include only instructors who have given at least one other non-null grade in some course.
SELECT id, name 
FROM instructor AS i
WHERE 'A' NOT IN (
    SELECT takes.grade
    FROM takes INNER JOIN teaches 
        ON (takes.course_id,takes.sec_id,takes.semester,takes.year) = 
           (teaches.course_id,teaches.sec_id,teaches.semester,teaches.year)
    WHERE teaches.id = i.id
) 
AND
(
    SELECT COUNT(*)
    FROM takes INNER JOIN teaches 
        ON (takes.course_id,takes.sec_id,takes.semester,takes.year) = 
           (teaches.course_id,teaches.sec_id,teaches.semester,teaches.year)
    WHERE teaches.id = i.id AND takes.grade IS NOT NULL    
) >= 1
-- 3.33 Using the university schema, write an SQL query to find the ID and title of each course in Comp. Sci. that has had at least one section with afternoon hours (i.e., ends at or after 12:00). (You should eliminate duplicates if any.)
SELECT course_id,title
FROM course AS c
WHERE dept_name = 'Comp. Sci.' AND 
    EXISTS (
        SELECT * 
        FROM section
        WHERE section.course_id = c.course_id AND 
        time_slot_id IN (SELECT time_slot_id FROM time_slot WHERE end_hr >= 12)
    )

-- 3.34 Using the university schema, write an SQL query to find the number of students in each section. The result columns should appear in the order “courseid, secid, year, semester, num”. You do not need to output sections with 0 students.
SELECT course_id, sec_id, year, semester, COUNT(DISTINCT ID) AS num
FROM takes
GROUP BY course_id, sec_id, year, semester;

-- 3.35 Using the university schema, write an SQL query to find section(s) with maximum enrollment. The result columns should appear in the order “courseid, secid, year, semester, num”. (It may be convenient to use the with construct.)
WITH section_student_frequency(courseid, secid, year, semester, num) AS (
    SELECT course_id, sec_id, year, semester, COUNT(DISTINCT ID)
    FROM takes
    GROUP BY course_id, sec_id, year, semester
)
SELECT *
FROM section_student_frequency
WHERE num = (SELECT MAX(num) FROM section_student_frequency);

