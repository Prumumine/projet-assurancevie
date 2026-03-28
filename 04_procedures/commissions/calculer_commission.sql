CREATE OR REPLACE PROCEDURE Calculer_Commissions(
    p_id_agent   IN NUMBER DEFAULT NULL,
    p_date_debut IN DATE,
    p_date_fin   IN DATE
) AS
    v_id_campagne NUMBER;
BEGIN
    -- Créer une nouvelle campagne
    INSERT INTO CAMPAGNE_COMMISSION (DATE_DEBUT, DATE_FIN, DATE_CALCUL, ID_AGENT)
    VALUES (p_date_debut, p_date_fin, SYSDATE, p_id_agent)
    RETURNING ID_CAMPAGNE INTO v_id_campagne;

    -- Calculer et insérer toutes les commissions pour cette campagne
    INSERT INTO COMMISSION (MONTANT, DATE_CALCUL, ID_AGENT, ID_SOUSCRIPTION, ID_CAMPAGNE)
    SELECT 
        s.MONTANT_PRIME * (p.TAUX_COMMISSION / 100),
        SYSDATE,
        s.ID_AGENT,
        s.ID_SOUSCRIPTION,
        v_id_campagne
    FROM SOUSCRIPTION s
    JOIN PRODUIT p   ON s.ID_PRODUIT = p.ID_PRODUIT
    JOIN PAIEMENT pay ON s.ID_SOUSCRIPTION = pay.ID_SOUSCRIPTION
    WHERE s.STATUT = 'ACTIVE'
      AND pay.STATUT = 'VALIDE'
      AND pay.DATE_PAIEMENT BETWEEN p_date_debut AND p_date_fin
      AND (p_id_agent IS NULL OR s.ID_AGENT = p_id_agent);

    DBMS_OUTPUT.PUT_LINE('Calcul terminé pour la campagne ID ' || v_id_campagne ||
                         ' pour la période ' || TO_CHAR(p_date_debut,'YYYY-MM-DD') ||
                         ' au ' || TO_CHAR(p_date_fin,'YYYY-MM-DD'));
EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20010, 'Erreur lors du calcul des commissions: ' || SQLERRM);
END;
/