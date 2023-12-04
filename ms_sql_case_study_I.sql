
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
ROUND((SUM(customer_value_total_ever_online + customer_value_total_ever_offline)) / (SUM(order_num_total_ever_online + order_num_total_ever_offline)), 2) ORTALAMACIRO
FROM FLO_DATA
GROUP BY last_order_channel

-- 9. Son 12 ayda en çok ilgi gören kategoriyi getiren sorguyu yazınız.
SELECT TOP 1
interested_in_categories_12,
COUNT(interested_in_categories_12) TOPLAMSAYI
FROM FLO_DATA
GROUP BY interested_in_categories_12
ORDER BY TOPLAMSAYI DESC

-- 10. En çok tercih edilen store_type bilgisini getiren sorguyu yazınız.
SELECT TOP 1
store_type,
COUNT(store_type) TOPLAMSAYI
FROM FLO_DATA
GROUP BY store_type
ORDER BY TOPLAMSAYI DESC

-- 11. En son alışveriş yapılan kanal (last_order_channel) bazında, en çok ilgi gören kategoriyi ve bu kategoriden ne kadarlık alışveriş yapıldığını getiren sorguyu yazınız.
SELECT TOP 1
last_order_channel,
interested_in_categories_12,
COUNT(interested_in_categories_12) TOPLAMSAYI,
SUM(customer_value_total_ever_online + customer_value_total_ever_offline) TOPLAMCIRO
FROM FLO_DATA
GROUP BY last_order_channel, interested_in_categories_12
ORDER BY TOPLAMSAYI DESC

-- 12. En çok alışveriş yapan kişinin ID'sini getiren sorguyu yazınız.
SELECT TOP 1
master_id MUSTERIID,
SUM(order_num_total_ever_online + order_num_total_ever_offline) TOPLAMSIPARIS
FROM FLO_DATA
GROUP BY master_id
ORDER BY TOPLAMSIPARIS DESC
-- 13. En çok alışveriş yapan kişinin alışveriş başına ortalama cirosunu ve alışveriş yapma gün ortalamasını (alışveriş sıklığını) getiren sorguyu yazınız. 
SELECT *,
	ROUND((D.TOPLAMCIRO / D.TOPLAMSIPARIS), 2) ORTALAMASIPARIS
FROM(
	SELECT TOP 1
	master_id MUSTERIID,
	SUM(customer_value_total_ever_online + customer_value_total_ever_offline) TOPLAMCIRO,
	SUM(order_num_total_ever_online + order_num_total_ever_offline) TOPLAMSIPARIS
	FROM FLO_DATA
	GROUP BY master_id
	ORDER BY TOPLAMSIPARIS DESC) D

-- 14. En çok alışveriş yapan (ciro bazında) ilk 100 kişinin alışveriş yapma gün ortalamasını (alışveriş sıklığını) getiren sorguyu yazınız.
SELECT
	D.master_id,
	D.TOPLAMCIRO,
	D.TOPLAMSIPARIS,
	ROUND((D.TOPLAMCIRO / D.TOPLAMSIPARIS), 2) ORTALAMASIPARIS,
	DATEDIFF(DAY, D.ILKSIPARISTARIHI, D.SONSIPARISTARIHI) SIPARISGUNFARK,
	ROUND((DATEDIFF(DAY, D.ILKSIPARISTARIHI, D.SONSIPARISTARIHI) / D.TOPLAMSIPARIS), 1) GUNORT
FROM(
	SELECT TOP 100
	master_id ,
	first_order_date ILKSIPARISTARIHI,
	last_order_date SONSIPARISTARIHI,
	SUM(customer_value_total_ever_online + customer_value_total_ever_offline) TOPLAMCIRO,
	SUM(order_num_total_ever_online + order_num_total_ever_offline) TOPLAMSIPARIS
	FROM FLO_DATA
	GROUP BY master_id, first_order_date, last_order_date
	ORDER BY TOPLAMSIPARIS DESC
		) D;

-- 15. En son alışveriş yapılan kanal (last_order_channel) kırılımında en çok alışveriş yapan müşteriyi getiren sorguyu yazınız. 
SELECT
master_id MUSTERIID,
last_order_channel SONSIPARISKANALI,
SUM(order_num_total_ever_online + order_num_total_ever_offline) TOPLAMSIPARIS
FROM FLO_DATA
GROUP BY last_order_channel, master_id
ORDER BY TOPLAMSIPARIS DESC

-- 16. En son alışveriş yapan kişinin ID'sini getiren sorguyu yazınız. (max son tarihte birden fazla alışveriş yapan ID bulunmakta. Bunları da getiriniz.)
SELECT
master_id,
MAX(last_order_date_online) SONONLINEALISVERIS,
MAX(last_order_date_offline) SONOFFLINEALISVERIS
FROM FLO_DATA
WHERE last_order_date_online = '2021-05-30'
GROUP BY master_id
ORDER BY SONONLINEALISVERIS DESC, SONOFFLINEALISVERIS DESC