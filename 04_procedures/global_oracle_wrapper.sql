CREATE OR REPLACE PROCEDURE Global_Execute_Proc_Oracle(
    p_procedure_name VARCHAR2,
    p_params CLOB DEFAULT NULL
)
AS
    v_current_user VARCHAR2(128) := USER;
    v_proc_stmt    VARCHAR2(4000);
    v_allowed      BOOLEAN := FALSE;
BEGIN
    -- =============================================
    -- Définition des droits par rôle
    -- =============================================
    CASE UPPER(p_procedure_name)
    
        -- ===== CLIENT =====
        WHEN 'AJOUTER_CLIENT' THEN
            v_allowed := (v_current_user IN ('CLIENT','AGENT','GESTIONNAIRE','ADMIN') OR USER_ROLE_EXISTS('ROLE_CLIENT'));
        WHEN 'MODIFIER_CLIENT' THEN
            v_allowed := (v_current_user IN ('AGENT','GESTIONNAIRE','ADMIN') OR USER_ROLE_EXISTS('ROLE_CLIENT') OR USER_ROLE_EXISTS('ROLE_AGENT'));
        WHEN 'HISTORIQUE_CLIENT' THEN
            v_allowed := TRUE;
        WHEN 'AJOUTER_SOUSCRIPTION' THEN
            v_allowed := TRUE;
        WHEN 'AJOUTER_PAIEMENT' THEN
            v_allowed := TRUE;

        -- ===== AGENT =====
        WHEN 'ETAT_PORTFEUILLE_AGENT' THEN
            v_allowed := (v_current_user IN ('AGENT','GESTIONNAIRE','ADMIN') OR USER_ROLE_EXISTS('ROLE_AGENT'));
        
        -- ===== GESTIONNAIRE =====
        WHEN 'AJOUTER_PRODUIT' THEN v_allowed := (v_current_user IN ('GESTIONNAIRE','ADMIN'));
        WHEN 'MODIFIER_PRODUIT' THEN v_allowed := (v_current_user IN ('GESTIONNAIRE','ADMIN'));
        WHEN 'SUPPRIMER_PRODUIT' THEN v_allowed := (v_current_user IN ('GESTIONNAIRE','ADMIN'));
        WHEN 'AJOUTER_AGENT' THEN v_allowed := (v_current_user IN ('GESTIONNAIRE','ADMIN'));
        WHEN 'MODIFIER_AGENT' THEN v_allowed := (v_current_user IN ('GESTIONNAIRE','ADMIN'));
        WHEN 'SUPPRIMER_AGENT' THEN v_allowed := (v_current_user IN ('GESTIONNAIRE','ADMIN'));
        WHEN 'MODIFIER_STATUT_SOUSCRIPTION' THEN v_allowed := (v_current_user IN ('GESTIONNAIRE','ADMIN'));
        WHEN 'RECHERCHER_SOUSCRIPTION' THEN v_allowed := (v_current_user IN ('GESTIONNAIRE','ADMIN'));
        WHEN 'SOUSCRIPTIONS_PROCHES_ECHEANCE' THEN v_allowed := (v_current_user IN ('GESTIONNAIRE','ADMIN'));
        WHEN 'SUPPRIMER_CLIENT' THEN v_allowed := (v_current_user IN ('GESTIONNAIRE','ADMIN'));
        WHEN 'MODIFIER_STATUT_PAIEMENT' THEN v_allowed := (v_current_user IN ('GESTIONNAIRE','ADMIN'));
        WHEN 'GENERER_RAPPORT_PERFORMANCE_AGENTS' THEN v_allowed := (v_current_user IN ('GESTIONNAIRE','ADMIN'));

        -- ===== ADMIN =====
        -- ADMIN peut tout faire, pas besoin de vérifier explicitement

        ELSE
            RAISE_APPLICATION_ERROR(-20099, 'Procédure ' || p_procedure_name || ' non configurée');
    END CASE;

    -- =============================================
    -- Exécution si autorisé
    -- =============================================
    IF v_allowed OR v_current_user = 'ADMIN' THEN
        -- Construction correcte de l’instruction PL/SQL
        IF p_params IS NOT NULL THEN
            v_proc_stmt := 'BEGIN ' || p_procedure_name || p_params || ' ; END;';
        ELSE
            v_proc_stmt := 'BEGIN ' || p_procedure_name || ' ; END;';
        END IF;

        EXECUTE IMMEDIATE v_proc_stmt;
    ELSE
        RAISE_APPLICATION_ERROR(
            -20010,
            '❌ Utilisateur [' || v_current_user || '] non autorisé à exécuter : ' || p_procedure_name
        );
    END IF;
END;
/