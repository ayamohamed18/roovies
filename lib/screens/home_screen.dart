import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roovies/models/tmdb_handler.dart';
import 'package:roovies/models/user.dart';
import 'package:roovies/providers/genres_provider.dart';
import 'package:roovies/providers/movies_provider.dart';
import 'package:roovies/providers/persons_provider.dart';
import 'package:roovies/providers/users_provider.dart';
import 'package:roovies/screens/authentication_screen.dart';
import 'package:roovies/widgets/movies_by_genre.dart';
import 'package:roovies/widgets/my_drawer.dart';
import 'package:roovies/widgets/now_playing.dart';
import 'package:roovies/widgets/trending_movies.dart';
import 'package:roovies/widgets/trending_persons.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/home';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool firstRun, successful;
  @override
  void initState() {
    super.initState();
    firstRun = true;
    successful = false;
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (firstRun) {
      //await Provider.of<MoviesProvider>(context, listen: false).fetchNowPlaying();

      bool done = await context.read<UserProvider>().refreshTokenIfNecessary();
      User user = context.read<UserProvider>().currentUser;

      List<bool> results = await Future.wait([
        context.read<MoviesProvider>().fetchFavorites(user),
        context.read<MoviesProvider>().fetchNowPlaying(),
        context.read<GenresProvider>().fetchGenres(),
        context.read<PersonsProvider>().fetchTrendingPersons(),
        context.read<MoviesProvider>().fetchTrendingMovies()
      ]);
      setState(() {
        firstRun = false;
        successful =
            (!results.any((element) => element == false) && done == true);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    TMDBHandler.instance.getNowPlaying();
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        centerTitle: true,
        title: Text('Roovies'),
        actions: [
          IconButton(icon: Icon(Icons.search), onPressed: () {}),
        ],
      ),
      body: (firstRun)
          ? Center(child: CircularProgressIndicator())
          : (successful)
              ? ListView(
                  children: [
                    NowPlaying(),
                    MoviesByGenre(),
                    TrendingPersons(),
                    TrendingMovies(),
                  ],
                )
              : Center(
                  child: Text(
                    'Error has occured',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
    );
  }
}
