import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MyCustomSecureStorage {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final _accountNameController =
      TextEditingController(text: 'flutter_secure_storage_service');

  MyCustomSecureStorage();

  IOSOptions _getIOSOptions() => IOSOptions(
        accountName: _getAccountName(),
      );

  AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );

  String? _getAccountName() =>
      _accountNameController.text.isEmpty ? null : _accountNameController.text;

  Future<Map<String, String>> readAll() async {
    try {
      final all = await _storage.readAll(
        iOptions: _getIOSOptions(),
        aOptions: _getAndroidOptions(),
      );
      return all;
    } catch (e) {
      // Handle error
      debugPrint('Error reading all items: $e');
      return {};
    }
  }

  Future<void> write({required String key, required String value}) async {
    try {
      await _storage.write(
        key: key,
        value: value,
        iOptions: _getIOSOptions(),
        aOptions: _getAndroidOptions(),
      );
    } catch (e) {
      // Handle error
      debugPrint('Error writing item: $e');
    }
  }

  Future<void> delete({required String key}) async {
    try {
      await _storage.delete(
        key: key,
        iOptions: _getIOSOptions(),
        aOptions: _getAndroidOptions(),
      );
    } catch (e) {
      // Handle error
      debugPrint('Error deleting item: $e');
    }
  }

  Future<void> deleteAll() async {
    try {
      await _storage.deleteAll(
        iOptions: _getIOSOptions(),
        aOptions: _getAndroidOptions(),
      );
    } catch (e) {
      // Handle error
      debugPrint('Error deleting all items: $e');
    }
  }
}
