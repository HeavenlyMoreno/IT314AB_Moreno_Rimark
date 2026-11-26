/// Maps the `students` table. The original Student Directory fields
/// (course, year, age, hobby, image, favorite...) are stored in extra columns
/// added by migration 2.
class Student {
  final int? id; // students.student_id (PK)
  final String studentNo; // shown as "Student ID"
  final String firstName;
  final String lastName;
  final String email;
  final String? course;
  final int? year; // year_level 1-4
  final int? age;
  final String? dateOfBirth; // 'YYYY-MM-DD'
  final double? height;
  final String? hobby;
  final String? favoriteSubject;
  final String image; // asset path, e.g. assets/daddy.jpg
  final String status; // Active / Inactive / Graduated
  final bool favorite;

  const Student({
    this.id,
    required this.studentNo,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.course,
    this.year,
    this.age,
    this.dateOfBirth,
    this.height,
    this.hobby,
    this.favoriteSubject,
    this.image = 'assets/daddy.jpg',
    this.status = 'Active',
    this.favorite = false,
  });

  String get fullName => '$firstName $lastName'.trim();
  bool get active => status == 'Active';

  /// "Course - Year 3" line used in the list.
  String get programLabel {
    final c = (course ?? '').trim();
    if (c.isEmpty && year == null) return 'No course yet';
    if (year == null) return c;
    return c.isEmpty ? 'Year $year' : '$c - Year $year';
  }

  static const _months = [
    'January', 'February', 'March', 'April', 'May', 'June', 'July',
    'August', 'September', 'October', 'November', 'December'
  ];

  /// 2004-04-19 -> April 19, 2004
  String get birthdayText {
    final d = DateTime.tryParse(dateOfBirth ?? '');
    if (d == null) return '';
    return '${_months[d.month - 1]} ${d.day}, ${d.year}';
  }

  /// "Mannes D. VADING" -> ['Mannes D.', 'VADING']. One word -> [word, ''].
  static List<String> splitName(String full) {
    final text = full.trim().replaceAll(RegExp(r'\s+'), ' ');
    final i = text.lastIndexOf(' ');
    if (i == -1) return [text, ''];
    return [text.substring(0, i), text.substring(i + 1)];
  }

  factory Student.fromRow(Map<String, dynamic> r) => Student(
        id: r['student_id'] as int,
        studentNo: r['student_no'] as String,
        firstName: r['first_name'] as String,
        lastName: r['last_name'] as String,
        email: r['email'] as String,
        course: r['course'] as String?,
        year: r['year_level'] as int?,
        age: r['age'] as int?,
        dateOfBirth: r['date_of_birth'] as String?,
        height: (r['height'] as num?)?.toDouble(),
        hobby: r['hobby'] as String?,
        favoriteSubject: r['favorite_subject'] as String?,
        image: (r['image'] as String?) ?? 'assets/daddy.jpg',
        status: r['status'] as String,
        favorite: (r['favorite'] as bool?) ?? false,
      );

  static String? _nullIfEmpty(String? v) =>
      (v == null || v.trim().isEmpty) ? null : v.trim();

  Map<String, dynamic> toRow() => {
        'student_no': studentNo,
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'course': _nullIfEmpty(course),
        'year_level': year,
        'age': age,
        'date_of_birth': _nullIfEmpty(dateOfBirth),
        'height': height,
        'hobby': _nullIfEmpty(hobby),
        'favorite_subject': _nullIfEmpty(favoriteSubject),
        'image': image,
        'status': status,
        'favorite': favorite,
      };

  Student copyWith({
    String? studentNo,
    String? firstName,
    String? lastName,
    String? email,
    String? course,
    int? year,
    int? age,
    String? dateOfBirth,
    double? height,
    String? hobby,
    String? favoriteSubject,
    String? image,
    String? status,
    bool? favorite,
  }) =>
      Student(
        id: id,
        studentNo: studentNo ?? this.studentNo,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        email: email ?? this.email,
        course: course ?? this.course,
        year: year ?? this.year,
        age: age ?? this.age,
        dateOfBirth: dateOfBirth ?? this.dateOfBirth,
        height: height ?? this.height,
        hobby: hobby ?? this.hobby,
        favoriteSubject: favoriteSubject ?? this.favoriteSubject,
        image: image ?? this.image,
        status: status ?? this.status,
        favorite: favorite ?? this.favorite,
      );
}
