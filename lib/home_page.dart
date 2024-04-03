import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> _drinksAudit = [];
  bool areFABsVisible = true;
  final drinksSharedPrefKey = "drinks";

  @override
  void initState() {
    super.initState();
    _loadDrinks();
  }

  Future<void> _loadDrinks() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _drinksAudit = prefs.getStringList(drinksSharedPrefKey) ?? [];
    });
  }

  Future<void> _addDrink() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _drinksAudit.add(DateFormat('Hms').format(DateTime.now()));
      prefs.setStringList(drinksSharedPrefKey, _drinksAudit);
    });
  }

  Future<void> _removeDrink(int index) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _drinksAudit.removeAt(index);
      prefs.setStringList(drinksSharedPrefKey, _drinksAudit);
    });
  }

  Future<void> _removeAll() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _drinksAudit = [];
      prefs.setStringList(drinksSharedPrefKey, _drinksAudit);
    });
  }

  Widget showFABs() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FloatingActionButton(
            onPressed: _removeAll,
            tooltip: 'Fechar a conta',
            child: const Icon(Icons.playlist_remove),
          ),
          FloatingActionButton(
            onPressed: _addDrink,
            tooltip: 'Adicionar drink',
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final headline1Theme = Theme.of(context).textTheme.displayLarge;
    final TextStyle textStyle = TextStyle(
        fontSize: headline1Theme!.fontSize, fontWeight: FontWeight.bold);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Drink Counter'),
      ),
      body: Stack(children: [
        SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Image.asset(
            'assets/images/background.jpg',
            fit: BoxFit.cover,
          ),
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Card(
                shape: const StadiumBorder(
                    side: BorderSide(color: Colors.amber, width: 5.0)),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    '${_drinksAudit.length}',
                    style: textStyle,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: _drinksAudit.length,
                    itemBuilder: ((context, index) {
                      return Card(
                        child: ListTile(
                          trailing: IconButton(
                              onPressed: () {
                                _removeDrink(index);
                              },
                              icon: const Icon(Icons.remove_circle,
                                  color: Colors.red)),
                          title: Text(
                            '🍺 ${index + 1} - ${_drinksAudit[index]}',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        ),
                      );
                    })),
              ),
              Container(
                height: 70,
              )
            ],
          ),
        ),
      ]),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: showFABs(),
    );
  }
}

// image from https://unsplash.com/photos/_8KV86shhPo
// icon https://www.freeimages.com/photo/beer-mug-1634149
