CREATE TABLE authtable(
system_name VARCHAR2,
token VARCHAR2,
expire_date SYSDATE
primary key(token)
);

BEGIN
INSERT INTO authtable (system_name,token,expiry_date) VALUES ('SYSTEM A', 'TOKEN123A, SYSDATE +3);
INSERT INTO authtable (system_name,token,expiry_date) VALUES ('SYSTEM b', 'TOKEN123B, SYSDATE +5);
END;
/

CREATE OR REPLACE PROCEDURE validate_token
(p_token IN authtable.token%TYPE, p_date IN authtable.expiry_date%TYPE, p_detail OUT)
IS
BEGIN
SELECT token, expiry_date INTO p_token, p_date FROM authtable
WHERE p_token=token;
IF SYSDATE > p_token THEN
dbms_output.put_line('Expired Token');
ELSE
dbms_output.put_line ('Authenticated);
END IF;
EXCEPTION
WHEN NO_DATA_FOUND 
dbms_output.put_line ('Invalid Token);
END;
/


BEGIN
validation_token('TOKEN123A')
END;
/

CREATE OR REPLACE PROCEDURE cleanup_token( c_token, c_date)
AS
BEGIN
SELECT token, expiry_date INTO c_token,c_date
WHERE c_token=token;
IF SYSTDATE> c_date THEN
DELETE FROM TABLE app_tokens
WHERE token=c_token;
END;
/
