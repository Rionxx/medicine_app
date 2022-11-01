import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget implements PreferredSizeWidget {
  const SearchBar({Key key}) : super(key: key);

  @override
  State<SearchBar> createState() => SearchBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class SearchBarState extends State<SearchBar> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: SizedBox(
        child: TextField(
          controller: _controller,
          decoration: const InputDecoration(
            hintText: 'Search Text',
            prefixIcon: Icon(Icons.search),
            suffixIcon: Icon(Icons.clear),
          ),
        ),
      ),
    );
  }
}