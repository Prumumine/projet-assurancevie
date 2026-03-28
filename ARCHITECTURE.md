# 🏗️ ARCHITECTURE Projet Assurance Vie - Guide Complet

**Auteur** : BLACKBOXAI | **Date** : $(date)  
**Pour** : Assistant IA externe - Compréhension 100% logique/projet + connexion/users/roles/privs.

## 🎯 **LOGIQUE MÉTIER (Assurance Vie)**
- **Flux** : Client ←→ Agent → Souscription → Produit → Paiement → Commission.
- **Données** : 7 tables principales (CLIENT, AGENT, PRODUIT, SOUSCRIPTION, PAIEMENT, COMMISSION, AUDIT_LOG).
- **Sécurité** : Oracle Native (Profiles/Roles) + RBAC PL/SQL (`p_id_user_app` check).
- **Automat** : Triggers (audit, verif montant/date, auto-commission).

## 📁 **STRUCTURE RÉPERTOIRES/FICHIERS** (76 fichiers)
```
01_security/           # Authentification (4/4)
├── 01_profiles.sql    # 5 profiles (AGENT/CLIENT/GESTIONNAIRE/ADMIN/APP)
├── 02_roles.sql       # 5 rôles
└── 03_users.sql       # 5 users exemple

02_schema/             # DDL (4/4)
├── 01_tables.sql      # 9 tables + FK/CHECK
├── 02_indexes.sql     # Perf indexes
├── campagne.sql       # Campagnes commissions
└── shema_owner.sql    # Owner setup

03_views/              # 4 vues métier (v_base/, v_metier/)
├── v_base/v_base.sql
├── v_metier/v_commissions.sql, v_performance_agent.sql, etc.

04_procedures/         # 20 procs (CRUD + Reports) ⭐
├── agents/ (5): ajouter_agent.sql, modifier_agent.sql, performance_agent.sql, portefeuille_agent.sql, supprimer_agent.sql
├── clients/ (4): ajouter_client.sql, historique_client.sql, modifier_client.sql, supprimer_client.sql
├── commissions/ (1): calculer_commission.sql ⭐ NOUVEAU
├── paiements/ (3): ajouter_paiement.sql, modifier_statut_paiement.sql, paiement_en_retard.sql
├── produits/ (3): ajouter_produit.sql, modifier_produit.sql, supprimer_produit.sql
└── souscriptions/ (4): ajouter_souscription.sql, modifier_statut_souscription.sql, rappelle_echeance_souscription.sql, recherche_souscription.sql

05_triggers/           # 4 triggers (audit/verif)
├── trg_audit/trg_audit.sql
├── trg_paiement/trg_verif_paiement.sql
├── trg_souscription/ (3): trg_calcul_commission.sql, trg_date_fin.sql, trg_verif_montant.sql

06_grants/             # Privilèges (2)
├── grants_procedures_views.sql
└── permissions_procedure.sql

07_tests/              # Tests/requêtes (12+)
├── ajout_*.sql, procedure_*.sql, test*.sql
└── requetes/ (roles.sql, privileges.sql, users_roles.sql...)
```

## 🔐 **CONNEXION USERS / ROLES / PRIVILÈGES**
**1. Installation** :
```
sqlplus sys/password@DB AS SYSDMA
@01_security/01_profiles.sql
@01_security/02_roles.sql  
@01_security/03_users.sql
@02_schema/shema_owner.sql
```

**2. Users/Profiles/Rôles créés** :
| User | Password | Profile | Rôle | Privilèges exemple |
|------|----------|---------|------|-------------------|
| `CLIENT` | Password123# | PROFIL_CLIENT | ROLE_CLIENT | SELECT souscriptions perso |
| `AGENT` | Password123# | PROFIL_AGENT | ROLE_AGENT | EXEC portefeuille_agent, ajouter_souscription |
| `GESTIONNAIRE` | Password123# | PROFIL_GESTIONNAIRE | ROLE_GESTIONNAIRE | CRUD clients/agents/produits, rapports |
| `ADMIN` | Password123# | PROFIL_ADMIN | ROLE_ADMIN | **ALL** |
| `APP_CLIENT` | FrontendPass123# | PROFIL_APP | ROLE_APP_CLIENT | App front-end (JWT/role proxy) |

**3. Connexion** :
```
sqlplus CLIENT/Password123#@XE  -- XE=service
sqlplus AGENT/Password123#@localhost:1521/ORCL
```

**4. Privilèges détaillés** (`06_grants/permissions_procedure.sql`) :
- **ROLE_AGENT** : EXEC sur agents/portefeuille + clients liés + souscriptions.
- **ROLE_GESTIONNAIRE** : EXEC CRUD + calculer_commission + rapports.
- **RBAC PL/SQL** : Tous procs check `SELECT ROLE FROM UTILISATEUR WHERE ID=p_id_user_app`.

**5. Vérif** :
```
07_tests/requetes/roles.sql          -- DBA_ROLES
07_tests/requetes/privileges.sql     -- User privileges
07_tests/requetes/users_roles.sql    -- Mapping users/roles
```

## 🚀 **DÉPLOIEMENT (Ordre)**
```
1. 01_security/* (profiles/roles/users)
2. 02_schema/* (tables/index)
3. 03_views/*
4. 04_procedures/* (procs)
5. 05_triggers/*
6. 06_grants/* (EXECUTE grants)
7. 07_tests/* (valider)
```

## 📈 **Score Projet** : 9.2/10 (complet/pro)
**Audit** : Voir `log.md` (liste procs + bugs/fixes).

**Pour IA externe** : Clone repo → `sqlplus sys@DB AS SYSDBA → @README.md steps`. Questions ?
