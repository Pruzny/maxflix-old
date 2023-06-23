import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:maxflix/helper/movie_helper.dart';
import 'package:maxflix/model/movie.dart';

class MoviePage extends StatefulWidget {
  const MoviePage({super.key, required this.movie, required this.posterPath});
  final Movie movie;
  final String posterPath;

  @override
  State<MoviePage> createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  @override
  Widget build(BuildContext context) {
    Movie movie = widget.movie;
    String posterPath = widget.posterPath;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    List<String> splitDate = movie.releaseDate.split("-");
    String releaseYear = splitDate.isNotEmpty ? splitDate[0] : "-";
    final currencyFormat = NumberFormat.simpleCurrency();
    final averageFormat = NumberFormat.decimalPatternDigits(decimalDigits: 1);

    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: FloatingActionButton.extended(
            onPressed: () {
              Navigator.pop(context);
            },
            backgroundColor: Colors.white,
            label: const Text(
              "Voltar",
              style: TextStyle(
                color: Color(0xFF6D7070),
                fontWeight: FontWeight.w500,
                fontSize: 18,
              ),
            ),
            icon: SvgPicture.asset(
              "assets/icons/Back.svg",
              height: 18,
            )),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      body: SafeArea(
          child: Container(
        color: Colors.white,
        child: Center(
            child: FutureBuilder(
                future: MovieHelper().getMovieData(movie),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              Column(
                                children: [
                                  Container(
                                    height: width * 0.8,
                                    color: const Color(0xFFF5F5F5),
                                  ),
                                  Container(
                                    height: width * 0.4,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                              Container(
                                width: width * 0.6,
                                height: width * 0.9,
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF00384C)
                                          .withOpacity(0.2),
                                      offset: const Offset(0, 20),
                                      spreadRadius: -10,
                                      blurRadius: 20,
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(width * 0.03),
                                  child: movie.posterPath != null
                                      ? CachedNetworkImage(
                                          imageUrl:
                                              "$posterPath${movie.posterPath}",
                                          cacheManager:
                                              MovieHelper().cacheManager,
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
                                                fontWeight: FontWeight.bold),
                                          )),
                                        ),
                                ),
                              ),
                            ],
                          ),
                          Padding(padding: EdgeInsets.all(height * 0.03)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                averageFormat.format(movie.voteAverage),
                                style: TextStyle(
                                  fontSize: width * 0.1,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              Text(
                                " / 10",
                                style: TextStyle(
                                  fontSize: width * 0.07,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF868E96),
                                ),
                              ),
                            ],
                          ),
                          Padding(padding: EdgeInsets.all(height * 0.03)),
                          Container(
                            constraints: BoxConstraints(maxWidth: width * 0.8),
                            child: Text(
                              movie.title.toUpperCase(),
                              style: TextStyle(
                                color: const Color(0xFF343A40),
                                fontSize: width * 0.06,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Padding(padding: EdgeInsets.all(height * 0.015)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Título original: ",
                                style: TextStyle(
                                  fontSize: width * 0.035,
                                  fontWeight: FontWeight.normal,
                                  color: const Color(0xFF5E6770),
                                ),
                              ),
                              Container(
                                constraints:
                                    BoxConstraints(maxWidth: width * 0.6),
                                child: Text(
                                  movie.originalTitle,
                                  style: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    fontSize: width * 0.035,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF5E6770),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(padding: EdgeInsets.all(height * 0.025)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: width * 0.10,
                                width: width * 0.3,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF1F3F5),
                                  borderRadius:
                                      BorderRadius.circular(width * 0.015),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Ano: ",
                                      style: TextStyle(
                                        fontSize: width * 0.04,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFF868E96),
                                      ),
                                    ),
                                    Text(
                                      releaseYear,
                                      style: TextStyle(
                                        fontSize: width * 0.045,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFF343A40),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                  padding: EdgeInsets.only(left: width * 0.03)),
                              Container(
                                height: width * 0.10,
                                width: width * 0.5,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF1F3F5),
                                  borderRadius:
                                      BorderRadius.circular(width * 0.015),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Duração: ",
                                      style: TextStyle(
                                        fontSize: width * 0.04,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFF868E96),
                                      ),
                                    ),
                                    Text(
                                      formatDuration(movie.runtime),
                                      style: TextStyle(
                                        fontSize: width * 0.045,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFF343A40),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Padding(padding: EdgeInsets.all(height * 0.01)),
                          createGenreCards(
                              genres: movie.genreIds,
                              width: width,
                              height: height),
                          Padding(padding: EdgeInsets.all(height * 0.05)),
                          Container(
                            width: width * 0.9,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Descrição",
                              style: TextStyle(
                                color: const Color(0xFF5E6770),
                                fontSize: width * 0.06,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                          Padding(padding: EdgeInsets.all(width * 0.015)),
                          Container(
                            width: width * 0.9,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              movie.overview != "" ? movie.overview : "-",
                              style: TextStyle(
                                color: const Color(0xFF343A40),
                                fontSize: width * 0.04,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                          ),
                          Padding(padding: EdgeInsets.all(height * 0.03)),
                          Container(
                            height: width * 0.10,
                            width: width * 0.9,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F3F5),
                              borderRadius:
                                  BorderRadius.circular(width * 0.015),
                            ),
                            padding: EdgeInsets.only(left: width * 0.05),
                            child: Row(
                              children: [
                                Text(
                                  "ORÇAMENTO:  ",
                                  style: TextStyle(
                                    fontSize: width * 0.04,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF868E96),
                                  ),
                                ),
                                Text(
                                  movie.budget != 0
                                      ? currencyFormat.format(movie.budget)
                                      : "-",
                                  style: TextStyle(
                                      fontSize: width * 0.045,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF343A40),
                                      overflow: TextOverflow.ellipsis),
                                ),
                              ],
                            ),
                          ),
                          Padding(padding: EdgeInsets.all(height * 0.005)),
                          Container(
                            constraints:
                                BoxConstraints(minHeight: width * 0.10),
                            width: width * 0.9,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F3F5),
                              borderRadius:
                                  BorderRadius.circular(width * 0.015),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: width * 0.05, vertical: height * 0.01, ),
                            child: Wrap(
                              children: [
                                Text(
                                  "PRODUTORA:  ",
                                  style: TextStyle(
                                    fontSize: width * 0.04,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF868E96),
                                  ),
                                ),
                                Text(
                                  getNames(
                                    movie.productionCompanies,
                                  ),
                                  style: TextStyle(
                                    fontSize: width * 0.045,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF343A40),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(padding: EdgeInsets.all(height * 0.03)),
                          Container(
                            width: width * 0.9,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Diretor",
                              style: TextStyle(
                                color: const Color(0xFF5E6770),
                                fontSize: width * 0.06,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                          Padding(padding: EdgeInsets.all(width * 0.015)),
                          Container(
                            width: width * 0.9,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              getNames(movie.crew),
                              style: TextStyle(
                                color: const Color(0xFF343A40),
                                fontSize: width * 0.04,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                          ),
                          Padding(padding: EdgeInsets.all(height * 0.025)),
                          Container(
                            width: width * 0.9,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Elenco",
                              style: TextStyle(
                                color: const Color(0xFF5E6770),
                                fontSize: width * 0.06,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                          Padding(padding: EdgeInsets.all(width * 0.015)),
                          Container(
                            width: width * 0.9,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              getNames(movie.cast),
                              style: TextStyle(
                                color: const Color(0xFF343A40),
                                fontSize: width * 0.04,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                          ),
                          Padding(padding: EdgeInsets.all(width * 0.05)),
                        ],
                      ),
                    );
                  }

                  return const CircularProgressIndicator();
                })),
      )),
    );
  }

  SizedBox createGenreCards(
      {required List<dynamic> genres,
      required double width,
      required double height}) {
    Map<String, String> genreMap = MovieHelper().reversedGenres;

    List<Widget> children = [];

    int len = genres.length;
    for (int i = 0; i < 3; i++) {
      if (len >= i + 1) {
        children.add(IntrinsicWidth(
          child: Container(
            height: height * 0.05,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade200),
              borderRadius: BorderRadius.circular(width * 0.015),
            ),
            alignment: Alignment.center,
            padding: EdgeInsets.only(left: width * 0.025, right: width * 0.025),
            child: Text(
              genreMap["${genres[i]}"]?.toUpperCase() ?? "",
              style: TextStyle(
                overflow: TextOverflow.ellipsis,
                fontSize: width * 0.045,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF5E6770),
              ),
            ),
          ),
        ));
      }
    }

    return SizedBox(
      width: width * 0.9,
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: width * 0.025,
        runSpacing: width * 0.025,
        children: children,
      ),
    );
  }

  String formatDuration(int? duration) {
    if (duration == null) {
      return '-';
    }

    if (duration < 60) {
      return "$duration min";
    }

    return "${(duration / 60).floor()}h ${duration % 60}min";
  }

  String getNames(List<dynamic> elements) {
    List<String> names = [];

    for (Map<String, dynamic> element in elements) {
      names.add("${element["name"]}");
    }

    names = names.toSet().toList();
    String text = "";
    if (names.isNotEmpty) {
      text = names.first;

      if (names.length > 1) {
        for (String name in names) {
          text = "$text, $name";
        }
      }
    } else {
      text = "-";
    }

    return text;
  }
}
