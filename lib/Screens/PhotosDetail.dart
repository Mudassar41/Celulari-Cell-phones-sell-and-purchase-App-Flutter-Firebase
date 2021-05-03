import 'package:flutter/material.dart';

class PhotosDetail extends StatefulWidget {
  final String Image;

  const PhotosDetail({Key key, this.Image}) : super(key: key);

  @override
  _PhotosDetailState createState() => _PhotosDetailState();
}

class _PhotosDetailState extends State<PhotosDetail> {
  final TransformationController _transformationController =
      TransformationController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF00a651),
      ),
      body: SafeArea(
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * .7,
            child: Card(
              clipBehavior: Clip.antiAlias,
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: InteractiveViewer(
                transformationController: _transformationController,
                onInteractionEnd: (details) {
                  _transformationController.value = Matrix4.identity();
                },
                child: Image.network(
                  widget.Image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
