import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portal_berita/Page/Profile/login_page.dart';
import 'package:portal_berita/api/api_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isEmpty = true;

  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  Future<void> register() async {
    try {
      final responseData = await ApiService.register(name.text, email.text, password.text);
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            title: Text('Registration Successful',
              style: GoogleFonts.poppins(
              color: Colors.red,
              fontWeight: FontWeight.w500,
            ),),
            content: Text('Akun anda berhasil dibuat',
              style: GoogleFonts.poppins(
              color: Colors.black,
            ),), // Kosongkan konten jika tidak ada konten tambahan yang diperlukan
            actions: <Widget>[
              TextButton(
                child: Text(
                  'OK',
                  style: GoogleFonts.poppins(
                    color: Colors.red,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => LoginPage(),
                  ));
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        iconTheme: IconThemeData(color: Colors.red),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Sign Up", style: GoogleFonts.openSans(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: 30,),

                  Image.asset("images/agam-logo.png",
                    fit: BoxFit.cover,
                    width: 80,
                    height: 100,
                  ),
                  SizedBox(height: 25,),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Nama", style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: Colors.red)),
                      SizedBox(height: 10,),

                      TextFormField(
                        controller: name,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5)),
                          hintText: "Masukkan Nama",
                          suffixIcon: Icon(Icons.person, color: Colors.red),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Nama harus diisi.';
                          }
                          return null; // Return null jika validasi berhasil
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 20,),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Email",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: Colors.red)),
                      SizedBox(height: 10,),

                      TextFormField(
                        controller: email,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5)),
                          hintText: "Masukkan Email",
                          suffixIcon: Icon(Icons.email, color: Colors.red),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Email harus diisi.';
                          }
                          return null; // Return null jika validasi berhasil
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 20,),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Password", style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: Colors.red)),
                      SizedBox(height: 10,),

                      TextFormField(
                        controller: password,
                        obscureText: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5)),
                          hintText: "Masukkan Password",
                          suffixIcon: Icon(Icons.lock, color: Colors.red),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Password harus diisi.';
                          }
                          if (value.length < 8) {
                            return 'Password harus memiliki setidaknya 8 karakter.';
                          }
                          return null; // Return null jika validasi berhasil
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 20,),

                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          padding: EdgeInsets.all(20),
                          backgroundColor: Colors.red,
                          textStyle: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold)),
                      child: Text("Sign Up"),
                      onPressed: () {
                        // Memeriksa apakah form valid sebelum melakukan pendaftaran
                        if (_formKey.currentState!.validate()) {
                          // Form valid, lanjutkan dengan pendaftaran
                          register();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
