-- Consulta per verificar que el preu mig dels components és correcte

SELECT 
    c.CM_CODI,
    c.CM_PREU_MIG AS preu_mig_guardat,
    (
        SELECT ROUND(AVG(pc.PC_PREU), 2)
        FROM PROV_COMP pc
        WHERE pc.PC_CM_IT_CODI = c.CM_CODI
    ) AS preu_mig_esperat
FROM COMPONENT c;
