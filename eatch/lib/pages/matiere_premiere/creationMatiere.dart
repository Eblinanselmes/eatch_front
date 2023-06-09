import 'dart:convert';
import 'dart:typed_data';
import 'package:eatch/servicesAPI/getLabo.dart';
import 'package:eatch/servicesAPI/getMatiere.dart';
import 'package:eatch/utils/applayout.dart';
import 'package:eatch/utils/palettes/palette.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../../servicesAPI/multipart.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart' show MediaType;

class MatiereLaboAffiche extends ConsumerStatefulWidget {
  const MatiereLaboAffiche({Key? key}) : super(key: key);

  @override
  MatiereLaboAfficheState createState() => MatiereLaboAfficheState();
}

class MatiereLaboAfficheState extends ConsumerState<MatiereLaboAffiche> {
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
    final viewModel = ref.watch(getDataLaboratoriesFuture);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= 900) {
            return horizontalView(
                height(context), width(context), context, viewModel.listFINI);
          } else {
            return verticalView(
                height(context), width(context), context, viewModel.listFINI);
          }
        },
      ),
    );
  }

  Widget horizontalView(
      double height, double width, context, List<Materials> matiere) {
    return Scaffold(
      body: Container(
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
                  const Text('Matières premières du laboratoire'),
                  Expanded(child: Container()),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Palette.primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      minimumSize: const Size(180, 50),
                    ),
                    onPressed: () {
                      /*setState(() {
                        ajout = true;
                      });*/
                      /*Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RestaurantCreation()));*/
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Ajouter un type de matière'),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                ],
              ),
            ),
            Container(
              height: height - 280,
              child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 300,
                      childAspectRatio: 3 / 2,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 50,
                      mainAxisExtent: 400),
                  itemCount: matiere.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 10,
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 200,
                              width: 300,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage('emballage.jpeg'),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            Text('Nom : ${matiere[index].title}'),
                            const SizedBox(
                              height: 10,
                            ),
                            Text('Quantité : ${matiere[index].quantity}'),
                            const SizedBox(
                              height: 10,
                            ),
                            Text('Dernière date : ${matiere[index].updatedAt}'),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                                'Date de création : ${matiere[index].createdAt}'),
                            Container(
                              alignment: Alignment.center,
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: IconButton(
                                      alignment: Alignment.center,
                                      splashColor: Palette.greenColors,
                                      onPressed: () {},
                                      icon: const Icon(
                                        Icons.edit,
                                        size: 30,
                                        color: Palette.greenColors,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                      flex: 5,
                                      child: Container(
                                        height: 60,
                                        width: 60,
                                        alignment: Alignment.center,
                                        decoration: const BoxDecoration(
                                            color: Colors.black,
                                            shape: BoxShape.circle),
                                        child: IconButton(
                                          splashColor: Palette.greenColors,
                                          onPressed: () {
                                            /*dialogAjout(
                                              contextt,
                                              listFini[index].sId!,
                                              'Steak',
                                              listFini[index].title!,
                                              listFini[index]
                                                  .quantity
                                                  .toString());*/
                                          },
                                          iconSize: 30,
                                          icon: const Icon(
                                            Icons.add_box,
                                            color: Palette.greenColors,
                                          ),
                                        ),
                                      )),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: IconButton(
                                      alignment: Alignment.center,
                                      splashColor: Colors.red,
                                      onPressed: () {
                                        /*dialogDelete(
                                          context,
                                          listFini[index].sId!,
                                          listFini[index].title!);*/
                                      },
                                      icon: const Icon(
                                        Icons.delete,
                                        size: 30,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Widget verticalView(
      double height, double width, context, List<Materials> matiere) {
    return AppLayout(
      content: Container(),
    );
  }
}
