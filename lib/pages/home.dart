import 'package:flutter/material.dart';
import 'package:maxflix/helper/movie_helper.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final movieHelper = MovieHelper();

    return Scaffold(
      appBar: AppBar(
        title: const Text("MaxFlix"),
        centerTitle: true,
      ),
      body: const Center(child: Text("Movies")),
    );
  }
}