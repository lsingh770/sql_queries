-- Step 1: Create Database
CREATE DATABASE Zomato;

-- Step 2: Use the created database
USE Zomato;

-- Step 3: Create Orders table
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY AUTO_INCREMENT,
    UserID INT NOT NULL,
    City VARCHAR(50),
    Cuisine VARCHAR(50),
    DishName VARCHAR(100),
    RestaurantID INT,
    Quantity INT,
    Amount DECIMAL(10,2),
    OrderDate DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Step 4: Insert 100 records into Orders
INSERT INTO Orders (UserID, City, Cuisine, DishName, RestaurantID, Quantity, Amount, OrderDate)
SELECT 
    FLOOR(RAND() * 1000) + 1, 
    ELT(FLOOR(1 + (RAND() * 5)), 'Delhi', 'Mumbai', 'Bangalore', 'Hyderabad', 'Chennai'),
    ELT(FLOOR(1 + (RAND() * 4)), 'Indian', 'Chinese', 'Italian', 'Mexican'),
    ELT(FLOOR(1 + (RAND() * 5)), 'Biryani', 'Pasta', 'Burger', 'Tacos', 'Dosa'),
    FLOOR(RAND() * 500) + 1, 
    FLOOR(RAND() * 5) + 1, 
    ROUND(RAND() * 500 + 100, 2), 
    NOW()
FROM (SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5) a,
     (SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5) b,
     (SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4) c;

-- Step 5: Add an index to UserID in Orders table and Create Ratings table
CREATE INDEX idx_userid ON Orders(UserID);
CREATE TABLE Ratings (
    RestaurantID INT NOT NULL,
    UserID INT NOT NULL,
    Ratings DECIMAL(2,1),
    FOREIGN KEY (UserID) REFERENCES Orders(UserID)
);

-- Step 6: Insert 100 records into Ratings
INSERT INTO Ratings (RestaurantID, UserID, Ratings)
SELECT DISTINCT
    FLOOR(RAND() * 500) + 1,
    UserID,
    ROUND(RAND() * 4 + 1, 1)
FROM Orders
ORDER BY RAND()
LIMIT 100;

-- Step 7: Create Referrals table
CREATE TABLE Referrals (
    ReferrerID INT NOT NULL,
    ReferredID INT NOT NULL,
    FOREIGN KEY (ReferrerID) REFERENCES Orders(UserID),
    FOREIGN KEY (ReferredID) REFERENCES Orders(UserID),
    CHECK (ReferrerID <> ReferredID)
);

-- Step 8: Insert records into Referrals
INSERT INTO Referrals (ReferrerID, ReferredID)
SELECT DISTINCT
    O1.UserID AS ReferrerID,
    O2.UserID AS ReferredID
FROM Orders O1
JOIN Orders O2 ON O1.UserID <> O2.UserID
ORDER BY RAND()
LIMIT 50;
