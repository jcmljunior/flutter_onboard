// Classe responsável por atribuir o comportamento inicial da classe: Translate Manager.
class TranslateManagerConstant {
  // Define o idioma padrão a ser utilizado como referencia.
  // Importante o pacote do idioma padrão estar completo pois ele será utilizado
  // como referência para pacotes de idiomas incompleto.
  static const String defaultLanguage = 'en_US';

  // Lista de pacotes de idiomas disponíveis.
  static const List<String> defaultAvailableLanguages = [
    'en_US',
    'es_ES',
  ];

  // Inicialização das strings de idioma.
  static const Map<String, String> defaultLocalizedStrings = {};

  // Utilizado para validar se a tradução do idioma solicitado está completa.
  static const bool defaultIsFullyTranslated = false;

  static const String defaultAssetPath = 'resources/locales/';
}
