import 'package:figenie/consts.dart';
import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback? onSearch;

  const SearchBar({
    Key? key,
    required this.controller,
    this.onSearch,
  }) : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  bool showClearButton = false;
  List<String> dummyLabels = [];
  double shape = 50;

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
      dummyLabels = [
        'Tour 1',
        'Tour 2',
        'Tour 3',
      ];
    });
    setState(() {
      shape = widget.controller.text.isEmpty ? 50 : 10;
    });
  }

  void _clearText() {
    widget.controller.clear();
    setState(() {
      showClearButton = false;
      dummyLabels.clear();
      shape = 50;
    });
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: foregroundColor,
        borderRadius: BorderRadius.circular(shape),
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(190, 0, 0, 0),
            blurRadius: 5,
            spreadRadius: 0.1,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Icon(Icons.search, color: textColor),
              ),
              Expanded(
                child: TextField(
                  cursorColor: textColor,
                  controller: widget.controller,
                  style: const TextStyle(color: textColor),
                  decoration: const InputDecoration(
                    hintText: ' Search Tours...',
                    hintStyle: TextStyle(color: textLightColor),
                    border: InputBorder.none,
                  ),
                  onChanged: (value) {
                    setState(() {
                      showClearButton = value.isNotEmpty;
                      if (value.isEmpty) {
                        dummyLabels.clear();
                      }
                    });
                  },
                ),
              ),
              if (showClearButton)
                IconButton(
                  icon: const Icon(Icons.clear, color: textColor),
                  onPressed: _clearText,
                ),
            ],
          ),
          // const SizedBox(height: 8.0),
          ListView.builder(
            shrinkWrap: true,
            itemCount: dummyLabels.length,
            itemBuilder: (context, index) {
              return InkWell(
                child: ListTile(
                  title: Text(
                    dummyLabels[index],
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: textLightColor,
                    ),
                  ),
                  onTap: () {
                    _clearText();
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
