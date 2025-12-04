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

-- ============================================================
-- Function: fn_check_room_available 
-- ============================================================
CREATE OR REPLACE FUNCTION fn_check_room_available(
    p_room_id INT,
    p_start_time TIMESTAMP,
    p_end_time TIMESTAMP
)
RETURNS TABLE(is_available BOOLEAN, conflict_count INT, conflict_from TEXT)
LANGUAGE plpgsql
AS $$
DECLARE
    v_conf INT;
BEGIN
    IF p_start_time IS NULL OR p_end_time IS NULL THEN
        RAISE EXCEPTION 'Start and end time required';
    END IF;
    IF p_end_time <= p_start_time THEN
        RAISE EXCEPTION 'end_time must be after start_time';
    END IF;

    PERFORM 1 FROM room WHERE room_id = p_room_id;
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Room % not found', p_room_id;
    END IF;

    -- If room explicitly OCCUPIED -> unavailable
    IF (SELECT status FROM room WHERE room_id = p_room_id) = 'OCCUPIED' THEN
        is_available := FALSE;
        conflict_count := 1;
        conflict_from := 'ROOM_OCCUPIED';
        RETURN NEXT;
        RETURN;
    END IF;

    SELECT COUNT(*) INTO v_conf
    FROM reservation r
    WHERE r.room_id = p_room_id
      AND r.reservation_status NOT IN ('CANCELLED','FINISHED')
      AND p_start_time < (
            r.end_time + COALESCE((
                SELECT SUM((te.extension_duration::text)::interval) FROM time_extend te WHERE te.reservation_id = r.reservation_id
            ), '00:00:00'::interval)
          )
      AND p_end_time > r.start_time;

    IF v_conf > 0 THEN
        is_available := FALSE;
        conflict_count := v_conf;
        conflict_from := 'RESERVATION';
    ELSE
        is_available := TRUE;
        conflict_count := 0;
        conflict_from := 'NONE';
    END IF;

    RETURN NEXT;
END;
$$;

-- ============================================================
-- Procedure: sp_create_reservation 
-- ============================================================
CREATE OR REPLACE PROCEDURE sp_create_reservation(
    p_customer_id    INT,
    p_room_id        INT,
    p_d_date         DATE,
    p_start_time     TIMESTAMP,
    p_end_time       TIMESTAMP,
    p_reservation_type VARCHAR DEFAULT 'REGULAR',
    p_people_coming  INT DEFAULT NULL,
    p_payment_method VARCHAR DEFAULT NULL
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_capacity INT;
    v_hourly_rate NUMERIC(12,2);
    v_duration_hours NUMERIC;
    v_base_cost NUMERIC(12,2);
    v_days_until INT;
    v_is_available BOOLEAN;
    v_conf_count INT;
    v_conf_from TEXT;
    v_dp NUMERIC(12,2);
    v_reservation_id INT;
    v_payment_id INT;
    v_customer_name TEXT;
BEGIN
    -- Customer exist check
    SELECT name INTO v_customer_name FROM customer WHERE customer_id = p_customer_id;
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Customer % not found', p_customer_id;
    END IF;

    -- Room info
    SELECT capacity, hourly_rate INTO v_capacity, v_hourly_rate
    FROM room WHERE room_id = p_room_id;
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Room % not found', p_room_id;
    END IF;

    -- Time validation
    IF p_end_time <= p_start_time THEN
        RAISE EXCEPTION 'end_time must be after start_time';
    END IF;

    -- Capacity check
    IF p_people_coming IS NOT NULL THEN
        IF p_people_coming <= 0 THEN
            RAISE EXCEPTION 'people_coming must be > 0';
        END IF;
        IF p_people_coming > v_capacity THEN
            RAISE NOTICE 'Capacity violation: % people > room capacity %', p_people_coming, v_capacity;
            RAISE EXCEPTION 'Room capacity insufficient';
        END IF;
        UPDATE customer SET people_coming = p_people_coming WHERE customer_id = p_customer_id;
    END IF;

    -- Availability check
    SELECT is_available, conflict_count, conflict_from
    INTO v_is_available, v_conf_count, v_conf_from
    FROM fn_check_room_available(p_room_id, p_start_time, p_end_time);

    IF NOT v_is_available THEN
        RAISE NOTICE 'Availability failed: %', v_conf_from;
        RAISE EXCEPTION 'Room unavailable';
    END IF;

    -- Cost calculation
    v_duration_hours := extract(epoch from (p_end_time - p_start_time)) / 3600.0;
    v_base_cost := round(v_hourly_rate * v_duration_hours, 2);

    -- H-7 rule
    v_days_until := (p_d_date - current_date);

    IF upper(p_reservation_type) = 'REGULAR' THEN
        IF v_days_until > 7 THEN
            RAISE NOTICE 'REGULAR booking outside allowed window (H-7). days_until=%', v_days_until;
            RAISE EXCEPTION 'REGULAR only allowed ≤ 7 days from today';
        END IF;

        v_dp := ROUND(v_base_cost * 0.30, 2);
    ELSE
        v_dp := 0;
    END IF;

    -- Insert reservation
    IF p_start_time <= now() AND p_end_time >= now() THEN
        INSERT INTO reservation
        (customer_id, room_id, d_date, start_time, end_time,
         reservation_status, reservation_type, pct_dp, paid_dp, reservation_date)
        VALUES
        (p_customer_id, p_room_id, p_d_date, p_start_time, p_end_time,
         'ONGOING', upper(p_reservation_type), 
         CASE WHEN v_dp > 0 THEN 0.3 ELSE 0 END, v_dp, CURRENT_DATE)
        RETURNING reservation_id INTO v_reservation_id;

        UPDATE room SET status = 'OCCUPIED' WHERE room_id = p_room_id;
    ELSE
        INSERT INTO reservation
        (customer_id, room_id, d_date, start_time, end_time,
         reservation_status, reservation_type, pct_dp, paid_dp, reservation_date)
        VALUES
        (p_customer_id, p_room_id, p_d_date, p_start_time, p_end_time,
         'CONFIRMED', upper(p_reservation_type), 
         CASE WHEN v_dp > 0 THEN 0.3 ELSE 0 END, v_dp, CURRENT_DATE)
        RETURNING reservation_id INTO v_reservation_id;

        UPDATE room SET status = 'RESERVED' WHERE room_id = p_room_id;
    END IF;

    -- DP Payment auto insert
    IF v_dp > 0 THEN
        INSERT INTO payment (reservation_id, payment_method, total_cost, discount_member, final_cost, payment_time)
        VALUES (v_reservation_id, p_payment_method, v_dp, 0, v_dp, now())
        RETURNING payment_id INTO v_payment_id;
    END IF;

    ----------------------------------------------------------------------
    -- SUMMARY FOR REGULAR 
    ----------------------------------------------------------------------
    IF UPPER(p_reservation_type) = 'REGULAR' THEN
        RAISE NOTICE '=================================================';
        RAISE NOTICE '          REGULAR RESERVATION SUMMARY           ';
        RAISE NOTICE '=================================================';
        RAISE NOTICE 'Reservation ID       : %', v_reservation_id;
        RAISE NOTICE 'Customer Name        : %', v_customer_name;
        RAISE NOTICE 'People Coming        : % (Room Capacity: %)', p_people_coming, v_capacity;
        RAISE NOTICE '--------------------------------------------------';
        RAISE NOTICE 'Room ID              : %', p_room_id;
        RAISE NOTICE 'Hourly Rate          : Rp %', v_hourly_rate;
        RAISE NOTICE 'Base Cost            : Rp %', v_base_cost;
        RAISE NOTICE 'DP 30%% Required      : Rp %', v_dp;
        RAISE NOTICE 'Reservation Type     : REGULAR';
        RAISE NOTICE '-------------------------------------------------';
        RAISE NOTICE 'Date                 : %', p_d_date;
        RAISE NOTICE 'Start Time           : %', p_start_time::time;
        RAISE NOTICE 'End Time             : %', p_end_time::time;
        RAISE NOTICE 'Duration (Hours)     : %', ROUND(v_duration_hours, 2);
        RAISE NOTICE '=================================================';
    END IF;

END;
$$;


-- ============================================================
-- Function Check Room
-- ============================================================
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
        RETURN QUERY SELECT FALSE, NULL::VARCHAR(10), NULL::VARCHAR(20), NULL::INT, 'Room not found.'::VARCHAR(100);
        RETURN;
    END IF;

    IF v_room_status != 'AVAILABLE' THEN
        RETURN QUERY SELECT FALSE, v_room_type, v_room_status, v_capacity, ('Room is currently ' || v_room_status)::VARCHAR(100);
        RETURN;
    END IF;

    SELECT COUNT(*) INTO v_conflict_count
    FROM RESERVATION r
    WHERE r.ROOM_ID = p_room_id
      AND r.D_DATE = p_check_date
      AND r.RESERVATION_STATUS NOT IN ('CANCELLED','FINISHED')
      AND (p_start_time < r.END_TIME AND p_end_time > r.START_TIME);

    IF v_conflict_count > 0 THEN
        RETURN QUERY SELECT FALSE, v_room_type, v_room_status, v_capacity, 'Schedule conflicts with existing reservation'::VARCHAR(100);
        RETURN;
    END IF;

    RETURN QUERY SELECT TRUE, v_room_type, v_room_status, v_capacity, 'Available'::VARCHAR(100);
END;
$$ LANGUAGE plpgsql;


-- ============================================================
-- Trigger: check schedule conflict
-- ============================================================
CREATE OR REPLACE FUNCTION trg_reservation_conflict()
RETURNS trigger
LANGUAGE plpgsql
AS $$
DECLARE
    v_start TIMESTAMP := NEW.start_time;
    v_end TIMESTAMP := NEW.end_time;
    v_room INT := NEW.room_id;
    v_conf INT;
BEGIN
    IF v_start IS NULL OR v_end IS NULL THEN
        RAISE EXCEPTION 'start_time and end_time cannot be null';
    END IF;
    IF v_end <= v_start THEN
        RAISE EXCEPTION 'end_time must be after start_time';
    END IF;

    IF TG_OP = 'UPDATE' THEN
        SELECT COUNT(*) INTO v_conf
        FROM reservation r
        WHERE r.room_id = v_room
          AND r.reservation_id <> NEW.reservation_id
          AND r.reservation_status NOT IN ('CANCELLED','FINISHED')
          AND v_start < (r.end_time + COALESCE((SELECT SUM((te.extension_duration::text)::interval) FROM time_extend te WHERE te.reservation_id = r.reservation_id), '00:00:00'::interval))
          AND v_end > r.start_time;
    ELSE
        SELECT COUNT(*) INTO v_conf
        FROM reservation r
        WHERE r.room_id = v_room
          AND r.reservation_status NOT IN ('CANCELLED','FINISHED')
          AND v_start < (r.end_time + COALESCE((SELECT SUM((te.extension_duration::text)::interval) FROM time_extend te WHERE te.reservation_id = r.reservation_id), '00:00:00'::interval))
          AND v_end > r.start_time;
    END IF;

    IF v_conf > 0 THEN
        RAISE NOTICE 'Conflict detected for room % between % and % (conflicts=%)', v_room, v_start, v_end, v_conf;
        RAISE EXCEPTION 'Schedule conflict detected - insert/update rejected';
    END IF;

    IF (SELECT status FROM room WHERE room_id = v_room) = 'OCCUPIED' THEN
        RAISE NOTICE 'Room % currently OCCUPIED', v_room;
        RAISE EXCEPTION 'Room occupied';
    END IF;

    RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_reservation_conflict ON reservation;
CREATE TRIGGER trg_reservation_conflict
BEFORE INSERT OR UPDATE ON reservation
FOR EACH ROW EXECUTE FUNCTION trg_reservation_conflict();

-- ============================================================
-- Trigger: trg_reservation_rules 
-- ============================================================
CREATE OR REPLACE FUNCTION trg_reservation_rules()
RETURNS trigger
LANGUAGE plpgsql
AS $$
DECLARE
    v_days_until INT;
    v_hourly_rate NUMERIC(12,2);
    v_duration_hours NUMERIC;
    v_total_cost NUMERIC(12,2);
    v_required_dp NUMERIC(12,2);
BEGIN
    IF NEW.d_date IS NULL THEN
        RAISE NOTICE 'D_DATE is null';
        RAISE EXCEPTION 'D_DATE cannot be null';
    END IF;

    IF NEW.end_time <= NEW.start_time THEN
        RAISE NOTICE 'Invalid time range';
        RAISE EXCEPTION 'end_time must be after start_time';
    END IF;

    v_days_until := (NEW.d_date - current_date);

    SELECT hourly_rate INTO v_hourly_rate FROM room WHERE room_id = NEW.room_id;
    IF NOT FOUND THEN
        RAISE NOTICE 'Room not found %', NEW.room_id;
        RAISE EXCEPTION 'Room % not found', NEW.room_id;
    END IF;

    v_duration_hours := extract(epoch from (NEW.end_time - NEW.start_time)) / 3600.0;
    v_total_cost := round(v_hourly_rate * v_duration_hours, 2);

    IF upper(coalesce(NEW.reservation_type,'REGULAR')) = 'REGULAR' THEN
        -- rule: REGULAR must be within 7 days (<=7)
        IF v_days_until > 7 THEN
            RAISE NOTICE 'REGULAR booking beyond 7 days (days_until=%) - rejected', v_days_until;
            RAISE EXCEPTION 'REGULAR reservations only allowed within 7 days from today';
        END IF;

        -- set PCT_DP to 0.3 (fixed)
        NEW.pct_dp := 0.3;
        v_required_dp := ROUND(v_total_cost * 0.3,2);

        IF NEW.paid_dp IS NULL OR NEW.paid_dp < v_required_dp THEN
            RAISE NOTICE 'REGULAR requires DP 30%% => required=% (paid=%)', v_required_dp, COALESCE(NEW.paid_dp,0);
            RAISE EXCEPTION 'REGULAR reservation requires DP 30%% of total cost (Rp %)', v_required_dp;
        END IF;
    ELSE
        -- WALKIN: ensure pct_dp/paid_dp = 0
        NEW.pct_dp := 0;
        NEW.paid_dp := COALESCE(NEW.paid_dp,0);
    END IF;

    RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_reservation_rules ON reservation;
CREATE TRIGGER trg_reservation_rules
BEFORE INSERT OR UPDATE ON reservation
FOR EACH ROW EXECUTE FUNCTION trg_reservation_rules();


-- ============================================================
-- Views: v_room_schedule
-- ============================================================
CREATE OR REPLACE VIEW v_room_schedule AS
SELECT
    rm.room_id,
    rm.room_type,
    rm.capacity,
    rm.hourly_rate,
    rm.status AS room_status,
    res.reservation_id,
    res.customer_id,
    c.name AS customer_name,
    res.d_date,
    res.start_time,
    res.end_time,
    (res.end_time + COALESCE((SELECT SUM((te.extension_duration::text)::interval) FROM time_extend te WHERE te.reservation_id = res.reservation_id), '00:00:00'::interval)) AS extended_end,
    res.reservation_status,
    res.reservation_type,
    res.pct_dp,
    res.paid_dp,
    res.reservation_date
FROM reservation res
JOIN room rm ON rm.room_id = res.room_id
LEFT JOIN customer c ON c.customer_id = res.customer_id
ORDER BY rm.room_id, res.start_time;


-- Test Case
--1. Gagal >H-7
CALL sp_create_reservation(
    1,                       -- customer_id
    2,                       -- room_id
    '2025-12-20',            -- d_date
    '2025-12-20 10:00',      -- start_time
    '2025-12-20 12:00',      -- end_time
    'REGULAR',               -- reservation_type
    3,                       -- people coming
    'QRIS'                   -- payment method
);


--2. Berhasil <= h-7
CALL sp_create_reservation(
    1,
    2,
    '2025-12-10',      -- H+6
    '2025-12-10 10:00',
    '2025-12-10 12:00',
    'REGULAR',
    3,
    'QRIS'
);

-- Gagal Overlap
CALL sp_create_reservation(
    3,
    2,
    '2025-12-10',
    '2025-12-10 11:00',     -- overlap
    '2025-12-10 13:00',
    'REGULAR',
    3,
    'QRIS'
);

select * from reservation
select * from room
select * from payment