import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import '../models/product.dart';

class StorageService {
  // Get reference to the local file in the app documents directory
  static Future<File> _getLocalFile(String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/$fileName');
  }

  // Load products from local storage. If not found, load default data from assets and save it.
  static Future<List<Product>> loadProducts(String fileName) async {
    try {
      final file = await _getLocalFile(fileName);
      if (await file.exists()) {
        final contents = await file.readAsString();
        final List<dynamic> jsonList = jsonDecode(contents);
        return jsonList.map((item) => Product.fromJson(item)).toList();
      } else {
        // Load default from assets/products.json
        final defaultString = await rootBundle.loadString('assets/products.json');
        final List<dynamic> jsonList = jsonDecode(defaultString);
        final defaultProducts = jsonList.map((item) => Product.fromJson(item)).toList();
        // Save these products to local storage immediately to seed the file
        await saveProducts(fileName, defaultProducts);
        return defaultProducts;
      }
    } catch (e) {
      // In case of any error, return an empty list or handle gracefully
      return [];
    }
  }

  // Save the list of products back to local storage
  static Future<void> saveProducts(String fileName, List<Product> products) async {
    try {
      final file = await _getLocalFile(fileName);
      final jsonList = products.map((p) => p.toJson()).toList();
      final contents = jsonEncode(jsonList);
      await file.writeAsString(contents);
    } catch (e) {
      rethrow;
    }
  }
}
