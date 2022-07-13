import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sns_j/model/account.dart';
import 'package:sns_j/utils/Authentication.dart';
import 'package:sns_j/utils/firestore/users.dart';
import 'package:sns_j/utils/function_utils.dart';
import 'package:sns_j/utils/widget_utils.dart';
import 'package:sns_j/view/start_up/check_email_page.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({Key? key}) : super(key: key);

  @override
  _CreateAccountPageState createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController userIdController = TextEditingController();
  TextEditingController selfIntroductionController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  File? image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetUtils.createAppBar('プロフィール作成'),
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
                  foregroundImage: image == null ? null : FileImage(image!),
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
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Container(
                  width: 300,
                  child: TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                        hintText: 'メールアドレス'
                    ),
                  ),
                ),
              ),
              Container(
                width: 300,
                child: TextField(
                  controller: passController,
                  decoration: InputDecoration(
                      hintText: 'パスワード'
                  ),
                ),
              ),
              SizedBox(height: 20,),
              ElevatedButton(
                onPressed: ()async{
                  if(nameController.text.isNotEmpty
                  && userIdController.text.isNotEmpty
                  && selfIntroductionController.text.isNotEmpty
                  && emailController.text.isNotEmpty
                  && passController.text.isNotEmpty
                  && image != null){
                    var result = await Authenticatioin.signUp(email: emailController.text, pass: passController.text);
                    if(result is UserCredential){
                      var _result = await createAccount(result.user!.uid);
                      if(_result == true){
                        result.user!.sendEmailVerification();
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>CheckEmailPage(
                            email: emailController.text,
                            pass: passController.text,
                        )));
                      }

                    }
                  }
                },
                child: Text('アカウント作成'),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Future<dynamic>createAccount(String uid)async{
    String imagePath = await FunctionUtils.uploadImage(uid,image!);
    Account newAccount = Account(
      id: uid,
      name: nameController.text,
      userId: userIdController.text,
      selfIntroduction: selfIntroductionController.text,
      imagePath: imagePath,
    );
    var _result = await UserFirestore.setUser(newAccount);
    return _result;
  }
}
