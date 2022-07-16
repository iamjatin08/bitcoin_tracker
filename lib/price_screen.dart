import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'coin_data.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';
  String bitcoinValueInUSD = '?';
  String bitcoinValueInETH = '?';
  String bitcoinValueInLTC = '?';
  CoinData findData = CoinData();

  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      dropdownItems.add(newItem);
    }

    return DropdownButton<String>(
      value: selectedCurrency,
      items: dropdownItems,
      onChanged: (value) {
        selectedCurrency = value;
        getData(selectedCurrency);
      },
    );
  }

  CupertinoPicker iOSPicker() {
    List<Text> pickerItems = [];
    for (String currency in currenciesList) {
      pickerItems.add(Text(currency));
    }

    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        selectedCurrency = currenciesList[selectedIndex];
        getData(selectedCurrency);
      },
      children: pickerItems,
    );
  }

  void getData(String currency) async {
    try {
      double dataUSD =
      await findData.getCoinData(crypto: 'BTC', selectedCurrency: currency);
      double dataETH =
      await findData.getCoinData(crypto: 'ETH', selectedCurrency: currency);
      double dataLTC =
      await findData.getCoinData(crypto: 'LTC', selectedCurrency: currency);
      setState(() {
        bitcoinValueInUSD = dataUSD.toStringAsFixed(0);
        bitcoinValueInETH = dataETH.toStringAsFixed(0);
        bitcoinValueInLTC = dataLTC.toStringAsFixed(0);
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getData(selectedCurrency);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Coin Ticker')),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
                child: NewCard(
                  bitcoinValueInUSD: bitcoinValueInUSD,
                  selectedCurrency: selectedCurrency,
                  CurrencyName: "USD",
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
                child: NewCard(
                  bitcoinValueInUSD: bitcoinValueInETH,
                  selectedCurrency: selectedCurrency,
                  CurrencyName: "ETH",
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
                child: NewCard(
                  bitcoinValueInUSD: bitcoinValueInLTC,
                  selectedCurrency: selectedCurrency,
                  CurrencyName: "LTC",
                ),
              ),
            ],
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iOSPicker() : androidDropdown(),
          ),
        ],
      ),
    );
  }
}

class NewCard extends StatelessWidget {
  const NewCard({
    Key key,
    @required this.bitcoinValueInUSD,
    @required this.selectedCurrency,
    @required this.CurrencyName
  }) : super(key: key);

  final String bitcoinValueInUSD;
  final String selectedCurrency;
  final String CurrencyName;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.lightBlueAccent,
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
        child: Text(
          '1 $CurrencyName = $bitcoinValueInUSD $selectedCurrency',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
