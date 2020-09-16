import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart';
import 'package:learn_app/models/getApiProvinsiDetail.dart';

class DetailProvinsi extends StatefulWidget {
  final String provinsi;
  final int kasusPosi;
  final int kasusSemb;
  final int kasusMeni;

  DetailProvinsi(
      {this.provinsi, this.kasusPosi, this.kasusSemb, this.kasusMeni});

  @override
  _DetailProvinsiState createState() => _DetailProvinsiState();
}

class _DetailProvinsiState extends State<DetailProvinsi> {
  List<ApiProvinsiDetail> _listCases;
  List<Series<ApiProvinsiDetail, String>> _listSeries;
  var _chartsType = 'bar';

  @override
  void initState() {
    _listCases = <ApiProvinsiDetail>[
      ApiProvinsiDetail(
        title: "Positif",
        count: widget.kasusPosi,
      ),
      ApiProvinsiDetail(
        title: "Sembuh",
        count: widget.kasusSemb,
      ),
      ApiProvinsiDetail(
        title: "Meninggal",
        count: widget.kasusMeni,
      ),
    ];
    _listSeries = <Series<ApiProvinsiDetail, String>>[
      Series(
        id: widget.provinsi,
        data: _listCases,
        domainFn: (ApiProvinsiDetail cases, int index) {
          return cases.title;
        },
        measureFn: (ApiProvinsiDetail cases, int index) {
          return cases.count;
        },
        labelAccessorFn: (ApiProvinsiDetail cases, int index) {
          return "${cases.count}";
        },
      ),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daerah ${widget.provinsi}'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.cached),
            onPressed: () {
              _chartsType = _chartsType == "bar" ? "pie" : "bar";
              setState(() {});
            },
          ),
        ],
      ),
      body: _chartsType == "bar"
          ? BarChart(
              _listSeries,
              barRendererDecorator: BarLabelDecorator<String>(
                labelPosition: BarLabelPosition.outside,
              ),
            )
          : PieChart(
              _listSeries,
              defaultRenderer: ArcRendererConfig(
                arcRendererDecorators: [
                  ArcLabelDecorator(
                    labelPosition: ArcLabelPosition.outside,
                  ),
                ],
              ),
              behaviors: [
                DatumLegend(
                  showMeasures: true,
                  legendDefaultMeasure: LegendDefaultMeasure.sum,
                ),
              ],
            ),
    );
  }
}
