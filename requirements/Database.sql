--              Setup
-- -----------------------------------
SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+02:00";

CREATE DATABASE IF NOT EXISTS 'Euk' DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `Euk`;

-- -----------------------------------
--              Tabeller
-- -----------------------------------
DROP TABLE IF EXISTS 'Arrangementer';
CREATE TABLE 'Arrangementer' (
    'Id' int(11) NOT  NULL AUTO_INCREMENT COMMENT 'Id to allow indexing',
    'Navn' varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Name of event',
    'Dato' datetime NOT NULL COMMENT 'Date of event',
    'Beskrivelse' text NOT NULL COMMENT 'Description of event'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS 'Billeder';
CREATE TABLE 'Billeder' (
    'Id' int(11) NOT NULL AUTO_INCREMENT COMMENT 'Id to allow indexing',
    'Navn' varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Name of picture',
    'Dato' datetime NOT NULL COMMENT 'Date of upload',
    'Fil' image NOT NULL COMMENT 'Binary of image'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


ALTER TABLE 'Arrangementer'
    ADD PRIMARY KEY ('Id'),
    ADD UNIQUE KEY 'Navn'('Navn'),
    ADD UNIQUE KEY 'Beskrivelse'('Beskrivelse');

ALTER TABLE 'Billeder'
    ADD PRIMARY KEY ('Id'),
    ADD UNIQUE KEY 'Navn'('Navn'),
    ADD UNIQUE KEY 'Fil'('Fil');

