// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get dashboard => 'Tableau de bord';

  @override
  String get login => 'Connexion';

  @override
  String get logout => 'Déconnexion';

  @override
  String get settings => 'PARAMÈTRES';

  @override
  String get darkMode => 'Mode sombre';

  @override
  String get currentThemeDark => 'Thème actuel : sombre';

  @override
  String get currentThemeLight => 'Thème actuel : clair';

  @override
  String get language => 'Langue';

  @override
  String get english => 'Anglais';

  @override
  String get french => 'Français';

  @override
  String get me => 'MOI';

  @override
  String get modify => 'Modifier';

  @override
  String get successful => 'avec succés';

  @override
  String get delete => 'Supprimer';

  @override
  String get clockin => 'POINTAGE ARRIVÉE';

  @override
  String get clockout => 'POINTAGE SORTIE';

  @override
  String get validate => 'Valider';

  @override
  String get arrival => 'Heure d\'arrivée';

  @override
  String get registerTitle => 'Créer un utilisateur';

  @override
  String get welcome => 'Bienvenue';

  @override
  String get teams => 'Équipes';

  @override
  String get team => 'Équipe';

  @override
  String get teamDetails => 'Détails de l\'équipe';

  @override
  String get reports => 'Rapports';

  @override
  String get kpiTitle => 'Indicateurs de performance';

  @override
  String get loading => 'Chargement...';

  @override
  String get error => 'Une erreur est survenue';

  @override
  String get emailLabel => 'Adresse e-mail';

  @override
  String get passwordLabel => 'Mot de passe';

  @override
  String get userNameLabel => 'Nom d\'utilisateur';

  @override
  String get firstNameLabel => 'Prénom';

  @override
  String get phoneNumberLabel => 'Numéro de téléphone';

  @override
  String get lastNameLabel => 'Nom';

  @override
  String get loginButton => 'Se connecter';

  @override
  String get registerButton => 'Créer';

  @override
  String get emailRequired => 'L\'adresse e-mail est obligatoire';

  @override
  String get invalidEmail => 'Adresse e-mail invalide';

  @override
  String get passwordRequired => 'Le mot de passe est obligatoire';

  @override
  String get shortPassword => 'Le mot de passe doit comporter au moins 6 caractères';

  @override
  String get fieldRequired => 'Le champ ne peut pas être vide';

  @override
  String get departure => 'Heure de départ';

  @override
  String get badRequest => 'Requête invalide (400)';

  @override
  String get unauthorized => 'Accès non autorisé (401)';

  @override
  String get notFound => 'Ressource non trouvée (404)';

  @override
  String get serverError => 'Erreur du serveur (500)';

  @override
  String get forgotPassword => 'Mot de passe oublié ?';

  @override
  String get management => 'GESTION';

  @override
  String get addanewuser => 'Nouvel utilisateur';

  @override
  String get addanewteam => 'Nouvelle équipe';

  @override
  String get searchbarhint => 'Utilisateur ou équipe...';

  @override
  String networkError(int code) {
    return 'Erreur réseau ($code)';
  }

  @override
  String fieldIsRequired(String field) {
    return 'Le champ \'$field\' est obligatoire.';
  }

  @override
  String get toggleThemeHint => 'Active ou désactive le mode sombre';

  @override
  String get languageSelectionHint => 'Choisir la langue de l’application';

  @override
  String get accessibilityInfo => 'Ces paramètres améliorent l’accessibilité et la lisibilité pour tous les utilisateurs.';

  @override
  String get invalidPhoneNumber => 'Numéro de téléphone invalide';

  @override
  String get phoneNumberRequired => 'Le numéro de téléphone est requis';

  @override
  String get phoneFormatHint => 'Exemple : +33 6 12 34 56 78';

  @override
  String get teamManagement => 'TEAM MANAGEMENT';

  @override
  String get teamHintName => 'Veuillez reneseigner un nom de team';

  @override
  String get createTeam => 'Créer team';

  @override
  String get teamNameLabel => 'Nom :';

  @override
  String get teamDescriptionLabel => 'Description : ';

  @override
  String get teamNoMember => 'Aucun membre';

  @override
  String get cancel => 'Stop';

  @override
  String get addMembers => 'Ajoutez des membres';

  @override
  String get calendar => 'Calendrier';

  @override
  String get loadingProfile => 'Chargement de votre profil...';

  @override
  String get day => 'Jour';

  @override
  String get week => 'Semaine';

  @override
  String get month => 'Mois';

  @override
  String get year => 'Année';

  @override
  String get retry => 'Réessayer';

  @override
  String get work => 'Travail';

  @override
  String get hours => 'Heures';

  @override
  String get weekly => 'Hebdomadaire';

  @override
  String get monthly => 'Mensuel';

  @override
  String get yearly => 'Annuel';

  @override
  String get dashboardLoading => 'Chargement du dashboard...';

  @override
  String get planningCalendar => 'Calendrier de planning';

  @override
  String get planning => 'Planning';

  @override
  String get noPlanningForToday => 'No schedule for today';

  @override
  String get planningWeekly => 'Weekly schedule';

  @override
  String get noConfigPlanning => 'No schedule configured';

  @override
  String get planningLoading => 'Chargement du planning...';

  @override
  String get monday => 'Lundi';

  @override
  String get tuesday => 'Mardi';

  @override
  String get wednesday => 'Mercredi';

  @override
  String get thursday => 'Jeudi';

  @override
  String get friday => 'Friday';

  @override
  String get saturday => 'Saturday';

  @override
  String get sunday => 'Sunday';

  @override
  String get january => 'Janvier';

  @override
  String get february => 'Fevrier';

  @override
  String get march => 'Mars';

  @override
  String get april => 'Avril';

  @override
  String get may => 'Mai';

  @override
  String get june => 'Juin';

  @override
  String get july => 'Juillet';

  @override
  String get august => 'Août';

  @override
  String get september => 'Septembre';

  @override
  String get october => 'Octobre';

  @override
  String get november => 'Novembre';

  @override
  String get december => 'Décembre';
}
