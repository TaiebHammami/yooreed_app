import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import 'package:flutter/material.dart';

class SecteurPartenaireShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
            padding: EdgeInsets.all(20),
            child:Shimmer.fromColors(baseColor: Get.isDarkMode ? Colors.white70 : Colors.white,
             highlightColor:Get.isDarkMode ? Colors.grey.shade100 : Colors.white54,

              period: Duration(milliseconds: 1000),
              child: ListView.separated(
                physics: NeverScrollableScrollPhysics(),
                itemCount: 10,
                itemBuilder: (context, index) {

                  return ShimmerItem();
                },
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(
                    height: 16,
                  );
                },
              ),
            )),
      ),
    );
  }
}

class ShimmerItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
          alignment: Alignment.center,

          children: [
                Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.only(bottom: 15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Theme.of(context).bottomAppBarColor,

                   ),
                child: Column(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                      color: Colors.green.withAlpha(30),
                                  borderRadius: BorderRadius.circular(12),
                                ))
                          ),
                          SizedBox(width: 10),
                          Flexible(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 90,
                                    height: 7,
                                     decoration: BoxDecoration(
                                      color: Colors.green.withAlpha(30),
                                        borderRadius: BorderRadius.circular(20),
                                      )
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                     Container(
                                    width: 90,
                                    height: 7,
                                     decoration: BoxDecoration(
                                      color: Colors.green.withAlpha(30),
                                        borderRadius: BorderRadius.circular(20),
                                      )
                                  ),
                                ]),
                          )
                        ]),
                      ),
                    ],
                  ),
                        SizedBox(height: 20,),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
SizedBox(width: 20,),
                                  Container(
                                    width: 90,
                                    height: 26,
                                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color:Get.isDarkMode ? Colors.green.withAlpha(30) : Colors.red,
                                    ),

                                  ),
                                  SizedBox(width: 16,),
                                  Container(
                                    width: 80,
                                    height: 7,
                                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                                    decoration: BoxDecoration(
                                      color: Colors.green.withAlpha(30),
                                      borderRadius: BorderRadius.circular(12),

                                    ),
                              ),
                   ]
                                  )
                                ],
                              )
                  )
                ])),
            Positioned(

              right: 30,

                child:  Container(
                margin: EdgeInsets.all(8),
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: Colors.green.withAlpha(30)),

              ),)
              ],
        );
  }
}
