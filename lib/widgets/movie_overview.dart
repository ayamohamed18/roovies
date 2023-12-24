import 'package:flutter/material.dart';

class MovieOverview extends StatefulWidget {
  final String data;
  MovieOverview(this.data);

  @override
  _MovieOverviewState createState() => _MovieOverviewState();
}

class _MovieOverviewState extends State<MovieOverview> {
  bool seeMore;
  @override
  void initState() {
    super.initState();
    seeMore = false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Overview',
            style: Theme.of(context).textTheme.headline6,
          ),
          Text(
            widget.data,
            maxLines: seeMore ? 20 : 3,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: FlatButton(
                child: Text(
                  (seeMore) ? 'see less' : 'see more',
                  style: TextStyle(color: Theme.of(context).accentColor),
                ),
                onPressed: () {
                  setState(() {
                    seeMore = !seeMore;
                  });
                }),
          )
        ],
      ),
    );
  }
}
