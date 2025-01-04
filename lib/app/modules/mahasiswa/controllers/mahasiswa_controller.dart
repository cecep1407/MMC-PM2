import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MahasiswaController extends GetxController {
  //TODO: Implement MahasiswaController
  late TextEditingController cNpm;
  late TextEditingController cNama;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<QuerySnapshot<Object?>> GetData() async {
    CollectionReference mahasiswa = firestore.collection('mahasiswa');

    return mahasiswa.get();
  }

  Stream<QuerySnapshot<Object?>> streamData() {
    CollectionReference mahasiswa = firestore.collection('mahasiswa');
    return mahasiswa.snapshots();
  }

  void add(String npm, String nama) async {
    CollectionReference mahasiswa = firestore.collection("mahasiswa");

    try {
      await mahasiswa.add({
        "npm": npm,
        "nama": nama,
      });
      Get.defaultDialog(
          title: "Berhasil",
          middleText: "Berhasil menyimpan data mahasiswa",
          onConfirm: () {
            cNpm.clear();
            cNama.clear();
            Get.back();
            Get.back();
            textConfirm:
            "OK";
          });
    } catch (e) {
      print(e);
      Get.defaultDialog(
        title: "Terjadi Kesalahan",
        middleText: "Gagal Menambahkan Mahasiswa.",
      );
    }
  }

  Future<DocumentSnapshot<Object?>> GetDataById(String id) async {
    DocumentReference docRef = firestore.collection("mahasiswa").doc(id);

    return docRef.get();
  }

  void Update(String npm, String nama, String id) async {
    DocumentReference mahasiswaById = firestore.collection("mahasiswa").doc(id);

    try {
      await mahasiswaById.update({
        "npm": npm,
        "nama": nama,
      });

      Get.defaultDialog(
        title: "Berhasil",
        middleText: "Berhasil mengubah data Mahasiswa.",
        onConfirm: () {
          cNpm.clear();
          cNama.clear();
          Get.back();
          Get.back();
        },
        textConfirm: "OK",
      );
    } catch (e) {
      print(e);
      Get.defaultDialog(
        title: "Terjadi Kesalahan",
        middleText: "Gagal Menambahkan Mahasiswa.",
      );
    }
  }

    void delete(String id) {
    DocumentReference docRef = firestore.collection("mahasiswa").doc(id);

    try {
      Get.defaultDialog(
        title: "Info",
        middleText: "Apakah anda yakin menghapus data ini ?",
        onConfirm: () {
          docRef.delete();
          Get.back();
          Get.defaultDialog(
            title: "Sukses",
            middleText: "Berhasil menghapus data",
          );
        },
        textConfirm: "Ya",
        textCancel: "Batal",
      );
    } catch (e) {
      print(e);
      Get.defaultDialog(
        title: "Terjadi kesalahan",
        middleText: "Tidak berhasil menghapus data",
      );
    }
  }
  
  @override
  void onInit() {
    // TODO: implement onInit
    cNpm = TextEditingController();
    cNama = TextEditingController();
    super.onInit();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    cNpm.dispose();
    cNama.dispose();
    super.onClose();
  }
}
