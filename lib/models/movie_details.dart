import 'package:roovies/models/genre.dart';

class MovieDetails {
  final String overview, releaseDate;
  final int duration, budget;
  final List<Genre> genres;

  MovieDetails.fromJson(dynamic json)
      : this.overview = json['overview'],
        this.releaseDate = json['release_date'],
        this.budget = json['budget'],
        this.duration = json['runtime'],
        this.genres = (json['genres'] as List).map((genre) {
          return Genre.fromJson(genre);
        }).toList();
}
