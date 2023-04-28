import 'package:flutter/material.dart';

class NoConnection extends StatefulWidget {
  const NoConnection({ Key? key }) : super(key: key);

  @override
  _NoConnectionState createState() => _NoConnectionState();
}

class _NoConnectionState extends State<NoConnection> {
  @override
  Widget build(BuildContext context) {
    return  Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.5,
            decoration: BoxDecoration(

              image: DecorationImage(
                image: AssetImage('assets/no-connection.gif')
              )
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 50),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(60),
                  topRight: Radius.circular(60),
                ),
              ),
              child: Column(
                children: [
                  Text("Ooops! 😓", style: TextStyle(fontSize: 32, fontWeight: FontWeight.w500, color: Colors.black),),
                  SizedBox(height: 15,),
                  Text("No internet connection found. Check your connection or try again.",
                  textAlign: TextAlign.center, style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),),

                  // MaterialButton(
                  //   onPressed: () {},
                  //   height: 45,
                  //   padding: EdgeInsets.symmetric(horizontal: 50),
                  //   elevation: 0,
                  //   shape: RoundedRectangleBorder(
                  //     borderRadius: BorderRadius.circular(10)
                  //   ),
                  //   color: Colors.orange.shade400,
                  //   child: Text("Try Again", style: TextStyle(color: Colors.white),),
                  // )
                ],
              ),
            ),
          )
        ],

    );
  }
}