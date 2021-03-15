import 'package:flutter/material.dart';
import 'models.dart';

class ReleaseDetailsScreen extends StatelessWidget {
  final int releaseId;

  ReleaseDetailsScreen({this.releaseId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mikon vinskat'),
      ),
      body: FutureBuilder(
        future: fetchReleaseDetails(releaseId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return _releaseData(snapshot.data, context);
          } else {
            return Center(
              child: Image.asset('assets/loading.gif'),
            );
          }
        },
      ),
    );
  }

  Widget _releaseData(Release release, BuildContext context) {
    return Column(
      children: [
        FadeInImage.assetNetwork(
          placeholder: 'assets/loading.gif',
          image: release.imageUrl,
        ),
        Center(
          child: TextButton(
            child: Text(release.artist),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ],
    );
  }
}
