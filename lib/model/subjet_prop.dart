import 'package:questt/model/chapter_response.dart';

class Subject {
  String name;
  List<ChapterData> data;

  @override
  String toString() {
    return 'Subject{name: $name, data: $data}';
  }

  Subject({this.name, this.data});
}
