import 'package:flutter/material.dart';

class FilterProvider with ChangeNotifier {
  List<String> _selectedCategories = ['all'];
  String _selectedSortType = 'timeLeft';

  List<String> get selectedCategories => _selectedCategories;

  String get selectedSortType => _selectedSortType;

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

  void toggleSortSelection(String sortType) {
    _selectedSortType = sortType;
    notifyListeners();
  }
}
