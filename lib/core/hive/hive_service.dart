import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:quick_buy/features/home/data/models/product_model.dart';

class HiveService {
  static bool _initialized = false;

  /// Initialize Hive (and register adapters) if not already done.
  static Future<void> initHive() async {
    if (!_initialized) {
      await Hive.initFlutter();
      // Register the Product adapter (generated via build_runner)
      Hive.registerAdapter(ProductAdapter());
      _initialized = true;
    }
  }

  /// Opens (or retrieves) a Hive box without a specific type.
  static Future<Box> openBox(String boxName) async {
    if (!_initialized) {
      await initHive();
    }
    return Hive.openBox(boxName);
  }

  /// Retrieves an already open box; if not open, it opens it.
  static Future<Box> getBox(String boxName) async {
    if (Hive.isBoxOpen(boxName)) {
      return Hive.box(boxName);
    }
    return openBox(boxName);
  }

  /// Stores a list of [Product] objects in the specified box under the key 'products'.
  static Future<void> storeProducts(String boxName, List<Product> products) async {
    final box = await getBox(boxName);
    await box.put('products', products);
  }

  /// Retrieves the list of [Product] objects stored under the key 'products'.
  /// Returns null if no data is found.
  static Future<List<Product>?> getProducts(String boxName) async {
    final box = await getBox(boxName);
    final data = box.get('products');
    if (data != null && data is List) {
      return data.cast<Product>();
    }
    return null;
  }

  /// Deletes the stored products from the specified box.
  static Future<void> deleteProducts(String boxName) async {
    final box = await getBox(boxName);
    await box.delete('products');
  }

  /// Clears all data in the specified box.
  static Future<void> clearBox(String boxName) async {
    final box = await getBox(boxName);
    await box.clear();
  }
}
