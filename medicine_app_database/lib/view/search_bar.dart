import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

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
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          child: TextField(
            controller: _controller,
            decoration: const InputDecoration(
              hintText: '検索',
              prefixIcon: Icon(Icons.search),
              suffixIcon: Icon(Icons.clear),
            ),
          ),
        ),
      ),
    );
  }
}