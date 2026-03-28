CREATE OR REPLACE PROCEDURE Generer_Rapport_Performance_Agents (
    p_date_debut IN DATE,
    p_date_fin   IN DATE
)
AS
BEGIN
    FOR rec IN (
        SELECT a.NOM, a.PRENOM,
               SUM(c.MONTANT) AS TOTAL_COMMISSION
        FROM COMMISSION c
        JOIN AGENT_COMMERCIAL a ON c.ID_AGENT = a.ID_AGENT
        WHERE c.DATE_CALCUL BETWEEN p_date_debut AND p_date_fin
        GROUP BY a.NOM, a.PRENOM
        ORDER BY TOTAL_COMMISSION DESC
    )
    LOOP
        DBMS_OUTPUT.PUT_LINE(
            rec.NOM||' '||rec.PRENOM||
            ' -> Commission: '||rec.TOTAL_COMMISSION
        );
    END LOOP;
END;
/