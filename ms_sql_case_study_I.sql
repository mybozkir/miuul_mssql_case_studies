
-- 2. Kaç farklı müşterinin alışveriş yaptığını gösterecek sorguyu yazınız.
SELECT COUNT(DISTINCT master_id) UNIQUECUSTOMERS
FROM FLO_DATA

-- 3. Toplam yapılan alışveriş sayısı ve ciroyu getirecek sorguyu yazınız.
SELECT
SUM(order_num_total_ever_online + order_num_total_ever_offline) TOPLAMSIPARIS,
SUM(customer_value_total_ever_online + customer_value_total_ever_offline) TOPLAMCIRO
FROM FLO_DATA

-- 4. Alışveriş başına ortalama ciroyu getirecek sorguyu yazınız.
SELECT
ROUND((SUM(customer_value_total_ever_online + customer_value_total_ever_offline) / SUM(order_num_total_ever_online + order_num_total_ever_offline)), 2) ORTALAMACIRO
FROM FLO_DATA

-- 5. En son alışveriş yapılan kanal (last_order_channel) üzerinden yapılan alışverişlerin toplam ciro ve alışveriş sayılarını getirecek sorguyu yazınız.
SELECT
last_order_channel SONSIPARISKANALI,
SUM(customer_value_total_ever_online + customer_value_total_ever_offline) TOPLAMCIRO,
SUM(order_num_total_ever_online + order_num_total_ever_offline) TOPLAMSIPARIS
FROM FLO_DATA
GROUP BY last_order_channel
-- 6. Store-type kırılımında elde edilen toplam ciroyu getiren sorguyu yazınız.
SELECT
store_type MAGAZATIPI,
SUM(customer_value_total_ever_online + customer_value_total_ever_offline) TOPLAMCIRO
FROM FLO_DATA
GROUP BY store_type

-- 7. Yıl kırılımında alışveriş sayılarını getirecek sorguyu yazınız (Yıl olarak müşterinin ilk alışveriş tarihi (first_order_date) yılını baz alınız.)
SELECT
DATEPART(YEAR, first_order_date) YIL,
SUM(order_num_total_ever_online + order_num_total_ever_offline) TOPLAMSIPARIS
FROM FLO_DATA
GROUP BY DATEPART(YEAR, first_order_date)
ORDER BY YIL

-- 8. En son alışveriş yapılan kanal kırılımında alışveriş başına ortalama ciroyu hesaplayacak sorguyu yazınız.
SELECT
last_order_channel SONSIPARISKANALI,
ROUND((SUM(customer_value_total_ever_online + customer_value_total_ever_offline)) / (SUM(order_