import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roovies/providers/users_provider.dart';
import 'package:roovies/screens/authentication_screen.dart';
import 'package:roovies/screens/home_screen.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Theme.of(context).primaryColor,
        padding: EdgeInsets.all(16),
        child: ListView(
          children: [
            Text(
              'Welcome',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Theme.of(context).accentColor,
              ),
            ),
            Text(
              context.watch<UserProvider>().currentUser.email,
              style: TextStyle(
                color: Theme.of(context).accentColor,
              ),
            ),
            Divider(
              thickness: 3,
              color: Theme.of(context).accentColor,
            ),
            Card(
              elevation: 8,
              shadowColor: Theme.of(context).accentColor,
              color: Theme.of(context).accentColor,
              child: ListTile(
                onTap: () {
                  if (ModalRoute.of(context).settings.name ==
                      HomeScreen.routeName) {
                    Navigator.of(context).pop();
                  } else {
                    Navigator.of(context)
                        .pushReplacementNamed(HomeScreen.routeName);
                  }
                },
                title: Text('Home'),
                trailing: Icon(Icons.home),
              ),
            ),
            Card(
              elevation: 8,
              shadowColor: Theme.of(context).accentColor,
              color: Theme.of(context).accentColor,
              child: ListTile(
                onTap: () {},
                title: Text('Favorites'),
                trailing: Icon(Icons.bookmark),
              ),
            ),
            Card(
              elevation: 8,
              shadowColor: Theme.of(context).accentColor,
              color: Theme.of(context).accentColor,
              child: ListTile(
                onTap: () {
                  context.read<UserProvider>().removeUserData();
                  Navigator.of(context)
                      .pushReplacementNamed(AuthenticationScreen.routeName);
                },
                title: Text('Logout'),
                trailing: Icon(Icons.exit_to_app),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
