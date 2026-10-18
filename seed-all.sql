-- =====================================================================
-- MASTER DUMMY DATA SINKRONISASI RESMI DARI DATA DUMMY ASLI USER
-- 1. SSO Engine (sso_engine)
-- 2. MyMember (mymember_db)
-- 3. Inventory (inventory_sso)
-- =====================================================================

SET FOREIGN_KEY_CHECKS = 0;

-- =====================================================================
-- 1. SSO ENGINE (sso_engine)
-- User asli: farrel labib, alhaidar, kicau, labib, mamang
-- =====================================================================
USE sso_engine;

INSERT INTO `users` (`id`, `email`, `username`, `password_hash`, `created_at`) VALUES
('7a43a6bf-9afa-400d-bbc4-2b467fdedec5', 'labibfarrel960@gmail.com', 'farrel labib', '$2y$10$TueSb3ZX63tOVDg72rj4IuccPWnEu6g8Yq3ZxHTJSKKM6FgJL/KIK', '2026-08-13 03:05:58'),
('ed31274b-82da-409b-8f93-14d3785501e9', 'alhaidar121@gmail.com', 'alhaidar', '$2y$10$HqO2Xgs/vn2lTr5tpjxcCerq.DeTsJnoGVgpnqCi7nT0pKSTdtLQ6', '2026-08-13 04:00:26'),
('465fabba-9dd5-4c4b-8fb5-1b649b5c8dc3', 'kicaumania343@gmail.com', 'kicau', '$2y$10$Wn79Km4XlTIhBi3q5eAAaOKf8mw/Y8Qh6PNnJ6ILNdgqAj9clohvC', '2026-08-14 06:51:58'),
('c82d1c33-f933-4062-9bf7-d44c94d75007', 'labibalhaidar123@gmail.com', 'labib', '$2y$10$qDM99UmswMPhIHe.BKpS8OnImNuKR4zBWnrnIxg9HQX66fhSUDwzC', '2026-08-21 06:37:50'),
('f72ece31-2b58-480b-9fd5-56b101671d21', 'mamangracing232@gmail.com', 'mamang', '$2y$10$RVWcNBRcVC3nBQdzZE.2eORGRuZn/4Q.79yXmO0/hv2m1c1y2gd.K', '2026-08-17 15:33:59')
ON DUPLICATE KEY UPDATE `username` = VALUES(`username`), `password_hash` = VALUES(`password_hash`);

-- Hak Admin SSO
INSERT IGNORE INTO `sso_admins` (`user_id`, `granted_by`, `created_at`)
VALUES ('7a43a6bf-9afa-400d-bbc4-2b467fdedec5', NULL, NOW());

-- Akses Aplikasi SSO untuk semua user ke semua aplikasi terdaftar
INSERT IGNORE INTO `user_application_access` (`user_id`, `application_id`, `granted_by`, `granted_at`)
SELECT u.id, a.id, 1, NOW()
FROM `users` u
CROSS JOIN `applications` a
WHERE u.email IN ('labibfarrel960@gmail.com', 'alhaidar121@gmail.com', 'kicaumania343@gmail.com', 'labibalhaidar123@gmail.com', 'mamangracing232@gmail.com');


-- =====================================================================
-- 2. MYMEMBER (mymember_db)
-- Tipe Member: Platinum Member, Gold Member, Silver Member
-- Mempertahankan seluruh 14 data member asli user tanpa ditimpa/dihapus
-- =====================================================================
USE mymember_db;

ALTER TABLE `members` ADD COLUMN IF NOT EXISTS `is_deleted` TINYINT(1) DEFAULT 0;

-- Sinkronisasi Tipe Member ke Platinum Member (1), Gold Member (2), Silver Member (3)
INSERT INTO `master_type_member` (`id_type`, `type_member`, `kuota_kunjungan`, `deskripsi_benefit`, `created_at`, `updated_at`) VALUES
(1, 'Platinum Member', 50, 'Akses 24/7 seluruh area, internet dedicated 100 Mbps, free locker room, prioritas booking event space & ruang meeting 8 jam/bulan.', NOW(), NOW()),
(2, 'Gold Member', 30, 'Akses jam kerja 08:00 - 22:00, WiFi ultra-fast 50 Mbps, ruang meeting 4 jam/bulan, complimentary pantry coffee & tea.', NOW(), NOW()),
(3, 'Silver Member', 15, 'Akses reguler coworking space, WiFi 20 Mbps, kopi/teh gratis 1x/hari.', NOW(), NOW())
ON DUPLICATE KEY UPDATE 
    `type_member` = VALUES(`type_member`),
    `kuota_kunjungan` = VALUES(`kuota_kunjungan`),
    `deskripsi_benefit` = VALUES(`deskripsi_benefit`);

-- Update label tipe lama (Regular Basic -> Silver, Premium VIP -> Gold, Corporate Team -> Platinum)
UPDATE `master_type_member` SET `type_member` = 'Platinum Member' WHERE `id_type` = 1;
UPDATE `master_type_member` SET `type_member` = 'Gold Member' WHERE `id_type` = 2;
UPDATE `master_type_member` SET `type_member` = 'Silver Member' WHERE `id_type` = 3;

-- Pastikan semua member terikat ke id_type 1, 2, atau 3 yang valid
UPDATE `members` SET `id_type` = 3 WHERE `id_type` NOT IN (1, 2, 3);

-- Update akun admin resepsionis agar sinkron dengan SSO
INSERT INTO `admin` (`id_admin`, `username`, `password`, `nama_resepsionis`, `email`, `sso_user_id`, `synced_at`, `created_at`, `updated_at`) VALUES
(1, 'farrel labib', '$2y$10$TueSb3ZX63tOVDg72rj4IuccPWnEu6g8Yq3ZxHTJSKKM6FgJL/KIK', 'Farrel Labib', 'labibfarrel960@gmail.com', '7a43a6bf-9afa-400d-bbc4-2b467fdedec5', NOW(), NOW(), NOW())
ON DUPLICATE KEY UPDATE `email` = VALUES(`email`), `nama_resepsionis` = VALUES(`nama_resepsionis`), `sso_user_id` = VALUES(`sso_user_id`);


-- =====================================================================
-- 3. INVENTORY (inventory_sso)
-- Menggunakan data asli user: Elektronik, ATK, Lantai 2, Lantai 3,
-- Kertas F4, Laptop Lenovo Thinkpad, Printer Epson, transaksi asli user
-- =====================================================================
USE inventory_sso;

-- Kategori asli
INSERT INTO `categories` (`id`, `name`, `created_at`, `updated_at`) VALUES
(1, 'Elektronik', NOW(), NOW()),
(7, 'ATK', NOW(), NOW())
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`);

-- Lokasi asli
INSERT INTO `locations` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES
(1, 'Lantai 2', 'Divisi Sales', NOW(), NOW()),
(2, 'Lantai 3', 'Divisi Kreatif', NOW(), NOW())
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `description` = VALUES(`description`);

-- Supplier asli
INSERT INTO `suppliers` (`id`, `name`, `contact`, `address`, `notes`, `created_at`, `updated_at`) VALUES
(1, 'ATK Bunga Permai', '0898873372', 'jl. cendrawasih no 7', 'ATK: kertas hvs, bolpint, spidol', NOW(), NOW()),
(2, 'AGRESS.ID', '084374373422', 'Jakarta', 'Distributor resmi laptop & peripheral', NOW(), NOW())
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `contact` = VALUES(`contact`), `address` = VALUES(`address`);

-- Pengguna asli Inventory (sinkron SSO ID asli)
INSERT INTO `users` (`id`, `sso_user_id`, `name`, `email`, `role`, `synced_at`, `password`, `created_at`, `updated_at`) VALUES
(1, '7a43a6bf-9afa-400d-bbc4-2b467fdedec5', 'farrel labib', 'labibfarrel960@gmail.com', 'admin', NOW(), '$2y$10$TueSb3ZX63tOVDg72rj4IuccPWnEu6g8Yq3ZxHTJSKKM6FgJL/KIK', NOW(), NOW()),
(2, 'ed31274b-82da-409b-8f93-14d3785501e9', 'alhaidar', 'alhaidar121@gmail.com', 'staff', NOW(), '$2y$10$HqO2Xgs/vn2lTr5tpjxcCerq.DeTsJnoGVgpnqCi7nT0pKSTdtLQ6', NOW(), NOW()),
(5, '465fabba-9dd5-4c4b-8fb5-1b649b5c8dc3', 'kicau', 'kicaumania343@gmail.com', 'admin', NOW(), '$2y$10$Wn79Km4XlTIhBi3q5eAAaOKf8mw/Y8Qh6PNnJ6ILNdgqAj9clohvC', NOW(), NOW()),
(10, 'c82d1c33-f933-4062-9bf7-d44c94d75007', 'labib', 'labibalhaidar123@gmail.com', 'staff', NOW(), '$2y$10$qDM99UmswMPhIHe.BKpS8OnImNuKR4zBWnrnIxg9HQX66fhSUDwzC', NOW(), NOW())
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `role` = VALUES(`role`), `sso_user_id` = VALUES(`sso_user_id`);

-- Barang asli (Kertas F4, Laptop Lenovo Thinkpad, Printer Epson)
INSERT INTO `items` (`id`, `code`, `name`, `category_id`, `location_id`, `condition`, `unit`, `current_stock`, `created_at`, `updated_at`) VALUES
(1, '1191928192', 'Kertas F4', 7, 1, 'baik', 'kardus', 15, NOW(), NOW()),
(2, 'ITM-20260811-0001', 'Laptop Lenovo Thinkpad', 1, 1, 'baik', 'unit', 10, NOW(), NOW()),
(3, 'ITM-20260820-0001', 'Printer Epson', 1, 2, 'rusak_ringan', 'pcs', 2, NOW(), NOW())
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `condition` = VALUES(`condition`), `current_stock` = VALUES(`current_stock`);

-- Transaksi stok asli
INSERT INTO `stock_transactions` (`id`, `item_id`, `type`, `quantity`, `unit_price`, `total_price`, `supplier_id`, `borrower_name`, `status`, `reference_id`, `document_path`, `notes`, `created_by`, `transaction_date`, `created_at`, `updated_at`) VALUES
(1, 1, 'masuk', 5, 175000.00, 875000.00, 1, NULL, NULL, NULL, NULL, 'Membeli Kertas F4 sebanyak 5 kardus dari ATK Bunga Permai', 1, '2026-08-11', NOW(), NOW()),
(3, 2, 'keluar', 5, NULL, NULL, NULL, 'IT', 'dikembalikan', NULL, NULL, NULL, 1, '2026-08-11', NOW(), NOW()),
(4, 2, 'masuk', 5, NULL, NULL, NULL, NULL, 'dikembalikan', 3, NULL, NULL, 1, '2026-08-13', NOW(), NOW()),
(5, 3, 'masuk', 3, 1250000.00, 3750000.00, 2, NULL, NULL, NULL, NULL, 'beli second', 2, '2026-08-20', NOW(), NOW()),
(6, 3, 'keluar', 2, NULL, NULL, NULL, 'Divisi Marketing', 'dipinjam', NULL, NULL, NULL, 2, '2026-08-20', NOW(), NOW())
ON DUPLICATE KEY UPDATE `quantity` = VALUES(`quantity`), `status` = VALUES(`status`);

-- Purchase Order asli
INSERT INTO `purchase_orders` (`id`, `po_number`, `status`, `requested_by`, `approved_by`, `rejection_reason`, `notes`, `created_at`, `updated_at`) VALUES
(1, 'PO-20260811-0001', 'selesai', 1, 1, NULL, 'Keperluan Lomba 17 Agustus', NOW(), NOW()),
(2, 'PO-20260817-0001', 'ditolak', 2, 1, 'Tidak ada harga satuan barang', NULL, NOW(), NOW())
ON DUPLICATE KEY UPDATE `status` = VALUES(`status`), `rejection_reason` = VALUES(`rejection_reason`);

-- Purchase Order Items asli
INSERT INTO `purchase_order_items` (`id`, `purchase_order_id`, `item_id`, `item_name_temp`, `quantity_requested`, `estimated_price`, `notes`, `created_at`, `updated_at`) VALUES
(2, 1, NULL, 'Tali Rafia', 2, NULL, 'ball', NOW(), NOW()),
(3, 2, NULL, 'Printer Epson 311', 1, NULL, NULL, NOW(), NOW())
ON DUPLICATE KEY UPDATE `item_name_temp` = VALUES(`item_name_temp`), `quantity_requested` = VALUES(`quantity_requested`);

SET FOREIGN_KEY_CHECKS = 1;
