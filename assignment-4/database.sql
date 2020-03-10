-- Creating Roles table

CREATE TABLE IF NOT EXISTS roles(
  id serial PRIMARY KEY,
  name varchar(100) NOT NULL
);

-- Creating users table and defining a constraint

CREATE TABLE IF NOT EXISTS users(
  id serial PRIMARY KEY,
  name varchar(100) NOT NULL,
  role_id int NOT NULL,
  CONSTRAINT fk_role_id FOREIGN key(role_id) REFERENCES roles(id)
);

-- Creating permissions table and defining a constraint

CREATE TABLE IF NOT EXISTS permissions(
  id serial PRIMARY KEY,
  name varchar(100) NOT NULL
);

-- Creating and defining Many to Many relation between roles and permissions

CREATE TABLE IF NOT EXISTS roles_permissions(
  id serial PRIMARY KEY,
  role_id int NOT NULL,
  permission_id int NOT NULL,
  CONSTRAINT fk_role_id FOREIGN key(role_id) REFERENCES roles(id),
  CONSTRAINT fk_permission_id FOREIGN key(permission_id) REFERENCES permissions(id)
);

-- Defining a stored procedure to add user with role

DROP PROCEDURE IF EXISTS addUser;


CREATE OR REPLACE PROCEDURE addUser(userName varchar, ROLE varchar) LANGUAGE PLPGSQL AS $$
DECLARE roleId int;
BEGIN
SELECT id INTO roleId FROM public.roles AS roles WHERE roles.name = role;
IF roleId IS NULL THEN
	INSERT INTO roles(name) VALUES(role);
	roleId := lastval();
END IF;
INSERT INTO public.users(name, role_id) VALUES(userName, roleId);
END;
$$;

-- Add Permission stored procedure

CREATE OR REPLACE PROCEDURE addPermission(roleName varchar, permissionName varchar) LANGUAGE PLPGSQL AS $$
DECLARE roleId int;
DECLARE permissionId int;
BEGIN
SELECT id into roleId from public.roles as roles where roles.name = roleName;
if roleId is null then
	insert into roles(name) values(roleName);
	roleId := lastval();
end if;
select id into permissionId from public.permissions as permissions where permissions.name = permissionName;
if permissionId is null then
	insert into permissions(name) values(permissionName);
	permissionId := lastval();
end if;

insert into public.roles_permissions(role_id, permission_id) values(roleId, permissionId);
end;
$$;

CALL addUser('waseem', 'admin');

CALL addUser('bilal', 'employee');

CALL addUser('raheel', 'employee');

CALL addPermission('admin', 'add_user') CALL addPermission('admin', 'view_user') CALL addPermission('employee', 'view_detail') CALL addPermission('admin', 'view_detail')
DROP VIEW IF EXISTS view_user_detail;


CREATE OR REPLACE VIEW view_user_detail AS
SELECT users.name AS name,
       roles.name AS ROLE,
       permissions.name AS permission
FROM public.users AS users
LEFT JOIN public.roles AS ROLES ON roles.id = users.role_id
LEFT JOIN public.permissions AS permissions ON permissions.id IN
  (SELECT permission_id
   FROM public.roles_permissions
   WHERE role_id = roles.id)
GROUP BY users.name,
         roles.name,
         permissions.name;


SELECT * FROM view_user_detail;