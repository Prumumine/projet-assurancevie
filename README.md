# Projet Assurance BD  
PROJET-ASSURANCEVIE/
│
├── README.md
│
├── 01_security/
│   ├── 01_profiles.sql
│   ├── 02_roles.sql
│   ├── 03_users.sql
│
├── 02_schema/
│   ├── 01_tables.sql
│   ├── 02_indexes.sql
│   ├── 03_constraints.sql
│
├── 03_views/
│   ├── v_clients.sql
│   ├── v_souscriptions.sql
│   ├── v_paiements.sql
│
├── 04_procedures/
│   ├── clients/
│   │   ├── ajouter_client.sql
│   │   ├── modifier_client.sql
│   │   └── supprimer_client.sql
│   │
│   ├── souscriptions/
│   │   ├── ajouter_souscription.sql
│   │   └── modifier_statut_souscription.sql
│   │
│   ├── paiements/
│   │   ├── ajouter_paiement.sql
│   │   └── modifier_statut_paiement.sql
│   │
│   └── commissions/
│       └── calculer_commission.sql
│
├── 05_triggers/
│   ├── trg_date_fin.sql
│   ├── trg_verif_montant.sql
│   └── trg_calcul_commission.sql
│
├── 06_grants/
│   └── grants_procedures_views.sql
│
└── 07_tests/
    ├── test_clients.sql
    ├── test_souscriptions.sql
    └── test_paiements.sqloubien oracle le gere si oui comment l integre dnans notre systeme
