import 'dart:convert';

import 'package:eatch/pages/produits/presentation/modification_produit.dart';
import 'package:eatch/servicesAPI/get_categories.dart' as Category;
import 'package:eatch/servicesAPI/get_produits.dart';
import 'package:eatch/utils/default_button/default_button.dart';
import 'package:eatch/utils/palettes/palette.dart';
import 'package:eatch/utils/size/size.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Produitpage extends ConsumerStatefulWidget {
  const Produitpage({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.price,
    required this.sId,
    required this.category,
    required this.quantity,
    // required this.recette,
  });
  final String imageUrl;
  final String title;
  // final Category.Recette recette;
  final String sId;
  final int price;
  final int quantity;
  final Category.Category category;

  @override
  ConsumerState<Produitpage> createState() => _ProduitpageState();
}

class _ProduitpageState extends ConsumerState<Produitpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            alignment: Alignment.centerRight,
            margin: const EdgeInsets.only(top: 35, left: 15),
            child: RawMaterialButton(
              fillColor: Palette.primaryColor,
              onPressed: () {
                Navigator.of(context).pop();
              },
              padding: const EdgeInsets.all(0),
              shape: const CircleBorder(),
              child: const Icon(IconData(0xe16a, fontFamily: 'MaterialIcons'),
                  color: Colors.white),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(100),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox.fromSize(
                    size: const Size.fromRadius(100),
                    child: Image.network(
                      widget.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  widget.title,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Palette.textPrimaryColor,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  NumberFormat.simpleCurrency(name: "MAD ")
                      .format(widget.price),
                  style: const TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                    color: Palette.primaryColor,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: 150,
                      child: DefaultButton(
                        color: Palette.primaryColor,
                        foreground: Colors.red,
                        text: 'SUPPRIMER',
                        textcolor: Palette.primaryBackgroundColor,
                        onPressed: () {
                          dialogDelete(
                            context,
                            widget.title,
                            widget.sId,
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 20),
                    SizedBox(
                      width: 150,
                      child: DefaultButton(
                        color: Palette.secondaryBackgroundColor,
                        foreground: Colors.red,
                        text: 'MODIFIER',
                        textcolor: Palette.textsecondaryColor,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) {
                              return ModificationProduit(
                                imageUrl: widget.imageUrl,
                                price: widget.price,
                                title: widget.title,
                                category: widget.category,
                                quantity: widget.quantity,
                                // recette: widget.recette.title!,
                              );
                            }),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future dialogDelete(
      BuildContext context, String nomproduit, String productId) {
    return showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
              backgroundColor: Colors.white,
              title: const Center(
                child: Text(
                  "Confirmez la suppression",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              actions: [
                ElevatedButton.icon(
                    icon: const Icon(
                      Icons.close,
                      size: 14,
                    ),
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                    label: const Text("Quitter   ")),
                const SizedBox(
                  width: 20,
                ),
                ElevatedButton.icon(
                  icon: const Icon(
                    Icons.delete,
                    size: 14,
                  ),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Palette.deleteColors),
                  onPressed: () {
                    deleteProduct(context, productId);
                  },
                  label: const Text("Supprimer."),
                )
              ],
              content: Container(
                  alignment: Alignment.center,
                  color: Colors.white,
                  height: 150,
                  child: Text(
                    "Voulez vous supprimer la catégorie $nomproduit?",
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                  )));
        });
  }

  Future<http.Response> deleteProduct(BuildContext context, String id) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var userdelete = prefs.getString('IdUser').toString();
      var restaurantid = prefs.getString('idRestaurant');
      var token = prefs.getString('token');
      String urlDelete = "http://192.168.11.110:4003/api/products/delete/$id";
      var json = {
        '_creator': userdelete,
        'restaurant': restaurantid,
      };
      var body = jsonEncode(json);

      final http.Response response = await http.delete(
        Uri.parse(urlDelete),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
          'Accept': 'application/json',
          'authorization': 'Bearer $token',
          'body': body,
        },
      );

      print(response.statusCode);
      if (response.statusCode == 200) {
        ref.refresh(getDataProduitFuture);

        return response;
      } else {
        return Future.error("Server Error");
      }
    } catch (e) {
      return Future.error(e);
    }
  }
}
