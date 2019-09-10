import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:ponta_firme/data/rest.dart';


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  Rest rest = Rest();

  var _controller = new MaskedTextController(mask: '000.000.000-00');
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;


    return Scaffold(
      key: scaffoldKey,
      body: SingleChildScrollView(
          child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: screenSize.height,
        ),
        child: Container(
          decoration: BoxDecoration(
            image: new DecorationImage(
              colorFilter:ColorFilter.mode(Colors.black54, BlendMode.overlay),
              image: AssetImage(
                'assets/bkg.jpg',
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Container(
                  width: 280.0,
                  height: 280.0,
                  alignment: Alignment.center,
                  decoration: new BoxDecoration(
                      image: new DecorationImage(
                          image: AssetImage(
                    'assets/logo2.png',
                  ))),
                ),
                new Form(
                    child: new Column(children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Material(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Colors.white.withOpacity(0.5),
                      elevation: 0.0,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: TextField(
                          controller: _controller,
                          onChanged: (var val) {
                            if (val.length > 14)
                              _controller.updateMask('00.000.000/0000-00');
                            else
                              _controller.updateMask('000.000.000-000');
                          },
                          decoration: InputDecoration(
                            hintText: "CPF ou CNPJ",
                            icon: Icon(Icons.portrait),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Material(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.green[700].withOpacity(0.9),
                      elevation: 0.0,
                      child: MaterialButton(
                        onPressed: () {
                          String dados = _controller.text;

                          if(dados.contains("."))
                            dados = dados.replaceAll(".", "");
                          if(dados.contains("-"))
                            dados = dados.replaceAll("-", "");
                          if(dados.contains("/"))
                            dados = dados.replaceAll("/", "");

                          if(dados.length == 0)
                            _dialog(titulo: "Ooops!", texto: "Você não informou os dados!");
                          else if(dados.length < 5)
                            _dialog(titulo: "Ooops!", texto: "Dados não encontrados.");
                          else if(dados.length < 14)
                            _dialog(titulo: "Ponta Firme!", texto: "Fabiano Gadenz é um ponta firme!");
                          else
                            _dialog(titulo: "Ooops!", texto: "Não encontramos dados referente a José Silva");


                          print(dados.replaceAll(".", ""));
                        },
                        minWidth: MediaQuery.of(context).size.width,
                        child: Text(
                          "CONSULTAR",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0),
                        ),
                      ),
                    ),
                  ),
                  Divider(
                    color: Colors.white,
                    height: 10,
                  ),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Seja um franqueado ",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                                fontSize: 16.0)),
                        InkWell(
                          child: Text("clicando aqui.",
                              style: TextStyle(
                                  color: Colors.green[600],
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold)),
                          onTap: () {
                          },
                        ),
                      ],
                    ),
                  )
                ]))
              ],
            ),
          ),
        ),
      )),
    );
  }
  void _dialog({String titulo, String texto}){
    showDialog(context: context, builder: (context){
      return AlertDialog(
        title: Text(titulo),
        content: Text(texto),
        actions: <Widget>[
          FlatButton(child: Text("Ok"),onPressed: (){
            Navigator.of(context).pop();
          },)
        ],
      );
    });
  }
}
