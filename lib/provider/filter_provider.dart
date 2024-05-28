import 'package:flutter/material.dart';

class FilterProvider with ChangeNotifier {
  List<String> _selectedCategories = ['all'];

  List<String> get selectedCategories => _selectedCategories;

  void toggleCategorySelection(String category) {
    if (category == 'all') {
      _selectedCategories = ['all'];
    } else {
      if (_selectedCategories.contains(category)) {
        _selectedCategories.remove(category);
      } else {
        _selectedCategories.add(category);
      }

      if (_selectedCategories.isEmpty) {
        _selectedCategories = ['all'];
      } else {
        _selectedCategories.remove('all');
      }
    }
    notifyListeners();
  }
}
