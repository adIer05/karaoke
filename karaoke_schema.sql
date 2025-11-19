/*==============================================================*/
/* DBMS name:      PostgreSQL 9.x                               */
/* Created on:     19/11/2025 11:47:22                          */
/*==============================================================*/


drop index CUSTOMER_PK;

drop table CUSTOMER;

drop index MEMBER_PK;

drop table MEMBER;

drop index PAYMENT_PK;

drop table PAYMENT;

drop index PICK_FK;

drop index PICK2_FK;

drop table PICK;

drop index RESULTS_PAYMENT_REGISTRATION_FK;

drop index MAKE_REGISTRATION_FK;

drop index REGISTRATION_PK;

drop table REGISTRATION;

drop index RESULTS_PAYMENT_RESERVATION_FK;

drop index MAKE_RESERVATION_FK;

drop index RESERVATION_PK;

drop table RESERVATION;

drop index ASSIGNED_FOR_REGISTRATION_FK;

drop index ASSIGNED_FOR_RESERVATION_FK;

drop index ROOM_PK;

drop table ROOM;

drop index SONGS_PK;

drop table SONGS;

drop index RECORDED_IN_FK;

drop index SONG_ACTIVITIES_PK;

drop table SONG_ACTIVITIES;

drop index REG_HAS_EXTENSION_FK;

drop index RES_HAS_EXTENSION_FK;

drop index TIME_EXTEND_PK;

drop table TIME_EXTEND;

/*==============================================================*/
/* Table: CUSTOMER                                              */
/*==============================================================*/
create table CUSTOMER (
   CUSTOMER_ID          SERIAL               not null,
   NO_PHONE             VARCHAR(13)          null,
   NAME                 VARCHAR(80)          null,
   PEOPLE_COMING        INT4                 null,
   constraint PK_CUSTOMER primary key (CUSTOMER_ID)
);

/*==============================================================*/
/* Index: CUSTOMER_PK                                           */
/*==============================================================*/
create unique index CUSTOMER_PK on CUSTOMER (
CUSTOMER_ID
);

/*==============================================================*/
/* Table: MEMBER                                                */
/*==============================================================*/
create table MEMBER (
   CUSTOMER_ID          SERIAL               not null,
   MEMBER_STATUS        VARCHAR(9)           null,
   NUMBER_OF_VISITS     INT4                 null,
   DISCOUNT_MEMBER      FLOAT8               null,
   constraint PK_MEMBER primary key (CUSTOMER_ID)
);

/*==============================================================*/
/* Index: MEMBER_PK                                             */
/*==============================================================*/
create unique index MEMBER_PK on MEMBER (
CUSTOMER_ID
);

/*==============================================================*/
/* Table: PAYMENT                                               */
/*==============================================================*/
create table PAYMENT (
   PAYMENT_ID           SERIAL               not null,
   PAYMENT_TIME         DATE                 null,
   PAYMENT_METHOD       VARCHAR(10)          null,
   TOTAL_COST           NUMERIC(8,2)         null,
   DISCOUNT_MEMBER      FLOAT8               null,
   FINAL_COST           NUMERIC(8,2)         null,
   constraint PK_PAYMENT primary key (PAYMENT_ID)
);

/*==============================================================*/
/* Index: PAYMENT_PK                                            */
/*==============================================================*/
create unique index PAYMENT_PK on PAYMENT (
PAYMENT_ID
);

/*==============================================================*/
/* Table: PICK                                                  */
/*==============================================================*/
create table PICK (
   SONGS_ID             INT4                 not null,
   ACTIVITY_ID          INT4                 not null
);

/*==============================================================*/
/* Index: PICK2_FK                                              */
/*==============================================================*/
create  index PICK2_FK on PICK (
ACTIVITY_ID
);

/*==============================================================*/
/* Index: PICK_FK                                               */
/*==============================================================*/
create  index PICK_FK on PICK (
SONGS_ID
);

/*==============================================================*/
/* Table: REGISTRATION                                          */
/*==============================================================*/
create table REGISTRATION (
   CUSTOMER_ID          INT4                 not null,
   ID_TRANSAKSI2        SERIAL               not null,
   PAYMENT_ID           INT4                 not null,
   DATE                 DATE                 null,
   START_TIME           DATE                 null,
   END_TIME             DATE                 null,
   REGISTRATION_STATUS  VARCHAR(20)          null,
   constraint PK_REGISTRATION primary key (ID_TRANSAKSI2)
);

/*==============================================================*/
/* Index: REGISTRATION_PK                                       */
/*==============================================================*/
create unique index REGISTRATION_PK on REGISTRATION (
ID_TRANSAKSI2
);

/*==============================================================*/
/* Index: MAKE_REGISTRATION_FK                                  */
/*==============================================================*/
create  index MAKE_REGISTRATION_FK on REGISTRATION (
CUSTOMER_ID
);

/*==============================================================*/
/* Index: RESULTS_PAYMENT_REGISTRATION_FK                       */
/*==============================================================*/
create  index RESULTS_PAYMENT_REGISTRATION_FK on REGISTRATION (
PAYMENT_ID
);

/*==============================================================*/
/* Table: RESERVATION                                           */
/*==============================================================*/
create table RESERVATION (
   CUSTOMER_ID          INT4                 not null,
   RESERVATION_ID       SERIAL               not null,
   PAYMENT_ID           INT4                 not null,
   DATE                 DATE                 null,
   START_TIME           DATE                 null,
   END_TIME             DATE                 null,
   RESERVATION_DATE     DATE                 null,
   PCT_DP               FLOAT8               null,
   PAID_DP              NUMERIC(8,2)         null,
   LATE                 BOOL                 null,
   constraint PK_RESERVATION primary key (RESERVATION_ID)
);

/*==============================================================*/
/* Index: RESERVATION_PK                                        */
/*==============================================================*/
create unique index RESERVATION_PK on RESERVATION (
RESERVATION_ID
);

/*==============================================================*/
/* Index: MAKE_RESERVATION_FK                                   */
/*==============================================================*/
create  index MAKE_RESERVATION_FK on RESERVATION (
CUSTOMER_ID
);

/*==============================================================*/
/* Index: RESULTS_PAYMENT_RESERVATION_FK                        */
/*==============================================================*/
create  index RESULTS_PAYMENT_RESERVATION_FK on RESERVATION (
PAYMENT_ID
);

/*==============================================================*/
/* Table: ROOM                                                  */
/*==============================================================*/
create table ROOM (
   ID_TRANSAKSI2        INT4                 not null,
   RESERVATION_ID       INT4                 not null,
   PAYMENT_ID2          SERIAL               not null,
   ROOM_TYPE            VARCHAR(10)          null,
   CAPACITTY            INT4                 null,
   HOURLY_RATE          NUMERIC(8,2)         null,
   STATUS               VARCHAR(20)          null,
   constraint PK_ROOM primary key (PAYMENT_ID2)
);

/*==============================================================*/
/* Index: ROOM_PK                                               */
/*==============================================================*/
create unique index ROOM_PK on ROOM (
PAYMENT_ID2
);

/*==============================================================*/
/* Index: ASSIGNED_FOR_RESERVATION_FK                           */
/*==============================================================*/
create  index ASSIGNED_FOR_RESERVATION_FK on ROOM (
RESERVATION_ID
);

/*==============================================================*/
/* Index: ASSIGNED_FOR_REGISTRATION_FK                          */
/*==============================================================*/
create  index ASSIGNED_FOR_REGISTRATION_FK on ROOM (
ID_TRANSAKSI2
);

/*==============================================================*/
/* Table: SONGS                                                 */
/*==============================================================*/
create table SONGS (
   SONGS_ID             SERIAL               not null,
   TITLE                VARCHAR(250)         null,
   ARTIST               VARCHAR(80)          null,
   GENRE                VARCHAR(25)          null,
   LANGUAGE             VARCHAR(25)          null,
   DURATION             TIME                 null,
   LYRICS               TEXT                 null,
   constraint PK_SONGS primary key (SONGS_ID)
);

/*==============================================================*/
/* Index: SONGS_PK                                              */
/*==============================================================*/
create unique index SONGS_PK on SONGS (
SONGS_ID
);

/*==============================================================*/
/* Table: SONG_ACTIVITIES                                       */
/*==============================================================*/
create table SONG_ACTIVITIES (
   ACTIVITY_ID          SERIAL               not null,
   CUSTOMER_ID          CHAR(10)             not null,
   SONG_START_TIME      DATE                 null,
   PLAYED_DURATION      TIME                 null,
   PLAYED_PERCENTAGE    FLOAT8               null,
   constraint PK_SONG_ACTIVITIES primary key (ACTIVITY_ID)
);

/*==============================================================*/
/* Index: SONG_ACTIVITIES_PK                                    */
/*==============================================================*/
create unique index SONG_ACTIVITIES_PK on SONG_ACTIVITIES (
ACTIVITY_ID
);

/*==============================================================*/
/* Index: RECORDED_IN_FK                                        */
/*==============================================================*/
create  index RECORDED_IN_FK on SONG_ACTIVITIES (
CUSTOMER_ID
);

/*==============================================================*/
/* Table: TIME_EXTEND                                           */
/*==============================================================*/
create table TIME_EXTEND (
   ID_TRANSAKSI2        INT4                 not null,
   RESERVATION_ID       INT4                 not null,
   EXTEND_ID            SERIAL               not null,
   EXTENSION_DURATION   TIME                 null,
   EXTENSION_COST       NUMERIC(8,2)         null,
   constraint PK_TIME_EXTEND primary key (EXTEND_ID)
);

/*==============================================================*/
/* Index: TIME_EXTEND_PK                                        */
/*==============================================================*/
create unique index TIME_EXTEND_PK on TIME_EXTEND (
EXTEND_ID
);

/*==============================================================*/
/* Index: RES_HAS_EXTENSION_FK                                  */
/*==============================================================*/
create  index RES_HAS_EXTENSION_FK on TIME_EXTEND (
RESERVATION_ID
);

/*==============================================================*/
/* Index: REG_HAS_EXTENSION_FK                                  */
/*==============================================================*/
create  index REG_HAS_EXTENSION_FK on TIME_EXTEND (
ID_TRANSAKSI2
);

alter table MEMBER
   add constraint FK_MEMBER_PART_OF_CUSTOMER foreign key (CUSTOMER_ID)
      references CUSTOMER (CUSTOMER_ID)
      on delete restrict on update restrict;

alter table PICK
   add constraint FK_PICK_PICK_SONGS foreign key (SONGS_ID)
      references SONGS (SONGS_ID)
      on delete restrict on update restrict;

alter table PICK
   add constraint FK_PICK_PICK2_SONG_ACT foreign key (ACTIVITY_ID)
      references SONG_ACTIVITIES (ACTIVITY_ID)
      on delete restrict on update restrict;

alter table REGISTRATION
   add constraint FK_REGISTRA_MAKE_REGI_CUSTOMER foreign key (CUSTOMER_ID)
      references CUSTOMER (CUSTOMER_ID)
      on delete restrict on update restrict;

alter table REGISTRATION
   add constraint FK_REGISTRA_RESULTS_P_PAYMENT foreign key (PAYMENT_ID)
      references PAYMENT (PAYMENT_ID)
      on delete restrict on update restrict;

alter table RESERVATION
   add constraint FK_RESERVAT_MAKE_RESE_CUSTOMER foreign key (CUSTOMER_ID)
      references CUSTOMER (CUSTOMER_ID)
      on delete restrict on update restrict;

alter table RESERVATION
   add constraint FK_RESERVAT_RESULTS_P_PAYMENT foreign key (PAYMENT_ID)
      references PAYMENT (PAYMENT_ID)
      on delete restrict on update restrict;

alter table ROOM
   add constraint FK_ROOM_ASSIGNED__REGISTRA foreign key (ID_TRANSAKSI2)
      references REGISTRATION (ID_TRANSAKSI2)
      on delete restrict on update restrict;

alter table ROOM
   add constraint FK_ROOM_ASSIGNED__RESERVAT foreign key (RESERVATION_ID)
      references RESERVATION (RESERVATION_ID)
      on delete restrict on update restrict;

alter table SONG_ACTIVITIES
   add constraint FK_SONG_ACT_RECORDED__CUSTOMER foreign key (CUSTOMER_ID)
      references CUSTOMER (CUSTOMER_ID)
      on delete restrict on update restrict;

alter table TIME_EXTEND
   add constraint FK_TIME_EXT_REG_HAS_E_REGISTRA foreign key (ID_TRANSAKSI2)
      references REGISTRATION (ID_TRANSAKSI2)
      on delete restrict on update restrict;

alter table TIME_EXTEND
   add constraint FK_TIME_EXT_RES_HAS_E_RESERVAT foreign key (RESERVATION_ID)
      references RESERVATION (RESERVATION_ID)
      on delete restrict on update restrict;

