import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sns_j/utils/Authentication.dart';
import 'package:sns_j/utils/firestore/users.dart';
import 'package:sns_j/utils/widget_utils.dart';
import 'package:sns_j/view/screen.dart';

class CheckEmailPage extends StatefulWidget {
  final String email;
  final String pass;
  const CheckEmailPage({Key? key,required this.email,required this.pass}) : super(key: key);

  @override
  _CheckEmailPageState createState() => _CheckEmailPageState();
}

class _CheckEmailPageState extends State<CheckEmailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetUtils.createAppBar('メールアドレスを確認'),
      body: Column(
        children: [
          Text('登録いだ炊いたメールアドレスに確認のメールを送信しております。そちらに記載されているURLのクリック認証をお願いします。'),
          ElevatedButton(
            onPressed: ()async{
              var result = await Authenticatioin.emailSignIn(email: widget.email, pass: widget.pass);
              if(result is UserCredential){
                if(result.user!.emailVerified == true){
                  while(Navigator.canPop(context)){
                    Navigator.pop(context);
                  }
                }
                await UserFirestore.getUser(result.user!.uid);
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Screen()));
              }else{
                print('メール認証が終わっていません。');
              }
            },
            child: Text('認証確認'),
          ),
        ],
      ),
    );
  }
}
