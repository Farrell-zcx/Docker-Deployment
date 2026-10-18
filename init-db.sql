-- ===========================================================
-- Script Inisialisasi Database
-- Otomatis dijalankan saat container MySQL pertama kali start
-- ===========================================================

-- Database SSO Engine (sudah dibuat via MYSQL_DATABASE env)
-- CREATE DATABASE IF NOT EXISTS sso_engine;

-- Database MyMember
CREATE DATABASE IF NOT EXISTS mymember_db
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_general_ci;

-- Database Inventory
CREATE DATABASE IF NOT EXISTS inventory_sso
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_general_ci;

-- Grant full access ke root untuk ketiga database
GRANT ALL PRIVILEGES ON sso_engine.* TO 'root'@'%';
GRANT ALL PRIVILEGES ON mymember_db.* TO 'root'@'%';
GRANT ALL PRIVILEGES ON inventory_sso.* TO 'root'@'%';
FLUSH PRIVILEGES;
