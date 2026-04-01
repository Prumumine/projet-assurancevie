CREATE OR REPLACE PROCEDURE Rechercher_Souscription (
    p_nom_client      IN VARCHAR2 DEFAULT NULL,
    p_num_identite    IN VARCHAR2 DEFAULT NULL,
    p_id_agent        IN NUMBER   DEFAULT NULL,
    p_numero_matricule IN VARCHAR2 DEFAULT NULL,
    p_statut          IN VARCHAR2 DEFAULT NULL
)
AS
BEGIN
    FOR rec IN (
        SELECT s.ID_SOUSCRIPTION,
               c.NOM, c.PRENOM,
               c.NUMERO_IDENTITE,
               s.STATUT,
               s.MONTANT_PRIME,
               a.NOM AS NOM_AGENT, a.PRENOM AS PRENOM_AGENT
        FROM SOUSCRIPTION s
        JOIN CLIENT c ON s.ID_CLIENT = c.ID_CLIENT
        JOIN AGENT_COMMERCIAL a ON s.ID_AGENT = a.ID_AGENT
        WHERE (p_nom_client IS NULL OR UPPER(c.NOM) LIKE '%'||UPPER(p_nom_client)||'%')
          AND (p_num_identite IS NULL OR c.NUMERO_IDENTITE = p_num_identite)
          AND (p_id_agent IS NULL OR s.ID_AGENT = p_id_agent)
          AND (p_numero_matricule IS NULL OR a.NUMERO_MATRICULE = p_numero_matricule)
          AND (p_statut IS NULL OR s.STATUT = p_statut)
    )
    LOOP
        DBMS_OUTPUT.PUT_LINE(
            'Souscription: '||rec.ID_SOUSCRIPTION||
            ' | Client: '||rec.NOM||' '||rec.PRENOM||
            ' | Agent: '||rec.NOM_AGENT||' '||rec.PRENOM_AGENT||
            ' | Prime: '||rec.MONTANT_PRIME||
            ' | Statut: '||rec.STATUT
        );
    END LOOP;
END;
/