import 'package:myapp/app/modules/mahasiswa/controllers/mahasiswa_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class MahasiswaUpdateView extends GetView<MahasiswaController> {
  const MahasiswaUpdateView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ubah Mahasiswa'),
        centerTitle: true,
      ),
      body: FutureBuilder<DocumentSnapshot<Object?>>(
        future: controller. GetDataById (Get.arguments),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            var data = snapshot.data!.data() as Map<String, dynamic>;
            controller.cNpm.text = data['npm'];
            controller.cNama.text = data['nama'];
            return Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                children: [
                  TextField(
                    controller: controller.cNpm,
                    autocorrect: false,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(labelText: "NPM"),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: controller.cNama,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(labelText: "Nama"),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  
                  ElevatedButton(
                    onPressed: () => controller.Update(
                      controller.cNpm.text,
                      controller.cNama.text,
                      Get.arguments,
                    ),
                    child: Text("Ubah"),
                  )
                ],
              ),
            );
          }

          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}