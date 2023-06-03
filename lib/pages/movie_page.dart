import 'package:flutter/material.dart';
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
  static const maxNames = 5;

  @override
  Widget build(BuildContext context) {
    Movie movie = widget.movie;
    String posterPath = widget.posterPath;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    List<String> splitDate = movie.releaseDate.split("-");
    String releaseYear = splitDate.isNotEmpty ? splitDate[0] : "-";
    final currencyFormat = NumberFormat.simpleCurrency();

    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: FloatingActionButton.extended(
          onPressed: () {
            Navigator.pop(context);
          },
          backgroundColor: Colors.white,
          label: Text(
            "Voltar",
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 18,
            ),
          ),
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.grey.shade600,
            size: 18,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      body: SafeArea(
          child: Center(
            child: FutureBuilder(
              future: MovieHelper().getMovieData(movie),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(padding: EdgeInsets.all(height * 0.08)),
                        Container(
                          width: width * 0.6,
                          height: width * 0.9,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade800.withOpacity(0.6),
                                spreadRadius: 4,
                                blurRadius: 16,
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(width*0.03),
                            child: Image.network(
                              "$posterPath${movie.posterPath}",
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                        ),
                        Padding(padding: EdgeInsets.all(height * 0.03)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "${movie.voteAverage}",
                              style: TextStyle(
                                fontSize: width*0.1,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            Text(
                              " /10",
                              style: TextStyle(
                                fontSize: width*0.07,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                        Padding(padding: EdgeInsets.all(height * 0.03)),
                        Container(
                          constraints: BoxConstraints(maxWidth: width * 0.8),
                          child: Text(
                            movie.title,
                            style: TextStyle(
                              color: Colors.grey.shade800,
                              fontSize: width * 0.06,
                              fontWeight: FontWeight.w600,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        Padding(padding: EdgeInsets.all(height * 0.015)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Título original: ",
                              style: TextStyle(
                                fontSize: width*0.035,
                                fontWeight: FontWeight.normal,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            Container(
                              constraints: BoxConstraints(maxWidth: width*0.6),
                              child: Text(
                                movie.originalTitle,
                                style: TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  fontSize: width*0.035,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey.shade700,
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
                              color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(width * 0.015),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Ano: ",
                                    style: TextStyle(
                                      fontSize: width*0.04,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  Text(
                                    releaseYear,
                                    style: TextStyle(
                                      fontSize: width*0.05,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey.shade900,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(padding: EdgeInsets.only(left: width*0.03)),
                            Container(
                              height: width * 0.10,
                              width: width * 0.5,
                              decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(width * 0.015),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Duração: ",
                                    style: TextStyle(
                                      fontSize: width*0.04,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  Text(
                                    formatDuration(movie.runtime),
                                    style: TextStyle(
                                      fontSize: width*0.05,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey.shade900,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Padding(padding: EdgeInsets.all(height * 0.01)),
                        createGenreCards(genres: movie.genreIds, width: width, height: height),
                        Padding(padding: EdgeInsets.all(height * 0.05)),
                        Container(
                          width: width * 0.9,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Descrição",
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontSize: width * 0.06,
                              fontWeight: FontWeight.w300,
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
                              color: Colors.grey.shade900,
                              fontSize: width * 0.04,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                        Padding(padding: EdgeInsets.all(height * 0.03)),
                        Container(
                          height: width * 0.10,
                          width: width * 0.9,
                          decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(width * 0.015),
                          ),
                          padding: EdgeInsets.only(left: width * 0.05),
                          child: Row(
                            children: [
                              Text(
                                "ORÇAMENTO:  ",
                                style: TextStyle(
                                  fontSize: width*0.04,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              Text(
                                movie.budget != 0 ? currencyFormat.format(movie.budget) : "-",
                                style: TextStyle(
                                  fontSize: width*0.05,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey.shade900,
                                  overflow: TextOverflow.ellipsis
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(padding: EdgeInsets.all(height * 0.005)),
                        Container(
                          height: width * 0.10,
                          width: width * 0.9,
                          decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(width * 0.015),
                          ),
                          padding: EdgeInsets.only(left: width * 0.05),
                          child: Row(
                            children: [
                              Text(
                                "PRODUTORA:  ",
                                style: TextStyle(
                                  fontSize: width*0.04,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              Text(
                                movie.productionCompanies.isNotEmpty ? movie.productionCompanies[0]["name"] : "-",
                                style: TextStyle(
                                  fontSize: width*0.05,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey.shade900,
                                  overflow: TextOverflow.ellipsis
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
                              color: Colors.grey.shade700,
                              fontSize: width * 0.06,
                              fontWeight: FontWeight.w300,
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
                              color: Colors.grey.shade900,
                              fontSize: width * 0.04,
                              fontWeight: FontWeight.w600,
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
                              color: Colors.grey.shade700,
                              fontSize: width * 0.06,
                              fontWeight: FontWeight.w300,
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
                              color: Colors.grey.shade900,
                              fontSize: width * 0.04,
                              fontWeight: FontWeight.w600,
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
              }
            )
          )
      ),
    );
  }

  Row createGenreCards({required List<dynamic> genres, required double width, required double height}) {
    Map<String, String> genreMap = MovieHelper().reversedGenres;

    List<Widget> children = [];

    int len = genres.length;
    for (int i=0; i < 3; i++) {
      if (len >= i + 1) {
        children.add(Container(
          height: width * 0.10,
          decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade200),
            borderRadius: BorderRadius.circular(width * 0.015),
          ),
          alignment: Alignment.center,
          padding: EdgeInsets.only(left: width*0.025, right: width*0.025),
          child: Container(
            constraints: BoxConstraints(maxWidth: width*0.25),
            child: Text(
              genreMap["${genres[i]}"]?.toUpperCase() ?? "",
              style: TextStyle(
                overflow: TextOverflow.ellipsis,
                fontSize: width*0.045,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
          ),
        ));
        children.add(Padding(padding: EdgeInsets.only(left: width*0.02)));
      }
    }

    if (children.isNotEmpty) {
      children.removeLast();
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
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
      names.add("${element["original_name"]}");
    }

    names = names.toSet().toList();
    String text = "";
    if (names.isNotEmpty) {
      text = names.first;

      if (names.length > 1) {
        for (String name in names.sublist(1, names.length < maxNames ? names.length : maxNames)) {
          text = "$text, $name";
        }
      }

      if (names.length > 5) {
        text = "$text...";
      }
    } else {
      text = "-";
    }

    return text;
  }
}
