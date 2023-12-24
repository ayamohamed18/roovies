import 'package:flutter/material.dart';
import 'package:roovies/providers/genres_provider.dart';
import 'package:roovies/widgets/movies_list.dart';
import 'package:provider/provider.dart';

class MoviesByGenre extends StatefulWidget {
  @override
  _MoviesByGenreState createState() => _MoviesByGenreState();
}

class _MoviesByGenreState extends State<MoviesByGenre>
    with TickerProviderStateMixin {
  TabController tabController;
  @override
  void initState() {
    super.initState();
    tabController = TabController(
        length: context.read<GenresProvider>().genres.length, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      width: MediaQuery.of(context).size.width,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 48,
          bottom: TabBar(
            controller: tabController,
            isScrollable: true,
            tabs: context.watch<GenresProvider>().genres.map((genre) {
              return Tab(
                text: genre.name,
              );
            }).toList(),
          ),
        ),
        body: TabBarView(
          controller: tabController,
          children: context.watch<GenresProvider>().genres.map((genre) {
            return MoviesList.byGenreId(genre.id);
          }).toList(),
        ),
      ),
    );
  }
}
