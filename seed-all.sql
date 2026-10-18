-- =====================================================================
-- MASTER DUMMY DATA SEEDER FOR 3 DESNET PROJECTS:
-- 1. SSO Engine (sso_engine)
-- 2. MyMember (mymember_db)
-- 3. Inventory (inventory_sso)
-- =====================================================================

SET FOREIGN_KEY_CHECKS = 0;

-- =====================================================================
-- 1. SSO ENGINE (sso_engine)
-- =====================================================================
USE sso_engine;

-- Dummy Users (Password: password123)
INSERT INTO `users` (`id`, `email`, `username`, `password_hash`, `created_at`) VALUES
('90000000-0000-0000-0000-000000000001', 'labibfarrel960@gmail.com', 'farrel_admin', '$2y$10$wZkL0v6yQd9T2EfZHwZJauO57U5w26s8y2R.TsmX0z01g6qHkY.iO', NOW()),
('90000000-0000-0000-0000-000000000002', 'budi.santoso@desnet.id', 'budi_gudang', '$2y$10$wZkL0v6yQd9T2EfZHwZJauO57U5w26s8y2R.TsmX0z01g6qHkY.iO', NOW()),
('90000000-0000-0000-0000-000000000003', 'siti.nurhaliza@desnet.id', 'siti_staff', '$2y$10$wZkL0v6yQd9T2EfZHwZJauO57U5w26s8y2R.TsmX0z01g6qHkY.iO', NOW()),
('90000000-0000-0000-0000-000000000004', 'ahmad.fauzi@desnet.id', 'ahmad_manager', '$2y$10$wZkL0v6yQd9T2EfZHwZJauO57U5w26s8y2R.TsmX0z01g6qHkY.iO', NOW())
ON DUPLICATE KEY UPDATE `username` = VALUES(`username`);

-- Hak Admin SSO untuk akun utama
INSERT IGNORE INTO `sso_admins` (`user_id`, `granted_by`, `created_at`)
SELECT `id`, NULL, NOW() FROM `users` WHERE `email` = 'labibfarrel960@gmail.com';

-- Berikan akses aplikasi ke semua aplikasi aktif
INSERT IGNORE INTO `user_application_access` (`user_id`, `application_id`, `granted_by`, `granted_at`)
SELECT u.id, a.id, 1, NOW()
FROM `users` u
CROSS JOIN `applications` a
WHERE u.email IN ('labibfarrel960@gmail.com', 'budi.santoso@desnet.id', 'siti.nurhaliza@desnet.id', 'ahmad.fauzi@desnet.id');


-- =====================================================================
-- 2. MYMEMBER (mymember_db)
-- =====================================================================
USE mymember_db;

-- Pastikan kolom is_deleted tersedia di tabel members
ALTER TABLE `members` ADD COLUMN IF NOT EXISTS `is_deleted` TINYINT(1) DEFAULT 0;

-- Master Tipe Member: Platinum, Gold, Silver
INSERT INTO `master_type_member` (`id_type`, `type_member`, `kuota_kunjungan`, `deskripsi_benefit`, `created_at`, `updated_at`) VALUES
(1, 'Platinum Member', 50, 'Akses 24/7 seluruh area coworking, internet dedicated 100 Mbps, free locker room, prioritas booking event space & ruang meeting 8 jam/bulan.', NOW(), NOW()),
(2, 'Gold Member', 30, 'Akses jam operasional 08:00 - 22:00, WiFi ultra-fast 50 Mbps, ruang meeting 4 jam/bulan, complimentary pantry coffee & tea.', NOW(), NOW()),
(3, 'Silver Member', 15, 'Akses area reguler coworking, WiFi 20 Mbps, kopi/teh gratis 1x/hari.', NOW(), NOW())
ON DUPLICATE KEY UPDATE `type_member` = VALUES(`type_member`), `kuota_kunjungan` = VALUES(`kuota_kunjungan`), `deskripsi_benefit` = VALUES(`deskripsi_benefit`);

-- Hapus tipe member usang selain 1, 2, 3 jika ada
DELETE FROM `master_type_member` WHERE `id_type` NOT IN (1, 2, 3);

-- Akun Resepsionis MyMember
INSERT INTO `admin` (`id_admin`, `username`, `password`, `nama_resepsionis`, `email`, `sso_user_id`, `synced_at`, `created_at`, `updated_at`) VALUES
(1, 'admin', '$2y$10$wZkL0v6yQd9T2EfZHwZJauO57U5w26s8y2R.TsmX0z01g6qHkY.iO', 'Farrel Alhaidar', 'labibfarrel960@gmail.com', '90000000-0000-0000-0000-000000000001', NOW(), NOW(), NOW())
ON DUPLICATE KEY UPDATE `email` = VALUES(`email`), `nama_resepsionis` = VALUES(`nama_resepsionis`);

-- Data Member Dummy
-- Khusus member 1: email labibfarrel960@gmail.com dengan masa aktif H-2 (CURDATE() + 2 hari)
-- Ini disiapkan khusus agar testing perintah reminder email (php spark email:reminder) langsung masuk ke inbox Gmail!
INSERT INTO `members` (`NIK`, `nama_lengkap`, `nomor_hp`, `email`, `id_type`, `sisa_kuota`, `tgl_expired_member`, `reminder_terkirim`, `is_deleted`, `created_at`, `updated_at`) VALUES
('3301011909980001', 'Farrel Alhaidar (H-2 Test)', '081234567890', 'labibfarrel960@gmail.com', 1, 48, DATE_ADD(CURDATE(), INTERVAL 2 DAY), 0, 0, NOW(), NOW()),
('3301011203950002', 'Budi Prasetyo', '081223344556', 'budi.prasetyo@gmail.com', 2, 28, DATE_ADD(CURDATE(), INTERVAL 25 DAY), 0, 0, NOW(), NOW()),
('3301012507960003', 'Siti Rahmawati', '081334455667', 'siti.rahma@yahoo.com', 2, 22, DATE_ADD(CURDATE(), INTERVAL 45 DAY), 0, 0, NOW(), NOW()),
('3301011808940004', 'Dwi Santoso', '082145566778', 'dwi.santoso@outlook.com', 1, 40, DATE_ADD(CURDATE(), INTERVAL 60 DAY), 0, 0, NOW(), NOW()),
('3301010901990005', 'Rina Anggraini', '085756677889', 'rina.anggraini@gmail.com', 3, 12, DATE_ADD(CURDATE(), INTERVAL 14 DAY), 0, 0, NOW(), NOW()),
('3301013010970006', 'Ahmad Hidayat', '087867788990', 'ahmad.hidayat@company.id', 3, 4, DATE_ADD(CURDATE(), INTERVAL 5 DAY), 0, 0, NOW(), NOW()),
('3301011402930007', 'Eko Wibowo', '089678899001', 'eko.wibowo@startup.co', 2, 25, DATE_ADD(CURDATE(), INTERVAL 80 DAY), 0, 0, NOW(), NOW()),
('3301012211980008', 'Maya Kartika', '081289900112', 'maya.kartika@univ.ac.id', 3, 3, DATE_SUB(CURDATE(), INTERVAL 1 DAY), 1, 0, NOW(), NOW())
ON DUPLICATE KEY UPDATE `nama_lengkap` = VALUES(`nama_lengkap`), `id_type` = VALUES(`id_type`), `sisa_kuota` = VALUES(`sisa_kuota`), `tgl_expired_member` = VALUES(`tgl_expired_member`), `reminder_terkirim` = VALUES(`reminder_terkirim`);

-- Log Kunjungan (Termasuk check-in hari ini agar langsung tampil di Dashboard & Riwayat Kunjungan)
INSERT INTO `log_kunjungan` (`id_kunjungan`, `NIK`, `waktu_kunjungan`, `kuota_awal`, `kuota_akhir`) VALUES
(1, '3301011909980001', CONCAT(CURDATE(), ' 08:30:15'), 50, 49),
(2, '3301011909980001', CONCAT(CURDATE(), ' 13:10:00'), 49, 48),
(3, '3301011203950002', CONCAT(CURDATE(), ' 09:15:22'), 29, 28),
(4, '3301012507960003', CONCAT(CURDATE(), ' 10:45:00'), 23, 22),
(5, '3301011808940004', DATE_SUB(NOW(), INTERVAL 1 DAY), 42, 41),
(6, '3301010901990005', DATE_SUB(NOW(), INTERVAL 1 DAY), 14, 13),
(7, '3301011203950002', DATE_SUB(NOW(), INTERVAL 2 DAY), 30, 29),
(8, '3301011808940004', DATE_SUB(NOW(), INTERVAL 3 DAY), 44, 43),
(9, '3301013010970006', DATE_SUB(NOW(), INTERVAL 3 DAY), 6, 5),
(10, '3301011402930007', DATE_SUB(NOW(), INTERVAL 4 DAY), 27, 26)
ON DUPLICATE KEY UPDATE `waktu_kunjungan` = VALUES(`waktu_kunjungan`), `kuota_awal` = VALUES(`kuota_awal`), `kuota_akhir` = VALUES(`kuota_akhir`);


-- =====================================================================
-- 3. INVENTORY (inventory_sso)
-- =====================================================================
USE inventory_sso;

-- Kategori Barang
INSERT INTO `categories` (`id`, `name`, `created_at`, `updated_at`) VALUES
(1, 'Network & Routing', NOW(), NOW()),
(2, 'Switching & Access Point', NOW(), NOW()),
(3, 'Fiber Optic & Cabling', NOW(), NOW()),
(4, 'Server & Storage', NOW(), NOW()),
(5, 'Power & Cooling', NOW(), NOW()),
(6, 'Tools & Splicer', NOW(), NOW())
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`);

-- Lokasi Penyimpanan
INSERT INTO `locations` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES
(1, 'Warehouse Utama (Lt. 1)', 'Gudang utama penyimpanan barang bulk, kabel drum, dan rak server', NOW(), NOW()),
(2, 'Server Room NOC (Lt. 2)', 'Ruang tertutup NOC untuk active spares (Router, Switch Core, SFP)', NOW(), NOW()),
(3, 'Tool Room & Workshop', 'Ruang penyimpanan alat ukur, OTDR, splicer, dan perkakas teknisi', NOW(), NOW()),
(4, 'Transit Area Dispatch', 'Area staging barang siap antar atau pengembalian teknisi lapangan', NOW(), NOW())
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `description` = VALUES(`description`);

-- Pemasok / Supplier
INSERT INTO `suppliers` (`id`, `name`, `contact`, `address`, `notes`, `created_at`, `updated_at`) VALUES
(1, 'PT Mitra Jaringan Solusindo', 'Budi Santoso (0812-3344-5566)', 'Jl. Gatot Subroto No. 45, Jakarta Selatan', 'Supplier resmi perangkat Cisco & MikroTik', NOW(), NOW()),
(2, 'CV Fiber Optik Nusantara', 'Siti Rahma (0813-7788-9900)', 'Kawasan Industri Rungkut, Surabaya', 'Distributor kabel FO, SFP module, dan patch cord', NOW(), NOW()),
(3, 'PT Sumber Daya Server', 'Hendra Wijaya (0821-1122-3344)', 'Jl. Surya Sumantri No. 12, Bandung', 'Penyedia server rack, UPS, dan PDU', NOW(), NOW()),
(4, 'PT Telekom Sukses Makmur', 'Agus Salim (0856-9900-1122)', 'Jl. Pemuda No. 88, Semarang', 'Penyedia perlengkapan OLT, ONU, dan ONT', NOW(), NOW())
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `contact` = VALUES(`contact`);

-- Pengguna Inventory (Pastikan akun admin ada di ID 1)
INSERT INTO `users` (`id`, `sso_user_id`, `name`, `email`, `role`, `synced_at`, `password`, `created_at`, `updated_at`) VALUES
(1, '90000000-0000-0000-0000-000000000001', 'Farrel Admin', 'labibfarrel960@gmail.com', 'admin', NOW(), '$2y$10$wZkL0v6yQd9T2EfZHwZJauO57U5w26s8y2R.TsmX0z01g6qHkY.iO', NOW(), NOW()),
(2, '90000000-0000-0000-0000-000000000002', 'Budi Staff Gudang', 'budi.santoso@desnet.id', 'staff', NOW(), '$2y$10$wZkL0v6yQd9T2EfZHwZJauO57U5w26s8y2R.TsmX0z01g6qHkY.iO', NOW(), NOW())
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `role` = VALUES(`role`);

-- Master Barang (Kolom `condition` diapit backtick)
INSERT INTO `items` (`id`, `code`, `name`, `category_id`, `location_id`, `condition`, `unit`, `current_stock`, `created_at`, `updated_at`) VALUES
(1, 'ITM-RTR-001', 'MikroTik CCR2004-16G-2S+', 1, 2, 'baik', 'Unit', 8, NOW(), NOW()),
(2, 'ITM-RTR-002', 'MikroTik RB4011iGS+RM', 1, 2, 'baik', 'Unit', 15, NOW(), NOW()),
(3, 'ITM-SWT-001', 'Cisco Catalyst 2960-X 24 Port Gigabit', 2, 2, 'baik', 'Unit', 5, NOW(), NOW()),
(4, 'ITM-SWT-002', 'Ruijie RG-ES218GC-P PoE Switch 16 Port', 2, 1, 'baik', 'Unit', 4, NOW(), NOW()),
(5, 'ITM-APN-001', 'Ubiquiti UniFi U6 Pro Access Point', 2, 1, 'baik', 'Unit', 12, NOW(), NOW()),
(6, 'ITM-CBL-001', 'Kabel FO Dropcore 1 Core 1000m Drum', 3, 1, 'baik', 'Roll', 25, NOW(), NOW()),
(7, 'ITM-CBL-002', 'Patch Cord SC-UPC to SC-UPC 3m Single Mode', 3, 1, 'baik', 'Pcs', 80, NOW(), NOW()),
(8, 'ITM-SFP-001', 'SFP+ 10G Transceiver 1310nm 10km LC', 3, 2, 'baik', 'Pcs', 6, NOW(), NOW()),
(9, 'ITM-SRV-001', 'Dell PowerEdge R740 2U Rack Server', 4, 2, 'baik', 'Unit', 2, NOW(), NOW()),
(10, 'ITM-PWR-001', 'APC Smart-UPS RT 3000VA On-Line 230V', 5, 2, 'baik', 'Unit', 3, NOW(), NOW()),
(11, 'ITM-TLS-001', 'Fujikura 90S+ Core Alignment Fusion Splicer', 6, 3, 'baik', 'Unit', 2, NOW(), NOW()),
(12, 'ITM-TLS-002', 'Anritsu MT9085 Series OTDR Optical Tester', 6, 3, 'rusak_ringan', 'Unit', 1, NOW(), NOW())
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `condition` = VALUES(`condition`), `current_stock` = VALUES(`current_stock`);

-- Transaksi Stok (Rentang 7 hari terakhir agar grafik dashboard bervariasi)
INSERT INTO `stock_transactions` (`id`, `item_id`, `type`, `quantity`, `unit_price`, `total_price`, `supplier_id`, `borrower_name`, `status`, `reference_id`, `document_path`, `notes`, `created_by`, `transaction_date`, `created_at`, `updated_at`) VALUES
(1, 1, 'masuk', 10, 4500000.00, 45000000.00, 1, NULL, NULL, NULL, NULL, 'Pengadaan router core NOC', 1, DATE_SUB(CURDATE(), INTERVAL 6 DAY), NOW(), NOW()),
(2, 6, 'masuk', 30, 850000.00, 25500000.00, 2, NULL, NULL, NULL, NULL, 'Restock kabel dropcore batch 1', 1, DATE_SUB(CURDATE(), INTERVAL 5 DAY), NOW(), NOW()),
(3, 7, 'masuk', 100, 25000.00, 2500000.00, 2, NULL, NULL, NULL, NULL, 'Pembelian patch cord FO', 1, DATE_SUB(CURDATE(), INTERVAL 5 DAY), NOW(), NOW()),
(4, 1, 'keluar', 2, NULL, NULL, NULL, 'Teknisi Ahmad (BTS Simpang Lima)', 'habis', NULL, NULL, 'Deploy link BTS baru', 1, DATE_SUB(CURDATE(), INTERVAL 4 DAY), NOW(), NOW()),
(5, 5, 'masuk', 15, 2400000.00, 36000000.00, 1, NULL, NULL, NULL, NULL, 'Pengadaan Access Point kantor cabang', 1, DATE_SUB(CURDATE(), INTERVAL 3 DAY), NOW(), NOW()),
(6, 6, 'keluar', 5, NULL, NULL, NULL, 'Tim Penarikan Kabel FO (Zona Barat)', 'habis', NULL, NULL, 'Instalasi pelanggan korporat', 1, DATE_SUB(CURDATE(), INTERVAL 3 DAY), NOW(), NOW()),
(7, 11, 'keluar', 1, NULL, NULL, NULL, 'Bambang Teknisi FO', 'dipinjam', NULL, NULL, 'Peminjaman splicer untuk splicing ODP', 1, DATE_SUB(CURDATE(), INTERVAL 2 DAY), NOW(), NOW()),
(8, 4, 'masuk', 6, 1850000.00, 11100000.00, 1, NULL, NULL, NULL, NULL, 'Pengadaan Switch PoE Ruijie', 1, DATE_SUB(CURDATE(), INTERVAL 1 DAY), NOW(), NOW()),
(9, 4, 'keluar', 2, NULL, NULL, NULL, 'Agus Teknisi CCTV', 'habis', NULL, NULL, 'Pemasangan switch di gedung warehouse', 1, DATE_SUB(CURDATE(), INTERVAL 1 DAY), NOW(), NOW()),
(10, 5, 'keluar', 3, NULL, NULL, NULL, 'Tim IT Support', 'habis', NULL, NULL, 'Upgrade WiFi ruang rapat', 1, CURDATE(), NOW(), NOW()),
(11, 7, 'keluar', 20, NULL, NULL, NULL, 'Tim Maintenance FO', 'habis', NULL, NULL, 'Perapihan kabel rack server NOC', 1, CURDATE(), NOW(), NOW())
ON DUPLICATE KEY UPDATE `quantity` = VALUES(`quantity`), `transaction_date` = VALUES(`transaction_date`);

-- Purchase Orders (PO)
INSERT INTO `purchase_orders` (`id`, `po_number`, `status`, `requested_by`, `approved_by`, `rejection_reason`, `notes`, `created_at`, `updated_at`) VALUES
(1, 'PO-2026-001', 'selesai', 1, 1, NULL, 'Pengadaan darurat kabel FO dan aksesoris ODC', DATE_SUB(NOW(), INTERVAL 10 DAY), DATE_SUB(NOW(), INTERVAL 6 DAY)),
(2, 'PO-2026-002', 'disetujui', 1, 1, NULL, 'Penambahan unit router backup MikroTik CCR', DATE_SUB(NOW(), INTERVAL 3 DAY), DATE_SUB(NOW(), INTERVAL 2 DAY)),
(3, 'PO-2026-003', 'diajukan', 1, NULL, NULL, 'Pengajuan pembelian baterai pengganti UPS APC 3000VA', DATE_SUB(NOW(), INTERVAL 1 DAY), DATE_SUB(NOW(), INTERVAL 1 DAY))
ON DUPLICATE KEY UPDATE `status` = VALUES(`status`), `notes` = VALUES(`notes`);

-- Purchase Order Items
INSERT INTO `purchase_order_items` (`id`, `purchase_order_id`, `item_id`, `item_name_temp`, `quantity_requested`, `estimated_price`, `notes`, `created_at`, `updated_at`) VALUES
(1, 1, 6, NULL, 20, 850000.00, 'Kabel dropcore 1000m', DATE_SUB(NOW(), INTERVAL 10 DAY), NOW()),
(2, 1, 7, NULL, 50, 25000.00, 'Patch cord SC-UPC', DATE_SUB(NOW(), INTERVAL 10 DAY), NOW()),
(3, 2, 1, NULL, 4, 4500000.00, 'Router CCR2004 standby', DATE_SUB(NOW(), INTERVAL 3 DAY), NOW()),
(4, 3, 10, NULL, 2, 3500000.00, 'Battery pack replacement', DATE_SUB(NOW(), INTERVAL 1 DAY), NOW()),
(5, 3, NULL, 'Tool Kit Crimping & Stripper FO Pro', 3, 450000.00, 'Set perkakas tambahan teknisi', DATE_SUB(NOW(), INTERVAL 1 DAY), NOW())
ON DUPLICATE KEY UPDATE `quantity_requested` = VALUES(`quantity_requested`), `estimated_price` = VALUES(`estimated_price`);

SET FOREIGN_KEY_CHECKS = 1;
