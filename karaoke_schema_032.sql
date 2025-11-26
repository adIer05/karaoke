/*==============================================================*/
/* DBMS name:      PostgreSQL 9.x                               */
/* Created on:     19/11/2025 11:47:22                          */
/*==============================================================*/

drop index IF EXISTS CUSTOMER_PK;

drop table IF EXISTS CUSTOMER CASCADE;

drop index IF EXISTS MEMBER_PK;

drop table IF EXISTS MEMBER CASCADE;

drop index IF EXISTS PAYMENT_PK;

drop table IF EXISTS PAYMENT CASCADE;

drop index IF EXISTS PICK_FK;

drop index IF EXISTS PICK2_FK;

drop table IF EXISTS PICK CASCADE;

drop index IF EXISTS RESULTS_PAYMENT_REGISTRATION_FK;

drop index IF EXISTS MAKE_REGISTRATION_FK;

drop index IF EXISTS REGISTRATION_PK;

drop table IF EXISTS REGISTRATION CASCADE;

drop index IF EXISTS RESULTS_PAYMENT_RESERVATION_FK;

drop index IF EXISTS MAKE_RESERVATION_FK;

drop index IF EXISTS RESERVATION_PK;

drop table IF EXISTS RESERVATION CASCADE;

drop index IF EXISTS ASSIGNED_FOR_REGISTRATION_FK;

drop index IF EXISTS ASSIGNED_FOR_RESERVATION_FK;

drop index IF EXISTS ROOM_PK;

drop table IF EXISTS ROOM CASCADE;

drop index IF EXISTS SONGS_PK;

drop table IF EXISTS SONGS CASCADE;

drop index IF EXISTS RECORDED_IN_FK;

drop index IF EXISTS SONG_ACTIVITIES_PK;

drop table IF EXISTS SONG_ACTIVITIES CASCADE;

drop index IF EXISTS REG_HAS_EXTENSION_FK;

drop index IF EXISTS RES_HAS_EXTENSION_FK;

drop index IF EXISTS TIME_EXTEND_PK;

drop table IF EXISTS TIME_EXTEND CASCADE;

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
   CUSTOMER_ID          INT4                 not null,
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
   REGISTRATION_ID      INT4                 null,
   RESERVATION_ID       INT4                 null,
   PAYMENT_TIME         TIMESTAMP            null,
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
   REGISTRATION_ID      SERIAL               not null,
   CUSTOMER_ID          INT4                 not null,
   ROOM_ID              INT4                 not null,
   RG_DATE              DATE                 null,
   START_TIME           TIMESTAMP            null,
   END_TIME             TIMESTAMP            null,
   REGISTRATION_STATUS  VARCHAR(20)          null,
   constraint PK_REGISTRATION primary key (REGISTRATION_ID)
);

/*==============================================================*/
/* Index: REGISTRATION_PK                                       */
/*==============================================================*/
create unique index REGISTRATION_PK on REGISTRATION (
REGISTRATION_ID
);

/*==============================================================*/
/* Index: MAKE_REGISTRATION_FK                                  */
/*==============================================================*/
create  index MAKE_REGISTRATION_FK on REGISTRATION (
CUSTOMER_ID
);

/*==============================================================*/
/* Index: RESULTS_PAYMENT_REGISTRATION_FK                           */
/*==============================================================*/
create  index RESULTS_PAYMENT_REGISTRATION_FK on PAYMENT (
REGISTRATION_ID
);

/*==============================================================*/
/* Table: RESERVATION                                           */
/*==============================================================*/
create table RESERVATION (
   RESERVATION_ID       SERIAL               not null,
   CUSTOMER_ID          INT4                 not null,
   ROOM_ID              INT4                 not null,
   RV_DATE              DATE                 null,
   START_TIME           TIMESTAMP            null,
   END_TIME             TIMESTAMP            null,
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
/* Index: RESULTS_PAYMENT_RESERVATION_FK                            */
/*==============================================================*/
create  index RESULTS_PAYMENT_RESERVATION_FK on PAYMENT (
RESERVATION_ID
);

/*==============================================================*/
/* Table: ROOM                                                  */
/*==============================================================*/
create table ROOM (
   ROOM_ID              SERIAL               not null,
   ROOM_TYPE            VARCHAR(10)          null,
   CAPACITY             INT4                 null,
   HOURLY_RATE          NUMERIC(8,2)         null,
   STATUS               VARCHAR(20)          null,
   constraint PK_ROOM primary key (ROOM_ID)
);

/*==============================================================*/
/* Index: ROOM_PK                                               */
/*==============================================================*/
create unique index ROOM_PK on ROOM (
ROOM_ID
);

/*==============================================================*/
/* Index: ASSIGNED_FOR_RESERVATION_FK                              */
/*==============================================================*/
create  index ASSIGNED_FOR_RESERVATION_FK on RESERVATION (
ROOM_ID
);

/*==============================================================*/
/* Index: ASSIGNED_FOR_REGISTRATION_FK                             */
/*==============================================================*/
create  index ASSIGNED_FOR_REGISTRATION_FK on REGISTRATION (
ROOM_ID
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
   CUSTOMER_ID          INT4                 not null,
   SONG_START_TIME      TIMESTAMP            null,
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
   EXTEND_ID            SERIAL               not null,
   REGISTRATION_ID      INT4                 null,
   RESERVATION_ID       INT4                 null,
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
REGISTRATION_ID
);

alter table MEMBER
   add constraint FK_MEMBER_PART_OF_CUSTOMER foreign key (CUSTOMER_ID)
      references CUSTOMER (CUSTOMER_ID)
      on delete restrict on update restrict;

alter table PAYMENT
   add constraint FK_PAYMENT_PAYMENT_FOR_REGISTRATION foreign key (REGISTRATION_ID)
      references REGISTRATION (REGISTRATION_ID)
      on delete restrict on update restrict;

alter table PAYMENT
   add constraint FK_PAYMENT_PAYMENT_FOR_RESERVATION foreign key (RESERVATION_ID)
      references RESERVATION (RESERVATION_ID)
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
   add constraint FK_REGISTRA_USES_ROOM_ROOM foreign key (ROOM_ID)
      references ROOM (ROOM_ID)
      on delete restrict on update restrict;

alter table RESERVATION
   add constraint FK_RESERVAT_MAKE_RESE_CUSTOMER foreign key (CUSTOMER_ID)
      references CUSTOMER (CUSTOMER_ID)
      on delete restrict on update restrict;

alter table RESERVATION
   add constraint FK_RESERVAT_USES_ROOM_ROOM foreign key (ROOM_ID)
      references ROOM (ROOM_ID)
      on delete restrict on update restrict;

alter table SONG_ACTIVITIES
   add constraint FK_SONG_ACT_RECORDED__CUSTOMER foreign key (CUSTOMER_ID)
      references CUSTOMER (CUSTOMER_ID)
      on delete restrict on update restrict;

alter table TIME_EXTEND
   add constraint FK_TIME_EXT_REG_HAS_E_REGISTRA foreign key (REGISTRATION_ID)
      references REGISTRATION (REGISTRATION_ID)
      on delete restrict on update restrict;

alter table TIME_EXTEND
   add constraint FK_TIME_EXT_RES_HAS_E_RESERVAT foreign key (RESERVATION_ID)
      references RESERVATION (RESERVATION_ID)
      on delete restrict on update restrict;

-- ===========================
-- INSERT INTO CUSTOMER (10)
-- ===========================
INSERT INTO CUSTOMER (NO_PHONE, NAME, PEOPLE_COMING) VALUES
('081234567890', 'Annisa', 3),
('081234567891', 'Budi', 2),
('081234567892', 'Citra', 4),
('081234567893', 'Dhika', 1),
('081234567894', 'Eka', 5),
('081234567895', 'Virli', 2),
('081234567896', 'Gina', 3),
('081234567897', 'Hana', 6),
('081234567898', 'Indah', 2),
('081234567899', 'Shofi', 1);
SELECT * FROM CUSTOMER;

-- ===========================
-- INSERT INTO MEMBER (10)
-- ===========================
INSERT INTO MEMBER (CUSTOMER_ID, MEMBER_STATUS, NUMBER_OF_VISITS, DISCOUNT_MEMBER) VALUES
(1,'Silver',5,0.05),
(2,'Gold',15,0.10),
(3,'INACTIVE',0,0.00),
(4,'Platinum',30,0.15),
(5,'Gold',16,0.10),
(6,'Silver',6,0.05),
(7,'INACTIVE',0,0.00),
(8,'Silver',5,0.05),
(9,'Gold',20,0.10),
(10,'Platinum',31,0.15);
SELECT * FROM MEMBER;

-- ===========================
-- INSERT INTO ROOM (10)
-- ===========================
INSERT INTO ROOM (ROOM_TYPE, CAPACITY, HOURLY_RATE, STATUS) VALUES
('SMALL',4,50000,'AVAILABLE'),
('MEDIUM',6,75000,'AVAILABLE'),
('LARGE',8,100000,'AVAILABLE'),
('VIP',10,150000,'AVAILABLE'),
('SMALL',4,50000,'AVAILABLE'),
('MEDIUM',6,75000,'AVAILABLE'),
('LARGE',8,100000,'AVAILABLE'),
('VIP',10,150000,'AVAILABLE'),
('SMALL',4,50000,'AVAILABLE'),
('MEDIUM',6,75000,'AVAILABLE');
SELECT * FROM ROOM;

-- ===============================
-- INSERT INTO REGISTRATION (10)
-- ===============================
INSERT INTO REGISTRATION (CUSTOMER_ID, ROOM_ID, RG_DATE, START_TIME, END_TIME, REGISTRATION_STATUS) VALUES
(1,1,'2025-11-10','2025-11-10 10:00','2025-11-10 12:00','FINISHED'),
(2,2,'2025-11-11','2025-11-11 11:00','2025-11-11 13:00','FINISHED'),
(3,3,'2025-11-12','2025-11-12 12:00','2025-11-12 14:00','FINISHED'),
(4,4,'2025-11-13','2025-11-13 09:30','2025-11-13 11:30','FINISHED'),
(5,5,'2025-11-14','2025-11-14 14:00','2025-11-14 16:00','FINISHED'),
(6,1,'2025-11-15','2025-11-15 15:00','2025-11-15 17:00','FINISHED'),
(7,2,'2025-11-16','2025-11-16 16:00','2025-11-16 18:00','FINISHED'),
(8,3,'2025-11-17','2025-11-17 11:30','2025-11-17 13:30','FINISHED'),
(9,4,'2025-11-18','2025-11-18 17:00','2025-11-18 19:00','FINISHED'),
(10,5,'2025-11-19','2025-11-19 18:00','2025-11-19 20:00','FINISHED');
SELECT * FROM REGISTRATION;

-- ===============================
-- INSERT INTO RESERVATION (10)
-- ===============================
INSERT INTO RESERVATION (CUSTOMER_ID, ROOM_ID, RV_DATE, START_TIME, END_TIME, RESERVATION_DATE, PCT_DP, PAID_DP, LATE) VALUES
(1,6,'2025-11-22','2025-11-22 10:00','2025-11-22 12:00','2025-11-20',0.30,36000,false),
(2,7,'2025-11-23','2025-11-23 12:00','2025-11-23 14:00','2025-11-21',0.30,45000,false),
(3,8,'2025-11-24','2025-11-24 14:00','2025-11-24 16:00','2025-11-22',0.30,27000,false),
(4,9,'2025-11-25','2025-11-25 16:00','2025-11-25 18:00','2025-11-23',0.30,33000,false),
(5,10,'2025-11-26','2025-11-26 18:00','2025-11-26 20:00','2025-11-24',0.30,48000,false),
(6,6,'2025-11-27','2025-11-27 09:00','2025-11-27 11:00','2025-11-25',0.30,24000,false),
(7,7,'2025-11-28','2025-11-28 11:00','2025-11-28 13:00','2025-11-26',0.30,60000,false),
(8,8,'2025-11-29','2025-11-29 13:00','2025-11-29 15:00','2025-11-27',0.30,39000,false),
(9,9,'2025-11-30','2025-11-30 15:00','2025-11-30 17:00','2025-11-28',0.30,30000,false),
(10,10,'2025-12-01','2025-12-01 17:00','2025-12-01 19:00','2025-11-29',0.30,42000,false);
SELECT * FROM RESERVATION;

-- ===========================
-- INSERT INTO PAYMENT (10)
-- ===========================
INSERT INTO PAYMENT (REGISTRATION_ID, RESERVATION_ID, PAYMENT_TIME, PAYMENT_METHOD, TOTAL_COST, DISCOUNT_MEMBER, FINAL_COST) VALUES
(1,NULL,NOW(), 'CASH', 120000, 0.10, 108000),
(2,NULL,NOW(), 'CARD', 150000, 0.15, 127500),
(3,NULL,NOW(), 'CASH', 90000, 0.00, 90000),
(4,NULL,NOW(), 'QRIS', 110000, 0.20, 88000),
(5,NULL,NOW(), 'CASH', 160000, 0.05, 152000),
(6,NULL,NOW(), 'CARD', 80000, 0.00, 80000),
(7,NULL,NOW(), 'QRIS', 200000, 0.25, 150000),
(8,NULL,NOW(), 'CASH', 130000, 0.10, 117000),
(9,NULL,NOW(), 'CARD', 100000, 0.00, 100000),
(10,NULL,NOW(), 'QRIS', 140000, 0.15, 119000);
SELECT * FROM PAYMENT;

-- ===========================
-- INSERT INTO SONGS (10)
-- ===========================
INSERT INTO SONGS (TITLE, ARTIST, GENRE, LANGUAGE, DURATION, LYRICS) VALUES
('Take A Chance With Me', 'NIKI', 'Pop / R&B', 'English', '00:03:45', 'Lyrics not included'),
('I Pray', 'LANY', 'Pop', 'English', '00:03:30', 'Lyrics not included'),
('Out Of My League', 'LANY', 'Pop', 'English', '00:03:20', 'Lyrics not included'),
('TAROT', '.Feast', 'Rock / Alternative', 'Indonesian', '00:04:20', 'Lyrics not included'),
('Rumah Ke Rumah', 'Hindia', 'Indie', 'Indonesian', '00:04:28', 'Lyrics not included'),
('Berdansalah, Karir Ini Tak Ada Artinya', 'Hindia', 'Alternative / Indie', 'Indonesian', '00:04:10', 'Lyrics not included'),
('Aku Milikmu', 'Dewa 19', 'Rock', 'Indonesian', '00:05:48', 'Lyrics not included'),
('Bertaut', 'Nadin Amizah', 'Indie Folk', 'Indonesian', '00:03:58', 'Lyrics not included'),
('Interaksi', 'Tulus', 'Pop', 'Indonesian', '00:03:35', 'Lyrics not included'),
('Guilty as Sin?', 'Taylor Swift', 'Pop', 'English', '00:04:14', 'Lyrics not included');
SELECT * FROM SONGS;

-- ================================
-- INSERT INTO SONG_ACTIVITIES (10)
-- ================================
INSERT INTO SONG_ACTIVITIES (CUSTOMER_ID, SONG_START_TIME, PLAYED_DURATION, PLAYED_PERCENTAGE) VALUES
(1, NOW(), '00:02:00', 60),
(2, NOW(), '00:03:00', 75),
(3, NOW(), '00:04:00', 80),
(4, NOW(), '00:01:30', 50),
(5, NOW(), '00:03:20', 70),
(6, NOW(), '00:02:40', 65),
(7, NOW(), '00:04:10', 85),
(8, NOW(), '00:03:50', 90),
(9, NOW(), '00:02:10', 55),
(10,NOW(), '00:04:00', 95);
SELECT * FROM SONG_ACTIVITIES;

-- ===========================
-- INSERT INTO PICK (10)
-- ===========================
INSERT INTO PICK (SONGS_ID, ACTIVITY_ID) VALUES
(1,1),(2,2),(3,3),(4,4),(5,5),
(6,6),(7,7),(8,8),(9,9),(10,10);
SELECT * FROM PICK;

-- ===============================
-- INSERT INTO TIME_EXTEND (10)
-- ===============================
INSERT INTO TIME_EXTEND (REGISTRATION_ID, RESERVATION_ID, EXTENSION_DURATION, EXTENSION_COST) VALUES
(1,NULL,'00:30:00',25000),
(2,NULL,'00:20:00',20000),
(3,NULL,'00:40:00',35000),
(4,NULL,'00:15:00',15000),
(5,NULL,'00:30:00',25000),
(NULL,1,'00:30:00',25000),
(NULL,2,'00:20:00',20000),
(NULL,3,'00:45:00',40000),
(NULL,4,'00:10:00',10000),
(NULL,5,'00:25:00',22000);
SELECT * FROM TIME_EXTEND;

-- ===============================
-- FUNCTION TOTAL PAYMENT
-- ===============================
CREATE OR REPLACE FUNCTION calculate_total_payment(
    p_total_cost      NUMERIC(8,2),
    p_discount_member FLOAT8
)
RETURNS NUMERIC(8,2)
LANGUAGE plpgsql
AS $$
DECLARE
    v_final NUMERIC(8,2);
BEGIN
    v_final := p_total_cost - (p_total_cost * COALESCE(p_discount_member,0));
    RETURN ROUND(v_final,2);
END;
$$;

-- ===============================
-- FUNCTION DISCOUNT MEMBER
-- ===============================
CREATE OR REPLACE FUNCTION get_discount_member(
    p_customer_id INT
)
RETURNS FLOAT8
LANGUAGE plpgsql
AS $$
DECLARE
    v_visits   INT;
    v_discount FLOAT8 := 0;
BEGIN
    SELECT COALESCE(number_of_visits,0)
    INTO v_visits
    FROM member
    WHERE customer_id = p_customer_id;

    IF v_visits >= 30 THEN
        v_discount := 0.15;   -- Platinum
    ELSIF v_visits >= 15 THEN
        v_discount := 0.10;   -- Gold
    ELSIF v_visits >= 5 THEN
        v_discount := 0.05;   -- Silver
    ELSE
        v_discount := 0.00;   -- Non-member / INACTIVE
    END IF;

    RETURN v_discount;
END;
$$;

-- ===============================
-- PROCEDURE PAYMENT REGISTRATION
-- ===============================
CREATE OR REPLACE PROCEDURE pay_registration(
    IN p_registration_id INT,
    IN p_payment_method VARCHAR(10)
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_customer_id INT;
    v_start_time TIMESTAMP;
    v_end_time TIMESTAMP;
    v_room_id INT;
    v_hourly_rate NUMERIC(8,2);
    v_duration_hours NUMERIC(8,2);
    v_base_cost NUMERIC(8,2);
    v_ext_cost NUMERIC(8,2);
    v_total_cost NUMERIC(8,2);
    v_discount FLOAT8;
    v_final_cost NUMERIC(8,2);
    v_payment_id INT;
BEGIN
    -- 1. Ambil data registrasi
    SELECT customer_id, room_id, start_time, end_time
    INTO   v_customer_id, v_room_id, v_start_time, v_end_time
    FROM   registration
    WHERE  registration_id = p_registration_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Registration % not found', p_registration_id;
    END IF;

    -- 2. Ambil tarif ruangan
    SELECT hourly_rate
    INTO   v_hourly_rate
    FROM   room
    WHERE  room_id = v_room_id;

    IF v_hourly_rate IS NULL THEN
        RAISE EXCEPTION 'Room % not found or hourly_rate is NULL', v_room_id;
    END IF;

    -- 3. Hitung durasi dalam jam
    v_duration_hours :=
        EXTRACT(EPOCH FROM (v_end_time - v_start_time)) / 3600.0;

    v_base_cost := ROUND(v_hourly_rate * v_duration_hours, 2);

    -- 4. Tambah biaya extend
    SELECT COALESCE(SUM(extension_cost),0)
    INTO   v_ext_cost
    FROM   time_extend
    WHERE  registration_id = p_registration_id;

    v_total_cost := v_base_cost + v_ext_cost;

    -- 5. Ambil diskon membership 
    v_discount := get_discount_member(v_customer_id);

    -- 6. Hitung final cost
    v_final_cost := calculate_total_payment(v_total_cost, v_discount);

    -- 7. RAISE NOTICE summary
    RAISE NOTICE '=== PAYMENT SUMMARY FOR REGISTRATION % ===', p_registration_id;
    RAISE NOTICE 'Room ID               : %', v_room_id;
    RAISE NOTICE 'Room hourly rate      : Rp %', v_hourly_rate;
    RAISE NOTICE 'Duration (hours)      : %', v_duration_hours;
    RAISE NOTICE 'Base room cost        : Rp %', v_base_cost;
    RAISE NOTICE 'Extension cost        : Rp %', v_ext_cost;
    RAISE NOTICE '------------------------------------------';
    RAISE NOTICE 'Total cost            : Rp %', v_total_cost;
    RAISE NOTICE 'Membership discount   : % %', v_discount * 100, '%';
    RAISE NOTICE 'Final cost to pay     : Rp %', v_final_cost;
    RAISE NOTICE '==========================================';

    -- 8. Simpan ke PAYMENT 
    INSERT INTO payment(
        registration_id,
        reservation_id,
        payment_time,
        payment_method,
        total_cost,
        discount_member,
        final_cost
    )
    VALUES (
        p_registration_id,
        NULL,
        NOW(),
        p_payment_method,
        v_total_cost,
        v_discount,
        v_final_cost
    )
    RETURNING payment_id INTO v_payment_id;

    RAISE NOTICE 'Payment recorded with PAYMENT_ID = %', v_payment_id;

    -- 9. update status
    UPDATE registration
    SET registration_status = 'PAID'
    WHERE registration_id = p_registration_id;

    RAISE NOTICE 'Registration % marked as PAID', p_registration_id;
END;
$$;

select * from registration g
join room r on (r.room_id = g.room_id)
call pay_registration(1, 'CASH')

-- =====================================
-- PROCEDURE PAYMENT RESERVATION (LUNAS)
-- =====================================
CREATE OR REPLACE PROCEDURE pay_reservation_settle(
    IN p_reservation_id INT,
    IN p_payment_method VARCHAR(10)
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_customer_id INT;
    v_room_id INT;
    v_start_time TIMESTAMP;
    v_end_time TIMESTAMP;
    v_paid_dp NUMERIC(8,2);
    v_hourly_rate NUMERIC(8,2);
    v_duration_hours NUMERIC(8,2);
    v_base_cost NUMERIC(8,2);
    v_ext_cost NUMERIC(8,2);
    v_total_cost NUMERIC(8,2);
    v_remaining_cost NUMERIC(8,2);
    v_discount FLOAT8;
    v_final_cost NUMERIC(8,2);
    v_payment_id INT;
BEGIN
    -- 1. Ambil data reservasi
    SELECT customer_id, room_id, start_time, end_time, COALESCE(paid_dp,0)
    INTO   v_customer_id, v_room_id, v_start_time, v_end_time, v_paid_dp
    FROM   reservation
    WHERE  reservation_id = p_reservation_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Reservation % not found', p_reservation_id;
    END IF;

    -- 2. Ambil tarif ruangan
    SELECT hourly_rate
    INTO   v_hourly_rate
    FROM   room
    WHERE  room_id = v_room_id;

    IF v_hourly_rate IS NULL THEN
        RAISE EXCEPTION 'Room % not found or hourly_rate is NULL', v_room_id;
    END IF;

    -- 3. Durasi dalam jam
    v_duration_hours :=
        EXTRACT(EPOCH FROM (v_end_time - v_start_time)) / 3600.0;

    v_base_cost := ROUND(v_hourly_rate * v_duration_hours, 2);

    -- 4. Biaya perpanjangan untuk reservasi ini
    SELECT COALESCE(SUM(extension_cost),0)
    INTO   v_ext_cost
    FROM   time_extend
    WHERE  reservation_id = p_reservation_id;

    v_total_cost := v_base_cost + v_ext_cost;

    -- 5. Kurangi dengan DP
    v_remaining_cost := v_total_cost - v_paid_dp;
    IF v_remaining_cost < 0 THEN
        v_remaining_cost := 0;
    END IF;

    -- 6. Diskon member
	v_discount := get_discount_member(v_customer_id);

    -- 7. Final cost setelah diskon
    v_final_cost := calculate_total_payment(v_remaining_cost, v_discount);

    -- NOTICE
    RAISE NOTICE '=== PAYMENT SUMMARY FOR RESERVATION % ===', p_reservation_id;
    RAISE NOTICE 'Room ID               : %', v_room_id;
    RAISE NOTICE 'Room hourly rate      : Rp %', v_hourly_rate;
    RAISE NOTICE 'Duration (hours)      : %', v_duration_hours;
    RAISE NOTICE 'Base room cost        : Rp %', v_base_cost;
    RAISE NOTICE 'Extension cost        : Rp %', v_ext_cost;
    RAISE NOTICE '------------------------------------------';
    RAISE NOTICE 'Total cost            : Rp %', v_total_cost;
    RAISE NOTICE 'DP already paid       : Rp %', v_paid_dp;
    RAISE NOTICE 'Remaining before disc : Rp %', v_remaining_cost;
    RAISE NOTICE 'Membership discount   : % %', v_discount * 100, '%';
    RAISE NOTICE 'Final cost to pay     : Rp %', v_final_cost;
    RAISE NOTICE '==========================================';

    -- 8. Insert PAYMENT 
    INSERT INTO payment(
        registration_id,
        reservation_id,
        payment_time,
        payment_method,
        total_cost,
        discount_member,
        final_cost
    )
    VALUES (
        NULL,
        p_reservation_id,
        NOW(),
        p_payment_method,
        v_remaining_cost,
        v_discount,
        v_final_cost
    )
    RETURNING payment_id INTO v_payment_id;

    RAISE NOTICE 'Payment recorded with PAYMENT_ID = %', v_payment_id;
END;
$$;

select * from reservation
call pay_reservation_settle(1, 'CARD')

-- =====================================
-- PROCEDURE EXTEND TIME
-- =====================================
CREATE OR REPLACE PROCEDURE extend_time(
    IN p_booking_type VARCHAR(3),   -- 'REG' atau 'RES'
    IN p_booking_id INT,
    IN p_minutes INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_room_id INT;
    v_hourly_rate NUMERIC(8,2);
    v_ext_cost NUMERIC(8,2);
    v_ext_interval INTERVAL;
    v_current_end TIMESTAMP;
    v_new_end TIMESTAMP;
    v_next_start TIMESTAMP;
BEGIN
    IF p_minutes <= 0 THEN
        RAISE EXCEPTION 'Extension minutes must be > 0';
    END IF;

    v_ext_interval := (p_minutes || ' minutes')::INTERVAL;

    -- 1. Ambil END_TIME & ROOM_ID dari booking
    IF p_booking_type = 'REG' THEN
        SELECT end_time, room_id
        INTO   v_current_end, v_room_id
        FROM   registration
        WHERE  registration_id = p_booking_id;

        IF v_current_end IS NULL THEN
            RAISE EXCEPTION 'Registration % not found or END_TIME NULL', p_booking_id;
        END IF;

    ELSIF p_booking_type = 'RES' THEN
        SELECT end_time, room_id
        INTO   v_current_end, v_room_id
        FROM   reservation
        WHERE  reservation_id = p_booking_id;

        IF v_current_end IS NULL THEN
            RAISE EXCEPTION 'Reservation % not found or END_TIME NULL', p_booking_id;
        END IF;

    ELSE
        RAISE EXCEPTION 'Unknown booking_type: %, use REG or RES', p_booking_type;
    END IF;

    -- 2. Ambil tarif ruangan
    SELECT hourly_rate
    INTO   v_hourly_rate
    FROM   room
    WHERE  room_id = v_room_id;

    IF v_hourly_rate IS NULL THEN
        RAISE EXCEPTION 'Room % not found or hourly_rate NULL', v_room_id;
    END IF;

    -- 3. Cari booking berikutnya di room yang sama
    WITH next_bookings AS (
        -- Registrasi lain di room yang sama
        SELECT r2.start_time AS start_time
        FROM   registration r2
        WHERE  r2.room_id = v_room_id
          AND  r2.start_time > v_current_end
          AND  (p_booking_type <> 'REG'
                OR r2.registration_id <> p_booking_id)

        UNION ALL

        -- Reservasi lain di room yang sama
        SELECT rv2.start_time AS start_time
        FROM   reservation rv2
        WHERE  rv2.room_id = v_room_id
          AND  rv2.start_time > v_current_end
          AND  (p_booking_type <> 'RES'
                OR rv2.reservation_id <> p_booking_id)
    )
    SELECT MIN(start_time)
    INTO   v_next_start
    FROM   next_bookings;

    -- Hitung END_TIME baru setelah extend
    v_new_end := v_current_end + v_ext_interval;

    -- 4. Validasi: kalau ada booking berikutnya
    IF v_next_start IS NOT NULL THEN
        IF v_new_end > (v_next_start - INTERVAL '30 minutes') THEN
            RAISE EXCEPTION
                'Cannot extend: new end time % is too close to next booking at % (min 30 minutes gap)',
                v_new_end, v_next_start;
        END IF;
    END IF;

    -- 5. Hitung biaya extend & simpan ke TIME_EXTEND
    v_ext_cost := v_hourly_rate * (p_minutes::NUMERIC / 60.0);

    IF p_booking_type = 'REG' THEN
        INSERT INTO time_extend(
            registration_id, reservation_id, extension_duration, extension_cost
        )
        VALUES (
            p_booking_id, NULL, v_ext_interval, v_ext_cost
        );

        UPDATE registration
        SET end_time = v_new_end
        WHERE registration_id = p_booking_id;

    ELSE  -- 'RES'
        INSERT INTO time_extend(
            registration_id, reservation_id, extension_duration, extension_cost
        )
        VALUES (
            NULL, p_booking_id, v_ext_interval, v_ext_cost
        );

        UPDATE reservation
        SET end_time = v_new_end
        WHERE reservation_id = p_booking_id;
    END IF;

    -- 6. RAISE NOTICE summary
    RAISE NOTICE 'Extend % ID % in room % by % minutes',
                 p_booking_type, p_booking_id, v_room_id, p_minutes;
    RAISE NOTICE 'Old END_TIME: %, New END_TIME: %', v_current_end, v_new_end;

    IF v_next_start IS NOT NULL THEN
        RAISE NOTICE 'Next booking in this room starts at: % (min 30 min gap enforced)', v_next_start;
    ELSE
        RAISE NOTICE 'No next booking in this room – extension is only limited by duration requested.';
    END IF;

    RAISE NOTICE 'Extra cost for this extension: Rp %', v_ext_cost;
END;
$$;

select * from reservation
select * from registration

CALL extend_time('REG', 3, 30);
CALL extend_time('REG', 3, 60);
CALL extend_time('RES', 3, 30);
CALL extend_time('REG', 4, 30);
CALL extend_time('REG', 5, 30);

-- =====================================
-- TRIGGER PAYMENT 
-- =====================================
CREATE OR REPLACE FUNCTION trg_payment_calculate_total()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    IF NEW.final_cost IS NULL THEN
        NEW.final_cost := calculate_total_payment(
            NEW.total_cost,
            COALESCE(NEW.discount_member,0)
        );
    END IF;

    IF NEW.payment_time IS NULL THEN
        NEW.payment_time := NOW();
    END IF;

    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_before_insert_payment
BEFORE INSERT ON payment
FOR EACH ROW
EXECUTE FUNCTION trg_payment_calculate_total();

INSERT INTO registration(customer_id, room_id, start_time, end_time, registration_status)
VALUES (1, 3, '2025-01-01 10:00', '2025-01-01 12:00', 'ONGOING');

INSERT INTO payment (registration_id, reservation_id, payment_method, total_cost, discount_member)
VALUES (11, NULL, 'CASH', 125000, 0.10);

select * from registration
select * from payment

-- =====================================
-- VIEW MEMBERSHIP STATUS
-- =====================================
CREATE OR REPLACE VIEW v_membership_status AS
SELECT
    c.customer_id,
    c.name,
    m.member_status,
    m.number_of_visits,
    m.discount_member
FROM customer c
LEFT JOIN member m
       ON m.customer_id = c.customer_id;

select * from v_membership_status

-- =====================================
-- VIEW SONG POPULARITY
-- =====================================
CREATE OR REPLACE VIEW v_song_popularity AS
SELECT
    s.songs_id,
    s.title,
    COUNT(sa.activity_id) AS total_play,
    SUM(
        CASE WHEN sa.played_percentage = 100 THEN 1 ELSE 0 END
    ) AS full_play_count,
    CASE
        WHEN COUNT(sa.activity_id) = 0 THEN 0
        ELSE ROUND(
            SUM(
                CASE WHEN sa.played_percentage = 100 THEN 1 ELSE 0 END
            )::NUMERIC * 100
            / COUNT(sa.activity_id),
            2
        )
    END AS popularity_percentage
FROM songs s
LEFT JOIN pick p
       ON p.songs_id = s.songs_id
LEFT JOIN song_activities sa
       ON sa.activity_id = p.activity_id
GROUP BY s.songs_id, s.title
ORDER BY popularity_percentage DESC;

select * from v_song_popularity

