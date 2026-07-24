class MedicalSpecialty {
  final String id;
  final String name;
  final String description;
  final List<String> commonPainTypes;

  const MedicalSpecialty({
    required this.id,
    required this.name,
    required this.description,
    required this.commonPainTypes,
  });

  static const List<MedicalSpecialty> all = [
    MedicalSpecialty(
      id: 'primary_care',
      name: 'Primary Care',
      description: 'General health concerns, first point of contact',
      commonPainTypes: ['General pain', 'Minor injuries', 'Common illnesses'],
    ),
    MedicalSpecialty(
      id: 'internal_medicine',
      name: 'Internal Medicine',
      description: 'Complex medical conditions affecting internal organs',
      commonPainTypes: ['Chest pain', 'Abdominal pain', 'Systemic symptoms'],
    ),
    MedicalSpecialty(
      id: 'orthopedics',
      name: 'Orthopedics',
      description: 'Musculoskeletal system - bones, joints, ligaments, tendons',
      commonPainTypes: ['Joint pain', 'Fractures', 'Back pain', 'Sports injuries'],
    ),
    MedicalSpecialty(
      id: 'rheumatology',
      name: 'Rheumatology',
      description: 'Autoimmune and inflammatory conditions',
      commonPainTypes: ['Joint swelling', 'Morning stiffness', 'Widespread pain'],
    ),
    MedicalSpecialty(
      id: 'neurology',
      name: 'Neurology',
      description: 'Nervous system - brain, spinal cord, nerves',
      commonPainTypes: ['Headaches', 'Neuropathic pain', 'Nerve pain', 'Dizziness'],
    ),
    MedicalSpecialty(
      id: 'pain_medicine',
      name: 'Pain Medicine',
      description: 'Specialized pain management for chronic conditions',
      commonPainTypes: ['Chronic pain', 'Complex pain', 'Treatment-resistant pain'],
    ),
    MedicalSpecialty(
      id: 'gastroenterology',
      name: 'Gastroenterology',
      description: 'Digestive system - stomach, intestines, liver, pancreas',
      commonPainTypes: ['Abdominal pain', 'Bloating', 'Digestive issues'],
    ),
    MedicalSpecialty(
      id: 'cardiology',
      name: 'Cardiology',
      description: 'Heart and cardiovascular system',
      commonPainTypes: ['Chest pain', 'Palpitations', 'Shortness of breath'],
    ),
    MedicalSpecialty(
      id: 'urology',
      name: 'Urology',
      description: 'Urinary tract and male reproductive system',
      commonPainTypes: ['Flank pain', 'Urinary issues', 'Pelvic pain'],
    ),
    MedicalSpecialty(
      id: 'gynecology',
      name: 'Gynecology',
      description: 'Female reproductive system',
      commonPainTypes: ['Pelvic pain', 'Menstrual pain', 'Vaginal discomfort'],
    ),
    MedicalSpecialty(
      id: 'pmr',
      name: 'PM&R',
      description: 'Physical Medicine & Rehabilitation',
      commonPainTypes: ['Rehabilitation', 'Functional impairment', 'Muscle weakness'],
    ),
    MedicalSpecialty(
      id: 'emergency',
      name: 'Emergency Medicine',
      description: 'Acute, life-threatening conditions requiring immediate care',
      commonPainTypes: ['Severe acute pain', 'Trauma', 'Emergency symptoms'],
    ),
    MedicalSpecialty(
      id: 'dermatology',
      name: 'Dermatology',
      description: 'Skin, hair, and nails',
      commonPainTypes: ['Skin pain', 'Rash', 'Lesions'],
    ),
    MedicalSpecialty(
      id: 'oncology',
      name: 'Oncology',
      description: 'Cancer diagnosis and treatment',
      commonPainTypes: ['Unexplained lumps', 'Persistent pain', 'Cancer-related pain'],
    ),
    MedicalSpecialty(
      id: 'psychiatry',
      name: 'Psychiatry',
      description: 'Mental health conditions affecting pain perception',
      commonPainTypes: ['Pain with psychological factors', 'Somatic symptom disorders'],
    ),
    MedicalSpecialty(
      id: 'endocrinology',
      name: 'Endocrinology',
      description: 'Hormonal and glandular system',
      commonPainTypes: ['Metabolic pain', 'Thyroid-related pain', 'Hormonal symptoms'],
    ),
    MedicalSpecialty(
      id: 'podiatry',
      name: 'Podiatry',
      description: 'Foot and ankle conditions',
      commonPainTypes: ['Foot pain', 'Ankle pain', 'Heel pain'],
    ),
    MedicalSpecialty(
      id: 'dentistry',
      name: 'Dentistry',
      description: 'Teeth, gums, and oral cavity',
      commonPainTypes: ['Tooth pain', 'Jaw pain', 'Gum pain'],
    ),
    MedicalSpecialty(
      id: 'pulmonology',
      name: 'Pulmonology',
      description: 'Respiratory system - lungs and airways',
      commonPainTypes: ['Chest pain with breathing', 'Cough', 'Shortness of breath'],
    ),
    MedicalSpecialty(
      id: 'general_surgery',
      name: 'General Surgery',
      description: 'Surgical intervention for various conditions',
      commonPainTypes: ['Acute abdomen', 'Appendicitis', 'Gallbladder pain'],
    ),
  ];

  static MedicalSpecialty? findById(String id) {
    try {
      return all.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }
}
