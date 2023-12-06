SELECT *
FROM KESINTI

-- 2. "KESİNTİ_NEDENİNE_İLİŞKİN_AÇIKLAMA" sütununda yer alan benzersiz kesinti nedenlerini listeleyiniz.

SELECT DISTINCT KESİNTİ_NEDENİNE_İLİŞKİN_AÇIKLAMA
FROM KESINTI

-- 3. "BAŞLAMA_TARİHİ_VE_ZAMANI" sütununda en erken ve en geç başlama tarihlerini bulunuz.

SELECT 
MIN(BAŞLAMA_TARİHİ_VE_ZAMANI) EN_ERKEN,
MAX(BAŞLAMA_TARİHİ_VE_ZAMANI) EN_GEC
FROM KESINTI

-- 4. "KESİNTİ_SÜRESİ" sütunundaki kesinti süresi ortalamasını hesaplayınız.

SELECT 
AVG(KESİNTİ_SÜRESİ) ORT_KESINTI_SURESI
FROM KESINTI

-- 5. "KENTSEL_OG" ve "KENTSEL_AG" sütunlarını toplayarak "TOPLAM_KENTSEL_OG" sütununu oluşturunuz.

SELECT 
KENTSEL_OG + KENTSEL_AG
FROM KESINTI

ALTER TABLE KESINTI
ADD TOPLAM_KENTSEL INT

UPDATE KESINTI
SET TOPLAM_KENTSEL = KENTSEL_OG + KENTSEL_AG

SELECT
TOPLAM_KENTSEL
FROM KESINTI 

-- 6. "SÜREYE_GÖRE" sütununda yer alan kesintileri, kısa süreli ve uzun süreli olarak gruplandırınız.

SELECT
SÜREYE_GÖRE,
COUNT(SÜREYE_GÖRE) KESINTI_SAYISI
FROM KESINTI
GROUP BY SÜREYE_GÖRE

-- 7. "KAYNAĞA_GÖRE" sütununda en çok tekrar eden kaynakları ve bu kaynakların sayısını bulunuz.

SELECT
KAYNAĞA_GÖRE,
COUNT(*) KESINTI_SAYISI
FROM KESINTI
GROUP BY KAYNAĞA_GÖRE
ORDER BY KAYNAĞA_GÖRE

-- 8. "BİLDİRİME_GÖRE" sütununda "21-07-2021" tarihinden sonraki kesinti bildirimlerini listeleyiniz.

SELECT 
BAŞLAMA_TARİHİ_VE_ZAMANI,
BİLDİRİME_GÖRE
FROM KESINTI
WHERE BAŞLAMA_TARİHİ_VE_ZAMANI > '2021-07-21 23:59:59'

-- 9. "BAŞLAMA_TARİHİ_VE_ZAMANI" ve "SONA_ERME_TARİHİ_VE_ZAMANI" sütunlarını kullanarak kesinti süresini hesaplayın ve "KESİNTİ_SÜRESİ" adında yeni bir sütun oluşturun.

SELECT
DATEDIFF(HOUR, BAŞLAMA_TARİHİ_VE_ZAMANI, SONA_ERME_TARİHİ_VE_ZAMANI) SAATLIK_KESINTI_SURESI
FROM KESINTI

ALTER TABLE KESINTI
ADD SAATLIK_KESINTI_SURESI SMALLINT

UPDATE KESINTI
SET SAATLIK_KESINTI_SURESI = DATEDIFF(HOUR, BAŞLAMA_TARİHİ_VE_ZAMANI, SONA_ERME_TARİHİ_VE_ZAMANI)

SELECT
SAATLIK_KESINTI_SURESI
FROM KESINTI

-- 10. "KENTSEL_OG", "KENTSEL_AG", "KENTALTI_OG" ve "KENTALTI_AG" sütunlarındaki değerleri toplayarak kentsel ve kırsal alanlarda toplam kesinti sayısını hesaplayın.

SELECT
SUM(KENTSEL_OG + KENTSEL_AG) KENTSEL_KESINTI,
SUM(KENTALTI_OG + KENTALTI_AG) KENTALTI_KESINTI
FROM KESINTI

-- 11. "SEBEBE_GÖRE" sütununda yer alan kesintileri, belirli bir sebep listesine göre gruplayın ve bu sebeplerin toplam kesinti süresini hesaplayın.

SELECT
SEBEBE_GÖRE,
SUM(KESİNTİ_SÜRESİ) TOPLAM_KESINTI_SURESI
FROM KESINTI 
GROUP BY SEBEBE_GÖRE

-- 12. "BAŞLAMA_TARİHİ_VE_ZAMANI" sütununda yer alan kesintileri, yıl ve ay bazında gruplayın ve her bir yıl/ay için toplam kesinti süresini hesaplayın.

SELECT
DATEPART(YEAR, BAŞLAMA_TARİHİ_VE_ZAMANI) BASLAMA_YILI,
DATEPART(MONTH, BAŞLAMA_TARİHİ_VE_ZAMANI) BASLAMA_AYI,
SUM(KESİNTİ_SÜRESİ)
FROM KESINTI
GROUP BY DATEPART(YEAR, BAŞLAMA_TARİHİ_VE_ZAMANI), DATEPART(MONTH, BAŞLAMA_TARİHİ_VE_ZAMANI)
ORDER BY BASLAMA_AYI

-- 13. "BAŞLAMA_TARİHİ_VE_ZAMANI" sütununda yer alan tarihleri kullanarak, haftalık kesinti sayısını ve toplam kesinti süresini hesaplayın.

SELECT 
DATEPART(WEEK, BAŞLAMA_TARİHİ_VE_ZAMANI) HAFTA,
COUNT(*) KESINTI_SAYISI,
SUM(KESİNTİ_SÜRESİ) TOPLAM_KESINTI_SURESI
FROM KESINTI
GROUP BY DATEPART(WEEK, BAŞLAMA_TARİHİ_VE_ZAMANI)
ORDER BY HAFTA