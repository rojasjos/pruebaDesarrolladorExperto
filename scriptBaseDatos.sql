-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`Cliente`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Cliente` (
  `idCliente` INT NOT NULL,
  `primerNombre` VARCHAR(45) NULL,
  `segundoNombre` VARCHAR(45) NULL,
  `primerApellido` VARCHAR(45) NULL,
  `segundoApellido` VARCHAR(45) NULL,
  `tipoDocumento` VARCHAR(45) NULL,
  `numDocumento` VARCHAR(45) NULL,
  `celular` VARCHAR(45) NULL,
  `direccion` VARCHAR(45) NULL,
  `correo` VARCHAR(45) NULL,
  `estado` VARCHAR(45) NULL,
  PRIMARY KEY (`idCliente`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Mecanico`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Mecanico` (
  `idMecanico` INT NOT NULL,
  `primerNombre` VARCHAR(45) NULL,
  `segundoNombre` VARCHAR(45) NULL,
  `primerApellido` VARCHAR(45) NULL,
  `segundoApellido` VARCHAR(45) NULL,
  `tipoDocumento` VARCHAR(45) NULL,
  `numDocumento` VARCHAR(45) NULL,
  `celular` VARCHAR(45) NULL,
  `direccion` VARCHAR(45) NULL,
  `correo` VARCHAR(45) NULL,
  `estado` VARCHAR(45) NULL,
  PRIMARY KEY (`idMecanico`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`factura`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`factura` (
  `idfactura` INT NOT NULL,
  `fecha` DATE NULL,
  `Cliente_idCliente` INT NOT NULL,
  PRIMARY KEY (`idfactura`),
  INDEX `fk_factura_Cliente1_idx` (`Cliente_idCliente` ASC) VISIBLE,
  CONSTRAINT `fk_factura_Cliente1`
    FOREIGN KEY (`Cliente_idCliente`)
    REFERENCES `mydb`.`Cliente` (`idCliente`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Repuesto`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Repuesto` (
  `idRepuesto` INT NOT NULL,
  `precioUnitario` DOUBLE NULL,
  `unidades` VARCHAR(45) NULL,
  `descuento` DOUBLE NULL,
  PRIMARY KEY (`idRepuesto`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Servicio`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Servicio` (
  `idServicio` INT NOT NULL,
  `precioManoObra` DOUBLE NULL,
  `descuento` DOUBLE NULL,
  `factura_idfactura` INT NOT NULL,
  `Repuesto_idRepuesto` INT NOT NULL,
  PRIMARY KEY (`idServicio`),
  INDEX `fk_Servicio_factura1_idx` (`factura_idfactura` ASC) VISIBLE,
  INDEX `fk_Servicio_Repuesto1_idx` (`Repuesto_idRepuesto` ASC) VISIBLE,
  CONSTRAINT `fk_Servicio_factura1`
    FOREIGN KEY (`factura_idfactura`)
    REFERENCES `mydb`.`factura` (`idfactura`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Servicio_Repuesto1`
    FOREIGN KEY (`Repuesto_idRepuesto`)
    REFERENCES `mydb`.`Repuesto` (`idRepuesto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Vehiculo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Vehiculo` (
  `idVehiculo` INT NOT NULL,
  `marca` VARCHAR(45) NULL,
  `color` VARCHAR(45) NULL,
  `modelo` VARCHAR(45) NULL,
  `placa` VARCHAR(45) NULL,
  `Cliente_idCliente` INT NOT NULL,
  `Mecanico_idMecanico` INT NOT NULL,
  PRIMARY KEY (`idVehiculo`),
  INDEX `fk_Vehiculo_Cliente_idx` (`Cliente_idCliente` ASC) VISIBLE,
  INDEX `fk_Vehiculo_Mecanico1_idx` (`Mecanico_idMecanico` ASC) VISIBLE,
  CONSTRAINT `fk_Vehiculo_Cliente`
    FOREIGN KEY (`Cliente_idCliente`)
    REFERENCES `mydb`.`Cliente` (`idCliente`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Vehiculo_Mecanico1`
    FOREIGN KEY (`Mecanico_idMecanico`)
    REFERENCES `mydb`.`Mecanico` (`idMecanico`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;


-- Consultas 
select c.* from cliente c inner join factura f on c.idCliente = f.Cliente_idCliente 
where f.total > 100000 and f.fechafactura < (sysdate() - 60);

select r.* from repuestos r inner join servicios s on r.Servicios_idServicios = s.idServicios
inner join factura f on s.factura_idFactura = f.idfactura where r.numUnidades > 100 and 
f.fechafactura < (sysdate() - 30);

select f.tiendas from factura f  inner 
join servicios s on s.factura_idfactura = f.idFactura inner 
join repuestos r on r.Servicios_idServicios = s.idServicios 
where r.idRepuestos = 100 and r.numUnidades > 100  and f.fechaFactura < (sysdate() - 60) ;

select * from cliente c inner join factura f on c.idCliente = f.Cliente_idCliente 
where f.fechaFactura < (sysdate() - 30);

-- Procedimiento
Create  Trigger TRIG_UNIDADES_INVENT after insert on repuestos 
for each row set new.totalunidades =  new.totalUnidades - new.numUnidades;
 