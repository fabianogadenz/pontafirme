import 'package:flutter/material.dart';
import 'package:flutter_launch/flutter_launch.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:ponta_firme/data/rest.dart';
import 'package:ponta_firme/model/rating.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

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
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: 340,
            child: RotatedBox(
              quarterTurns: 2,
              child: WaveWidget(
                config: CustomConfig(
                  gradients: [
                    [Colors.green, Colors.green[800]],
                    [Colors.green[200], Colors.green[400]],
                  ],
                  durations: [19440, 10800],
                  heightPercentages: [0.20, 0.25],
                  blur: MaskFilter.blur(BlurStyle.solid, 10),
                  gradientBegin: Alignment.bottomLeft,
                  gradientEnd: Alignment.topRight,
                ),
                waveAmplitude: 0,
                size: Size(
                  double.infinity,
                  double.infinity,
                ),
              ),
            ),
          ),
          ListView(
            children: <Widget>[
              Container(
                height: 480,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 320,
                      height: 160,
                      decoration: BoxDecoration(
                          image: new DecorationImage(
                              image: AssetImage(
                        'assets/logo2.png',
                      ))),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Card(
                      margin: EdgeInsets.only(left: 30, right: 30, top: 50),
                      elevation: 11,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(40))),
                      child: TextField(
                        controller: _controller,
                        keyboardType: TextInputType.number,
                        onChanged: (var val) {
                          if (val.length > 14)
                            _controller.updateMask('00.000.000/0000-00');
                          else
                            _controller.updateMask('000.000.000-000');
                        },
                        decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.person,
                              color: Colors.black26,
                            ),
                            hintText: "CPF ou CNPJ",
                            hintStyle: TextStyle(color: Colors.black26),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(40.0)),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 16.0)),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(
                          left: 30.0, right: 30.0, top: 20.0, bottom: 20),
                      child: RaisedButton(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        color: Colors.green[600],
                        onPressed: () async {
                          String dados = _controller.text;
                          if(dados.length > 5) {
                            if (dados.contains("."))
                              dados = dados.replaceAll(".", "");
                            if (dados.contains("-"))
                              dados = dados.replaceAll("-", "");
                            if (dados.contains("/"))
                              dados = dados.replaceAll("/", "");
                            Rating r = await rest.getRating(cpfCnpj: dados);

                            if (r != null) {
                              if (r.name == "") {
                                _dialog(
                                    titulo: "Ooops!",
                                    texto: "Dados não encontrados.");
                              } else {
                                if (r.countLikes > r.countDislikes)
                                  _dialog(
                                      titulo: "Ponta Firme!",
                                      texto: "${r.name} é um ponta firme!");
                                else if (r.countLikes == r.countDislikes)
                                  _dialog(
                                      titulo: "Ooops!",
                                      texto: "Não sabemos como opinar sobre ${r.name}.");
                                else
                                  _dialog(
                                      titulo: "Ooops!",
                                      texto:
                                      "Não encontramos dados referente a ${r
                                          .name}.");
                              }
                            }
                          }
                          else
                            _dialog(
                                titulo: "Ooops!",
                                texto: "Digite o CPF ou o CNPJ corretamente!");
                        },
                        elevation: 11,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(40.0))),
                        child: Text("CONSULTAR",
                            style:
                                TextStyle(color: Colors.white70, fontSize: 20)),
                      ),
                    ),
                    Divider(
                      color: Colors.grey,
                      height: 10,
                    ),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("Seja um franqueado ",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16.0)),
                          InkWell(
                            child: Text("clicando aqui.",
                                style: TextStyle(
                                    color: Colors.green[600],
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold)),
                            onTap: () {
                              print("clicou");
                              whatsAppOpen();
                              print("clicou2");
                            },
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void whatsAppOpen() async {
    bool whatsapp = await FlutterLaunch.hasApp(name: "whatsapp");

    if (whatsapp) {
      await FlutterLaunch.launchWathsApp(phone: "5534992016100", message: "Hello, flutter_launch");
    } else {
      _dialog(titulo: "Ooops!", texto: "Não conseguimos abrir seu Whatsapp, entre em contato conosco pelo número: (45) 99102-5167");
    }
  }

  void _dialog({String titulo, String texto}) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(titulo),
            content: Text(texto),
            actions: <Widget>[
              FlatButton(
                child: Text("Ok"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
}
