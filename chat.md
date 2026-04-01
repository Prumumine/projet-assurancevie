# Liste des procédures à tester (sécurité via Global_Execute_Proc_Oracle depuis CLIENT non autorisé)

## Agents:
- AJOUTER_AGENT (test_ajout.sql)
- MODIFIER_AGENT (test_modifier_agent_security.sql)
- SUPPRIMER_AGENT (test_supprimer_agent.sql)
- PERFORMANCE_AGENT (test_performance_agent.sql)
- PORTFEUILLE_AGENT / ETAT_PORTFEUILLE_AGENT (test_portefeuille_agent.sql)

## Clients:
- AJOUTER_CLIENT (test_ajouter_client.sql)
- MODIFIER_CLIENT (test_modifier_client.sql)
- SUPPRIMER_CLIENT (test_supprimer_client.sql)
- HISTORIQUE_CLIENT (test_historique_client.sql)

## Produits:
- AJOUTER_PRODUIT (test_ajouter_produit.sql)
- MODIFIER_PRODUIT (test_modifier_produit.sql)
- SUPPRIMER_PRODUIT (test_supprimer_produit.sql)

## Souscriptions:
- AJOUTER_SOUSCRIPTION (test_ajouter_souscription.sql)
- MODIFIER_STATUT_SOUSCRIPTION (test_modifier_statut_souscription.sql)
- RECHERCHER_SOUSCRIPTION (test_rechercher_souscription.sql)
- SOUSCRIPTIONS_PROCHES_ECHEANCE (test_souscriptions_proches_echeance.sql)

## Paiements:
- AJOUTER_PAIEMENT (test_ajouter_paiement.sql)
- MODIFIER_STATUT_PAIEMENT (test_modifier_statut_paiement.sql)
- RAPPORT_PAIEMENTS_EN_RETARD (test_rapport_paiements_en_retard.sql)

## Commissions:
- CALCULER_COMMISSIONS (test_calculer_commissions.sql)

Tous les tests créés avec succès ! Exécuter comme CLIENT user pour vérifier les erreurs d'autorisation.

