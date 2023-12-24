class Movie {
  final int id;
  final String title, posterPath, backPosterPath;
  final double rating;

  Movie.fromJson(dynamic json)
      : this.id = json['id'],
        this.title = json['title'],
        this.rating = json['vote_average'].toDouble(),
        this.posterPath =
            'https://image.tmdb.org/t/p/original/${json['poster_path']}',
        this.backPosterPath =
            'https://image.tmdb.org/t/p/original/${json['backdrop_path']}';
}
