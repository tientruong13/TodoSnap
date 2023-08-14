// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:task_app/Functions/option/vibration.dart';
import 'package:task_app/widget/animated_top_to_bottom_widget.dart';

class ImageTitleForAdd extends StatefulWidget {
  ImageTitleForAdd({
    Key? key,
    required this.imagePaths,
    required this.index,
    required this.onPressed,
  }) : super(key: key);

  final List<String> imagePaths;

  final int index;
  final void Function() onPressed;

  @override
  State<ImageTitleForAdd> createState() => _ImageTitleForAddState();
}

class _ImageTitleForAddState extends State<ImageTitleForAdd> {
  void viewImage(BuildContext context, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              PhotoViewGallery.builder(
                itemCount: widget.imagePaths.length,
                builder: (BuildContext context, int index) {
                  return PhotoViewGalleryPageOptions(
                    imageProvider: FileImage(File(widget.imagePaths[index])),
                    initialScale: PhotoViewComputedScale.contained,
                    heroAttributes: PhotoViewHeroAttributes(
                        tag: 'imageHero${widget.index}'),
                  );
                },
                pageController: PageController(initialPage: index),
                onPageChanged: (index) {
                  vibrateForAhalfSeconds();
                },
                backgroundDecoration: BoxDecoration(color: Colors.black),
              ),
              SafeArea(
                child: TopToBottomWidget(
                  index: 1,
                  child: Container(
                    height: 8.h,
                    width: 100.w,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Ionicons.chevron_back,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        vibrateForAhalfSeconds();
        viewImage(context, widget.index);
      },
      child: Hero(
        tag: 'imageHero${widget.index}',
        child: Container(
          height: 15.w,
          width: 15.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.w),
            image: DecorationImage(
              image: FileImage(File(widget.imagePaths[widget.index])),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                  top: 0,
                  right: 0,
                  child: IconButton(
                    onPressed: widget.onPressed,
                    icon: Icon(Icons.cancel, size: 6.w, color: Colors.red),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
