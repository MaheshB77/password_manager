import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> envInit() async {
  await dotenv.load(fileName: ".env");
}