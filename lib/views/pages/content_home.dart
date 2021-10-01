import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:questt/helper/apis.dart';
import 'package:questt/helper/session.dart';
import 'package:questt/helper/string.dart';
import 'package:questt/model/chapter_response.dart';
import 'package:questt/model/subject_response.dart';

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
  var resultHashMap = HashMap<String, List<ChapterData>>();

  void initState() {
    super.initState();
    getUserDetails();
    getAllSubjectWithChapters()
        .then((value) => {
          if(this.mounted) {
            this.setState(() {

            })
          }
    }).onError((error, stackTrace) => {});
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
            SubjectData subjectData = SubjectData.fromJson(getdata);
            subjectData.data.forEach((element) async {
              getAllChapter(element.id).then((subjectData) => {
                    if (subjectData != null)
                      {
                        resultHashMap.putIfAbsent(
                            subjectData.subejct, () => subjectData.data)
                      }
                  });
            });

            setState(() {
              _isLoading = false;
            });
          });
        } else {
          setSnackbar(msg);
        }
      }
    } on TimeoutException catch (_) {
      setSnackbar('somethingMSg');
    }
  }

  Future<SubJectData> getAllChapter(String id) async {
    String upDatedtoken = await getPrefrence(TOKEN);
    var data = {AUTH: 'bearer $upDatedtoken'};

    try {
      Response response = await get(getChapterApi(id), headers: data)
          .timeout(Duration(seconds: timeOut));

      if (response.statusCode == 200) {
        var getdata = json.decode(response.body);
        int code = getdata["code"];
        String msg = getdata["status"];

        if (code == 200) {
          await Future.delayed(Duration(seconds: 3)).then((_) async {
            SubJectWiseChapter subJectWiseChapter =
                SubJectWiseChapter.fromJson(getdata);
            return Future.value(subJectWiseChapter.data[0]);
          });
        } else {
          return Future.error("Not able to load");
        }
      }
    } on TimeoutException catch (_) {
      return Future.error("Not able to load");
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
        ? Center(child: CircularProgressIndicator())
        : Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(15),
                      child: Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          itemCount: resultHashMap.length,
                          itemBuilder: (context, index) {
                            debugPrint("Build : ${resultHashMap.toString()}");
                            var dataWithList =
                                resultHashMap.entries.elementAt(index);
                            return buildLayout(
                                dataWithList.value, dataWithList.key);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          );
  }

  Widget buildLayout(List<ChapterData> listOfChapterData, String subjectName) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.comment_outlined),
              SizedBox(
                width: 10,
              ),
              Text(subjectName)
            ],
          ),
          SizedBox(
            height: 20,
          ),
          getChaterLayout(context, listOfChapterData),
        ],
      ),
    );
  }

  Widget buldChapterLayout(ChapterData cd) {
    return Padding(
      padding: const EdgeInsets.only(left: 30),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(30)),
        height: 200,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.network(
              cd.photoUrl,
              height: 100,
              width: 100,
              fit: BoxFit.cover,
            ),
            Text(cd.title)
          ],
        ),
      ),
    );
  }

  void getUserDetails() async {
    token = await getPrefrence(TOKEN);
    name = await getPrefrence(USERNAME);

    if (mounted) {
      setState(() {});
    }
  }

  getChaterLayout(BuildContext context, List<ChapterData> data) {
    return Container(
      height: 200,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          physics: BouncingScrollPhysics(),
          itemCount: data.length,
          itemBuilder: (BuildContext context, int index) {
            return buldChapterLayout(data[index]);
          }),
    );
  }
}
