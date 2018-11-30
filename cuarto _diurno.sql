/*==============================================================*/
/* DBMS name:      Sybase SQL Anywhere 11                       */
/* Created on:     30/10/2018 8:48:38                           */
/*==============================================================*/


if exists(select 1 from sys.sysforeignkey where role='FK_PACIENTE_RELATIONS_CLINICA') then
    alter table PACIENTE
       delete foreign key FK_PACIENTE_RELATIONS_CLINICA
end if;

if exists(select 1 from sys.sysforeignkey where role='FK_PACIENTE_RELATIONS_MEDICO') then
    alter table PACIENTE
       delete foreign key FK_PACIENTE_RELATIONS_MEDICO
end if;

if exists(
   select 1 from sys.sysindex i, sys.systable t
   where i.table_id=t.table_id 
     and i.index_name='CLINICA_PK'
     and t.table_name='CLINICA'
) then
   drop index CLINICA.CLINICA_PK
end if;

if exists(
   select 1 from sys.systable 
   where table_name='CLINICA'
     and table_type in ('BASE', 'GBL TEMP')
) then
    drop table CLINICA
end if;

if exists(
   select 1 from sys.sysindex i, sys.systable t
   where i.table_id=t.table_id 
     and i.index_name='MEDICO_PK'
     and t.table_name='MEDICO'
) then
   drop index MEDICO.MEDICO_PK
end if;

if exists(
   select 1 from sys.systable 
   where table_name='MEDICO'
     and table_type in ('BASE', 'GBL TEMP')
) then
    drop table MEDICO
end if;

if exists(
   select 1 from sys.sysindex i, sys.systable t
   where i.table_id=t.table_id 
     and i.index_name='RELATIONSHIP_2_FK'
     and t.table_name='PACIENTE'
) then
   drop index PACIENTE.RELATIONSHIP_2_FK
end if;

if exists(
   select 1 from sys.sysindex i, sys.systable t
   where i.table_id=t.table_id 
     and i.index_name='RELATIONSHIP_1_FK'
     and t.table_name='PACIENTE'
) then
   drop index PACIENTE.RELATIONSHIP_1_FK
end if;

if exists(
   select 1 from sys.sysindex i, sys.systable t
   where i.table_id=t.table_id 
     and i.index_name='PACIENTE_PK'
     and t.table_name='PACIENTE'
) then
   drop index PACIENTE.PACIENTE_PK
end if;

if exists(
   select 1 from sys.systable 
   where table_name='PACIENTE'
     and table_type in ('BASE', 'GBL TEMP')
) then
    drop table PACIENTE
end if;

/*==============================================================*/
/* Table: CLINICA                                               */
/*==============================================================*/
create table CLINICA 
(
   CLI_RUC              char(13)                       not null,
   CLI_NOMBRE           char(30)                       not null,
   CLI_CAPACIDAD        integer                        not null,
   CLI_COSTO_DIA        numeric(8,2)                   not null,
   CLI_CATEGORIA        char(3)                        null,
   CLI_DIRECCION        varchar(80)                    not null,
   CLI_CIUDAD           char(30)                       not null,
   constraint PK_CLINICA primary key (CLI_RUC)
);

/*==============================================================*/
/* Index: CLINICA_PK                                            */
/*==============================================================*/
create unique index CLINICA_PK on CLINICA (
CLI_RUC ASC
);

/*==============================================================*/
/* Table: MEDICO                                                */
/*==============================================================*/
create table MEDICO 
(
   MED_MATRICULA        char(4)                        not null,
   MED_NOMBRE           char(30)                       not null,
   MED_APELLIDO         char(30)                       not null,
   MED_SEXO             char(1)                        not null,
   MED_TELEFONO         char(10)                       not null,
   MED_CIUDAD           char(30)                       not null,
   MED_EDAD             integer                        null,
   MED_ESPECIALIDAD     char(30)                       null,
   MED_SALARIO          numeric(8,2)                   null,
   constraint PK_MEDICO primary key (MED_MATRICULA)
);

/*==============================================================*/
/* Index: MEDICO_PK                                             */
/*==============================================================*/
create unique index MEDICO_PK on MEDICO (
MED_MATRICULA ASC
);

/*==============================================================*/
/* Table: PACIENTE                                              */
/*==============================================================*/
create table PACIENTE 
(
   PAC_CODIGO           char(6)                        not null,
   CLI_RUC              char(13)                       null,
   MED_MATRICULA        char(4)                        null,
   PAC_NOMBRE           char(30)                       not null,
   PAC_APELLIDO         char(30)                       not null,
   PAC_FECHA_NAC        date                           not null,
   PAC_FECHA_INGRESO    date                           not null,
   PAC_FECHA_SALIDA     date                           null,
   PAC_DIRECCION        varchar(80)                    null,
   PAC_CIUDAD           char(30)                       not null,
   PAC_TELEFONO         char(10)                       null,
   PAC_SEXO             char(1)                        not null,
   PAC_DIAGNOSTICO      varchar(100)                   null,
   constraint PK_PACIENTE primary key (PAC_CODIGO)
);

/*==============================================================*/
/* Index: PACIENTE_PK                                           */
/*==============================================================*/
create unique index PACIENTE_PK on PACIENTE (
PAC_CODIGO ASC
);

/*==============================================================*/
/* Index: RELATIONSHIP_1_FK                                     */
/*==============================================================*/
create index RELATIONSHIP_1_FK on PACIENTE (
CLI_RUC ASC
);

/*==============================================================*/
/* Index: RELATIONSHIP_2_FK                                     */
/*==============================================================*/
create index RELATIONSHIP_2_FK on PACIENTE (
MED_MATRICULA ASC
);

alter table PACIENTE
   add constraint FK_PACIENTE_RELATIONS_CLINICA foreign key (CLI_RUC)
      references CLINICA (CLI_RUC)
      on update restrict
      on delete restrict;

alter table PACIENTE
   add constraint FK_PACIENTE_RELATIONS_MEDICO foreign key (MED_MATRICULA)
      references MEDICO (MED_MATRICULA)
      on update restrict
      on delete restrict;

