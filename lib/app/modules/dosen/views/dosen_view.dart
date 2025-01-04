import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:myapp/app/modules/dosen/controllers/dosen_controller.dart';
import 'package:myapp/app/modules/dosen/views/dosen_update_view.dart';

class DosenView extends GetView<DosenController> {
  void showOption(id) async {
    var result = await Get.dialog(
      SimpleDialog(
        children: [
          ListTile(
            onTap: () {
              Get.back();
              Get.to(
                DosenUpdateView(),
                arguments: id,
              );
            },
            title: Text('Update'),
          ),
          ListTile(
            onTap: () {
              Get.back();
              controller.delete(id);
            },
            title: Text('Delete'),
          ),
          ListTile(
            onTap: () => Get.back(),
            title: Text('Close'),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Object?>>(
      stream: Get.put(DosenController()).streamData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          // mengambil data
          var listAllDocs = snapshot.data?.docs ?? [];
          return listAllDocs.length > 0
              ? ListView.builder(
                  itemCount: listAllDocs.length,
                  itemBuilder: (context, index) => ListTile(
                    leading: CircleAvatar(
                      child: Text('${index + 1}'),
                      backgroundColor: Color.fromARGB(255, 248, 248, 248),
                    ),
                    title: Text(
                      "Nama : ${(listAllDocs[index].data() as Map<String, dynamic>)["nama"]}",
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment
                          .start, // Tambahkan properti ini untuk alignment
                      children: [
                        Text(
                          "NIDN : ${(listAllDocs[index].data() as Map<String, dynamic>)["nidn"]}",
                        ),
                        Text(
                          "Prodi : ${(listAllDocs[index].data() as Map<String, dynamic>)["prodi"]}",
                        ),
                      ],
                    ),
                    trailing: IconButton(
                        onPressed: () => showOption(listAllDocs[index].id),
                        icon: Icon(Icons.more_vert)),
                  ),
                )
              : Center(
                  child: Text("Data Kosong"),
                );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
