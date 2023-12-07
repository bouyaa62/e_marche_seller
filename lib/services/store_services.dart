import 'package:emart_seller/const/const.dart';

class StoreServices {
  static getProfile(uid) {
    return firestore
        .collection(vendorsCollection)
        .where('id', isEqualTo: uid)
        .get();
  }

  static getMessage(uid) {
    return firestore
        .collection(chatsCollecton)
        .where('toId', isEqualTo: uid)
        .snapshots();
  }
}
