/*==============================================================*/
/* DBMS name:      PostgreSQL 9.x                               */
/* Created on:     12/3/2025 9:34:25 AM                         */
/*==============================================================*/

drop index IF EXISTS CUSTOMER_PK;

drop table IF EXISTS CUSTOMER CASCADE;

drop index IF EXISTS PART_OF_FK;

drop table IF EXISTS MEMBER CASCADE;

drop index IF EXISTS RESULTS_PAYMENT_RESERVATION_FK;

drop table IF EXISTS PAYMENT CASCADE;

drop index IF EXISTS REFERS_TO_FK;

drop index IF EXISTS PERFORMS_FK;

drop table IF EXISTS PLAYS CASCADE;

drop index IF EXISTS ASSIGNED_FOR_RESERVATION_FK;

drop index IF EXISTS MAKE_RESERVATION_FK;

drop index IF EXISTS RESERVATION_PK;

drop table IF EXISTS RESERVATION CASCADE;

drop index IF EXISTS ROOM_PK;

drop table IF EXISTS ROOM CASCADE;

drop index IF EXISTS SONGS_PK;

drop table IF EXISTS SONGS CASCADE;

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
   CUSTOMER_ID          SERIAL               not null,
   MEMBER_STATUS        VARCHAR(9)           null,
   NUMBER_OF_VISITS     INT4                 null,
   DISCOUNT_MEMBER      FLOAT8               null,
   constraint AK_PK_MEMBER unique (CUSTOMER_ID)
);

/*==============================================================*/
/* Index: PART_OF_FK                                            */
/*==============================================================*/
create  index PART_OF_FK on MEMBER (
CUSTOMER_ID
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
/* Table: SONGS                                                 */
/*==============================================================*/
create table SONGS (
   SONGS_ID             SERIAL               not null,
   TITLE                VARCHAR(250)         null,
   ARTIST               VARCHAR(250)         null,
   GENRE                VARCHAR(250)         null,
   LANGUAGE             VARCHAR(250)         null,
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
/* Table: RESERVATION                                           */
/*==============================================================*/
create table RESERVATION (
   CUSTOMER_ID          INT4                 not null,
   RESERVATION_ID       SERIAL               not null,
   ROOM_ID              INT4                 not null,
   D_DATE               DATE                 null,
   START_TIME           TIMESTAMP            null,
   END_TIME             TIMESTAMP            null,
   RESERVATION_STATUS   VARCHAR(20)          null,
   RESERVATION_TYPE     VARCHAR(15)          null,
   PCT_DP               FLOAT8               null,
   PAID_DP              NUMERIC(8,2)         null,
   RESERVATION_DATE     DATE                 null,
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
/* Index: ASSIGNED_FOR_RESERVATION_FK                           */
/*==============================================================*/
create  index ASSIGNED_FOR_RESERVATION_FK on RESERVATION (
ROOM_ID
);

/*==============================================================*/
/* Table: TIME_EXTEND                                           */
/*==============================================================*/
create table TIME_EXTEND (
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
/* Table: PAYMENT                                               */
/*==============================================================*/
create table PAYMENT (
   PAYMENT_ID           SERIAL               not null,
   RESERVATION_ID       INT4                 not null,
   PAYMENT_METHOD       VARCHAR(10)          null,
   TOTAL_COST           NUMERIC(8,2)         null,
   DISCOUNT_MEMBER      FLOAT8               null,
   FINAL_COST           NUMERIC(8,2)         null,
   PAYMENT_TIME         TIMESTAMP            null,
   constraint PK_PAYMENT primary key (PAYMENT_ID)
);

/*==============================================================*/
/* Index: RESULTS_PAYMENT_RESERVATION_FK                        */
/*==============================================================*/
create  index RESULTS_PAYMENT_RESERVATION_FK on PAYMENT (
RESERVATION_ID
);

/*==============================================================*/
/* Table: PLAYS                                                 */
/*==============================================================*/
create table PLAYS (
   CUSTOMER_ID          INT4                 not null,
   SONGS_ID             INT4                 not null,
   SONG_START_TIME      TIMESTAMP            null,
   PLAY_DURATION        TIME                 null
);

/*==============================================================*/
/* Index: PERFORMS_FK                                           */
/*==============================================================*/
create  index PERFORMS_FK on PLAYS (
CUSTOMER_ID
);

/*==============================================================*/
/* Index: REFERS_TO_FK                                          */
/*==============================================================*/
create  index REFERS_TO_FK on PLAYS (
SONGS_ID
);

alter table MEMBER
   add constraint FK_MEMBER_PART_OF_CUSTOMER foreign key (CUSTOMER_ID)
      references CUSTOMER (CUSTOMER_ID)
      on delete restrict on update restrict;

alter table PAYMENT
   add constraint FK_PAYMENT_RESULTS_P_RESERVAT foreign key (RESERVATION_ID)
      references RESERVATION (RESERVATION_ID)
      on delete restrict on update restrict;

alter table PLAYS
   add constraint FK_PLAYS_PERFORMS_CUSTOMER foreign key (CUSTOMER_ID)
      references CUSTOMER (CUSTOMER_ID)
      on delete restrict on update restrict;

alter table PLAYS
   add constraint FK_PLAYS_REFERS_TO_SONGS foreign key (SONGS_ID)
      references SONGS (SONGS_ID)
      on delete restrict on update restrict;

alter table RESERVATION
   add constraint FK_RESERVAT_ASSIGNED__ROOM foreign key (ROOM_ID)
      references ROOM (ROOM_ID)
      on delete restrict on update restrict;

alter table RESERVATION
   add constraint FK_RESERVAT_MAKE_RESE_CUSTOMER foreign key (CUSTOMER_ID)
      references CUSTOMER (CUSTOMER_ID)
      on delete restrict on update restrict;

alter table TIME_EXTEND
   add constraint FK_TIME_EXT_RES_HAS_E_RESERVAT foreign key (RESERVATION_ID)
      references RESERVATION (RESERVATION_ID)
      on delete restrict on update restrict;

-- ===========================
-- INSERT INTO CUSTOMER (3)
-- ===========================
INSERT INTO CUSTOMER (NO_PHONE, NAME, PEOPLE_COMING) VALUES 
('081234567890', 'Shofi', 3),
('082198765432', 'Hana', 2),
('081345678901', 'Reida', 4),
('081456789012', 'alfa', 4);
SELECT * FROM CUSTOMER;

-- ===========================
-- INSERT INTO MEMBER (1)
-- ===========================
INSERT INTO MEMBER (CUSTOMER_ID, MEMBER_STATUS, NUMBER_OF_VISITS, DISCOUNT_MEMBER) VALUES 
(1, 'Silver', 12, 0.10),
(2,'Silver',5,0.05),
(3,'INACTIVE',0,0.00),
(4,'Platinum',30,0.15);
SELECT * FROM MEMBER;

-- ===========================
-- INSERT INTO ROOM (4)
-- ===========================
INSERT INTO ROOM (ROOM_TYPE, CAPACITY, HOURLY_RATE, STATUS) VALUES
('SMALL',4,50000,'AVAILABLE'),
('MEDIUM',6,75000,'AVAILABLE'),
('LARGE',8,100000,'AVAILABLE'),
('VIP',10,150000,'AVAILABLE');
SELECT * FROM ROOM;

-- ===========================
-- INSERT INTO SONGS (6)
-- ===========================
INSERT INTO SONGS (TITLE, ARTIST, GENRE, LANGUAGE, DURATION, LYRICS) VALUES
('Take A Chance With Me', 'NIKI', 'Pop / R&B', 'English', '00:03:45', 'Lyrics not included'),
('I Pray', 'LANY', 'Pop', 'English', '00:03:30', 'Lyrics not included'),
('Out Of My League', 'LANY', 'Pop', 'English', '00:03:20', 'Lyrics not included'),
('TAROT', '.Feast', 'Rock / Alternative', 'Indonesian', '00:04:20', 'Lyrics not included'),
('Rumah Ke Rumah', 'Hindia', 'Indie', 'Indonesian', '00:04:28', 'Lyrics not included'),
('Berdansalah, Karir Ini Tak Ada Artinya', 'Hindia', 'Alternative / Indie', 'Indonesian', '00:04:10', 'Lyrics not included');
SELECT * FROM SONGS;

-- ===========================
-- INSERT INTO RESERVATION (2)
-- ===========================
INSERT INTO RESERVATION 
(CUSTOMER_ID, ROOM_ID, D_DATE, START_TIME, END_TIME, RESERVATION_STATUS, RESERVATION_TYPE, PCT_DP, PAID_DP, RESERVATION_DATE)
VALUES
(1, 2, '2025-12-03', '2025-12-03 14:00', '2025-12-03 16:00', 'ONGOING', 'REGULAR', 0.3, 45000, '2025-12-01'),
(2, 1, '2025-12-03', '2025-12-03 15:00', '2025-12-03 17:00', 'ONGOING', 'WALKIN', 0, 0, '2025-12-03');
SELECT * FROM RESERVATION;

-- ===========================
-- INSERT INTO TIME EXTEND (1)
-- ===========================
INSERT INTO TIME_EXTEND (RESERVATION_ID, EXTENSION_DURATION, EXTENSION_COST) VALUES
(1, '00:30:00', 25000);
SELECT * FROM TIME_EXTEND;

-- ===========================
-- INSERT INTO PAYMENT (2)
-- ===========================
INSERT INTO PAYMENT (RESERVATION_ID, PAYMENT_METHOD, TOTAL_COST, DISCOUNT_MEMBER, FINAL_COST, PAYMENT_TIME)
VALUES
(1, 'CASH', 125000, 0.1, 112500, '2025-12-03 16:10'),
(2, 'QRIS', 100000, 0, 100000, '2025-12-03 17:10');
SELECT * FROM PAYMENT;

-- ===========================
-- INSERT INTO PLAYS (3)
-- ===========================
INSERT INTO PLAYS (CUSTOMER_ID, SONGS_ID, SONG_START_TIME, PLAY_DURATION)
VALUES
(1, 1, '2025-12-03 14:05', '00:04:55'),
(1, 3, '2025-12-03 14:12', '00:03:25'),
(2, 2, '2025-12-03 15:10', '00:03:30');
SELECT * FROM PLAYS;




/*==============================================================*/
/*        Function untuk me-return level membership             */
/*==============================================================*/

CREATE OR REPLACE FUNCTION fn_membership_level(p_customer_id INT)
RETURNS VARCHAR AS $$
DECLARE
    v_visit_count INT;
    v_member_status VARCHAR(9);
    v_level VARCHAR(15);
BEGIN
    SELECT MEMBER_STATUS, NUMBER_OF_VISITS 
    INTO v_member_status, v_visit_count
    FROM MEMBER 
    WHERE CUSTOMER_ID = p_customer_id;
    
    IF NOT FOUND THEN
        RETURN 'Non-Member';
    END IF;
    
    IF v_visit_count >= 30 THEN
        v_level := 'Platinum';
    ELSIF v_visit_count >= 15 THEN
        v_level := 'Gold';
    ELSIF v_visit_count >= 5 THEN
        v_level := 'Silver';
    ELSE
        v_level := 'Member Inactive';
    END IF;
    
    RETURN v_level;
END;
$$ LANGUAGE plpgsql;

SELECT 
    c.CUSTOMER_ID,
    c.NAME,
    fn_membership_level(c.CUSTOMER_ID) AS membership_level,
    m.NUMBER_OF_VISITS,
    m.DISCOUNT_MEMBER
FROM CUSTOMER c
LEFT JOIN MEMBER m ON c.CUSTOMER_ID = m.CUSTOMER_ID
WHERE m.CUSTOMER_ID IS NOT NULL;

/*==============================================================*/
/*      Procedure untuk menambahkan registrasi on-the spot      */
/*==============================================================*/
CREATE OR REPLACE FUNCTION fn_check_room_availability(
    p_room_id INT,
    p_check_date DATE,
    p_start_time TIMESTAMP,
    p_end_time TIMESTAMP
)
RETURNS TABLE (
    is_available BOOLEAN,
    room_type_info VARCHAR(10),
    room_status_info VARCHAR(20),
    room_capacity INT,
    conflict_reason_info VARCHAR(100)
) AS $$
DECLARE
    v_room_status VARCHAR(20);
    v_room_type VARCHAR(10);
    v_capacity INT;
    v_conflict_count INT;
BEGIN
    SELECT ROOM_TYPE, STATUS, CAPACITY
    INTO v_room_type, v_room_status, v_capacity
    FROM ROOM
    WHERE ROOM_ID = p_room_id;

    IF NOT FOUND THEN
        RETURN QUERY 
        SELECT 
            FALSE,
            NULL::VARCHAR(10),
            NULL::VARCHAR(20),
            NULL::INT,
            'Room not found.'::VARCHAR(100);
        RETURN;
    END IF;

    IF v_room_status != 'AVAILABLE' THEN
        RETURN QUERY 
        SELECT 
            FALSE,
            v_room_type,
            v_room_status,
            v_capacity,
            ('Room is currently ' || v_room_status)::VARCHAR(100);
        RETURN;
    END IF;

    SELECT COUNT(*) INTO v_conflict_count
    FROM RESERVATION r
    WHERE r.ROOM_ID = p_room_id
      AND r.D_DATE = p_check_date
      AND r.RESERVATION_STATUS NOT IN ('CANCELLED','FINISHED')
      AND (p_start_time < r.END_TIME AND p_end_time > r.START_TIME);

    IF v_conflict_count > 0 THEN
        RETURN QUERY 
        SELECT 
            FALSE,
            v_room_type,
            v_room_status,
            v_capacity,
            'Schedule conflicts with existing reservation'::VARCHAR(100);
        RETURN;
    END IF;

    RETURN QUERY 
    SELECT 
        TRUE,
        v_room_type,
        v_room_status,
        v_capacity,
        'Available'::VARCHAR(100);
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE sp_create_registration(
    p_customer_id INT,
    p_room_id INT,
    p_date DATE,
    p_start TIMESTAMP,
    p_end TIMESTAMP
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_customer_name VARCHAR(80);
    v_people_coming INT;

    v_is_available BOOLEAN;
    v_avail_room_type VARCHAR(10);
    v_avail_room_status VARCHAR(20);
    v_avail_capacity INT;
    v_conflict_reason VARCHAR(100);

    v_room_type VARCHAR(10);
    v_hourly_rate NUMERIC(8,2);

    v_duration_hours NUMERIC;
    v_total_cost NUMERIC(12,2);
    v_reservation_id INT;
BEGIN
    IF p_customer_id IS NULL THEN
        RAISE EXCEPTION 'Customer ID cannot be null';
    END IF;
    IF p_room_id IS NULL THEN
        RAISE EXCEPTION 'Room ID cannot be null';
    END IF;
    IF p_date IS NULL THEN
        RAISE EXCEPTION 'Date cannot be null';
    END IF;
    IF p_start IS NULL OR p_end IS NULL THEN
        RAISE EXCEPTION 'Start time and end time cannot be null';
    END IF;
    IF p_end <= p_start THEN
        RAISE EXCEPTION 'End time must be after start time';
    END IF;

    SELECT NAME, PEOPLE_COMING
    INTO v_customer_name, v_people_coming
    FROM CUSTOMER
    WHERE CUSTOMER_ID = p_customer_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Customer with ID % not found', p_customer_id;
    END IF;

    SELECT 
        is_available,
        room_type_info,
        room_status_info,
        room_capacity,
        conflict_reason_info
    INTO 
        v_is_available,
        v_avail_room_type,
        v_avail_room_status,
        v_avail_capacity,
        v_conflict_reason
    FROM fn_check_room_availability(p_room_id, p_date, p_start, p_end);

    IF NOT v_is_available THEN
        RAISE EXCEPTION 'Room unavailable: %', v_conflict_reason;
    END IF;

    IF v_people_coming > v_avail_capacity THEN
        RAISE EXCEPTION 
            'People coming (%) exceeds room capacity (%)',
            v_people_coming, v_avail_capacity;
    END IF;

    SELECT ROOM_TYPE, HOURLY_RATE
    INTO v_room_type, v_hourly_rate
    FROM ROOM
    WHERE ROOM_ID = p_room_id;

    v_duration_hours := EXTRACT(EPOCH FROM (p_end - p_start)) / 3600;
    v_total_cost := ROUND(v_duration_hours * v_hourly_rate, 2);

    INSERT INTO RESERVATION (
        CUSTOMER_ID,
        ROOM_ID,
        D_DATE,
        START_TIME,
        END_TIME,
        RESERVATION_STATUS,
        RESERVATION_TYPE,
        PCT_DP,
        PAID_DP,
        RESERVATION_DATE
    )
    VALUES (
        p_customer_id,
        p_room_id,
        p_date,
        p_start,
        p_end,
        'ONGOING',
        'WALKIN',
        0,
        0,
        CURRENT_DATE
    )
    RETURNING RESERVATION_ID INTO v_reservation_id;

    UPDATE ROOM
    SET STATUS = 'OCCUPIED'
    WHERE ROOM_ID = p_room_id;

    RAISE NOTICE '=================================================';
    RAISE NOTICE '           WALK-IN REGISTRATION SUMMARY          ';
    RAISE NOTICE '=================================================';
    RAISE NOTICE 'Reservation ID       : %', v_reservation_id;
    RAISE NOTICE 'Customer Name        : %', v_customer_name;
    RAISE NOTICE 'People Coming        : % (Room Capacity: %)', v_people_coming, v_avail_capacity;
    RAISE NOTICE '--------------------------------------------------';
    RAISE NOTICE 'Room ID              : %', p_room_id;
    RAISE NOTICE 'Room Type            : %', v_room_type;
    RAISE NOTICE 'Room Status Before   : AVAILABLE';
    RAISE NOTICE 'Room Status Now      : OCCUPIED';
    RAISE NOTICE '-------------------------------------------------';
    RAISE NOTICE 'Date                 : %', p_date;
    RAISE NOTICE 'Start Time           : %', p_start::time;
    RAISE NOTICE 'End Time             : %', p_end::time;
    RAISE NOTICE 'Duration (Hours)     : %', ROUND(v_duration_hours, 2);
    RAISE NOTICE '-------------------------------------------------';
    RAISE NOTICE 'Hourly Rate          : Rp %', v_hourly_rate;
    RAISE NOTICE 'Total Cost           : Rp %', v_total_cost;
    RAISE NOTICE 'Reservation Type     : WALK-IN (NO DP REQUIRED)';
    RAISE NOTICE '==================================================';

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Walk-in registration failed: %', SQLERRM;
END;
$$;

CALL sp_create_registration(
    4,  -- Customer ID alfa
    1,  -- Room ID 1 (SMALL, capacity 4)
    '2025-12-03', 
    '2025-12-03 17:30', 
    '2025-12-03 19:30'
);

/*==================================================================*/
/*      Procedure untuk pembatalan reservasi dengan aturan H-3      */
/*==================================================================*/
CREATE OR REPLACE PROCEDURE sp_cancel_reservation(p_reservation_id INT)
LANGUAGE plpgsql
AS $$
DECLARE
    v_reservation RECORD;
    v_days_before INT;
    v_refund_amount NUMERIC(8,2);
    v_customer_name VARCHAR(80);
    v_room_type VARCHAR(10);
BEGIN
    IF p_reservation_id IS NULL THEN
        RAISE EXCEPTION 'Reservation ID must be filled';
    END IF;
    
    SELECT 
        r.*,
        c.NAME AS customer_name,
        rm.ROOM_TYPE,
        rm.HOURLY_RATE,
        EXTRACT(EPOCH FROM (r.END_TIME - r.START_TIME)) / 3600 AS duration_hours
    INTO v_reservation
    FROM RESERVATION r
    JOIN CUSTOMER c ON r.CUSTOMER_ID = c.CUSTOMER_ID
    JOIN ROOM rm ON r.ROOM_ID = rm.ROOM_ID
    WHERE r.RESERVATION_ID = p_reservation_id;
    
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Reservation ID % not found', p_reservation_id;
    END IF;
    
    IF v_reservation.RESERVATION_STATUS = 'CANCELLED' THEN
        RAISE NOTICE 'Reservation ID % already candelled', p_reservation_id;
        RETURN;
    END IF;
    
    IF v_reservation.RESERVATION_STATUS = 'FINISHED' THEN
        RAISE EXCEPTION 'Cannot cancel finished reservation';
    END IF;
    
    v_days_before := v_reservation.D_DATE - CURRENT_DATE;
    
    RAISE NOTICE 'Reservation for date: %, Today: %, Days between: %', 
        v_reservation.D_DATE, CURRENT_DATE, v_days_before;
    
    IF v_days_before < 3 THEN
        -- DP hangus
        v_refund_amount := 0;
        RAISE NOTICE 'Cancellation does not fulfill D-3. DP Rp % will not be refunded.', 
            v_reservation.PAID_DP;
    ELSE
        -- DP dikembalikan
        v_refund_amount := v_reservation.PAID_DP;
        RAISE NOTICE 'Cancellation successful. DP Rp % will be refunded.', 
            v_refund_amount;
    END IF;
    
    UPDATE RESERVATION 
    SET RESERVATION_STATUS = 'CANCELLED'
    WHERE RESERVATION_ID = p_reservation_id;
    
    IF v_reservation.RESERVATION_STATUS IN ('ONGOING', 'CONFIRMED') THEN
        UPDATE ROOM 
        SET STATUS = 'AVAILABLE'
        WHERE ROOM_ID = v_reservation.ROOM_ID;
        
        RAISE NOTICE 'Room status % changed to AVAILABLE', v_reservation.ROOM_TYPE;
    END IF;
    
    INSERT INTO PAYMENT (
        RESERVATION_ID,
        PAYMENT_METHOD,
        TOTAL_COST,
        DISCOUNT_MEMBER,
        FINAL_COST,
        PAYMENT_TIME
    ) VALUES (
        p_reservation_id,
        'REFUND',
        0,
        0,
        -v_refund_amount,  -- Nilai negatif untuk menandakan refund
        CURRENT_TIMESTAMP
    );
    
    RAISE NOTICE '========================================';
    RAISE NOTICE 'RESERVATION CANCELLATION SUCCESSFUL';
    RAISE NOTICE '========================================';
    RAISE NOTICE 'Reservation ID: %', p_reservation_id;
    RAISE NOTICE 'Customer: %', v_reservation.customer_name;
    RAISE NOTICE 'Room: %', v_reservation.ROOM_TYPE;
    RAISE NOTICE 'Date: %', v_reservation.D_DATE;
    RAISE NOTICE 'Time: % - %', 
        v_reservation.START_TIME::time, 
        v_reservation.END_TIME::time;
    RAISE NOTICE 'Status before: %', v_reservation.RESERVATION_STATUS;
    RAISE NOTICE 'Paid DP: Rp %', v_reservation.PAID_DP;
    RAISE NOTICE 'Refunded DP: Rp %', v_refund_amount;
    RAISE NOTICE 'Cancellation time: %', CURRENT_TIMESTAMP;
    RAISE NOTICE '========================================';
    
EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Failed to cancel Reservation: %', SQLERRM;
END;
$$;

-- Reset data untuk test procedure
UPDATE RESERVATION SET RESERVATION_STATUS = 'CONFIRMED' WHERE RESERVATION_ID IN (1,2);
UPDATE ROOM SET STATUS = 'AVAILABLE' WHERE ROOM_ID IN (1,2,3,4);

INSERT INTO RESERVATION 
(CUSTOMER_ID, ROOM_ID, D_DATE, START_TIME, END_TIME, RESERVATION_STATUS, RESERVATION_TYPE, PCT_DP, PAID_DP, RESERVATION_DATE)
VALUES
(3, 3, CURRENT_DATE + 5,  -- 5 hari dari sekarang (bisa dibatalkan)
 CURRENT_DATE + 5 + TIME '14:00', 
 CURRENT_DATE + 5 + TIME '16:00', 
 'CONFIRMED', 
 'REGULAR', 
 0.3, 
 45000,  -- DP 30% dari 150000
 CURRENT_DATE);

 SELECT * FROM RESERVATION;

 -- Test procedure berhasil: Cancel reservasi (H-5, DP dikembalikan)
CALL sp_cancel_reservation(3);

INSERT INTO RESERVATION 
(CUSTOMER_ID, ROOM_ID, D_DATE, START_TIME, END_TIME, RESERVATION_STATUS, RESERVATION_TYPE, PCT_DP, PAID_DP, RESERVATION_DATE)
VALUES
(3, 3, CURRENT_DATE + 1,  -- 1 hari dari sekarang (terlambat)
 CURRENT_DATE + 1 + TIME '14:00', 
 CURRENT_DATE + 1 + TIME '16:00', 
 'CONFIRMED', 
 'REGULAR', 
 0.3, 
 45000,  -- DP 30% dari 150000
 CURRENT_DATE);

 -- Test procedure hangus: Cancel reservasi (H-1)
CALL sp_cancel_reservation(13);

/*============================================================================*/
/*            Procedure untuk meminta alternatif jadwal dan ruangan           */
/*============================================================================*/
CREATE OR REPLACE PROCEDURE sp_suggest_alternative_schedule(
    p_room_id INT,
    p_date DATE,
    p_start TIMESTAMP,
    p_end TIMESTAMP,
    p_num_people INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_room_type VARCHAR(10);
    v_room_capacity INT;
    v_conflict_count INT;
    v_alternative_found BOOLEAN := FALSE;
    v_capacity_ok BOOLEAN := TRUE;
    v_alternative_room RECORD;
BEGIN
    RAISE NOTICE '========================================';
    RAISE NOTICE 'REQUEST: Room % at %', p_room_id, p_date;
    RAISE NOTICE 'Time: % - %', p_start::time, p_end::time;
    RAISE NOTICE 'Number of people: %', p_num_people;
    RAISE NOTICE '========================================';
    
    SELECT ROOM_TYPE, CAPACITY 
    INTO v_room_type, v_room_capacity
    FROM ROOM 
    WHERE ROOM_ID = p_room_id;
    
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Room ID % not found', p_room_id;
    END IF;

    IF p_num_people > v_room_capacity THEN
        v_capacity_ok := FALSE;
        RAISE NOTICE 'Number of people (% people) exceeds room capacity % (% people)', 
            p_num_people, v_room_type, v_room_capacity;
    END IF;
    
    SELECT COUNT(*) INTO v_conflict_count
    FROM RESERVATION r
    WHERE r.ROOM_ID = p_room_id
      AND r.D_DATE = p_date
      AND r.RESERVATION_STATUS NOT IN ('CANCELLED', 'FINISHED')
      AND (p_start < r.END_TIME AND p_end > r.START_TIME);
    
    IF v_conflict_count = 0 AND v_capacity_ok THEN
        RAISE NOTICE 'Room % available at desired time, no alternative needed', v_room_type;
        RETURN;
    END IF;

    RAISE NOTICE 'Room % unavailable OR capacity insufficient', v_room_type;
    RAISE NOTICE 'Conflicts: % | Capacity OK: %', v_conflict_count, v_capacity_ok;
    RAISE NOTICE 'Searching alternatives...';
    RAISE NOTICE '========================================';
    
    FOR v_alternative_room IN
        SELECT 
            r.ROOM_ID,
            r.ROOM_TYPE,
            r.CAPACITY,
            r.HOURLY_RATE,
            r.STATUS,
            (
                SELECT COUNT(*)
                FROM RESERVATION res
                WHERE res.ROOM_ID = r.ROOM_ID
                  AND res.D_DATE = p_date
                  AND res.RESERVATION_STATUS NOT IN ('CANCELLED', 'FINISHED')
                  AND (p_start < res.END_TIME AND p_end > res.START_TIME)
            ) AS conflict_count
        FROM ROOM r
        WHERE r.CAPACITY >= p_num_people  
          AND r.ROOM_ID != p_room_id  
        ORDER BY r.CAPACITY ASC, r.HOURLY_RATE ASC
    LOOP
        IF v_alternative_room.conflict_count = 0 THEN
            RAISE NOTICE '=== Room alternative:';
            RAISE NOTICE '    Room: % (ID: %)', v_alternative_room.ROOM_TYPE, v_alternative_room.ROOM_ID;
            RAISE NOTICE '    Capacity: %', v_alternative_room.CAPACITY;
            RAISE NOTICE '    Cost: Rp %/h', v_alternative_room.HOURLY_RATE;
            RAISE NOTICE '    Status: %', v_alternative_room.STATUS;
            RAISE NOTICE '    Schedule: % - % (as requested)', 
                p_start::time, p_end::time;
            RAISE NOTICE '';
            v_alternative_found := TRUE;
        END IF;
    END LOOP;
    
    IF NOT v_alternative_found THEN
        RAISE NOTICE 'No alternative room or schedule available';
    END IF;

    RAISE NOTICE '========================================';
    
EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Failed to find alternatives: %', SQLERRM;
END;
$$;

-- Setup: Booking room 1 dan 2, biarkan room 3 kosong
UPDATE RESERVATION SET RESERVATION_STATUS = 'CONFIRMED' 
WHERE ROOM_ID IN (1,2) AND D_DATE = CURRENT_DATE;

-- Test procedure berhasil: Cari alternatif untuk room 1 yang penuh
CALL sp_suggest_alternative_schedule(
    1,  -- SMALL room (capacity 4, penuh)
    CURRENT_DATE,
    CURRENT_DATE + TIME '14:00',
    CURRENT_DATE + TIME '16:00',
    3   -- num_people
);

CALL sp_suggest_alternative_schedule(
    1,  -- room_id (SMALL, capacity 4)
    CURRENT_DATE,  -- date
    CURRENT_DATE + TIME '15:00',  -- start (konflik sebagian)
    CURRENT_DATE + TIME '17:00',  -- end
    6   -- num_people (lebih dari capacity)
);

/*============================================================================*/
/*    Trigger untuk cek jumlah kedatangan tidak melebihi kapasitas ruangan    */
/*============================================================================*/
CREATE OR REPLACE FUNCTION trg_check_room_capacity()
RETURNS TRIGGER 
LANGUAGE plpgsql
AS $$
DECLARE
    v_people_coming INT;
    v_room_capacity INT;
    v_room_type VARCHAR(10);
    v_customer_name VARCHAR(80);
BEGIN
    SELECT c.PEOPLE_COMING, c.NAME
    INTO v_people_coming, v_customer_name
    FROM CUSTOMER c
    WHERE c.CUSTOMER_ID = NEW.CUSTOMER_ID;
    
    SELECT r.CAPACITY, r.ROOM_TYPE
    INTO v_room_capacity, v_room_type
    FROM ROOM r
    WHERE r.ROOM_ID = NEW.ROOM_ID;
    
    IF v_people_coming > v_room_capacity THEN
        RAISE EXCEPTION 'Customer "%" has % people, exceeds room capacity % (% people)', 
            v_customer_name, v_people_coming, v_room_type, v_room_capacity;
    END IF;
    
    IF v_people_coming IS NULL OR v_people_coming <= 0 THEN
        RAISE EXCEPTION 'Number of people must be more than 0';
    END IF;
    
    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_check_capacity_before_insert
BEFORE INSERT ON RESERVATION
FOR EACH ROW
EXECUTE FUNCTION trg_check_room_capacity();

-- Reset data customer
UPDATE CUSTOMER SET PEOPLE_COMING = 2 WHERE CUSTOMER_ID = 1;  -- Shofi jadi 2 orang
UPDATE CUSTOMER SET PEOPLE_COMING = 2 WHERE CUSTOMER_ID = 2;  -- Hana jadi 2 orang

-- Reset status room
UPDATE ROOM SET STATUS = 'AVAILABLE' WHERE ROOM_ID IN (1,2,3,4);

-- Test trigger GAGAL: Customer dengan 4 orang mencoba booking SMALL room (capacity 4)
-- UPDATE dulu customer ID 3 (Reida) menjadi 5 orang
UPDATE CUSTOMER SET PEOPLE_COMING = 5 WHERE CUSTOMER_ID = 3;

-- Coba insert reservasi - HARUS GAGAL karena 5 orang > capacity 4
BEGIN;
    INSERT INTO RESERVATION 
    (CUSTOMER_ID, ROOM_ID, D_DATE, START_TIME, END_TIME, RESERVATION_STATUS, RESERVATION_TYPE)
    VALUES
    (3, 1, CURRENT_DATE + 1,  -- Room 1 = SMALL (capacity 4)
     CURRENT_DATE + 1 + TIME '10:00', 
     CURRENT_DATE + 1 + TIME '12:00', 
     'CONFIRMED', 
     'REGULAR');

/*============================================================================*/
/*      Trigger untuk auto-update jumlah kedatangan & level membership        */
/*============================================================================*/
CREATE OR REPLACE FUNCTION trg_update_member_visits()
RETURNS TRIGGER 
LANGUAGE plpgsql
AS $$
DECLARE
    v_current_visits INT;
    v_new_visits INT;
    v_discount FLOAT8;
    v_member_status VARCHAR(9);
BEGIN
    IF (NEW.RESERVATION_STATUS = 'FINISHED' AND 
        (OLD.RESERVATION_STATUS IS NULL OR OLD.RESERVATION_STATUS != 'FINISHED')) THEN
        
        PERFORM 1 FROM MEMBER WHERE CUSTOMER_ID = NEW.CUSTOMER_ID;
        
        IF FOUND THEN
            SELECT NUMBER_OF_VISITS, DISCOUNT_MEMBER, MEMBER_STATUS 
            INTO v_current_visits, v_discount, v_member_status
            FROM MEMBER 
            WHERE CUSTOMER_ID = NEW.CUSTOMER_ID;
            
            v_new_visits := COALESCE(v_current_visits, 0) + 1;
            
            UPDATE MEMBER 
            SET NUMBER_OF_VISITS = v_new_visits
            WHERE CUSTOMER_ID = NEW.CUSTOMER_ID;
            
            UPDATE MEMBER 
            SET 
                DISCOUNT_MEMBER = CASE
                    WHEN v_new_visits >= 30 THEN 0.15  -- Platinum
                    WHEN v_new_visits >= 15 THEN 0.10  -- Gold
                    WHEN v_new_visits >= 5 THEN 0.05   -- Silver
                    ELSE 0.00
                END,
                MEMBER_STATUS = CASE
                    WHEN v_new_visits >= 30 THEN 'Platinum'
                    WHEN v_new_visits >= 15 THEN 'Gold'
                    WHEN v_new_visits >= 5 THEN 'Silver'
                    WHEN v_member_status = 'INACTIVE' THEN 'INACTIVE'
                    ELSE 'Active'
                END
            WHERE CUSTOMER_ID = NEW.CUSTOMER_ID;
            
            RAISE NOTICE 'Updated member visits for customer_id %: % → % visits', 
                NEW.CUSTOMER_ID, v_current_visits, v_new_visits;
        ELSE
            RAISE NOTICE 'Customer_id % is not a member, no visit count updated', NEW.CUSTOMER_ID;
        END IF;
    END IF;
    
    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_update_visits_after_finish
AFTER UPDATE ON RESERVATION
FOR EACH ROW
WHEN (NEW.RESERVATION_STATUS = 'FINISHED')
EXECUTE FUNCTION trg_update_member_visits();

SELECT 
    c.CUSTOMER_ID,
    c.NAME,
    m.MEMBER_STATUS,
    m.NUMBER_OF_VISITS AS visits_before,
    m.DISCOUNT_MEMBER AS discount_before
FROM CUSTOMER c
LEFT JOIN MEMBER m ON c.CUSTOMER_ID = m.CUSTOMER_ID
WHERE c.CUSTOMER_ID = 1;

INSERT INTO RESERVATION 
(CUSTOMER_ID, ROOM_ID, D_DATE, START_TIME, END_TIME, RESERVATION_STATUS, RESERVATION_TYPE)
VALUES
(1, 3, CURRENT_DATE,  -- Customer ID 1 (Shofi) - Member dengan 12 visits
 CURRENT_DATE + TIME '10:00', 
 CURRENT_DATE + TIME '12:00', 
 'ONGOING', 
 'WALKIN');

SELECT 
    RESERVATION_ID,
    CUSTOMER_ID,
    RESERVATION_STATUS
FROM RESERVATION 
WHERE CUSTOMER_ID = 1 
ORDER BY RESERVATION_ID DESC 
LIMIT 1;

UPDATE RESERVATION 
SET RESERVATION_STATUS = 'FINISHED'
WHERE CUSTOMER_ID = 1 
  AND RESERVATION_STATUS = 'ONGOING'
  AND D_DATE = CURRENT_DATE
  AND START_TIME = CURRENT_DATE + TIME '10:00';

SELECT 
    c.CUSTOMER_ID,
    c.NAME,
    m.MEMBER_STATUS,
    m.NUMBER_OF_VISITS AS visits_after,
    m.DISCOUNT_MEMBER AS discount_after,
    -- Hitung perubahan
    m.NUMBER_OF_VISITS - 12 AS visit_increment  -- 12 adalah jumlah awal
FROM CUSTOMER c
JOIN MEMBER m ON c.CUSTOMER_ID = m.CUSTOMER_ID
WHERE c.CUSTOMER_ID = 1;

/*============================================================================*/
/*            Trigger untuk auto-update Status Ruangan                        */
/*============================================================================*/
CREATE OR REPLACE FUNCTION trg_update_room_status()
RETURNS TRIGGER 
LANGUAGE plpgsql
AS $$
BEGIN
    IF NEW.RESERVATION_STATUS = 'ONGOING' AND 
       (OLD.RESERVATION_STATUS IS NULL OR OLD.RESERVATION_STATUS != 'ONGOING') THEN
        UPDATE ROOM SET STATUS = 'OCCUPIED' WHERE ROOM_ID = NEW.ROOM_ID;
        RAISE NOTICE 'Room % status updated to OCCUPIED', NEW.ROOM_ID;
    
    ELSIF (NEW.RESERVATION_STATUS = 'FINISHED' OR NEW.RESERVATION_STATUS = 'CANCELLED') AND
          (OLD.RESERVATION_STATUS IS NULL OR 
           (OLD.RESERVATION_STATUS != 'FINISHED' AND OLD.RESERVATION_STATUS != 'CANCELLED')) THEN
        UPDATE ROOM SET STATUS = 'AVAILABLE' WHERE ROOM_ID = NEW.ROOM_ID;
        RAISE NOTICE 'Room % status updated to AVAILABLE', NEW.ROOM_ID;
    
    ELSIF NEW.RESERVATION_STATUS = 'CONFIRMED' AND 
          (OLD.RESERVATION_STATUS IS NULL OR OLD.RESERVATION_STATUS != 'CONFIRMED') THEN
        UPDATE ROOM SET STATUS = 'RESERVED' WHERE ROOM_ID = NEW.ROOM_ID;
        RAISE NOTICE 'Room % status updated to RESERVED', NEW.ROOM_ID;
    END IF;
    
    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_auto_room_status
AFTER INSERT OR UPDATE ON RESERVATION
FOR EACH ROW
EXECUTE FUNCTION trg_update_room_status();

-- 1. Reset room status ke AVAILABLE
UPDATE ROOM SET STATUS = 'AVAILABLE' WHERE ROOM_ID = 1;

SELECT 'Room 1 status sebelum: ' || STATUS AS info FROM ROOM WHERE ROOM_ID = 1;

-- 2. Insert reservasi dengan status CONFIRMED (harus jadi RESERVED)
INSERT INTO RESERVATION 
(CUSTOMER_ID, ROOM_ID, D_DATE, START_TIME, END_TIME, RESERVATION_STATUS, RESERVATION_TYPE)
VALUES
(1, 1, CURRENT_DATE + 1, 
 CURRENT_DATE + 1 + TIME '14:00', 
 CURRENT_DATE + 1 + TIME '16:00', 
 'CONFIRMED',  -- Status baru
 'REGULAR');

SELECT 'Room 1 status sesudah: ' || STATUS AS info FROM ROOM WHERE ROOM_ID = 1;

-- 3. Update ke ONGOING (harus jadi OCCUPIED)
UPDATE RESERVATION 
SET RESERVATION_STATUS = 'ONGOING'
WHERE ROOM_ID = 1 
  AND D_DATE = CURRENT_DATE + 1 
  AND START_TIME = CURRENT_DATE + 1 + TIME '14:00';

SELECT 'Room 1 status: ' || STATUS AS info FROM ROOM WHERE ROOM_ID = 1;

-- 4. Update ke FINISHED (harus jadi AVAILABLE)
UPDATE RESERVATION 
SET RESERVATION_STATUS = 'FINISHED'
WHERE ROOM_ID = 1 
  AND D_DATE = CURRENT_DATE + 1 
  AND START_TIME = CURRENT_DATE + 1 + TIME '14:00';

SELECT 'Room 1 status: ' || STATUS AS info FROM ROOM WHERE ROOM_ID = 1;

-- 5. Test CANCELLED (harus jadi AVAILABLE)
INSERT INTO RESERVATION 
(CUSTOMER_ID, ROOM_ID, D_DATE, START_TIME, END_TIME, RESERVATION_STATUS, RESERVATION_TYPE)
VALUES
(2, 2, CURRENT_DATE + 1, 
 CURRENT_DATE + 1 + TIME '18:00', 
 CURRENT_DATE + 1 + TIME '20:00', 
 'CONFIRMED',
 'REGULAR');
SELECT 'Room 2 status setelah CONFIRMED: ' || STATUS FROM ROOM WHERE ROOM_ID = 2;

UPDATE RESERVATION 
SET RESERVATION_STATUS = 'CANCELLED'
WHERE ROOM_ID = 2 
  AND D_DATE = CURRENT_DATE + 1 
  AND START_TIME = CURRENT_DATE + 1 + TIME '18:00';

SELECT 'Room 2 status setelah CANCELLED: ' || STATUS FROM ROOM WHERE ROOM_ID = 2;

/*============================================================================*/
/*               View untuk lihat status ruangan hari ini                     */
/*============================================================================*/
CREATE OR REPLACE VIEW v_room_status_today AS
SELECT 
    r.ROOM_ID,
    r.ROOM_TYPE,
    r.CAPACITY,
    r.HOURLY_RATE,
    -- Status ruangan hari ini (prioritas: ONGOING > CONFIRMED > AVAILABLE)
    CASE 
        WHEN EXISTS (
            SELECT 1 
            FROM RESERVATION res 
            WHERE res.ROOM_ID = r.ROOM_ID 
              AND res.D_DATE = CURRENT_DATE
              AND res.RESERVATION_STATUS = 'ONGOING'
        ) THEN 'OCCUPIED'
        
        WHEN EXISTS (
            SELECT 1 
            FROM RESERVATION res 
            WHERE res.ROOM_ID = r.ROOM_ID 
              AND res.D_DATE = CURRENT_DATE
              AND res.RESERVATION_STATUS = 'CONFIRMED'
        ) THEN 'RESERVED'
        
        ELSE r.STATUS
    END AS TODAY_STATUS,
    
    -- Informasi reservasi hari ini (jika ada)
    (
        SELECT 
            STRING_AGG(
                CONCAT(
                    c.NAME, 
                    ' (', 
                    CASE res.RESERVATION_STATUS
                        WHEN 'ONGOING' THEN 'ONGOING'
                        WHEN 'CONFIRMED' THEN 'CONFIRMED'
                        WHEN 'CANCELLED' THEN 'CANCELLED'
                        WHEN 'FINISHED' THEN 'FINISHED'
                        ELSE res.RESERVATION_STATUS
                    END,
                    ')',
                    ' ', 
                    TO_CHAR(res.START_TIME, 'HH24:MI'), 
                    '-', 
                    TO_CHAR(res.END_TIME, 'HH24:MI'),
                    ' (', res.RESERVATION_TYPE, ')'
                ), 
                ', '
            )
        FROM RESERVATION res
        JOIN CUSTOMER c ON res.CUSTOMER_ID = c.CUSTOMER_ID
        WHERE res.ROOM_ID = r.ROOM_ID
          AND res.D_DATE = CURRENT_DATE
          AND res.RESERVATION_STATUS IN ('ONGOING', 'CONFIRMED')
    ) AS TODAY_BOOKINGS,
    
    -- Jam pemakaian hari ini (dalam format rentang waktu)
    (
        SELECT 
            STRING_AGG(
                CONCAT(
                    TO_CHAR(res.START_TIME, 'HH24:MI'), 
                    '-', 
                    TO_CHAR(res.END_TIME, 'HH24:MI')
                ), 
                ', '
            )
        FROM RESERVATION res
        WHERE res.ROOM_ID = r.ROOM_ID
          AND res.D_DATE = CURRENT_DATE
          AND res.RESERVATION_STATUS IN ('ONGOING', 'CONFIRMED')
    ) AS USAGE_HOURS,
    
    -- Customer yang sedang menggunakan/booking hari ini
    (
        SELECT 
            STRING_AGG(DISTINCT c.NAME, ', ')
        FROM RESERVATION res
        JOIN CUSTOMER c ON res.CUSTOMER_ID = c.CUSTOMER_ID
        WHERE res.ROOM_ID = r.ROOM_ID
          AND res.D_DATE = CURRENT_DATE
          AND res.RESERVATION_STATUS IN ('ONGOING', 'CONFIRMED')
    ) AS TODAY_CUSTOMERS,
    
    -- Durasi total pemakaian hari ini (dalam jam)
    COALESCE((
        SELECT 
            ROUND(SUM(
                EXTRACT(EPOCH FROM (res.END_TIME - res.START_TIME)) / 3600
            ), 2)
        FROM RESERVATION res
        WHERE res.ROOM_ID = r.ROOM_ID
          AND res.D_DATE = CURRENT_DATE
          AND res.RESERVATION_STATUS IN ('ONGOING', 'CONFIRMED')
    ), 0) AS TOTAL_HOURS_TODAY,
    
    -- Waktu saat ini untuk referensi
    CURRENT_TIME AS CURRENT_TIME
FROM ROOM r
ORDER BY 
    CASE 
        WHEN EXISTS (
            SELECT 1 
            FROM RESERVATION res 
            WHERE res.ROOM_ID = r.ROOM_ID 
              AND res.D_DATE = CURRENT_DATE
              AND res.RESERVATION_STATUS = 'ONGOING'
        ) THEN 1
        WHEN EXISTS (
            SELECT 1 
            FROM RESERVATION res 
            WHERE res.ROOM_ID = r.ROOM_ID 
              AND res.D_DATE = CURRENT_DATE
              AND res.RESERVATION_STATUS = 'CONFIRMED'
        ) THEN 2
        ELSE 3
    END,
    r.ROOM_TYPE;

DELETE FROM RESERVATION WHERE D_DATE = CURRENT_DATE;

INSERT INTO RESERVATION 
(CUSTOMER_ID, ROOM_ID, D_DATE, START_TIME, END_TIME, RESERVATION_STATUS, RESERVATION_TYPE)
VALUES
(1, 1, CURRENT_DATE, CURRENT_DATE + TIME '14:00', CURRENT_DATE + TIME '16:00', 'ONGOING', 'WALKIN'),
(2, 2, CURRENT_DATE, CURRENT_DATE + TIME '15:00', CURRENT_DATE + TIME '17:00', 'CONFIRMED', 'REGULAR');

SELECT 
    ROOM_ID,
    ROOM_TYPE,
    TODAY_STATUS,
    TODAY_CUSTOMERS,
    USAGE_HOURS
FROM v_room_status_today
WHERE ROOM_ID IN (1,2,3,4)
ORDER BY ROOM_ID;