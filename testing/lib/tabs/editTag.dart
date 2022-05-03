import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:testing/tabs/frontpage.dart';

class editTag extends StatefulWidget{
  final String tagName;
  const editTag(this.tagName);
  @override
  _TagEditFormState createState() => _TagEditFormState(tagName);
}

class _TagEditFormState extends State<editTag> {
  String tagName;
  _TagEditFormState(this.tagName);
  final _formKey = GlobalKey<FormState>();
  Color mycolor = Colors.lightBlue;
  Color selectColor = Colors.lightBlue;
  String newTagName = "";
  double pNum = 0.0;
  double threshold = 0.2;
  String keyword = "";
  List<String> keywords = [];
  bool _validator1 = false;
  bool _validator2 = false;
  bool _validator3 = false;
  bool _validator4 = false;
  TextEditingController tag = TextEditingController();
  TextEditingController pnum = TextEditingController();
  TextEditingController thresh = TextEditingController();
  TextEditingController keyw = TextEditingController();

  Widget build(BuildContext context){
    mycolor = gmailMessage.priorityHandler.pNumMap[gmailMessage.priorityHandler.tagMap[tagName].priorityNum];
    pNum = gmailMessage.priorityHandler.tagMap[tagName].priorityNum;
    threshold = gmailMessage.priorityHandler.tagMap[tagName].threshold;
    keywords = gmailMessage.priorityHandler.tagMap[tagName].keywords;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Edit "+tagName+" Tag"),
      ),
      body: buildForm(context),
    );
  }

  @override
  Widget buildForm(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return SizedBox(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Column(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 60,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero,
                            )
                        ),
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.amber),
                    ),
                    child: const Text(
                      'Tag Details',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: null,
                  ),
                ),
                Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width/3,
                      height: 25,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.grey),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero,
                                  side: BorderSide(color: Colors.grey),
                              )
                          ),
                        ),
                        child: Text(
                          'Name',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        onPressed: null,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width*2/3,
                      height: 25,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.zero,
                                    side: BorderSide(color: Colors.grey)
                                )
                            ),
                        ),
                        child: Text(
                          tagName,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        onPressed: null,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width/3,
                      height: 50,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.grey),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero,
                                  side: BorderSide(color: Colors.grey)
                              )
                          ),
                        ),
                        child: Text(
                          'Keywords',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        onPressed: null,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width*2/3,
                      height: 50,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero,
                                  side: BorderSide(color: Colors.grey)
                              )
                          ),
                        ),
                        child: Text(
                          keywords.toString(),
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        onPressed: null,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width/3,
                      height: 25,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.grey),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero,
                                  side: BorderSide(color: Colors.grey)
                              )
                          ),
                        ),
                        child: Text(
                          'Priority Value',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        onPressed: null,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width/6,
                      height: 25,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero,
                                  side: BorderSide(color: Colors.grey)
                              )
                          ),
                        ),
                        child: Text(
                          pNum.toString(),
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        onPressed: null,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width/3,
                      height: 25,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.grey),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero,
                                  side: BorderSide(color: Colors.grey)
                              )
                          ),
                        ),
                        child: Text(
                          'Threshold',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        onPressed: null,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width/6,
                      height: 25,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero,
                                  side: BorderSide(color: Colors.grey)
                              )
                          ),
                        ),
                        child: Text(
                          threshold.toString(),
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        onPressed: null,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width/3,
                      height: 25,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.grey),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero,
                                  side: BorderSide(color: Colors.grey)
                              )
                          ),
                        ),
                        child: const Text(
                          'Color',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        onPressed: null,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width*2/3,
                      height: 25,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(mycolor),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero,
                                  side: BorderSide(color: mycolor)
                              )
                          ),
                        ),
                        child: const Text(
                          "",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        onPressed: null,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Column(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 60,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.deepOrange),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                          )
                      ),
                    ),
                    child: const Text(
                      'Change properties',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: null,
                  ),
                ),
              ],
            ),
            Flexible(child: TextFormField(
              controller: tag,
              onChanged: (String? value){
                setState(() {
                  newTagName = value ?? " ";
                  if(value == null || value == ""){
                    _validator1 = false;
                  }else{
                    _validator1 = true;
                  }
                });
              },
              decoration: InputDecoration(
                icon: const Icon(Icons.person),
                hintText: 'Change Tag name if desired',
                label: RichText(
                  text: const TextSpan(
                    text: 'Tag Name',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 18.0,
                    ),
                  ),
                ),
              ),
            ),),
            Flexible(child: TextFormField(
              controller: keyw,
              onChanged: (String? value){
                setState(() {
                  keyword = value ?? " ";
                  if(value == null || value == ""){
                    _validator3 = false;
                  }else{
                    _validator3 = true;
                  }
                });
              },
              decoration: InputDecoration(
                icon: const Icon(Icons.person),
                hintText: 'Enter keywords separated by comma',
                label: RichText(
                  text: const TextSpan(
                    text: 'Add Keywords',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 18.0,
                    ),
                  ),
                ),
              ),
            ),),
            Flexible(child: TextFormField(
              controller: pnum,
              onChanged: (String? value){
                setState(() {
                  pNum = double.tryParse(value ?? "0.5") ?? 0.5;
                  if(value == null || value == ""){
                    _validator2 = false;
                  }else{
                    _validator2 = true;
                  }
                });
              },
              decoration: InputDecoration(
                icon: const Icon(Icons.phone),
                hintText: 'Enter a Priority value from 0 to 10.0',
                label: RichText(
                  text: const TextSpan(
                    text: 'Change Priority Value',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 18.0,
                    ),
                  ),
                ),
              ),
              keyboardType: TextInputType.number,
            ),),
            Flexible(child: TextFormField(
              controller: thresh,
              onChanged: (String? value){
                setState(() {
                  threshold = double.tryParse(value ?? "0.5") ?? 0.5;
                });
              },
              decoration: InputDecoration(
                icon: const Icon(Icons.phone),
                hintText: 'Value from 0 to 1.0, by default 0.2',
                label: RichText(
                  text: const TextSpan(
                    text: 'Change Threshold Value',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 18.0,
                    ),
                  ),
                ),
              ),
              keyboardType: TextInputType.number,
            ),),
            Flexible(child: TextFormField(
              readOnly: true,
              decoration: InputDecoration(
                icon: const Icon(Icons.calendar_today),
                hintText: 'Click on pallete button to Select Color',
                suffixIcon: IconButton(
                  icon: Icon(Icons.color_lens_outlined),
                  onPressed: (){
                    showDialog(
                        context: context,
                        builder: (BuildContext context){
                          return AlertDialog(
                            title: Text('Change a color!'),
                            content: SingleChildScrollView(
                              child: ColorPicker(
                                pickerColor: mycolor, //default color
                                onColorChanged: (Color color){ //on color picked
                                  _validator4 = true;
                                  setState(() {
                                    selectColor = color;
                                  });
                                },
                              ),
                            ),
                            actions: <Widget>[
                              ElevatedButton(
                                child: const Text('DONE'),
                                onPressed: () {
                                  Navigator.of(context).pop(); //dismiss the color picker
                                },
                              ),
                            ],
                          );
                        }
                    );
                  },
                ),
                label: RichText(
                  text: const TextSpan(
                    text: 'Tag Color',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 18.0,
                    ),
                  ),
                ),
              ),
            ),),
            ListTile(
              title: Text("You selected this color"),
              tileColor: _validator4? selectColor : mycolor,
              onTap: () {},
            ),
            Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width/2,
                  height: 60,
                  child: ElevatedButton(
                    child: Text('Edit Tag'),
                    onPressed: (_validator1 || _validator2 || _validator3 || _validator4) == true ? (){saveData();} : null,
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        )
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width/2,
                  height: 60,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.deepOrangeAccent),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          )
                      ),
                    ),
                    child: Text('Remove Tag'),
                    onPressed: () {removeTag();gmailMessage.sortMessages();_showMyDialog("Tag "+tagName+ " succefully removed");},
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void saveData(){
    debugPrint(tagName);
    debugPrint(threshold.toString());
    debugPrint(pNum.toString());
    debugPrint(keyword);
    editData();
  }

  void removeTag(){
    gmailMessage.priorityHandler.tagList.remove(gmailMessage.priorityHandler.tagMap[tagName]);
    gmailMessage.priorityHandler.tagMap.remove(tagName);
  }

  bool editData(){
    removeTag();
    List<String> keywrds = keyword.toLowerCase().replaceAll(new RegExp(r'[\s]$'),"").split(new RegExp(r'\s*[\,]\s*')).toList();
    if(_validator4){
      mycolor = selectColor;
    }
    if(newTagName == ""){
      gmailMessage.priorityHandler.setTag(tagName, keywords+keywrds, pNum, mycolor, threshold: threshold);
    }else{
      tagName = newTagName;
      gmailMessage.priorityHandler.setTag(newTagName, keywords+keywrds, pNum, mycolor, threshold: threshold);
    }
    if(gmailMessage.priorityHandler.tagMap.containsKey(tagName)){
      gmailMessage.sortMessages();
      debugPrint("Edit Success");
      _showMyDialog("Tag "+tagName+ " succefully edited");
      return true;
    }
    return false;
  }

  Future<void> _showMyDialog(String msg) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(msg),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

}