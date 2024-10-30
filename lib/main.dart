import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:my_places/pages/places.dart';

Future<void> main() async {
  // Asegúrate de que el binding esté inicializado antes de cargar dotenv
  WidgetsFlutterBinding.ensureInitialized();

  // Cargar el archivo .env
  try {
    await dotenv.load(fileName: '.env');
    print('.env file loaded successfully');
  } catch (e) {
    print('Error al cargar el archivo .env: $e');
  }

  runApp(
    const ProviderScope(child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      debugShowCheckedModeBanner: false,
      title: 'Great Places',
      theme: CupertinoThemeData(brightness: Brightness.light),
      home: PlacesPage(),
    );
  }
}
