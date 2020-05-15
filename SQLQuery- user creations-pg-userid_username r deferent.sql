-- you need to set v_workSpaceName / v_owner/ v_userCount values
DO
$$
DECLARE
	v_workSpaceName  text  = 'tetherfiaaaaaaa';
	v_owner   text  = 'admin@tetheri.com';
	v_userCount    INTEGER =3;
	
	v_password text = '$2a$10$/qgzQ84MjHJNgVd7d2Ijo.7OgxjOM/hHLvbhqq9qLun8Wl812yZ8m';	
   	v_workspaceid    INTEGER =1;
	v_Counter  INTEGER =1;   
	v_username text  = '';
	v_firstname text  = '';
	v_lastname text  = '';
	v_uid text ='';
BEGIN
	 
INSERT INTO organization.workspaces(
	"workSpaceName", active, owner, "createdAt", "updatedAt")
	VALUES ( v_workSpaceName,true,v_owner, '2020-04-14 13:01:31.5260000 +00:00','2020-04-14 13:01:31.5260000 +00:00') RETURNING workspaceid INTO v_workspaceid;
	
 WHILE v_Counter <= v_userCount
    LOOP
	v_uid = uuid_generate_v4();
        --SET @username = 'agent_test' + CAST(ABS(CHECKSUM(NEWID()) % (101 - 1 + 1)) + 1 as varchar(10))  
	v_firstname:= v_workSpaceName;
	v_lastname = v_Counter;
	v_username = concat(v_firstname,v_lastname,'@', v_workSpaceName,'.com');

	INSERT INTO organization.workspacemembers(
	type, user_type, userid, username, active, workspaceid, "createdAt", "updatedAt")
	VALUES ('member','agent', v_uid, v_username, true, v_workspaceid, '2020-04-14 13:01:31.5260000 +00:00','2020-04-14 13:01:31.5260000 +00:00');
	
	
	INSERT INTO auth."Identities"
           (username
           ,password
           ,active
           ,"createdAt", "updatedAt")
     VALUES
           (v_username,v_password,true,'2020-04-14 13:01:31.5260000 +00:00','2020-04-14 13:01:31.5260000 +00:00');
	INSERT INTO auth.user_accounts(
	user_id, user_name, activated, deleted, email_address, mobile_number, first_name, last_name, gender, avatar_url, org_id, created_at, updated_at, otp, password, user_type)
	VALUES (v_uid, v_username, true, false, v_username, '1234567890', v_firstname, v_lastname, 0, 'https://gravatar.com/avatar/b2ba96f865150584dd3847f561a64c91?s=400&d=robohash&r=x', v_workspaceid, NOW(), NOW(), '123456', v_password, 2);
	--INSERT INTO auth.user_accounts(
	--user_id, created, deleted, email_address, first_name, last_name, mobile_number, password, updated, user_type,  gender, img_path, activated, otp)
	--VALUES (v_uid, NOW(),false,v_username, v_firstname, v_lastname, '1234567890', '123456', NOW(), 2,  1,'https://gravatar.com/avatar/b2ba96f865150584dd3847f561a64c91?s=400&d=robohash&r=x', true, null);
	
--RAISE NOTICE concat('Agent Creted - ',v_username); 
    v_Counter  := v_Counter  + 1;
    END LOOP;

END;
$$
LANGUAGE plpgsql;