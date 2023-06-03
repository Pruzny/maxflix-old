import 'dart:async';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:maxflix/model/movie.dart';

class MovieHelper {
  static final _instance = MovieHelper._constructor();
  static const _discoverUrl = "https://api.themoviedb.org/3/discover/movie";
  static const _languageUrl = "https://api.themoviedb.org/3/configuration/languages";
  static const _genreUrl = "https://api.themoviedb.org/3/genre/movie/list";
  static const _movieUrl = "https://api.themoviedb.org/3/movie/";
  static const _key = "8c5021c1d9e9c7c1a2b0b2bd14b96f3d";
  List<String> genresQuery = [];
  String language = "pt";
  String page = "1";
  Timer? _debounce;
  List<Movie> movies = [];
  Map<String, String> languages = {};
  Map<String, String> genres = {};
  Map<String, String> reversedGenres = {};

  bool loadBase = false;

  MovieHelper._constructor();

  factory MovieHelper() {
    return _instance;
  }

  Future<bool> getMovieData(Movie movie) async {
    String args = "?api_key=$_key";
    http.Response responseData = await http.get(Uri.parse("$_movieUrl${movie.id}$args"));
    if (responseData.statusCode.toString() == '200') {
      Map<String, dynamic> data = json.decode(responseData.body);
      http.Response responseCredits = await http.get(Uri.parse("$_movieUrl/${movie.id}/credits$args"));
      if (responseCredits.statusCode.toString() == '200') {
        Map<String, dynamic> creditsMap = json.decode(responseCredits.body);
        data.addAll(creditsMap);

        movie.runtime = data["runtime"];
        movie.budget = data["budget"];
        movie.productionCompanies = data["production_companies"];
        movie.cast = data["cast"];
        movie.crew = data["crew"];

        return true;
      }
    }

    return false;
  }

  Future<List<Movie>> _getMovies() async {
    String genresString = "";
    for (var element in genresQuery) {
      genresString = "$genresString$element,";
    }
    String args = "?api_key=$_key"
                  "&language=$language"
                  "&page=$page"
                  "&with_genres=$genresString";
                  
    http.Response response = await http.get(Uri.parse("$_discoverUrl$args"));
    List<Movie> movies = [];

    if (response.statusCode.toString() == '200') {
      for (Map<String, dynamic> map in json.decode(response.body)["results"]) {
        movies.add(Movie.fromMap(map));
      }
      return movies;
    }

    return movies;
  }

  Future<Map<String, String>> _getLanguages() async {
    String args = "?api_key=$_key";
    http.Response response = await http.get(Uri.parse("$_languageUrl$args"));
    Map<String, String> languages = {};

    if (response.statusCode.toString() == '200') {
      for (Map<String, dynamic> map in json.decode(response.body)) {
        String name = map["name"]!;
        if (name != "") {
          languages[name] = map["iso_639_1"]!;
        }
      }
    }

    return languages;
  }

  Future<Map<String, String>> _getGenres() async {
    String args = "?api_key=$_key&language=$language";
    http.Response response = await http.get(Uri.parse("$_genreUrl$args"));
    Map<String, String> genres = {};

    if (response.statusCode.toString() == '200') {
      for (Map<String, dynamic> map in json.decode(response.body)["genres"]) {
        genres[map["name"]!] = "${map["id"]!}";
      }
    }

    return genres;
  }

  Future<Map<String, dynamic>> loadData() async {
    if (!loadBase) {
      languages.clear();
      languages.addAll(await _getLanguages());
      genres.clear();
      genres.addAll(await _getGenres());
      reversedGenres.clear();
      genres.forEach((key, value) {
        reversedGenres[value] = key;
      });
      loadBase = true;
    }
    if (_debounce?.isActive ?? false) {
      _debounce!.cancel();
    } else {
      movies.clear();
      movies.addAll(await _getMovies());
      _debounce = Timer(const Duration(milliseconds: 500), () async {});
    }

    return {
      "movies": movies,
      "languages": languages,
      "genres": genres,
    };
  }

  String getCardGenres(Movie movie) {
    // if (genresQuery.length > 1) {
    //   return "${reversedGenres[genresQuery[0].toString()]} - ${reversedGenres[genresQuery[1].toString()]}";
    // }

    // if (genresQuery.isNotEmpty) {
    //   return "${reversedGenres[genresQuery[0]]}";
    // }

    if (movie.genreIds.length > 1) {
      return "${reversedGenres[movie.genreIds[0].toString()]} - ${reversedGenres[movie.genreIds[1].toString()]}";
    }

    if (movie.genreIds.isNotEmpty) {
      return "${reversedGenres[movie.genreIds[0].toString()]}";
    }

    return "";
  }
}