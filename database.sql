CREATE TABLE IF NOT EXISTS showrooms (
    id INT AUTO_INCREMENT PRIMARY KEY,
    owner INT NOT NULL,
    name VARCHAR(255) NOT NULL,
    location VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS showroom_cars (
    id INT AUTO_INCREMENT PRIMARY KEY,
    showroom_id INT NOT NULL,
    car_model VARCHAR(255) NOT NULL,
    FOREIGN KEY (showroom_id) REFERENCES showrooms(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS warehouse_cars (
    id INT AUTO_INCREMENT PRIMARY KEY,
    car_model VARCHAR(255) NOT NULL,
    price INT NOT NULL
);

-- Insert default cars into the warehouse
INSERT INTO warehouse_cars (car_model, price) VALUES
('adder', 100000),
('banshee', 80000),
('bullet', 120000),
('cheetah', 90000),
('entityxf', 110000);