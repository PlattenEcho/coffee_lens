import 'dart:io';

import 'package:coffee_vision/model/resep.dart';
import 'package:coffee_vision/view/shared/gaps.dart';
import 'package:coffee_vision/view/shared/theme.dart';
import 'package:coffee_vision/view/widgets/card.dart';
import 'package:flutter/material.dart';

class PreviewResep extends StatelessWidget {
  final Resep resep;

  const PreviewResep({super.key, required this.resep});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: kPrimaryLightColor,
        body: CustomScrollView(slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            floating: true,
            expandedHeight: 250,
            backgroundColor: kPrimaryLight2Color,
            elevation: 0.0,
            flexibleSpace: FlexibleSpaceBar(
                background: resep.imageUrl.startsWith('http')
                    ? Image.network(resep.imageUrl, fit: BoxFit.cover)
                    : Image.file(File(resep.imageUrl), fit: BoxFit.cover)),
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back, color: kWhiteColor),
            ),
            actions: [
              InkWell(
                onTap: () {},
                child: Image.asset(
                  'assets/icon/icon_favorit.png',
                  width: 24,
                  height: 24,
                  color: kWhiteColor,
                ),
              ),
              gapW(16),
            ],
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Container(
                padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                child: Column(
                  children: [
                    Container(
                      width: parentW(context) / 3,
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(color: kPrimaryColor, width: 3),
                        ),
                      ),
                    ),
                    gapH12,
                    Text(
                      resep.category,
                      style: mediumTextStyle.copyWith(
                        color: kGreyColor,
                        fontSize: 16,
                      ),
                    ),
                    gapH4,
                    Text(
                      resep.title,
                      style: blackTextStyle.copyWith(fontSize: 28),
                    ),
                    gapH8,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.star,
                                color: kYellowColor,
                                size: 16,
                              ),
                              SizedBox(width: 4),
                              Text(
                                resep.rating.toString(),
                                style: extraBoldTextStyle.copyWith(
                                  color: kWhiteColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        gapW8,
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.access_time_rounded,
                                color: kWhiteColor,
                                size: 16,
                              ),
                              SizedBox(width: 4),
                              Text(
                                "${resep.duration} Menit",
                                style: extraBoldTextStyle.copyWith(
                                  color: kWhiteColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    gapH(16),
                    Text(
                      resep.description,
                      style: regularTextStyle.copyWith(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    gapH(16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                          5,
                          (index) => Icon(
                                Icons.star,
                                size: 40,
                                color: kGreyColor,
                              )),
                    ),
                    gapH32,
                    TabBar(
                      indicatorColor: kPrimaryColor,
                      labelColor: kPrimaryColor,
                      unselectedLabelColor: kGreyColor,
                      labelStyle: blackTextStyle.copyWith(fontSize: 16),
                      unselectedLabelStyle:
                          blackTextStyle.copyWith(fontSize: 16),
                      tabs: [
                        Tab(
                          text: "Alat dan Bahan",
                        ),
                        Tab(text: "Langkah"),
                      ],
                    ),
                    gapH12,
                    SizedBox(
                      height: 400,
                      child: TabBarView(
                        children: [
                          ListView(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            children: [
                              Text(
                                "Alat",
                                style: blackTextStyle.copyWith(fontSize: 24),
                              ),
                              gapH8,
                              ...resep.tools
                                  .map((tool) => AlatCard(nama: tool))
                                  .toList(), // Generate tool cards
                              gapH(16),
                              Text(
                                "Bahan",
                                style: blackTextStyle.copyWith(fontSize: 24),
                              ),
                              gapH8,
                              ...resep.ingredients
                                  .map((ingredient) => BahanCard(
                                      nama: ingredient.name,
                                      kadar: ingredient.quantity))
                                  .toList(), // Generate ingredient cards
                            ],
                          ),
                          ListView(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            children: [
                              ...resep.steps.asMap().entries.map((entry) {
                                int index = entry.key;
                                String step = entry.value;
                                return StepCard(
                                    nomor: index + 1,
                                    langkah:
                                        step); // Display step number and content
                              }).toList(),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ]),
      ),
    );
  }
}
