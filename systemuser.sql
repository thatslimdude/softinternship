--creating account table
CREATE TABLE bank_account(
account_id NUMBER GENERATED BY DEFAULT AS IDENTITY (START WITH 1 INCREMENT BY 1),
account_number VARCHAR2(20) UNIQUE,
account_name VARCHAR2(100),
balance NUMBER(10,2),
PRIMARY KEY(account_id)
);

--create transaction log table
CREATE TABLE transaction_log(
log_id NUMBER GENERATED BY DEFAULT AS IDENTITY(START WITH 1 INCREMENT BY 1),
account_number VARCHAR2(250),
transaction_type VARCHAR2(250),
amount NUMBER,
transaction_time DATE DEFAULT SYSDATE,
PRIMARY KEY(log_id)
);

--inserting accounts
BEGIN
INSERT INTO bank_account(account_number,account_name,balance) VALUES ('ACC001','Alice Martins',5000);
INSERT INTO bank_account(account_number,account_name,balance) VALUES ('ACCOO2','John Peters',3000);
END;
/

--make deposit procedure
CREATE OR REPLACE PROCEDURE make_deposit(
p_account_number IN VARCHAR2,
p_amount IN NUMBER
)AS d_count NUMBER;
BEGIN
SELECT COUNT(*) INTO d_count FROM bank_account
WHERE p_account_number=account_number;

IF p_amount>0 THEN
UPDATE bank_account SET balance= balance + p_amount;
ELSE
dbms_output.put_line('Invalid Amount');
END IF;
EXCEPTION
WHEN no_data_found THEN
dbms_output.put_line ('Invalid Account');

--Modified procedure to insert into transaction_log
INSERT INTO transaction_log (account_number,transaction_type,amount) VALUES (p_account_number,'DEPOSIT',p_amount);
END;
/

--make withdrawal procedure
CREATE OR REPLACE PROCEDURE make_withdrawal(
p_account_number IN VARCHAR,
p_amount IN NUMBER
) AS 
curr_balance NUMBER;
BEGIN
SELECT balance INTO curr_balance FROM bank_account
WHERE p_account_number=account_number;

IF p_amount< curr_balance THEN
UPDATE bank_account SET balance=curr_balance - p_amount;
dbms_output.put_line ('Withdrawal Successful');
ELSE
dbms_output.put_line ('Insufficient Funds');
END IF;
EXCEPTION
WHEN no_data_found THEN
dbms_output.put_line('Invalid Account');
--Modified procedure to insert into transaction_log
INSERT INTO transaction_log (account_number,transaction_type,amount) VALUES (p_account_number,'WITHDRAWAL',p_amount);
END;
/

BEGIN
make_deposit('ACC001',1000);
make_withdrawal('ACC002',2000);
make_withdrawal('ACC002',5000);
END;
/






