import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/app/controllers/auth_controller.dart';
import 'package:myapp/app/modules/chatai/views/chatai_view.dart';
import 'package:myapp/app/modules/dosen/views/dosen_add_view.dart';
import 'package:myapp/app/modules/dosen/views/dosen_view.dart';
import 'package:myapp/app/modules/mahasiswa/views/mahasiswa_view.dart';
import 'package:myapp/app/modules/pegawai/views/pegawai_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with SingleTickerProviderStateMixin {
  final cAuth = Get.put(AuthController());
  late TabController _tabController;
  int _currentIndex = 0;

  final List<Map<String, dynamic>> _tabs = [
    {'title': 'Dashboard', 'icon': Icons.dashboard, 'view': ChataiView()},
    {'title': 'Mahasiswa', 'icon': Icons.people, 'view': MahasiswaView()},
    {'title': 'Dosen', 'icon': Icons.school, 'view': DosenView()},
    {'title': 'Pegawai', 'icon': Icons.work, 'view': PegawaiView()},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(),
      appBar: AppBar(
        backgroundColor: Color(0xFF74B3CE), // Warna biru pastel
        title: Text(
          _tabs[_currentIndex]['title'],
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add_circle_outline),
            onPressed: () {
              // Menambahkan data sesuai tab aktif
              if (_currentIndex == 2) Get.to(() => DosenAddView());
              if (_currentIndex == 3) Get.to(() => PegawaiView());
            },
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: _tabs.map((tab) => tab['view'] as Widget).toList(),
      ),
      bottomNavigationBar: TabBar(
        controller: _tabController,
        indicatorColor: Colors.white,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        tabs: _tabs
            .map((tab) => Tab(
                  text: tab['title'],
                  icon: Icon(tab['icon']),
                ))
            .toList(),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xFF74B3CE),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(Icons.account_circle, size: 70, color: Colors.white),
                SizedBox(height: 10),
                Text(
                  "Julius John Christian",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  "Admin",
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.dashboard, color: Color(0xFF24476F)),
            title: Text('Dashboard'),
            onTap: () {
              setState(() {
                _currentIndex = 0;
                _tabController.animateTo(0);
              });
              Get.back();
            },
          ),
          ListTile(
            leading: Icon(Icons.people, color: Color(0xFF24476F)),
            title: Text('Data Mahasiswa'),
            onTap: () {
              setState(() {
                _currentIndex = 1;
                _tabController.animateTo(1);
              });
              Get.back();
            },
          ),
          ListTile(
            leading: Icon(Icons.school, color: Color(0xFF24476F)),
            title: Text('Data Dosen'),
            onTap: () {
              setState(() {
                _currentIndex = 2;
                _tabController.animateTo(2);
              });
              Get.back();
            },
          ),
          ListTile(
            leading: Icon(Icons.work, color: Color(0xFF24476F)),
            title: Text('Data Pegawai'),
            onTap: () {
              setState(() {
                _currentIndex = 3;
                _tabController.animateTo(3);
              });
              Get.back();
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.red),
            title: Text('Logout'),
            onTap: () {
              cAuth.logout();
              Get.back();
            },
          ),
        ],
      ),
    );
  }
}
