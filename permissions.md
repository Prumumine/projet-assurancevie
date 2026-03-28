# 🔐 PERMISSIONS - Procédures & Vues (Système Assurance Vie PRO)

**Logique** : Permissions basées sur métier assurance vie :
- **ROLE_CLIENT** : Consultation perso.
- **ROLE_AGENT** : Portfolio/clients/souscrip/propres commissions.
- **ROLE_GESTIONNAIRE** : CRUD/gestion/reports.
- **ROLE_ADMIN** : Tout.
- **ROLE_APP_CLIENT** : App front (tous EXECUTE).

## 📋 **GRANT EXECUTE sur PROCÉDURES** (20+)

| Procédure | Dossier/Fichier | ROLE_CLIENT | ROLE_AGENT | ROLE_GESTIONNAIRE | ROLE_ADMIN | ROLE_APP | **Raison métier** |
|-----------|-----------------|-------------|------------|-------------------|------------|----------|-------------------|
| Ajouter_Client | clients/ajouter_client.sql | ❌ | ⚠️ | ✅ | ✅ | App | Gestionnaire crée clients |
| Modifier_Client | clients/modifier_client.sql | ❌ | ✅ (liés) | ✅ | ✅ | App | Agent modifie ses clients |
| Supprimer_Client | clients/supprimer_client.sql | ❌ | ❌ | ✅ | ✅ | App | Admin seulement (cascade) |
| Historique_Client | clients/historique_client.sql | ✅ (perso) | ✅ | ✅ | ✅ | App | Consultation |
| **Ajout/modif/suppr Agent** | agents/*.sql | ❌ | ❌ | ✅ | ✅ | App | RH/Gestionnaire |
| Portefeuille_Agent | agents/portefeuille_agent.sql | ❌ | ✅ (self) | ✅ | ✅ | App | Agent voit son portefeuille |
| Performance_Agent | agents/performance_agent.sql | ❌ | ✅ | ✅ | ✅ | App | Rapport perf |
| **Ajout/modif/suppr Produit** | produits/*.sql | ❌ | ❌ | ✅ | ✅ | App | Catalogue mgmt |
| **CRUD Paiement** | paiements/ajouter_*.sql | ✅ (self) | ✅ | ✅ | ✅ | App | Paiements clients/agents |
| Paiement_En_Retard | paiements/paiement_en_retard.sql | ❌ | ✅ | ✅ | ✅ | App | Recouvrement |
| **CRUD Souscription** | souscriptions/ajouter_*.sql | ✅ (self) | ✅ | ✅ | ✅ | App | Cœur métier |
| Recherche_Souscription | souscriptions/recherche_souscription.sql | ✅ | ✅ | ✅ | ✅ | App | Recherche |
| Rappelle_Echeance | souscriptions/rappelle_echeance_souscription.sql | ❌ | ✅ | ✅ | ✅ | App | Notification |
| **Calculer_Commissions** | commissions/calculer_commission.sql | ❌ | ⚠️ | ✅ | ✅ | App | Batch mensuel |

**Script GRANT** (`06_grants/grants_procedures.sql`) :
```
-- AGENT
GRANT EXECUTE ON portefeuille_agent TO ROLE_AGENT;
GRANT EXECUTE ON performance_agent TO ROLE_AGENT;
GRANT EXECUTE ON recherche_souscription TO ROLE_AGENT;

-- GESTIONNAIRE
GRANT EXECUTE ON ajouter_client TO ROLE_GESTIONNAIRE;
GRANT EXECUTE ON calculer_commission TO ROLE_GESTIONNAIRE;
-- etc.

-- ADMIN/APP
GRANT EXECUTE ON 04_procedures.* TO ROLE_ADMIN, ROLE_APP_CLIENT;
```

## 👁️ **GRANT SELECT sur VUES** (03_views/)

| Vue | Dossier | ROLE_CLIENT | ROLE_AGENT | ROLE_GESTIONNAIRE | ROLE_ADMIN | **Raison** |
|-----|---------|-------------|------------|-------------------|------------|------------|
| v_base | v_base/v_base.sql | ✅ | ✅ | ✅ | ✅ | Données de base |
| v_commissions | v_metier/ | ❌ | ✅ | ✅ | ✅ | Rapports commissions |
| v_performance_agent | v_metier/ | ❌ | ✅ (self) | ✅ | ✅ | KPI agents |
| v_souscription_detail | v_metier/ | ✅ (self) | ✅ | ✅ | ✅ | Détails polices |
| v_stat_produit | v_metier/ | ❌ | ❌ | ✅ | ✅ | Stats produits |

**Script** :
```
GRANT SELECT ON v_performance_agent TO ROLE_AGENT, ROLE_GESTIONNAIRE;
GRANT SELECT ON v_base TO ALL_ROLES;
```

## ✅ **Vérification** (07_tests/requetes/)
- `roles.sql`, `privileges.sql` : Check post-grant.

**Déploiement** : `@06_grants/permissions_procedure.sql` après procs/vues.

*Permissions validées BLACKBOXAI - Métier assurance vie*
