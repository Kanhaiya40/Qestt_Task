class SubJectWiseChapter {
  String status;

  @override
  String toString() {
    return 'SubJectWiseChapter{status: $status, message: $message, code: $code, data: $data}';
  }

  Null message;
  int code;
  List<SubJectData> data;

  SubJectWiseChapter({this.status, this.message, this.code, this.data});

  SubJectWiseChapter.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    code = json['code'];
    if (json['data'] != null) {
      data = new List<SubJectData>();
      json['data'].forEach((v) {
        data.add(new SubJectData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['code'] = this.code;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SubJectData {
  String subejct;
  String subject;
  String subjectId;
  String subjectImage;
  List<ChapterData> data;

  SubJectData(
      {this.subejct,
      this.subject,
      this.subjectId,
      this.subjectImage,
      this.data});

  @override
  String toString() {
    return 'SubJectData{subejct: $subejct, subject: $subject, subjectId: $subjectId, subjectImage: $subjectImage, data: $data}';
  }

  SubJectData.fromJson(Map<String, dynamic> json) {
    subejct = json['subejct'];
    subject = json['subject'];
    subjectId = json['subject_id'];
    subjectImage = json['subject_image'];
    if (json['data'] != null) {
      data = new List<ChapterData>();
      json['data'].forEach((v) {
        data.add(new ChapterData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['subejct'] = this.subejct;
    data['subject'] = this.subject;
    data['subject_id'] = this.subjectId;
    data['subject_image'] = this.subjectImage;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ChapterData {
  String id;
  String title;
  String photoUrl;
  int questCount;
  int isActive;
  int level;
  int studentActive;
  String type;

  @override
  String toString() {
    return 'ChapterData{id: $id, title: $title, photoUrl: $photoUrl, questCount: $questCount, isActive: $isActive, level: $level, studentActive: $studentActive, type: $type, orderingLevel: $orderingLevel, questionsCount: $questionsCount}';
  }

  int orderingLevel;
  int questionsCount;

  ChapterData(
      {this.id,
      this.title,
      this.photoUrl,
      this.questCount,
      this.isActive,
      this.level,
      this.studentActive,
      this.type,
      this.orderingLevel,
      this.questionsCount});

  ChapterData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    photoUrl = json['photo_url'];
    questCount = json['quest_count'];
    isActive = json['is_active'];
    level = json['level'];
    studentActive = json['student_active'];
    type = json['type'];
    orderingLevel = json['ordering_level'];
    questionsCount = json['questions_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['photo_url'] = this.photoUrl;
    data['quest_count'] = this.questCount;
    data['is_active'] = this.isActive;
    data['level'] = this.level;
    data['student_active'] = this.studentActive;
    data['type'] = this.type;
    data['ordering_level'] = this.orderingLevel;
    data['questions_count'] = this.questionsCount;
    return data;
  }
}
