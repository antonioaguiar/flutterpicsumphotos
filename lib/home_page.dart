import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_app/foto_info.dart';
import 'package:my_app/menu_superior.dart';

import 'foto_services.dart';

class HomePage extends StatefulWidget {
  final String title;
  const HomePage({Key? key, required this.title}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String urlSelecionada = "https://picsum.photos/500/600";
  int fotoSelecionada = 0;
  FotoInfo info = FotoInfo();
  FotoServices service = FotoServices();

  @override
  Widget build(BuildContext context) {
    final List<MenuSuperior> opcoes = [];

    for (int i = 0; i < 20; i++) {
      opcoes.add(MenuSuperior("Foto ${i + 1}"));
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Picsum photos",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 1, right: 1),
              height: 160,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: opcoes.length,
                itemBuilder: (context, idx) {
                  var opt = opcoes[idx];
                  //Future.delayed(Duration(seconds: 2));
                  return GestureDetector(
                    child: Container(
                      margin: EdgeInsets.only(left: 1),
                      //  height: 160,
                      width: 160,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.fill,
                            image: Image.network(
                              "https://picsum.photos/id/${idx}/160/160",
                              fit: BoxFit.fill,
                              loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    backgroundColor: Colors.amber,
                                    color: Colors.black,
                                    value: loadingProgress.expectedTotalBytes != null
                                        ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                );
                              },
                            ).image),
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: Center(
                        child: Text(
                          opt.title,
                          textAlign: TextAlign.end,
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    onTap: () async {
                      fotoSelecionada = idx;
                      FotoInfo _info = await service.getInfo(fotoSelecionada);
                      setState(() {
                        info = _info;
                        urlSelecionada = "https://picsum.photos/id/${idx}/500/600";
                        print(urlSelecionada);
                      });
                    },
                  );
                },
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Visibility(
                  child: Card(
                    color: Colors.grey[300],
                    child: Container(
                      padding: EdgeInsets.all(2),
                      width: double.maxFinite,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              "Informações da foto",
                              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Text("ID: ${info.id}, Autor: ${info.author}"),
                          Text("Tamanho: ${info.width} x ${info.height}"),
                        ],
                      ),
                    ),
                  ),
                  visible: info.id != null,
                ),
                Container(
                  padding: EdgeInsets.all(1),
                  child: Image.network(
                    urlSelecionada,
                    loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.amber,
                          color: Colors.black,
                          value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! : 1,
                        ),
                      );
                    },
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FloatingActionButton(
                backgroundColor: Colors.grey,
                shape: BeveledRectangleBorder(borderRadius: BorderRadius.zero),
                onPressed: () {
                  setState(() {
                    urlSelecionada = "https://picsum.photos/id/${fotoSelecionada}/500/600?grayscale";
                  });
                },
                child: Text("Gray"),
              ),
              FloatingActionButton(
                backgroundColor: Colors.blue,
                shape: BeveledRectangleBorder(borderRadius: BorderRadius.zero),
                onPressed: () {
                  setState(() {
                    urlSelecionada = "https://picsum.photos/id/${fotoSelecionada}/500/600?blur";
                  });
                },
                child: Text("Blur"),
              ),
            ],
          ),
        ));
  }
}
