
--Ici les authentifications sont géres par oracle et les autorisations par les rôles, les profils sont utilisés pour définir les politiques de mot de passe et de session pour chaque type d'utilisateur.

-- Création utilisateur client
CREATE USER CLIENT IDENTIFIED BY Password123# PROFILE PROFIL_CLIENT;
GRANT ROLE_CLIENT TO CLIENT;

-- Création utilisateur agent
CREATE USER AGENT IDENTIFIED BY Password123# PROFILE PROFIL_AGENT;
GRANT ROLE_AGENT TO AGENT;

-- Création utilisateur gestionnaire
CREATE USER GESTIONNAIRE IDENTIFIED BY Password123# PROFILE PROFIL_GESTIONNAIRE;
GRANT ROLE_GESTIONNAIRE TO GESTIONNAIRE;

-- Création utilisateur administrateur
CREATE USER ADMIN IDENTIFIED BY Password123# PROFILE PROFIL_ADMIN;
GRANT ROLE_ADMIN TO ADMIN;

-- Compte applicatif front-end Ici l'authentification sera gerer par l'application client afin de determiner le role de chaque utilisateur

-- Compte applicatif front-end 
CREATE USER APP_CLIENT IDENTIFIED BY FrontendPass123# PROFILE PROFIL_APP;
GRANT ROLE_APP_CLIENT TO APP_CLIENT;
