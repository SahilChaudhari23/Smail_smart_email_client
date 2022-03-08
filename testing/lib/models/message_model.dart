import 'package:demo3/models/user_model.dart';
import 'package:flutter/material.dart';
class Message {
  final User sender;
  final String time;
  final String text;
  final String subject;
  final Color priority;
  bool isStarred;
  final bool unread;
  Message({
    this.sender,
    this.time,
    this.text,
    this.subject,
    this.isStarred,
    this.unread,
    this.priority,
  });
}

final User currentUser =User(id: 0, name: 'Sahil Chaudhari', imageUrl: Colors.red);
final User sandhya = User(id: 1, name: 'Sandhya Chandrasekharan', imageUrl: Colors.orange);
final User acad = User(id: 2, name: 'Academic IIT Palakkad', imageUrl: Colors.grey);
final User medium = User(id: 3, name: 'Medium Daily', imageUrl: Colors.pink[900]);
final User amazon = User(id: 4, name: 'Amazon.in', imageUrl: Colors.yellow);
final User vishesh = User(id: 5, name: 'Vishesh Munjal', imageUrl: Colors.red);
final User rajeev = User(id: 6, name: 'Rajeev Goyal', imageUrl:Colors.teal);
final User leetcode = User(id: 7, name: 'LeetCode', imageUrl: Colors.blueGrey);
final User digitalocean = User(id: 8, name: 'Digital Ocean', imageUrl: Colors.deepPurpleAccent);
final User digitalocean1 = User(id: 9, name: 'Digital Ocean', imageUrl: Colors.greenAccent);
final User digitalocean2 = User(id: 10, name: 'Digital Ocean', imageUrl: Colors.lightBlue);
final User digitalocean3 = User(id: 11, name: 'Digital Ocean', imageUrl: Colors.amber);
final User digitalocean4 = User(id: 12, name: 'Digital Ocean', imageUrl: Colors.pink[700]);

//Chats on Mail Screen

List<Message> mails = [
  Message(
    sender: sandhya,
    time: '04:30 PM',
    text: 'Can you spot common mistakes to look out for when writing about campus?\n1, Security cameras with adequate backup facilities are installed in the campus.\n2. The first year students have their classes and accomodations in the Ahalia campus.\n3.At the Ahalia campus, the hostels are close to the academic block.\n4.  IIT Palakkad currently functions in two campuses.\n5. The boys and girls have separate hostels with 24/7 Wi-Fi connectivity.\nAnswersregards, Sandhya\n--\nRoom# 203, Academic Block,\nAhalia Campus\nIIT Palakkad',
    subject: 'Correct the sentences',
    isStarred: false,
    unread: true,
    priority: Colors.blueGrey
  ),
  Message(
    sender: acad,
    time: '01:05 PM',
    text: 'Dear Students,\nIn continuation to the mail sent, please be informed that the deadline for filling the google form for renewal of scholarships is extended till 13.12.2021 ( Monday ).\nThe google form link can be found here\nPlease note that no further extensions will be given for the same.',
    subject: 'Renewal of Scholarships- Income Certificate Submission',
    isStarred: true,
    unread: false,
    priority: Colors.red
  ),
  Message(
    sender: vishesh,
    time: '10:00 AM',
    text: 'Check the modified PDF attached & send feedback...Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
    subject: 'PDF attached',
    isStarred: false,
    unread: false,
    priority: Colors.amberAccent
  ),
  Message(
    sender: rajeev,
    time: '9:30 AM',
    text: 'Ive created the collab repo, shall we start making the project?...Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
    subject: 'Invitation to github collaborator',
    isStarred: false,
    unread: false,
    priority: Colors.greenAccent
  ),
  Message(
    sender: medium,
    time: '9:05 AM',
    text: 'Stories for Sahil Chaudhari : How I got an engineering internships in...Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
    subject: 'Simple SQFlite databases examples in flutter',
    isStarred: false,
    unread: true,
    priority: Colors.limeAccent
  ),
  Message(
    sender: amazon,
    time: 'Dec 11',
    text: 'Amazon Orders|1 of 5 items order has been dispatched...Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
    subject: 'Your Amazon.in order #205-304458 of 1 item has been dispatched',
    isStarred: false,
    unread: true,
    priority: Colors.lightBlueAccent
  ),
  Message(
    sender: leetcode,
    time: 'Dec 11',
    text: 'Hello!🎉 Congratulations to our 1st leetcodes Pick winner...Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
    subject: 'Leetcode Weekly Digest',
    isStarred: false,
    unread: true,
    priority: Colors.lightBlueAccent
  ),
  Message(
    sender: digitalocean,
    time: 'Dec 10',
    text: 'Get your Dev Badge at Hacktoberfest ,just by login into the Dev Website...Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. ',
    subject: 'Dev Badge @Hacktoberfest',
    isStarred: false,
    unread: true,
    priority: Colors.lime
  ),
  Message(
    sender: digitalocean1,
    time: 'Dec 10',
    text: 'Get your Dev Badge at Hacktoberfest ,just by login into the Dev Website...Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. ',
    subject: 'Dev Badge @Hacktoberfest',
    isStarred: false,
    unread: true,
      priority: Colors.lime
  ),
  Message(
    sender: digitalocean2,
    time: 'Dec 10',
    text: 'Get your Dev Badge at Hacktoberfest ,just by login into the Dev Website...Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. ',
    subject: 'Dev Badge @Hacktoberfest',
    isStarred: false,
    unread: true,
      priority: Colors.white
  ),
  Message(
    sender: digitalocean3,
    time: 'Dec 10',
    text: 'Get your Dev Badge at Hacktoberfest ,just by login into the Dev Website...Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. ',
    subject: 'Dev Badge @Hacktoberfest',
    isStarred: false,
    unread: true,
      priority: Colors.lime
  ),
  Message(
    sender: digitalocean4,
    time: 'Dec 10',
    text: 'Get your Dev Badge at Hacktoberfest ,just by login into the Dev Website...Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. ',
    subject: 'Dev Badge @Hacktoberfest',
    isStarred: false,
    unread: true,
      priority: Colors.white
  ),
];
