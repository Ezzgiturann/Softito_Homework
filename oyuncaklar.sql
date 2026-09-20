CREATE TABLE oyuncaklar (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    isim TEXT NOT NULL,
    cesit TEXT,
    fiyat REAL CHECK (fiyat > 0),
    renk TEXT DEFAULT 'kırmızı'
);

-- BÖLÜM 2: Ekleme
INSERT INTO oyuncaklar (isim, cesit, fiyat) 
VALUES ('Şimşek', 'araba', 50);

INSERT INTO oyuncaklar (isim, cesit, fiyat, renk) VALUES
('Ayıcık', 'peluş', 80, 'kahverengi'),
('Kale Seti', 'lego', 150, 'gri'),
('Zıpzıp', 'top', 20, 'sarı'),
('Barbi', 'bebek', 90, 'pembe');

-- BÖLÜM 4: Değiştirme ve Silme
UPDATE oyuncaklar 
SET renk = 'mavi' 
WHERE isim = 'Şimşek';

DELETE FROM oyuncaklar 
WHERE isim = 'Zıpzıp';

-- BÖLÜM 5: Tabloyu Düzenleme
ALTER TABLE oyuncaklar ADD COLUMN kimin TEXT;

UPDATE oyuncaklar 
SET kimin = 'Ali' 
WHERE isim = 'Kale Seti';

ALTER TABLE oyuncaklar RENAME COLUMN cesit TO tur;

-- BÖLÜM 3: Bulma / Listeleme Sorguları
SELECT * FROM oyuncaklar;
SELECT isim, fiyat FROM oyuncaklar WHERE fiyat >= 80;
SELECT * FROM oyuncaklar ORDER BY fiyat DESC LIMIT 2;
SELECT * FROM oyuncaklar WHERE isim LIKE 'Z%';
SELECT * FROM oyuncaklar WHERE tur IN ('araba', 'top');
SELECT * FROM oyuncaklar WHERE fiyat BETWEEN 20 AND 60;
