import 'dart:convert';

import 'package:eatch/utils/applayout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../servicesAPI/getMenu.dart';
import '../../servicesAPI/get_promotion.dart';
import '../../servicesAPI/multipart.dart';
import '../../utils/palettes/palette.dart';
import 'affichePromotion.dart';

import 'package:eatch/servicesAPI/get_produits.dart' as p;

class ModificationPromotion extends ConsumerStatefulWidget {
  const ModificationPromotion({
    super.key,
    required this.imageUrl,
    required this.sId,
    required this.title,
    required this.description,
    //required this.price,
    required this.products,
    required this.menus,
  });

  final String imageUrl;
  final String sId;
  final String title;
  final String description;
  //final double price;
  final String products;
  final String menus;

  @override
  ConsumerState<ModificationPromotion> createState() =>
      ModificationPromotionState();
}

class ModificationPromotionState extends ConsumerState<ModificationPromotion> {
  late var nomController = TextEditingController(text: widget.title);
  late var descriptionPromo = TextEditingController(text: widget.description);

  @override
  void initState() {
    // TODO: implement initState
    depart();
    super.initState();
  }

  void depart() {
    setState(() {
      if (widget.menus.isNotEmpty) menu = widget.menus;
      if (widget.products.isNotEmpty) produit = widget.products;
    });
  }

  String? menu;
  String? produit;

  DateTime date = DateTime.now();
  bool dd = false;
  bool dep = false;

  MediaQueryData mediaQueryData(BuildContext context) {
    return MediaQuery.of(context);
  }

  Size size(BuildContext buildContext) {
    return mediaQueryData(buildContext).size;
  }

  double width(BuildContext buildContext) {
    return size(buildContext).width;
  }

  double height(BuildContext buildContext) {
    return size(buildContext).height;
  }

  @override
  Widget build(BuildContext context) {
    final viewModel1 = ref.watch(getDataMenuFuture);
    final viewModel2 = ref.watch(p.getDataProduitFuture);
    return AppLayout(
      content: SizedBox(
        child: Container(
          color: Palette.secondaryBackgroundColor,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  alignment: Alignment.centerRight,
                  height: 80,
                  color: Palette.yellowColor,
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 50,
                      ),
                      const Text('Modification de Promotion'),
                      Expanded(child: Container()),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Palette.primaryColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            minimumSize: const Size(150, 50)),
                        onPressed: () {
                          setState(() {
                            ref.refresh(getDataPromotionFuture);
                          });
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PromotionAffiche(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.backspace),
                        label: const Text('Retour'),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width - 50,
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: nomController,
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (value) {},
                          decoration: InputDecoration(
                              hoverColor: Palette.primaryBackgroundColor,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 42, vertical: 20),
                              filled: true,
                              fillColor: Palette.primaryBackgroundColor,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: const BorderSide(
                                    color: Palette.secondaryBackgroundColor),
                                gapPadding: 10,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: const BorderSide(
                                    color: Palette.secondaryBackgroundColor),
                                gapPadding: 10,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: const BorderSide(
                                    color: Palette.secondaryBackgroundColor),
                                gapPadding: 10,
                              ),
                              hintText: "Entrer le nom du type",
                              // If  you are using latest version of flutter then lable text and hint text shown like this
                              // if you r using flutter less then 1.20.* then maybe this is not working properly
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              suffixIcon: const Icon(Icons.food_bank)),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width - 50,
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: descriptionPromo,
                          maxLines: 2,
                          maxLength: 100,
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (value) {},
                          decoration: InputDecoration(
                            hoverColor: Palette.primaryBackgroundColor,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 42, vertical: 20),
                            filled: true,
                            fillColor: Palette.primaryBackgroundColor,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(
                                  color: Palette.secondaryBackgroundColor),
                              gapPadding: 10,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(
                                  color: Palette.secondaryBackgroundColor),
                              gapPadding: 10,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(
                                  color: Palette.secondaryBackgroundColor),
                              gapPadding: 10,
                            ),
                            hintText: "Entrer la description de la promotion",
                            // If  you are using latest version of flutter then lable text and hint text shown like this
                            // if you r using flutter less then 1.20.* then maybe this is not working properly
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            suffixIcon: const Icon(Icons.description),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width - 50,
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: DropdownButtonFormField(
                          decoration: InputDecoration(
                            hoverColor: Palette.primaryBackgroundColor,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 42, vertical: 20),
                            filled: true,
                            fillColor: Palette.primaryBackgroundColor,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(
                                  color: Palette.secondaryBackgroundColor),
                              gapPadding: 10,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(
                                  color: Palette.secondaryBackgroundColor),
                              gapPadding: 10,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(
                                  color: Palette.secondaryBackgroundColor),
                              gapPadding: 10,
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                          value: menu,
                          hint: const Text('Menu'),
                          isExpanded: true,
                          onChanged: (value) {
                            setState(() {
                              menu = value!;
                              print('Valeur : $menu');
                            });
                          },
                          items: viewModel1.listMenus.map((val) {
                            return DropdownMenuItem(
                              value: val.sId,
                              child: Text(
                                val.menuTitle!,
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width - 50,
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: DropdownButtonFormField(
                          decoration: InputDecoration(
                            hoverColor: Palette.primaryBackgroundColor,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 42, vertical: 20),
                            filled: true,
                            fillColor: Palette.primaryBackgroundColor,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(
                                  color: Palette.secondaryBackgroundColor),
                              gapPadding: 10,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(
                                  color: Palette.secondaryBackgroundColor),
                              gapPadding: 10,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(
                                  color: Palette.secondaryBackgroundColor),
                              gapPadding: 10,
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                          value: produit,
                          hint: const Text('Produit'),
                          isExpanded: true,
                          onChanged: (value) {
                            setState(() {
                              produit = value!;
                              print('Valeur 1 : $produit');
                            });
                          },
                          items: viewModel2.listProduit.map((val) {
                            return DropdownMenuItem(
                              value: val.sId,
                              child: Text(
                                val.productName!,
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                // début --------------------------------------------
                SizedBox(
                  width: MediaQuery.of(context).size.width - 50,
                  child: Row(
                    children: [
                      const SizedBox(width: 25),
                      const Text(
                        "Fin de la promotion",
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(width: 20),
                      ElevatedButton(
                        onPressed: () async {
                          DateTime? newDate = await showDatePicker(
                            context: context,
                            initialDate: date,
                            firstDate: DateTime(1900),
                            lastDate: DateTime(2100),
                          );

                          if (newDate == null) return;

                          setState(() {
                            date = newDate;
                            dd = true;
                          });
                          print(date);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Palette.primaryColor,
                          minimumSize: const Size(150, 40),
                          maximumSize: const Size(200, 50),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        child: dd == false
                            ? Text(
                                "${date.year}-${date.month}-${date.day}",
                                style: const TextStyle(fontSize: 18),
                              )
                            : Text(
                                "${date.year}-${date.month}-${date.day}",
                                style: const TextStyle(fontSize: 18),
                              ),
                      ),
                    ],
                  ),
                ),
                // fin --------------------------------------------
                const SizedBox(
                  height: 80,
                ),
                ElevatedButton(
                  onPressed: (() {
                    modificationPromotion(
                        context,
                        nomController.text,
                        descriptionPromo.text,
                        menu,
                        produit,
                        date.toString(),
                        widget.sId);
                  }),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Palette.primaryColor,
                    minimumSize: const Size(150, 50),
                    maximumSize: const Size(200, 70),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Modifier'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///////////// - Modification Promotion
  ///
  ///// - Modification de Promotion
  ///
  Future<void> modificationPromotion(
    BuildContext context,
    String nomPromo,
    String descriptionPromo,
    String? nomDuMenu,
    String? nomDuProduit,
    String endPromo,
    String idPromo,
    // List<int> selectedFile,
    // FilePickerResult? result,
  ) async {
    ////////////

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString('IdUser').toString();
    var restaurantId = prefs.getString('idRestaurant').toString();
    var token = prefs.getString('token');

    //String adressUrl = prefs.getString('ipport').toString();

    var url = Uri.parse(
        "http://13.39.81.126:5005/api/promotions/update/$idPromo"); //$adressUrl
    final request = MultipartRequest(
      'PUT',
      url,
      // ignore: avoid_returning_null_for_void
      onProgress: (int bytes, int total) {
        final progress = bytes / total;
        print('progress: $progress ($bytes/$total)');
      },
    );

    var json = {
      '_creator': id,
      'restaurant': restaurantId,
      'promotion_name': nomPromo,
      'description': descriptionPromo,
      'menu': nomDuMenu,
      'product': nomDuProduit,
      'end_date': endPromo,
    };
    var body = jsonEncode(json);

    request.headers.addAll({
      "body": body,
    });

    request.fields['form_key'] = 'form_value';
    request.headers['authorization'] = 'Bearer $token';
    // if (result != null) {
    //   request.files.add(
    //     http.MultipartFile.fromBytes('file', selectedFile,
    //         contentType: MediaType('application', 'octet-stream'),
    //         filename: result.files.first.name),
    //   );
    // }
    print("RESPENSE SEND STEAM FILE REQ");
    //var responseString = await streamedResponse.stream.bytesToString();
    var response = await request.send();
    print("Upload Response$response");
    print(response.statusCode);
    print(request.headers);

    print("Je me situe maintenant ici");
    try {
      if (response.statusCode == 200 || response.statusCode == 201) {
        await response.stream.bytesToString().then((value) {
          print(value);
        });

        //stopMessage();
        //finishWorking();
        showTopSnackBar(
          Overlay.of(context),
          const CustomSnackBar.info(
            backgroundColor: Palette.greenColors,
            message: "La promotion a été modifié avec succès",
          ),
        );
        ref.refresh(getDataPromotionFuture);
        // ignore: use_build_context_synchronously
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const PromotionAffiche(),
          ),
        );
      } else {
        showTopSnackBar(
          Overlay.of(context),
          const CustomSnackBar.info(
            backgroundColor: Palette.deleteColors,
            message: "La promotion n'a pas été modifié avec succès",
          ),
        );
        print("Error Create Programme  !!!");
      }
    } catch (e) {
      rethrow;
    }
  }
}
