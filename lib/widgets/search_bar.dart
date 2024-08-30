import 'package:flutter/material.dart';
import 'package:figenie/consts.dart';
import 'package:figenie/model/tour.dart';

class SearchBar extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback? onSearch;
  final List<Tour> tours;
  final bool isMap;
  final void Function(Tour) onTourTap;
  final void Function(List<Tour>) updateTours;

  const SearchBar({
    super.key,
    required this.controller,
    this.onSearch,
    required this.tours,
    required this.onTourTap,
    required this.isMap,
    required this.updateTours,
    // required this.onSearchChanged,
  });

  @override
  // ignore: library_private_types_in_public_api
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  bool showClearButton = false;
  List<Tour> filteredTours = [];
  double shape = 50;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_updateClearButtonVisibility);
    filteredTours = [];
  }

  @override
  void dispose() {
    widget.controller.removeListener(_updateClearButtonVisibility);
    super.dispose();
  }

  void _updateClearButtonVisibility() {
    setState(() {
      showClearButton = widget.controller.text.isNotEmpty;
      shape = widget.controller.text.isEmpty ? 50 : 10;
    });
  }

  void _clearText() {
    widget.controller.clear();
    // widget.onSearchChanged('');
    setState(() {
      showClearButton = false;
      filteredTours = [];
      shape = 50;
    });
    widget.updateTours(widget.tours);
    FocusScope.of(context).unfocus();
  }

  void _performSearch(String searchText) {
    setState(() {
      if (searchText.isEmpty) {
        if (widget.isMap) {
          filteredTours = [];
        } else {
          filteredTours = widget.tours;
        }
      } else {
        filteredTours = widget.tours
            .where((tour) =>
                tour.name.toLowerCase().contains(searchText.toLowerCase()))
            .toList();
      }
      widget.updateTours(filteredTours);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: backgroundColor,
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
                  onChanged: _performSearch,
                ),
              ),
              if (showClearButton)
                IconButton(
                  icon: const Icon(Icons.clear, color: textColor),
                  onPressed: _clearText,
                ),
            ],
          ),
          widget.isMap
              ? ListView.builder(
                  shrinkWrap: true,
                  itemCount: filteredTours.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      child: ListTile(
                        title: Text(
                          filteredTours[index].name,
                          style: const TextStyle(
                            fontSize: 16.0,
                            color: textLightColor,
                          ),
                        ),
                        onTap: () {
                          widget.onTourTap(filteredTours[index]);
                          _clearText();
                        },
                      ),
                    );
                  },
                )
              : Container(),
        ],
      ),
    );
  }
}
