import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();
  final movieHelper = MovieHelper();
  Timer? _debounce;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    Map<String, String> genres = movieHelper.genres;

    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(0),
          child: AppBar(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            elevation: 0,
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: Colors.white,
              statusBarIconBrightness: Brightness.dark,
              statusBarBrightness: Brightness.dark,
            ),
          ),
        ),
        resizeToAvoidBottomInset: false,
        body: Center(
          child: SizedBox(
            width: width * 0.9,
            child: FutureBuilder(
              future: movieHelper.loadData(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Movie> movies = movieHelper.movies;

                  return CustomScrollView(
                    controller: _scrollController,
                    slivers: [
                      SliverAppBar(
                        floating: true,
                        pinned: false,
                        collapsedHeight: height * 0.14 + 78,
                        backgroundColor: Colors.white,
                        flexibleSpace: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.only(top: height * 0.025, bottom: height * 0.025),
                              alignment: Alignment.centerLeft,
                              child: const Text(
                                "Filmes",
                                style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF343A40)),
                              ),
                            ),
                            SizedBox(
                              width: width * 0.9,
                              child: SearchBar(
                                controller: _searchController,
                                leading: SvgPicture.asset(
                                  "assets/icons/Search.svg",
                                  height: 18,
                                ),
                                hintText: "Pesquise filmes",
                                hintStyle: MaterialStateProperty.all(const TextStyle(
                                  color: Color(0xFF5E6770),
                                  fontSize: 18,
                                )),
                                textStyle: MaterialStateProperty.all(const TextStyle(
                                  color: Color(0xFF5E6770),
                                  fontSize: 18,
                                )),
                                onChanged: (value) {
                                  if (!(_debounce?.isActive ?? false)) {
                                    _debounce =
                                        Timer(const Duration(milliseconds: 500),
                                            () async {
                                      setState(() {
                                        movieHelper.name = value;
                                        movieHelper.page = 1;
                                      });
                                    });
                                  }
                                },
                                backgroundColor: MaterialStateProperty.all(
                                    const Color(0xFFF1F3F5)),
                                padding: MaterialStateProperty.all(
                                    EdgeInsets.only(left: width * 0.05)),
                                shadowColor:
                                    MaterialStateProperty.all(Colors.transparent),
                                trailing: _searchController.text.isNotEmpty
                                    ? [
                                        IconButton(
                                          onPressed: () {
                                            _searchController.clear();
                                            setState(() {
                                              movieHelper.name = "";
                                              movieHelper.page = 1;
                                            });
                                          },
                                          icon: Icon(
                                            Icons.clear,
                                            size: height * 0.025,
                                            color: const Color(0xFF5E6770),
                                          ),
                                        )
                                      ]
                                    : [],
                              ),
                            ),
                            Padding(padding: EdgeInsets.all(height * 0.005)),
                            movieHelper.genres.isNotEmpty
                                ? createFilters(genres)
                                : const SizedBox(),
                          ],
                        ),
                      ),
                      SliverList(
                          delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          if (index == movies.length) {
                            if (movieHelper.hasNextPage) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                            return const SizedBox();
                          }

                          Movie movie = movies[index];

                          return Container(
                            padding: const EdgeInsets.only(bottom: 24),
                            child: Card(
                              shadowColor: Colors.transparent,
                              clipBehavior: Clip.hardEdge,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(width * 0.05)),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MoviePage(
                                            movie: movie,
                                            posterPath: _posterPath)),
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
                                            colors: [
                                              Colors.black,
                                              Colors.transparent
                                            ],
                                          ).createShader(Rect.fromLTRB(
                                              rect.width * 3 / 5,
                                              rect.height * 2 / 5,
                                              rect.width,
                                              rect.height));
                                        },
                                        blendMode: BlendMode.darken,
                                        child: movie.posterPath != null
                                            ? CachedNetworkImage(
                                                imageUrl:
                                                    "$_posterPath${movie.posterPath}",
                                                cacheManager:
                                                    movieHelper.cacheManager,
                                                fit: BoxFit.fill,
                                              )
                                            : Container(
                                                color: Colors.black,
                                                child: Center(
                                                    child: Text(
                                                  "No image",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: width * 0.04,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                )),
                                              ),
                                      ),
                                    ),
                                    Container(
                                      width: width,
                                      padding: EdgeInsets.only(
                                          left: width * 0.08,
                                          right: width * 0.08,
                                          top: height * 0.08,
                                          bottom: height * 0.08),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            movie.title.toUpperCase(),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: height * 0.03,
                                                color: Colors.white),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: height * 0.03),
                                            child: Text(
                                              movieHelper.getCardGenres(movie),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontSize: height * 0.03,
                                                  fontWeight: FontWeight.normal,
                                                  color: Colors.white),
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
                        },
                        childCount: movies.length + 1,
                      )),
                    ],
                  );
                }

                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ));
  }

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.offset) {
        setState(() {
          movieHelper.page++;
        });
      }
    });
    super.initState();
  }

  SizedBox createFilters(Map<String, String> genres) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    List<String> keys = List.from(genres.keys);

    return SizedBox(
      height: height * 0.055,
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
                style: isActive
                    ? ButtonStyle(
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(width))))
                    : ButtonStyle(
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(width))),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.white),
                      ),
                child: FittedBox(
                  fit: BoxFit.fitHeight,
                  child: Text(
                    keys[index],
                    style: TextStyle(
                        fontSize: height * 0.025,
                        fontWeight: FontWeight.normal,
                        color: isActive
                            ? Colors.white
                            : Theme.of(context).primaryColor),
                  ),
                ),
              ),
            );
          }),
    );
  }
}

class ToggleController {
  List<int> filter = [];

  ToggleController();
}
