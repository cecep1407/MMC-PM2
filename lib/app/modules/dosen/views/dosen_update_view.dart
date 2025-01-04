import 'package:myapp/app/modules/dosen/controllers/dosen_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class DosenUpdateView extends GetView<DosenController> {
  const DosenUpdateView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ubah Dosen'),
        centerTitle: true,
      ),
      body: FutureBuilder<DocumentSnapshot<Object?>>(
        future: controller. GetDataById (Get.arguments),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            var data = snapshot.data!.data() as Map<String, dynamic>;
            controller.cNidn.text = data['nidn'];
            controller.cNama.text = data['nama'];
             controller.cProdi.text = data['prodi'];
            return Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                children: [
                  TextField(
                    controller: controller.cNidn,
                    autocorrect: false,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(labelText: "NIDN"),
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
                  TextField(
                    controller: controller.cProdi,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(labelText: "Prodi"),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  
                  ElevatedButton(
                    onPressed: () => controller.Update(
                      controller.cNidn.text,
                      controller.cNama.text,
                      controller.cProdi.text,
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