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

-- =============================================================================== --
--                              TEST CASE PAYMENT                                  --
-- =============================================================================== --
TRUNCATE TABLE PAYMENT RESTART IDENTITY;
SELECT * FROM PAYMENT;

-- Test Case 1 – RESERVATION_ID = 1 (REGULAR + MEMBER GOLD + EXTEND)
/*
Room: MEDIUM → 75.000 / jam
Durasi: 2 jam → base_cost = 2 × 75.000 = 150.000
Diskon member (GOLD 10%):
	discount_rate = 0,10
	discount_amount = 10% × 150.000 = 15.000
	net_after_disc = 150.000 – 15.000 = 135.000
DP:
	paid_dp = 45.000 
	after_dp = 135.000 – 45.000 = 90.000

Extend: ext_cost = 25.000
Total / final:
	total_cost = base_cost + ext = 150.000 + 25.000 = 175.000
	final_cost = after_dp + ext = 90.000 + 25.000 = 115.000
*/

call pay_reservation_settle(1, 'QRIS');
SELECT * FROM PAYMENT;

-- Test Case 2 – RESERVATION_ID = 2 (WALKIN + MEMBER SILVER + TANPA EXTEND)
/*
Room: SMALL → 50.000 / jam
Durasi: 2 jam → base_cost = 2 × 50.000 = 100.000
Diskon member (Silver 5%):
	discount_rate = 0,05
	discount_amount = 5% × 100.000 = 5.000
	net_after_disc = 100.000 – 5.000 = 95.000
DP:
	reservation_type = WALKIN → DP diabaikan
	paid_dp = 0
	after_dp = net_after_disc = 95.000
Extend: ext_cost = 0
Total / final:
	total_cost = base_cost + ext = 100.000 + 0 = 100.000
	final_cost = after_dp + ext = 95.000 + 0 = 95.000
*/
call pay_reservation_settle(2, 'QRIS');
SELECT * FROM PAYMENT;