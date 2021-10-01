import 'package:flutter/material.dart';
import 'package:questt/model/slide.dart';

class SlideItems extends StatelessWidget {
  final int index;
  List<Slide> slider = Slide.slides;

  SlideItems({Key key, this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 30,
          ),
          Text(
            slider[index].title,
            style: TextStyle(
                color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            slider[index].description,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
          SizedBox(
            height: 30,
          ),
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: AssetImage(slider[index].imageUrl),
                    fit: BoxFit.cover)),
          )
        ],
      ),
    );
  }
}
