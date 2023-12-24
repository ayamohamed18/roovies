import 'package:flutter/material.dart';
import 'package:roovies/models/movie.dart';
import 'package:roovies/models/movie_details.dart';
import 'package:roovies/providers/movies_provider.dart';
import 'package:roovies/screens/video_screen.dart';
import 'package:roovies/widgets/movie_genres.dart';
import 'package:roovies/widgets/movie_info.dart';
import 'package:roovies/widgets/movie_overview.dart';
import 'package:roovies/widgets/movie_rating.dart';
import 'package:sliver_fab/sliver_fab.dart';
import 'package:provider/provider.dart';

class MovieDetailsScreen extends StatefulWidget {
  static const String routeName = '/movie-details';

  @override
  _MovieDetailsScreenState createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  MovieDetails movieDetails;
  bool firstRun, successful;
  Movie movie;
  String videoKey;
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
      movie = ModalRoute.of(context).settings.arguments;
      List results = await Future.wait([
        context.read<MoviesProvider>().fetchMovieDetailsById(movie.id),
        context.read<MoviesProvider>().fetchVideoKeyByMovieId(movie.id)
      ]);
      setState(() {
        firstRun = false;
        if (!results.any((element) => element == null)) {
          successful = true;
          movieDetails = results[0];
          videoKey = results[1];
        } else {
          successful = false;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (firstRun)
          ? Center(
              child: CircularProgressIndicator(),
            )
          : (successful)
              ? SliverFab(
                  slivers: [
                    SliverAppBar(
                      pinned: true,
                      expandedHeight: MediaQuery.of(context).size.height * 0.4,
                      flexibleSpace: FlexibleSpaceBar(
                        title: Container(
                          margin: EdgeInsets.only(right: 75),
                          child: Text(
                            movie.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ),
                        background: Stack(
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height * 0.4,
                              width: double.infinity,
                              child: Image.network(
                                movie.backPosterPath,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height * 0.4,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Theme.of(context).primaryColor,
                                    Theme.of(context)
                                        .primaryColor
                                        .withOpacity(0),
                                  ],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: EdgeInsets.all(16.0),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            MovieRating(movie.rating),
                            MovieOverview(movieDetails.overview),
                            MovieInfo(
                              movieDetails.budget.toString(),
                              movieDetails.duration.toString(),
                              movieDetails.releaseDate,
                            ),
                            MovieGenres(movieDetails.genres),
                          ],
                        ),
                      ),
                    ),
                  ],
                  expandedHeight: MediaQuery.of(context).size.height * 0.4,
                  floatingWidget: FloatingActionButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) {
                          return VideoScreen(videoKey);
                        },
                      ));
                    },
                    backgroundColor: Theme.of(context).accentColor,
                    child: Icon(
                      Icons.play_arrow,
                    ),
                  ),
                )
              : Center(
                  child: Text(
                    'Error has occurred',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
    );
  }
}
