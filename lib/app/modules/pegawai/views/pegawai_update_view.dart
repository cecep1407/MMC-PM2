import 'package:myapp/app/modules/pegawai/controllers/pegawai_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class PegawaiUpdateView extends GetView<PegawaiController> {
  const PegawaiUpdateView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ubah Pegawai'),
        centerTitle: true,
      ),
      body: FutureBuilder<DocumentSnapshot<Object?>>(
        future: controller.GetDataById(Get.arguments),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            var data = snapshot.data!.data() as Map<String, dynamic>;
            controller.cNoKaryawan.text = data['no_karyawan'];
            controller.cNamaKaryawan.text = data['nama_karyawan'];
            controller.cJabatanKaryawan.text = data['jabatan_karyawan'];
            return Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                children: [
                  TextField(
                    controller: controller.cNoKaryawan,
                    autocorrect: false,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(labelText: "Nomor Karyawan"),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: controller.cNamaKaryawan,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(labelText: "Nama Karyawan"),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  TextField(
                    controller: controller.cJabatanKaryawan,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(labelText: "Jabatan Karyawan"),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                    onPressed: () => controller.Update(
                      controller.cNoKaryawan.text,
                      controller.cNamaKaryawan.text,
                      controller.cJabatanKaryawan.text,
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
