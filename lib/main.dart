import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

void main() {
  runApp(MyApp());
}

const List<String> _results = <String>[
  'aardvark',
  'baboon',
  'chameleon',
  'dingo',
  'elephant',
  'flamingo',
  'goose',
  'hippopotamus',
  'iguana',
  'jaguar',
  'koala',
  'lemur',
  'mouse',
  'northern white rhinocerous',
];

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: <String, Widget Function(BuildContext)>{
        '/': (BuildContext context) => MyHomePage(title: 'Flutter Demo Home Page'),
        '/typeahead': (BuildContext context) => TypeaheadPage(),
        '/vanilla': (BuildContext context) => VanillaPage(),
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: ListView(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                showSearch(
                  context: context,
                  delegate: CustomSearchDelegate(),
                );
              },
              child: ListTile(
                title: const Text('SearchDelegate Example'),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed('/typeahead');
              },
              child: ListTile(
                title: const Text('Typeahead Example'),
                subtitle: const Text('Package broken on Mac?'),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed('/vanilla');
              },
              child: ListTile(
                title: const Text('Vanilla Example'),
                subtitle: const Text('Custom'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomSearchDelegate extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.length < 3) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text(
              "Search term must be longer than two letters.",
            ),
          )
        ],
      );
    }

    /*
    if (loading) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(child: CircularProgressIndicator()),
        ],
      );
    }
    */

    /*
    if (_results.isEmpty()) {
      return Column(
        children: <Widget>[
          Text(
            "No Results Found.",
          ),
        ],
      );
    }
    */

    return ListView.builder(
      itemCount: _results.length,
      itemBuilder: (context, index) {
        var result = _results[index];
        return ListTile(
          title: Text(result),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ListView(
      children: <Widget>[
        ListTile(
          title: const Text('suggestion1'),
        ),
        ListTile(
          title: const Text('suggestion2'),
        ),
      ],
    );
  }
}

class Item {
  Item({
    this.name = 'Unnamed',
  });

  final String name;
  final double price = 1.99;
}

class TypeaheadPage extends StatelessWidget {
  TypeaheadPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Typeahead Example'),
      ),
      body: Center(
        child: TypeAheadField(
          textFieldConfiguration: TextFieldConfiguration(
            autofocus: true,
            style: DefaultTextStyle.of(context).style.copyWith(
              fontStyle: FontStyle.italic
            ),
            decoration: InputDecoration(
              border: OutlineInputBorder()
            )
          ),
          suggestionsCallback: (pattern) async {
            return Future<List<Item>>.delayed(const Duration(seconds: 2), () {
              return _results.map((String result) => Item(name: result)).toList();
            });
          },
          itemBuilder: (context, Item suggestion) {
            return ListTile(
              leading: Icon(Icons.shopping_cart),
              title: Text(suggestion.name),
              subtitle: Text('\$${suggestion.price}'),
            );
          },
          onSuggestionSelected: (suggestion) {
            print('justin selected ${suggestion.name}');
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }
}

class VanillaPage extends StatelessWidget {
  VanillaPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Typeahead Example'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            TextFormField(
            ),
          ],
        ),
      ),
    );
  }
}
