import 'package:flutter/material.dart';

class Dashbord extends StatelessWidget {
  const Dashbord({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color.fromARGB(255, 18, 32, 47),
      ),
      home: Scaffold(
        body: ListView(children: const [
          LoginCreateAcount(),
        ]),
      ),
    );
  }
}

class LoginCreateAcount extends StatelessWidget {
  const LoginCreateAcount({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 1080,
          height: 1920,
          clipBehavior: Clip.antiAlias,
          decoration: const BoxDecoration(color: Colors.white),
          child: Stack(
            children: [
              Positioned(
                left: 0,
                top: 0,
                child: Container(
                  width: 1080,
                  height: 1827,
                  decoration: const BoxDecoration(color: Color(0xFF2E7D32)),
                ),
              ),
              Positioned(
                left: 0,
                top: 801,
                child: Container(
                  width: 1080,
                  height: 1119,
                  decoration: const ShapeDecoration(
                    color: Color(0xFFFFCA28),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(100),
                        topRight: Radius.circular(100),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 55,
                top: 1105,
                child: Container(
                  width: 970,
                  height: 155,
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(55),
                    ),
                  ),
                ),
              ),
              const Positioned(
                left: 92,
                top: 1155,
                child: Text(
                  'Password',
                  style: TextStyle(
                    color: Color(0xFF575050),
                    fontSize: 48,
                    fontFamily: 'Asap Condensed',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Positioned(
                left: 882,
                top: 1124,
                child: Opacity(
                  opacity: 0.66,
                  child: Container(
                    width: 124,
                    height: 124,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage("https://placehold.co/124x124"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 55,
                top: 914,
                child: Container(
                  width: 970,
                  height: 155,
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(55),
                    ),
                  ),
                ),
              ),
              const Positioned(
                left: 92,
                top: 964,
                child: Text(
                  'NIK',
                  style: TextStyle(
                    color: Color(0xFF575050),
                    fontSize: 48,
                    fontFamily: 'Asap Condensed',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Positioned(
                left: 375,
                top: 1315,
                child: Container(
                  width: 331,
                  height: 105,
                  decoration: ShapeDecoration(
                    color: const Color(0xFF1CC625),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(84),
                    ),
                  ),
                ),
              ),
              const Positioned(
                left: 480,
                top: 1339,
                child: Text(
                  'Masuk',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 50,
                    fontFamily: 'Asap Condensed',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Positioned(
                left: 419,
                top: 1471,
                child: Container(
                  width: 241,
                  height: 7,
                  decoration: const BoxDecoration(color: Colors.white),
                ),
              ),
              Positioned(
                left: 512,
                top: 1456,
                child: Container(
                  width: 55,
                  height: 7,
                  decoration: const BoxDecoration(color: Colors.white),
                ),
              ),
              Positioned(
                left: 512,
                top: 1486,
                child: Container(
                  width: 55,
                  height: 7,
                  decoration: const BoxDecoration(color: Colors.white),
                ),
              ),
              Positioned(
                left: 419,
                top: 837,
                child: Container(
                  width: 241,
                  height: 7,
                  decoration: const BoxDecoration(color: Colors.white),
                ),
              ),
              Positioned(
                left: 788,
                top: 1327,
                child: Container(
                  width: 236,
                  height: 3,
                  decoration: const BoxDecoration(color: Colors.black),
                ),
              ),
              const Positioned(
                left: 788,
                top: 1278,
                child: Text(
                  'Lupa Password ?',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 40,
                    fontFamily: 'Asap Condensed',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Positioned(
                left: 379,
                top: 152,
                child: Container(
                  width: 321,
                  height: 354,
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(),
                  child: const Stack(),
                ),
              ),
              const Positioned(
                left: 163,
                top: 523,
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'TANGGAPAN',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 128,
                          fontFamily: 'Chewy',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      TextSpan(
                        text: 'KU',
                        style: TextStyle(
                          color: Color(0xFF00FF0C),
                          fontSize: 128,
                          fontFamily: 'Chewy',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: -84.31,
                top: 1646,
                child: Container(
                  transform: Matrix4.identity()
                    ..translate(0.0, 0.0)
                    ..rotateZ(0.56),
                  width: 542,
                  height: 245.63,
                  decoration: const BoxDecoration(color: Colors.white),
                ),
              ),
              Positioned(
                left: 1237.65,
                top: 1821.60,
                child: Container(
                  transform: Matrix4.identity()
                    ..translate(0.0, 0.0)
                    ..rotateZ(2.58),
                  width: 542,
                  height: 207.16,
                  decoration: const BoxDecoration(color: Colors.white),
                ),
              ),
              Positioned(
                left: -131.31,
                top: 1513,
                child: Container(
                  transform: Matrix4.identity()
                    ..translate(0.0, 0.0)
                    ..rotateZ(0.56),
                  width: 819.61,
                  height: 88,
                  decoration: const BoxDecoration(color: Color(0xFFFF0000)),
                ),
              ),
              Positioned(
                left: 1221.43,
                top: 1587.59,
                child: Container(
                  transform: Matrix4.identity()
                    ..translate(0.0, 0.0)
                    ..rotateZ(2.58),
                  width: 819.61,
                  height: 88,
                  decoration: const BoxDecoration(color: Color(0xFFFF0000)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
