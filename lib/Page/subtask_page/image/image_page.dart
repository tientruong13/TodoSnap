import 'package:flutter/material.dart';
import 'package:task_app/Model/subtask_model.dart';
import 'package:task_app/Page/subtask_page/image/image_title.dart';

class ImageGridView extends StatefulWidget {
  final List<String> imagePaths;
  final SubTaskModel subTask;

  ImageGridView({
    Key? key,
    required this.imagePaths,
    required this.subTask,
  }) : super(key: key);

  @override
  State<ImageGridView> createState() => _ImageGridViewState();
}

class _ImageGridViewState extends State<ImageGridView> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: widget.imagePaths.length,
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // You can modify the number of columns here
        crossAxisSpacing: 4.0,
        mainAxisSpacing: 4.0,
      ),
      itemBuilder: (BuildContext context, int index) {
        return ImageTitle(
          imagePaths: widget.imagePaths,
          index: index,
        );

        // GestureDetector(
        //   onTap: () => viewImage(context, index),
        //   child: Stack(
        //     children: [
        //       Container(
        //           height: 100,
        //           width: 100,
        //           decoration: BoxDecoration(
        //             image: DecorationImage(
        //               image: FileImage(File(widget.imagePaths[index])),
        //               fit: BoxFit.cover,
        //             ),
        //           )),
        //       Positioned(
        //           child: IconButton(
        //         onPressed: () async {
        //           widget.onDelete(index, widget.subTask);
        //         },
        //         icon: Icon(Icons.close, color: Colors.red),
        //       ))
        //     ],
        //   ),
        // );
      },
    );
  }
}
