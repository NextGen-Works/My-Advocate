import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/body_region.dart';
import '../models/pain_assessment.dart';
import '../models/api_settings.dart';
import '../utils/region_data.dart';
import '../utils/specialty_routing.dart';
import '../models/medical_specialty.dart';
import '../utils/api_service.dart';

class AppProvider extends ChangeNotifier {
  bool _showBackView = false;
  String? _selectedRegionId;
  final PainAssessment _assessment = PainAssessment();
  final ApiSettings _apiSettings = ApiSettings();
  String? _aiResponse;
  bool _isLoading = false;

  bool get showBackView => _showBackView;
  String? get selectedRegionId => _selectedRegionId;
  PainAssessment get assessment => _assessment;
  ApiSettings get apiSettings => _apiSettings;
  String? get aiResponse => _aiResponse;
  bool get isLoading => _isLoading;

  List<BodyRegion> get currentViewRegions =>
      _showBackView ? RegionData.backRegions : RegionData.frontRegions;

  BodyRegion? get selectedRegion =>
      _selectedRegionId != null ? RegionData.findById(_selectedRegionId!) : null;

  List<MedicalSpecialty> get routedSpecialties =>
      SpecialtyRouting.route(_assessment);

  void toggleView() {
    _showBackView = !_showBackView;
    _selectedRegionId = null;
    notifyListeners();
  }

  void selectRegion(String id) {
    _selectedRegionId = id;
    _assessment.selectedRegionId = id;
    final region = RegionData.findById(id);
    _assessment.selectedRegionName = region?.name ?? '';
    notifyListeners();
  }

  void setPainLevel(int level) {
    _assessment.intensity = level;
    if (_selectedRegionId != null) {
      final region = RegionData.findById(_selectedRegionId!);
      region?.painLevel = level;
    }
    notifyListeners();
  }

  void setPainCategory(String category) {
    _assessment.category = category;
    notifyListeners();
  }

  void toggleDescriptor(String descriptor) {
    if (_assessment.descriptors.contains(descriptor)) {
      _assessment.descriptors.remove(descriptor);
    } else {
      _assessment.descriptors.add(descriptor);
    }
    notifyListeners();
  }

  void setStartDate(DateTime? date) {
    _assessment.startDate = date;
    notifyListeners();
  }

  void setTrigger(String trigger) {
    _assessment.trigger = trigger;
    notifyListeners();
  }

  void setNotes(String notes) {
    _assessment.notes = notes;
    notifyListeners();
  }

  void setEndpoint(String endpoint) {
    _apiSettings.endpoint = endpoint;
    notifyListeners();
  }

  void setModelMapping(Map<String, String> mapping) {
    _apiSettings.modelMapping = mapping;
    notifyListeners();
  }

  void setModelForSpecialty(String specialtyId, String model) {
    _apiSettings.modelMapping[specialtyId] = model;
    notifyListeners();
  }

  Future<void> testApiConnection() async {
    final service = ApiService(_apiSettings);
    _apiSettings.connected = await service.testConnection();
    notifyListeners();
  }

  Future<void> getAiConsultation() async {
    _isLoading = true;
    _aiResponse = null;
    notifyListeners();

    final region = selectedRegion;
    final specialties = routedSpecialties;
    if (specialties.isEmpty) return;

    final prompt = _buildPrompt(region);
    final service = ApiService(_apiSettings);

    final response = await service.getChatResponse(
      specialtyId: specialties.first.id,
      prompt: prompt,
    );

    _aiResponse = response;
    _isLoading = false;
    notifyListeners();
  }

  String _buildPrompt(BodyRegion? region) {
    final buf = StringBuffer();
    buf.writeln('Patient reports pain in: ${region?.name ?? "Unknown"}');
    buf.writeln('Pain intensity: ${_assessment.intensity}/10');
    if (_assessment.category.isNotEmpty) {
      buf.writeln('Pain category: ${_assessment.category}');
    }
    if (_assessment.descriptors.isNotEmpty) {
      buf.writeln('Pain descriptors: ${_assessment.descriptors.join(", ")}');
    }
    if (_assessment.startDate != null) {
      buf.writeln('Pain started: $_assessment.startDate');
    }
    if (_assessment.trigger.isNotEmpty) {
      buf.writeln('Trigger/onset: ${_assessment.trigger}');
    }
    if (_assessment.notes.isNotEmpty) {
      buf.writeln('Additional notes: ${_assessment.notes}');
    }
    return buf.toString();
  }

  String generateReport() {
    final buf = StringBuffer();
    buf.writeln('MY ADVOCATE - PAIN ASSESSMENT REPORT');
    buf.writeln(StringBuffer()..writeAll(List.filled(40, '=')));
    buf.writeln('');
    buf.writeln('Body Region: ${_assessment.selectedRegionName}');
    buf.writeln('Pain Intensity: ${_assessment.intensity}/10');
    if (_assessment.category.isNotEmpty) {
      buf.writeln('Pain Category: ${_assessment.category}');
    }
    if (_assessment.descriptors.isNotEmpty) {
      buf.writeln('Pain Descriptors: ${_assessment.descriptors.join(", ")}');
    }
    if (_assessment.startDate != null) {
      buf.writeln('Started: ${_assessment.startDate!.toLocal().toString().split(' ')[0]}');
    }
    if (_assessment.trigger.isNotEmpty) {
      buf.writeln('Trigger: ${_assessment.trigger}');
    }
    if (_assessment.notes.isNotEmpty) {
      buf.writeln('Notes: ${_assessment.notes}');
    }
    buf.writeln('');
    buf.writeln('Recommended Specialties:');
    for (final spec in routedSpecialties) {
      buf.writeln('  - ${spec.name}');
    }
    buf.writeln('');
    if (_aiResponse != null) {
      buf.writeln('AI Consultation:');
      buf.writeln(_aiResponse);
      buf.writeln('');
    }
    buf.writeln(StringBuffer()..writeAll(List.filled(40, '-')));
    buf.writeln('Disclaimer: This is not medical advice.');
    buf.writeln('Please consult a qualified healthcare professional.');
    return buf.toString();
  }

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final endpoint = prefs.getString('api_endpoint');
    if (endpoint != null) _apiSettings.endpoint = endpoint;
    final mappingStr = prefs.getString('model_mapping');
    if (mappingStr != null) {
      _apiSettings.modelMapping = Map<String, String>.from(jsonDecode(mappingStr));
    }
    notifyListeners();
  }

  Future<void> saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('api_endpoint', _apiSettings.endpoint);
    await prefs.setString('model_mapping', jsonEncode(_apiSettings.modelMapping));
  }

  void clearAssessment() {
    _selectedRegionId = null;
    _aiResponse = null;
    _assessment.intensity = 0;
    _assessment.category = '';
    _assessment.descriptors.clear();
    _assessment.startDate = null;
    _assessment.trigger = '';
    _assessment.notes = '';
    _assessment.selectedRegionId = '';
    _assessment.selectedRegionName = '';
    for (final region in RegionData.allRegions) {
      region.painLevel = null;
    }
    notifyListeners();
  }
}
