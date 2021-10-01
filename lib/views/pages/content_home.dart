import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:questt/helper/apis.dart';
import 'package:questt/helper/session.dart';
import 'package:questt/helper/string.dart';
import 'package:questt/model/chapter_response.dart';
import 'package:questt/model/subject_response.dart';
import 'package:questt/model/subjet_prop.dart';

class HomeContentPage extends StatefulWidget {
  const HomeContentPage({Key key}) : super(key: key);

  @override
  _HomeContentPageState createState() => _HomeContentPageState();
}

class _HomeContentPageState extends State<HomeContentPage> {
  String token;
  String name;
  var getSubject;
  var getChapter;
  bool _isLoading = true;
  List<Data> subjectData;
  List<ChapterData> chapterData;

  List<Subject> subjectList = [];

  void initState() {
    super.initState();
    getUserDetails();
    getSubjectWiseData();
    debugPrint('subjectList:$subjectList');
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void getSubjectWiseData() async {
    await getAllSubjectWithChapters();
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> getAllSubjectWithChapters() async {
    String upDatedtoken = await getPrefrence(TOKEN);
    var data = {AUTH: 'bearer $upDatedtoken'};
    try {
      Response response = await get(getSubjectApi, headers: data)
          .timeout(Duration(seconds: timeOut));

      if (response.statusCode == 200) {
        var getdata = json.decode(response.body);
        int code = getdata["code"];
        String msg = getdata["status"];

        if (code == 200) {
          await Future.delayed(Duration(seconds: 3)).then((_) async {
            SubjectData subjectWiseData = SubjectData.fromJson(getdata);
            subjectData = await subjectWiseData.data;
            for (Data eachSubject in subjectData) {
              Response response =
              await get(getChapterApi(eachSubject.id), headers: data)
                  .timeout(Duration(seconds: timeOut));

              if (response.statusCode == 200) {
                var getdata = json.decode(response.body);
                int code = getdata["code"];
                String msg = getdata["status"];

                if (code == 200) {
                  await Future.delayed(Duration(seconds: 3)).then((_) async {
                    SubJectWiseChapter subJectWiseChapter =
                    SubJectWiseChapter.fromJson(getdata);
                    chapterData = subJectWiseChapter.data[0].data;

                    subjectList.add(Subject(
                        name: subJectWiseChapter.data[0].subejct,
                        data: chapterData));

                    if(mounted){
                      setState(() {
                        _isLoading = false;
                      });
                    }
                  });
                }
              }
            }
          });
        } else {
          setSnackbar(msg);
        }
      }
    } on TimeoutException catch (_) {
      setSnackbar(WENT_WRONG);
    }
  }

  setSnackbar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
      content: new Text(
        msg,
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.teal,
      elevation: 1.0,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(
      child: CircularProgressIndicator(),
    )
        : Column(
      children: [
        Expanded(
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: [
              Padding(
                  padding: EdgeInsets.all(15),
                  child: Container(
                    height: MediaQuery
                        .of(context)
                        .size
                        .height,
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    child: ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: subjectList.length,
                        itemBuilder: (context, index) {
                          return buildContentLayout(subjectList[index]);
                        }),
                  ))
            ],
          ),
        )
      ],
    );
  }

  void getUserDetails() async {
    token = await getPrefrence(TOKEN);
    name = await getPrefrence(USERNAME);

    if (mounted) {
      setState(() {});
    }
  }

  Widget buildContentLayout(Subject subjectList) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.comment),
            SizedBox(
              width: 10,
            ),
            Text(subjectList.name)
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          height: 200,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: BouncingScrollPhysics(),
              itemCount: subjectList.data.length,
              itemBuilder: (context, index) {
                return buildChapter(subjectList.data[index]);
              }),
        )
      ],
    );
  }

  Widget buildChapter(ChapterData data) {
    return Container(
      margin: EdgeInsets.only(left: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      height: 200,
      width: 200,
      child: Column(
        children: [
          Image.asset(
            'assets/images/introimage_a.png',
            height: 120,
            width: 120,
            fit: BoxFit.cover,
          ),
          SizedBox(
            height: 10,
          ),
          Text(data.title)
        ],
      ),
    );
  }
}
