import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:googleapis/gmail/v1.dart';
import 'package:testing/tabs/frontpage.dart';

class addTag extends StatefulWidget{
  @override
  _TagFormState createState() => _TagFormState();
}

class _TagFormState extends State<addTag> {

  final _formKey = GlobalKey<FormState>();
  Color mycolor = Colors.lightBlue;
  String tagName = "";
  double pNum = 0.0;
  double threshold = 0.2;
  String keyword = "";
  bool _validator1 = false;
  bool _validator2 = false;
  bool _validator3 = false;
  TextEditingController tag = TextEditingController();
  TextEditingController pnum = TextEditingController();
  TextEditingController thresh = TextEditingController();
  TextEditingController keyw = TextEditingController();

  Widget build(BuildContext context){
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Create Tag"),
      ),
      body: buildForm(context),
    );
  }

  @override
  Widget buildForm(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Flexible(child: TextFormField(
            controller: tag,
            onChanged: (String? value){
              setState(() {
                tagName = value ?? " ";
                if(value == null || value == ""){
                  _validator1 = false;
                }else{
                  _validator1 = true;
                }
              });
            },
            decoration: InputDecoration(
              icon: const Icon(Icons.person),
              hintText: 'Enter Tag name',
              label: RichText(
                text: const TextSpan(
                    text: 'Tag Name',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 18.0,
                    ),
                    children: [
                      TextSpan(
                          text: ' *',
                          style: TextStyle(
                            color: Colors.red,
                          )
                      )
                    ]
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
                    text: 'Keywords',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 18.0,
                    ),
                    children: [
                      TextSpan(
                          text: ' *',
                          style: TextStyle(
                            color: Colors.red,
                          )
                      )
                    ]
                ),
              ),
            ),
          ),),
          TextFormField(
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
                    text: 'Priority Value',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 18.0,
                    ),
                    children: [
                      TextSpan(
                          text: ' *',
                          style: TextStyle(
                            color: Colors.red,
                          )
                      )
                    ]
                ),
              ),
            ),
            keyboardType: TextInputType.number,
          ),
          TextFormField(
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
                    text: 'Threshold Value',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 18.0,
                    ),
                ),
              ),
            ),
            keyboardType: TextInputType.number,
          ),
          TextFormField(
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
                          title: Text('Pick a color!'),
                          content: SingleChildScrollView(
                            child: ColorPicker(
                              pickerColor: mycolor, //default color
                              onColorChanged: (Color color){ //on color picked
                                setState(() {
                                  mycolor = color;
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
                    children: [
                      TextSpan(
                          text: ' *',
                          style: TextStyle(
                            color: Colors.red,
                          )
                      )
                    ]
                ),
              ),
            ),
          ),
          ListTile(
            title: Text("You selected this color"),
            tileColor: mycolor,
            onTap: () {},
          ),
          Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 60,
                child: ElevatedButton(
                  child: Text('Submit'),
                  onPressed: (_validator1 && _validator2 && _validator3) == true ? (){saveData();} : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void saveData(){
    debugPrint(tagName);
    debugPrint(threshold.toString());
    debugPrint(pNum.toString());
    debugPrint(keyword);
    if(storeData()){
      _showMyDialog();
    }
  }

  bool storeData(){
    List<String> keywords = keyword.toLowerCase().replaceAll(new RegExp(r'[\s]$'),"").split(new RegExp(r'\s*[\,]\s*')).toList();
    gmailMessage.priorityHandler.setTag(tagName, keywords, pNum, mycolor, threshold: threshold);
    if(gmailMessage.priorityHandler.tagMap.containsKey(tagName)){
      gmailMessage.sortMessages();
      debugPrint("Success");
      return true;
    }
    return false;
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Tag '+tagName+" added"),
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