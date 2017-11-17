-- MySQL Script generated by MySQL Workbench
-- Thu Nov 16 23:30:57 2017
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema dbsimples
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `dbsimples` ;

-- -----------------------------------------------------
-- Schema dbsimples
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `dbsimples` DEFAULT CHARACTER SET utf8 ;
USE `dbsimples` ;

-- -----------------------------------------------------
-- Table `dbsimples`.`endereco`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `dbsimples`.`endereco` ;

CREATE TABLE IF NOT EXISTS `dbsimples`.`endereco` (
  `cep` INT NOT NULL,
  `rua` VARCHAR(45) NOT NULL,
  `bairro` VARCHAR(45) NOT NULL,
  `numero` INT NOT NULL,
  PRIMARY KEY (`cep`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `dbsimples`.`cliente`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `dbsimples`.`cliente` ;

CREATE TABLE IF NOT EXISTS `dbsimples`.`cliente` (
  `cpf_cli` INT NOT NULL,
  `nome_cli` VARCHAR(100) NOT NULL,
  `tel_cli` VARCHAR(14) NOT NULL,
  `email_cli` VARCHAR(100) NOT NULL,
  `cep_endereco` INT NOT NULL,
  PRIMARY KEY (`cpf_cli`),
  INDEX `endereco_cliente_idx` (`cep_endereco` ASC),
  CONSTRAINT `endereco_cliente`
    FOREIGN KEY (`cep_endereco`)
    REFERENCES `dbsimples`.`endereco` (`cep`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `dbsimples`.`funcionario`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `dbsimples`.`funcionario` ;

CREATE TABLE IF NOT EXISTS `dbsimples`.`funcionario` (
  `cpf_func` INT NOT NULL,
  `nome_func` VARCHAR(45) NOT NULL,
  `tel_func` VARCHAR(45) NOT NULL,
  `email_func` VARCHAR(45) NOT NULL,
  `cargo` VARCHAR(45) NOT NULL,
  `cep_endereco` INT NOT NULL,
  PRIMARY KEY (`cpf_func`),
  INDEX `endereco_funcionario_idx` (`cep_endereco` ASC),
  CONSTRAINT `endereco_funcionario`
    FOREIGN KEY (`cep_endereco`)
    REFERENCES `dbsimples`.`endereco` (`cep`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `dbsimples`.`fornecedor`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `dbsimples`.`fornecedor` ;

CREATE TABLE IF NOT EXISTS `dbsimples`.`fornecedor` (
  `cnpj` INT NOT NULL,
  `rsocial` VARCHAR(45) NOT NULL,
  `nfantasia` VARCHAR(45) NOT NULL,
  `contato_forn` VARCHAR(45) NOT NULL,
  `tel_forn` VARCHAR(45) NOT NULL,
  `email_forn` VARCHAR(45) NOT NULL,
  `cep_endereco` INT NOT NULL,
  PRIMARY KEY (`cnpj`),
  INDEX `fornecedor_endereco_idx` (`cep_endereco` ASC),
  CONSTRAINT `fornecedor_endereco`
    FOREIGN KEY (`cep_endereco`)
    REFERENCES `dbsimples`.`endereco` (`cep`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `dbsimples`.`usuario`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `dbsimples`.`usuario` ;

CREATE TABLE IF NOT EXISTS `dbsimples`.`usuario` (
  `id` INT NOT NULL,
  `usuario` VARCHAR(45) NOT NULL,
  `senha` VARCHAR(45) NOT NULL,
  `cpf_func` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `funcionario_user_idx` (`cpf_func` ASC),
  CONSTRAINT `funcionario_user`
    FOREIGN KEY (`cpf_func`)
    REFERENCES `dbsimples`.`funcionario` (`cpf_func`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `dbsimples`.`peca`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `dbsimples`.`peca` ;

CREATE TABLE IF NOT EXISTS `dbsimples`.`peca` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `descricao` VARCHAR(45) NOT NULL,
  `unidade` VARCHAR(45) NOT NULL,
  `valor` VARCHAR(45) NOT NULL,
  `cnpj` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `peca_forn_idx` (`cnpj` ASC),
  CONSTRAINT `peca_forn`
    FOREIGN KEY (`cnpj`)
    REFERENCES `dbsimples`.`fornecedor` (`cnpj`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `dbsimples`.`servico`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `dbsimples`.`servico` ;

CREATE TABLE IF NOT EXISTS `dbsimples`.`servico` (
  `id` INT NOT NULL,
  `descricao` VARCHAR(45) NOT NULL,
  `data` DATE NOT NULL,
  `hora` DATETIME NOT NULL,
  `tempo` DATETIME NOT NULL,
  `cpf_cli` INT NOT NULL,
  `cpf_func` INT NOT NULL,
  `id_peca` INT NOT NULL,
  `valor` DOUBLE NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `servico_cliente_idx` (`cpf_cli` ASC),
  INDEX `servico_func_idx` (`cpf_func` ASC),
  INDEX `servico_peca_idx` (`id_peca` ASC),
  CONSTRAINT `servico_cliente`
    FOREIGN KEY (`cpf_cli`)
    REFERENCES `dbsimples`.`cliente` (`cpf_cli`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `servico_func`
    FOREIGN KEY (`cpf_func`)
    REFERENCES `dbsimples`.`funcionario` (`cpf_func`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `servico_peca`
    FOREIGN KEY (`id_peca`)
    REFERENCES `dbsimples`.`peca` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `dbsimples`.`pecaservico`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `dbsimples`.`pecaservico` ;

CREATE TABLE IF NOT EXISTS `dbsimples`.`pecaservico` (
  `id` INT NOT NULL,
  `peca_id` INT NOT NULL,
  `servico_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `pecaservico_peca_idx` (`peca_id` ASC),
  INDEX `pecaservico_servico_idx` (`servico_id` ASC),
  CONSTRAINT `pecaservico_peca`
    FOREIGN KEY (`peca_id`)
    REFERENCES `dbsimples`.`peca` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `pecaservico_servico`
    FOREIGN KEY (`servico_id`)
    REFERENCES `dbsimples`.`servico` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
