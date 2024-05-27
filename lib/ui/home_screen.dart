import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _hasInput = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_updateInputStatus);
  }

  void _updateInputStatus() {
    setState(() {
      _hasInput = _searchController.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_updateInputStatus);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(66.0),
        child: AppBar(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(16),
            ),
          ),
          title: Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 40.0,
                  child: TextField(
                    controller: _searchController,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: 'Mau cari makan apa hari ini?',
                      hintStyle:
                          Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                      prefixIcon: _hasInput
                          ? null
                          : Icon(
                              Icons.search,
                              size: 18.0,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                      suffixIcon: _hasInput
                          ? IconButton(
                              icon: Icon(
                                Icons.close,
                                size: 18.0,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              onPressed: () {
                                _searchController.clear();
                              },
                            )
                          : null,
                      prefixIconConstraints: const BoxConstraints(
                        minWidth: 38.0,
                        minHeight: 40.0,
                      ),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.onPrimary,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8.0),
              Container(
                height: 40.0,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: IconButton(
                  icon: Icon(
                    MdiIcons.hamburgerPlus,
                    size: 20.0,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  onPressed: () {
                    // Define the action for the hamburger button here
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      body: Center(
        child: Text(
          'Home Screen',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    );
  }
}
