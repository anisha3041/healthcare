create database healthcare;
use healthcare;
-- import healthcare sql

select * from appointments;
select * from billing;
select * from doctors;
select * from patients;
select * from prescriptions;

select * from appointments 
where patient_id=1;

select * from prescriptions
where appointment_id=1;

select * from billing
where appointment_id=1;


select a.appointment_id,p.first_name as patient_first_name,p.last_name as patient_last_name,
d.first_name as doctor_first_name, d.last_name as doctor_last_name,
b.amount,b.payment_date,b.status
from appointments a
join patients p on a.patient_id = p.patient_id
join doctors d on a.doctor_id =d.doctor_id
join billing b on a.appointment_id = b.appointment_id;

-- find all paid billing
select * from billing
where status = 'paid';

-- calc total amount billed and total paid amount
select (select sum(amount) from billing) as total_billed,
(select sum(amount) from billing where status ='paid') as total_paid;

--  get num of appointment by specialty
select d.specialty, count(a.appointment_id) as number_of_appointments
from appointments a
join doctors d on a.doctor_id = d.doctor_id
group by d.specialty;

-- fing the most common rason for appointment
select reason, count(*) as count
from appointments 
group by reason
order by count desc;

-- list patients with their latest appo date
select p.patient_id,p.first_name,p.last_name,max(a.appointment_date) as latest_appointment
from patients p
join appointments a on p.patient_id = a.patient_id
group by p.patient_id,p.first_name,p.last_name;

-- list all doctors and the num of appointments they had
select d.doctor_id,d.first_name, d.last_name,count(a.appointment_id) as number_of_appointments
from doctors d
left join appointments a on d.doctor_id = a.doctor_id
group by d.doctor_id,d.first_name,d.last_name;

-- retrieve patients who had appoi in last 90 days
select distinct p.*
from patients p
join appointments a on p.patient_id=a.patient_id
where a.appointment_date >= curdate()-interval 90 day;

-- find presc associated with appo that are pending payment
select pr.prescription_id,pr.medication,pr.dosage,pr.instructions 
from prescriptions pr join appointments a on pr.appointment_id = a.appointment_id
join billing b on a.appointment_id = b.appointment_id
where b.status = 'pending';

-- analysis patient demographics
select gender,count(*) as count 
from patients
group by gender;

-- cast use for integer , substring use to break
select medication,count(*) as frequency,sum(cast(substring_index(dosage,' ',1) as unsigned)) total_dosage
from prescriptions
group by medication
order by frequency desc;

-- payment status over time
select date_format(payment_date,'%Y-%m') as month,status,
count(*) as count from billing
group by month,status
order by month,status;

-- day wise appointment counts
select appointment_date,count(*) as appointment_count
from appointments
group by appointment_date;

-- find patients with missing appoitments
select p.patient_id,p.first_name,p.last_name
from patients p
left join appointments a on p.patient_id = a.patient_id
where a.appointment_id is null;