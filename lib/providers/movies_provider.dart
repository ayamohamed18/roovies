import 'package:flutter/material.dart';
import 'package:roovies/models/firebase_handler.dart';
import 'package:roovies/models/movie.dart';
import 'package:roovies/models/movie_details.dart';
import 'package:roovies/models/tmdb_handler.dart';
import 'package:roovies/models/user.dart';

class MoviesProvider with ChangeNotifier {
  List<Movie> nowPlaying;
  List<Movie> moviesByGenre;
  List<Movie> trendingMovies;
  List<Movie> favorites = [];
  Future<bool> fetchNowPlaying() async {
    try {
      nowPlaying = await TMDBHandler.instance.getNowPlaying();
      return true;
    } catch (error) {
      return false;
    }
  }

  Future<bool> fetchMoviesByGenreId(int genreId) async {
    try {
      moviesByGenre = await TMDBHandler.instance.getMoviesByGenreId(genreId);
      return true;
    } catch (error) {
      return false;
    }
  }

  Future<bool> fetchTrendingMovies() async {
    try {
      trendingMovies = await TMDBHandler.instance.getTrendingMovies();
      return true;
    } catch (error) {
      return false;
    }
  }

  Future<MovieDetails> fetchMovieDetailsById(int movieId) async {
    try {
      return await TMDBHandler.instance.getMovieDetailsById(movieId);
    } catch (error) {
      return null;
    }
  }

  Future<String> fetchVideoKeyByMovieId(int movieId) async {
    try {
      return await TMDBHandler.instance.getVideoKeyByMovieId(movieId);
    } catch (e) {
      return null;
    }
  }

  void toggleFavoriteStatus(Movie movie, User user) async {
    try {
      if (isFavorite(movie.id)) {
        await FirebaseHandler.instance.deleteFavorite(movie, user);
        favorites.removeWhere((element) => element.id == movie.id);
      } else {
        await FirebaseHandler.instance.addFavorite(movie, user);
        favorites.add(movie);
      }

      notifyListeners();
    } catch (e) {
      print(e.response.data);
    }
  }

  bool isFavorite(int movieId) {
    return favorites.any((element) => element.id == movieId);
  }

  Future<bool> fetchFavorites(User user) async {
    try {
      favorites = await FirebaseHandler.instance.getFavorites(user);
      return true;
    } catch (error) {
      print(error.response.data);
      return false;
    }
  }
}
