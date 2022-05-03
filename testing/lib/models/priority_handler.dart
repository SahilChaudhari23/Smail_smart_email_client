import 'dart:math';
import 'package:flutter/material.dart';
import 'package:testing/models/tag_model.dart';
import 'package:testing/models/message_model.dart';
import 'package:retrieval/trie.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Pair{
  final double pNum;
  final String tag;
  Pair({
    required this.pNum,
    required this.tag});
}

class PriorityHandler {
  // key: tagName value: Tag class
  late Map tagMap;
  // email id : tag name
  late Map emailTag;
  // email id: priority
  late Map emailMap;
  // pNum : color
  late Map pNumMap;
  late List<Tag> tagList;
  late List<String> mailList;
  int topK = 60;
  int maxTags = 2;
  final dateDetector = RegExp(r'([0-2][0-9])\s*(st|nd|rd|th)?\s*(\.|\,|\\|\s)\s*(([0][1-9])|[1][0-2]|[1-9]|(Jan|jan|Feb|feb|Mar|mar|Apr|apr|May|may|Jun|jun|Jul|jul|Aug|aug|Sep|sep|Oct|oct|Nov|nov|Dec|dec)[a-z]*)\s*((\.|\,|\\|\s)\s*(([0-9][0-9][0-9][0-9])|([0-9][0-9])))');
  List<String> stopWords = ['i', ' ', 'me', 'my', 'myself', 'we', 'our', 'ours', 'ourselves', 'you', "you're", "you've", "you'll", "you'd", 'your', 'yours', 'yourself', 'yourselves', 'he', 'him', 'his', 'himself', 'she', "she's", 'her', 'hers', 'herself', 'it', "it's", 'its', 'itself', 'they', 'them', 'their', 'theirs', 'themselves', 'what', 'which', 'who', 'whom', 'this', 'that', "that'll", 'these', 'those', 'am', 'is', 'are', 'was', 'were', 'be', 'been', 'being', 'have', 'has', 'had', 'having', 'do', 'does', 'did', 'doing', 'a', 'an', 'the', 'and', 'but', 'if', 'or', 'because', 'as', 'until', 'while', 'of', 'at', 'by', 'for', 'with', 'about', 'against', 'between', 'into', 'through', 'during', 'before', 'after', 'above', 'below', 'to', 'from', 'up', 'down', 'in', 'out', 'on', 'off', 'over', 'under', 'again', 'further', 'then', 'once', 'here', 'there', 'when', 'where', 'why', 'how', 'all', 'any', 'both', 'each', 'few', 'more', 'most', 'other', 'some', 'such', 'no', 'nor', 'not', 'only', 'own', 'same', 'so', 'than', 'too', 'very', 's', 't', 'can', 'will', 'just', 'don', "don't", 'should', "should've", 'now', 'd', 'll', 'm', 'o', 're', 've', 'y', 'ain', 'aren', "aren't", 'couldn', "couldn't", 'didn', "didn't", 'doesn', "doesn't", 'hadn', "hadn't", 'hasn', "hasn't", 'haven', "haven't", 'isn', "isn't", 'ma', 'mightn', "mightn't", 'mustn', "mustn't", 'needn', "needn't", 'shan', "shan't", 'shouldn', "shouldn't", 'wasn', "wasn't", 'weren', "weren't", 'won', "won't", 'wouldn', "wouldn't", ''];

  PriorityHandler(){
    tagMap = {};
    emailMap = {};
    emailTag = {};
    pNumMap = {};
    tagList = [];
    mailList = [];
    pNumMap[0.0] = Colors.lightGreenAccent;
    pNumMap[11.0] = Colors.deepOrangeAccent;
  }

  void setTag(String tName, List<String> keywords, double pNum, Color pColor, {double threshold = 0.2}){
    if(! tagMap.containsKey(tName)){
      Tag t = Tag(tName);
      t.keywords.addAll(keywords);
      t.priorityNum = pNum;
      t.threshold = threshold;
      pNumMap[pNum] = pColor;
      debugPrint(pNumMap.toString());
      tagMap[tName] = t;
      tagList.add(t);
      tagList.sort((a,b) => b.priorityNum.compareTo(a.priorityNum));
      t.print();
    }
  }
  
  void init() async{
    setTag("Academics",["academics", "endsem", "exam", "result", "fee", "scholarships"],10,Colors.red,threshold: 0.1);
    setTag("Job/CDC",["cdc","job","internship","published","profile"],9,Colors.yellow,threshold: 0.1);
    setTag("Deadline",["deadline","due"],7,Colors.blue,threshold: 0.1);
    setTag("Broadcast",["broadcast"],5,Colors.lightBlueAccent,threshold:0.1);
    setTag("Ads",["coding","ninjas","amazon","shop","grammarly"],1,Colors.green,threshold:0.1);
  }

  List<Pair> textParser(Trie dataTree, bool dateFlag){
    List<Pair> tagMatched = [];
    int tagCounter = 0;
    bool deadlineFlag = false;
    if(dateFlag){
      tagMatched.add(Pair(pNum: 11.0, tag: "Have Date"));
    }
    for(var tag in tagList){
      for(var keyWord in tag.keywords){
        int presentCount = 0;
        int keywordCount = 0;
        if(dataTree.has(keyWord)){
          presentCount++;
        }
        keywordCount++;
        if(presentCount >= tag.threshold*min(topK, tag.keywords.length)){
          tagMatched.add(Pair(pNum: tag.priorityNum, tag: tag.name));
          if(tag.name == "Deadline"){
            deadlineFlag = true;
            debugPrint("deadline flag");
          }
          tagCounter++;
          if(tagCounter >= maxTags){
            if(dateFlag){
              if(deadlineFlag){
                tagMatched.removeAt(0);
                debugPrint("tag matched remove"+tagMatched.length.toString());
              }
              else{
                tagMatched.removeLast();
              }
            }
            return tagMatched;
          }
          break;
        }
        if(keywordCount >= topK){
          break;
        }
      }
    }
    if(deadlineFlag && dateFlag){
      tagMatched.removeAt(0);
      return tagMatched;
    }
    if((!dateFlag && tagMatched.isNotEmpty)||(tagMatched.length == 2)){
      return tagMatched;
    }
    tagMatched.add(Pair(pNum: 0, tag: "Other"));
    return tagMatched;
  }

  void pairListPrint(List<Pair> list){
    for(var pair in list){
      debugPrint(" tag: "+pair.tag+" pnum: "+pair.pNum.toString()+"\n");
    }
  }

  void getPriority(List<AppMessage> messages){
    init();
    for (var mail in messages.reversed) {
      bool dateFlag = false;
      final trie = Trie();
      final regexp = RegExp(r'[^\w\s]|[0-9]+');
      if(dateDetector.hasMatch(mail.subject)){
        dateFlag = true;
      }
      if(dateDetector.hasMatch(mail.text)){
        dateFlag = true;
      }
      for (var word in mail.subject.replaceAll(regexp, '').toLowerCase().split(' ')){
        if(stopWords.contains(word)){
          continue;
        }
        trie.insert(word);
      }
      for (var word in mail.text.replaceAll(regexp, '').toLowerCase().split(' ')){
        if(stopWords.contains(word)){
          continue;
        }
        trie.insert(word);
      }
      final bodyTag = textParser(trie,dateFlag);
      // debugPrint("\n\npriority handler\n\n");
      debugPrint(mail.subject);
      pairListPrint(bodyTag);
      emailTag[mail.id] = (bodyTag.map((e) => e.tag)).toList();
      debugPrint(emailTag[mail.id].length.toString()+" "+mail.id);
      if(bodyTag[0].tag == "Have Date"){
        emailMap[mail.id] = bodyTag[1].pNum;
      }else{
        emailMap[mail.id] = bodyTag[0].pNum;
      }
    }
  }

  void sortPriority(Map mailMap){
    var sortMapByValue = Map.fromEntries(
        emailMap.entries.toList()
          ..sort((e2, e1) => mailMap[e1.key].datetime.compareTo(mailMap[e2.key].datetime)));
    var sortMapByValue1 = Map.fromEntries(
        sortMapByValue.entries.toList()
          ..sort((e2, e1) => e1.value.compareTo(e2.value)));
    var tempList = sortMapByValue1.keys.toList();
    mailList = tempList.map((e) => e.toString()).toList();
    debugPrint(mailList.toString());
  }
}