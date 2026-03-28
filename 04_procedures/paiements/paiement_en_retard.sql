CREATE OR REPLACE PROCEDURE Rapport_Paiements_En_Retard
AS
BEGIN
    FOR rec IN (
        SELECT s.ID_SOUSCRIPTION, c.NOM, c.PRENOM
        FROM SOUSCRIPTION s
        JOIN CLIENT c ON s.ID_CLIENT = c.ID_CLIENT
        WHERE s.STATUT = 'ACTIVE'
          AND NOT EXISTS (
              SELECT 1 FROM PAIEMENT p
              WHERE p.ID_SOUSCRIPTION = s.ID_SOUSCRIPTION
              AND p.STATUT = 'VALIDE'
          )
    )
    LOOP
        DBMS_OUTPUT.PUT_LINE(
            'Retard -> Souscription: '||rec.ID_SOUSCRIPTION||
            ' | Client: '||rec.NOM||' '||rec.PRENOM
        );
    END LOOP;
END;
/