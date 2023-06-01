import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:maxflix/model/movie.dart';

class MovieHelper {
  static MovieHelper? _instance;
  static const _discoverUrl = "https://api.themoviedb.org/3/discover/movie";
  static const _languageUrl = "https://api.themoviedb.org/3/configuration/languages";
  static const _genreUrl = "https://api.themoviedb.org/3/genre/movie/list";
  static const _key = "8c5021c1d9e9c7c1a2b0b2bd14b96f3d";
  String language;
  String page;

  MovieHelper({this.language = "pt", this.page = "1"});

  Future<List<Movie>> getMovies({String genre = ""}) async {
    String args = "?api_key=$_key"
                  "&language=$language"
                  "&page=$page"
                  "&with_genres=$genre";
                  
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

  Future<Map<String, String>> getLanguages() async {
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

  Future<Map<String, String>> getGenres() async {
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
    List<Movie> movies = await getMovies();
    Map<String, String> languages = await getLanguages();
    Map<String, String> genres = await getGenres();

    return {
      "movies": movies,
      "languages": languages,
      "genres": genres,
    };
  }
}