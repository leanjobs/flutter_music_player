import 'package:flutter/material.dart';
import 'package:music_player/navigationBar/BottomBar.dart';

class ResetPassword extends StatelessWidget {
  const ResetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("images/imgPrev3.png"), fit: BoxFit.cover),
        ),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF191A1E).withOpacity(0.1),
                    Color(0xFF191A1E).withOpacity(0.8),
                    Color(0xFF191A1E).withOpacity(1.0),
                    Color(0xFF191A1E),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding:
                      EdgeInsets.only(right: 30, left: 30, bottom: 70, top: 20),
                  child: Stack(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 100),
                        width: MediaQuery.of(context).size.width - 60,
                        height: MediaQuery.of(context).size.height - 500,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20)),
                        child: Container(
                          margin: EdgeInsets.only(top: 60),
                          padding: EdgeInsets.all(30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Reset Password",
                                style: TextStyle(
                                    fontSize: 36, fontWeight: FontWeight.w900),
                              ),
                              SizedBox(height: 20),
                              TextFormField(
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide:
                                            BorderSide(color: Colors.grey)),
                                    hintText: "Email",
                                    hintStyle: TextStyle(
                                      fontSize: 15,
                                      color: Colors.grey.withOpacity(0.5),
                                    ),
                                    prefixIcon: Icon(Icons.mail_lock_outlined)),
                              ),
                              SizedBox(height: 10),
                              TextFormField(
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide:
                                            BorderSide(color: Colors.grey)),
                                    hintText: "Password",
                                    hintStyle: TextStyle(
                                      fontSize: 15,
                                      color: Colors.grey.withOpacity(0.5),
                                    ),
                                    prefixIcon: Icon(Icons.key_outlined)),
                              ),
                              SizedBox(height: 50),
                              SizedBox(
                                width: double.infinity,
                                height: 60,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return BottomBar();
                                    }));
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFFD9D9D9),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    padding: EdgeInsets.symmetric(vertical: 15),
                                  ),
                                  child: Text(
                                    "Done",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                          left: (MediaQuery.of(context).size.width - 260) / 2,
                          top: -20,
                          child: Container(
                            height: 200,
                            width: 200,
                            child: Image.asset("images/onlyLogo.png"),
                          ))
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}