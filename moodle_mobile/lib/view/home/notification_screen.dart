import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              elevation: 10,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.2,
                padding: EdgeInsets.only(top: 8, right: 5, left: 18, bottom: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "CLC_HK1_2122_CSC12107_18HTTT",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Card(
                            elevation: 5,
                            color: Colors.blue[50],
                            child: Padding(
                              padding: const EdgeInsets.all(3),
                              child: Text("18/03/2021"),
                            )),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.75,
                              child: RichText(
                                text: TextSpan(
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.black),
                                    children: [
                                      TextSpan(
                                          text: 'Tiết Gia Hồng ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      TextSpan(
                                        text: 'posted in ',
                                      ),
                                      TextSpan(
                                          text: 'quản trị cơ sở dữ liệu',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                    ]),
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                            onPressed: () {}, icon: Icon(Icons.arrow_right))
                      ],
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.6,
                      //height: MediaQuery.of(context).size.height * 0.1,
                      child: RichText(
                        text: TextSpan(
                            style: TextStyle(fontSize: 14, color: Colors.black),
                            children: [
                              TextSpan(
                                  text: 'hiện đại:',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(
                                text:
                                    '[THÔNG BÁO KIỂM TRA ĐIỂM THỰC HÀNH CUỐI KỲ]',
                              ),
                            ]),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
