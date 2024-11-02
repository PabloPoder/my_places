import 'dart:io';

import 'package:my_places/models/place.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';

/// Database helper class to manage the SQLite database
/// and provide a singleton instance of the database
class DBHelper {
  /// Singleton instance of the database
  static Database? _database;

  /// Getter to get the database instance
  /// If the database is already initialized, it returns the instance
  /// Otherwise, it initializes the database and returns the instance
  ///
  /// Returns:
  /// - [Future<Database>] - The database instance
  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  /// Initializes the database and creates the table
  /// if it does not exist
  ///
  /// Returns:
  /// - [Future<Database>] - The database instance
  static Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final pathToDatabase = path.join(dbPath, 'places.db');

    return await openDatabase(
      pathToDatabase,
      version: 1,
      onCreate: (db, version) {
        return db.execute('''
        CREATE TABLE user_places(
          id TEXT PRIMARY KEY, 
          name TEXT NOT NULL,
          description TEXT NOT NULL,
          image TEXT NOT NULL,
          date TEXT NOT NULL,
          lat REAL NOT NULL,
          lng REAL NOT NULL,
          address TEXT NOT NULL
        )
      ''');
      },
    );
  }

  /// Inserts data into the database
  /// If the data already exists, it replaces the data
  ///
  /// Parameters:
  /// - [String] table - The table name
  /// - [Map<String, Object>] data - The data to insert
  ///
  /// Returns:
  /// - [Future<int>] - The id of the inserted data
  ///                  If the data is not inserted, it returns -1
  static Future<int> insertPlace(Place place) async {
    try {
      final db = await database;
      final id = await db.insert(
          'user_places',
          {
            'id': place.id,
            'name': place.name,
            'description': place.description,
            'image': place.image.path,
            'date': place.date.toIso8601String(),
            'lat': place.location.latitude,
            'lng': place.location.longitude,
            'address': place.location.address,
          },
          conflictAlgorithm: ConflictAlgorithm.replace);
      return id;
    } catch (error) {
      print('Error inserting into user_places: $error');
      return -1;
    }
  }

  /// Fetches the data from the database
  /// and returns a list of places
  ///
  /// Returns:
  /// - [Future<List<Place>>] - The list of places
  static Future<List<Place>> getPlaces() async {
    final db = await database;
    final data = await db.query('user_places');

    final places = data
        .map(
          (row) => Place(
            id: row['id'] as String,
            name: row['name'] as String,
            description: row['description'] as String,
            image: File(row['image'] as String),
            date: DateTime.parse(row['date'] as String),
            location: PlaceLocation(
              latitude: row['lat'] as double,
              longitude: row['lng'] as double,
              address: row['address'] as String,
            ),
          ),
        )
        .toList();

    return places;
  }

  // TODO: Implement the deletePlace method
}
