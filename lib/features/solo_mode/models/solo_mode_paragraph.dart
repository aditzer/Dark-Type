import 'dart:math';

class Paragraph {
  String status;
  int resultSize;
  Data data;
  Paragraph({
    required this.status,
    required this.resultSize,
    required this.data,
  });

  static List<String> getList(dynamic jsonList) {
    List<String> list = [];
    for(int i=0;i<jsonList['text'].length;i++) {
      list.add(jsonList['text'][i]);
      log(jsonList['text'][i]);
    }
    return list;
  }

  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'resultSize': resultSize,
      'data': data
    };
  }

  factory Paragraph.fromMap(Map<String, dynamic> map) {
    return Paragraph(
      status: map['status'],
      resultSize: map['resultSize'],
      data: map['data']
    );
  }
}

class Data {
  List<String> text;
  Data({
    required this.text,
  });
}


