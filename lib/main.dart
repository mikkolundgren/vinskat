import 'package:flutter/material.dart';
import 'models.dart';
import 'releasePage.dart';

void main() {
  runApp(VinylsApp());
}

class VinylsApp extends StatefulWidget {
  @override
  _VinylsAppState createState() => _VinylsAppState();
}

class _VinylsAppState extends State<VinylsApp> {
  final _controller = TextEditingController();
  List<Release> _vinskat = [];
  Release _selectedRelease;
  List<Release> _filtered = [];

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
    return MaterialApp(
      title: 'Vinskat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: Navigator(
        pages: [
          MaterialPage(
            key: ValueKey('ReleaseListPage'),
            child: _listing(),
          ),
        ],
        onPopPage: (route, result) => route.didPop(result),
      ),
    );
  }

  Widget _listing() {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mikon vinskat'),
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
                  return _listItem(_filtered[index], context);
                  /*
                  return Container(
                    height: 40,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              _filtered[index].artist,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Expanded(
                            child: TextButton(
                              child: Text(
                                _filtered[index].title +
                                    "  " +
                                    _filtered[index].year.toString(),
                                textAlign: TextAlign.center,
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) {
                                    return ReleaseDetailsScreen(
                                        release: _filtered[index]);
                                  }),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                  */
                },
              ),
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _listItem(Release release, BuildContext context) {
    String horseUrl = 'https://i.stack.imgur.com/Dw6f7.png';
    return ListTile(
      title: Text(release.title),
      subtitle: Text(release.artist),
      trailing: Text(release.year.toString()),
      contentPadding: EdgeInsets.symmetric(horizontal: 30.0),
      onLongPress: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) {
            return ReleaseDetailsScreen(releaseId: release.id);
          }),
        );
      },
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
