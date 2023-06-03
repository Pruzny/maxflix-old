class Movie {
  bool adult;
  String? backdropPath;
  List<dynamic> genreIds;
  int id;
  String originalLanguage;
  String originalTitle;
  String overview;
  double popularity;
  String? posterPath;
  String releaseDate;
  String title;
  bool video;
  double voteAverage;
  int voteCount;
  int? runtime;
  int? budget;
  List<dynamic> productionCompanies = [];
  List<dynamic> cast = [];
  List<dynamic> crew = [];


  Movie({
    required this.adult,
    this.backdropPath,
    required this.genreIds,
    required this.id, 
    required this.originalLanguage,
    required this.originalTitle,
    required this.overview,
    required this.popularity,
    this.posterPath,
    required this.releaseDate,
    required this.title,
    required this.video,
    required this.voteAverage,
    required this.voteCount,
  });

  factory Movie.fromMap(Map<String, dynamic> map) {
    return Movie(
      adult: map["adult"] as bool,
      backdropPath: map["backdrop_path"] as String?,
      genreIds: map["genre_ids"] as List<dynamic>,
      id: map["id"] as int,
      originalLanguage: map["original_language"] as String,
      originalTitle: map["original_title"] as String,
      overview: map["overview"] as String,
      popularity: double.tryParse("${map["popularity"]}")!,
      posterPath: map["poster_path"] as String?,
      releaseDate: map["release_date"] ?? "",
      title: map["title"] as String,
      video: map["video"] as bool,
      voteAverage: double.tryParse("${map["vote_average"]}")!,
      voteCount: map["vote_count"] as int,
    );
  }

  @override
  String toString() {
    return 
    """
adult: $adult,
backdropPath: $backdropPath,
genreIds: $genreIds,
id: $id,
originalLanguage: $originalLanguage,
originalTitle: $originalTitle
overview: $overview,
popularity: $popularity,
posterPath: $posterPath,
releaseDate: $releaseDate,
title: $title,
video: $video,
voteAverage: $voteAverage,
voteCount: $voteCount,
""";
  }
}
