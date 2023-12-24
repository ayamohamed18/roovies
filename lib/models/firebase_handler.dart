import 'package:dio/dio.dart';
import 'package:roovies/helpers/api_keys.dart';
import 'package:roovies/models/movie.dart';
import 'package:roovies/models/user.dart';

class FirebaseHandler {
  static FirebaseHandler _instance = FirebaseHandler._private();
  FirebaseHandler._private();
  static FirebaseHandler get instance => _instance;

  Dio _dio = Dio();

  Future<void> addFavorite(Movie movie, User user) async {
    String url =
        'https://roovies-online.firebaseio.com/users/${user.userId}/favorites/${movie.id}.json';
    final params = {
      'auth': user.idToken,
    };
    await _dio.put(
      url,
      queryParameters: params,
      data: {
        'id': movie.id,
        'title': movie.title,
        'vote_average': movie.rating,
        'poster_path': movie.posterPath.split('/').last,
        'backdrop_path': movie.backPosterPath.split('/').last,
      },
    );
  }

  Future<void> deleteFavorite(Movie movie, User user) async {
    String url =
        'https://roovies-online.firebaseio.com/users/${user.userId}/favorites/${movie.id}.json';
    final params = {
      'auth': user.idToken,
    };
    await _dio.delete(
      url,
      queryParameters: params,
    );
  }

  Future<User> register(String email, String password) async {
    String url = 'https://identitytoolkit.googleapis.com/v1/accounts:signUp';
    final params = {
      'key': ApiKeys.firebaseKey,
    };
    Response response = await _dio.post(
      url,
      queryParameters: params,
      data: {'email': email, 'password': password, 'returnSecureToken': true},
    );

    return User.fromJson(response.data);
  }

  Future<User> login(String email, String password) async {
    String url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword';
    final params = {
      'key': ApiKeys.firebaseKey,
    };
    Response response = await _dio.post(
      url,
      queryParameters: params,
      data: {'email': email, 'password': password, 'returnSecureToken': true},
    );

    return User.fromJson(response.data);
  }

  Future<User> refreshToken(User user) async {
    String url = 'https://securetoken.googleapis.com/v1/token';
    final params = {
      'key': ApiKeys.firebaseKey,
    };
    Response response = await _dio.post(
      url,
      queryParameters: params,
      data: {
        'grant_type': 'refresh_token',
        'refresh_token': user.refreshToken,
      },
    );

    user.refreshToken = response.data['refresh_token'];
    user.idToken = response.data['id_token'];
    user.expiryDate = DateTime.now()
        .add(Duration(seconds: int.parse(response.data['expires_in'])));

    return user;
  }

  Future<List<Movie>> getFavorites(User user) async {
    String url =
        'https://roovies-online.firebaseio.com/users/${user.userId}/favorites.json';
    final params = {
      'auth': user.idToken,
    };

    Response response = await _dio.get(url, queryParameters: params);
    if (response.data != null) {
      return (response.data as Map)
          .entries
          .map((e) => Movie.fromJson(e.value))
          .toList();
    } else {
      return [];
    }
  }
}
