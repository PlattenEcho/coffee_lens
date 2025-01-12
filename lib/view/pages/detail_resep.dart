import 'package:coffee_vision/controller/resep_controller.dart';
import 'package:coffee_vision/controller/storage_controller.dart';
import 'package:coffee_vision/main.dart';
import 'package:coffee_vision/model/resep.dart';
import 'package:coffee_vision/view/pages/other_profile.dart';
import 'package:coffee_vision/view/pages/update_resep.dart';
import 'package:coffee_vision/view/shared/gaps.dart';
import 'package:coffee_vision/view/shared/theme.dart';
import 'package:coffee_vision/view/widgets/card.dart';
import 'package:coffee_vision/view/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class DetailResep extends StatefulWidget {
  final int idResep;
  final double rating;
  final int idUser;
  final String imgUrl;

  const DetailResep(
      {super.key,
      required this.idResep,
      required this.rating,
      required this.idUser,
      required this.imgUrl});

  @override
  State<DetailResep> createState() => _DetailResepState();
}

class _DetailResepState extends State<DetailResep> {
  final idUser = storageController.getData("user")['id'];
  bool? isMine;
  double? userRating;
  bool isFavorit = false;
  Resep? resep;
  bool isChanged = false;

  @override
  void initState() {
    super.initState();
    isMine = idUser == widget.idUser;
    loadDetailResep();
  }

  Future<void> loadDetailResep() async {
    final resepResponse = await fetchDetailResep(widget.idResep);
    final userRatingResponse = await supabase
        .from('rating')
        .select('*')
        .eq('id_resep', widget.idResep)
        .eq('id_user', idUser)
        .maybeSingle();
    final favoritResponse = await supabase
        .from('favorit')
        .select('*')
        .eq('id_resep', widget.idResep)
        .eq('id_user', idUser)
        .maybeSingle();
    final userResponse = await supabase
        .from('user')
        .select('username, img_url')
        .eq('id', widget.idUser)
        .maybeSingle();
    final Resep recipe = Resep.fromJson(resepResponse);
    if (userResponse != null) {
      recipe.username = userResponse['username'];
      recipe.userImgUrl = userResponse['img_url'];
    }
    final double userRate = userRatingResponse != null
        ? (userRatingResponse['rating'] as num).toDouble()
        : 0.0;
    bool isFav = favoritResponse != null;

    setState(() {
      resep = recipe;
      userRating = userRate;
      isFavorit = isFav;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, isChanged);
        return false;
      },
      child: DefaultTabController(
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
                    background: resep == null
                        ? Container(color: kGreyColor)
                        : Image.network(resep!.imageUrl, fit: BoxFit.cover)),
                leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context, isChanged);
                  },
                  icon: Icon(Icons.arrow_back, color: kWhiteColor),
                ),
                actions: [
                  isMine == true
                      ? PopupMenuButton<String>(
                          icon: Icon(Icons.more_vert, color: kWhiteColor),
                          onSelected: (value) {
                            if (value == 'update') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => UpdateResep(
                                          idResep: widget.idResep,
                                        )),
                              ).then((isUpdated) {
                                if (isUpdated == true) {
                                  setState(() {
                                    loadDetailResep();
                                    isChanged = true;
                                  });
                                }
                              });
                            } else if (value == 'delete') {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(
                                      "Konfirmasi Hapus",
                                      style: boldTextStyle,
                                    ),
                                    content: Text(
                                      "Apakah Anda yakin ingin menghapus resep ini?",
                                      style: regularTextStyle,
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(
                                          "Batal",
                                          style: regularTextStyle,
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          Navigator.pop(context, true);
                                          try {
                                            await supabase
                                                .from('resep')
                                                .delete()
                                                .eq('id', widget.idResep);
                                            showToast(context,
                                                "Resep berhasil dihapus");

                                            Navigator.pop(context, true);
                                          } catch (e) {
                                            print(
                                                'Error deleting resep: ${e.toString()}');
                                          }
                                        },
                                        child: Text(
                                          "Hapus",
                                          style: boldTextStyle.copyWith(
                                              color: kRedColor),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuEntry<String>>[
                            PopupMenuItem<String>(
                              value: 'update',
                              child: Text('Update'),
                            ),
                            PopupMenuItem<String>(
                              value: 'delete',
                              child: Text('Delete'),
                            ),
                          ],
                        )
                      : InkWell(
                          onTap: () {
                            try {
                              if (isFavorit) {
                                removeFavorit(idUser, widget.idResep);
                                setState(() {
                                  isFavorit = false;
                                  isChanged = true;
                                });
                                showToast(
                                    context, "Berhasil menghapus dari favorit");
                              } else {
                                addFavorit(idUser, widget.idResep);
                                setState(() {
                                  isFavorit = true;
                                  isChanged = true;
                                });
                                showToast(
                                    context, "Berhasil menambahkan ke favorit");
                              }
                            } catch (e) {
                              showToast(
                                  context, "Error: silahkan ulangi lagi nanti");
                            }
                          },
                          child: Image.asset(
                            isFavorit
                                ? 'assets/icon/icon_favorit_filled.png'
                                : 'assets/icon/icon_favorit.png',
                            width: 24,
                            height: 24,
                            color: kWhiteColor,
                          ),
                        ),
                  gapW(16),
                ],
              ),
              resep == null
                  ? SliverToBoxAdapter(
                      child: Container(
                        padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: kPrimaryColor,
                          ),
                        ),
                      ),
                    )
                  : SliverList(
                      delegate: SliverChildListDelegate([
                        Container(
                          padding:
                              EdgeInsets.only(top: 20, left: 20, right: 20),
                          child: Column(
                            children: [
                              Container(
                                width: parentW(context) / 3,
                                decoration: BoxDecoration(
                                  border: Border(
                                    top: BorderSide(
                                        color: kPrimaryColor, width: 3),
                                  ),
                                ),
                              ),
                              gapH12,
                              Text(
                                resep!.category,
                                style: mediumTextStyle.copyWith(
                                  color: kGreyColor,
                                  fontSize: 16,
                                ),
                              ),
                              gapH4,
                              Text(
                                resep!.title,
                                style: blackTextStyle.copyWith(fontSize: 28),
                              ),
                              gapH8,
                              Text(
                                "Oleh:",
                                style: mediumTextStyle.copyWith(
                                  color: kGreyColor,
                                  fontSize: 16,
                                ),
                              ),
                              gapH8,
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => OtherProfile(
                                              idUser: widget.idUser)));
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: IntrinsicWidth(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CircleAvatar(
                                          radius: 12,
                                          backgroundImage: NetworkImage(
                                              resep!.userImgUrl ?? ""),
                                          onBackgroundImageError:
                                              (error, stackTrace) {},
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          resep!.username ?? "",
                                          style: extraBoldTextStyle.copyWith(
                                            color: kWhiteColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              gapH(20),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.star,
                                          color: kYellowColor,
                                          size: 16,
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          widget.rating.toString(),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.access_time_rounded,
                                          color: kWhiteColor,
                                          size: 16,
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          "${resep!.duration} Menit",
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
                                resep!.description,
                                style: regularTextStyle.copyWith(fontSize: 16),
                                textAlign: TextAlign.center,
                              ),
                              gapH(16),
                              isMine == false
                                  ? userRating != null
                                      ? RatingBar.builder(
                                          initialRating: userRating!,
                                          minRating: 0.5,
                                          direction: Axis.horizontal,
                                          allowHalfRating: true,
                                          itemCount: 5,
                                          itemPadding: EdgeInsets.symmetric(
                                              horizontal: 4.0),
                                          itemBuilder: (context, _) => Icon(
                                            Icons.star,
                                            color: kPrimaryColor,
                                          ),
                                          onRatingUpdate: (rating) {
                                            try {
                                              updateRating(idUser,
                                                  widget.idResep, rating);
                                              setState(() {
                                                userRating = rating;
                                              });
                                              showToast(context,
                                                  "Berhasil memberi rating");
                                            } catch (e) {
                                              showToast(context,
                                                  "Error: silahkan cek koneksi atau ulangi lagi nanti");
                                            }
                                          },
                                        )
                                      : CircularProgressIndicator()
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                labelStyle:
                                    blackTextStyle.copyWith(fontSize: 16),
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
                                          style: blackTextStyle.copyWith(
                                              fontSize: 24),
                                        ),
                                        gapH8,
                                        ...resep!.tools
                                            .map((tool) => AlatCard(nama: tool))
                                            .toList(),
                                        gapH(16),
                                        Text(
                                          "Bahan",
                                          style: blackTextStyle.copyWith(
                                              fontSize: 24),
                                        ),
                                        gapH8,
                                        ...resep!.ingredients
                                            .map((ingredient) => BahanCard(
                                                nama: ingredient.name,
                                                kadar: ingredient.quantity))
                                            .toList(),
                                      ],
                                    ),
                                    ListView(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10),
                                      children: [
                                        ...resep!.steps
                                            .asMap()
                                            .entries
                                            .map((entry) {
                                          int index = entry.key;
                                          String step = entry.value;
                                          return StepCard(
                                              nomor: index + 1, langkah: step);
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
            ])),
      ),
    );
  }
}
