import 'package:cloud_firestore/cloud_firestore.dart';

class Account{
  String id;
  String name;
  String userId;
  String imagePath;
  String selfIntroduction;
  Timestamp? createdTime;
  Timestamp? updatedTime;

  Account({
    this.id='',
    this.name='',
    this.userId='',
    this.imagePath='',
    this.selfIntroduction='',
    this.createdTime,
    this.updatedTime,
  });
}