import 'package:flutter/material.dart';
import '../Constant/ColorGlobal.dart';

class PayPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: ColorGlobal.whiteColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: ColorGlobal.textColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Pay',
          style: TextStyle(color: ColorGlobal.textColor),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(12.0, 16.0, 12.0, 0.0),
              child: Text(
                'If you are paying for your annual membership or contribution towards an upcoming event, please tranfer/deposit in the following bank account',
                style: TextStyle(
                  color: const Color(0xFF544F50),
                  fontSize: 18.0,
                  letterSpacing: 1.2,
                  wordSpacing: 1.2,
                ),
              ),
            ),
            SizedBox(height: 10.0),
            Card(
              margin: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
              color: Colors.blue[300],
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text(
                        'A/c Holder: RECAL UAE CHAPTER',
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 6.0),
                      Text(
                        'A/c No./IBAN: AE54672345',
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 6.0),
                      Text(
                        'Branch Address : NA',
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 6.0),
                      Text(
                        'Swift: ',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.white,
                        ),
                      )
                    ]
                ),
              ),
            ),
            SizedBox(height: 10.0),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
              child: Text(
                  'Note:',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: const Color(0xFF544F50),
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    wordSpacing: 1.2,
                  )
              ),
            ),
            SizedBox(height: 6.0),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
              child: Text(
                  '\u2022 Once the payment is received, you will receive a notification on your registered e-mail or on this app once you login again. ',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: const Color(0xFF544F50),
                  )
              ),
            ),
            SizedBox(height: 6.0),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
              child: Text(
                '\u2022 The cost of the annual membership is AED 500 valid for one year from the day of payment. You are entitled to attend all the events organized by the chapter at subsidized rates.',
                style: TextStyle(
                  fontSize: 18.0,
                  color: const Color(0xFF544F50),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 4.0),
              child: Image(
                image: AssetImage('assets/images/pay_bg.jpg'),
                alignment: Alignment.bottomCenter,
              ),
            ),
//          Padding(
//            padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
//            child: Text(
//              'https://www.freepik.com/free-photos-vectors/business. Business vector created by freepik - www.freepik.com',
//                style: TextStyle(
//                  fontSize: 10.0,
//                  color: Colors.grey[500],
//                ),
//            ),
//          )
          ],
        ),
      ),
    );
  }
}