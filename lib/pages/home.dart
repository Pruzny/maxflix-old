import 'package:flutter/material.dart';
import 'package:maxflix/helper/movie_helper.dart';
import 'package:maxflix/model/movie.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _toggleController = ToggleController();
  final movieHelper = MovieHelper();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: width*0.04, top: height*0.04, right: width*0.04, bottom: height*0.04),
          child: FutureBuilder(
            future: movieHelper.loadData(),
            builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Movie> movies = snapshot.data!["movies"];
              Map<String, String> languages = snapshot.data!["languages"];
              Map<String, String> genres = snapshot.data!["genres"];
              
              return Column(
                children: [
                  const Center(child: Text("Search bar")),
                  createFilters(genres),
                  const Center(child: Text("Movies")),
                ]
              );
            }
            
            return const Center(child: Text("Loading..."));
          }),
        ),
      )
    );
  }

  SizedBox createFilters(Map<String, String> genres) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    List<String> keys = List.from(genres.keys);

    return SizedBox(
      height: height * 0.06,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: genres.length,
        itemBuilder: (context, index) {
          bool isActive = _toggleController.filter.contains(index);

          return Container(
            padding: const EdgeInsets.all(6),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  if (isActive) {
                    _toggleController.filter.remove(index);
                    movieHelper.genresQuery.remove(genres[keys[index]]);
                  } else {
                    _toggleController.filter.add(index);
                    movieHelper.genresQuery.add(genres[keys[index]]!);
                  }
                });
              },
              style: isActive ? ButtonStyle(
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(width)
                ))
              ) : ButtonStyle(
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(width)
                )),
                backgroundColor: MaterialStateProperty.all(Colors.white),
              ),
              child: FittedBox(
                fit: BoxFit.fitHeight,
                child: Text(
                  keys[index],
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: height*0.03,
                    color: isActive ? Colors.white : Theme.of(context).primaryColor
                  ),
                ),
              ),
            ),
          );
        }
      ),
    );
  }
}

class ToggleController {
  List<int> filter = [];
  
  ToggleController();
}