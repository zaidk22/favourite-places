import 'package:riverpod/riverpod.dart';
import 'package:path_provider/path_provider.dart' as syspaths;
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';
import '../PlaceModel.dart';

class UserPlacesNotifier extends StateNotifier<List<placeModel>>{
Future<Database> _getDatabase() async{
  final dbPath = await sql.getDatabasesPath();
  final db = await sql.openDatabase(path.join(dbPath,'place.db'),
      onCreate: (db, version) {
        return db.execute('CREATE TABLE user_places(id TEXT PRIMARY KEY,title TEXT,image TEXT,lat REAL,long REAL,address TEXT)');
      },
      version: 1
  );
  return db;
}


  UserPlacesNotifier():super(const []);

Future<void> loadPlaces() async{
  final db = await _getDatabase();
  final data = await db.query('user_places');
  final places =data.map((e) =>placeModel(
      id: e['id'] as String,
      title: e['title'] as String,
      image: File(e['image'] as String),
      location: PlaceLocation(longitude: e['lat'] as double,
          latitude:  e['long'] as double, address:  e['address'] as String,))).toList();
  state = places;
}

  void addPlace(String title,File image,PlaceLocation location) async{
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final fileName =  path.basename(image.path);
    final copiedImage = await image.copy('${appDir.path}/${fileName}');
    final newPlace = placeModel(title: title,image: copiedImage,location: location);

final db = await _getDatabase();
    db.insert('user_places', {
      'id':newPlace.id,
      'title':newPlace.title,
      'image':newPlace.image.path,
      'lat':newPlace.location.latitude,
      'long':newPlace.location.longitude,
      'address':newPlace.location.address

    });
    state = [newPlace,...state];
  }


}

final userPlacesProvider = StateNotifierProvider<UserPlacesNotifier,List<placeModel>>((ref) => UserPlacesNotifier());