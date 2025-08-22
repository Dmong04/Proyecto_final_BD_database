Create database coco_tours_db;
go

-- Use database
USE coco_tours_db;
GO

-- Table: client
CREATE TABLE client (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(50) NOT NULL
);
GO

-- Table: client_phones
CREATE TABLE client_phones (
    id INT IDENTITY(1,1) PRIMARY KEY,
    client_id INT NOT NULL,
    phone VARCHAR(20) NOT NULL,
    FOREIGN KEY (client_id) REFERENCES client(id) ON DELETE CASCADE
);
GO

-- Table: administrator
CREATE TABLE administrator (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(50) NOT NULL
);
GO

-- Table: user
CREATE TABLE [user] (
    id INT IDENTITY(1,1) PRIMARY KEY,
    email VARCHAR(70) UNIQUE NOT NULL,
    username VARCHAR(30) UNIQUE NOT NULL,
    password VARCHAR(150) NOT NULL,
    client_id INT DEFAULT NULL,
    admin_id INT DEFAULT NULL,
    [role] VARCHAR(10) DEFAULT NULL,
    FOREIGN KEY (client_id) REFERENCES client(id) ON DELETE SET NULL,
    FOREIGN KEY (admin_id) REFERENCES administrator(id) ON DELETE SET NULL
    );
GO

-- Table: extra
CREATE TABLE extra (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(40) NOT NULL,
    description VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL
);
GO

-- Table: reservations
CREATE TABLE reservations (
    id INT IDENTITY(1,1) PRIMARY KEY,
    date DATE NOT NULL,
    time TIME NOT NULL,
    description VARCHAR(100) NOT NULL,
    tour_subtotal DECIMAL(10,2) DEFAULT 0,
    extra_subtotal DECIMAL(10,2) DEFAULT 0,
    total DECIMAL(10,2) DEFAULT 0,
    [user_id] INT NOT NULL,
    FOREIGN KEY ([user_id]) REFERENCES [user](id) ON DELETE CASCADE
);
GO

-- Table: extra_detail
CREATE TABLE extra_detail (
    id INT IDENTITY(1,1) PRIMARY KEY,
    person_count INT NOT NULL,
    total_price DECIMAL(10,2),
    extra_id INT NOT NULL,
    reservation_id INT NOT NULL,
    FOREIGN KEY (reservation_id) REFERENCES reservations(id) ON DELETE CASCADE,
    FOREIGN KEY (extra_id) REFERENCES extra(id) ON DELETE CASCADE
);
GO

-- Table: supplier
CREATE TABLE supplier (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    description VARCHAR(100) NOT NULL,
    email VARCHAR(70) NOT NULL
);
GO

-- Table: supplier_phones
CREATE TABLE supplier_phones (
    id INT IDENTITY(1,1) PRIMARY KEY,
    phone VARCHAR(20) NOT NULL,
    supplier_id INT NOT NULL,
    FOREIGN KEY (supplier_id) REFERENCES supplier(id) ON DELETE CASCADE
);
GO

-- Table: tour
CREATE TABLE tour (
    id INT IDENTITY(1,1) PRIMARY KEY,
    type VARCHAR(30) NOT NULL,
    description VARCHAR(MAX) NOT NULL,
    price DECIMAL(10,2) NOT NULL
);
GO

-- Table: tour_detail
CREATE TABLE tour_detail (
    id INT IDENTITY(1,1) PRIMARY KEY,
    passenger_count INT NOT NULL,
    origin VARCHAR(40) NOT NULL,
    destination VARCHAR(40) NOT NULL,
    tour_id INT NOT NULL,
    reservation_id INT NOT NULL,
    supplier_id INT NOT NULL,
    FOREIGN KEY (tour_id) REFERENCES tour(id) ON DELETE CASCADE,
    FOREIGN KEY (reservation_id) REFERENCES reservations(id) ON DELETE CASCADE,
    FOREIGN KEY (supplier_id) REFERENCES supplier(id) ON DELETE CASCADE
);
GO

-- Table: passengers
CREATE TABLE passengers (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(60) NOT NULL,
    age INT NOT NULL,
    tour_detail_id INT NOT NULL,
    FOREIGN KEY (tour_detail_id) REFERENCES tour_detail(id)
        ON DELETE CASCADE ON UPDATE CASCADE
);
GO
