# Setup: Student Enrollment System (Flutter + Neon PostgreSQL)

This version is built for the EXISTING Neon schema
(students, subjects, schedules, enrollments, grades). It does not create
or drop any table.

## 1. Rotate your DB password
Neon Console > Roles > reset password for `neondb_owner`.
(The old one was pasted in chat and the repo is public.)

## 2. Migration (command line, after step 3 and 4)
The migration lives in `lib/core/migrations.dart`. Run it from the folder
that has pubspec.yaml and .env:

    dart run lib/core/migrate.dart status    (see applied / pending)
    dart run lib/core/migrate.dart           (apply pending migrations)

It only ADDS `schedules.slots` and `enrollments.schedule_id` and records what
ran in `schema_migrations`. Nothing is dropped. The app also runs the same
check at startup as a safety net.

## 3. Packages (in the folder with pubspec.yaml)
    flutter pub add postgres flutter_dotenv provider
    flutter pub get

## 4. Credentials
Copy `.env.example` to `.env`, put the new password in it.
Add `.env` to `.gitignore`, and register it in pubspec.yaml:

    flutter:
      assets:
        - .env

## 5. Code
Replace your project's `lib/` with the `lib/` from this zip.
Delete the old `Screens/` folder and empty `db.dart`.

## 6. Run (Windows desktop or Android, NOT web)
    flutter run -d windows

## 7. Git
    git checkout -b feature/final_project
    git add .
    git commit -m "feat: final project - database connected enrollment system (MVVM)"
    git push -u origin feature/final_project
