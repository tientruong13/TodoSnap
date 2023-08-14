import 'package:flutter/material.dart';
import 'package:task_app/Functions/add_image/image_title.dart';
import 'package:task_app/Functions/option/vibration.dart';
import 'package:task_app/Model/subtask_model.dart';

class ImageGridViewForAdd extends StatefulWidget {
  final List<String> imagePaths;
  final SubTaskModel subTask;
  final Function(int index, SubTaskModel subTask) onDelete;

  ImageGridViewForAdd({
    Key? key,
    required this.imagePaths,
    required this.subTask,
    required this.onDelete,
  }) : super(key: key);

  @override
  State<ImageGridViewForAdd> createState() => _ImageGridViewForAddState();
}

class _ImageGridViewForAddState extends State<ImageGridViewForAdd> {
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
        return ImageTitleForAdd(
          imagePaths: widget.imagePaths,
          index: index,
          // onPressed: widget.onPressed
          onPressed: () async {
            vibrateForAhalfSeconds();
            widget.onDelete(index, widget.subTask);
          },
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

// class Imagepage extends StatelessWidget {
//   const Imagepage({
//     Key? key,
//     required this.task,
//     this.pickedImage,
//   }) : super(key: key);

//   final TaskModel task;
//   final String? pickedImage;

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<SubTaskDataProvider>(
//         builder: (context, subTaskProvider, _) {
//       List<SubTaskModel> filteredSubTasks = subTaskProvider.getSubTaskList
//           .where((it) => it.parent == task.id && it.imagePath != null)
//           .toList();

//       List<ImageProvider<Object>> images = filteredSubTasks
//           .map((subTask) => FileImage(File(subTask.imagePath!)))
//           .toList();

//       // Add the picked image to the list of images if it's available
//       if (pickedImage != null) {
//         images.add(FileImage(File(pickedImage!)));
//       }

//       if (images.isEmpty) {
//         return Container();
//       } else {
//         return GridView.builder(
//             itemCount: images
//                 .length, // Update the itemCount to match the length of the images list
//             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 3,
//               crossAxisSpacing: 4,
//               mainAxisSpacing: 4,
//             ),
//             itemBuilder: (BuildContext context, int index) {
//               final photo = filteredSubTasks[index];
//               return ImageTitle(
//                 images: images,
//                 currentIndex: index,
//                 onPressed: () {
//                   subTaskProvider.deleteImage(photo.imagePath!, photo);
//                 },
//               );
//             });
//       }
//     });
//   }
// }
