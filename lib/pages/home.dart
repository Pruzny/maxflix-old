import 'package:flutter/material.dart';
import 'package:maxflix/helper/movie_helper.dart';
import 'package:maxflix/model/movie.dart';
import 'package:maxflix/pages/movie_page.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _posterPath = "https://image.tmdb.org/t/p/w500";
  final _toggleController = ToggleController();
  final movieHelper = MovieHelper();
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: width*0.04, top: height*0.04, right: width*0.04, bottom: height*0.04),
          child: FutureBuilder(
            future: movieHelper.loadData(),
            builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Movie> movies = movieHelper.movies;
              Map<String, String> languages = movieHelper.languages;
              Map<String, String> genres = movieHelper.genres;
              
              return Column(
                children: [
                  SearchBar(
                    controller: _searchController,
                    hintText: "Pesquise filmes",
                    hintStyle: MaterialStateProperty.all(TextStyle(
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w400,
                      fontSize: height * 0.03,
                    )),
                    textStyle: MaterialStateProperty.all(TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontSize: height * 0.03,
                    )),
                    onChanged: (value) {
                      setState(() {
                        movieHelper.name = value;
                        movieHelper.page = 1;
                      });
                    },
                    backgroundColor: MaterialStateProperty.all(Colors.grey.shade200),
                    padding: MaterialStateProperty.all(EdgeInsets.only(left: width * 0.05)),
                    leading: Icon(
                      Icons.search,
                      size: height * 0.035,
                      color: Colors.grey.shade700,
                    ),
                    shadowColor: MaterialStateProperty.all(Colors.transparent),
                  ),
                  Padding(padding: EdgeInsets.all(height*0.005)),
                  createFilters(genres),
                  Padding(padding: EdgeInsets.all(height * 0.005)),
                  SingleChildScrollView(child: createMovies(movies)),
                ]
              );
            }
            
            return const Center(child: CircularProgressIndicator());
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
      height: height * 0.065,
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
                  movieHelper.page = 1;
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

  SizedBox createMovies(List<Movie> movies) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return SizedBox(
      height: height * 0.7,
      width: width * 0.9,
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: movies.length,
        itemBuilder: (context, index) {
          if (index == movies.length) {
            return const Center(child: Text("Loading..."));
          }

          Movie movie = movies[index];

          return Container(
            padding: const EdgeInsets.only(bottom: 24),
            child: Card(
              shadowColor: Colors.transparent,
              clipBehavior: Clip.hardEdge,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(width*0.05)
              ),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder:(context) => MoviePage(movie: movie, posterPath: _posterPath)),
                  );
                },
                child: Stack(
                  alignment: AlignmentDirectional.bottomStart,
                  children: [
                    SizedBox(
                      width: width * 0.9,
                      height: width * 1.30,
                      child: ShaderMask(
                        shaderCallback: (rect) {
                          return const LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [Colors.black, Colors.transparent],
                          ).createShader(Rect.fromLTRB(rect.width * 3/5, rect.height * 2/5, rect.width, rect.height));
                        },
                        blendMode: BlendMode.darken,
                        child: movie.posterPath != null ? Image.network(
                          "$_posterPath${movie.posterPath}",
                          fit: BoxFit.fitWidth,
                        ) : Container(
                          color: Colors.black,
                          child: Center(child: Text(
                            "No image",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: width * 0.04,
                            ),
                          )),
                        ),
                      ),
                    ),
                    Container(
                      width: width,
                      padding: EdgeInsets.only(left: width * 0.08, right: width * 0.08, top: height * 0.08, bottom: height * 0.08),
                      child: Column(
                        children: [
                          Text(
                            movie.title.toUpperCase(),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: height*0.03,
                              color: Colors.white
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: height*0.03),
                            child: Text(
                              movieHelper.getCardGenres(movie),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: height*0.03,
                                color: Colors.white
                              ),
                            ),
                          )
                        ],
                      ),
                      ),
                  ],
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