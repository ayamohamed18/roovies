import 'package:flutter/material.dart';
import 'package:roovies/widgets/persons_list.dart';

class TrendingPersons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 10, top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Trending Persons Of This Week',
            style: Theme.of(context).textTheme.headline6,
          ),
          PersonsList(),
        ],
      ),
    );
  }
}
