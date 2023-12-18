--Stefan Andre Amaro Castillo
--Pregunta1
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
select * from auditoria;
select * from employees;

--Pregunta2
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

--Verificando la tabla jobs
select * from jobs;

--Pregunta3
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
--Ahora el body
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
    v_primer_nombre := 'Andre';
    v_apellidos := 'Amaro';
    v_email := 'Andre43@gmail.com';
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
    v_email := 'Andre43@gmail.com';
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
select * from employees;
--Pregunta 4
create or replace view V_GENERAL_REPORT_SALARIES as
select
    to_char(hire_date,'YYYY') as Año,
    count(*) as Cantidad_Empleados,
    round(sum(salary),2) as Planilla_Mensual,
    round(sum(salary)*12,2) as Plantilla_Anual,
    round(avg(salary),2) as Salario_Promedio_Mensual
from employees
group by to_char(hire_date,'YYYY')
order by to_char(hire_date,'YYYY') asc;

select * from V_GENERAL_REPORT_SALARIES;
