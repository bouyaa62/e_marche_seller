import 'dart:io';

import 'package:emart_seller/const/const.dart';
import 'package:emart_seller/controllers/profile_controller.dart';
import 'package:emart_seller/views/widgets/custom_textfield.dart';
import 'package:emart_seller/views/widgets/loading_indicator.dart';
import 'package:emart_seller/views/widgets/text_style.dart';
import 'package:get/get.dart';

class EditProfileScreen extends StatefulWidget {
  final String? username;
  const EditProfileScreen({super.key, this.username});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  var controller = Get.find<ProfileController>();

  @override
  void initState() {
    controller.nameController.text = widget.username!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: purpleColor,
        appBar: AppBar(
          title: boldText(text: editProfile, size: 16.0),
          actions: [
            controller.isLoading.value
                ? loadingIndicator(circleColor: white)
                : TextButton(
                    onPressed: () async {
                      controller.isLoading(true);

                      //if image is not selected
                      if (controller.profileImagePath.value.isNotEmpty) {
                        await controller.uploadProfileImage();
                      } else {
                        controller.profileImageLink =
                            controller.snapshotData['imageUrl'];
                      }

                      //if oldpassword matches data base
                      if (controller.snapshotData['password'] ==
                          controller.oldpassController.text) {
                        await controller.changeAuthPassword(
                            email: controller.snapshotData['email'],
                            password: controller.oldpassController.text,
                            newpassword: controller.newpassController.text);

                        await controller.updateProfile(
                          imageUrl: controller.profileImageLink,
                          name: controller.nameController.text,
                          password: controller.newpassController.text,
                        );
                        VxToast.show(context, msg: "updated");
                      } else if (controller
                              .oldpassController.text.isEmptyOrNull &&
                          controller.newpassController.text.isEmptyOrNull) {
                        await controller.updateProfile(
                          imageUrl: controller.profileImageLink,
                          name: controller.nameController.text,
                          password: controller.snapshotData['password'],
                        );
                        VxToast.show(context, msg: "updated");
                      } else {
                        VxToast.show(context, msg: "Some error occured");
                        controller.isLoading(false);
                      }
                    },
                    child: normalText(text: save))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              controller.snapshotData['imageUrl'] == '' &&
                      controller.profileImagePath.isEmpty
                  ? Image.asset(imgProduct, width: 100, fit: BoxFit.cover)
                      .box
                      .roundedFull
                      .clip(Clip.antiAlias)
                      .make()

                  //if data is not empty but controller path is empty
                  : controller.snapshotData['imageUrl'] != "" &&
                          controller.profileImagePath.isEmpty
                      ? Image.network(
                          controller.snapshotData['imageUrl'],
                          width: 100,
                          fit: BoxFit.cover,
                        ).box.roundedFull.clip(Clip.antiAlias).make()

                      //if both are empty
                      : Image.file(
                          File(controller.profileImagePath.value),
                          width: 100,
                          fit: BoxFit.cover,
                        ).box.roundedFull.clip(Clip.antiAlias).make(),
              10.heightBox,
              ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: white),
                  onPressed: () {
                    controller.changeImage(context);
                  },
                  child: normalText(text: changeImage, color: fontGrey)),
              20.heightBox,
              customTextField(
                  label: name,
                  hint: "eg. ayoub kaddour",
                  controller: controller.nameController),
              30.heightBox,
              Align(
                  alignment: Alignment.centerLeft,
                  child: boldText(text: "Change your password")),
              10.heightBox,
              customTextField(
                  label: password,
                  hint: passwordHint,
                  controller: controller.oldpassController),
              10.heightBox,
              customTextField(
                  label: confirmPass,
                  hint: passwordHint,
                  controller: controller.newpassController),
            ],
          ),
        ),
      ),
    );
  }
}
