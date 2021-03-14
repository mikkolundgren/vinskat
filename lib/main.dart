import 'package:flutter/material.dart';
import 'models.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vinskat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Mikon vinskat'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _controller = TextEditingController();
  var _filtered = [];
  var _vinskat = [];

  @override
  void initState() {
    super.initState();
    _controller.addListener(_filter);
    _fetchR();
  }

  void _fetchR() async {
    _vinskat = await fetchAllReleases();
    print("${_vinskat.length}");
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 50,
              child: Center(
                child: Text(_filtered.length.toString()),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 300.0,
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), labelText: "search"),
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(4),
                itemCount: _filtered.length,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    height: 25,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(_filtered[index].artist),
                          Text(_filtered[index].title),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  _filter() {
    var other = 0;
    if (_controller.text.compareTo("*") == other) {
      setState(() {
        _filtered.clear();
        _filtered.addAll(_vinskat);
      });
      return;
    }

    if (_controller.text.length < 2) {
      return;
    }
    setState(() {
      _filtered.clear();
    });
    print("${_controller.text} ");

    _vinskat.forEach((element) {
      if (element.artist.toLowerCase().contains(_controller.text) ||
          element.title.toLowerCase().contains(_controller.text)) {
        setState(() {
          _filtered.add(element);
        });
      }
    });
    print("result ${_filtered.length}");
  }
}
