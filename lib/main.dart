import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

// --- Theme และการตั้งค่าหลัก ---
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ขยะคืนชีพ',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: const Color(0xFFF1F8E9),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF2E7D32),
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 4,
          titleTextStyle: TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold, fontFamily: 'Kanit'),
        ),
        fontFamily: 'Kanit',
      ),
      home: const HomePage(),
    );
  }
}

// ==========================================
// ส่วนที่ 1: หน้าหลัก (Home Page)
// ==========================================
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ขยะคืนชีพ'),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: Image.asset('assets/images/logo.png',
                errorBuilder: (c, o, s) =>
                    const Icon(Icons.recycling, color: Colors.green)),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: WasteSearchDelegate());
            },
          ),
          IconButton(
            icon: const Icon(Icons.account_circle, size: 28),
            tooltip: 'ผู้จัดทำ',
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const AuthorPage()));
            },
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/Recycle1.jpg"),
            fit: BoxFit.cover,
            opacity: 0.1,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Banner
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      colors: [Color(0xFF43A047), Color(0xFF66BB6A)]),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: Offset(0, 4))
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                          color: Colors.white24, shape: BoxShape.circle),
                      child:
                          const Icon(Icons.eco, color: Colors.white, size: 40),
                    ),
                    const SizedBox(width: 15),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("ยินดีต้อนรับ!",
                              style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                          Text("คลังความรู้ขยะรีไซเคิลฉบับสมบูรณ์",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),

              // ==========================================
              // ส่วนเมนู (GridView)
              // ==========================================
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 0.85,
                children: [
                  _buildMenuBtn(context, "ขยะรีไซเคิล\nคืออะไร?",
                      Icons.auto_stories, Colors.orange, const KnowledgePage()),
                  _buildMenuBtn(
                      context,
                      "การจัดการ\nและการคัดแยก",
                      Icons.cleaning_services,
                      Colors.blue,
                      const ManagementMenuPage()),
                  _buildMenuBtn(
                      context,
                      "ผลกระทบ\nและประโยชน์",
                      Icons.volunteer_activism,
                      Colors.teal,
                      const ImpactAndBenefitMenuPage()),
                  _buildMenuBtn(context, "ประเภทขยะ", Icons.category,
                      Colors.purple, const WasteCategoryListPage()),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuBtn(BuildContext context, String title, IconData icon,
      Color color, Widget page) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context, MaterialPageRoute(builder: (context) => page)),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          // ignore: deprecated_member_use
          border: Border.all(color: color.withOpacity(0.1), width: 1),
          boxShadow: [
            BoxShadow(
                // ignore: deprecated_member_use
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 5,
                offset: const Offset(0, 3))
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                // ignore: deprecated_member_use
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 40, color: color),
            ),
            const SizedBox(height: 15),
            Text(title,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800])),
          ],
        ),
      ),
    );
  }
}

class Item {}

class Remove {}

// ==========================================
// Template พื้นฐาน (BasePage)
// ==========================================
class BasePage extends StatelessWidget {
  final String title;
  final Widget body;
  const BasePage({super.key, required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () =>
                Navigator.of(context).popUntil((route) => route.isFirst),
          )
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color(0xFFF9FBE7),
        child: body,
      ),
    );
  }
}

// ==========================================
// ส่วนที่ 2: ความรู้ทั่วไป
// ==========================================
class KnowledgePage extends StatelessWidget {
  const KnowledgePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: "ขยะรีไซเคิลคืออะไร?",
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // ส่วนวิดีโอ
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                      // ignore: deprecated_member_use
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10)
                ],
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(15),
                    child: Row(
                      children: [
                        Icon(Icons.play_circle_fill,
                            color: Colors.red, size: 24),
                        SizedBox(width: 10),
                        Text("วิดีโอ: ปาฏิหาริย์การรีไซเคิล",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                      ],
                    ),
                  ),
                  ClipRRect(
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(20)),
                    child: MyVideoPlayer(youtubeId: "9GjXx-R7QaI"),
                  ),
                ],
              ),
            ),

            // เนื้อหา
            Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [
                  Color.fromARGB(255, 25, 173, 60),
                  Color.fromARGB(255, 8, 102, 14)
                ], begin: Alignment.topLeft, end: Alignment.bottomRight),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                      // ignore: deprecated_member_use
                      color: Colors.orange.withOpacity(0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 4))
                ],
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.auto_stories, color: Colors.white, size: 30),
                      SizedBox(width: 10),
                      Text("Recycle คืออะไร?",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    "การรีไซเคิล คือกระบวนการ 'ชุบชีวิต' วัสดุเหลือใช้ที่ดูเหมือนไร้ค่า ให้กลับมาเป็นวัตถุดิบใหม่ เพื่อนำไปผลิตเป็นสิ่งของเครื่องใช้ได้อีกครั้ง โดยไม่ต้องรบกวนทรัพยากรธรรมชาติเพิ่ม ช่วยลดขยะและลดโลกร้อนได้จริง",
                    style: TextStyle(
                        color: Colors.white, fontSize: 16, height: 1.5),
                  ),
                ],
              ),
            ),

            _buildSectionHeader("สัญลักษณ์ลูกศร 3 ตัว หมายถึง?", Icons.loop),
            Container(
              margin: const EdgeInsets.only(bottom: 25),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                // ignore: deprecated_member_use
                border: Border.all(color: Colors.green.withOpacity(0.2)),
                boxShadow: [
                  // ignore: deprecated_member_use
                  BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 5)
                ],
              ),
              child: Column(
                children: [
                  _buildStepItem(
                      "1", "Collection", "การรวบรวมและคัดแยกขยะจากบ้านเรือน"),
                  const Divider(),
                  _buildStepItem("2", "Processing",
                      "การนำไปแปรรูปเป็นวัตถุดิบใหม่ในโรงงาน"),
                  const Divider(),
                  _buildStepItem("3", "Manufacturing",
                      "การผลิตเป็นสินค้าใหม่และนำกลับมาขาย"),
                ],
              ),
            ),

            _buildSectionHeader("เส้นทางสู่ชีวิตใหม่", Icons.timeline),
            _buildInfoCard(
                "1. การคัดแยก (Sorting)",
                "จุดเริ่มต้นที่สำคัญที่สุด! เราต้องแยกขยะรีไซเคิลออกจากขยะเปียกและขยะสกปรก เพื่อให้วัสดุมีความสะอาดพร้อมเข้าสู่โรงงาน",
                Colors.blue),
            _buildInfoCard(
                "2. การบดย่อยและล้าง (Shredding)",
                "เมื่อถึงโรงงาน ขยะจะถูกบดเป็นชิ้นเล็กๆ และล้างทำความสะอาดสิ่งปนเปื้อนออกจนหมดจด",
                Colors.teal),
            _buildInfoCard(
                "3. การหลอมละลาย (Melting)",
                "ชิ้นส่วนเล็กๆ จะถูกความร้อนหลอมละลายกลายเป็นเม็ดพลาสติก แผ่นโลหะ หรือเยื่อกระดาษ พร้อมเป็นสารตั้งต้นใหม่",
                Colors.orange),
            _buildInfoCard(
                "4. การขึ้นรูปใหม่ (Molding)",
                "วัตถุดิบเหล่านั้นจะถูกนำไปขึ้นรูปเป็นสินค้าใหม่ เช่น ขวดน้ำ เสื้อผ้า หรือเฟอร์นิเจอร์ พร้อมกลับสู่มือผู้บริโภค",
                Colors.purple),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15, top: 10),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF2E7D32), size: 28),
          const SizedBox(width: 10),
          Text(title,
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E7D32))),
        ],
      ),
    );
  }

  Widget _buildStepItem(String num, String title, String desc) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.green,
            radius: 15,
            child: Text(num,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
                Text(desc,
                    style: TextStyle(color: Colors.grey[600], fontSize: 14)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, String desc, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border(left: BorderSide(color: color, width: 5)),
        boxShadow: [
          BoxShadow(
              // ignore: deprecated_member_use
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                  fontSize: 17, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 5),
          Text(desc,
              style: const TextStyle(
                  fontSize: 15, height: 1.5, color: Colors.black87)),
        ],
      ),
    );
  }
}

// ==========================================
// ส่วนที่ 3: เมนูการจัดการ
// ==========================================
class ManagementMenuPage extends StatelessWidget {
  const ManagementMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: "การจัดการและคัดแยก",
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildRichMenuCard(
              context,
              "1. การจัดการขยะ (3R)",
              "หลักการพื้นฐาน: ใช้น้อย ใช้ซ้ำ นำกลับมาใช้ใหม่",
              "assets/images/3r_diagram.jpg",
              Colors.teal,
              const ManagementDetailsPage(type: 'manage')),
          const SizedBox(height: 20),
          _buildRichMenuCard(
              context,
              "2. การคัดแยกขยะ",
              "วิธีแยกขยะที่ต้นทางให้ถูกต้อง สะอาด ปลอดภัย",
              "assets/images/sorting_guide.jpg",
              Colors.indigo,
              const ManagementDetailsPage(type: 'sort')),
          const SizedBox(height: 20),
          _buildRichMenuCard(
              context,
              "3. ถังขยะ 4 สี",
              "รู้จักสีของถังขยะ: เขียว น้ำเงิน เหลือง แดง",
              "assets/images/sorting.jpg",
              Colors.orange,
              const BinColorsPage()),
        ],
      ),
    );
  }

  Widget _buildRichMenuCard(BuildContext context, String title, String subtitle,
      String imagePath, Color color, Widget page) {
    return GestureDetector(
      onTap: () =>
          Navigator.push(context, MaterialPageRoute(builder: (c) => page)),
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                // ignore: deprecated_member_use
                color: Colors.grey.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 5))
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(imagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (c, o, s) => Container(
                        // ignore: deprecated_member_use
                        color: color.withOpacity(0.3),
                        child: const Icon(Icons.image,
                            size: 80, color: Colors.white))),
              ),
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        // ignore: deprecated_member_use
                        Colors.black.withOpacity(0.8),
                        Colors.transparent
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold)),
                    Text(subtitle,
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 16)),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// ส่วนที่ 3.1: หน้ารายละเอียดการจัดการ (ปรับปรุง: ย้ายวิดีโอขึ้นบนสุด)
// ==========================================
class ManagementDetailsPage extends StatelessWidget {
  final String type;
  const ManagementDetailsPage({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    // ข้อมูลเนื้อหา (คงเดิม)
    final Map<String, dynamic> content = type == 'manage'
        ? {
            "title": "การจัดการขยะ (3R)",
            "video": "Z3zTXYwGAYE", // ID วิดีโอ 3R
            "image": "assets/images/3r_diagram.jpg",
            "theme": Colors.teal,
            "sections": [
              {
                "head": "หลักการ 3R คืออะไร?",
                "body":
                    "3R เป็นแนวคิดในการจัดการขยะที่เริ่มต้นที่นิสัยของเรา เพื่อลดปริมาณขยะให้เหลือน้อยที่สุด โดยเรียงลำดับความสำคัญดังนี้:"
              },
              {
                "head": "1. Reduce (คิดก่อนใช้)",
                "body":
                    "คือการลดการสร้างขยะตั้งแต่ต้นทาง\n• ปฏิเสธการรับถุงพลาสติกหากไม่จำเป็น\n• ใช้แก้วน้ำส่วนตัวแทนแก้วพลาสติก\n• ทานอาหารให้หมดไม่เหลือทิ้ง"
              },
              {
                "head": "2. Reuse (ใช้ซ้ำให้คุ้ม)",
                "body":
                    "คือการนำของที่ใช้แล้วมาใช้ซ้ำให้คุ้มค่าที่สุดก่อนทิ้ง\n• ใช้กระดาษให้ครบทั้ง 2 หน้า\n• นำกล่องคุ้กกี้มาใส่เข็มด้ายหรืออุปกรณ์\n• ซ่อมแซมอุปกรณ์ที่ชำรุดแทนการซื้อใหม่"
              },
              {
                "head": "3. Recycle (หมุนเวียนกลับมาใหม่)",
                "body":
                    "เมื่อใช้ซ้ำไม่ได้แล้ว ให้นำไปแปรรูป\n• คัดแยกขยะแต่ละประเภท (แก้ว, กระดาษ, พลาสติก, โลหะ)\n• รวบรวมขายให้ร้านรับซื้อของเก่า"
              },
            ]
          }
        : {
            "title": "การคัดแยกขยะที่ถูกวิธี",
            "video": "llUO0n1XNSI", // ID วิดีโอแยกขยะ
            "image": "assets/images/sorting_guide.jpg",
            "theme": Colors.indigo,
            "sections": [
              {
                "head": "ทำไมต้องแยกขยะ?",
                "body":
                    "การแยกขยะช่วยให้เจ้าหน้าที่ทำงานง่ายขึ้น ลดเชื้อโรค และทำให้ขยะรีไซเคิลไม่ปนเปื้อนจนเสียหาย"
              },
              {
                "head": "ขั้นตอนการเตรียมขยะรีไซเคิล (3 สเต็ปเทพ)",
                "body":
                    "1. ล้าง: ล้างคราบอาหารหรือนมออกด้วยน้ำเปล่าเล็กน้อย\n2. ตาก: คว่ำให้แห้ง เพื่อไม่ให้เกิดกลิ่นเหม็นเน่า\n3. บีบ: บีบขวดหรือกล่องให้แบน เพื่อประหยัดพื้นที่ถังขยะ"
              },
              {
                "head": "ข้อควรระวัง!",
                "body":
                    "❌ ห้ามทิ้งเศษอาหารรวมกับขยะรีไซเคิลเด็ดขาด เพราะจะทำให้กระดาษหรือพลาสติกสกปรกและราขึ้น จนไม่สามารถนำไปรีไซเคิลได้"
              },
              {
                "head": "แยกขยะอันตราย",
                "body":
                    "ถ่านไฟฉาย, หลอดไฟ, กระป๋องสเปรย์ ต้องแยกใส่ถุงสีแดง หรือเขียนหน้าถุงว่า 'ขยะอันตราย' เพื่อความปลอดภัยของพนักงานเก็บขยะ"
              },
            ]
          };

    final List sections = content['sections'];
    final Color themeColor = content['theme'];

    return BasePage(
      title: content['title'],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ==========================================
            // 1. ส่วนวิดีโอ (ย้ายขึ้นมาบนสุด)
            // ==========================================
            Container(
              margin: const EdgeInsets.only(bottom: 25),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      // ignore: deprecated_member_use
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10)
                ],
              ),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    decoration: BoxDecoration(
                        color: themeColor,
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(15))),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.ondemand_video, color: Colors.white),
                        SizedBox(width: 10),
                        Text("วิดีโอประกอบการเรียนรู้",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                      ],
                    ),
                  ),
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(15)),
                    child: MyVideoPlayer(youtubeId: content['video']),
                  ),
                ],
              ),
            ),

            // ==========================================
            // 2. ส่วนรูปภาพ (เลื่อนลงมา)
            // ==========================================
            Container(
              margin: const EdgeInsets.only(bottom: 25),
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    // ignore: deprecated_member_use
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  )
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  content['image'],
                  fit: BoxFit.cover,
                  errorBuilder: (c, o, s) => Container(
                    color: Colors.grey[300],
                    child: const Center(child: Icon(Icons.image, size: 50)),
                  ),
                ),
              ),
            ),

            // ==========================================
            // 3. ส่วนเนื้อหา
            // ==========================================
            const Padding(
              padding: EdgeInsets.only(bottom: 15),
              child: Text(
                "เนื้อหาความรู้",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),

            ...sections.map((sec) {
              return Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border(left: BorderSide(color: themeColor, width: 5)),
                  boxShadow: [
                    BoxShadow(
                        // ignore: deprecated_member_use
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 5,
                        offset: const Offset(0, 2))
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      sec['head'],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: themeColor,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      sec['body'],
                      style: const TextStyle(
                          fontSize: 16, height: 1.6, color: Colors.black87),
                    ),
                  ],
                ),
              );
              // ignore: unnecessary_to_list_in_spreads
            }).toList(),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// ส่วนที่ 3.2: หน้าถังขยะ 4 สี
// ==========================================
class BinColorsPage extends StatelessWidget {
  const BinColorsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bins = [
      {
        'color': Colors.green,
        'name': 'ถังเขียว (ขยะอินทรีย์)',
        'type': 'ย่อยสลายได้',
        'desc': 'ขยะเน่าเสียและย่อยสลายได้เร็ว สามารถนำมาหมักทำปุ๋ยได้',
        'ex': 'เศษอาหาร, ใบไม้, เปลือกผลไม้, ก้างปลา',
        'img': 'assets/images/bin_green.jpg'
      },
      {
        'color': Colors.blue,
        'name': 'ถังน้ำเงิน (ขยะทั่วไป)',
        'type': 'รีไซเคิลไม่ได้',
        'desc': 'ขยะที่ย่อยสลายยาก และไม่คุ้มค่าที่จะนำไปรีไซเคิล',
        'ex': 'ถุงพลาสติกเปื้อนแกง, ซองขนม, โฟม, ทิชชูใช้แล้ว',
        'img': 'assets/images/bin_blue.jpg'
      },
      {
        'color': Colors.amber,
        'name': 'ถังเหลือง (ขยะรีไซเคิล)',
        'type': 'ขายได้ / แปรรูปได้',
        'desc': 'ขยะแห้งที่สะอาด สามารถนำไปขายหรือเข้ากระบวนการผลิตใหม่',
        'ex': 'ขวดน้ำ, กระดาษลัง, กระป๋อง, แก้ว',
        'img': 'assets/images/bin_yellow.jpg'
      },
      {
        'color': Colors.red,
        'name': 'ถังแดง (ขยะอันตราย)',
        'type': 'มีพิษ / ติดเชื้อ',
        'desc': 'ขยะที่มีสารปนเปื้อนวัตถุอันตราย ไวไฟ หรือเชื้อโรค',
        'ex': 'ถ่านไฟฉาย, หลอดไฟ, กระป๋องสเปรย์, หน้ากากอนามัย',
        'img': 'assets/images/bin_red.jpg'
      },
    ];

    return BasePage(
      title: "ถังขยะ 4 สี",
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // ส่วนวิดีโอ
            Container(
              margin: const EdgeInsets.only(bottom: 25),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                        // ignore: deprecated_member_use
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10)
                  ]),
              child: const Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.video_library, color: Colors.orange),
                      SizedBox(width: 10),
                      Text("วิดีโอ: วิธีแยกขยะลงถัง 4 สี",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  SizedBox(height: 10),
                  MyVideoPlayer(youtubeId: "llUO0n1XNSI"),
                ],
              ),
            ),
            // รายการถังขยะ
            ...bins.map((bin) {
              Color binColor = bin['color'] as Color;
              return Container(
                margin: const EdgeInsets.only(bottom: 20),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: binColor, width: 2),
                    boxShadow: [
                      BoxShadow(
                          // ignore: deprecated_member_use
                          color: binColor.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 3))
                    ]),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(bin['img'] as String,
                        width: 80,
                        height: 100,
                        fit: BoxFit.contain,
                        errorBuilder: (c, o, s) =>
                            Icon(Icons.delete, size: 80, color: binColor)),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(bin['name'] as String,
                              style: TextStyle(
                                  color: binColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold)),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: binColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(bin['type'] as String,
                                style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                          ),
                          Text(bin['desc'] as String,
                              style: const TextStyle(fontSize: 14)),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(8)),
                            child: Row(
                              children: [
                                const Icon(Icons.info_outline,
                                    size: 16, color: Colors.grey),
                                const SizedBox(width: 5),
                                Expanded(
                                  child: Text("${bin['ex']}",
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey[800],
                                          fontStyle: FontStyle.italic)),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// ส่วนที่ 4: ผลกระทบและประโยชน์
// ==========================================
class ImpactAndBenefitMenuPage extends StatelessWidget {
  const ImpactAndBenefitMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    final impactData = [
      {
        "title": "1. ภาวะโลกร้อน (Global Warming)",
        "desc":
            "ขยะอินทรีย์ที่เน่าเสียปล่อยก๊าซมีเทน ร้ายแรงกว่า CO2 ถึง 25 เท่า ทำให้น้ำแข็งขั้วโลกละลาย",
        "img": "assets/images/pp.jpg"
      },
      {
        "title": "2. วิกฤตไมโครพลาสติก",
        "desc":
            "พลาสติกแตกตัวเป็นชิ้นเล็กๆ ปนเปื้อนในอาหารทะเล ย้อนกลับมาทำร้ายสุขภาพมนุษย์",
        "img": "assets/images/unnamed.jpg"
      },
      {
        "title": "3. มลพิษทางอากาศ",
        "desc":
            "การเผาขยะทำให้เกิดฝุ่น PM 2.5 และสารก่อมะเร็ง ทำลายระบบทางเดินหายใจ",
        "img": "assets/images/impact_air.jpg"
      },
      {
        "title": "4. แหล่งเพาะพันธุ์เชื้อโรค",
        "desc": "กองขยะหมักหมมเป็นบ้านของหนูและแมลงสาบ นำโรคระบาดสู่ชุมชน",
        "img": "assets/images/impact_disease.jpg"
      },
    ];

    final benefitData = [
      {
        "title": "1. ชุบชีวิตต้นไม้",
        "desc":
            "รีไซเคิลกระดาษ 1 ตัน ช่วยชีวิตต้นไม้ได้ 17 ต้น และประหยัดน้ำ 26,000 ลิตร",
        "img": "assets/images/Recycle1.jpg"
      },
      {
        "title": "2. สร้างรายได้",
        "desc":
            "ขวดพลาสติก กระป๋อง และกระดาษ มีราคารับซื้อ สร้างรายได้เสริมให้ครอบครัว",
        "img": "assets/images/benefit_money.jpg"
      },
      {
        "title": "3. ประหยัดพลังงาน",
        "desc": "รีไซเคิลอลูมิเนียมประหยัดพลังงานกว่าขุดแร่ใหม่ถึง 95%",
        "img": "assets/images/unnamed (1).jpg"
      },
      {
        "title": "4. ลดขยะล้นเมือง",
        "desc": "ช่วยลดพื้นที่บ่อฝังกลบ และลดงบประมาณกำจัดขยะของประเทศ",
        "img": "assets/images/yy.jpg"
      },
    ];

    return DefaultTabController(
      length: 2,
      child: BasePage(
        title: "ผลกระทบและประโยชน์",
        body: Column(
          children: [
            Container(
              color: Colors.white,
              child: const TabBar(
                labelColor: Color(0xFF2E7D32),
                unselectedLabelColor: Colors.grey,
                indicatorColor: Color(0xFF2E7D32),
                indicatorWeight: 3,
                labelStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Kanit'),
                tabs: [
                  Tab(text: "⚠️ ผลกระทบ"),
                  Tab(text: "🌿 ประโยชน์"),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildContentList(impactData, Colors.red, "4L2ZLr5BpNQ"),
                  _buildContentList(benefitData, Colors.teal, "49AwdTr46Bk"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentList(
      List<Map<String, String>> data, Color themeColor, String videoId) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        // วิดีโอ
        Container(
          margin: const EdgeInsets.only(bottom: 25),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
              boxShadow: [
                // ignore: deprecated_member_use
                BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8)
              ]),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                width: double.infinity,
                decoration: BoxDecoration(
                  // ignore: deprecated_member_use
                  color: themeColor.withOpacity(0.1),
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(15)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.video_library, color: themeColor),
                    const SizedBox(width: 8),
                    Text("วิดีโอประกอบการเรียนรู้",
                        style: TextStyle(
                            color: themeColor, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(bottom: Radius.circular(15)),
                child: MyVideoPlayer(youtubeId: videoId),
              ),
            ],
          ),
        ),

        ...data.map((item) {
          return Container(
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                    // ignore: deprecated_member_use
                    color: Colors.grey.withOpacity(0.15),
                    blurRadius: 6,
                    offset: const Offset(0, 3))
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: themeColor,
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(15)),
                  ),
                  width: double.infinity,
                  child: Text(
                    item['title']!,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                if (item['img']!.isNotEmpty)
                  SizedBox(
                    height: 180,
                    width: double.infinity,
                    child: Image.asset(
                      item['img']!,
                      fit: BoxFit.cover,
                      errorBuilder: (c, o, s) => Container(
                        color: Colors.grey[100],
                        child: const Center(
                            child: Icon(Icons.image, color: Colors.grey)),
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    item['desc']!,
                    style: const TextStyle(
                        fontSize: 16, height: 1.6, color: Colors.black87),
                  ),
                ),
              ],
            ),
          );
          // ignore: unnecessary_to_list_in_spreads
        }).toList(),
      ],
    );
  }
}

// ==========================================
// ส่วนที่ 5: หน้าเลือกประเภทขยะ
// ==========================================
class WasteCategoryListPage extends StatelessWidget {
  const WasteCategoryListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = WasteData.allData.keys.toList();

    return BasePage(
      title: "ประเภทขยะรีไซเคิล",
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: categories.length,
        separatorBuilder: (c, i) => const SizedBox(height: 15),
        itemBuilder: (ctx, i) {
          final catKey = categories[i];
          final catData = WasteData.allData[catKey];

          return GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (c) => WasteSubCategoryPage(
                  categoryName: catKey,
                  data: catData!,
                ),
              ),
            ),
            child: Container(
              height: 110,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    // ignore: deprecated_member_use
                    color: (catData!['color'] as Color).withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  )
                ],
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: Row(
                children: [
                  Container(
                    width: 90,
                    decoration: BoxDecoration(
                      color: catData['color'] as Color,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(18),
                        bottomLeft: Radius.circular(18),
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        catData['icon'] as IconData,
                        size: 45,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            catKey,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            "คลิกเพื่อดู ${catData['items'].length} รายการ",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Icon(
                      Icons.arrow_circle_right,
                      // ignore: deprecated_member_use
                      color: (catData['color'] as Color).withOpacity(0.5),
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ==========================================
// ส่วนที่ 5.1: หน้าแสดงรายการย่อย
// ==========================================
class WasteSubCategoryPage extends StatefulWidget {
  final String categoryName;
  final Map<String, dynamic> data;

  const WasteSubCategoryPage({
    super.key,
    required this.categoryName,
    required this.data,
  });

  @override
  State<WasteSubCategoryPage> createState() => _WasteSubCategoryPageState();
}

class _WasteSubCategoryPageState extends State<WasteSubCategoryPage> {
  @override
  Widget build(BuildContext context) {
    final List subItems = widget.data['items'] ?? [];
    final Color themeColor = widget.data['color'] as Color? ?? Colors.green;

    return BasePage(
      title: widget.categoryName,
      body: ListView.builder(
        padding: const EdgeInsets.all(15),
        itemCount: subItems.length + 1,
        itemBuilder: (ctx, i) {
          // --- ส่วนที่ 1: วิดีโอแนะนำ ---
          if (i == 0) {
            return Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                          // ignore: deprecated_member_use
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10)
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        const Icon(Icons.play_circle_fill,
                            color: Colors.red, size: 28),
                        const SizedBox(width: 10),
                        Text("วิดีโอเรียนรู้เรื่อง${widget.categoryName}",
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                      ]),
                      const SizedBox(height: 10),
                      MyVideoPlayer(youtubeId: widget.data['video']),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, bottom: 10),
                  child: Text("รายการขยะในหมวดนี้ (${subItems.length})",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: themeColor)),
                ),
              ],
            );
          }

          // --- ส่วนที่ 2: รายการเนื้อหา ---
          final index = i - 1;
          final item = subItems[index];

          final String name = item['name'] ?? 'ไม่มีชื่อ';
          final String imagePath = item['image'] ?? '';
          final String look = item['look'] ?? '-';
          final String ex = item['ex'] ?? '-';
          final String recycle = item['recycle'] ?? '-';

          return Card(
            margin: const EdgeInsets.only(bottom: 15),
            elevation: 3,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: ExpansionTile(
              textColor: themeColor,
              iconColor: themeColor,
              collapsedTextColor: Colors.black87,
              backgroundColor: Colors.white,
              collapsedBackgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              leading: CircleAvatar(
                // ignore: deprecated_member_use
                backgroundColor: themeColor.withOpacity(0.1),
                child: Text("${index + 1}",
                    style: TextStyle(
                        color: themeColor, fontWeight: FontWeight.bold)),
              ),
              title: Text(name,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16)),
              children: [
                Container(
                  width: double.infinity,
                  color: Colors.white,
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (imagePath.isNotEmpty)
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          height: 180,
                          width: double.infinity,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              imagePath,
                              fit: BoxFit.cover,
                              errorBuilder: (c, o, s) => Container(
                                color: Colors.grey[200],
                                child: const Center(
                                    child: Icon(Icons.image_not_supported,
                                        color: Colors.grey)),
                              ),
                            ),
                          ),
                        ),
                      const SizedBox(height: 10),
                      _buildDetailRow("ลักษณะ:", look, Colors.blue),
                      const SizedBox(height: 10),
                      _buildDetailRow("ตัวอย่าง:", ex, Colors.orange),
                      const SizedBox(height: 15),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          // ignore: deprecated_member_use
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                          border:
                              // ignore: deprecated_member_use
                              Border.all(color: Colors.green.withOpacity(0.3)),
                        ),
                        child: _buildDetailRow(
                            "วิธีจัดการ:", recycle, Colors.green),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                color: color, fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 4),
        Text(value,
            style: const TextStyle(
                color: Colors.black87, fontSize: 16, height: 1.5)),
      ],
    );
  }
}

// ==========================================
// ส่วนที่ 6: ผู้จัดทำ
// ==========================================
class AuthorPage extends StatelessWidget {
  const AuthorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ทีมผู้จัดทำ"),
        elevation: 0,
        backgroundColor: const Color(0xFF2E7D32),
      ),
      body: Stack(
        children: [
          Container(
            height: 250,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF2E7D32), Color(0xFF66BB6A)],
              ),
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30)),
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 10),
                const Text("PROJECT CREATORS",
                    style: TextStyle(
                        color: Color.fromARGB(234, 242, 241, 241),
                        letterSpacing: 2,
                        fontWeight: FontWeight.bold)),
                const Text("ขยะคืนชีพ",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 30),
                _buildModernProfileCard(
                    "นางสาวรุ่งธิดา ผาสีดา",
                    "นักศึกษาชั้นปีที่ 2",
                    "assets/images/student1.jpg",
                    "Lin ʚìɞ",
                    "082-135-9369"),
                const SizedBox(height: 20),
                _buildModernProfileCard(
                    "นางสาววริศรา เทียวไทย",
                    "นักศึกษาชั้นปีที่ 2",
                    "assets/images/student2.jpg",
                    "Warisara Thiawthai",
                    "088-615-3291"),
                const SizedBox(height: 30),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                          // ignore: deprecated_member_use
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 5))
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                            // ignore: deprecated_member_use
                            color: Colors.orange.withOpacity(0.1),
                            shape: BoxShape.circle),
                        child: const Icon(Icons.school,
                            color: Colors.orange, size: 30),
                      ),
                      const SizedBox(width: 15),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("แผนกวิชาเทคโนโลยีธุรกิจดิจิทัล",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16)),
                            Text("ประกาศนียบัตรวิชาชีพชั้นสูง (ปวส.)",
                                style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernProfileCard(
      String name, String role, String imagePath, String fbName, String phone) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              // ignore: deprecated_member_use
              color: Colors.black.withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, 5))
        ],
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomCenter,
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                  image: const DecorationImage(
                      image: AssetImage("assets/images/Recycle1.jpg"),
                      fit: BoxFit.cover,
                      opacity: 0.5),
                  color: Colors.green[100],
                ),
              ),
              Positioned(
                top: 30,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                      color: Colors.white, shape: BoxShape.circle),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[200],
                    backgroundImage: AssetImage(imagePath),
                    child: const Align(
                        alignment: Alignment.bottomRight,
                        child: Icon(Icons.check_circle,
                            color: Colors.blue, size: 24)),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 60),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              children: [
                Text(name,
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2E7D32))),
                const SizedBox(height: 5),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                      // ignore: deprecated_member_use
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20)),
                  child: Text(role,
                      style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 12)),
                ),
                const SizedBox(height: 15),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.facebook, color: Colors.blue),
                      const SizedBox(width: 8),
                      Text(fbName, style: const TextStyle(fontSize: 14)),
                      const SizedBox(width: 20),
                      const Icon(Icons.phone, color: Colors.green),
                      const SizedBox(width: 8),
                      Text(phone, style: const TextStyle(fontSize: 14)),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// ส่วนที่ 7: ระบบค้นหา
// ==========================================
class WasteSearchDelegate extends SearchDelegate {
  @override
  String get searchFieldLabel => 'พิมพ์ชื่อขยะ (เช่น ขวด, กล่อง)';

  @override
  TextStyle? get searchFieldStyle =>
      const TextStyle(fontFamily: 'Kanit', fontSize: 16);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(icon: const Icon(Icons.clear), onPressed: () => query = ''),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => close(context, null));
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildResultList(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildResultList(context);
  }

  Widget _buildResultList(BuildContext context) {
    final List<Map<String, dynamic>> allItems = [];
    WasteData.allData.forEach((category, data) {
      for (var item in (data['items'] as List)) {
        allItems.add({
          'name': item['name'],
          'category': category,
          'data': data,
          'matchWord': item['ex'] ?? ''
        });
      }
    });

    final results = query.isEmpty
        ? []
        : allItems.where((element) {
            final String name = element['name'].toString().toLowerCase();
            final String category =
                element['category'].toString().toLowerCase();
            final String examples =
                element['matchWord'].toString().toLowerCase();
            final String search = query.toLowerCase();
            return name.contains(search) ||
                category.contains(search) ||
                examples.contains(search);
          }).toList();

    if (results.isEmpty && query.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off, size: 50, color: Colors.grey),
            const SizedBox(height: 10),
            Text('ไม่พบข้อมูลเกี่ยวกับ "$query"',
                style: const TextStyle(fontSize: 18, color: Colors.grey)),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final item = results[index];
        return ListTile(
          leading: Icon(Icons.recycling, color: Colors.green[700]),
          title: RichText(
            text: TextSpan(
              text: item['name'],
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Kanit',
                  fontSize: 16),
              children: [
                TextSpan(
                    text: " (${item['category']})",
                    style: const TextStyle(color: Colors.grey, fontSize: 14)),
              ],
            ),
          ),
          subtitle: Text(item['matchWord'],
              maxLines: 1, overflow: TextOverflow.ellipsis),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => WasteSubCategoryPage(
                      categoryName: item['category'], data: item['data'])),
            );
          },
        );
      },
    );
  }
}

// ==========================================
// ส่วนสำคัญ: Custom Video Player (ฉบับอัปเกรด ใช้ Iframe เสถียร 100%)
// ==========================================
class MyVideoPlayer extends StatelessWidget {
  final String? youtubeId;
  const MyVideoPlayer({super.key, this.youtubeId});

  Future<void> _launchUrl() async {
    if (youtubeId == null) return;
    final Uri url = Uri.parse('https://www.youtube.com/watch?v=$youtubeId');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (youtubeId == null || youtubeId!.isEmpty) {
      return Container(
        height: 200,
        color: Colors.grey[900],
        child: const Center(
          child: Icon(Icons.error, color: Colors.white),
        ),
      );
    }

    return GestureDetector(
      onTap: _launchUrl,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // ภาพปกคลิป (Thumbnail)
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black,
              image: DecorationImage(
                image: NetworkImage(
                    'https://img.youtube.com/vi/$youtubeId/hqdefault.jpg'),
                fit: BoxFit.cover,
                onError: (exception, stackTrace) {},
              ),
            ),
          ),
          // ปุ่ม Play
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.9),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.play_arrow,
              color: Colors.white,
              size: 40,
            ),
          ),
          // ข้อความแนะนำ
          Positioned(
            bottom: 10,
            right: 15,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                "แตะเพื่อรับชม",
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// ส่วนที่ 8: ฐานข้อมูล (DATABASE)
// ==========================================
class WasteData {
  static final Map<String, dynamic> allData = {
    "พลาสติก": {
      "icon": Icons.local_drink,
      "color": Colors.orange,
      "video": "aUkErvy093U",
      "items": [
        {
          "name": "พลาสติกเพท เบอร์ 1 (PET / PETE)",
          "look": "ใส มองทะลุได้ เหมือนแก้วแต่เบากว่า",
          "ex": "ขวดน้ำดื่ม, ขวดน้ำอัดลม, ขวดน้ำมันพืช, ขวดน้ำยาบ้วนปาก",
          "recycle":
              "นำไปแปรรูปเป็นเส้นใยสังเคราะห์ทำเสื้อผ้า, พรม, หรือขวดน้ำใบใหม่",
          "image": "assets/images/plastic_pet.jpg"
        },
        {
          "name": "พลาสติกเฮชดีพีอี เบอร์ 2 (HDPE)",
          "look": "หนา ทึบแสง เหนียว แข็งแรง",
          "ex":
              "ขวดแชมพู, ขวดนม, ขวดแป้งเด็ก, ถังน้ำมัน, แกลลอนน้ำยาทำความสะอาด",
          "recycle": "นำไปหลอมเป็นท่อประปา, ถังขยะ, ไม้เทียม",
          "image": "assets/images/plastic_hdpe.jpg"
        },
        {
          "name": "พีวีซี เบอร์ 3 (PVC)",
          "look": "แข็งมาก หรือเป็นพลาสติกหนังเทียม มีกลิ่นเฉพาะเมื่อเผา",
          "ex": "ท่อประปา, สายยาง, สายไฟ, ม่านห้องน้ำ, แผ่นพลาสติกปูโต๊ะ",
          "recycle":
              "อันตราย! หากเผาจะเกิดสารพิษ รีไซเคิลยาก ควรแยกทิ้งต่างหาก",
          "image": "assets/images/plastic_pvc.jpeg"
        },
        {
          "name": "แอลดีพีอี เบอร์ 4 (LDPE)",
          "look": "นิ่ม ยืดหยุ่น ใสแต่ไม่กรอบ",
          "ex": "ถุงพลาสติกหูหิ้ว, ถุงเย็นใส่อาหาร, ฟิล์มห่ออาหาร (Wrap)",
          "recycle":
              "มักนำไปทำเชื้อเพลิง (RDF) หรือส่งโครงการ 'วน' เพื่อรีไซเคิลเป็นถุงใหม่",
          "image": "assets/images/plastic_ldpe.jpg"
        },
        {
          "name": "พีพี เบอร์ 5 (PP)",
          "look": "ทนความร้อนได้ดี (เข้าไมโครเวฟได้) มีความยืดหยุ่น",
          "ex": "กล่องใส่อาหารเวฟ, ถ้วยโยเกิร์ต, แก้วน้ำพลาสติกแข็ง, ฝาขวดน้ำ",
          "recycle": "แปรรูปเป็นกล่องแบตเตอรี่, ชิ้นส่วนรถยนต์, ไม้กวาดพลาสติก",
          "image": "assets/images/plastic_pp.jpg"
        },
        {
          "name": "พีเอส เบอร์ 6 (PS)",
          "look": "กรอบ แตกง่าย หรือเป็น 'โฟม'",
          "ex": "กล่องโฟม, ช้อนส้อมพลาสติก (ใช้แล้วทิ้ง), กล่องใส่อาหารใสๆ",
          "recycle": "ขายไม่ได้ราคา ไม่ค่อยรับซื้อ ควรหลีกเลี่ยงการใช้",
          "image": "assets/images/plastic_ps.jpg"
        },
        {
          "name": "พลาสติกอื่นๆ เบอร์ 7 (Other)",
          "look": "พลาสติกผสม หรือชนิดอื่นๆ ที่ไม่ใช่ 6 ข้อแรก (Polycarbonate)",
          "ex":
              "ขวดนมเด็ก (บางรุ่น), ซองขนม (ที่ด้านในเป็นฟอยล์), หลอดยาสีฟัน (แบบผสมอลูมิเนียม)",
          "recycle":
              "ยากที่สุด มักต้องส่งไปทำเชื้อเพลิงพลังงาน หรือทำบล็อกปูถนน (Green Road)",
          "image": "assets/images/plastic_other.jpg"
        },
      ]
    },
    "กระดาษ": {
      "icon": Icons.newspaper,
      "color": Colors.brown,
      "video": "R28yf05Qvts",
      "items": [
        {
          "name": "กระดาษขาว-ดำ",
          "look": "สีขาว เนื้อเนียน ไม่มันวาว มีเฉพาะหมึกสีดำ",
          "ex": "กระดาษ A4 ถ่ายเอกสาร, ข้อสอบ, ชีทเรียน",
          "recycle": "แปรรูปกลับมาเป็นกระดาษทิชชู, สมุดรีไซเคิล",
          "image": "assets/images/paper_white.png"
        },
        {
          "name": "กระดาษลัง/ลูกฟูก",
          "look": "สีน้ำตาล หนา มีชั้นลอนคลื่นตรงกลาง",
          "ex": "กล่องพัสดุไปรษณีย์, ลังเบียร์, ลังเครื่องใช้ไฟฟ้า",
          "recycle": "ทำกล่องลังใบใหม่, ถุงกระดาษสีน้ำตาล",
          "image": "assets/images/paper_box.jpg"
        },
        {
          "name": "หนังสือพิมพ์",
          "look": "เนื้อบาง เปื่อยง่าย สีออกเทา หมึกติดมือ",
          "ex": "หนังสือพิมพ์รายวัน",
          "recycle": "ทำแผงไข่ไก่, ถาดรองผลไม้",
          "image": "assets/images/paper_news.jpg"
        },
        {
          "name": "กระดาษเล่ม/สมุด (Books & Magazines)",
          "look": "เข้าเล่มเป็นหนังสือ มีสันกาวหรือลวดเย็บ",
          "ex": "สมุดการบ้าน หนังสือเรียนเก่า พ็อกเก็ตบุ๊ก",
          "recycle": "กระดาษพิมพ์เขียนเกรดรอง, เชื้อเพลิง",
          "image": "assets/images/paper_book.jpg"
        },
        {
          "name": "กระดาษจั๊บ/กล่องสี (Mixed Paper / Boxboard)",
          "look": "กระดาษแข็ง ไม่มีลอนลูกฟูก มีสีสัน หรือเคลือบมันบางๆ",
          "ex":
              "กล่องสบู่, ยาสีฟัน, กล่องรองเท้า, กล่องซีเรียล, ใบปลิว, โบรชัวร์, แกนทิชชู",
          "recycle": "กล่องรองเท้า, ปกหลังสมุด, แกนทิชชู",
          "image": "assets/images/paper_mixed.jpg"
        },
        {
          "name": "กล่อง UHT (กล่องเครื่องดื่ม)",
          "look": "มี 3 ชั้น: กระดาษ + พลาสติก + อลูมิเนียมฟอยล์",
          "ex": "กล่องนม, กล่องน้ำผลไม้, กล่องกะทิ",
          "recycle":
              "แยกชิ้นส่วนทำหลังคาเขียว, โต๊ะ-เก้าอี้ (ต้องล้างและพับให้แบน)",
          "image": "assets/images/paper_uht.jpg"
        },
      ]
    },
    "แก้ว": {
      "icon": Icons.wine_bar,
      "color": Colors.green,
      "video": "qvV_RU-Ddzs",
      "items": [
        {
          "name": "ขวดแก้วใส",
          "look": "โปร่งใส ไม่มีสี มองเห็นข้างในชัดเจน",
          "ex": "ขวดน้ำอัดลม, โซดา, ขวดน้ำปลา, ขวดแยม",
          "recycle": "หลอมเป็นขวดแก้วใสใบใหม่ (ราคารับซื้อดี)",
          "image": "assets/images/glass_clear.jpg"
        },
        {
          "name": "ขวดแก้วสีชา",
          "look": "สีน้ำตาลเข้ม ช่วยกรองแสง",
          "ex": "ขวดเครื่องดื่มชูกำลัง, ขวดเบียร์, ขวดยา",
          "recycle": "หลอมเป็นขวดแก้วสีชาใบใหม่",
          "image": "assets/images/glass_amber.jpg"
        },
        {
          "name": "ขวดแก้วสีเขียว",
          "look": "สีเขียว (มักเจอในเครื่องดื่มแอลกอฮอล์)",
          "ex": "ขวดเบียร์, ขวดไวน์, ขวดน้ำแร่บางยี่ห้อ",
          "recycle": "หลอมเป็นขวดแก้วสีเขียวใบใหม่",
          "image": "assets/images/glass_green.jpg"
        },
        {
          "name": "เศษแก้วแตก (Broken Glass / Cullet)",
          "look": "แก้ว 3 ประเภทข้างต้นที่แตกหักเสียหาย",
          "ex": "เศษขวดที่แตกแล้ว",
          "recycle":
              "นำไปหลอมใหม่ได้เหมือนขวดปกติ (แต่ร้านรับซื้อมักให้ราคาต่ำหรือไม่รับ เพราะอันตรายและขนย้ายยาก)",
          "image": "assets/images/glass_broken.jpg"
        },
      ]
    },
    "โลหะ": {
      "icon": Icons.settings,
      "color": Colors.blueGrey,
      "video": "RMaUlYYaflM",
      "items": [
        {
          "name": "กระป๋องอลูมิเนียม",
          "look": "น้ำหนักเบา บีบง่าย ก้นเว้า แม่เหล็กดูดไม่ติด",
          "ex": "กระป๋องน้ำอัดลม, กระป๋องเบียร์",
          "recycle": "ทำขาเทียม, ชิ้นส่วนเครื่องบิน, กระป๋องใบใหม่",
          "image": "assets/images/metal_can.png"
        },
        {
          "name": "กระป๋องเหล็ก/สังกะสี",
          "look": "แข็งกว่าอลูมิเนียม มีรอยตะเข็บข้าง แม่เหล็กดูดติด",
          "ex": "ปลากระป๋อง, กระป๋องนมข้นหวาน, กระป๋องกาแฟ",
          "recycle": "หลอมเป็นเหล็กเส้นก่อสร้าง",
          "image": "assets/images/metal_tin.jpg"
        },
        {
          "name": "เศษเหล็กทั่วไป",
          "look": "โลหะแข็ง หนัก เป็นสนิมได้",
          "ex": "ตะปู, น็อต, สังกะสีเก่า, จักรยานเก่า",
          "recycle": "หลอมใหม่ทำวัสดุก่อสร้าง",
          "image": "assets/images/metal_scrap.jpg"
        },
        {
          "name": "สแตนเลส (Stainless Steel)",
          "look":
              "ผิวเงาวาว แข็งมาก ไม่เป็นสนิม แม่เหล็กมักดูดไม่ติด (เกรด 304)",
          "ex": "ช้อนส้อม, หม้อสแตนเลส, แก้วเก็บความเย็น, ซิงค์ล้างจาน",
          "recycle": "เครื่องครัวสแตนเลส, เครื่องมือแพทย์",
          "image": "assets/images/metal_stainless.jpg"
        },
        {
          "name": "ทองแดง/ทองเหลือง (Copper / Brass)",
          "look":
              "ทองแดง: สีแดงอิฐ (อยู่ในสายไฟ) / ทองเหลือง: สีทอง (หนักกว่าทองแดง)",
          "ex": "ไส้สายไฟ (ปอกพลาสติกออก) ก็อกน้ำทองเหลือง พาน, แจกันทองเหลือง",
          "recycle": "สายไฟใหม่, อุปกรณ์อิเล็กทรอนิกส์",
          "image": "assets/images/metal_copper.jpg"
        },
        {
          "name": "อลูมิเนียมหล่อ/หนา (Cast Aluminum)",
          "look": "เป็นอลูมิเนียมที่ขึ้นรูปหนา ไม่ใช่กระป๋องบางๆ",
          "ex": "หม้อข้าว, กะทะ, ขอบหน้าต่างอลูมิเนียม, ส่วนประกอบเครื่องยนต์",
          "recycle": "ชิ้นส่วนเครื่องจักร, กรอบหน้าต่าง",
          "image": "assets/images/metal_cast.jpg"
        },
      ]
    },
    "E-Waste": {
      "icon": Icons.phonelink,
      "color": Colors.redAccent,
      "video": "cXKPEhZf7JQ",
      "items": [
        {
          "name": "โทรศัพท์มือถือและอุปกรณ์",
          "look": "มีแผงวงจร แบตเตอรี่ หน้าจอ",
          "ex": "มือถือเก่า, สายชาร์จ, หูฟัง, Power Bank",
          "recycle": "สกัดแยกทองคำ เงิน ทองแดง จากแผงวงจร",
          "image": "assets/images/ewaste_phone.jpg"
        },
        {
          "name": "เครื่องใช้ไฟฟ้าขนาดใหญ่",
          "look": "ขนาดใหญ่ มีมอเตอร์",
          "ex": "ตู้เย็น, เครื่องซักผ้า, แอร์",
          "recycle": "แยกชิ้นส่วนเหล็ก พลาสติก ทองแดง",
          "image": "assets/images/ewaste_large.jpg"
        },
        {
          "name": "เครื่องใช้ไฟฟ้าขนาดเล็ก (Small Appliances)",
          "look": "ใช้งานในครัวเรือนทั่วไป เคลื่อนย้ายง่าย",
          "ex":
              "เตารีด, เครื่องปั่น, หม้อหุงข้าว, ไดร์เป่าผม, เครื่องดูดฝุ่น, พัดลม",
          "recycle": "ทองแดง (จากสายไฟ/มอเตอร์), พลาสติก, เหล็ก",
          "image": "assets/images/ewaste_small.jpg"
        },
        {
          "name": "อุปกรณ์เพื่อความบันเทิง (Consumer Equipment)",
          "look": "มักมีหน้าจอ หรือเลนส์ประกอบ",
          "ex": "ทีวี (LCD, LED, จอแก้ว), กล้องถ่ายรูป, วิทยุ, เครื่องเล่นเกม",
          "recycle": "แก้วหน้าจอ, พลาสติก, แผงวงจร, ทองแดง",
          "image": "assets/images/ewaste_game.jpg"
        },
        {
          "name": "แบตเตอรี่/ถ่านไฟฉาย",
          "look": "ทรงกระบอก หรือก้อนสี่เหลี่ยม มีขั้วบวกขั้วลบ",
          "ex": "ถ่าน AA, AAA, แบตเตอรี่โน้ตบุ๊ก",
          "recycle":
              "แยกทิ้งถังขยะอันตราย (สีแดง) เพื่อสกัดแร่ธาตุอย่างถูกวิธี",
          "image": "assets/images/ewaste_battery.jpg"
        },
        {
          "name": "อุปกรณ์แสงสว่าง (Lighting Equipment)",
          "look": "เปราะบางแตกหักง่าย มีสารเคมีภายใน",
          "ex": "หลอดไฟนีออน (ยาว), หลอดตะเกียบ (CFL), หลอด LED",
          "recycle": "ต้องกำจัดสารปรอทก่อน นำแก้วและขั้วโลหะไปรีไซเคิล",
          "image": "assets/images/ewaste_light.jpg"
        },
      ]
    }
  };
}
