import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Animator',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      home: const HeroAnimation(),
    );
  }
}

@immutable
class Person {
  final String icon;
  final int age;
  final String name;

  const Person(this.icon, this.age, this.name);
}

final List<Person> people = [
  const Person("🙋🏽‍♀️", 20, "John"),
  const Person("🙋🏽‍♂️", 23, "Mary"),
  const Person("👲", 20, "Josh"),
];

class HeroAnimation extends StatelessWidget {
  const HeroAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("People"),
      ),
      body: ListView.builder(
        itemCount: people.length,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) {
                  return DetailedPage(person: people[index]);
                },
              ));
            },
            leading: Hero(
                flightShuttleBuilder: (flightContext, animation, flightDirection, fromHeroContext, toHeroContext) {
                  switch(flightDirection){
                    case HeroFlightDirection.push:
                    return Material(
                      color: Colors.transparent,
                      child: ScaleTransition(
                        scale: animation.drive(
                          Tween<double>(
                            begin: 0.0,
                            end: 1.0
                          ).chain(CurveTween(curve: Curves.fastOutSlowIn))
                        ),
                        child: toHeroContext.widget));
                    case HeroFlightDirection.pop:
                    return Material(
                      color: Colors.transparent,
                      child: fromHeroContext.widget);
                  }
                },
                tag: people[index].name,
                child: Text(
                  people[index].icon,
                  style: const TextStyle(fontSize: 35),
                )),
            title: Text(people[index].name),
            subtitle: Text('${people[index].age} years old'),
            trailing: const Icon(Icons.arrow_forward_ios),
          );
        },
      ),
    );
  }
}

class DetailedPage extends StatelessWidget {
  final Person person;
  const DetailedPage({super.key, required this.person});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Hero(
          tag: person.name,
          child: Text(person.icon, style: const TextStyle(fontSize: 40),)),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 30),
            Text(person.name),
            const SizedBox(height: 30),
            Text('${person.age} years old')
          ],
        ),
      ),
    );
  }
}
