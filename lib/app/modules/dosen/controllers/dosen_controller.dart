import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DosenController extends GetxController {
  //TODO: Implement DosenController
  late TextEditingController cNidn;
  late TextEditingController cNama;
  late TextEditingController cProdi;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<QuerySnapshot<Object?>> GetData() async {
    CollectionReference dosen = firestore.collection('dosen');

    return dosen.get();
  }

  Stream<QuerySnapshot<Object?>> streamData() {
    CollectionReference dosen = firestore.collection('dosen');
    return dosen.snapshots();
  }

  void add(String nidn, String nama,String prodi) async {
    CollectionReference dosen = firestore.collection("dosen");

    try {
      await dosen.add({
        "nidn": nidn,
        "nama": nama,
        "prodi" : prodi,
      });
      Get.defaultDialog(
          title: "Berhasil",
          middleText: "Berhasil menyimpan data Dosen",
          onConfirm: () {
            cNidn.clear();
            cNama.clear();
            cProdi.clear();
            Get.back();
            Get.back();
            Get.back();
            textConfirm:
            "OK";
          });
    } catch (e) {
      print(e);
      Get.defaultDialog(
        title: "Terjadi Kesalahan",
        middleText: "Gagal Menambahkan Dosen.",
      );
    }
  }

  Future<DocumentSnapshot<Object?>> GetDataById(String id) async {
    DocumentReference docRef = firestore.collection("dosen").doc(id);

    return docRef.get();
  }

  void Update(String nidn, String nama, String prodi, String id) async {
    DocumentReference dosenById = firestore.collection("dosen").doc(id);

    try {
      await dosenById.update({
        "nidn": nidn,
        "nama": nama,
        "prodi" : prodi,
      });

      Get.defaultDialog(
        title: "Berhasil",
        middleText: "Berhasil mengubah data Dosen.",
        onConfirm: () {
          cNidn.clear();
          cNama.clear();
          cProdi.clear();
          Get.back();
          Get.back();
          Get.back();
        },
        textConfirm: "OK",
      );
    } catch (e) {
      print(e);
      Get.defaultDialog(
        title: "Terjadi Kesalahan",
        middleText: "Gagal Menambahkan Dosen.",
      );
    }
  }

    void delete(String id) {
    DocumentReference docRef = firestore.collection("dosen").doc(id);

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
    cNidn = TextEditingController();
    cNama = TextEditingController();
    cProdi = TextEditingController();
    super.onInit();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    cNidn.dispose();
    cNama.dispose();
    cProdi.dispose();
    super.onClose();
  }
}
