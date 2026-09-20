-- 1. Tablo Tasarimi ve Kisitlar

PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS odunc;
DROP TABLE IF EXISTS uyeler;
DROP TABLE IF EXISTS kitaplar;

CREATE TABLE uyeler (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    ad TEXT NOT NULL,
    yas INTEGER CHECK (yas > 13),
    sehir TEXT DEFAULT 'Erzincan',
    kayit TEXT DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE kitaplar (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    ad TEXT NOT NULL UNIQUE
);

CREATE TABLE odunc (
    uye_id INTEGER NOT NULL,
    kitap_id INTEGER NOT NULL,
    gun INTEGER,
    PRIMARY KEY (uye_id, kitap_id),
    FOREIGN KEY (uye_id) REFERENCES uyeler(id) ON DELETE CASCADE,
    FOREIGN KEY (kitap_id) REFERENCES kitaplar(id)
);

-- Odunc kaydi olan kitap silinmek istenirse FOREIGN KEY hatasi verir, silinmez.
-- CASCADE olsaydi kitapla birlikte odunc gecmisi de silinirdi.
-- DELETE FROM kitaplar WHERE id = 1;


-- 2. Veri Ekleme

INSERT INTO kitaplar (ad) VALUES
('Suç ve Ceza'),
('Sefiller'),
('Kürk Mantolu Madonna'),
('Tutunamayanlar'),
('Simyacı');

INSERT INTO uyeler (ad, yas, sehir) VALUES ('Ahmet', 25, 'Erzincan');
INSERT INTO uyeler (ad, yas, sehir) VALUES ('Ayşe', 17, 'İstanbul');
INSERT INTO uyeler (ad, yas) VALUES ('Mehmet', 34);
INSERT INTO uyeler (ad, yas, sehir) VALUES ('Zeynep', 16, 'Ankara');
INSERT INTO uyeler (ad, yas) VALUES ('Ali', 45);
INSERT INTO uyeler (ad, yas, sehir) VALUES ('Fatma', 22, 'İzmir');
INSERT INTO uyeler (ad, yas) VALUES ('Mustafa', 15);
INSERT INTO uyeler (ad, yas, sehir) VALUES ('Elif', 29, 'İstanbul');
INSERT INTO uyeler (ad, yas, sehir) VALUES ('Emre', 52, 'Erzincan');
INSERT INTO uyeler (ad, yas, sehir) VALUES ('Selin', 19, 'Ankara');

SELECT * FROM uyeler;

-- CHECK hatasi verir (yas > 13 degil)
-- INSERT INTO uyeler (ad, yas) VALUES ('Can', 10);

-- FOREIGN KEY hatasi verir (99 numarali uye yok)
-- INSERT INTO odunc (uye_id, kitap_id, gun) VALUES (99, 1, 10);

INSERT INTO odunc (uye_id, kitap_id, gun) VALUES
(1, 1, 12), (1, 2, 35),
(2, 3, 5), (2, 4, 8),
(3, 1, 40), (3, 3, 22),
(4, 2, 3), (4, 4, 14),
(5, 1, 45), (5, 2, 30), (5, 4, 18),
(6, 3, 10), (6, 1, 7),
(7, 2, 28), (7, 4, 33),
(8, 1, 15), (8, 3, 20),
(9, 2, 16), (9, 4, 38),
(10, 3, 4), (10, 1, 25);

INSERT INTO uyeler (ad, yas, sehir) VALUES ('Burak', 30, 'Bursa');


-- 3. JOIN

SELECT u.ad AS uye, k.ad AS kitap, o.gun
FROM odunc o
JOIN uyeler u ON o.uye_id = u.id
JOIN kitaplar k ON o.kitap_id = k.id;

SELECT u.ad AS uye, k.ad AS kitap, o.gun
FROM odunc o
JOIN uyeler u ON o.uye_id = u.id
JOIN kitaplar k ON o.kitap_id = k.id
WHERE o.gun > 30;

SELECT u.ad AS uye, k.ad AS kitap, o.gun
FROM odunc o
JOIN uyeler u ON o.uye_id = u.id
JOIN kitaplar k ON o.kitap_id = k.id
WHERE u.sehir = 'Erzincan';

SELECT u.ad AS uye, k.ad AS kitap, o.gun
FROM uyeler u
LEFT JOIN odunc o ON o.uye_id = u.id
LEFT JOIN kitaplar k ON o.kitap_id = k.id;


-- 4. Gruplama ve Toplama Fonksiyonlari

SELECT u.ad, ROUND(AVG(o.gun), 1) AS ortalama, COUNT(*) AS kitap_sayisi, MAX(o.gun) AS en_uzun
FROM odunc o
JOIN uyeler u ON o.uye_id = u.id
GROUP BY u.id, u.ad;

-- WHERE gruplamadan once calistigi icin AVG kullanilamaz, HAVING gruplardan sonra calisir.
SELECT u.ad, ROUND(AVG(o.gun), 1) AS ortalama, COUNT(*) AS kitap_sayisi, MAX(o.gun) AS en_uzun
FROM odunc o
JOIN uyeler u ON o.uye_id = u.id
GROUP BY u.id, u.ad
HAVING AVG(o.gun) > 20;

SELECT k.ad, COUNT(o.kitap_id) AS odunc_sayisi
FROM kitaplar k
LEFT JOIN odunc o ON o.kitap_id = k.id
GROUP BY k.id, k.ad;

SELECT sehir, COUNT(*) AS uye_sayisi
FROM uyeler
GROUP BY sehir
ORDER BY uye_sayisi DESC;


-- 5. Alt Sorgu

SELECT ad FROM uyeler
WHERE id IN (SELECT uye_id FROM odunc WHERE gun > 30);

SELECT ad FROM kitaplar
WHERE id NOT IN (SELECT kitap_id FROM odunc);

SELECT * FROM odunc
WHERE gun > (SELECT AVG(gun) FROM odunc);


-- 6. CASE

SELECT uye_id, kitap_id, gun,
    CASE
        WHEN gun > 30 THEN 'Gecikmiş'
        WHEN gun BETWEEN 15 AND 30 THEN 'Uyarı'
        ELSE 'Normal'
    END AS durum
FROM odunc;

SELECT ad, yas,
    CASE WHEN yas <= 18 THEN 'Genç' ELSE 'Yetişkin' END AS grup
FROM uyeler;

SELECT
    CASE
        WHEN gun > 30 THEN 'Gecikmiş'
        WHEN gun BETWEEN 15 AND 30 THEN 'Uyarı'
        ELSE 'Normal'
    END AS durum,
    COUNT(*) AS sayi
FROM odunc
GROUP BY durum;


-- 7. Index

-- ad = '...', ORDER BY ad gibi sorgulari hizlandirir
CREATE INDEX idx_uyeler_ad ON uyeler(ad);

ALTER TABLE uyeler ADD COLUMN eposta TEXT;
CREATE UNIQUE INDEX idx_uyeler_eposta ON uyeler(eposta);

UPDATE uyeler SET eposta = 'ahmet@mail.com' WHERE id = 1;

-- UNIQUE hatasi verir, ayni e-posta ikinci kez kullanilamaz
-- UPDATE uyeler SET eposta = 'ahmet@mail.com' WHERE id = 2;
