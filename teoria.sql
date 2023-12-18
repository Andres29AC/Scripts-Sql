--TODO Paquetes en Oracle
--Los paquetes son un conjunto de procedimientos, funciones y tipos definidos 
--por el usuario
--Los paquetes sirven para agrupar los objetos de un mismo tipo y para reutilizarlos
--Los paquetes se pueden compilar y almacenar en la base de datos
--Los paquetes pl/sql se dividen en 2 partes:
--Especificación o declaracion: define el nombre del paquete, los objetos 
--que contiene y sus especificaciones
--Implementación o body: define el código fuente de los objetos del paquete

--En Especificaciones:
--Puedo poneer Variables
--Puedo poner funciones
--Puedo poner procedimientos almacenados
--En el body:
--Implementare las funciones
--Implementare los procedimientos almacenados

--Creando un paquete
create or replace PACKAGE paquete1 is
    --Creando 2 variables
    variable1 number;
    variable2 varchar2(50);


end;
/
set serveroutput on;
--Creando el body del paquete
begin
    paquete1.variable1:=300;
    paquete1.variable2:='Andres';
    dbms_output.put_line(paquete1.variable1);
    dbms_output.put_line(paquete1.variable2);
end;

create or replace PACKAGE paquete2 IS
    --Creando variables
    variable1 number := 100;
    variable2 varchar2(50);
    --Asignando un procedimiento almacenado
    PROCEDURE saludo1(val_nombre VARCHAR);
    --Asignando una funcion
    FUNCTION despedida1(val_nombre VARCHAR) RETURN VARCHAR;
end;
/
--Creando el body del paquete
create or replace PACKAGE body paquete2 
is 
--Todo lo que esta dentro de body es privado
    --Implementando el procedimiento almacenado
    PROCEDURE saludo1(val_nombre VARCHAR) IS
    BEGIN
        dbms_output.put_line('Hola '||val_nombre);
    END;
    --Implementando la funcion
    FUNCTION despedida1(val_nombre VARCHAR) RETURN VARCHAR 
    IS  
    BEGIN
        RETURN 'Adios '||val_nombre;
    END;
end;
/
--Ejecutando el procedimiento almacenado
begin
    paquete2.variable2:='Andres Lion';
    paquete2.saludo1('Andres');
    dbms_output.put_line(paquete2.despedida1('Andres'));
end;

--TODO Elimitar un paquete
drop package paquete1;
--ELiminando el body del paquete
drop package body paquete2;

--TODO Example de paquete1
--Crear un paquete en Oracle con nombre pack1 con 2 variables,
--una de tipo numerica y otra de tipo cadena
--Posteriormente crear un bloque PL/SQL iniciar las variables y imprimir sus valores
create or replace package pack1 is
    variable1 number;
    variable2 varchar2(50);
end;
/
set serveroutput on
begin
    pack1.variable1:=100;
    pack1.variable2:='Mensaje';
    dbms_output.put_line(pack1.variable1);
    dbms_output.put_line(pack1.variable2);
end;
--TODO Example de paquete2
--Crear un paquete en Oracle con nombre pack2 con 1 variable numerica
--con un valor inicial de 10
--Posteriormente crear un bloque PL/SQLen la cual va actualizar su valor
--incrementandolo de 10 en 10







--TODO Transacciones:commit,rollback,savepoint
--roolback: deshace los cambios realizados en la base de datos
--commit: confirma los cambios realizados en la base de datos
--savepoint: permite volver a un punto anterior de la transacción
--Una transacción es un conjunto de sentencias que se ejecutan como una sola unidad


--TODO Triggers
--Tipos de triggers:
--Triggers por sentencia
--Los triggers por sentencia se ejecutan una vez asi se modifiquen
--un monton dde datos 
--Triggers por fila(row)
--Los triggers por fila se ejecutaran de acuerdo al numero de filas 
-- afectadas 
--Los triggers sirven para realizar acciones automaticas en la base de datos

--TODO Ejemplo1 de Triggers
--Creando una tabla llamada LOG_TABLE
--Tabla detectora
create table log_table(
    LOG_COLUMN varchar2(200),
    USER_NAME varchar2(50)
);
--Seleccionando la tabla
select * from log_table;
--Inicializando el trigger
--Este TRIGGER es a nivel statement o a nivel consulta
--Creando un trigger
create or replace trigger insertar_Regiones
--Se ejecutara despues de que se haya insertado en la tabla regiones
after insert on REGIONS
--Creando el cuerpo del trigger
begin
    --Insertando en la tabla log_table
    insert into log_table values('Insercion en la tabla regiones',user);
end;
--Finalizando el trigger
--after --despues
--before --antes
select user from dual;

--Eliminando el trigger
drop trigger insertar_empleado;

--Selec a regions
select * from regions;

--Insertando en regions
insert into regions values(10,'Atlantida');
insert into regions values(11,'Narnia');
COMMIT;

select * from log_table;


--TODO Ejemplo2 de Triggers
--Inicializando el trigger
--Este TRIGGER es a nivel statement o a nivel consulta
--Creando un trigger
create or replace trigger insertar_Regiones2
--Se ejecutara antes de que se haya insertado en la tabla regiones
 before insert on REGIONS
--Creando el cuerpo del trigger
begin
    --Si ingresa un usuario diferente a 'HR' me lanzara un error
    if user <> 'HR' THEN
        RAISE_APPLICATION_ERROR(-20000,'Solo user HR puede insertar');
    else
        --Insertando en la tabla log_table
        INSERT INTO log_table VALUES('Insercion en la tabla regiones',user);
    end if;
end;

--Insertando en regions
insert into regions values(14,'Grand Line');
insert into regions values(15,'One Piece');
COMMIT;

select user from dual;

SELECT * FROM log_table;

--Selec a regions
select * from regions;

--TODO Ejemplo3 de Triggers
--Crear un Trigger que impida que un usuario difiere de HR pueda insertar
--modificar o eliminar en la tabla regions
--Inicializando el trigger
--Este TRIGGER es a nivel statement o a nivel consulta
--Creando un trigger
create or replace trigger insertar_Regiones3
--Se ejecutara antes de que se haya insertado en la tabla regiones
 before insert or update or delete on REGIONS
--Creando el cuerpo del trigger
begin
    --Si ingresa un usuario diferente a 'HR' me lanzara un error
    if user <> 'HR' THEN
        RAISE_APPLICATION_ERROR(-20000,'Solo user HR puede insertar,modificar o eliminar');
    else
        --Insertando en la tabla log_table
        INSERT INTO log_table VALUES('Insercion en la tabla regiones',user);
    end if;
end;

truncate table log_table;

select * from regions;

---Eliminando con otro usuario
delete from HR.REGIONS where region_id=11;
--Actualizando con otro usuario
update HR.REGIONS set region_name='Atlantida' where region_id=10;
COMMIT;

--TODO Ejemplo4 de Triggers
--Creando un trigger
create or replace trigger insertar_Regiones4
--Se ejecutara antes de que se haya insertado en la tabla regiones
before insert or update or delete on REGIONS
--Creando el cuerpo del trigger
begin
    --Si ingresa un usuario diferente a 'HR' me lanzara un error
    if user <> 'HR' THEN
        RAISE_APPLICATION_ERROR(-20000,'Solo user HR puede insertar,modificar o eliminar');
    else
        if inserting then
            --Insertando en la tabla log_table
            INSERT INTO log_table VALUES('Insercion en la tabla regiones',user);
        end if;
        if deleting then
            --Insertando en la tabla log_table
            INSERT INTO log_table VALUES('Eliminacion en la tabla regiones',user);
        end if;
        if updating('REGION_ID') then
            --Insertando en la tabla log_table
            INSERT INTO log_table VALUES('Actualizacion en la tabla regiones (REGION_ID)',user);
        end if;
        if updating('REGION_NAME') then
            --Insertando en la tabla log_table
            INSERT INTO log_table VALUES('Actualizacion en la tabla regiones (REGION_NAME)',user);
        end if;
    end if;
end;

--TODO Ejemplo5 de Triggers
--Modificar el trigger TR2_REGION ahora debe ejecutar el trigger
-- cada vez que manipulen los registros (for each row),
--en las operaicones de insert, update y delete (REGION_NAME, REGION_ID) de
--datos en la tabla REGIONS,registrar las operaciones en la tabla LOG_TABLE
--e indicar el usuario que realizo los cambios.
--Cuando se realiza una insercion o modificacion los datos de la columna
--REGION_NAME deben ser convertidos a mayusculas
--Inicializando el trigger
--Este TRIGGER es a nivel statement o a nivel filas o row 
--Creando un trigger
create or replace trigger TR2_REGION
--Se ejecutara antes de que se haya insertado en la tabla regiones
before insert or update or delete on REGIONS
for each row
--Creando el cuerpo del trigger
begin
    if inserting then
        :new.REGION_NAME := upper(:new.REGION_NAME);
        --Insertando en la tabla log_table
        INSERT INTO log_table VALUES('Insercion',user);
    end if;
    if updating ('REGION_NAME') then
        :new.REGION_NAME := upper(:new.REGION_NAME);
        --Insertando en la tabla log_table
        INSERT INTO log_table VALUES('Actualizacion de REGION_NAME',user);
    end if;
    if updating ('REGION_ID') then
        --Insertando en la tabla log_table
        INSERT INTO log_table VALUES('Actualizacion de REGION_ID',user);
    end if;
    if deleting then
        --Insertando en la tabla log_table
        INSERT INTO log_table VALUES('Eliminacion',user);
    end if;
end;

--TODO Ejemplo6 de Triggers
--Modificar el trigger TR2_REGION y agregarle una clausula global
--para que permita registrar datos en la tabla LOG_TABLE, en la
--cual el nuevo dato REGION_ID debe ser mayor que 1000

--Inicializando el trigger
--Este TRIGGER es a nivel statement o a nivel filas o row
--Creando un trigger
create or replace trigger TR2_REGION
--Se ejecutara antes de que se haya insertado en la tabla regiones
before insert or update or delete on REGIONS
for each row
when (:new.REGION_ID > 1000)
--Creando el cuerpo del trigger
begin
    if inserting then
        :new.REGION_NAME := upper(:new.REGION_NAME);
        --Insertando en la tabla log_table
        INSERT INTO log_table VALUES('Insercion',user);
    end if;
    if updating ('REGION_NAME') then
        :new.REGION_NAME := upper(:new.REGION_NAME);
        --Insertando en la tabla log_table
        INSERT INTO log_table VALUES('Actualizacion de REGION_NAME',user);
    end if;
    if updating ('REGION_ID') then
        --Insertando en la tabla log_table
        INSERT INTO log_table VALUES('Actualizacion de REGION_ID',user);
    end if;
    if deleting then
        --Insertando en la tabla log_table
        INSERT INTO log_table VALUES('Eliminacion',user);
    end if;
end;

--TODO Ejemplo7 de Triggers
--Eliminar el trigger TR2_REGION
--Crear el TRIGGER TR3_REGION que sea de tipo  compuesto(Compound Trigger)
--en al cual se ejecute cuando se realcen los eventos de insert, update y delete
--y a su vez debe controlar los eventos BEFORE y AFTER
--Cosiderar dentro del trigger las sentencias a nivel comando (statement) y
--a nivel filas (row)
--Inicializando el trigger
--Este TRIGGER es a nivel statement o a nivel filas o row
--Creando un trigger
create or replace trigger TR3_REGION
--Se ejecutara antes de que se haya insertado en la tabla regiones
before insert or update or delete on REGIONS
compound trigger
--Creando el cuerpo del trigger
    before statement is begin
        insert into log_table values('Antes de la sentencia',user);
    end before statement;
    after statement is begin
        insert into log_table values('Despues de la sentencia',user);
    end after statement;
    before row is begin
        insert into log_table values('Antes de la fila',user);
    end before row;
    after row is begin
        insert into log_table values('Despues de la fila',user);
    end after row;
end;
----------------------------------------------------------------------------------------
--TODO Pregunta1 de examen
--Crear un TRIGGER BEFORE UPDATE de la columna SALARY de la de tipo EACH ROW.
--El trigger tiene como nombre TR_SALARY.
--Si el salario nuevo es menor que el salario antiguo el trigger
--debe disparar un RAISE_APPLICATION_ERROR con el siguiente mensaje:
--"No se puede bajar un salario"
--Si el salario nuevo es mayor al salario antiguo entonces debemos registrar en la
--tabla auditoria el nombre de usuario,fecha de sistema,el salario antigua y el salario nuevo
--Realizar 2 update y verificar el funcionamiento del trigger.
--Nota:Usar el :NEW.SALARY y :OLD.SALARY
--Creando la tabla auditoria
create table auditoria(
    usuario varchar2(50),
    fecha date,
    salario_antiguo number,
    salario_nuevo number
);
--Eliminar la tabla auditoria
select * from auditoria;

--Creando un trigger
create or replace trigger TR_SALARY
--Se ejecutara antes de que se haya insertado en la tabla regiones
before update of SALARY on EMPLOYEES
for each row
--Creando el cuerpo del trigger
begin
    if :new.SALARY < :old.SALARY then
        RAISE_APPLICATION_ERROR(-20000,'No se puede bajar un salario');
    else
        insert into auditoria values(user,sysdate,:old.SALARY,:new.SALARY);
    end if;
end;
--Relizar 2 update y verificar el funcionamiento del trigger
update employees set salary = 22000 where employee_id = 100;
update employees set salary = 26000 where employee_id = 100;
commit;


--TODO Pregunta2 de examen
--Crear un trigger de nombre TG_JOBS en la cual verifique antes de realizar
--la insercion el salario minimo es menor o igual al salario mayor,caso contrario
--lanzar una debe disparar un RAISE_APPLICATION_ERROR con el siguiente mensaje:
--"El salario minimo no puede ser mayor al salario maximo"
--Posterirmente ingresar los siguientes datos en la tabla JOBS
--y verificar el funcionamiento del trigger
create or replace trigger TG_JOBS
before insert on JOBS
for each row
begin
    if :new.MIN_SALARY > :new.MAX_SALARY then
        RAISE_APPLICATION_ERROR(-20000,'El salario minimo no puede ser mayor al salario maximo');
    end if;
end;

--Select de la tabla jobs
select * from jobs;

--Insertando datos en la tabla JOBS
insert into jobs values('Z1_DEM', 'PRUEBA1', 1000, 2000);
insert into jobs values('Z2_DEM', 'PRUEBA2', 1500, 2500);
insert into jobs values('Z3_DEM', 'PRUEBA3', 2000, 300);
--TODO Pregunta 3
--Crear un paquete con nombre PKG_EMPLEADOS en la cual va a gestionar el registro
--de datos de la tabla EMPLOYEES, se implementaran los siguientes metodo:
--TODO Procedimiento almacenado SP_EMPLOYEES_INSERT, si el registro fue correcto imprimir en
--consola el resultado, caso contrario lanzar una excepción imprimiendo en consola el
--resultado.
--TODO Procedimiento almacenado SP_EMPLOYEES_UPDATE, si el registro fue correcto imprimir en
--consola el resultado, caso contrario lanzar una excepción imprimiendo en consola el
--resultado.
--TODO Procedimiento almacenado SP_EMPLOYEES_DELETE, si el registro fue correcto imprimir en
--consola el resultado, caso contrario lanzar una excepción imprimiendo en consola el
--resultado.
--TODO Función almacenada SF_EMPLOYEES_SALARY que retornará un cursor, el cursor deberá
--retornar el siguiente resultado SQL: “Mostrar el Código, el nombre y apellidos de todos los
--empleados que ganan por encima del salario promedio. Ordene los resultados en orden
--descendente de salario. 

select * from employees;
create or replace PACKAGE PKG_EMPLEADOS IS
    --Metodo1 Procedimiento1
    --Asignando un procedimiento almacenado
    PROCEDURE SP_EMPLOYEES_INSERT(
        empleado_id IN EMPLOYEES.EMPLOYEE_ID%TYPE,
        primer_nombre IN EMPLOYEES.FIRST_NAME%TYPE,
        apellidos IN EMPLOYEES.LAST_NAME%TYPE,
        email IN EMPLOYEES.EMAIL%TYPE,
        numero_telefono IN EMPLOYEES.PHONE_NUMBER%TYPE,
        fecha_contratacion IN EMPLOYEES.HIRE_DATE%TYPE,
        trabajo_id IN EMPLOYEES.JOB_ID%TYPE,
        salario IN EMPLOYEES.SALARY%TYPE,
        comision_pct IN EMPLOYEES.COMMISSION_PCT%TYPE,
        gerente_id IN EMPLOYEES.MANAGER_ID%TYPE,
        departamento_id IN EMPLOYEES.DEPARTMENT_ID%TYPE
    );
    --Metodo2 Procedimiento2
    --Asignando un procedimiento almacenado
    PROCEDURE SP_EMPLOYEES_UPDATE(
        empleado_id IN EMPLOYEES.EMPLOYEE_ID%TYPE,
        primer_nombre IN EMPLOYEES.FIRST_NAME%TYPE,
        apellidos IN EMPLOYEES.LAST_NAME%TYPE,
        email IN EMPLOYEES.EMAIL%TYPE,
        numero_telefono IN EMPLOYEES.PHONE_NUMBER%TYPE,
        fecha_contratacion IN EMPLOYEES.HIRE_DATE%TYPE,
        trabajo_id IN EMPLOYEES.JOB_ID%TYPE,
        salario IN EMPLOYEES.SALARY%TYPE,
        comision_pct IN EMPLOYEES.COMMISSION_PCT%TYPE,
        gerente_id IN EMPLOYEES.MANAGER_ID%TYPE,
        departamento_id IN EMPLOYEES.DEPARTMENT_ID%TYPE
    );
    --Metodo3 Procedimiento3
    --Asignando un procedimiento almacenado
    PROCEDURE SP_EMPLOYEES_DELETE(
        empleado_id IN EMPLOYEES.EMPLOYEE_ID%TYPE
    );
    --Metodo4 Funcion
    --Asignando una funcion almacenada
    FUNCTION SF_EMPLOYEES_SALARY RETURN SYS_REFCURSOR;
END PKG_EMPLEADOS;

set serveroutput on;
create or replace package  body PKG_EMPLEADOS as
    procedure SP_EMPLOYEES_INSERT(
        empleado_id IN EMPLOYEES.EMPLOYEE_ID%TYPE,
        primer_nombre IN EMPLOYEES.FIRST_NAME%TYPE,
        apellidos IN EMPLOYEES.LAST_NAME%TYPE,
        email IN EMPLOYEES.EMAIL%TYPE,
        numero_telefono IN EMPLOYEES.PHONE_NUMBER%TYPE,
        fecha_contratacion IN EMPLOYEES.HIRE_DATE%TYPE,
        trabajo_id IN EMPLOYEES.JOB_ID%TYPE,
        salario IN EMPLOYEES.SALARY%TYPE,
        comision_pct IN EMPLOYEES.COMMISSION_PCT%TYPE,
        gerente_id IN EMPLOYEES.MANAGER_ID%TYPE,
        departamento_id IN EMPLOYEES.DEPARTMENT_ID%TYPE
    ) IS
    BEGIN
        insert into employees values(
            empleado_id,
            primer_nombre,
            apellidos,
            email,
            numero_telefono,
            fecha_contratacion,
            trabajo_id,
            salario,
            comision_pct,
            gerente_id,
            departamento_id
        );
        dbms_output.put_line('Registro insertado correctamente');
        exception
            when others then
                dbms_output.put_line('Error al insertar el registro');
    END SP_EMPLOYEES_INSERT;
    procedure SP_EMPLOYEES_UPDATE(
        empleado_id IN EMPLOYEES.EMPLOYEE_ID%TYPE,
        primer_nombre IN EMPLOYEES.FIRST_NAME%TYPE,
        apellidos IN EMPLOYEES.LAST_NAME%TYPE,
        email IN EMPLOYEES.EMAIL%TYPE,
        numero_telefono IN EMPLOYEES.PHONE_NUMBER%TYPE,
        fecha_contratacion IN EMPLOYEES.HIRE_DATE%TYPE,
        trabajo_id IN EMPLOYEES.JOB_ID%TYPE,
        salario IN EMPLOYEES.SALARY%TYPE,
        comision_pct IN EMPLOYEES.COMMISSION_PCT%TYPE,
        gerente_id IN EMPLOYEES.MANAGER_ID%TYPE,
        departamento_id IN EMPLOYEES.DEPARTMENT_ID%TYPE
    ) IS
    BEGIN
        update employees set
            first_name = primer_nombre,
            last_name = apellidos,
            email = email,
            phone_number = numero_telefono,
            hire_date = fecha_contratacion,
            job_id = trabajo_id,
            salary = salario,
            commission_pct = comision_pct,
            manager_id = gerente_id,
            department_id = departamento_id
        where employee_id = empleado_id;
        dbms_output.put_line('Registro actualizado correctamente');
        exception
            when others then
                dbms_output.put_line('Error al actualizar el registro');
    END SP_EMPLOYEES_UPDATE;
    procedure SP_EMPLOYEES_DELETE(
        empleado_id IN EMPLOYEES.EMPLOYEE_ID%TYPE
    ) IS
    BEGIN
        delete from employees where employee_id = empleado_id;
        dbms_output.put_line('Registro eliminado correctamente');
        exception
            when others then
                dbms_output.put_line('Error al eliminar el registro');
    END SP_EMPLOYEES_DELETE;
    function SF_EMPLOYEES_SALARY return SYS_REFCURSOR is
        cursor_salario SYS_REFCURSOR;
    BEGIN
        open cursor_salario for
            select employee_id, salary from employees;
        return cursor_salario;
    END SF_EMPLOYEES_SALARY;
END PKG_EMPLEADOS;
--Comprobar el funcionamiento de los procedimientos almacenados
--Metodo1 Procedimiento1
--Asignando un procedimiento almacenado
declare
    v_empleado_id employees.employee_id%type;
    v_primer_nombre employees.first_name%type;
    v_apellidos employees.last_name%type;
    v_email employees.email%type;
    v_numero_telefono employees.phone_number%type;
    v_fecha_contratacion employees.hire_date%type;
    v_trabajo_id employees.job_id%type;
    v_salario employees.salary%type;
    v_comision_pct employees.commission_pct%type;
    v_gerente_id employees.manager_id%type;
    v_departamento_id employees.department_id%type;
begin
    v_empleado_id := 207;
    v_primer_nombre := 'Juan';
    v_apellidos := 'Perez';
    v_email := 'Juan43@gmail.com';
    v_numero_telefono := '123456789';
    v_fecha_contratacion := to_date('01/01/2020','dd/mm/yyyy');
    v_trabajo_id := 'IT_PROG';
    v_salario := 1000;
    v_comision_pct := 0.1;
    v_gerente_id := 100;
    v_departamento_id := 60;
    pkg_empleados.sp_employees_insert(
        v_empleado_id,
        v_primer_nombre,
        v_apellidos,
        v_email,
        v_numero_telefono,
        v_fecha_contratacion,
        v_trabajo_id,
        v_salario,
        v_comision_pct,
        v_gerente_id,
        v_departamento_id
    );
end;
select * from employees;
--Eliminar el paquete
drop package pkg_empleados;
---Eliminar a juan perez
delete from employees where employee_id = 207;

--Ahora para actualizar un registro
declare
    v_empleado_id employees.employee_id%type;
    v_primer_nombre employees.first_name%type;
    v_apellidos employees.last_name%type;
    v_email employees.email%type;
    v_numero_telefono employees.phone_number%type;
    v_fecha_contratacion employees.hire_date%type;
    v_trabajo_id employees.job_id%type;
    v_salario employees.salary%type;
    v_comision_pct employees.commission_pct%type;
    v_gerente_id employees.manager_id%type;
    v_departamento_id employees.department_id%type;
begin
    v_empleado_id := 207;
    v_primer_nombre := 'Steven';
    v_apellidos := 'King';
    v_email := 'Steven34@gmail.com';
    v_numero_telefono := '987654321';
    v_fecha_contratacion := to_date('01/01/2020','dd/mm/yyyy');
    v_trabajo_id := 'IT_PROG';
    v_salario := 1000;
    v_comision_pct := 0.1;
    v_gerente_id := 100;
    v_departamento_id := 60;
    pkg_empleados.sp_employees_update(
        v_empleado_id,
        v_primer_nombre,
        v_apellidos,
        v_email,
        v_numero_telefono,
        v_fecha_contratacion,
        v_trabajo_id,
        v_salario,
        v_comision_pct,
        v_gerente_id,
        v_departamento_id
    );
end;

--TODO Pregunta 4
--Crear una vista con el nombre V_GENERAL_REPORT_SALARIES que muestre la cantidad 
--de empleados que ingresaron en cada año, el costo del salario mensual, anual y 
--el salario promedio (redondeado a dos decimales) por cada año, el año será 
--ordenado de ascendente.
--Creando una vista
create or replace view V_GENERAL_REPORT_SALARIES as
select
    to_char(hire_date,'YYYY') as year,
    count(*) as employees,
    round(sum(salary)/12,2) as monthly_salary,
    round(sum(salary),2) as annual_salary,
    round(avg(salary),2) as average_salary
from employees
group by to_char(hire_date,'YYYY')
order by to_char(hire_date,'YYYY') asc;


--eleiminando una vista
drop view V_GENERAL_REPORT_SALARIES;
reate or replace view V_GENERAL_REPORT_SALARIES as
select
    to_char(hire_date,'YYYY') as year,
    count(*) as employees,
    round(sum(salary)/12,2) as monthly_salary,
    round(sum(salary),2) as annual_salary,
    round(avg(salary),2) as average_salary
from employees
group by to_char(hire_date,'YYYY')
order by to_char(hire_date,'YYYY') asc;

create or replace view V_GENERAL_REPORT_SALARIES as
select
    to_char(hire_date,'YYYY') as AÑO,
    count(*) as CANTIDAD_EMPLEADOS,
    round(sum(salary),2) as PLANILLA_MENSUAL,
    round(sum(salary)*12,2) as PLANILLA_ANUAL,
    round(avg(salary),2) as SALARIO_PROMEDIO_MENSUAL
from employees
group by to_char(hire_date,'YYYY')
order by to_char(hire_date,'YYYY') asc;

--------------------------------------------------------------------------------------










