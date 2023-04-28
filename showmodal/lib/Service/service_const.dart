//
//
//
//
//
class ServiceConst {
  static String OFFRE_STATUS_ACCEPTED = 'accepted';
  static String OFFRE_STATUS_REFUSED = 'refused';
  static String RoleAdherent = 'Adherent';
  static String RolePartenaire = 'Partenaire';
  static String RoleBoth = 'Adherent Partenaire';

  /// Global Url
   static String globalUrl = "http://10.0.2.2:8000/api";
 // static String globalUrl = "http://192.168.100.187:8000/api";

  // static String globalUrl =                            "192.168.100.44";

  /// Authentication
  static String Auth = '/auth';

  static String logIn = '/login';
  static String logOut = '/logout';
  static String resetPassword = '/reset-password';

  /// Offre api
  static String Offre = '/offre/';
  static String getOffersById = '/';
}
