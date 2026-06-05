/*
================================================================================
Database Transaction Safety Case Study - Financial Ledger System
================================================================================
Target System: Microsoft SQL Server (T-SQL)
Description: Examples of transactional safety, explicit error handling, 
             and automated rollbacks during financial modifications.
*/

-- -----------------------------------------------------------------------------
-- 1. SCHEMA DEFINITION & MOCK DATA
-- -----------------------------------------------------------------------------

CREATE TABLE Accounts(
    AccountID           INT,
    CustomerID          INT,
    Balance             DECIMAL(18,2),
    AccountType         CHAR(20),
    PRIMARY KEY (AccountID)
);

CREATE TABLE Transactions(
    TransactionID       INT IDENTITY(1,1), -- Automatically handles unique ID generation safely
    AccountID           INT,
    Amount              DECIMAL(18,2),
    TransactionType     CHAR(20),
    TransactionDate     DATE,
    PRIMARY KEY (TransactionID),
    FOREIGN KEY (AccountID) REFERENCES Accounts(AccountID)
);


INSERT INTO Accounts VALUES (777, 12345, 0.00, 'C');
INSERT INTO Accounts VALUES (333, 123456, 1000, 'C');
GO


-- -----------------------------------------------------------------------------
-- 2. TRANSACTION SAMPLES WITH AUTOMATED ERROR HANDLING
-- -----------------------------------------------------------------------------

-- Example 1: Safe Account Deposit
-- Note: Verifies the target account exists, applies the deposit, and logs the history.
--       If an unexpected error occurs, the CATCH block reverses all changes automatically.

BEGIN TRY
    BEGIN TRANSACTION;

    IF EXISTS (SELECT 1 FROM Accounts WHERE AccountID = 777)
    BEGIN
        UPDATE  Accounts 
        SET     Balance = Balance + 1000
        WHERE   AccountID = 777;

        INSERT INTO Transactions (AccountID, Amount, TransactionType, TransactionDate)
        VALUES (777, 1000, 'Deposit', GETDATE());

        COMMIT TRANSACTION;
    END
    ELSE
    BEGIN
        -- Rollback if the account does not exist
        ROLLBACK TRANSACTION;
    END
END TRY
BEGIN CATCH
    -- Rollback if a system error occurs mid-execution
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
END CATCH;
GO


-- Example 2: Safe Account Withdrawal
-- Note: Verifies the target account exists before deducting funds and logging the history.

BEGIN TRY
    BEGIN TRANSACTION;

    IF EXISTS (SELECT 1 FROM Accounts WHERE AccountID = 333)
    BEGIN
        UPDATE  Accounts 
        SET     Balance = Balance - 300
        WHERE   AccountID = 333;

        INSERT INTO Transactions (AccountID, Amount, TransactionType, TransactionDate)
        VALUES (333, 300, 'Withdrawal', GETDATE());

        COMMIT TRANSACTION;
    END
    ELSE
    BEGIN
        ROLLBACK TRANSACTION;
    END
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
END CATCH;
GO


-- Example 3: Multi-Account Fund Transfer
-- Note: Ensures that both the deduction from Account 777 and the addition to Account 333
--       succeed together. If either check fails, the entire transaction is rolled back.

BEGIN TRY
    BEGIN TRANSACTION;

    IF EXISTS (SELECT 1 FROM Accounts WHERE AccountID = 777) 
       AND EXISTS (SELECT 1 FROM Accounts WHERE AccountID = 333)
    BEGIN
        -- Deduct from sender
        UPDATE  Accounts 
        SET     Balance = Balance - 200
        WHERE   AccountID = 777;

        -- Credit to receiver
        UPDATE  Accounts 
        SET     Balance = Balance + 200
        WHERE   AccountID = 333;

        -- Log sender transaction record
        INSERT INTO Transactions (AccountID, Amount, TransactionType, TransactionDate)
        VALUES (777, 200, 'Transfer Out', GETDATE());

        -- Log receiver transaction record
        INSERT INTO Transactions (AccountID, Amount, TransactionType, TransactionDate)
        VALUES (333, 200, 'Transfer In', GETDATE());

        COMMIT TRANSACTION;
    END
    ELSE
    BEGIN
        ROLLBACK TRANSACTION;
    END
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
END CATCH;
GO


-- -----------------------------------------------------------------------------
-- 3. VERIFICATION
-- -----------------------------------------------------------------------------

SELECT		* FROM		Accounts;
SELECT		* FROM		Transactions;