# 1 тут вывод по успешной сдаче сессии
with x as ( select sres.student_id,
  sres.result,
                   sum(sres.result) as summ
from students.student_result sres
            where sres.result > 2
group by sres.student_id
            having count(*) = 3 )
select st.first_name, st.last_name
from students.student st
join x on  x.student_id = st.id
order by x.summ desc;

# 1 вывод того кто просто сдал экзамены не на 2
select id, stud.first_name, stud.last_name
from student stud
join student_result res on res.student_id = stud.id
where res.result > 2
order by res.result desc;
 
 #2
select count(*)
from (
select sres.student_id,
sres.result
from students.student_result sres
where sres.result in (4, 5)
group by sres.student_id
        having count(*) = 3
) as x;

 #3
select count(*)
from student_result res
where res.result > 2
and res.student_id not in (
select er.student_id
    from exam_result er
    where er.exam_id = res.exam_id
);

#4
select avg(result)
from students.student_result sre
where sre.training_course_id = 1;

#5
with x as (
select er.student_id
from exam_result er
join exam on exam.id = er.exam_id
where exam.training_course_id = 3 and result <=2
)
select st.first_name, st.last_name
from student st
join x on x.student_id = st.id;

#5 второй вид запроса
with x as (
select st.first_name,
                    st.last_name,
                    exam_result.result,
                    exam_result.exam_id
from student st
            join exam_result on st.id = exam_result.student_id
)
select x.first_name, x.last_name
from x
join exam on exam.id = x.exam_id
where training_course_id = 3 and result <= 2;

#6 больше 2 или больше равно 2?
select teacher_id
from students.training_course
group by teacher_id
having count(*) >= 2;

#7
select student_id
from students.exam_result
group by teacher_id, student_id
having count(*) >= 2;

#8 where student_result.result >2 having count(*) = 3 тогда будут другие рез-ты (условие уточнить)
with x as (select student_id,
result,
          sum(result) as summ
          from students.student_result            
          group by student_result.student_id
             )
select st.first_name,
st.last_name
from students.student st
join  x on  x.id = st.student_id
order by summ desc
limit 5;

#9
with x as (
select teacher_id,
avg(sr.result) as summ
from student_result sr
join training_course tc on sr.training_course_id = id
group by teacher_id
)
select last_name
from techer
join x on techer.id = x.teacher_id
where summ = (select max(summ) from x);

#10 # по годам среднее (заменить на 5)
select year(date), avg(result)
from student_result res
where res.training_course_id = 4
group by date
order by date