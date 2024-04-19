class Constants {
  static const String appName = "Fumettologo";

  static const String addressStoreServer = "http://localhost:8081";
  static const String addressAuthenticationServer = "http://localhost:8080";

  static const String realm = "fumettologo";
  static const String clientId = "springboot-keycloak";
  static const String requestLogin = "/realms/$realm/protocol/openid-connect/token";
  static const String requestLogout = "/realms/$realm/protocol/openid-connect/logout";
}