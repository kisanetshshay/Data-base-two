-- Active: 1747023134431@@127.0.0.1@5432@data_class@coop_connect

CREATE SCHEMA coop_connect;

CREATE TABLE coop_connect.farmers (
    Id INT  PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    coop_id VARCHAR(50) UNIQUE NOT NULL,
    phone_number VARCHAR(20) UNIQUE NOT NULL,
    village_id VARCHAR(20) UNIQUE NOT NULL
);


INSERT INTO coop_connect.farmers (id, name, coop_id, phone_number, village_id) VALUES
('1','John James', 'COOP001', '+254712345678', 'VILLAGE01'),
('2','Jane Smith', 'COOP002', '+254787654321', 'VILLAGE02'),
('3','Michael Johnson', 'COOP003', '+254700112233', 'VILLAGE03'),
('4','Abel Brown', 'COOP004', '+254733445566', 'VILLAGE04'),
('5','Charlie Davis', 'COOP005', '+254722998877', 'VILLAGE05'),
('6','Brhanu White', 'COOP006', '+254755667788', 'VILLAGE06');
SELECT * FROM coop_connect.farmers

CREATE TABLE coop_connect.training_sessions (
    id INT PRIMARY KEY,
    topic VARCHAR(500) NOT NULL,
    date DATE NOT NULL,
    village VARCHAR(255) NOT NULL,
    extension_worker VARCHAR(255) NOT NULL
);
INSERT INTO training_sessions ( id,topic, date, village, extension_worker) VALUES
('1','Soil Health Management', '2025-04-10', 'VILLAGE01', 'John Kariuki'),
('2','Crop Rotation Techniques', '2025-04-12', 'VILLAGE02', 'Alice Wambua'),
('3','Pest Control Strategies', '2025-04-15', 'VILLAGE03', 'David Omondi'),
('4','Organic Farming Practices', '2025-04-18', 'VILLAGE04', 'Grace Achieng'),
('5','Irrigation Systems Overview', '2025-04-20', 'VILLAGE05', 'Peter Mwangi'),
('6','Post-Harvest Handling', '2025-04-22', 'VILLAGE06', 'Lucy Njeri');
SELECT * FROM coop_connect.training_sessions


CREATE TABLE coop_connect.attendance (
    id SERIAL PRIMARY KEY,
    farmer_id INT NOT NULL,
    session_id INT NOT NULL,
    village_id VARCHAR(20) NOT NULL,
    attended_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (farmer_id) REFERENCES coop_connect.farmers(id) ON DELETE CASCADE,
    FOREIGN KEY (session_id) REFERENCES coop_connect.training_sessions(id) ON DELETE CASCADE,
    FOREIGN KEY (village_id) REFERENCES coop_connect.farmers(village_id) ON DELETE CASCADE
);

INSERT INTO coop_connect.attendance (farmer_id, session_id, village_id) VALUES
(1, 1, 'VILLAGE01'),
(2, 2, 'VILLAGE02'),
(3, 3, 'VILLAGE03'),
(4, 4, 'VILLAGE04'),
(5, 5, 'VILLAGE05'),
(6, 6, 'VILLAGE06');
SELECT * FROM coop_connect.attendance

SELECT id FROM coop_connect.attendance;

CREATE TABLE coop_connect.farmer_rewards (
    id  SERIAL PRIMARY KEY,
    farmer_id INT NOT NULL,
    attendance_id INT NOT NULL,
    farmer_points INT NOT NULL DEFAULT 0,
    status VARCHAR(20) NOT NULL,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (farmer_id) REFERENCES farmers(id) ON DELETE CASCADE,
    FOREIGN KEY (attendance_id) REFERENCES attendance(id) ON DELETE CASCADE
);

INSERT INTO coop_connect.farmer_rewards (farmer_id, attendance_id, farmer_points, status)
VALUES
(1, 1, 50, 'Active'),
(2, 2, 30, 'Inactive'),
(3, 3, 70, 'Active'),
(4, 4, 20, 'Pending'),
(5, 5, 90, 'Active'),
(6, 6, 40, 'Suspended');

 SELECT * FROM coop_connect.farmer_rewards;
CREATE TABLE coop_connect.payments (
    id  SERIAl PRIMARY KEY,
    farmer_id INT NOT NULL,
    session_id INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    payment_method VARCHAR(20) NOT NULL CHECK (payment_method IN ('MTN Money', 'Reward Points')),
    status VARCHAR(20) NOT NULL DEFAULT 'Completed' CHECK (status IN ('Pending', 'Completed', 'Failed')),
    transaction_id VARCHAR(50) UNIQUE NOT NULL,
    points_deducted INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (farmer_id) REFERENCES farmers(id) ON DELETE CASCADE,
    FOREIGN KEY (session_id) REFERENCES training_sessions(id) ON DELETE CASCADE
);
 INSERT INTO coop_connect.payments (
    farmer_id,
    session_id,
    amount,
    payment_method,
    status,
    transaction_id,
    points_deducted
) VALUES
(1, 101, 500.00, 'MTN Money', 'Completed', 'TXN20250401001', 0),
(2, 102, 300.00, 'Reward Points', 'Pending', 'TXN20250401002', 50),
(3, 103, 450.00, 'MTN Money', 'Completed', 'TXN20250401003', 0),
(4, 101, 200.00, 'Reward Points', 'Failed', 'TXN20250401004', 20),
(5, 104, 600.00, 'MTN Money', 'Completed', 'TXN20250401005', 0),
(6, 102, 350.00, 'Reward Points', 'Pending', 'TXN20250401006', 35);
SELECT * FROM coop_connect.payments

CREATE TABLE coop_connect.payments_history (
    id  SERIAL PRIMARY KEY,
    farmer_id INT NOT NULL,
    payment_id INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    payment_method VARCHAR(20) NOT NULL CHECK (payment_method IN ('MTN Money', 'Reward Points')),
    transaction_id VARCHAR(50),
    status VARCHAR(20) NOT NULL DEFAULT 'Completed' CHECK (status IN ('Pending', 'Completed', 'Failed')),
    processed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (farmer_id) REFERENCES farmers(id) ON DELETE CASCADE,
    FOREIGN KEY (payment_id) REFERENCES payments(id) ON DELETE CASCADE
);
INSERT INTO coop_connect.payments_history (
    farmer_id,
    payment_id,
    amount,
    payment_method,
    transaction_id,
    status,
    processed_at
) VALUES
(1, 1001, 500.00, 'MTN Money', 'TXN20250401001', 'Completed', '2025-04-01 10:10:00'),
(2, 1002, 300.00, 'Reward Points', 'TXN20250401002', 'Pending', '2025-04-01 10:15:00'),
(3, 1003, 450.00, 'MTN Money', 'TXN20250401003', 'Completed', '2025-04-01 10:20:00'),
(4, 1004, 200.00, 'Reward Points', 'TXN20250401004', 'Failed', '2025-04-01 10:25:00'),
(5, 1005, 600.00, 'MTN Money', 'TXN20250401005', 'Completed', '2025-04-01 10:30:00'),
(6, 1006, 350.00, 'Reward Points', 'TXN20250401006', 'Pending', '2025-04-01 10:35:00');

SELECT * FROM coop_connect.payments_history

CREATE TABLE coop_connect.users (
    coop_id INT PRIMARY KEY,
    full_name VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(300) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO coop_connect.users (coop_id, full_name, email, password) VALUES
(1001, 'John James', 'johndoe@example.com', 'securepassword123'),
(1002, 'Jane Smith', 'janesmith@example.com', 'mypassword456'),
(1003, 'Micheal Johnson', 'alicej@example.com', 'pass1234'),
(1004, 'Abel Brown', 'bobbrown@example.com', 'bobspassword'),
(1005, 'Charlie Davis', 'charlied@example.com', 'letmein'),
(1006, 'Brhanu White', 'evewhite@example.com', 'evepassword');

SELECT* FROM coop_connect.users
