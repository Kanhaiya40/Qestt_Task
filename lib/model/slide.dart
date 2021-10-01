import 'package:flutter/cupertino.dart';

class Slide {
  final String imageUrl;
  final String title;
  final String description;

  Slide({
    @required this.imageUrl,
    @required this.title,
    @required this.description,
  });

  static List<Slide> slides = [
    Slide(
      imageUrl: 'assets/images/introimage_a.png',
      title: 'Gamified Homework',
      description: 'Student can compete with friends in real time and can win',
    ),
    Slide(
      imageUrl: 'assets/images/introimage_b.png',
      title: 'Assign HomeWork Instantly',
      description: 'Teachers can choose from 50000+ predefined questions',
    ),
    Slide(
      imageUrl: 'assets/images/introimage_c.png',
      title: 'From marks to mastery',
      description: 'Students can attain identify learning patterns and attain mastery by reinforcement learning',
    ),
  ];
}
