CREATE OR REPLACE PROCEDURE Generer_Rapport_Performance_Agents
AS
BEGIN
    FOR rec IN (
        SELECT CODE_AGENT,
               NOM,
               PRENOM,
               NB_VENTES,
               CHIFFRE_AFFAIRE
        FROM V_PERFORMANCE_AGENT
        ORDER BY CHIFFRE_AFFAIRE DESC
    )
    LOOP
        DBMS_OUTPUT.PUT_LINE(
            'Agent : ' || rec.CODE_AGENT || ' - ' ||
            rec.NOM || ' ' || rec.PRENOM ||
            ' | Ventes : ' || rec.NB_VENTES ||
            ' | Chiffre : ' || rec.CHIFFRE_AFFAIRE
        );
    END LOOP;
END;
/