class AIPersonality {
  final bool empathetic;
  final bool authoritative;
  final bool supportive;
  final bool transparent;

  const AIPersonality({
    required this.empathetic,
    required this.authoritative,
    required this.supportive,
    required this.transparent,
  });
}

class AIAssistantConfig {
  static const bool enableVoiceInput = true;
  static const bool enableProactiveNotifications = true;

  // AI personality settings from design documentation
  static const AIPersonality personality = AIPersonality(
    empathetic: true,
    authoritative: true,
    supportive: true,
    transparent: true,
  );
}
