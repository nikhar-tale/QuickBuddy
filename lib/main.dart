import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:quick_buy/features/home/data/models/product_model.dart';
import 'core/firebase/firebase_service.dart';
import 'app.dart';
import 'core/hive/hive_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseService.initializeFirebase();
  await HiveService.initHive(); // Initialize Hive


  
  runApp(const MyApp());
}
