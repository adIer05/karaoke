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
(1, 'GOLD', 12, 0.10),
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

-- =====================================
-- FUNCTION AMBIL DISKON MEMBER
-- =====================================
CREATE OR REPLACE FUNCTION get_discount_member(
    p_customer_id INT
)
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

-- =====================================
-- FUNCTION HITUNG DP
-- =====================================
CREATE OR REPLACE FUNCTION calculate_dp(
    p_reservation_type VARCHAR,
    p_base_cost NUMERIC(8,2),
    p_pct_dp FLOAT8 DEFAULT 0.3
)
RETURNS NUMERIC(8,2)
LANGUAGE plpgsql
AS $$
DECLARE
    v_dp_pct FLOAT8;
    v_dp_amount NUMERIC(8,2);
BEGIN
    v_dp_pct := COALESCE(p_pct_dp, 0);
    IF v_dp_pct <= 0 THEN
        v_dp_pct := 0.3;
    END IF;

    IF UPPER(p_reservation_type) = 'REGULAR' THEN
        v_dp_amount := ROUND( (p_base_cost * v_dp_pct)::NUMERIC, 2 );
    ELSE
        v_dp_amount := 0;
    END IF;

    RETURN v_dp_amount;
END;
$$;

-- ===============================================
-- FUNCTION HITUNG FINAL COST DARI TOTAL & DISKON
-- ===============================================
CREATE OR REPLACE FUNCTION calculate_total_payment(
    p_total_cost NUMERIC(8,2),
    p_discount_member FLOAT8
)
RETURNS NUMERIC(8,2)
LANGUAGE plpgsql
AS $$
DECLARE
    v_final NUMERIC(8,2);
BEGIN
    v_final := ROUND(
        (p_total_cost - (p_total_cost * COALESCE(p_discount_member,0))::NUMERIC), 2);
    RETURN v_final;
END;
$$;

-- =========================================
-- PROCEDURE PEMBAYARAN RESERVATION (LUNAS)
-- =========================================
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
    v_res_type VARCHAR(15);
    v_pct_dp FLOAT8;
    v_paid_dp NUMERIC(8,2);

    v_hourly_rate NUMERIC(8,2);
    v_duration_hours NUMERIC(8,2);
    v_base_cost NUMERIC(8,2);

    v_discount_rate FLOAT8;
    v_discount_amount NUMERIC(8,2);
    v_net_after_disc NUMERIC(8,2);

    v_after_dp NUMERIC(8,2);
    v_ext_cost NUMERIC(8,2);

    v_total_cost NUMERIC(8,2);
    v_final_cost NUMERIC(8,2);

    v_payment_id INT;
BEGIN
    -- 1. Ambil data reservasi
    SELECT customer_id,
           room_id,
           start_time,
           end_time,
           reservation_type,
           COALESCE(pct_dp,0),
           COALESCE(paid_dp,0)
    INTO v_customer_id,
         v_room_id,
         v_start_time,
         v_end_time,
         v_res_type,
         v_pct_dp,
         v_paid_dp
    FROM reservation
    WHERE reservation_id = p_reservation_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Reservation % not found', p_reservation_id;
    END IF;

    -- 2. Tarif ruangan
    SELECT hourly_rate
    INTO v_hourly_rate
    FROM room
    WHERE room_id = v_room_id;

    IF v_hourly_rate IS NULL THEN
        RAISE EXCEPTION 'Room % not found or hourly_rate is NULL', v_room_id;
    END IF;

    -- 3. Durasi & base cost
    v_duration_hours := ROUND(
        (EXTRACT(EPOCH FROM (v_end_time - v_start_time)) / 3600.0)::NUMERIC, 2);

    v_base_cost := ROUND(
        (v_hourly_rate * v_duration_hours)::NUMERIC, 2);

    -- 4. Diskon member
    v_discount_rate := get_discount_member(v_customer_id);

    v_discount_amount := ROUND(
        (v_base_cost * v_discount_rate)::NUMERIC, 2);

    v_net_after_disc := v_base_cost - v_discount_amount;

    -- 5. Kurangi DP
    IF UPPER(v_res_type) = 'REGULAR' THEN
        v_after_dp := v_net_after_disc - v_paid_dp;
        IF v_after_dp < 0 THEN
            v_after_dp := 0;
        END IF;
    ELSE
        v_after_dp := v_net_after_disc;
        v_paid_dp := 0;
    END IF;

    -- 6. Biaya extend
    SELECT COALESCE(SUM(extension_cost),0)
    INTO v_ext_cost
    FROM time_extend
    WHERE reservation_id = p_reservation_id;

    -- 7. Total dan final
    v_total_cost := v_base_cost + v_ext_cost;
    v_final_cost := v_after_dp + v_ext_cost;

    -- 8. Cek PAYMENT (insert atau update)
    SELECT payment_id
    INTO v_payment_id
    FROM payment
    WHERE reservation_id = p_reservation_id
    LIMIT 1;

    IF NOT FOUND THEN
        INSERT INTO payment(
            reservation_id,
            payment_method,
            total_cost,
            discount_member,
            final_cost,
            payment_time
        )
        VALUES (
            p_reservation_id,
            p_payment_method,
            v_total_cost,
            v_discount_rate,
            v_final_cost,
            NOW()
        )
        RETURNING payment_id INTO v_payment_id;
    ELSE
        UPDATE payment
        SET payment_method = p_payment_method,
            total_cost = v_total_cost,
            discount_member = v_discount_rate,
            final_cost = v_final_cost,
            payment_time = NOW()
        WHERE payment_id = v_payment_id;
    END IF;

    -- 9. Summary
    RAISE NOTICE '=== PAYMENT SUMMARY FOR RESERVATION % ===', p_reservation_id;
    RAISE NOTICE 'Room ID               : %', v_room_id;
    RAISE NOTICE 'Room hourly rate      : Rp %', v_hourly_rate;
    RAISE NOTICE 'Duration (hours)      : %', v_duration_hours;
    RAISE NOTICE 'Base room cost        : Rp %', v_base_cost;
    RAISE NOTICE 'Extension cost        : Rp %', v_ext_cost;
    RAISE NOTICE '---------------------------------------------------';
    RAISE NOTICE 'Total cost            : Rp %', v_total_cost;
    RAISE NOTICE 'DP already paid       : Rp %', v_paid_dp;
    RAISE NOTICE 'Remaining before disc : Rp %', v_after_dp;
    RAISE NOTICE 'Membership discount   : % %', v_discount_rate * 100, '%';
    RAISE NOTICE 'Final cost to pay     : Rp %', v_final_cost;
    RAISE NOTICE '===================================================';
END;
$$;

-- =====================================
-- TRIGGER FUNCTION UNTUK PAYMENT
-- =====================================
CREATE OR REPLACE FUNCTION trg_payment_calculate_total()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    -- Set payment_time kalau belum diisi
    IF NEW.payment_time IS NULL THEN
        NEW.payment_time := NOW();
    END IF;

    -- Hitung final_cost otomatis kalau belum diisi
    IF NEW.final_cost IS NULL
       AND NEW.total_cost IS NOT NULL THEN
        NEW.final_cost := calculate_total_payment(
            NEW.total_cost,
            COALESCE(NEW.discount_member, 0)
        );
    END IF;

    RETURN NEW;
END;
$$;

-- =====================================
-- CREATE TRIGGER UNTUK PAYMENT
-- =====================================
CREATE TRIGGER trg_before_insert_payment
BEFORE INSERT ON payment
FOR EACH ROW
EXECUTE FUNCTION trg_payment_calculate_total();

-- =========================================
-- PROCEDURE PERPANJANGAN WAKTU RESERVATION
-- =========================================
CREATE OR REPLACE PROCEDURE extend_time(
    IN p_reservation_id INT,
    IN p_minutes INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_room_id INT;
    v_start_time TIMESTAMP;
    v_end_time TIMESTAMP;   
    v_d_date DATE;

    v_hourly_rate  NUMERIC(8,2);

    v_next_start TIMESTAMP;   -- start_time booking berikutnya 
    v_max_end TIMESTAMP;   -- batas maksimal end_time (30 menit sebelum next_start)
    v_new_end TIMESTAMP;   -- END_TIME setelah extend

    v_ext_hours NUMERIC(8,2);
    v_ext_cost NUMERIC(8,2);
BEGIN
    IF p_minutes <= 0 THEN
        RAISE EXCEPTION 'Extend minutes must be > 0. Given: %', p_minutes;
    END IF;

    -- 1. Ambil data reservasi
    SELECT room_id, start_time, end_time, d_date
    INTO v_room_id, v_start_time, v_end_time, v_d_date
    FROM reservation
    WHERE reservation_id = p_reservation_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Reservation % not found', p_reservation_id;
    END IF;

    -- 2. Ambil tarif ruangan
    SELECT hourly_rate
    INTO v_hourly_rate
    FROM room
    WHERE room_id = v_room_id;

    IF v_hourly_rate IS NULL THEN
        RAISE EXCEPTION 'Room % not found or hourly_rate is NULL', v_room_id;
    END IF;

    -- 3. Hitung END_TIME baru
    v_new_end := v_end_time + make_interval(mins => p_minutes);

    -- 4. Cari booking berikutnya di ruangan yang sama pada hari yang sama
    SELECT start_time
    INTO v_next_start
    FROM reservation
    WHERE room_id = v_room_id
      AND reservation_id <> p_reservation_id
      AND d_date = v_d_date
      AND start_time > v_end_time
    ORDER BY start_time LIMIT 1;

    IF FOUND THEN
        -- maksimal boleh sampai 30 menit sebelum booking berikutnya
        v_max_end := v_next_start - INTERVAL '30 minutes';

        IF v_new_end > v_max_end THEN
            RAISE EXCEPTION
                'Cannot extend reservation % in room %: requested end % exceeds max allowed % (30 minutes before next booking at %)',
                p_reservation_id, v_room_id, v_new_end, v_max_end, v_next_start;
        END IF;
    END IF;

    -- 5. Hitung biaya perpanjangan
    v_ext_hours := ROUND( (p_minutes::NUMERIC / 60)::NUMERIC, 2 );
    v_ext_cost := ROUND( (v_hourly_rate * v_ext_hours)::NUMERIC, 2 );

    -- 6. Simpan ke TIME_EXTEND
    INSERT INTO time_extend(
        reservation_id,
        extension_duration,
        extension_cost
    )
    VALUES (
        p_reservation_id,
        ((p_minutes || ' minutes')::interval)::time,  
        v_ext_cost
    );

    -- 7. Update END_TIME di RESERVATION
    UPDATE reservation
    SET end_time = v_new_end
    WHERE reservation_id = p_reservation_id;

    -- 8. RAISE NOTICE summary (pakai gaya yang kamu mau)
    RAISE NOTICE 'Extend RESERVATION ID % in room % by % minutes',
                 p_reservation_id, v_room_id, p_minutes;
    RAISE NOTICE 'Old END_TIME: %, New END_TIME: %',
                 v_end_time, v_new_end;

    IF v_next_start IS NOT NULL THEN
        RAISE NOTICE 'Next booking in this room starts at: % (min 30 min gap enforced)',
                     v_next_start;
    ELSE
        RAISE NOTICE 'No next booking in this room – extension is only limited by duration requested.';
    END IF;

    RAISE NOTICE 'Extra cost for this extension: Rp %', v_ext_cost;
END;
$$;

-- =========================================
-- VIEW STATUS MEMBERSHIP CUSTOMER
-- =========================================
CREATE OR REPLACE VIEW v_membership_status AS
SELECT 
    c.customer_id,
    c.name,
    m.member_status,
    m.number_of_visits,
    m.discount_member
FROM customer c
LEFT JOIN member m 
    ON c.customer_id = m.customer_id
ORDER BY c.customer_id;

-- =========================================
-- VIEW SONG POPULARITY
-- =========================================
CREATE OR REPLACE VIEW v_song_popularity AS
WITH total_play AS (
    SELECT COUNT(*)::NUMERIC AS total_count
    FROM plays
)
SELECT 
    s.songs_id,
    s.title,
    s.artist,
    s.genre,
    s.language,
    COUNT(p.songs_id) AS total_plays,
    CASE 
        WHEN (SELECT total_count FROM total_play) = 0 THEN 0
        ELSE ROUND(
            (COUNT(p.songs_id)::NUMERIC 
                / (SELECT total_count FROM total_play)) * 100,
            2
        )
    END AS popularity_percentage
FROM songs s
LEFT JOIN plays p 
    ON s.songs_id = p.songs_id
GROUP BY 
    s.songs_id, s.title, s.artist, s.genre, s.language
ORDER BY popularity_percentage DESC;

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

