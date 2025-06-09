import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

/// for bottom dot position
enum DotPosition {
  topLeft,
  topCenter,
  topRight,
  bottomLeft,
  bottomCenter,
  bottomRight
}

/// Carousel Widget
class Caroulina extends StatefulWidget {
  ///All the images on this Carousel.
  final List images;

  ///All the images on this Carousel.
  // ignore: prefer_typing_uninitialized_variables
  final defaultImage;

  ///The transition animation timing curve. Default is [Curves.ease]
  final Curve animationCurve;

  ///The transition animation duration. Default is 300ms.
  final Duration animationDuration;

  /// The base size of the dots. Default is 8.0
  final double dotSize;

  /// The increase in the size of the selected dot. Default is 2.0
  final double dotIncreaseSize;

  /// The distance between the center of each dot. Default is 25.0
  final double dotSpacing;

  /// The Color of each dot. Default is Colors.white
  final Color dotColor;

  /// The background Color of the dots. Default is [Colors.grey[800].withOpacity(0.5)]
  final Color? dotBgColor;

  /// The Color of each increased dot. Default is Colors.white
  final Color dotIncreasedColor;

  /// Enable or Disable the indicator (dots). Default is true
  final bool showIndicator;

  ///Padding Size of the background Indicator. Default is 20.0
  final double indicatorBgPadding;

  ///How to show the images in the box. Default is cover
  final BoxFit boxFit;

  ///Enable/Disable radius Border for the images. Default is false
  final bool borderRadius;

  ///Border Radius of the images. Default is [Radius.circular(8.0)]
  final Radius? radius;

  ///Indicator position. Default bottomCenter
  final DotPosition dotPosition;

  ///Move the Indicator Horizontally relative to the dot position
  final double dotHorizontalPadding;

  ///Move the Indicator Vertically relative to the dot position
  final double dotVerticalPadding;

  ///Move the Indicator From the Bottom
  final double moveIndicatorFromBottom;

  ///Remove the radius bottom from the indicator background. Default false
  final bool noRadiusForIndicator;

  ///Enable/Disable Image Overlay Shadow. Default false
  final bool overlayShadow;

  ///Choose the color of the overlay Shadow color. Default Colors.grey[800]
  final Color? overlayShadowColors;

  ///Choose the size of the Overlay Shadow, from 0.0 to 1.0. Default 0.5
  final double overlayShadowSize;

  ///Enable/Disable the auto play of the slider. Default true
  final bool autoplay;

  ///Duration of the Auto play slider by seconds. Default 3 seconds
  final Duration autoplayDuration;

  /// Pause autoplay when user interacts with carousel. Default true
  final bool pauseOnInteraction;

  /// Duration to resume autoplay after interaction stops. Default 3 seconds
  final Duration resumePlayDelay;

  /// Enable dynamic dot sizing based on distance from active dot. Default false
  final bool dynamicDots;

  /// List of overlay texts for each slide (optional)
  final List<String>? overlayTexts;

  /// Style for overlay text
  final TextStyle? overlayTextStyle;

  /// Position of overlay text
  final Alignment overlayTextAlignment;

  /// Background color for overlay text
  final Color? overlayTextBackground;

  /// Padding for overlay text
  final EdgeInsets overlayTextPadding;

  /// List of URLs or page routes for each slide (optional)
  final List<String>? slideLinks;

  /// Callback when a slide link is tapped
  final void Function(String link, int index)? onLinkTap;

  ///On image tap event, passes current image index as an argument
  final void Function(int)? onImageTap;

  ///On image change event, passes previous image index and current image index as arguments
  final void Function(int, int)? onImageChange;

  /// Callback when autoplay is paused
  final VoidCallback? onAutoplayPaused;

  /// Callback when autoplay is resumed
  final VoidCallback? onAutoplayResumed;

  /// Callback when user starts interacting with carousel
  final VoidCallback? onInteractionStart;

  /// Callback when user stops interacting with carousel
  final VoidCallback? onInteractionEnd;

  //// Default constructor
  const Caroulina({
    super.key,
    required this.images,
    this.animationCurve = Curves.ease,
    this.animationDuration = const Duration(milliseconds: 1000),
    this.dotSize = 8.0,
    this.dotSpacing = 25.0,
    this.dotIncreaseSize = 2.0,
    this.dotColor = Colors.white,
    this.dotBgColor,
    this.dotIncreasedColor = Colors.white,
    this.showIndicator = true,
    this.indicatorBgPadding = 20.0,
    this.boxFit = BoxFit.cover,
    this.borderRadius = false,
    this.radius,
    this.dotPosition = DotPosition.bottomCenter,
    this.dotHorizontalPadding = 0.0,
    this.dotVerticalPadding = 0.0,
    this.moveIndicatorFromBottom = 0.0,
    this.noRadiusForIndicator = false,
    this.overlayShadow = false,
    this.overlayShadowColors,
    this.overlayShadowSize = 0.5,
    this.autoplay = true,
    this.autoplayDuration = const Duration(seconds: 3),
    this.pauseOnInteraction = true,
    this.resumePlayDelay = const Duration(seconds: 3),
    this.dynamicDots = false,
    this.overlayTexts,
    this.overlayTextStyle,
    this.overlayTextAlignment = Alignment.bottomLeft,
    this.overlayTextBackground,
    this.overlayTextPadding = const EdgeInsets.all(16.0),
    this.slideLinks,
    this.onLinkTap,
    this.defaultImage,
    required this.onImageChange,
    this.onImageTap,
    this.onAutoplayPaused,
    this.onAutoplayResumed,
    this.onInteractionStart,
    this.onInteractionEnd,
  });

  @override
  State createState() => _CaroulinaState();
}

/// private state class for Caroulina
class _CaroulinaState extends State<Caroulina> {
  int _currentImageIndex = 0;
  final PageController _controller = PageController();
  Timer? _autoplayTimer;
  Timer? _resumeTimer;
  bool _isAutoplayPaused = false;

  @override
  void initState() {
    super.initState();
    if (widget.autoplay) {
      _startAutoplay();
    }
  }

  void _startAutoplay() {
    _autoplayTimer?.cancel();
    _autoplayTimer = Timer.periodic(widget.autoplayDuration, (_) {
      if (_controller.hasClients && !_isAutoplayPaused) {
        if (_controller.page?.round() == widget.images.length - 1) {
          _controller.animateToPage(
            0,
            duration: widget.animationDuration,
            curve: widget.animationCurve,
          );
        } else {
          _controller.nextPage(
              duration: widget.animationDuration, curve: widget.animationCurve);
        }
      }
    });
  }

  void _pauseAutoplay() {
    if (!_isAutoplayPaused && widget.pauseOnInteraction) {
      setState(() {
        _isAutoplayPaused = true;
      });
      widget.onAutoplayPaused?.call();
      widget.onInteractionStart?.call();

      _resumeTimer?.cancel();
      _resumeTimer = Timer(widget.resumePlayDelay, () {
        _resumeAutoplay();
        widget.onInteractionEnd?.call();
      });
    }
  }

  void _resumeAutoplay() {
    if (_isAutoplayPaused && !widget.pauseOnInteraction) {
      setState(() {
        _isAutoplayPaused = false;
      });
      widget.onAutoplayResumed?.call();
    }
  }

  void _handleSlideInteraction(int index) {
    _pauseAutoplay();

    if (widget.slideLinks != null &&
        index < widget.slideLinks!.length &&
        widget.slideLinks![index].isNotEmpty) {
      widget.onLinkTap?.call(widget.slideLinks![index], index);
    } else {
      widget.onImageTap?.call(index);
    }
  }

  @override
  void dispose() {
    _autoplayTimer?.cancel();
    _resumeTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> listImages =
        widget.images.asMap().entries.map<Widget>((entry) {
      int index = entry.key;
      var netImage = entry.value;

      return AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          double value = 1.0;
          if (_controller.position.haveDimensions) {
            value = _controller.page! - _currentImageIndex;
            value = (1 - (value.abs() * .3)).clamp(0.0, 1.0);
          }
          return Transform.scale(
            scale: value,
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: widget.borderRadius
                        ? BorderRadius.all(
                            widget.radius ?? const Radius.circular(16.0))
                        : null,
                    image: DecorationImage(
                      image: netImage,
                      fit: widget.boxFit,
                    ),
                  ),
                  child: widget.overlayShadow
                      ? Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(16),
                                bottomRight: Radius.circular(16)),
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.center,
                              stops: [0.0, widget.overlayShadowSize],
                              colors: [
                                widget.overlayShadowColors != null
                                    ? widget.overlayShadowColors!
                                        .withOpacity(1.0)
                                    : Colors.grey[800]!.withOpacity(1.0),
                                widget.overlayShadowColors != null
                                    ? widget.overlayShadowColors!
                                        .withOpacity(0.0)
                                    : Colors.grey[800]!.withOpacity(0.0)
                              ],
                            ),
                          ),
                        )
                      : Container(),
                ),
                // Overlay text
                if (widget.overlayTexts != null &&
                    index < widget.overlayTexts!.length &&
                    widget.overlayTexts![index].isNotEmpty)
                  Positioned.fill(
                    child: Align(
                      alignment: widget.overlayTextAlignment,
                      child: Container(
                        padding: widget.overlayTextPadding,
                        decoration: BoxDecoration(
                          color: widget.overlayTextBackground?.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Text(
                          widget.overlayTexts![index],
                          style: widget.overlayTextStyle ??
                              const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      );
    }).toList();

    final bottom = [
      DotPosition.bottomLeft,
      DotPosition.bottomCenter,
      DotPosition.bottomRight
    ].contains(widget.dotPosition)
        ? widget.dotVerticalPadding
        : null;

    final top = [
      DotPosition.topLeft,
      DotPosition.topCenter,
      DotPosition.topRight
    ].contains(widget.dotPosition)
        ? widget.dotVerticalPadding
        : null;

    double? left = [DotPosition.topLeft, DotPosition.bottomLeft]
            .contains(widget.dotPosition)
        ? widget.dotHorizontalPadding
        : null;
    double? right = [DotPosition.topRight, DotPosition.bottomRight]
            .contains(widget.dotPosition)
        ? widget.dotHorizontalPadding
        : null;

    if (left == null && right == null) {
      left = right = 0.0;
    }

    return Stack(
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(16.0),
          child: Builder(
            builder: (_) {
              Widget pageView = PageView(
                physics: const AlwaysScrollableScrollPhysics(),
                controller: _controller,
                children: listImages,
                onPageChanged: (currentPage) {
                  if (widget.onImageChange != null) {
                    widget.onImageChange!(_currentImageIndex, currentPage);
                  }
                  _currentImageIndex = currentPage;
                },
              );

              return GestureDetector(
                child: pageView,
                onTap: () => _handleSlideInteraction(_currentImageIndex),
                onPanStart: (_) => _pauseAutoplay(),
              );
            },
          ),
        ),
        widget.showIndicator
            ? Positioned(
                bottom: bottom,
                top: top,
                left: left,
                right: right,
                child: Container(
                  decoration: BoxDecoration(
                    color:
                        widget.dotBgColor ?? Colors.grey[800]!.withOpacity(0.5),
                    borderRadius: widget.borderRadius
                        ? (widget.noRadiusForIndicator
                            ? null
                            : BorderRadius.only(
                                bottomLeft: widget.radius ??
                                    const Radius.circular(16.0),
                                bottomRight: widget.radius ??
                                    const Radius.circular(16.0)))
                        : null,
                  ),
                  padding: EdgeInsets.all(widget.indicatorBgPadding),
                  child: Center(
                    child: DotsIndicator(
                      controller: _controller,
                      itemCount: listImages.length,
                      color: widget.dotColor,
                      increasedColor: widget.dotIncreasedColor,
                      dotSize: widget.dotSize,
                      dotSpacing: widget.dotSpacing,
                      dotIncreaseSize: widget.dotIncreaseSize,
                      dynamicDots: widget.dynamicDots,
                      onPageSelected: (int page) {
                        _pauseAutoplay();
                        _controller.animateToPage(
                          page,
                          duration: widget.animationDuration,
                          curve: widget.animationCurve,
                        );
                      },
                    ),
                  ),
                ),
              )
            : Container(),
      ],
    );
  }
}

//// An indicator showing the currently selected page of a PageController
class DotsIndicator extends AnimatedWidget {
  const DotsIndicator({
    super.key,
    required this.controller,
    this.itemCount,
    this.onPageSelected,
    this.color,
    this.increasedColor,
    this.dotSize,
    this.dotIncreaseSize,
    this.dotSpacing,
    this.dynamicDots = false,
  }) : super(listenable: controller);

  /// The PageController that this DotsIndicator is representing.
  final PageController controller;

  /// The number of items managed by the PageController
  final int? itemCount;

  /// Called when a dot is tapped
  final ValueChanged<int>? onPageSelected;

  /// The color of the dots.
  final Color? color;

  /// The color of the increased dot.
  final Color? increasedColor;

  /// The base size of the dots
  final double? dotSize;

  /// The increase in the size of the selected dot
  final double? dotIncreaseSize;

  /// The distance between the center of each dot
  final double? dotSpacing;

  /// Enable dynamic dot sizing based on distance from active dot
  final bool dynamicDots;

  Widget _buildDot(int index) {
    double? currentPage = controller.hasClients
        ? (controller.page ?? controller.initialPage.toDouble())
        : null;

    double selectedness = currentPage != null
        ? Curves.easeOut.transform(
            max(
              0.0,
              1.0 - (currentPage - index).abs(),
            ),
          )
        : 0.0;

    double zoom;
    Color? dotColor;

    if (dynamicDots) {
      // Dynamic sizing based on distance from active dot
      double distance = currentPage != null ? (currentPage - index).abs() : 0.0;
      double dynamicScale = max(0.5, 1.0 - (distance * 0.3));
      zoom = (1.0 + (dotIncreaseSize! - 1.0) * selectedness) * dynamicScale;

      // Color transitions based on proximity
      if (distance <= 1.0) {
        double colorLerp = 1.0 - distance;
        dotColor = Color.lerp(color, increasedColor, colorLerp * selectedness);
      } else {
        dotColor = color?.withOpacity(dynamicScale);
      }
    } else {
      // Original behavior
      zoom = 1.0 + (dotIncreaseSize! - 1.0) * selectedness;
      dotColor = zoom > 1.0 ? increasedColor : color;
    }

    return SizedBox(
      width: dotSpacing,
      child: Center(
        child: Material(
          color: dotColor,
          type: MaterialType.circle,
          child: SizedBox(
            width: dotSize! * zoom,
            height: dotSize! * zoom,
            child: InkWell(
              onTap: () => onPageSelected!(index),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List<Widget>.generate(itemCount!, _buildDot),
    );
  }
}
