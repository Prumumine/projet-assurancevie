CREATE OR REPLACE PROCEDURE Etat_Portefeuille_Agent (
    p_id_agent IN NUMBER
)
AS
    v_nb   NUMBER;
    v_sum  NUMBER;
BEGIN
    SELECT COUNT(*), NVL(SUM(MONTANT_PRIME),0)
    INTO v_nb, v_sum
    FROM SOUSCRIPTION
    WHERE ID_AGENT = p_id_agent
      AND STATUT = 'ACTIVE';

    DBMS_OUTPUT.PUT_LINE('Contrats actifs: '||v_nb);
    DBMS_OUTPUT.PUT_LINE('Total primes: '||v_sum);
END;
/