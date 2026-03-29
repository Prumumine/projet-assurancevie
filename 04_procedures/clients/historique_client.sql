CREATE OR REPLACE PROCEDURE Historique_Client (
    p_id_client IN NUMBER
)
AS
BEGIN
    FOR rec IN (
        SELECT 
            c.NOM || ' ' || c.PRENOM AS CLIENT,
            c.TELEPHONE,
            s.ID_SOUSCRIPTION,
            p.NOM_PRODUIT,
            a.NOM || ' ' || a.PRENOM AS AGENT,
            s.STATUT,
            s.MONTANT_PRIME
        FROM SOUSCRIPTION s
        JOIN CLIENT c ON s.ID_CLIENT = c.ID_CLIENT
        JOIN PRODUIT p ON s.ID_PRODUIT = p.ID_PRODUIT
        JOIN AGENT_COMMERCIAL a ON s.ID_AGENT = a.ID_AGENT
        WHERE s.ID_CLIENT = p_id_client
    )
    LOOP
        DBMS_OUTPUT.PUT_LINE(
            'Client: '||rec.CLIENT||
            ' | Tel: '||rec.TELEPHONE||
            ' | Souscription: '||rec.ID_SOUSCRIPTION||
            ' | Produit: '||rec.NOM_PRODUIT||
            ' | Agent: '||rec.AGENT||
            ' | Statut: '||rec.STATUT||
            ' | Prime: '||rec.MONTANT_PRIME
        );
    END LOOP;
END;
/