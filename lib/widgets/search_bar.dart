import 'package:flutter/material.dart';
import 'package:figenie/consts.dart';

class SearchBar extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback? onSearch;

  const SearchBar({
    super.key,
    required this.controller,
    this.onSearch,
  });

  @override
  // ignore: library_private_types_in_public_api
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  bool showClearButton = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_updateClearButtonVisibility);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_updateClearButtonVisibility);
    super.dispose();
  }

  void _updateClearButtonVisibility() {
    setState(() {
      showClearButton = widget.controller.text.isNotEmpty;
    });
  }

  void _clearText() {
    widget.controller.clear();
    setState(() {
      showClearButton = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: foregroundColor,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black,
            blurRadius: 5,
            spreadRadius: 0.1,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Icon(Icons.search, color: secondaryColor),
          ),
          Expanded(
            child: TextField(
              cursorColor: secondaryColor,
              controller: widget.controller,
              style: const TextStyle(color: secondaryColor),
              decoration: const InputDecoration(
                hintText: ' Search...',
                hintStyle: TextStyle(color: secondaryColor),
                border: InputBorder.none,
              ),
              onChanged: (value) {
                setState(() {
                  showClearButton = value.isNotEmpty;
                });
              },
            ),
          ),
          if (showClearButton)
            IconButton(
              icon: const Icon(Icons.clear, color: secondaryColor),
              onPressed: _clearText,
            ),
        ],
      ),
    );
  }
}
