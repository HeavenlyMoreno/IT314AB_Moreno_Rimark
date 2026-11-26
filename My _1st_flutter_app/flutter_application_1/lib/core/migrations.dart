import 'package:postgres/postgres.dart';

/// One database change. Never edit a migration that was already applied:
/// add a new one with the next version number instead.
class Migration {
  final int version;
  final String name;
  final String sql;
  const Migration(this.version, this.name, this.sql);
}

/// Pure Dart (no Flutter imports) so it can run from the command line:
///     dart run lib/core/migrate.dart
/// and also from the app's startup screen as a safety net.
/// Each migration runs ONCE, inside a transaction, and is recorded in
/// the `schema_migrations` table. The SQL is also written to be re-runnable
/// (IF NOT EXISTS), so it never breaks the existing Neon tables or data.
class Migrations {
  Migrations._();

  static const List<Migration> all = [
    Migration(1, 'add schedule slots and enrollment schedule', '''
      -- Schedules need a capacity so "remaining slots" can be checked.
      ALTER TABLE schedules
        ADD COLUMN IF NOT EXISTS slots INTEGER NOT NULL DEFAULT 30;

      DO \$\$
      BEGIN
        IF NOT EXISTS (SELECT 1 FROM pg_constraint
                       WHERE conname = 'chk_schedules_slots') THEN
          ALTER TABLE schedules
            ADD CONSTRAINT chk_schedules_slots CHECK (slots >= 1);
        END IF;

        -- Lets enrollments prove a schedule belongs to the enrolled subject.
        IF NOT EXISTS (SELECT 1 FROM pg_constraint
                       WHERE conname = 'uq_schedule_subject') THEN
          ALTER TABLE schedules
            ADD CONSTRAINT uq_schedule_subject UNIQUE (schedule_id, subject_id);
        END IF;
      END \$\$;

      -- Which schedule the student picked. Nullable so old rows keep working.
      ALTER TABLE enrollments
        ADD COLUMN IF NOT EXISTS schedule_id INTEGER;

      DO \$\$
      BEGIN
        IF NOT EXISTS (SELECT 1 FROM pg_constraint
                       WHERE conname = 'enrollments_schedule_subject_fkey') THEN
          ALTER TABLE enrollments
            ADD CONSTRAINT enrollments_schedule_subject_fkey
            FOREIGN KEY (schedule_id, subject_id)
            REFERENCES schedules (schedule_id, subject_id)
            ON DELETE RESTRICT;
        END IF;
      END \$\$;

      CREATE INDEX IF NOT EXISTS idx_enrollments_schedule
        ON enrollments (schedule_id);
    '''),

    Migration(2, 'student directory fields on students', '''
      ALTER TABLE students
        ADD COLUMN IF NOT EXISTS course VARCHAR(30),
        ADD COLUMN IF NOT EXISTS year_level INTEGER,
        ADD COLUMN IF NOT EXISTS age INTEGER,
        ADD COLUMN IF NOT EXISTS height DOUBLE PRECISION,
        ADD COLUMN IF NOT EXISTS hobby VARCHAR(100),
        ADD COLUMN IF NOT EXISTS favorite_subject VARCHAR(100),
        ADD COLUMN IF NOT EXISTS image VARCHAR(200) NOT NULL DEFAULT 'assets/daddy.jpg',
        ADD COLUMN IF NOT EXISTS favorite BOOLEAN NOT NULL DEFAULT FALSE;

      DO \$\$
      BEGIN
        IF NOT EXISTS (SELECT 1 FROM pg_constraint
                       WHERE conname = 'students_year_level_check') THEN
          ALTER TABLE students ADD CONSTRAINT students_year_level_check
            CHECK (year_level IS NULL OR year_level BETWEEN 1 AND 4);
        END IF;
        IF NOT EXISTS (SELECT 1 FROM pg_constraint
                       WHERE conname = 'students_age_check') THEN
          ALTER TABLE students ADD CONSTRAINT students_age_check
            CHECK (age IS NULL OR age BETWEEN 1 AND 120);
        END IF;
      END \$\$;
    '''),

    Migration(3, 'sample students from the original directory', '''
      INSERT INTO students
        (student_no, first_name, last_name, email, course, year_level, age,
         date_of_birth, height, hobby, favorite_subject, image, status)
      SELECT v.no, v.fn, v.ln, v.email, v.course, v.yr, v.age, v.dob, v.h,
             v.hobby, v.fav, v.img, v.status
      FROM (VALUES
        ('2024-001','Rimark Rafael','Moreno','rimark@gmail.com','BSIT',3,22,DATE '2004-04-19',5.2::float8,'Sleeping','Lunch','assets/daddy.jpg','Active'),
        ('2024-002','Mannes D.','VADING','mannes@gmail.com','BSIT',2,21,DATE '2004-05-12',4.2,'Role Play','Web Development','assets/mom.jpg','Inactive'),
        ('2024-003','John Kevin','Villacorte','johnkevin@gmail.com','BSIT',2,20,DATE '2006-10-08',4.3,'Painting','Database','assets/b.jpg','Active'),
        ('2024-004','James','Neil','jamesneil@gmail.com','BSIT',2,22,DATE '2004-02-14',4.7,'Guitar','Networking','assets/Lover.jpg','Active'),
        ('2024-005','Keith','Frances','keith@gmail.com','BSIT',3,23,DATE '2003-07-25',5.4,'Joke Purpose','Dismisal','assets/m1.jpg','Active'),
        ('2024-006','Wilken','Nobetnom','wilken@gmail.com','BSIT',3,23,DATE '2003-07-25',5.4,NULL,'Mobile Development','assets/a1.jpg','Active'),
        ('2024-007','Juswa','Puppy','juswa@gmail.com','BSIT',3,23,DATE '2003-07-25',5.4,NULL,'Computer Programming','assets/papy.jpg','Active')
      ) AS v(no, fn, ln, email, course, yr, age, dob, h, hobby, fav, img, status)
      WHERE NOT EXISTS (SELECT 1 FROM students x
                        WHERE x.email = v.email AND x.student_no <> v.no)
      ON CONFLICT (student_no) DO UPDATE SET
        course = COALESCE(students.course, EXCLUDED.course),
        year_level = COALESCE(students.year_level, EXCLUDED.year_level),
        age = COALESCE(students.age, EXCLUDED.age),
        date_of_birth = COALESCE(students.date_of_birth, EXCLUDED.date_of_birth),
        height = COALESCE(students.height, EXCLUDED.height),
        hobby = COALESCE(students.hobby, EXCLUDED.hobby),
        favorite_subject = COALESCE(students.favorite_subject, EXCLUDED.favorite_subject),
        image = CASE WHEN students.image = 'assets/daddy.jpg'
                     THEN EXCLUDED.image ELSE students.image END;
    '''),

    Migration(4, 'sample subjects and schedules', '''
      INSERT INTO subjects (subject_code, subject_name, description, units)
      VALUES
        ('IT314','Mobile Application Development','Flutter and mobile apps',3.0),
        ('IT312','Database Management Systems','SQL and PostgreSQL',3.0),
        ('IT315','Web Systems and Technologies','Web development',3.0),
        ('IT316','Networking 2','Networking fundamentals',3.0)
      ON CONFLICT (subject_code) DO NOTHING;

      INSERT INTO schedules (subject_id, day_of_week, start_time, end_time, room, slots)
      SELECT s.subject_id, v.day, v.st::time, v.et::time, v.room, v.slots
      FROM (VALUES
        ('IT314','Mon','08:00','09:30','Lab 1',30),
        ('IT314','Wed','13:00','14:30','Lab 2',2),
        ('IT312','Mon','09:00','10:30','Room 201',30),
        ('IT312','Tue','10:00','11:30','Room 202',30),
        ('IT315','Thu','08:00','09:30','Lab 3',30),
        ('IT316','Fri','14:00','15:30','Room 305',30)
      ) AS v(code, day, st, et, room, slots)
      JOIN subjects s ON s.subject_code = v.code
      WHERE NOT EXISTS (SELECT 1 FROM schedules x WHERE x.subject_id = s.subject_id);
    '''),
  ];

  /// Applies every migration that has not run yet.
  /// Returns how many were applied (0 = already up to date).
  static Future<int> run(Connection conn) async {
    await conn.execute('''
      CREATE TABLE IF NOT EXISTS schema_migrations (
        version    INTEGER PRIMARY KEY,
        name       TEXT NOT NULL,
        applied_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
      )
    ''');

    final done = await conn.execute('SELECT version FROM schema_migrations');
    final applied = done.map((r) => r.first as int).toSet();

    var count = 0;
    for (final m in all) {
      if (applied.contains(m.version)) continue;

      await conn.runTx((tx) async {
        // Simple query mode allows several statements in one string.
        await tx.execute(m.sql, queryMode: QueryMode.simple);
        await tx.execute(
          Sql.named(
              'INSERT INTO schema_migrations (version, name) VALUES (@v, @n)'),
          parameters: {'v': m.version, 'n': m.name},
        );
      });
      count++;
    }
    return count;
  }
}
