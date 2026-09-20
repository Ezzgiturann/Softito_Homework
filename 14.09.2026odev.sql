-- ==========================================
-- BÖLÜM 1 – Tablo Kurma
-- ==========================================
CREATE TABLE oyuncaklar(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    isim TEXT NOT NULL,
    cesit TEXT,
    fiyat REAL CHECK (fiyat > 0),
    renk TEXT DEFAULT 'kırmızı'
);

-- ==========================================
-- BÖLÜM 2 – Ekleme
-- ==========================================
-- Şimşek'i ekle (renk yazmadığımız için DEFAULT kuralı gereği otomatik 'kırmızı' olur)
INSERT INTO oyuncaklar(isim, cesit, fiyat) 
VALUES ('Şimşek', 'araba', 50);

-- Tek komutla dört oyuncağı ekleme
INSERT INTO oyuncaklar(isim, cesit, fiyat, renk) VALUES
    ('Ayıcık', 'peluş', 80, 'kahverengi'),
    ('Kale Seti', 'lego', 150, 'gri'),
    ('Zıpzıp', 'top', 20, 'sarı'),
    ('Barbi', 'bebek', 90, 'pembe');

-- ==========================================
-- BÖLÜM 3 – Bulma (Sorgular)
-- ==========================================
-- 1. Kutudaki tüm oyuncakları göster
SELECT * FROM oyuncaklar;

-- 2. Fiyatı 80 lira ve üstü olanların ismi ve fiyatı
SELECT isim, fiyat FROM oyuncaklar WHERE fiyat >= 80;

-- 3. En pahalı 2 oyuncağı listele
SELECT * FROM oyuncaklar ORDER BY fiyat DESC LIMIT 2;

-- 4. İsmi Z harfiyle başlayan oyuncaklar
SELECT * FROM oyuncaklar WHERE isim LIKE 'Z%';

-- 5. Sadece araba ve topları göster
SELECT * FROM oyuncaklar WHERE cesit IN ('araba', 'top');

-- 6. Fiyatı 20 ile 60 lira arasında olanlar
SELECT * FROM oyuncaklar WHERE fiyat BETWEEN 20 AND 60;

-- ==========================================
-- BÖLÜM 4 – Değiştirme ve Silme
-- ==========================================
-- Şimşek'in rengini mavi yap
UPDATE oyuncaklar SET renk = 'mavi' WHERE isim = 'Şimşek';

-- Zıpzıp'ı kutudan çıkar (sil)
DELETE FROM oyuncaklar WHERE isim = 'Zıpzıp';

-- ==========================================
-- BÖLÜM 5 – Tabloyu Düzenleme
-- ==========================================
-- Tabloya 'kimin' adında yeni sütun ekle
ALTER TABLE oyuncaklar ADD COLUMN kimin TEXT;

-- Kale Seti'nin sahibini Ali yap
UPDATE oyuncaklar SET kimin = 'Ali' WHERE isim = 'Kale Seti';

-- 'cesit' sütununun adını 'tur' olarak değiştir
ALTER TABLE oyuncaklar RENAME COLUMN cesit TO tur;
