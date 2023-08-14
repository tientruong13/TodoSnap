// ignore_for_file: unused_local_variable

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:rxdart/rxdart.dart';
import 'package:task_app/widget/color.dart';

class CustomPage extends StatefulWidget {
  @override
  _CustomPageState createState() => _CustomPageState();

  /// Leading: A widget to display before the toolbar's title.
  final Widget? leading;

  /// Title: A Widget to display title in AppBar
  final Widget title;

  /// Center Title: Allows toggling of title from the center. By default title is in the center.
  final bool centerTitle;

  /// Action: A list of Widgets to display in a row after the title widget.
  final List<Widget>? actions;

  /// Always Show Leading And Action : This make Leading and Action always visible. Default value is false.
  final bool alwaysShowLeadingAndAction;

  /// Always Show Title : This make Title always visible. Default value is false.
  final bool alwaysShowTitle;

  /// Drawer: Drawers are typically used with the Scaffold.drawer property.
  final Widget? drawer;

  /// Header Expanded Height : Height of the header widget. The height is a double between 0.0 and 1.0. The default value of height is 0.35 and should be less than stretchMaxHeigh
  final double headerExpandedHeight;

  /// Header Widget: A widget to display Header above body.
  final Widget headerWidget;

  /// headerBottomBar: AppBar or toolBar like widget just above the body.

  final Widget? headerBottomBar;

  /// backgroundColor: The color of the Material widget that underlies the entire DraggableHome body.
  final Color? backgroundColor;

  /// appBarColor: The color of the scaffold app bar.
  final Color? appBarColor;

  /// curvedBodyRadius: Creates a border top left and top right radius of body, Default radius of the body is 20.0. For no radius simply set value to 0.
  final double curvedBodyRadius;

  /// body: A widget to Body
  final List<Widget> body;

  /// fullyStretchable: Allows toggling of fully expand draggability of the DraggableHome. Set this to true to allow the user to fully expand the header.
  final bool fullyStretchable;

  /// stretchTriggerOffset: The offset of overscroll required to fully expand the header.
  final double stretchTriggerOffset;

  /// expandedBody: A widget to display when fully expanded as header or expandedBody above body.
  final Widget? expandedBody;

  /// stretchMaxHeight: Height of the expandedBody widget. The height is a double between 0.0 and 0.95. The default value of height is 0.9 and should be greater than headerExpandedHeight
  final double stretchMaxHeight;

  /// floatingActionButton: An object that defines a position for the FloatingActionButton based on the Scaffold's ScaffoldPrelayoutGeometry.
  final Widget? floatingActionButton;

  /// bottomSheet: A persistent bottom sheet shows information that supplements the primary content of the app. A persistent bottom sheet remains visible even when the user interacts with other parts of the app.
  final Widget? bottomSheet;

  /// bottomNavigationBarHeight: This is requires when using custom height to adjust body height. This make no effect on bottomNavigationBar.
  final double? bottomNavigationBarHeight;

  /// bottomNavigationBar: Snack bars slide from underneath the bottom navigation bar while bottom sheets are stacked on top.
  final Widget? bottomNavigationBar;

  /// floatingActionButtonLocation: An object that defines a position for the FloatingActionButton based on the Scaffold's ScaffoldPrelayoutGeometry.
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  /// floatingActionButtonAnimator: Provider of animations to move the FloatingActionButton between FloatingActionButtonLocations.
  final FloatingActionButtonAnimator? floatingActionButtonAnimator;

  final ScrollPhysics? physics;

  final bool? switchWidget;

  /// This will create DraggableHome.
  const CustomPage(
      {Key? key,
      this.switchWidget = true,
      this.leading,
      required this.title,
      this.centerTitle = true,
      this.actions,
      this.alwaysShowLeadingAndAction = false,
      this.alwaysShowTitle = false,
      this.headerExpandedHeight = 0.35,
      required this.headerWidget,
      this.headerBottomBar,
      this.backgroundColor,
      this.appBarColor,
      this.curvedBodyRadius = 20,
      required this.body,
      this.drawer,
      this.fullyStretchable = false,
      this.stretchTriggerOffset = 80,
      this.expandedBody,
      this.stretchMaxHeight = 0.9,
      this.bottomSheet,
      this.bottomNavigationBarHeight = kBottomNavigationBarHeight,
      this.bottomNavigationBar,
      this.floatingActionButton,
      this.floatingActionButtonLocation,
      this.floatingActionButtonAnimator,
      this.physics})
      : assert(headerExpandedHeight > 0.0 &&
            headerExpandedHeight < stretchMaxHeight),
        assert(
          (stretchMaxHeight > headerExpandedHeight) && (stretchMaxHeight < .95),
        ),
        super(key: key);
}

class _CustomPageState extends State<CustomPage> {
  final BehaviorSubject<bool> isFullyExpanded =
      BehaviorSubject<bool>.seeded(false);
  final BehaviorSubject<bool> isFullyCollapsed =
      BehaviorSubject<bool>.seeded(false);

  @override
  void dispose() {
    isFullyExpanded.close();
    isFullyCollapsed.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double appBarHeight = AppBar().preferredSize.height + 1.h;

    final double topPadding = MediaQuery.of(context).padding.top;

    final double expandedHeight = 100.h * widget.headerExpandedHeight;

    final double fullyExpandedHeight = 100.h * (widget.stretchMaxHeight);

    return SafeArea(
      child: Scaffold(
        backgroundColor:
            widget.backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
        drawer: widget.drawer,
        body: NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            if (notification.metrics.axis == Axis.vertical) {
              // isFullyCollapsed
              if ((isFullyExpanded.value) &&
                  notification.metrics.extentBefore > 100) {
                isFullyExpanded.add(false);
              }
              //isFullyCollapsed
              if (notification.metrics.extentBefore >
                  expandedHeight - AppBar().preferredSize.height - 40) {
                if (!(isFullyCollapsed.value)) isFullyCollapsed.add(true);
              } else {
                if ((isFullyCollapsed.value)) isFullyCollapsed.add(false);
              }
            }
            return false;
          },
          child: sliver(context, appBarHeight, fullyExpandedHeight,
              expandedHeight, topPadding, widget.switchWidget!),
        ),
        bottomSheet: widget.bottomSheet,
        bottomNavigationBar: widget.bottomNavigationBar,
        floatingActionButtonLocation: widget.floatingActionButtonLocation,
        floatingActionButtonAnimator: widget.floatingActionButtonAnimator,
        floatingActionButton: StreamBuilder<List<bool>>(
            stream: CombineLatestStream.list<bool>([
              isFullyCollapsed.stream,
              isFullyExpanded.stream,
            ]),
            builder:
                (BuildContext context, AsyncSnapshot<List<bool>> snapshot) {
              final List<bool> streams = (snapshot.data ?? [false, false]);
              final bool fullyCollapsed = streams[0];
              final bool fullyExpanded = streams[1];
              return Opacity(
                opacity: fullyExpanded ? 0.0 : 1.0,
                child: widget.floatingActionButton,
              );
            }),
      ),
    );
  }

  CustomScrollView sliver(
    BuildContext context,
    double appBarHeight,
    double fullyExpandedHeight,
    double expandedHeight,
    double topPadding,
    bool switchWidget,
  ) {
    return CustomScrollView(
      physics: widget.physics ?? const BouncingScrollPhysics(),
      slivers: [
        StreamBuilder<List<bool>>(
          stream: CombineLatestStream.list<bool>([
            isFullyCollapsed.stream,
            isFullyExpanded.stream,
          ]),
          builder: (BuildContext context, AsyncSnapshot<List<bool>> snapshot) {
            final List<bool> streams = (snapshot.data ?? [false, false]);
            final bool fullyCollapsed = streams[0];
            final bool fullyExpanded = streams[1];

            return SliverAppBar(
              backgroundColor:
                  !fullyCollapsed ? widget.backgroundColor : widget.appBarColor,
              leading: widget.alwaysShowLeadingAndAction
                  ? widget.leading
                  : !fullyCollapsed
                      ? const SizedBox()
                      : widget.leading,
              actions: widget.alwaysShowLeadingAndAction
                  ? widget.actions
                  : !fullyCollapsed
                      ? []
                      : widget.actions,
              shadowColor: Colors.grey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(6.w),
                ),
              ),
              elevation: 5,
              pinned: true,
              stretch: true,
              centerTitle: widget.centerTitle,
              title: widget.alwaysShowTitle
                  ? widget.title
                  : AnimatedOpacity(
                      opacity: fullyCollapsed ? 1 : 0,
                      duration: const Duration(milliseconds: 100),
                      child: widget.title,
                    ),
              collapsedHeight: appBarHeight,
              expandedHeight:
                  fullyExpanded ? fullyExpandedHeight : expandedHeight,
              flexibleSpace: Stack(
                children: [
                  FlexibleSpaceBar(
                    background: Container(
                      margin: const EdgeInsets.only(bottom: 0.2),
                      child: fullyExpanded
                          ? (widget.expandedBody ?? const SizedBox())
                          : widget.headerWidget,
                    ),
                  ),
                  Positioned(
                    bottom: -2.w,
                    left: 0,
                    right: 0,
                    child: widget.switchWidget == true
                        ? AnimatedOpacity(
                            duration: const Duration(milliseconds: 100),
                            opacity: fullyCollapsed ? 0.0 : 1.0,
                            child: roundedCorner(context),
                          )
                        : Container(),
                  ),
                  Positioned(
                    bottom: 2.w,
                    left: 0,
                    right: 0,
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 100),
                      opacity: fullyCollapsed ? 0.0 : 1.0,
                      child: expandedUpArrow(),
                    ),
                  ),
                  Positioned(
                    bottom: -2.w,
                    child: AnimatedContainer(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      curve: Curves.easeInOutCirc,
                      duration: const Duration(milliseconds: 100),
                      height: fullyCollapsed
                          ? 0
                          : fullyExpanded
                              ? 0
                              : kToolbarHeight,
                      width: MediaQuery.of(context).size.width,
                      child: fullyCollapsed
                          ? const SizedBox()
                          : fullyExpanded
                              ? const SizedBox()
                              : widget.headerBottomBar ?? Container(),
                    ),
                  )
                ],
              ),
              stretchTriggerOffset: widget.stretchTriggerOffset,
              onStretchTrigger: widget.fullyStretchable
                  ? () async {
                      if (!fullyExpanded) isFullyExpanded.add(true);
                    }
                  : null,
            );
          },
        ),
        sliverList(context, appBarHeight + topPadding),
      ],
    );
  }

  Container roundedCorner(BuildContext context) {
    return Container(
      height: 5.h,
      decoration: BoxDecoration(
        color:
            widget.backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.w),
          topRight: Radius.circular(10.w),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2), //Color of Shadow
            spreadRadius: 5, // Spread radius
            blurRadius: 5, // Blur radius
            offset: Offset(0, 0), // changes position of shadow
          ),
        ],
      ),
    );
  }

  SliverList sliverList(BuildContext context, double topHeight) {
    final double bottomPadding =
        widget.bottomNavigationBar == null ? 0 : kBottomNavigationBarHeight;
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height -
                    topHeight -
                    bottomPadding,
                color: widget.backgroundColor ??
                    Theme.of(context).scaffoldBackgroundColor,
              ),
              Column(
                children: [
                  //Body
                  ...widget.body
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  StreamBuilder<bool> expandedUpArrow() {
    return StreamBuilder<bool>(
      stream: isFullyExpanded.stream,
      builder: (context, snapshot) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          height: (snapshot.data ?? false) ? 10 : 0,
          width: MediaQuery.of(context).size.width,
          child: Center(
              child: Container(
            height: 1.w,
            width: 8.w,
            decoration: BoxDecoration(
                color: accentColor(context),
                borderRadius: BorderRadius.circular(50)),
          )),
        );
      },
    );
  }
}
