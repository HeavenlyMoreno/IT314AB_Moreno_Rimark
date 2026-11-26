/// Maps the existing `subjects` table.
class Subject {
  final int? id; // subjects.subject_id
  final String code;
  final String name;
  final String? description;
  final double units;

  const Subject({
    this.id,
    required this.code,
    required this.name,
    this.description,
    this.units = 3.0,
  });

  factory Subject.fromRow(Map<String, dynamic> r) => Subject(
        id: r['subject_id'] as int,
        code: r['subject_code'] as String,
        name: r['subject_name'] as String,
        description: r['description'] as String?,
        units: (r['units'] as num).toDouble(),
      );

  /// `units` is sent as text and cast to numeric in SQL.
  Map<String, dynamic> toRow() => {
        'subject_code': code,
        'subject_name': name,
        'description':
            (description == null || description!.trim().isEmpty) ? null : description!.trim(),
        'units': units.toString(),
      };

  @override
  String toString() => '$code - $name';
}
