CREATE OR REPLACE PROCEDURE Souscriptions_Proches_Echeance
AS
BEGIN
    FOR rec IN (
        SELECT 
            s.ID_SOUSCRIPTION,
            c.NOM || ' ' || c.PRENOM AS CLIENT,
            c.TELEPHONE,
            p.NOM_PRODUIT,
            a.NOM || ' ' || a.PRENOM AS AGENT,
            s.DATE_FIN
        FROM SOUSCRIPTION s
        JOIN CLIENT c ON s.ID_CLIENT = c.ID_CLIENT
        JOIN PRODUIT p ON s.ID_PRODUIT = p.ID_PRODUIT
        JOIN AGENT_COMMERCIAL a ON s.ID_AGENT = a.ID_AGENT
        WHERE s.DATE_FIN BETWEEN SYSDATE AND SYSDATE + 30
    )
    LOOP
        DBMS_OUTPUT.PUT_LINE(
            'Souscription: '||rec.ID_SOUSCRIPTION||
            ' | Client: '||rec.CLIENT||
            ' | Tel: '||rec.TELEPHONE||
            ' | Produit: '||rec.NOM_PRODUIT||
            ' | Agent: '||rec.AGENT||
            ' | Fin: '||TO_CHAR(rec.DATE_FIN,'YYYY-MM-DD')
        );
    END LOOP;
END;
/