CREATE DATABASE HospitalResourses_db;
USE HospitalResourses_db;
CREATE TABLE doctors (
    doctor_id SERIAL PRIMARY KEY,
    doctor_name VARCHAR(100),
    specialization VARCHAR(100),
    consultation_fee DECIMAL(10,2),
    available_from TIME,
    available_to TIME
);
INSERT INTO doctors (doctor_name, specialization, consultation_fee, available_from, available_to)
VALUES
('Dr. Rajesh Kumar', 'Cardiology', 800.00, '09:00:00', '17:00:00'),
('Dr. Priya Sharma', 'Neurology', 900.00, '10:00:00', '18:00:00'),
('Dr. Arun Reddy', 'Orthopedics', 700.00, '08:00:00', '16:00:00'),
('Dr. Sneha Patel', 'Pediatrics', 600.00, '09:30:00', '15:30:00'),
('Dr. Mohan Rao', 'General Medicine', 500.00, '08:00:00', '14:00:00');
CREATE TABLE patients (
    patient_id SERIAL PRIMARY KEY,
    patient_name VARCHAR(100),
    age INT,
    gender VARCHAR(10),
    contact_number VARCHAR(15)
);
INSERT INTO patients (patient_name, age, gender, contact_number)
VALUES
('Ravi Teja', 45, 'Male', '9876543210'),
('Anjali Verma', 32, 'Female', '9123456780'),
('Suresh Babu', 60, 'Male', '9988776655'),
('Lakshmi Devi', 28, 'Female', '9012345678'),
('Vikram Singh', 50, 'Male', '9090909090'),
('Meena Kumari', 40, 'Female', '9871234567'),
('Karthik R', 35, 'Male', '9345678901'),
('Divya Nair', 29, 'Female', '9567890123');
CREATE TABLE rooms (
    room_id SERIAL PRIMARY KEY,
    room_type VARCHAR(50),
    total_beds INT,
    occupied_beds INT
);
INSERT INTO rooms (room_type, total_beds, occupied_beds)
VALUES
('General Ward', 50, 35),
('Semi-Private', 20, 15),
('Private', 15, 10),
('ICU', 10, 9);
CREATE TABLE appointments (
    appointment_id SERIAL PRIMARY KEY,
    patient_id INT REFERENCES patients(patient_id),
    doctor_id INT REFERENCES doctors(doctor_id),
    appointment_date DATE,
    appointment_time TIME,
    status VARCHAR(20) -- Scheduled / Completed / Cancelled
);
INSERT INTO appointments (patient_id, doctor_id, appointment_date, appointment_time, status)
VALUES
(1, 1, '2026-03-01', '09:30:00', 'Completed'),
(2, 1, '2026-03-01', '10:00:00', 'Completed'),
(3, 2, '2026-03-01', '11:00:00', 'Scheduled'),
(4, 3, '2026-03-01', '08:30:00', 'Completed'),
(5, 4, '2026-03-02', '10:30:00', 'Cancelled'),
(6, 5, '2026-03-02', '09:00:00', 'Completed'),
(7, 1, '2026-03-02', '11:30:00', 'Scheduled'),
(8, 3, '2026-03-02', '12:00:00', 'Completed'),
(2, 5, '2026-03-03', '08:45:00', 'Completed'),
(4, 2, '2026-03-03', '10:15:00', 'Scheduled');
CREATE TABLE admissions (
    admission_id SERIAL PRIMARY KEY,
    patient_id INT REFERENCES patients(patient_id),
    room_id INT REFERENCES rooms(room_id),
    admission_date DATE,
    discharge_date DATE
);
INSERT INTO admissions (patient_id, room_id, admission_date, discharge_date)
VALUES
(1, 4, '2026-02-25', NULL),              -- ICU (still admitted)
(3, 1, '2026-02-26', '2026-03-01'),
(5, 2, '2026-02-28', NULL),              -- Semi-private
(6, 3, '2026-03-01', NULL),              -- Private
(7, 1, '2026-03-02', NULL);
SELECT doctor_id, appointment_date, COUNT(*) AS total_appointments
FROM appointments
GROUP BY doctor_id, appointment_date
HAVING COUNT(*) > 20;

SELECT 
    room_type,
    SUM(occupied_beds) * 100.0 / SUM(total_beds) AS occupancy_percentage
FROM rooms
GROUP BY room_type;
SELECT admission_date, COUNT(*) AS total_admissions
FROM admissions
GROUP BY admission_date
ORDER BY total_admissions DESC;
SELECT 
    doctor_id,
    COUNT(*) AS total_patients,
    RANK() OVER (ORDER BY COUNT(*) DESC) AS workload_rank
FROM appointments
WHERE status = 'Completed'
GROUP BY doctor_id;

SELECT 
    d.specialization,
    AVG(p.age) AS avg_age
FROM appointments a
JOIN doctors d ON a.doctor_id = d.doctor_id
JOIN patients p ON a.patient_id = p.patient_id
GROUP BY d.specialization;

