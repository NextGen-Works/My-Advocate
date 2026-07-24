class ApiSettings {
  String endpoint;
  Map<String, String> modelMapping;
  bool connected;

  ApiSettings({
    this.endpoint = 'http://localhost:1234/v1',
    Map<String, String>? modelMapping,
    this.connected = false,
  }) : modelMapping = modelMapping ?? {};

  static const List<String> specialtyIds = [
    'primary_care', 'internal_medicine', 'orthopedics', 'rheumatology',
    'neurology', 'pain_medicine', 'gastroenterology', 'cardiology',
    'urology', 'gynecology', 'pmr', 'emergency', 'dermatology',
    'oncology', 'psychiatry', 'endocrinology', 'podiatry', 'dentistry',
    'pulmonology', 'general_surgery',
  ];

  Map<String, dynamic> toJson() => {
        'endpoint': endpoint,
        'modelMapping': modelMapping,
      };
}
