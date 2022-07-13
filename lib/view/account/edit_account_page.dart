import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sns_j/model/account.dart';
import 'package:sns_j/utils/Authentication.dart';
import 'package:sns_j/utils/firestore/users.dart';
import 'package:sns_j/utils/function_utils.dart';
import 'package:sns_j/utils/widget_utils.dart';
import 'package:sns_j/view/start_up/login_page.dart';

class EditAccountPage extends StatefulWidget {
  const EditAccountPage({Key? key}) : super(key: key);

  @override
  _EditAccountPageState createState() => _EditAccountPageState();
}

class _EditAccountPageState extends State<EditAccountPage> {
  Account myAccount = Authenticatioin.myAccount!;
  TextEditingController nameController = TextEditingController();
  TextEditingController userIdController = TextEditingController();
  TextEditingController selfIntroductionController = TextEditingController();
  File? image;

  ImageProvider getImage(){
    if(image == null){
      return NetworkImage(myAccount.imagePath);
    }else{
      return FileImage(image!);
    }
  }

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: myAccount.name);
    userIdController = TextEditingController(text: myAccount.userId);
    selfIntroductionController = TextEditingController(text: myAccount.selfIntroduction);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetUtils.createAppBar('プロフィール編集'),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          child: Column(
            children: [
              SizedBox(height: 10,),
              GestureDetector(
                onTap: ()async{
                  var result = await FunctionUtils.getImageFromGallery();
                  if(result != null){
                    setState(() {
                      image = File(result.path);
                    });
                  }
                },
                child: CircleAvatar(
                  radius: 40,
                  child: Icon(Icons.add),
                  foregroundImage: getImage(),
                ),
              ),
              Container(
                width: 300,
                child: TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                      hintText: '名前'
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Container(
                  width: 300,
                  child: TextField(
                    controller: userIdController,
                    decoration: InputDecoration(
                        hintText: 'ユーザーID'
                    ),
                  ),
                ),
              ),
              Container(
                width: 300,
                child: TextField(
                  controller: selfIntroductionController,
                  decoration: InputDecoration(
                      hintText: '自己紹介'
                  ),
                ),
              ),
              SizedBox(height: 20,),
              ElevatedButton(
                onPressed: ()async{
                  if(nameController.text.isNotEmpty
                      && userIdController.text.isNotEmpty
                      && selfIntroductionController.text.isNotEmpty){
                    String imagePath = '';
                    if(image == null){
                      imagePath = myAccount.imagePath;
                    }else{
                      var result = await FunctionUtils.uploadImage(myAccount.id, image!);
                      imagePath = result;
                    }
                    Account updateAccount = Account(
                      id: myAccount.id,
                      name: nameController.text,
                      userId: userIdController.text,
                      selfIntroduction: selfIntroductionController.text,
                      imagePath: imagePath,
                    );
                    Authenticatioin.myAccount = updateAccount;
                    var _result = await UserFirestore.updateUser(updateAccount);
                    if(_result == true){
                      Navigator.pop(context,true);
                    }
                  }
                },
                child: Text('変更'),
              ),
              SizedBox(height: 50,),
              ElevatedButton(
                onPressed: (){
                  Authenticatioin.signOut();
                  while(Navigator.canPop(context)){
                    Navigator.pop(context);
                  }
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginPage()));
                },
                child: Text('ログアウト'),
              ),
              SizedBox(height: 50,),
              ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.red),
                onPressed: (){
                  UserFirestore.deleteUser(myAccount.id);
                  Authenticatioin.deleteAuth();
                  while(Navigator.canPop(context)){
                    Navigator.pop(context);
                  }
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginPage()));
                },
                child: Text('アカウント削除'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
