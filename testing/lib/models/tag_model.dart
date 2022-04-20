import 'package:flutter/material.dart';
class Tag {
  String name;
  late double priorityNum;
  late Map frequencyMap;
  late double threshold;
  late List<String> keywords;

  Tag(this.name){
    keywords = [];
    frequencyMap = {};
    priorityNum = 0;
    threshold = 0.2;
  }

  void print(){
    debugPrint("Tag: "+name);
    debugPrint(keywords.toString());
    debugPrint(priorityNum.toString());
    debugPrint(threshold.toString());
    debugPrint(frequencyMap.toString());
  }
}
