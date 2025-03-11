enum Flavors { dev, staging, prod}

class AppConfig {
  static Flavors? appFlavor;

  static String get baseUrl {
    switch (appFlavor) {
      case Flavors.dev:
        return 'https://dev.example.com';
      case Flavors.staging:
        return 'https://staging.example.com';
      case Flavors.prod:
        return 'https://prod.example.com';
      default:
        return 'https://prod.example.com';
    }
  }
}