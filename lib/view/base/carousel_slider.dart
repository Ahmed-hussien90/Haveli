import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class CarouselSlider extends StatefulWidget {
  const CarouselSlider({
    Key? key,
    required this.items,
  }) : super(key: key);

  final List<dynamic> items;

  @override
  State<CarouselSlider> createState() => _CarouselSliderState();
}

class _CarouselSliderState extends State<CarouselSlider> {
  int newIndex = 0;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Column(
      children: [
        SizedBox(
          height: height * 0.35,
          child: PageView.builder(
            itemCount: widget.items.length,
            onPageChanged: (int currentIndex) {
              newIndex = currentIndex;
              setState(() {});
            },
            itemBuilder: (_, index) {
              return CachedNetworkImage(
                imageUrl: widget.items[index],
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: imageProvider, fit: BoxFit.fill),
                  ),
                ),
                placeholder: (context, url) =>
                const SpinKitFadingCircle(color: Colors.red),
                errorWidget: (context, url, error) =>
                const Icon(Icons.error),
              );
            },
          ),
        ),
        SmoothIndicator(
          effect:  const WormEffect(
            dotColor: Colors.white,
            activeDotColor: Colors.deepOrange,
          ),
          offset: newIndex.toDouble(),
          count: widget.items.length, size: const Size(70, 20),
        )
      ],
    );
  }
}
