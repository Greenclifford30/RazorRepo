CREATE DATABASE IF NOT EXISTS razorshopdb;

USE razorshopdb;

CREATE TABLE users (
  id INT PRIMARY KEY AUTO_INCREMENT,
  username VARCHAR(255) UNIQUE,
  email VARCHAR(255) UNIQUE,
  password VARCHAR(255),
  first_name VARCHAR(255),
  last_name VARCHAR(255),
  phone VARCHAR(255) UNIQUE,
  created_at DATETIME,
  updated_at DATETIME
);

CREATE TABLE services (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(255),
  description VARCHAR(255),
  duration INT,
  created_at DATETIME,
  updated_at DATETIME
);

CREATE TABLE bookings (
  id INT PRIMARY KEY AUTO_INCREMENT,
  user_id INT,
  service_id INT,
  start_time DATETIME,
  end_time DATETIME,
  status ENUM('scheduled', 'completed', 'canceled'),
  created_at DATETIME,
  updated_at DATETIME,
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (service_id) REFERENCES services(id)
);

CREATE TABLE prices (
  id INT PRIMARY KEY AUTO_INCREMENT,
  service_id INT,
  price DECIMAL(10, 2),
  created_at DATETIME,
  updated_at DATETIME,
  FOREIGN KEY (service_id) REFERENCES services(id)
);

CREATE TABLE payments (
  id INT PRIMARY KEY AUTO_INCREMENT,
  booking_id INT,
  user_id INT,
  payment_amount DECIMAL(10, 2),
  tip_amount DECIMAL(10, 2),
  payment_status ENUM('pending', 'completed', 'refunded'),
  payment_method VARCHAR(255),
  FOREIGN KEY (booking_id) REFERENCES bookings(id),
  FOREIGN KEY (user_id) REFERENCES users(id)
);
