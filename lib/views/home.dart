import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:learn_app/models/getApiProvinsi.dart';
import 'package:learn_app/views/detailProvinsi.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Map _mapApi = {};
  List<ListApiProvinsi> _listApiProvinsi = [];
  Response _response;
  Response _responseProvinsi;
  var loading = false;

  Future<Null> getDataApi() async {
    setState(() {
      loading = true;
    });

    _response = await get("https://indonesia-covid-19.mathdro.id/api");
    if (_response.statusCode == 200) {
      var data = json.decode(_response.body);
      setState(() {
        _mapApi = data;
        loading = false;
      });
    } else {
      print("error code : ${_response.statusCode}");
    }
  }

  Future<Null> getDataApiProvinsi() async {
    _responseProvinsi =
        await get("https://indonesia-covid-19.mathdro.id/api/provinsi");
    if (_responseProvinsi.statusCode == 200) {
      var dataProvinsi = json.decode(_responseProvinsi.body)["data"];
      setState(() {
        for (Map i in dataProvinsi) {
          _listApiProvinsi.add(ListApiProvinsi.fromJson(i));
        }
      });
    } else {
      print("error code : ${_response.statusCode}");
    }
  }

  Future<Null> _refreshHalaman() async {
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      _mapApi = {};
      _listApiProvinsi = [];
      getDataApi();
      getDataApiProvinsi();
    });
    return null;
  }

  @override
  void initState() {
    super.initState();
    getDataApi();
    getDataApiProvinsi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Halaman Home'),
      ),
      body: loading ? _jikaTidakAda() : _jikaAda(),
    );
  }

  _jikaAda() {
    return RefreshIndicator(
      child: ListView(
        children: <Widget>[
          SingleChildScrollView(
            child: Container(
              child: Column(
                children: <Widget>[
                  Container(
                    child: GridView.count(
                      shrinkWrap: true,
                      primary: false,
                      padding: const EdgeInsets.all(20),
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      crossAxisCount: 2,
                      children: <Widget>[
                        BoxShow(
                          judul: "Positif",
                          total: _mapApi['jumlahKasus'].toString(),
                          warna: Colors.red,
                        ),
                        BoxShow(
                          judul: "Sembuh",
                          total: _mapApi['sembuh'].toString(),
                          warna: Colors.yellow,
                        ),
                        BoxShow(
                          judul: "Meninggal",
                          total: _mapApi['meninggal'].toString(),
                          warna: Colors.green,
                        ),
                        BoxShow(
                          judul: "Perawatan",
                          total: _mapApi['perawatan'].toString(),
                          warna: Colors.blue,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: ListView.builder(
                      shrinkWrap: true,
                      primary: false,
                      itemCount: _listApiProvinsi.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                            title: Text(_listApiProvinsi[index].provinsi),
                            trailing: Icon(Icons.chevron_right),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DetailProvinsi(
                                            provinsi: _listApiProvinsi[index]
                                                .provinsi,
                                            kasusMeni: _listApiProvinsi[index]
                                                .kasusMeni,
                                            kasusPosi: _listApiProvinsi[index]
                                                .kasusPosi,
                                            kasusSemb: _listApiProvinsi[index]
                                                .kasusSemb,
                                          )));
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
      onRefresh: _refreshHalaman,
    );
  }

  _jikaTidakAda() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}

// untuk tampilan kotak
class BoxShow extends StatelessWidget {
  final String judul;
  final String total;
  final Color warna;

  BoxShow({this.judul, this.total, this.warna});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8.0,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      color: warna,
      child: Center(
        child: ListView(
          primary: false,
          shrinkWrap: true,
          children: <Widget>[
            AutoSizeText(
              judul,
              style: TextStyle(fontSize: 32.0),
              maxLines: 1,
              textAlign: TextAlign.center,
            ),
            AutoSizeText(
              total,
              style: TextStyle(fontSize: 30.0),
              maxLines: 2,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
