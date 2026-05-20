BEGIN
  -- Eliminar triggers
  FOR t IN (SELECT trigger_name FROM user_triggers) LOOP
    EXECUTE IMMEDIATE 'DROP TRIGGER "' || t.trigger_name || '"';
  END LOOP;

  -- Eliminar procedimientos
  FOR p IN (SELECT object_name FROM user_objects WHERE object_type = 'PROCEDURE') LOOP
    EXECUTE IMMEDIATE 'DROP PROCEDURE "' || p.object_name || '"';
  END LOOP;

  -- Eliminar tablas
  FOR tab IN (SELECT table_name FROM user_tables) LOOP
    EXECUTE IMMEDIATE 'DROP TABLE "' || tab.table_name || '" CASCADE CONSTRAINTS';
  END LOOP;
END;
/


CREATE SEQUENCE ITEM_SEQ 
START WITH 30000 
INCREMENT BY 1 
NOCACHE;

-- Crear las tablas necesarias

CREATE TABLE UNITAT_MESURA(
    CODI_MESURA NUMBER(5) PRIMARY KEY,
    NOM VARCHAR2(20) CONSTRAINT um_nn_nom NOT NULL
);

CREATE TABLE PROVINCIA(
    CODI_PROVINCIA NUMBER(5) PRIMARY KEY,
    NOM VARCHAR2(20) CONSTRAINT p_nn_nom NOT NULL
);

CREATE TABLE MUNICIPI(
    CODI_MUNICIPI NUMBER(5),
    NOM VARCHAR2(20) CONSTRAINT m_nn_nom NOT NULL,
    CODI_PROVINCIA NUMBER(5) CONSTRAINT m_fk_provincia REFERENCES PROVINCIA(CODI_PROVINCIA),
    CONSTRAINT pk_municipi PRIMARY KEY (CODI_MUNICIPI, CODI_PROVINCIA)
);

CREATE TABLE PROVEIDOR(
    PV_CODI NUMBER(5) PRIMARY KEY,
    PV_CIF VARCHAR2(9) CONSTRAINT pv_nn_cif NOT NULL,
    PV_RAO_SOCIAL VARCHAR2(50) CONSTRAINT pv_nn_rao_social NOT NULL,
    PV_LIN_ADRE_FAC VARCHAR2(50),
    PV_PERSONA_CONTACTE VARCHAR2(30),
    PV_TELEF_CONTACTE VARCHAR2(9),
    PV_CODI_MUNICIPI NUMBER(5) NOT NULL,
    PV_CODI_PROVINCIA NUMBER(5) NOT NULL,
    CONSTRAINT pv_uk_cif UNIQUE (PV_CIF),
    CONSTRAINT pv_fk_municipi FOREIGN KEY (PV_CODI_MUNICIPI, PV_CODI_PROVINCIA)
        REFERENCES MUNICIPI(CODI_MUNICIPI, CODI_PROVINCIA)
);

CREATE TABLE ITEM(
    IT_CODI NUMBER(5) PRIMARY KEY,
    IT_TIPUS CHAR(1) CONSTRAINT it_nn_tipus NOT NULL,
    IT_NOM VARCHAR2(30) CONSTRAINT it_nn_nom NOT NULL,
    IT_DESCRIPCIO VARCHAR2(50) CONSTRAINT it_nn_descripcio NOT NULL,
    IT_STOCK NUMBER(10) CONSTRAINT it_nn_stock NOT NULL,
    IT_FOTO BLOB,
    CONSTRAINT it_ck_tipus CHECK (IT_TIPUS IN ('C','P'))
);

CREATE TABLE PRODUCTE(
    PR_CODI NUMBER(5) PRIMARY KEY,
    CONSTRAINT pr_fk_codi FOREIGN KEY (PR_CODI) REFERENCES ITEM(IT_CODI)
);

CREATE TABLE COMPONENT (
    CM_CODI NUMBER(5) PRIMARY KEY,
    CM_UM_CODI NUMBER(5) CONSTRAINT cm_nn_codi NOT NULL,
    CM_CODI_FABRICANT VARCHAR2(20) CONSTRAINT cm_nn_fabricant NOT NULL,
    CM_PREU_MIG NUMBER(10,2) CONSTRAINT cm_nn_preu NOT NULL,
    CONSTRAINT cm_fk_mesura FOREIGN KEY (CM_UM_CODI) REFERENCES UNITAT_MESURA(CODI_MESURA),
    CONSTRAINT cm_fk_item FOREIGN KEY (CM_CODI) REFERENCES ITEM(IT_CODI)
);

CREATE TABLE PROV_COMP(
    PC_CM_IT_CODI NUMBER(5),
    PC_PV_CODI NUMBER(5),
    PC_PREU NUMBER(10,2) CONSTRAINT pc_nn_preu NOT NULL,
    CONSTRAINT pk_prov_comp PRIMARY KEY (PC_CM_IT_CODI, PC_PV_CODI),
    CONSTRAINT pc_chk_preu CHECK (PC_PREU > 0),
    CONSTRAINT pc_fk_codi_comp FOREIGN KEY (PC_CM_IT_CODI) REFERENCES COMPONENT(CM_CODI),
    CONSTRAINT pc_fk_codi_prov FOREIGN KEY (PC_PV_CODI) REFERENCES PROVEIDOR(PV_CODI)
);

CREATE TABLE PROD_ITEM(
    PI_PR_CODI NUMBER(5),
    PI_IT_CODI NUMBER(5),
    PI_QUANTITAT NUMBER(10) CONSTRAINT pi_nn_quantitat NOT NULL,
    CONSTRAINT pk_prod_item PRIMARY KEY (PI_PR_CODI, PI_IT_CODI),
    CONSTRAINT pi_fk_codi_prod FOREIGN KEY (PI_PR_CODI) REFERENCES PRODUCTE(PR_CODI),
    CONSTRAINT pi_fk_codi_item FOREIGN KEY (PI_IT_CODI) REFERENCES ITEM(IT_CODI),
    CONSTRAINT chk_quantitat CHECK (PI_QUANTITAT > 0),
    CONSTRAINT chk_codis_distints CHECK (pi_pr_codi <> pi_it_codi)
);

CREATE TABLE USUARI (
    USUARI_ID NUMBER(10) PRIMARY KEY,
    USUARI_NOM VARCHAR2(50) NOT NULL,
    USUARI_CONTRASENYA VARCHAR2(255) NOT NULL 
);

CREATE OR REPLACE FUNCTION GET_PREU_MIG(p_codi_component VARCHAR2)
RETURN NUMBER IS
  v_suma  NUMBER := 0;
  v_count NUMBER := 0;
BEGIN
  -- Calcular la suma de los precios y el número de proveedores para el componente
  FOR rec IN (SELECT PC_PREU FROM PROV_COMP WHERE PC_CM_IT_CODI = p_codi_component) LOOP
    v_suma  := v_suma + rec.PC_PREU;  -- Asegúrate de que 'PC_PREU' es el nombre correcto
    v_count := v_count + 1;
  END LOOP;

  -- Si no hay proveedores para el componente, devolver 0
  IF v_count = 0 THEN
    RETURN 0;
  ELSE
    -- Retornar el promedio de los precios
    RETURN v_suma / v_count;
  END IF;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RETURN 0;  -- Si no se encuentra ningún precio, devolver 0
END;
/

-- Trigger 1: Inicializa preu_mig a 0 al Insertar
CREATE OR REPLACE TRIGGER trg_component_bi_set_preu0
BEFORE INSERT ON COMPONENT
FOR EACH ROW
BEGIN
  :NEW.CM_PREU_MIG := 0;  -- Cambié 'preu_mig' por 'CM_PREU_MIG'
END;
/


-- Trigger 2: Prohibe cambios en preu_mig y codi (excepto en ALUMNE)
CREATE OR REPLACE TRIGGER trg_component_bu_prohibit_changes
BEFORE UPDATE ON COMPONENT
FOR EACH ROW
DECLARE
  v_user VARCHAR2(30);
BEGIN
  SELECT SYS_CONTEXT('USERENV', 'CURRENT_USER') INTO v_user FROM dual;

  IF v_user = 'ALUMNE' THEN
    NULL; -- Permite el cambio internamente
  ELSE
    -- Corregir los nombres de las columnas
    IF :NEW.CM_PREU_MIG != :OLD.CM_PREU_MIG THEN  -- 'preu_mig' a 'CM_PREU_MIG'
      RAISE_APPLICATION_ERROR(-20001, 'preu_mig no es pot modificar manualment');
    END IF;
    IF :NEW.CM_CODI != :OLD.CM_CODI THEN  -- 'codi' a 'CM_CODI'
      RAISE_APPLICATION_ERROR(-20002, 'No es pot canviar el codi (cm_it_codi)');
    END IF;
  END IF;
END;
/



-- Trigger 3: Bloquea cambios de claves en PROV_COMP
CREATE OR REPLACE TRIGGER trg_provcomp_bu_lock_keys
BEFORE UPDATE ON PROV_COMP
FOR EACH ROW
BEGIN
  -- Corregir los nombres de las columnas
  IF :NEW.PC_PV_CODI != :OLD.PC_PV_CODI THEN  -- 'pv_codi' a 'PC_PV_CODI'
    RAISE_APPLICATION_ERROR(-20003, 'No es pot modificar pv_codi a PROV_COMP');
  END IF;
  IF :NEW.PC_CM_IT_CODI != :OLD.PC_CM_IT_CODI THEN  -- 'cm_codi' a 'PC_CM_IT_CODI'
    RAISE_APPLICATION_ERROR(-20004, 'No es pot modificar cm_codi a PROV_COMP');
  END IF;
END;
/



-- Trigger 4: Recalcula el preu_mig al insertar/actualizar/eliminar en PROV_COMP
CREATE OR REPLACE TRIGGER trg_provcomp_aiud_recalc
AFTER INSERT OR UPDATE OR DELETE ON PROV_COMP
DECLARE
BEGIN
  -- Recalcular todos los precios de los componentes afectados
  UPDATE COMPONENT c
  SET CM_PREU_MIG = GET_PREU_MIG(c.CM_CODI)  -- Corregir 'PREU_MIG' por 'CM_PREU_MIG' y 'CODI' por 'CM_CODI'
  WHERE EXISTS (
    SELECT 1 FROM PROV_COMP p
    WHERE p.PC_CM_IT_CODI = c.CM_CODI  -- Corregir 'cm_codi' por 'PC_CM_IT_CODI'
  );

  -- Si el componente no tiene proveedor, lo dejamos con CM_PREU_MIG = 0
  UPDATE COMPONENT c
  SET CM_PREU_MIG = 0
  WHERE NOT EXISTS (
    SELECT 1 FROM PROV_COMP p
    WHERE p.PC_CM_IT_CODI = c.CM_CODI  -- Corregir 'cm_codi' por 'PC_CM_IT_CODI'
  );
END;
/
