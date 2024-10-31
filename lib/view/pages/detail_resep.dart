import 'dart:io';

import 'package:coffee_vision/model/recipe.dart';
import 'package:coffee_vision/view/shared/gaps.dart';
import 'package:coffee_vision/view/shared/theme.dart';
import 'package:coffee_vision/view/widgets/card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class DetailResep extends StatefulWidget {
  final Recipe recipe;

  const DetailResep({super.key, required this.recipe});

  @override
  State<DetailResep> createState() => _DetailResepState();
}

class _DetailResepState extends State<DetailResep> {
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
              background: widget.recipe.imageUrl.startsWith('http')
                  ? Image.network(widget.recipe.imageUrl, fit: BoxFit.cover)
                  : Image.file(File(widget.recipe.imageUrl), fit: BoxFit.cover),
            ),
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back, color: kWhiteColor),
            ),
            actions: [
              InkWell(
                onTap: () {
                  widget.recipe.imageUrl.startsWith('http')
                      ? print(1)
                      : print(2);
                },
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
                      widget.recipe.category,
                      style: mediumTextStyle.copyWith(
                        color: kGreyColor,
                        fontSize: 16,
                      ),
                    ),
                    gapH4,
                    Text(
                      widget.recipe.title,
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
                                widget.recipe.rating.toString(),
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
                                "${widget.recipe.duration} Menit",
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
                      widget.recipe.description,
                      style: regularTextStyle.copyWith(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    gapH(16),
                    widget.recipe.imageUrl.startsWith('http')
                        ? RatingBar.builder(
                            initialRating: 0,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: false,
                            itemCount: 5,
                            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: kPrimaryColor,
                            ),
                            onRatingUpdate: (rating) {
                              print(rating);
                            },
                          )
                        : Row(
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
                              ...widget.recipe.tools
                                  .map((tool) => AlatCard(nama: tool))
                                  .toList(), // Generate tool cards
                              gapH(16),
                              Text(
                                "Bahan",
                                style: blackTextStyle.copyWith(fontSize: 24),
                              ),
                              gapH8,
                              ...widget.recipe.ingredients
                                  .map((ingredient) => BahanCard(
                                      nama: ingredient.name,
                                      kadar: ingredient.quantity))
                                  .toList(), // Generate ingredient cards
                            ],
                          ),
                          ListView(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            children: [
                              ...widget.recipe.steps
                                  .asMap()
                                  .entries
                                  .map((entry) {
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
