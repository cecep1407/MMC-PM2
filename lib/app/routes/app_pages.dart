import 'package:get/get.dart';

import '../modules/dosen/bindings/dosen_binding.dart';
import '../modules/dosen/views/dosen_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/mahasiswa/bindings/mahasiswa_binding.dart';
import '../modules/mahasiswa/views/mahasiswa_view.dart';
import '../modules/pegawai/bindings/pegawai_binding.dart';
import '../modules/pegawai/views/pegawai_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.MAHASISWA,
      page: () => MahasiswaView(),
      binding: MahasiswaBinding(),
    ),
    GetPage(
      name: _Paths.DOSEN,
      page: () => DosenView(),
      binding: DosenBinding(),
    ),
    GetPage(
      name: _Paths.PEGAWAI,
      page: () => PegawaiView(),
      binding: PegawaiBinding(),
    ),
  ];
}
