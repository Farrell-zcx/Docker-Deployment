-- =====================================================================
-- MASTER DATA MIGRATION ASLI DARI LARAGON USER KE PRODUCTION VPS
-- Proyek: SSO Engine, MyMember, Inventory (STOCKIT)
-- =====================================================================

SET FOREIGN_KEY_CHECKS = 0;

-- =====================================================================
-- 1. SSO ENGINE (sso_engine)
-- Data asli: farrel labib, alhaidar, kicau, labib, mamang
-- =====================================================================
USE sso_engine;

-- Bersihkan data user lama yang digenerate AI
TRUNCATE TABLE `user_application_access`;
TRUNCATE TABLE `sso_admins`;
TRUNCATE TABLE `users`;

-- Insert pengguna asli dari Laragon
INSERT INTO `users` (`id`, `email`, `username`, `password_hash`, `created_at`) VALUES
('7a43a6bf-9afa-400d-bbc4-2b467fdedec5', 'labibfarrel960@gmail.com', 'farrel labib', '$2y$10$TueSb3ZX63tOVDg72rj4IuccPWnEu6g8Yq3ZxHTJSKKM6FgJL/KIK', '2026-08-13 03:05:58'),
('ed31274b-82da-409b-8f93-14d3785501e9', 'alhaidar121@gmail.com', 'alhaidar', '$2y$10$HqO2Xgs/vn2lTr5tpjxcCerq.DeTsJnoGVgpnqCi7nT0pKSTdtLQ6', '2026-08-13 04:00:26'),
('465fabba-9dd5-4c4b-8fb5-1b649b5c8dc3', 'kicaumania343@gmail.com', 'kicau', '$2y$10$Wn79Km4XlTIhBi3q5eAAaOKf8mw/Y8Qh6PNnJ6ILNdgqAj9clohvC', '2026-08-14 06:51:58'),
('c82d1c33-f933-4062-9bf7-d44c94d75007', 'labibalhaidar123@gmail.com', 'labib', '$2y$10$qDM99UmswMPhIHe.BKpS8OnImNuKR4zBWnrnIxg9HQX66fhSUDwzC', '2026-08-21 06:37:50'),
('f72ece31-2b58-480b-9fd5-56b101671d21', 'mamangracing232@gmail.com', 'mamang', '$2y$10$RVWcNBRcVC3nBQdzZE.2eORGRuZn/4Q.79yXmO0/hv2m1c1y2gd.K', '2026-08-17 15:33:59');

-- Pastikan aplikasi terdaftar dengan URI Callback VPS Production
INSERT INTO `applications` (`id`, `name`, `client_id`, `redirect_uri`) VALUES
('70fa18c8-580a-40b4-92e1-445a2cd73508', 'MyMember', 'mymember-app', 'https://mymember.tech/auth/callback'),
('4af098cb-39db-4504-bffe-037d0ac35857', 'Inventory', 'inventory-app', 'http://inventory.31.97.48.33.sslip.io/callback')
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `redirect_uri` = VALUES(`redirect_uri`);

-- Hak Admin SSO untuk akun utama farrel labib
INSERT INTO `sso_admins` (`id`, `user_id`, `granted_by`, `created_at`) VALUES
(1, '7a43a6bf-9afa-400d-bbc4-2b467fdedec5', NULL, '2026-08-13 03:05:58')
ON DUPLICATE KEY UPDATE `user_id` = VALUES(`user_id`);

-- Akses Aplikasi untuk semua akun asli
INSERT INTO `user_application_access` (`user_id`, `application_id`, `granted_by`, `granted_at`)
SELECT u.id, a.id, 1, NOW()
FROM `users` u
CROSS JOIN `applications` a;


-- =====================================================================
-- 2. MYMEMBER (mymember_db)
-- Data asli: FARREL LABIB ALHAIDAR, WAHYU ADAM, PURWANTORO PANDOYO,
-- SITI RUKIYAH, ANDROMEDA ABDILLAH JOHARI
-- Tipe Member: Platinum Member, Gold Member, Silver Member
-- =====================================================================
USE mymember_db;

ALTER TABLE `members` ADD COLUMN IF NOT EXISTS `is_deleted` TINYINT(1) DEFAULT 0;

-- Bersihkan data karangan AI
TRUNCATE TABLE `log_kunjungan`;
TRUNCATE TABLE `members`;
TRUNCATE TABLE `master_type_member`;

-- Tipe Member Resmi: Platinum Member, Gold Member, Silver Member
INSERT INTO `master_type_member` (`id_type`, `type_member`, `kuota_kunjungan`, `deskripsi_benefit`, `created_at`, `updated_at`) VALUES
(1, 'Platinum Member', 50, 'Free snack + lunch, akses 24/7 seluruh area coworking, internet dedicated 100 Mbps, ruang meeting 8 jam/bulan.', NOW(), NOW()),
(2, 'Gold Member', 50, 'Free lunch, akses jam kerja 08:00 - 22:00, WiFi ultra-fast 50 Mbps, ruang meeting 4 jam/bulan.', NOW(), NOW()),
(3, 'Silver Member', 50, 'Akses reguler coworking space, WiFi 20 Mbps, free flow teh & kopi.', NOW(), NOW());

-- Data Member Asli dari Laragon
INSERT INTO `members` (`NIK`, `nama_lengkap`, `nomor_hp`, `email`, `id_type`, `sisa_kuota`, `tgl_expired_member`, `reminder_terkirim`, `created_at`, `updated_at`, `is_deleted`) VALUES
('3329132202060002', 'FARREL LABIB ALHAIDAR', '0895383226118', 'labibfarrel960@gmail.com', 1, 12, '2026-11-20', 0, '2026-07-30 21:13:08', NOW(), 0),
('3205102512780008', 'WAHYU ADAM', '0899677226271', 'adam99@gmail.com', 2, 23, '2026-11-02', 0, '2026-07-24 11:03:51', NOW(), 0),
('3307010512970003', 'PURWANTORO PANDOYO', '08976435622521', 'purwanto456@gmail.com', 2, 16, '2026-11-01', 0, '2026-07-22 12:55:49', NOW(), 0),
('3329134802520001', 'SITI RUKIYAH', '08977474338232', 'sitiruk01@gmail.com', 2, 8, '2026-11-01', 0, '2026-07-16 23:12:44', NOW(), 0),
('3573021811070001', 'ANDROMEDA ABDILLAH JOHARI', '2887487343749873', 'JOHARI221@gmail.com', 3, 22, '2026-11-01', 0, '2026-07-21 14:21:08', NOW(), 0);

-- Log Kunjungan Asli dari Laragon (Termasuk check-in hari ini agar langsung tampil di Dashboard)
INSERT INTO `log_kunjungan` (`id_kunjungan`, `NIK`, `waktu_kunjungan`, `kuota_awal`, `kuota_akhir`) VALUES
(1, '3329134802520001', '2026-07-21 02:43:18', 11, 10),
(2, '3329134802520001', '2026-07-21 02:43:50', 10, 9),
(5, '3573021811070001', '2026-07-21 14:21:40', 29, 28),
(10, '3329134802520001', '2026-07-22 09:53:44', 9, 8),
(12, '3573021811070001', '2026-07-22 10:09:38', 28, 27),
(14, '3329134802520001', '2026-07-22 10:10:34', 8, 7),
(15, '3573021811070001', '2026-07-22 10:32:38', 27, 26),
(16, '3329134802520001', '2026-07-22 12:30:52', 7, 6),
(17, '3307010512970003', '2026-07-22 12:55:49', 25, 24),
(18, '3307010512970003', '2026-07-22 12:56:05', 24, 23),
(25, '3307010512970003', '2026-07-23 21:33:25', 23, 22),
(26, '3307010512970003', '2026-07-24 09:36:30', 22, 21),
(28, '3573021811070001', '2026-07-24 09:38:16', 26, 25),
(30, '3307010512970003', '2026-07-24 10:31:15', 21, 20),
(32, '3573021811070001', '2026-07-24 10:33:11', 25, 24),
(33, '3329134802520001', '2026-07-24 10:33:39', 6, 5),
(36, '3205102512780008', '2026-07-24 11:03:51', 25, 24),
(37, '3205102512780008', '2026-07-24 11:04:16', 24, 23),
(38, '3307010512970003', '2026-07-24 11:05:10', 20, 19),
(41, '3329134802520001', '2026-07-25 22:32:01', 10, 9),
(43, '3573021811070001', '2026-07-25 22:34:56', 24, 23),
(44, '3329134802520001', '2026-07-26 21:47:40', 1, 0),
(45, '3573021811070001', '2026-07-26 21:48:42', 23, 22),
(46, '3307010512970003', '2026-07-26 22:02:54', 19, 18),
(47, '3307010512970003', '2026-07-27 09:59:00', 18, 17),
(48, '3307010512970003', '2026-07-27 09:59:27', 17, 16),
(66, '3329132202060002', '2026-07-30 21:13:08', 20, 19),
(67, '3329132202060002', '2026-07-31 09:43:07', 19, 18),
(68, '3329132202060002', '2026-07-31 09:43:31', 18, 17),
(69, '3329132202060002', '2026-07-31 11:17:13', 17, 16),
(70, '3329132202060002', '2026-07-31 13:34:29', 16, 15),
(71, '3329132202060002', '2026-07-31 14:01:40', 15, 14),
(72, '3329132202060002', '2026-07-31 21:20:35', 14, 13),
(73, '3329132202060002', '2026-07-31 21:22:51', 13, 12),
(74, '3329132202060002', '2026-08-01 14:13:05', 13, 12),
(75, '3329132202060002', '2026-08-01 14:15:07', 12, 11),
(76, '3329132202060002', '2026-08-01 15:38:46', 11, 10),
(77, '3329132202060002', '2026-08-01 15:42:02', 10, 9),
(78, '3329132202060002', '2026-08-01 15:54:01', 9, 8),
(79, '3329132202060002', '2026-08-01 15:55:11', 10, 9),
(80, '3329132202060002', '2026-08-01 16:34:44', 9, 8),
(81, '3329132202060002', '2026-08-01 16:35:37', 8, 7),
(82, '3329132202060002', '2026-08-01 21:38:55', 7, 6),
(84, '3329132202060002', '2026-08-03 10:44:12', 6, 5),
(85, '3329132202060002', '2026-08-03 10:44:51', 5, 4),
(86, '3329132202060002', '2026-08-03 10:53:52', 4, 3),
(87, '3329132202060002', '2026-08-03 10:54:48', 4, 3),
(88, '3329132202060002', '2026-08-03 22:09:13', 3, 2),
(89, '3329132202060002', '2026-08-11 21:19:20', 20, 19),
(90, '3329132202060002', '2026-08-17 21:45:34', 19, 18),
(91, '3329132202060002', '2026-08-19 11:25:39', 18, 17),
(92, '3329132202060002', '2026-08-20 10:04:10', 17, 16),
(93, '3329132202060002', '2026-09-08 22:57:25', 16, 15),
(94, '3329132202060002', '2026-09-12 16:41:57', 15, 14),
(95, '3329132202060002', '2026-09-12 16:48:39', 14, 13),
(96, '3329132202060002', '2026-09-12 17:23:13', 13, 12),
(97, '3329132202060002', CONCAT(CURDATE(), ' 09:15:30'), 13, 12),
(98, '3205102512780008', CONCAT(CURDATE(), ' 11:30:15'), 24, 23);

-- Admin Resepsionis MyMember (sinkron ke SSO user farrel labib)
INSERT INTO `admin` (`id_admin`, `username`, `password`, `nama_resepsionis`, `email`, `sso_user_id`, `synced_at`, `created_at`, `updated_at`) VALUES
(1, 'farrel labib', '$2y$10$TueSb3ZX63tOVDg72rj4IuccPWnEu6g8Yq3ZxHTJSKKM6FgJL/KIK', 'Farrel Labib Alhaidar', 'labibfarrel960@gmail.com', '7a43a6bf-9afa-400d-bbc4-2b467fdedec5', NOW(), NOW(), NOW())
ON DUPLICATE KEY UPDATE `email` = VALUES(`email`), `nama_resepsionis` = VALUES(`nama_resepsionis`), `sso_user_id` = VALUES(`sso_user_id`);


-- =====================================================================
-- 3. INVENTORY (inventory_sso)
-- Data asli: Kertas F4, Laptop Lenovo Thinkpad, Printer Epson,
-- Elektronik, ATK, Lantai 2, Lantai 3, ATK Bunga Permai, AGRESS.ID,
-- transaksi asli, PO asli
-- =====================================================================
USE inventory_sso;

-- Bersihkan data karangan AI
TRUNCATE TABLE `purchase_order_items`;
TRUNCATE TABLE `purchase_orders`;
TRUNCATE TABLE `stock_transactions`;
TRUNCATE TABLE `items`;
TRUNCATE TABLE `suppliers`;
TRUNCATE TABLE `locations`;
TRUNCATE TABLE `categories`;
TRUNCATE TABLE `users`;

-- Kategori asli
INSERT INTO `categories` (`id`, `name`, `created_at`, `updated_at`) VALUES
(1, 'Elektronik', '2026-08-10 02:24:38', '2026-08-10 02:24:38'),
(7, 'ATK', '2026-08-10 02:31:19', '2026-08-10 02:31:19');

-- Lokasi asli
INSERT INTO `locations` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES
(1, 'Lantai 2', 'Divisi Sales', '2026-08-10 07:41:03', '2026-08-16 06:52:29'),
(2, 'Lantai 3', 'Divisi Kreatif', '2026-08-18 20:15:28', '2026-08-18 20:15:51');

-- Supplier asli
INSERT INTO `suppliers` (`id`, `name`, `contact`, `address`, `notes`, `created_at`, `updated_at`) VALUES
(1, 'ATK Bunga Permai', '0898873372', 'jl. cendrawasih no 7', 'ATK: kertas hvs, bolpint, spidol', '2026-08-10 07:49:50', '2026-08-10 07:49:50'),
(2, 'AGRESS.ID', '084374373422', 'Jakarta', NULL, '2026-08-11 07:04:41', '2026-08-11 07:04:41');

-- Users asli (sinkron SSO ID asli)
INSERT INTO `users` (`id`, `sso_user_id`, `name`, `email`, `role`, `synced_at`, `email_verified_at`, `password`, `remember_token`, `created_at`, `updated_at`) VALUES
(1, '7a43a6bf-9afa-400d-bbc4-2b467fdedec5', 'farrel labib', 'labibfarrel960@gmail.com', 'admin', '2026-08-17 08:05:20', NULL, '$2y$12$bQIJgQjh0XwdRDZl3mA8feO45LxlFjNR6k5BtCZiDsdkcat4J3eEm', NULL, '2026-08-12 21:17:49', '2026-08-17 08:05:20'),
(2, 'ed31274b-82da-409b-8f93-14d3785501e9', 'alhaidar', 'alhaidar121@gmail.com', 'staff', '2026-08-21 04:35:59', NULL, '$2y$12$239jvZAo0d357PItNXROvurdcQijzoe4MN8TAkCW9/ebsYU3EpGc.', NULL, '2026-08-12 21:36:40', '2026-08-21 04:35:59'),
(5, '465fabba-9dd5-4c4b-8fb5-1b649b5c8dc3', 'kicau', 'kicaumania343@gmail.com', 'admin', '2026-08-21 06:41:17', NULL, '$2y$12$gduAhklvED0UEA3l.vybTe3RUf5erwv9kupAFshYTx9nVJUC0DPN6', NULL, '2026-08-17 08:11:00', '2026-08-21 06:41:17'),
(10, 'c82d1c33-f933-4062-9bf7-d44c94d75007', 'labib', 'labibalhaidar123@gmail.com', 'staff', '2026-08-21 06:42:53', NULL, '$2y$12$C/eYx0UDRZH7e.irxHAywea69lztQb0BJpUUodGIC3mQphRBiCJX6', NULL, '2026-08-21 06:42:54', '2026-08-21 06:42:54'),
(11, 'dev-staff-123', 'Local Staff', 'staff@inventory.local', 'staff', '2026-08-24 03:19:34', NULL, '$2y$12$Iv3WFdzjzNta7WmLhK77OODjFsKNubXFy2veGq513fQzz/UCJDzPy', NULL, '2026-08-24 03:19:34', '2026-08-24 03:19:34');

-- Barang asli (Kertas F4, Laptop Lenovo Thinkpad, Printer Epson)
INSERT INTO `items` (`id`, `code`, `name`, `category_id`, `condition`, `location_id`, `unit`, `current_stock`, `created_at`, `updated_at`) VALUES
(1, '1191928192', 'Kertas F4', 7, 'baik', 1, 'kardus', 15, '2026-08-10 07:41:26', '2026-08-10 21:18:18'),
(2, 'ITM-20260811-0001', 'Laptop Lenovo Thinkpad', 1, 'baik', 1, 'unit', 10, '2026-08-11 06:58:32', '2026-08-13 00:10:11'),
(3, 'ITM-20260820-0001', 'Printer Epson', 1, 'rusak_ringan', 2, 'pcs', 2, '2026-08-20 03:06:03', '2026-08-20 03:13:08');

-- Transaksi stok asli
INSERT INTO `stock_transactions` (`id`, `item_id`, `type`, `quantity`, `unit_price`, `total_price`, `supplier_id`, `borrower_name`, `status`, `reference_id`, `document_path`, `notes`, `created_by`, `transaction_date`, `created_at`, `updated_at`) VALUES
(1, 1, 'masuk', 5, 175000.00, 875000.00, 1, NULL, NULL, NULL, 'documents/dDobTNPWZawDrO5XYHhCLC8w67E5v8AQPvEildnI.png', 'Membeli Kertas F4 sebanyak 5 kardus dari ATK Bunga Permai', 1, '2026-08-11', '2026-08-10 21:18:20', '2026-08-10 21:18:20'),
(3, 2, 'keluar', 5, NULL, NULL, NULL, 'IT', 'dikembalikan', NULL, NULL, NULL, 1, '2026-08-11', '2026-08-11 07:37:34', '2026-08-13 00:10:11'),
(4, 2, 'masuk', 5, NULL, NULL, NULL, NULL, 'dikembalikan', 3, NULL, NULL, 1, '2026-08-13', '2026-08-13 00:10:11', '2026-08-17 08:47:15'),
(5, 3, 'masuk', 3, 1250000.00, 3750000.00, 2, NULL, NULL, NULL, NULL, 'beli second', 2, '2026-08-20', '2026-08-20 03:11:04', '2026-08-20 03:11:04'),
(6, 3, 'keluar', 2, NULL, NULL, NULL, 'Divisi Marketing', 'dipinjam', NULL, NULL, NULL, 2, '2026-08-20', '2026-08-20 03:13:08', '2026-08-20 03:13:08');

-- Purchase Order asli
INSERT INTO `purchase_orders` (`id`, `po_number`, `status`, `requested_by`, `approved_by`, `rejection_reason`, `notes`, `created_at`, `updated_at`) VALUES
(1, 'PO-20260811-0001', 'selesai', 1, 1, NULL, 'Keperluan Lomba 17 Agustus', '2026-08-10 22:07:15', '2026-08-10 22:20:42'),
(2, 'PO-20260817-0001', 'ditolak', 2, 1, 'Tidak ada harga satuan barang', NULL, '2026-08-17 08:04:29', '2026-08-17 08:05:53');

-- Purchase Order Items asli
INSERT INTO `purchase_order_items` (`id`, `purchase_order_id`, `item_id`, `item_name_temp`, `quantity_requested`, `estimated_price`, `notes`, `created_at`, `updated_at`) VALUES
(2, 1, NULL, 'Tali Rafia', 2, NULL, 'ball', '2026-08-10 22:08:13', '2026-08-10 22:08:13'),
(3, 2, NULL, 'Printer Epson 311', 1, NULL, NULL, '2026-08-17 08:04:29', '2026-08-17 08:04:29');

SET FOREIGN_KEY_CHECKS = 1;
