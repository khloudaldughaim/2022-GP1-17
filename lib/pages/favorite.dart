import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';


class FavoritePage extends StatefulWidget {
   const FavoritePage({Key? key}) : super(key: key);

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Text('FavoritePage'),
        ),
      ),
    );
  }


}
