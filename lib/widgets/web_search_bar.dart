import 'package:flutter/material.dart';
import 'package:whatsapp_clone/colors.dart';

class webSearchBar extends StatelessWidget {
  const webSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.10,
      width: MediaQuery.of(context).size.width * 0.35,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: dividerColor))),
      child: TextField(
        decoration: InputDecoration(
            fillColor: searchBarColor,
            filled: true,
            prefixIcon: Icon(Icons.search),
            hintText: "Search",
            hintStyle: TextStyle(fontSize: 14),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(width: 0, style: BorderStyle.none))),
      ),
    );
  }
}
