import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PegawaiController extends GetxController {
  //TODO: Implement PegawaiController
  late TextEditingController cNoKaryawan;
  late TextEditingController cNamaKaryawan;
  late TextEditingController cJabatanKaryawan;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<QuerySnapshot<Object?>> GetData() async {
    CollectionReference pegawai = firestore.collection('karyawan_22312022');

    return pegawai.get();
  }

  Stream<QuerySnapshot<Object?>> streamData() {
    CollectionReference pegawai = firestore.collection('karyawan_22312022');
    return pegawai.snapshots();
  }

  void add(String no_karyawan, String nama_karyawan,String jabatan_karyawan) async {
    CollectionReference pegawai = firestore.collection("karyawan_22312022");

    try {
      await pegawai.add({
        "no_karyawan": no_karyawan,
        "nama_karyawan": nama_karyawan,
        "jabatan_karyawan" : jabatan_karyawan,
      });
      Get.defaultDialog(
          title: "Berhasil",
          middleText: "Berhasil menyimpan data Pegawai",
          onConfirm: () {
            cNoKaryawan.clear();
            cNamaKaryawan.clear();
            cJabatanKaryawan.clear();
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
        middleText: "Gagal Menambahkan Pegawai.",
      );
    }
  }

  Future<DocumentSnapshot<Object?>> GetDataById(String id) async {
    DocumentReference docRef = firestore.collection("karyawan_22312022").doc(id);

    return docRef.get();
  }

  void Update(String no_karyawan, String nama_karyawan,String jabatan_karyawan, String id) async {
    DocumentReference pegawaiById = firestore.collection("karyawan_22312022").doc(id);

    try {
      await pegawaiById.update({
       "no_karyawan": no_karyawan,
        "nama_karyawan": nama_karyawan,
        "jabatan_karyawan" : jabatan_karyawan,
      });

      Get.defaultDialog(
        title: "Berhasil",
        middleText: "Berhasil mengubah data Pegawai.",
        onConfirm: () {
          cNoKaryawan.clear();
            cNamaKaryawan.clear();
            cJabatanKaryawan.clear();
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
        middleText: "Gagal Mengubah data Pegawai.",
      );
    }
  }

    void delete(String id) {
    DocumentReference docRef = firestore.collection("karyawan_22312022").doc(id);

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
    cNoKaryawan = TextEditingController();
    cNamaKaryawan = TextEditingController();
    cJabatanKaryawan = TextEditingController();
    super.onInit();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    cNoKaryawan.dispose();
    cNamaKaryawan.dispose();
    cJabatanKaryawan.dispose();
    super.onClose();
  }
}
