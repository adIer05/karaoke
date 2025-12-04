-- ================================================================
-- Integrated karaoke schema + functions/procedures/triggers/views
-- Rules:
--  - REGULAR allowed to book <= 7 days ahead (i.e. reservation_date - current_date <= 7)
--  - REGULAR must pay DP = 30% (fixed)
--  - WALKIN no DP required
--  - Conflicts consider TIME_EXTEND (sum of extension_duration)
--  - On rule violation, trigger/procedure issues NOTICE then RAISE EXCEPTION
-- ================================================================

/* =========================
   DROP existing objects (safe to re-run)
   ========================= */
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

-- =========================
-- SCHEMA (as provided)
-- =========================
create table CUSTOMER (
   CUSTOMER_ID          SERIAL               not null,
   NO_PHONE             VARCHAR(13)          null,
   NAME                 VARCHAR(80)          null,
   PEOPLE_COMING        INT4                 null,
   constraint PK_CUSTOMER primary key (CUSTOMER_ID)
);
create unique index CUSTOMER_PK on CUSTOMER (CUSTOMER_ID);

create table MEMBER (
   CUSTOMER_ID          SERIAL               not null,
   MEMBER_STATUS        VARCHAR(9)           null,
   NUMBER_OF_VISITS     INT4                 null,
   DISCOUNT_MEMBER      FLOAT8               null,
   constraint AK_PK_MEMBER unique (CUSTOMER_ID)
);
create index PART_OF_FK on MEMBER (CUSTOMER_ID);

create table ROOM (
   ROOM_ID              SERIAL               not null,
   ROOM_TYPE            VARCHAR(10)          null,
   CAPACITY             INT4                 null,
   HOURLY_RATE          NUMERIC(8,2)         null,
   STATUS               VARCHAR(20)          null,
   constraint PK_ROOM primary key (ROOM_ID)
);
create unique index ROOM_PK on ROOM (ROOM_ID);

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
create unique index SONGS_PK on SONGS (SONGS_ID);

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
create unique index RESERVATION_PK on RESERVATION (RESERVATION_ID);
create index MAKE_RESERVATION_FK on RESERVATION (CUSTOMER_ID);
create index ASSIGNED_FOR_RESERVATION_FK on RESERVATION (ROOM_ID);

create table TIME_EXTEND (
   RESERVATION_ID       INT4                 not null,
   EXTEND_ID            SERIAL               not null,
   EXTENSION_DURATION   TIME                 null,
   EXTENSION_COST       NUMERIC(8,2)         null,
   constraint PK_TIME_EXTEND primary key (EXTEND_ID)
);
create unique index TIME_EXTEND_PK on TIME_EXTEND (EXTEND_ID);
create index RES_HAS_EXTENSION_FK on TIME_EXTEND (RESERVATION_ID);

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
create index RESULTS_PAYMENT_RESERVATION_FK on PAYMENT (RESERVATION_ID);

create table PLAYS (
   CUSTOMER_ID          INT4                 not null,
   SONGS_ID             INT4                 not null,
   SONG_START_TIME      TIMESTAMP            null,
   PLAY_DURATION        TIME                 null
);
create index PERFORMS_FK on PLAYS (CUSTOMER_ID);
create index REFERS_TO_FK on PLAYS (SONGS_ID);

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

-- =========================
-- sample data (from your files)
-- =========================
INSERT INTO CUSTOMER (NO_PHONE, NAME, PEOPLE_COMING) VALUES 
('081234567890', 'Shofi', 3),
('082198765432', 'Hana', 2),
('081345678901', 'Reida', 4),
('081456789012', 'alfa', 4);

INSERT INTO MEMBER (CUSTOMER_ID, MEMBER_STATUS, NUMBER_OF_VISITS, DISCOUNT_MEMBER) VALUES 
(1, 'GOLD', 12, 0.10),
(2,'Silver',5,0.05),
(3,'INACTIVE',0,0.00),
(4,'Platinum',30,0.15);

INSERT INTO ROOM (ROOM_TYPE, CAPACITY, HOURLY_RATE, STATUS) VALUES
('SMALL',4,50000,'AVAILABLE'),
('MEDIUM',6,75000,'AVAILABLE'),
('LARGE',8,100000,'AVAILABLE'),
('VIP',10,150000,'AVAILABLE');

INSERT INTO SONGS (TITLE, ARTIST, GENRE, LANGUAGE, DURATION, LYRICS) VALUES
('Take A Chance With Me', 'NIKI', 'Pop / R&B', 'English', '00:03:45', 'Lyrics not included'),
('I Pray', 'LANY', 'Pop', 'English', '00:03:30', 'Lyrics not included'),
('Out Of My League', 'LANY', 'Pop', 'English', '00:03:20', 'Lyrics not included'),
('TAROT', '.Feast', 'Rock / Alternative', 'Indonesian', '00:04:20', 'Lyrics not included'),
('Rumah Ke Rumah', 'Hindia', 'Indie', 'Indonesian', '00:04:28', 'Lyrics not included'),
('Berdansalah, Karir Ini Tak Ada Artinya', 'Hindia', 'Alternative / Indie', 'Indonesian', '00:04:10', 'Lyrics not included');

INSERT INTO RESERVATION 
(CUSTOMER_ID, ROOM_ID, D_DATE, START_TIME, END_TIME, RESERVATION_STATUS, RESERVATION_TYPE, PCT_DP, PAID_DP, RESERVATION_DATE)
VALUES
(1, 2, '2025-12-03', '2025-12-03 14:00', '2025-12-03 16:00', 'ONGOING', 'REGULAR', 0.3, 45000, '2025-12-01'),
(2, 1, '2025-12-03', '2025-12-03 15:00', '2025-12-03 17:00', 'ONGOING', 'WALKIN', 0, 0, '2025-12-03');

INSERT INTO TIME_EXTEND (RESERVATION_ID, EXTENSION_DURATION, EXTENSION_COST) VALUES
(1, '00:30:00', 25000);

INSERT INTO PAYMENT (RESERVATION_ID, PAYMENT_METHOD, TOTAL_COST, DISCOUNT_MEMBER, FINAL_COST, PAYMENT_TIME)
VALUES
(1, 'CASH', 125000, 0.1, 112500, '2025-12-03 16:10'),
(2, 'QRIS', 100000, 0, 100000, '2025-12-03 17:10');

INSERT INTO PLAYS (CUSTOMER_ID, SONGS_ID, SONG_START_TIME, PLAY_DURATION)
VALUES
(1, 1, '2025-12-03 14:05', '00:04:55'),
(1, 3, '2025-12-03 14:12', '00:03:25'),
(2, 2, '2025-12-03 15:10', '00:03:30');

-- ============================================================
-- Utility functions (from files + merged logic)
-- ============================================================

-- get discount for member
CREATE OR REPLACE FUNCTION get_discount_member(p_customer_id INT)
RETURNS FLOAT8
LANGUAGE plpgsql
AS $$
DECLARE
    v_discount FLOAT8;
BEGIN
    SELECT COALESCE(discount_member, 0)
    INTO v_discount
    FROM member
    WHERE customer_id = p_customer_id;

    IF NOT FOUND THEN
        v_discount := 0;
    END IF;

    RETURN v_discount;
END;
$$;

-- fixed DP calculation: REGULAR -> 30% fixed; WALKIN -> 0
CREATE OR REPLACE FUNCTION calculate_dp_fixed(
    p_reservation_type VARCHAR,
    p_base_cost NUMERIC(12,2)
)
RETURNS NUMERIC(12,2)
LANGUAGE plpgsql
AS $$
DECLARE
    v_dp_amount NUMERIC(12,2);
BEGIN
    IF UPPER(COALESCE(p_reservation_type,'') ) = 'REGULAR' THEN
        v_dp_amount := ROUND(p_base_cost * 0.30, 2); -- fixed 30%
    ELSE
        v_dp_amount := 0;
    END IF;
    RETURN v_dp_amount;
END;
$$;

-- compute final cost after member discount
CREATE OR REPLACE FUNCTION calculate_total_payment(
    p_total_cost NUMERIC(12,2),
    p_discount_member FLOAT8
)
RETURNS NUMERIC(12,2)
LANGUAGE plpgsql
AS $$
DECLARE
    v_final NUMERIC(12,2);
BEGIN
    v_final := ROUND((p_total_cost - (p_total_cost * COALESCE(p_discount_member,0))::NUMERIC), 2);
    RETURN v_final;
END;
$$;

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
    p_customer_id      INT,
    p_room_id          INT,
    p_d_date           DATE,
    p_start_time       TIMESTAMP,
    p_end_time         TIMESTAMP,
    p_reservation_type VARCHAR DEFAULT 'REGULAR',
    p_people_coming    INT DEFAULT NULL,
    p_payment_method   VARCHAR DEFAULT NULL
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
    v_conf_count  INT;
    v_conf_from   TEXT;

    v_dp NUMERIC(12,2);
    v_reservation_id INT;

    v_payment_id INT;
BEGIN
    ---------------------------------------------------------
    -- 1. VALIDASI CUSTOMER & ROOM EXIST
    ---------------------------------------------------------
    PERFORM 1 FROM customer WHERE customer_id = p_customer_id;
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Customer % not found', p_customer_id;
    END IF;

    SELECT capacity, hourly_rate
    INTO v_capacity, v_hourly_rate
    FROM room WHERE room_id = p_room_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Room % not found', p_room_id;
    END IF;

    ---------------------------------------------------------
    -- 2. VALIDASI WAKTU
    ---------------------------------------------------------
    IF p_end_time <= p_start_time THEN
        RAISE NOTICE 'Invalid time range';
        RAISE EXCEPTION 'end_time must be after start_time';
    END IF;

    ---------------------------------------------------------
    -- 3. VALIDASI KAPASITAS
    ---------------------------------------------------------
    IF p_people_coming IS NOT NULL THEN
        IF p_people_coming <= 0 THEN
            RAISE EXCEPTION 'people_coming must be > 0';
        END IF;

        IF p_people_coming > v_capacity THEN
            RAISE NOTICE 'Capacity violation: room capacity % < people %', v_capacity, p_people_coming;
            RAISE EXCEPTION 'Room capacity insufficient';
        END IF;

        UPDATE customer
        SET people_coming = p_people_coming
        WHERE customer_id = p_customer_id;
    END IF;

    ---------------------------------------------------------
    -- 4. CHECK ROOM AVAILABILITY
    ---------------------------------------------------------
    SELECT is_available, conflict_count, conflict_from
    INTO v_is_available, v_conf_count, v_conf_from
    FROM fn_check_room_available(p_room_id, p_start_time, p_end_time);

    IF NOT v_is_available THEN
        RAISE NOTICE 'Room unavailable: % (conflicts=%)', v_conf_from, v_conf_count;
        RAISE EXCEPTION 'Room % not available in requested time slot', p_room_id;
    END IF;

    ---------------------------------------------------------
    -- 5. HITUNG DURASI DAN BASE COST
    ---------------------------------------------------------
    v_duration_hours := EXTRACT(EPOCH FROM (p_end_time - p_start_time)) / 3600.0;
    v_base_cost := ROUND(v_hourly_rate * v_duration_hours, 2);

    ---------------------------------------------------------
    -- 6. REGULAR RULES → H–7 + DP 30%
    ---------------------------------------------------------
    v_days_until := (p_d_date - CURRENT_DATE);

    IF UPPER(COALESCE(p_reservation_type,'REGULAR')) = 'REGULAR' THEN
        -- REGULAR tidak boleh booking lebih dari H–7
        IF v_days_until > 7 THEN
            RAISE NOTICE 'REGULAR booking beyond H-7 (days_until=%)', v_days_until;
            RAISE EXCEPTION 'REGULAR booking allowed only ≤ 7 days before D_DATE';
        END IF;

        -- Hitung DP 30%
        v_dp := ROUND(v_base_cost * 0.30, 2);
    ELSE
        -- WALKIN TANPA DP
        v_dp := 0;
    END IF;

    ---------------------------------------------------------
    -- 7. INSERT RESERVATION
    ---------------------------------------------------------
    IF p_start_time <= NOW() AND p_end_time >= NOW() THEN
        -- booking sedang berlangsung
        INSERT INTO reservation (
            customer_id, room_id, d_date, start_time, end_time,
            reservation_status, reservation_type, pct_dp, paid_dp, reservation_date
        ) VALUES (
            p_customer_id, p_room_id, p_d_date, p_start_time, p_end_time,
            'ONGOING', UPPER(p_reservation_type),
            CASE WHEN v_dp > 0 THEN 0.3 ELSE 0 END,
            v_dp,
            CURRENT_DATE
        )
        RETURNING reservation_id INTO v_reservation_id;

        UPDATE room SET status = 'OCCUPIED' WHERE room_id = p_room_id;

    ELSE
        -- booking masa depan
        INSERT INTO reservation (
            customer_id, room_id, d_date, start_time, end_time,
            reservation_status, reservation_type, pct_dp, paid_dp, reservation_date
        ) VALUES (
            p_customer_id, p_room_id, p_d_date, p_start_time, p_end_time,
            'CONFIRMED', UPPER(p_reservation_type),
            CASE WHEN v_dp > 0 THEN 0.3 ELSE 0 END,
            v_dp,
            CURRENT_DATE
        )
        RETURNING reservation_id INTO v_reservation_id;

        UPDATE room SET status = 'RESERVED' WHERE room_id = p_room_id;
    END IF;

    RAISE NOTICE 'Reservation created: ID=% (type=%, cost=%, dp=%)',
        v_reservation_id, p_reservation_type, v_base_cost, v_dp;

    ---------------------------------------------------------
    -- 8. INSERT PAYMENT UNTUK DP (JIKA ADA)
    ---------------------------------------------------------
    IF v_dp > 0 THEN
        INSERT INTO payment (
            reservation_id, payment_method, total_cost,
            discount_member, final_cost, payment_time
        )
        VALUES (
            v_reservation_id,
            p_payment_method,
            v_dp, 0, v_dp,
            NOW()
        )
        RETURNING payment_id INTO v_payment_id;

        RAISE NOTICE 'DP Payment recorded: payment_id=%, amount=%',
            v_payment_id, v_dp;
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
    'CASH'                   -- payment method
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
    'CASH'
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
    'CASH'
);

select * from reservation
select * from room
select * from payment