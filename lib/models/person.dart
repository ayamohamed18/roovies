class Person {
  final int id;
  final String name;
  final String posertPath;

  Person.fromJson(dynamic json)
      : this.id = json['id'],
        this.name = json['name'],
        this.posertPath =
            'https://image.tmdb.org/t/p/original/${json['profile_path']}';
}
