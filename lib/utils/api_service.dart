import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/api_settings.dart';

class ApiService {
  final ApiSettings settings;

  ApiService(this.settings);

  Future<bool> testConnection() async {
    try {
      final response = await http
          .get(Uri.parse('${settings.endpoint}/models'))
          .timeout(const Duration(seconds: 10));
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  Future<String?> getChatResponse({
    required String specialtyId,
    required String prompt,
  }) async {
    try {
      final model = settings.modelMapping[specialtyId] ?? 'default';

      final body = jsonEncode({
        'model': model,
        'messages': [
          {
            'role': 'system',
            'content': _getSystemPrompt(specialtyId),
          },
          {
            'role': 'user',
            'content': prompt,
          },
        ],
        'temperature': 0.3,
        'max_tokens': 1024,
      });

      final response = await http
          .post(
            Uri.parse('${settings.endpoint}/chat/completions'),
            headers: {'Content-Type': 'application/json'},
            body: body,
          )
          .timeout(const Duration(seconds: 60));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices']?[0]?['message']?['content'] as String?;
      }
      return null;
    } catch (e) {
      return 'Error: ${e.toString()}';
    }
  }

  String _getSystemPrompt(String specialtyId) {
    final specialty = _getSpecialtyName(specialtyId);
    return '''
You are a $specialty specialist providing a brief consultation.
Based on the patient's pain assessment, provide:
1. A brief analysis of the reported symptoms
2. Possible conditions to consider
3. Recommended next steps
4. Red flags or warning signs to watch for

Remember: This is for informational purposes only and does not constitute medical advice.
Keep your response concise and focused on the specialty area.
''';
  }

  String _getSpecialtyName(String id) {
    const names = {
      'primary_care': 'Primary Care',
      'internal_medicine': 'Internal Medicine',
      'orthopedics': 'Orthopedics',
      'rheumatology': 'Rheumatology',
      'neurology': 'Neurology',
      'pain_medicine': 'Pain Medicine',
      'gastroenterology': 'Gastroenterology',
      'cardiology': 'Cardiology',
      'urology': 'Urology',
      'gynecology': 'Gynecology',
      'pmr': 'Physical Medicine & Rehabilitation',
      'emergency': 'Emergency Medicine',
      'dermatology': 'Dermatology',
      'oncology': 'Oncology',
      'psychiatry': 'Psychiatry',
      'endocrinology': 'Endocrinology',
      'podiatry': 'Podiatry',
      'dentistry': 'Dentistry',
      'pulmonology': 'Pulmonology',
      'general_surgery': 'General Surgery',
    };
    return names[id] ?? 'Medical';
  }
}
