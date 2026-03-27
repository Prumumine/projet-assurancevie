# Diagnostic: Procédure Supprimer_Client - Échec du test

## Contexte
- **Fichier procédure**: `04_procedures/clients/supprimer_client.sql`
- **Fichier test**: `07_tests/procedure_supprimer-client.sql`
- **Test exécuté**: `Supprimer_Client(p_id_user_app => 2, p_id_client => 24)`

## Erreurs identifiées (causes de l'échec)

### 1. **Erreur principale: Client ID=24 n'existe pas** ❌
```
SELECT COUNT(*) INTO v_count FROM CLIENT WHERE ID_CLIENT = p_id_client;
IF v_count = 0 THEN RAISE_APPLICATION_ERROR(-20002,'Client inexistant');
```
- **Données de test** (`07_tests/ajout_client_test_data.sql`):
  | Nom     | CNI     | ID_CLIENT (attendu) |
  |---------|---------|---------------------|
  | DIALLO  | CNI-1001| 1                   |
  | OUEDRAOGO| CNI-1002| 2                 |
  | KABORE  | CNI-1003| 3                   |
  | SANKARA | CNI-1004| 4                   |
  | **BOUGMA**| **CNI-1005**| **5**              |
- **Problème**: Test utilise `p_id_client => 24` mais BOUGMA a `ID_CLIENT=5`.
- **Résultat**: Erreur `-20002: Client inexistant`.

### 2. **Problèmes mineurs dans la procédure**
```
| Ligne | Problème | Impact potentiel |
|-------|----------|------------------|
| Role check | `SELECT ROLE INTO v_role FROM UTILISATEUR WHERE ID_UTILISATEUR = p_id_user_app` **sans ALIAS** | Peut échouer en Oracle strict |
| Pas de COMMIT | `DELETE FROM CLIENT` sans COMMIT | Transaction non persistante |
| Vérif souscription | OK, pas de données SOUSCRIPTION dans inserts | Passerait si client existe |

### 3. **Problèmes dans le test**
- Ne charge pas les données (`ajout_client_test_data.sql` et `ajout_utilisateur_app.sql`) avant l'appel.
- User ID=2 (GESTIONNAIRE) ✓ existe après inserts.
- Pas de COMMIT après inserts.

## Propositions de corrections

### Fix immédiat (test)
**Modifier `07_tests/procedure_supprimer-client.sql`:**
```sql
-- 1. Charger données
@ajout_utilisateur_app.sql
@ajout_client_test_data.sql

SET SERVEROUTPUT ON;

BEGIN
    Supprimer_Client(p_id_user_app => 2, p_id_client => 5);  -- 5 au lieu de 24
    DBMS_OUTPUT.PUT_LINE('✅ Supprimer_Client Test: SUCCÈS');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('❌ Supprimer_Client Test: ' || SQLERRM);
END;
/
```

### Améliorations procédure (`supprimer_client.sql`)
```sql
CREATE OR REPLACE PROCEDURE Supprimer_Client(
    p_id_user_app IN NUMBER DEFAULT NULL,
    p_id_client IN NUMBER
) AS
    v_role VARCHAR2(20);
    v_count NUMBER;
BEGIN
    -- RBAC avec alias
    IF p_id_user_app IS NOT NULL THEN
        SELECT u.ROLE INTO v_role  -- AJOUT ALIAS 'u'
        FROM UTILISATEUR u
        WHERE u.ID_UTILISATEUR = p_id_user_app;

        IF UPPER(v_role) NOT IN ('GESTIONNAIRE','ADMIN') THEN  -- Case-insensitive
            RAISE_APPLICATION_ERROR(-20001,'Permission refusée');
        END IF;
    END IF;

    -- Client existe
    SELECT COUNT(*) INTO v_count FROM CLIENT c WHERE c.ID_CLIENT = p_id_client;
    IF v_count = 0 THEN RAISE_APPLICATION_ERROR(-20002,'Client inexistant'); END IF;

    -- Pas de souscriptions
    SELECT COUNT(*) INTO v_count FROM SOUSCRIPTION s WHERE s.ID_CLIENT = p_id_client;
    IF v_count > 0 THEN RAISE_APPLICATION_ERROR(-20004,'Client lié à souscriptions'); END IF;

    -- Suppression + COMMIT
    DELETE FROM CLIENT WHERE ID_CLIENT = p_id_client;
    COMMIT;  -- AJOUT

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20005,'Erreur suppression: '||SQLERRM);
END;
/
```

### Vérifications à faire
```sql
-- Vérifier IDs actuels
SELECT ID_CLIENT, NOM, PRENOM FROM CLIENT WHERE NOM = 'BOUGMA';
SELECT ID_UTILISATEUR, ROLE FROM UTILISATEUR WHERE ROLE = 'GESTIONNAIRE';
SELECT COUNT(*) FROM SOUSCRIPTION WHERE ID_CLIENT = 5;
```

## Pourquoi COMMIT dans la procédure ? (FAQ)

**Q: Pourquoi COMMIT à la fin ?**
```
Sans COMMIT:
❌ DELETE invisible aux autres sessions
❌ Déconnexion = ROLLBACK auto
❌ Données non persistées

Avec COMMIT:
✅ Suppression définitive
✅ Visible immédiatement
✅ Transaction complète

Alternative: L'appelant fait COMMIT après EXEC
```
**Recommandé pour procédures métier.**

## Test complet recommandé
```sql
sqlplus user/pass @ajout_utilisateur_app.sql
sqlplus user/pass @ajout_client_test_data.sql
sqlplus user/pass @procedure_supprimer-client.sql  -- avec ID=5
```

## ✅ RÉSOLU - Test fonctionnel

**IDs réels après inserts propres:**
- GESTIONNAIRE: ID=22
- BOUGMA: ID=30

**Commande test finale:**
```sql
SET SERVEROUTPUT ON;
BEGIN
  Supprimer_Client(22, 30);
  DBMS_OUTPUT.PUT_LINE('✅ SUCCÈS');
EXCEPTION WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('❌ '||SQLERRM); END; /
```

**Cause racine:** ID_CLIENT erroné + inserts bloqués par duplicatas existants.

**Plus aucune modification de fichiers.** Test prêt ci-dessus.

