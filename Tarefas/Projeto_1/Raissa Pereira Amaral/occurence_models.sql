-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`occurrence_multi`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`occurrence_multi` (
  `idoccurrence_multi` INT NOT NULL,
  `type` VARCHAR(45) NOT NULL,
  `title` VARCHAR(70) NOT NULL,
  `lat` DOUBLE NOT NULL,
  `long` DOUBLE NOT NULL,
  `date_time` DATETIME NOT NULL,
  `description` VARCHAR(350) NULL,
  PRIMARY KEY (`idoccurrence_multi`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`occurrence_binary`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`occurrence_binary` (
  `idoccurrence_multi` INT NOT NULL,
  `type` VARCHAR(45) NOT NULL,
  `title` VARCHAR(70) NOT NULL,
  `lat` DOUBLE NOT NULL,
  `long` DOUBLE NOT NULL,
  `date_time` DATETIME NOT NULL,
  `description` VARCHAR(350) NULL,
  `obj1` INT NULL,
  `obj2` TINYINT(1) NULL,
  `ob3` TINYINT(1) NULL,
  `obj4` TINYINT(1) NULL,
  `obj5` TINYINT(1) NULL,
  `obj6` TINYINT(1) NULL,
  `obj7` TINYINT(1) NULL,
  `obj8` TINYINT(1) NULL,
  `obj9` TINYINT(1) NULL,
  `obj10` TINYINT(1) NULL,
  `obj11` TINYINT(1) NULL,
  `obj12` TINYINT(1) NULL,
  `ob13` TINYINT(1) NULL,
  `obj14` TINYINT(1) NULL,
  `obj15` TINYINT(1) NULL,
  `obj16` TINYINT(1) NULL,
  `obj17` TINYINT(1) NULL,
  `obj18` TINYINT(1) NULL,
  `obj19` TINYINT(1) NULL,
  PRIMARY KEY (`idoccurrence_multi`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`occurrence_conv_copy1`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`occurrence_conv_copy1` (
  `idoccurrence_conv` INT NOT NULL,
  `type` VARCHAR(45) NOT NULL,
  `title` VARCHAR(70) NOT NULL,
  `lat` DOUBLE NOT NULL,
  `long` DOUBLE NOT NULL,
  `date_time` DATETIME NOT NULL,
  `description` VARCHAR(350) NULL,
  `stolen` INT ZEROFILL UNSIGNED NOT NULL,
  PRIMARY KEY (`idoccurrence_conv`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`stolen`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`stolen` (
  `idstolen` INT NOT NULL,
  `id_occurence` INT NOT NULL,
  `obj` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`idstolen`),
  UNIQUE INDEX `id_occurence_UNIQUE` (`id_occurence` ASC),
  UNIQUE INDEX `obj_UNIQUE` (`obj` ASC))
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
