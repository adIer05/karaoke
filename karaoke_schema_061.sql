/*==============================================================*/
/*                            sopi                              */
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
drop function if exists fn_membership_level(p_customer_id INT);
drop procedure if exists sp_create_registration(
    p_customer_id INT,
    p_room_id INT,
    p_date DATE,
    p_start TIMESTAMP,
    p_end TIMESTAMP,
    p_num_people INT
);
drop function if exists trg_check_room_capacity();
drop function if exists trg_update_membership();
drop view if exists v_room_status_today;

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
   CUSTOMER_ID          INT4                 not null,
   REGISTRATION_ID      SERIAL               not null,
   PAYMENT_ID           INT4                 not null,
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
/* Index: RESULTS_PAYMENT_RESERVATION_FK                        */
/*==============================================================*/
create  index RESULTS_PAYMENT_RESERVATION_FK on RESERVATION (
PAYMENT_ID
);

/*==============================================================*/
/* Table: ROOM                                                  */
/*==============================================================*/
create table ROOM (
   REGISTRATION_ID      INT4                 null,
   RESERVATION_ID       INT4                 null,
   ROOM_ID              SERIAL               not null,
   ROOM_TYPE            VARCHAR(10)          null,
   CAPACITTY            INT4                 null,
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
/* Index: ASSIGNED_FOR_RESERVATION_FK                           */
/*==============================================================*/
create  index ASSIGNED_FOR_RESERVATION_FK on ROOM (
RESERVATION_ID
);

/*==============================================================*/
/* Index: ASSIGNED_FOR_REGISTRATION_FK                          */
/*==============================================================*/
create  index ASSIGNED_FOR_REGISTRATION_FK on ROOM (
REGISTRATION_ID
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
   REGISTRATION_ID      INT4                 null,
   RESERVATION_ID       INT4                 null,
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
REGISTRATION_ID
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

ALTER TABLE REGISTRATION
	ALTER COLUMN PAYMENT_ID DROP NOT NULL;

alter table RESERVATION
   add constraint FK_RESERVAT_MAKE_RESE_CUSTOMER foreign key (CUSTOMER_ID)
      references CUSTOMER (CUSTOMER_ID)
      on delete restrict on update restrict;

alter table RESERVATION
   add constraint FK_RESERVAT_RESULTS_P_PAYMENT foreign key (PAYMENT_ID)
      references PAYMENT (PAYMENT_ID)
      on delete restrict on update restrict;

alter table ROOM
   add constraint FK_ROOM_ASSIGNED__REGISTRA foreign key (REGISTRATION_ID)
      references REGISTRATION (REGISTRATION_ID)
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
-- INSERT INTO PAYMENT (10)
-- ===========================
INSERT INTO PAYMENT (PAYMENT_TIME, PAYMENT_METHOD, TOTAL_COST, DISCOUNT_MEMBER, FINAL_COST) VALUES
(NOW(), 'CASH', 120000, 0.10, 108000),
(NOW(), 'CARD', 150000, 0.15, 127500),
(NOW(), 'CASH', 90000, 0.00, 90000),
(NOW(), 'QRIS', 110000, 0.20, 88000),
(NOW(), 'CASH', 160000, 0.05, 152000),
(NOW(), 'CARD', 80000, 0.00, 80000),
(NOW(), 'QRIS', 200000, 0.25, 150000),
(NOW(), 'CASH', 130000, 0.10, 117000),
(NOW(), 'CARD', 100000, 0.00, 100000),
(NOW(), 'QRIS', 140000, 0.15, 119000);
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
-- INSERT INTO REGISTRATION (10)
-- ===============================
INSERT INTO REGISTRATION (CUSTOMER_ID, PAYMENT_ID, RG_DATE, START_TIME, END_TIME, REGISTRATION_STATUS) VALUES
(1,1,'2025-11-10','2025-11-10 10:00','2025-11-10 12:00','FINISHED'),
(2,2,'2025-11-11','2025-11-11 11:00','2025-11-11 13:00','FINISHED'),
(3,3,'2025-11-12','2025-11-12 12:00','2025-11-12 14:00','FINISHED'),
(4,4,'2025-11-13','2025-11-13 09:30','2025-11-13 11:30','FINISHED'),
(5,5,'2025-11-14','2025-11-14 14:00','2025-11-14 16:00','FINISHED'),
(6,6,'2025-11-15','2025-11-15 15:00','2025-11-15 17:00','FINISHED'),
(7,7,'2025-11-16','2025-11-16 16:00','2025-11-16 18:00','FINISHED'),
(8,8,'2025-11-17','2025-11-17 11:30','2025-11-17 13:30','FINISHED'),
(9,9,'2025-11-18','2025-11-18 17:00','2025-11-18 19:00','FINISHED'),
(10,10,'2025-11-19','2025-11-19 18:00','2025-11-19 20:00','FINISHED');
SELECT * FROM REGISTRATION;


-- ===============================
-- INSERT INTO RESERVATION (10)
-- ===============================
INSERT INTO RESERVATION (CUSTOMER_ID, PAYMENT_ID, RV_DATE, START_TIME, END_TIME, RESERVATION_DATE, PCT_DP, PAID_DP, LATE) VALUES
(1,1,'2025-11-22','2025-11-22 10:00','2025-11-22 12:00','2025-11-20',0.30,36000,false),
(2,2,'2025-11-23','2025-11-23 12:00','2025-11-23 14:00','2025-11-21',0.30,45000,false),
(3,3,'2025-11-24','2025-11-24 14:00','2025-11-24 16:00','2025-11-22',0.30,27000,false),
(4,4,'2025-11-25','2025-11-25 16:00','2025-11-25 18:00','2025-11-23',0.30,33000,false),
(5,5,'2025-11-26','2025-11-26 18:00','2025-11-26 20:00','2025-11-24',0.30,48000,false),
(6,6,'2025-11-27','2025-11-27 09:00','2025-11-27 11:00','2025-11-25',0.30,24000,false),
(7,7,'2025-11-28','2025-11-28 11:00','2025-11-28 13:00','2025-11-26',0.30,60000,false),
(8,8,'2025-11-29','2025-11-29 13:00','2025-11-29 15:00','2025-11-27',0.30,39000,false),
(9,9,'2025-11-30','2025-11-30 15:00','2025-11-30 17:00','2025-11-28',0.30,30000,false),
(10,10,'2025-12-01','2025-12-01 17:00','2025-12-01 19:00','2025-11-29',0.30,42000,false);
SELECT * FROM RESERVATION;


-- ===========================
-- INSERT INTO ROOM (10)
-- ===========================
INSERT INTO ROOM (REGISTRATION_ID, RESERVATION_ID, ROOM_TYPE, CAPACITTY, HOURLY_RATE, STATUS) VALUES
(1,NULL,'SMALL',4,50000,'AVAILABLE'),
(2,NULL,'MEDIUM',6,75000,'AVAILABLE'),
(3,NULL,'LARGE',8,100000,'AVAILABLE'),
(4,NULL,'VIP',10,150000,'AVAILABLE'),
(5,NULL,'SMALL',4,50000,'AVAILABLE'),
(NULL,1,'MEDIUM',6,75000,'AVAILABLE'),
(NULL,2,'LARGE',8,100000,'AVAILABLE'),
(NULL,3,'VIP',10,150000,'AVAILABLE'),
(NULL,4,'SMALL',4,50000,'AVAILABLE'),
(NULL,5,'MEDIUM',6,75000,'AVAILABLE');
SELECT * FROM ROOM;

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

/*============================================================================
     Fungsi untuk menentukan level membership berdasarkan NUMBER_OF_VISITS
=============================================================================*/
CREATE OR REPLACE FUNCTION fn_membership_level(p_customer_id INT)
RETURNS VARCHAR
LANGUAGE plpgsql
AS $$
DECLARE
    v_visits INT;
    v_level VARCHAR := 'none';
BEGIN
    SELECT number_of_visits
    INTO v_visits
    FROM MEMBER
    WHERE customer_id = p_customer_id;

    IF v_visits IS NULL THEN
        RETURN 'none';
    ELSIF v_visits >= 30 THEN
        v_level := 'platinum';
    ELSIF v_visits >= 15 THEN
        v_level := 'gold';
    ELSIF v_visits >= 5 THEN
        v_level := 'silver';
    ELSE
        v_level := 'none';
    END IF;

    RETURN v_level;
END;
$$;

SELECT fn_membership_level(1) AS level_user1;
SELECT fn_membership_level(2) AS level_user2;
SELECT fn_membership_level(3) AS level_user3;
SELECT fn_membership_level(4) AS level_user4;

/*============================================================================
                 Prosedur untuk registrasi on-the-spot
-- p_customer_id: id customer (boleh terdaftar atau guest)
-- p_room_id: id ruangan yang ingin dipakai
-- p_date: tanggal registrasi (date)
-- p_start: waktu mulai (timestamp)
-- p_end: waktu selesai (timestamp)
-- p_num_people: jumlah orang datang (int)				 
=============================================================================*/
CREATE OR REPLACE PROCEDURE sp_create_registration(
    p_customer_id INT,
    p_room_id INT,
    p_date DATE,
    p_start TIMESTAMP,
    p_end TIMESTAMP,
    p_num_people INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_room_capacity INT;
    v_room_status TEXT;
    v_conflicts INT := 0;
    v_reg_id INT;
    v_member_exists INT;
    v_level TEXT;
    v_discount NUMERIC := 0;
    v_alternatives TEXT := '';
BEGIN
    -- basic validations
    IF p_end <= p_start THEN
        RAISE EXCEPTION 'END must be later than START';
    END IF;

    IF p_num_people <= 0 THEN
        RAISE EXCEPTION 'p_num_people must be > 0';
    END IF;

    -- check room exists and read capacity & status
    SELECT CAPACITTY, STATUS
    INTO v_room_capacity, v_room_status
    FROM ROOM
    WHERE ROOM_ID = p_room_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Room id % does not exist', p_room_id;
    END IF;

    -- check capacity
    IF v_room_capacity IS NULL OR v_room_capacity < p_num_people THEN
        RAISE EXCEPTION 'Room % capacity % is insufficient for % people', p_room_id, v_room_capacity, p_num_people;
    END IF;

    -- check conflicts with existing REGISTRATION assigned to this room
    -- we join ROOM -> REGISTRATION via ROOM.REGISTRATION_ID
    SELECT count(*) INTO v_conflicts
    FROM ROOM r
    JOIN REGISTRATION reg ON r.REGISTRATION_ID = reg.REGISTRATION_ID
    WHERE r.ROOM_ID = p_room_id
      AND reg.RG_DATE = p_date
      -- overlap test: NOT (new_end <= existing_start OR new_start >= existing_end)
      AND NOT (p_end <= reg.START_TIME OR p_start >= reg.END_TIME);

    -- check conflicts with existing RESERVATION assigned to this room
    SELECT v_conflicts + count(*) INTO v_conflicts
    FROM ROOM r
    JOIN RESERVATION res ON r.RESERVATION_ID = res.RESERVATION_ID
    WHERE r.ROOM_ID = p_room_id
      AND res.RV_DATE = p_date
      AND NOT (p_end <= res.START_TIME OR p_start >= res.END_TIME);

    IF v_conflicts > 0 THEN
        -- build a short list of alternative rooms (up to 3)
        v_alternatives := '';
        FOR v_room_capacity, v_room_status IN
            SELECT r.CAPACITTY, r.STATUS
            FROM ROOM r
            WHERE r.ROOM_ID != p_room_id
              AND r.CAPACITTY >= p_num_people
              AND r.STATUS = 'tersedia'
            LIMIT 1 -- just to ensure cursor works; actual check done below
        LOOP
            -- not used; this FOR is only to ensure the block compiles with variable binding
            EXIT;
        END LOOP;

        -- More robust: find up to 3 rooms that have no conflicting reservations/registrations
        v_alternatives := (
            SELECT string_agg('Room ' || r.room_id || ' (' || r.room_type || ')', '; ')
            FROM (
                SELECT r.*
                FROM ROOM r
                WHERE r.ROOM_ID != p_room_id
                  AND r.CAPACITTY >= p_num_people
                EXCEPT
                -- exclude rooms that have conflicting registration
                SELECT r2.*
                FROM ROOM r2
                JOIN REGISTRATION reg2 ON r2.REGISTRATION_ID = reg2.REGISTRATION_ID
                WHERE NOT (p_end <= reg2.START_TIME OR p_start >= reg2.END_TIME)
                  AND reg2.RG_DATE = p_date
                EXCEPT
                -- exclude rooms that have conflicting reservation
                SELECT r3.*
                FROM ROOM r3
                JOIN RESERVATION res3 ON r3.RESERVATION_ID = res3.RESERVATION_ID
                WHERE NOT (p_end <= res3.START_TIME OR p_start >= res3.END_TIME)
                  AND res3.RV_DATE = p_date
                LIMIT 3
            ) r
        );

        IF v_alternatives IS NULL OR trim(v_alternatives) = '' THEN
            RAISE EXCEPTION 'Room % is booked for the requested time. No suitable alternatives found.', p_room_id;
        ELSE
            RAISE EXCEPTION 'Room % is booked for the requested time. Alternatives: %', p_room_id, v_alternatives;
        END IF;
    END IF;

    -- If no conflict, insert registration (payment_id left NULL for on-the-spot; application can create PAYMENT later)
    INSERT INTO REGISTRATION (customer_id, payment_id, rg_date, start_time, end_time, registration_status)
    VALUES (p_customer_id, NULL, p_date, p_start, p_end, 'confirmed')
    RETURNING registration_id INTO v_reg_id;

    -- assign room to this registration and mark room as used
    UPDATE ROOM
    SET REGISTRATION_ID = v_reg_id,
        STATUS = 'digunakan'
    WHERE ROOM_ID = p_room_id;

    -- if customer is a member, increment visits and update discount
    SELECT count(*) INTO v_member_exists FROM MEMBER WHERE CUSTOMER_ID = p_customer_id;
    IF v_member_exists > 0 THEN
        -- increment visits
        UPDATE MEMBER
        SET NUMBER_OF_VISITS = COALESCE(NUMBER_OF_VISITS,0) + 1
        WHERE CUSTOMER_ID = p_customer_id;

        -- compute new level & discount and persist discount in MEMBER.DISCOUNT_MEMBER
        v_level := fn_membership_level(p_customer_id);
        IF v_level = 'platinum' THEN
            v_discount := 0.15;
        ELSIF v_level = 'gold' THEN
            v_discount := 0.10;
        ELSIF v_level = 'silver' THEN
            v_discount := 0.05;
        ELSE
            v_discount := 0;
        END IF;

        UPDATE MEMBER
        SET DISCOUNT_MEMBER = v_discount
        WHERE CUSTOMER_ID = p_customer_id;
    END IF;

    RAISE NOTICE 'Registration created with ID % and room % assigned. Member discount: %', v_reg_id, p_room_id, v_discount;
END;
$$;

INSERT INTO CUSTOMER (name, no_phone, people_coming)
VALUES ('Test User', '081234', 3) RETURNING customer_id;

CALL sp_create_registration(
    p_customer_id := 11,
    p_room_id     := 1,
    p_date        := CURRENT_DATE,
    p_start       := (CURRENT_TIMESTAMP + INTERVAL '10 minutes')::timestamp,
    p_end         := (CURRENT_TIMESTAMP + INTERVAL '70 minutes')::timestamp,
    p_num_people  := 3
);
SELECT * FROM REGISTRATION ORDER BY registration_id DESC LIMIT 1;
SELECT * FROM ROOM WHERE room_id = 1;

CALL sp_create_registration(
    11, 1, CURRENT_DATE,
    (CURRENT_TIMESTAMP + INTERVAL '10 minutes')::timestamp,
    (CURRENT_TIMESTAMP + INTERVAL '70 minutes')::timestamp,
    10  -- terlalu banyak
);

CALL sp_create_registration(
    11, 1, CURRENT_DATE,
    (CURRENT_TIMESTAMP + INTERVAL '20 minutes')::timestamp,
    (CURRENT_TIMESTAMP + INTERVAL '50 minutes')::timestamp,
    3  -- terlalu banyak
); -- Jadwal bertabrakan

/*============================================================================
            Trigger untuk cek kapasitas ruangan ≥ jumlah orang
=============================================================================*/
CREATE OR REPLACE FUNCTION trg_check_room_capacity()
RETURNS trigger AS $$
DECLARE
    v_capacity INT;
BEGIN
    -- Ambil kapasitas ruangan
    SELECT r.CAPACITTY INTO v_capacity
    FROM ROOM r
    WHERE r.ROOM_ID = NEW.ROOM_ID;

    IF v_capacity IS NULL THEN
        RAISE EXCEPTION 'Room % not found.', NEW.ROOM_ID;
    END IF;

    -- Cek kapasitas
    IF NEW.NUM_PEOPLE > v_capacity THEN
        RAISE EXCEPTION 
        'Jumlah orang (%) melebihi kapasitas ruangan (%)', 
        NEW.NUM_PEOPLE, v_capacity;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_room_capacity_before_insert
BEFORE INSERT ON REGISTRATION
FOR EACH ROW
EXECUTE FUNCTION trg_check_room_capacity();

/*============================================================================
         Trigger untuk auto-update jumlah kedatangan & level membership
=============================================================================*/
CREATE OR REPLACE FUNCTION trg_update_membership()
RETURNS trigger AS $$
DECLARE
    v_visits INT;
    v_level VARCHAR;
BEGIN
    -- Tambah jumlah kedatangan
    UPDATE MEMBER
    SET VISITS = VISITS + 1
    WHERE CUSTOMER_ID = NEW.CUSTOMER_ID
    RETURNING VISITS INTO v_visits;

    -- Jika customer tidak punya membership → tidak melakukan apa-apa
    IF v_visits IS NULL THEN
        RETURN NEW;
    END IF;

    -- Tentukan level membership
    IF v_visits >= 25 THEN
        v_level := 'platinum';
    ELSIF v_visits >= 10 THEN
        v_level := 'gold';
    ELSE
        v_level := 'silver';
    END IF;

    -- Update level ke tabel MEMBER
    UPDATE MEMBER
    SET LEVEL = v_level
    WHERE CUSTOMER_ID = NEW.CUSTOMER_ID;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_membership_after_registration
AFTER INSERT ON REGISTRATION
FOR EACH ROW
EXECUTE FUNCTION trg_update_membership();

CALL sp_create_registration(
    11, 2,
    CURRENT_DATE,
    (CURRENT_TIMESTAMP + INTERVAL '5 minutes')::timestamp,
    (CURRENT_TIMESTAMP + INTERVAL '65 minutes')::timestamp,
    3
);

SELECT customer_id, number_of_visits, member_status
FROM MEMBER
WHERE customer_id = 2;

/*============================================================================
         View untuk melihat daftar semua ruangan + status sekarang
=============================================================================*/
CREATE OR REPLACE VIEW v_room_status_today AS
SELECT
    r.ROOM_ID,
    r.ROOM_TYPE,
    r.CAPACITTY,
    CASE
        WHEN r.REGISTRATION_ID IS NOT NULL THEN 'digunakan'
        WHEN r.RESERVATION_ID  IS NOT NULL THEN 'direservasi'
        ELSE 'tersedia'
    END AS status_hari_ini
FROM ROOM r
ORDER BY r.ROOM_ID;

SELECT * FROM v_room_status_today;

