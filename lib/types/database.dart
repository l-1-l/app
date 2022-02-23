// // ignore_for_file: unused_element

// import 'dart:convert';
// import 'package:drift/native.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:path/path.dart' as p;
// import 'package:drift/drift.dart';
// import 'dart:io';

// import 'account.dart';
// import 'phone_number.dart';

// part 'database.g.dart';

// class PhoneNumberConverter extends TypeConverter<PhoneNumber, String> {
//   const PhoneNumberConverter();

//   @override
//   PhoneNumber? mapToDart(String? fromDb) {
//     if (fromDb == null) return null;
//     return PhoneNumber.fromJson(fromDb as Map<String, dynamic>);
//   }

//   @override
//   String? mapToSql(PhoneNumber? value) {
//     if (value == null) return null;
//     return json.encode(value.toJson());
//   }
// }

// class AccountStatus extends Table {}

// @UseRowClass(Account)
// class Accounts extends Table {
//   IntColumn get _id => integer().autoIncrement()();
//   TextColumn get id => text()();
//   TextColumn get userId => text().nullable()();
//   TextColumn get phoneNumber => text().map(const PhoneNumberConverter())();
//   TextColumn get email => text().nullable()();
//   IntColumn get status => intEnum<AccountStatus>()();
//   DateTimeColumn get createdAt => dateTime()();
//   DateTimeColumn get updatedAt => dateTime().nullable()();
// }

// LazyDatabase _openConnection() {
//   // the LazyDatabase util lets us find the right location for the file async.
//   return LazyDatabase(() async {
//     // put the database file, called db.sqlite here, into the documents folder
//     // for your app.
//     final dbFolder = await getApplicationDocumentsDirectory();
//     final file = File(p.join(dbFolder.path, 'db.sqlite'));
//     return NativeDatabase(file);
//   });
// }

// @DriftDatabase(tables: [Accounts])
// class Database {
//   // you should bump this number whenever you change or add a table definition. Migrations
//   // are covered later in this readme.
//   @override
//   // ignore: override_on_non_overriding_member
//   int get schemaVersion => 1;
// }
