/*==============================================================*/
/*                             sopi                             */
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

/*============================================================================
     Fungsi untuk menentukan level membership berdasarkan NUMBER_OF_VISITS
=============================================================================*/
DROP FUNCTION IF EXISTS fn_membership_level(p_customer_id INTEGER);

CREATE OR REPLACE FUNCTION fn_membership_level(p_customer_id INTEGER)
RETURNS VARCHAR AS $$
DECLARE
    v_visit_count INTEGER;
    v_member_status VARCHAR(9);
BEGIN
    SELECT NUMBER_OF_VISITS INTO v_visit_count
    FROM MEMBER 
    WHERE CUSTOMER_ID = p_customer_id;
    
    -- If customer not found in MEMBER table, return 'NON-MEMBER'
    IF NOT FOUND THEN
        RETURN 'NON-MEMBER';
    END IF;
    
    IF v_visit_count >= 30 THEN
        v_member_status := 'Platinum';
    ELSIF v_visit_count >= 15 THEN
        v_member_status := 'Gold';
    ELSIF v_visit_count >= 5 THEN
        v_member_status := 'Silver';
    ELSE
        v_member_status := 'INACTIVE';
    END IF;
    
    RETURN v_member_status;
END;
$$ LANGUAGE plpgsql;

SELECT 
    c.CUSTOMER_ID,
    c.NAME,
    m.NUMBER_OF_VISITS,
    fn_membership_level(c.CUSTOMER_ID) as membership_level
FROM CUSTOMER c
LEFT JOIN MEMBER m ON c.CUSTOMER_ID = m.CUSTOMER_ID
WHERE c.CUSTOMER_ID IN (1, 2, 3, 4, 5);

SELECT 
    c.CUSTOMER_ID,
    c.NAME,
    m.NUMBER_OF_VISITS,
    m.MEMBER_STATUS as current_status,
    fn_membership_level(c.CUSTOMER_ID) as calculated_level
FROM CUSTOMER c
JOIN MEMBER m ON c.CUSTOMER_ID = m.CUSTOMER_ID
ORDER BY c.CUSTOMER_ID;

/*============================================================================
                 Prosedur untuk registrasi on-the-spot		 
=============================================================================*/
DROP PROCEDURE IF EXISTS sp_create_registration(
    p_customer_id INTEGER,
    p_room_id INTEGER,
    p_date DATE,
    p_start TIMESTAMP,
    p_end TIMESTAMP,
    p_num_people INTEGER
);

CREATE OR REPLACE PROCEDURE sp_create_registration(
    p_customer_id INTEGER,
    p_room_id INTEGER,
    p_date DATE,
    p_start TIMESTAMP,
    p_end TIMESTAMP,
    p_num_people INTEGER
)
AS $$
DECLARE
    v_room_capacity INTEGER;
    v_room_status VARCHAR(20);
    v_is_available BOOLEAN;
    v_registration_id INTEGER;
    v_duration_hours NUMERIC;
    v_total_cost NUMERIC(8,2);
    v_hourly_rate NUMERIC(8,2);
    v_discount_member FLOAT8;
    v_final_cost NUMERIC(8,2);
BEGIN
    SELECT CAPACITY, STATUS, HOURLY_RATE 
    INTO v_room_capacity, v_room_status, v_hourly_rate
    FROM ROOM 
    WHERE ROOM_ID = p_room_id;
    
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Room ID % not found', p_room_id;
    END IF;
    
    IF p_num_people > v_room_capacity THEN
        RAISE EXCEPTION 'Room capacity (%) is insufficient for % people', 
            v_room_capacity, p_num_people;
    END IF;
    
    IF v_room_status != 'AVAILABLE' THEN
        RAISE EXCEPTION 'Room is not available. Current status: %', v_room_status;
    END IF;
    
    PERFORM 1 FROM REGISTRATION 
    WHERE ROOM_ID = p_room_id 
      AND RG_DATE = p_date
      AND (
        (START_TIME <= p_start AND END_TIME > p_start) OR
        (START_TIME < p_end AND END_TIME >= p_end) OR
        (START_TIME >= p_start AND END_TIME <= p_end)
      )
      AND REGISTRATION_STATUS != 'CANCELLED';
    
    IF FOUND THEN
        RAISE EXCEPTION 'Room is already booked for the selected time period';
    END IF;
   
    PERFORM 1 FROM RESERVATION 
    WHERE ROOM_ID = p_room_id 
      AND RV_DATE = p_date
      AND (
        (START_TIME <= p_start AND END_TIME > p_start) OR
        (START_TIME < p_end AND END_TIME >= p_end) OR
        (START_TIME >= p_start AND END_TIME <= p_end)
      );
    
    IF FOUND THEN
        RAISE EXCEPTION 'Room is reserved for the selected time period';
    END IF;
    
    v_duration_hours := EXTRACT(EPOCH FROM (p_end - p_start)) / 3600;
    
    IF v_duration_hours <= 0 THEN
        RAISE EXCEPTION 'Invalid time duration. End time must be after start time';
    END IF;
    
    v_total_cost := v_hourly_rate * v_duration_hours;
    
    SELECT DISCOUNT_MEMBER INTO v_discount_member
    FROM MEMBER 
    WHERE CUSTOMER_ID = p_customer_id;
    
    IF NOT FOUND THEN
        v_discount_member := 0;
    END IF;
    
    v_final_cost := v_total_cost * (1 - v_discount_member);
    
    INSERT INTO REGISTRATION (
        CUSTOMER_ID, ROOM_ID, RG_DATE, START_TIME, END_TIME, REGISTRATION_STATUS
    ) VALUES (
        p_customer_id, p_room_id, p_date, p_start, p_end, 'CONFIRMED'
    ) RETURNING REGISTRATION_ID INTO v_registration_id;
    
    UPDATE ROOM SET STATUS = 'OCCUPIED' WHERE ROOM_ID = p_room_id;
    
    UPDATE CUSTOMER SET PEOPLE_COMING = p_num_people 
    WHERE CUSTOMER_ID = p_customer_id;
    
    RAISE NOTICE 'Registration successful!';
    RAISE NOTICE 'Registration ID: %, Total Cost: %, Discount: %, Final Cost: %', 
        v_registration_id, v_total_cost, (v_discount_member * 100) || '%', v_final_cost;
    
EXCEPTION
    WHEN others THEN
        RAISE EXCEPTION 'Registration failed: %', SQLERRM;
END;
$$ LANGUAGE plpgsql;

-- berhasil
CALL sp_create_registration(
    p_customer_id := 1,
    p_room_id := 1,
    p_date := '2025-11-20',
    p_start := '2025-11-20 14:00:00',
    p_end := '2025-11-20 16:00:00',
    p_num_people := 3
);

-- gagal (ga cukup)
CALL sp_create_registration(
    p_customer_id := 2,
    p_room_id := 1,  -- Small (4)
    p_date := '2025-11-20',
    p_start := '2025-11-20 17:00:00',
    p_end := '2025-11-20 19:00:00',
    p_num_people := 5
);

/*============================================================================
                    Prosedur untuk cancel reservation		 
=============================================================================*/
CREATE OR REPLACE PROCEDURE p_cancel_reservation(p_reservation_id INTEGER)
AS $$
DECLARE
    v_reservation_record RECORD;
    v_days_before INTEGER;
    v_can_cancel BOOLEAN;
    v_room_id INTEGER;
BEGIN
    SELECT 
        r.RESERVATION_ID,
        r.RV_DATE,
        r.ROOM_ID,
        r.START_TIME,
        c.NAME as customer_name
    INTO v_reservation_record
    FROM RESERVATION r
    JOIN CUSTOMER c ON r.CUSTOMER_ID = c.CUSTOMER_ID
    WHERE r.RESERVATION_ID = p_reservation_id;
    
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Reservation ID % not found', p_reservation_id;
    END IF;
    
    v_days_before := v_reservation_record.RV_DATE - CURRENT_DATE;
    
    IF v_days_before < 3 THEN
        RAISE EXCEPTION 'Cannot cancel reservation. Cancellation must be at least 3 days before reservation date. Current: % days before', v_days_before;
    END IF;
    
    v_room_id := v_reservation_record.ROOM_ID;
    
    DELETE FROM RESERVATION 
    WHERE RESERVATION_ID = p_reservation_id;
    
    UPDATE ROOM 
    SET STATUS = 'AVAILABLE' 
    WHERE ROOM_ID = v_room_id;
    
    RAISE NOTICE 'Reservation ID % for % on % has been successfully cancelled.', 
        p_reservation_id, 
        v_reservation_record.customer_name,
        v_reservation_record.RV_DATE;
        
EXCEPTION
    WHEN others THEN
        RAISE EXCEPTION 'Cancellation failed: %', SQLERRM;
END;
$$ LANGUAGE plpgsql;

INSERT INTO RESERVATION (CUSTOMER_ID, ROOM_ID, RV_DATE, START_TIME, END_TIME, RESERVATION_DATE, PCT_DP, PAID_DP, LATE) 
VALUES 
(1, 1, CURRENT_DATE + INTERVAL '5 days', -- 5 hari dari sekarang (bisa cancel)
 CURRENT_TIMESTAMP + INTERVAL '5 days', 
 CURRENT_TIMESTAMP + INTERVAL '7 days', 
 CURRENT_DATE, 0.3, 30000, false),
 
(2, 2, CURRENT_DATE + INTERVAL '2 days', -- 2 hari dari sekarang (tidak bisa cancel)
 CURRENT_TIMESTAMP + INTERVAL '2 days', 
 CURRENT_TIMESTAMP + INTERVAL '4 days', 
 CURRENT_DATE, 0.3, 45000, false)
RETURNING RESERVATION_ID;

-- Test 1: (H-5)
CALL p_cancel_reservation(11); 

-- Test 2: (H-2) 
CALL p_cancel_reservation(12);

-- Test 3 iseng
CALL p_cancel_reservation(999);

/*============================================================================
            Trigger untuk cek kapasitas ruangan ≥ jumlah orang
=============================================================================*/
DROP FUNCTION IF EXISTS fn_validate_room_capacity();

CREATE OR REPLACE FUNCTION fn_validate_room_capacity()
RETURNS TRIGGER AS $$
DECLARE
    v_room_capacity INTEGER;
    v_people_coming INTEGER;
BEGIN
    SELECT CAPACITY INTO v_room_capacity
    FROM ROOM 
    WHERE ROOM_ID = NEW.ROOM_ID;
    
    SELECT PEOPLE_COMING INTO v_people_coming
    FROM CUSTOMER 
    WHERE CUSTOMER_ID = NEW.CUSTOMER_ID;
    
    IF v_people_coming > v_room_capacity THEN
        RAISE EXCEPTION 'Room capacity (%) exceeded. Customer has % people', 
            v_room_capacity, v_people_coming;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- untuk registrasi
CREATE OR REPLACE TRIGGER tr_validate_registration_capacity
    BEFORE INSERT OR UPDATE ON REGISTRATION
    FOR EACH ROW
    EXECUTE FUNCTION fn_validate_room_capacity();

-- untuk reservasi
CREATE OR REPLACE TRIGGER tr_validate_reservation_capacity
    BEFORE INSERT OR UPDATE ON RESERVATION
    FOR EACH ROW
    EXECUTE FUNCTION fn_validate_room_capacity();

-- Test gagal
UPDATE CUSTOMER SET PEOPLE_COMING = 5 WHERE CUSTOMER_ID = 1; -- bawa 5 orang

INSERT INTO REGISTRATION (
    CUSTOMER_ID, ROOM_ID, RG_DATE, START_TIME, END_TIME, REGISTRATION_STATUS
) VALUES (
    1, 1, '2025-11-21', '2025-11-21 10:00:00', '2025-11-21 12:00:00', 'CONFIRMED'
); -- small (4)

-- Test berhasil;
UPDATE CUSTOMER SET PEOPLE_COMING = 3 WHERE CUSTOMER_ID = 1; -- bawa 3 orang

INSERT INTO REGISTRATION (
    CUSTOMER_ID, ROOM_ID, RG_DATE, START_TIME, END_TIME, REGISTRATION_STATUS
) VALUES (
    1, 1, '2025-11-21', '2025-11-21 10:00:00', '2025-11-21 12:00:00', 'CONFIRMED'
); -- small (4)

/*============================================================================
         Trigger untuk auto-update jumlah kedatangan & level membership
=============================================================================*/
DROP FUNCTION IF EXISTS fn_update_member_visits();

CREATE OR REPLACE FUNCTION fn_update_member_visits()
RETURNS TRIGGER AS $$
DECLARE
    v_visit_count INTEGER;
    v_new_member_status VARCHAR(9);
BEGIN
    -- Hanya diproses jika registration jadi 'FINISHED'
    IF (TG_OP = 'INSERT' AND NEW.REGISTRATION_STATUS = 'FINISHED') OR
       (TG_OP = 'UPDATE' AND NEW.REGISTRATION_STATUS = 'FINISHED' AND OLD.REGISTRATION_STATUS != 'FINISHED') THEN
        
        IF EXISTS (SELECT 1 FROM MEMBER WHERE CUSTOMER_ID = NEW.CUSTOMER_ID) THEN
            -- Increment visit_count
            UPDATE MEMBER 
            SET NUMBER_OF_VISITS = NUMBER_OF_VISITS + 1
            WHERE CUSTOMER_ID = NEW.CUSTOMER_ID
            RETURNING NUMBER_OF_VISITS INTO v_visit_count;

            IF v_visit_count >= 30 THEN
                v_new_member_status := 'Platinum';
            ELSIF v_visit_count >= 15 THEN
                v_new_member_status := 'Gold';
            ELSIF v_visit_count >= 5 THEN
                v_new_member_status := 'Silver';
            ELSE
                v_new_member_status := 'INACTIVE';
            END IF;
            
            UPDATE MEMBER 
            SET MEMBER_STATUS = v_new_member_status,
                DISCOUNT_MEMBER = 
                    CASE 
                        WHEN v_visit_count >= 30 THEN 0.15
                        WHEN v_visit_count >= 15 THEN 0.10
                        WHEN v_visit_count >= 5 THEN 0.05
                        ELSE 0.00
                    END
            WHERE CUSTOMER_ID = NEW.CUSTOMER_ID;
            
            RAISE NOTICE 'Member updated: Customer %, Visits: %, New Status: %', 
                NEW.CUSTOMER_ID, v_visit_count, v_new_member_status;
        END IF;
        
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER tr_update_member_after_registration
    AFTER INSERT OR UPDATE ON REGISTRATION
    FOR EACH ROW
    EXECUTE FUNCTION fn_update_member_visits();

UPDATE REGISTRATION 
SET REGISTRATION_STATUS = 'FINISHED' 
WHERE REGISTRATION_ID = 1;

SELECT 
    c.CUSTOMER_ID,
    c.NAME,
    m.MEMBER_STATUS,
    m.NUMBER_OF_VISITS,
    m.DISCOUNT_MEMBER
FROM CUSTOMER c
JOIN MEMBER m ON c.CUSTOMER_ID = m.CUSTOMER_ID
WHERE c.CUSTOMER_ID = 1;

/*============================================================================
         View untuk melihat daftar semua ruangan + status sekarang
=============================================================================*/
DROP VIEW IF EXISTS v_room_status_today;

CREATE OR REPLACE VIEW v_room_status_today AS
SELECT 
    r.ROOM_ID,
    r.ROOM_TYPE,
    r.CAPACITY,
    r.HOURLY_RATE,
    COALESCE(
        (SELECT 'OCCUPIED' 
         FROM REGISTRATION reg 
         WHERE reg.ROOM_ID = r.ROOM_ID 
           AND reg.RG_DATE = CURRENT_DATE
           AND reg.REGISTRATION_STATUS NOT IN ('CANCELLED', 'FINISHED')
           AND CURRENT_TIMESTAMP BETWEEN reg.START_TIME AND reg.END_TIME),
        (SELECT 'RESERVED' 
         FROM RESERVATION res 
         WHERE res.ROOM_ID = r.ROOM_ID 
           AND res.RV_DATE = CURRENT_DATE
           AND CURRENT_TIMESTAMP BETWEEN res.START_TIME AND res.END_TIME),
        (SELECT 'BOOKED' 
         FROM (
             SELECT ROOM_ID FROM REGISTRATION 
             WHERE ROOM_ID = r.ROOM_ID 
               AND RG_DATE = CURRENT_DATE
               AND REGISTRATION_STATUS NOT IN ('CANCELLED', 'FINISHED')
               AND CURRENT_TIMESTAMP < START_TIME
             UNION 
             SELECT ROOM_ID FROM RESERVATION 
             WHERE ROOM_ID = r.ROOM_ID 
               AND RV_DATE = CURRENT_DATE
               AND CURRENT_TIMESTAMP < START_TIME
         ) AS future_bookings),
        r.STATUS
    ) as CURRENT_STATUS,
    
    COALESCE(
        (SELECT c.NAME 
         FROM REGISTRATION reg 
         JOIN CUSTOMER c ON reg.CUSTOMER_ID = c.CUSTOMER_ID
         WHERE reg.ROOM_ID = r.ROOM_ID 
           AND reg.RG_DATE = CURRENT_DATE
           AND CURRENT_TIMESTAMP BETWEEN reg.START_TIME AND reg.END_TIME),
        (SELECT c.NAME 
         FROM RESERVATION res 
         JOIN CUSTOMER c ON res.CUSTOMER_ID = c.CUSTOMER_ID
         WHERE res.ROOM_ID = r.ROOM_ID 
           AND res.RV_DATE = CURRENT_DATE
           AND CURRENT_TIMESTAMP BETWEEN res.START_TIME AND res.END_TIME),
        'TIDAK ADA'
    ) as CURRENT_CUSTOMER,
    
    (SELECT 
        TO_CHAR(MIN(start_time), 'HH24:MI') || ' - ' || TO_CHAR(MIN(end_time), 'HH24:MI')
     FROM (
         SELECT START_TIME, END_TIME 
         FROM REGISTRATION 
         WHERE ROOM_ID = r.ROOM_ID 
           AND RG_DATE = CURRENT_DATE
           AND REGISTRATION_STATUS NOT IN ('CANCELLED', 'FINISHED')
           AND START_TIME > CURRENT_TIMESTAMP
         UNION 
         SELECT START_TIME, END_TIME 
         FROM RESERVATION 
         WHERE ROOM_ID = r.ROOM_ID 
           AND RV_DATE = CURRENT_DATE
           AND START_TIME > CURRENT_TIMESTAMP
     ) AS next_bookings
    ) as NEXT_BOOKING_TIME

FROM ROOM r
ORDER BY 
    CASE COALESCE(
        (SELECT 'OCCUPIED' FROM REGISTRATION reg WHERE reg.ROOM_ID = r.ROOM_ID 
         AND reg.RG_DATE = CURRENT_DATE AND CURRENT_TIMESTAMP BETWEEN reg.START_TIME AND reg.END_TIME),
        (SELECT 'RESERVED' FROM RESERVATION res WHERE res.ROOM_ID = r.ROOM_ID 
         AND res.RV_DATE = CURRENT_DATE AND CURRENT_TIMESTAMP BETWEEN res.START_TIME AND res.END_TIME),
        'AVAILABLE'
    )
        WHEN 'OCCUPIED' THEN 1
        WHEN 'RESERVED' THEN 2
        ELSE 3 
    END,
    r.ROOM_ID;

CREATE OR REPLACE VIEW v_room_schedule_today AS
SELECT 
    r.ROOM_ID,
    r.ROOM_TYPE,
    r.CAPACITY,
    'REGISTRATION' as BOOKING_TYPE,
    reg.REGISTRATION_ID as BOOKING_ID,
    c.NAME as CUSTOMER_NAME,
    reg.START_TIME,
    reg.END_TIME,
    reg.REGISTRATION_STATUS as STATUS,
    CASE 
        WHEN CURRENT_TIMESTAMP BETWEEN reg.START_TIME AND reg.END_TIME THEN 'SEDANG BERLANGSUNG'
        WHEN CURRENT_TIMESTAMP < reg.START_TIME THEN 'AKAN DATANG'
        ELSE 'SELESAI'
    END as TIME_STATUS
FROM ROOM r
JOIN REGISTRATION reg ON r.ROOM_ID = reg.ROOM_ID
JOIN CUSTOMER c ON reg.CUSTOMER_ID = c.CUSTOMER_ID
WHERE reg.RG_DATE = CURRENT_DATE
  AND reg.REGISTRATION_STATUS NOT IN ('CANCELLED')

UNION ALL

SELECT 
    r.ROOM_ID,
    r.ROOM_TYPE,
    r.CAPACITY,
    'RESERVATION' as BOOKING_TYPE,
    res.RESERVATION_ID as BOOKING_ID,
    c.NAME as CUSTOMER_NAME,
    res.START_TIME,
    res.END_TIME,
    'CONFIRMED' as STATUS,
    CASE 
        WHEN CURRENT_TIMESTAMP BETWEEN res.START_TIME AND res.END_TIME THEN 'SEDANG BERLANGSUNG'
        WHEN CURRENT_TIMESTAMP < res.START_TIME THEN 'AKAN DATANG'
        ELSE 'SELESAI'
    END as TIME_STATUS
FROM ROOM r
JOIN RESERVATION res ON r.ROOM_ID = res.ROOM_ID
JOIN CUSTOMER c ON res.CUSTOMER_ID = c.CUSTOMER_ID
WHERE res.RV_DATE = CURRENT_DATE

ORDER BY ROOM_ID, START_TIME;

-- Lihat semua ruangan dan statusnya hari ini
SELECT 
    ROOM_ID,
    ROOM_TYPE,
    CAPACITY,
    CURRENT_STATUS,
    CURRENT_CUSTOMER,
    NEXT_BOOKING_TIME
FROM v_room_status_today;
SELECT * FROM v_room_status_today;

-- Hanya ruangan yang sedang digunakan
SELECT * FROM v_room_status_today 
WHERE CURRENT_STATUS = 'OCCUPIED';

-- Hanya ruangan yang tersedia
SELECT * FROM v_room_status_today 
WHERE CURRENT_STATUS = 'AVAILABLE';

-- Ruangan yang sudah dibooking (baik sedang atau akan datang)
SELECT * FROM v_room_status_today 
WHERE CURRENT_STATUS IN ('OCCUPIED', 'RESERVED', 'BOOKED');

-- Semua jadwal booking hari ini
SELECT 
    ROOM_ID,
    ROOM_TYPE,
    CUSTOMER_NAME,
    BOOKING_TYPE,
    TO_CHAR(START_TIME, 'HH24:MI') as START,
    TO_CHAR(END_TIME, 'HH24:MI') as END,
    TIME_STATUS
FROM v_room_schedule_today
ORDER BY ROOM_ID, START_TIME;
SELECT * FROM v_room_schedule_today;

