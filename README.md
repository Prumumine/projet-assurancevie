# Projet Assurance Vie - Base de Données

Ce projet contient les scripts SQL pour la mise en place d'une base de données Oracle pour un système d'assurance vie.

## Structure du Projet

```
PROJET-ASSURANCEVIE/
│
├── README.md
│
├── 01_security/
│   ├── 01_profiles.sql
│   ├── 02_roles.sql
│   └── 03_users.sql
│
├── 02_schema/
│   ├── 01_tables.sql
│   ├── 02_indexes.sql
│   └── 03_constraints.sql
│
├── 03_views/
│   ├── v_clients.sql
│   ├── v_souscriptions.sql
│   └── v_paiements.sql
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
    └── test_paiements.sql
```

## Prérequis

- Oracle Database
- SQL*Plus ou SQLcl pour l'exécution des scripts

## Installation

1. Connectez-vous à votre base de données Oracle.
2. Exécutez les scripts dans l'ordre des dossiers (01_security, puis 02_schema, etc.).
3. Commencez par les scripts de sécurité, puis le schéma, les vues, procédures, triggers, grants et enfin les tests.

## Utilisation

Après l'installation, vous pouvez utiliser les procédures stockées pour gérer les clients, souscriptions et paiements.

## Tests

Les scripts de test dans le dossier `07_tests/` permettent de vérifier le bon fonctionnement du système.
