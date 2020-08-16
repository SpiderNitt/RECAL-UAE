import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:iosrecal/Constant/ColorGlobal.dart';
import 'package:iosrecal/models/AccountInfo.dart';
import 'package:iosrecal/models/ResponseBody.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transparent_image/transparent_image.dart';
class Accounts extends StatefulWidget {
  int event_id;
  Accounts(this.event_id);
  @override
  _AccountsState createState() => _AccountsState();
}

class _AccountsState extends State<Accounts> {
  bool isAccountEmpty = false;
  bool accountServerError = false;
  int accountID=-1;
  AccountInfo accountInfos=new AccountInfo();
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery
        .of(context)
        .size
        .width;
    final height = MediaQuery
        .of(context)
        .size
        .height;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
              "Accounts", style: TextStyle(color: ColorGlobal.textColor)),
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(
              color: ColorGlobal.textColor
          ),
        ),
        body:DisplayAccount(),
      ),
    );
  }

Widget DisplayAccount(){

     if(accountID==-2||isAccountEmpty){
      return Center(
                    child: Text(
                        "No account information for this event", style: TextStyle(
                        color: Colors.blueGrey,
                      fontSize: 16
                    ))
                );
    }
    else if(accountID==-3||accountServerError){
      return Center(
                    child: Text(
                        "Server Error", style: TextStyle(
                        color: Colors.blueGrey,
                      fontSize: 16
                    ))
                );
    }
    else   if(accountID==-1||accountID==null){
       return
         Center(
           child: SpinKitDoubleBounce(
             color: Colors.lightBlueAccent,
           ),

         );
     }
    else{
      print("whyyy"+accountID.toString());
        return Container(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xff374ABE), Color(0xff3AAFFA)],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(20.0)),
                          margin: EdgeInsets.all(6),
                          child: Padding(
                              padding: const EdgeInsets.all(6),
                              child: Card(
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start,
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceBetween,
                                        children: <Widget>[
                                          Container(
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment
                                                  .start,
                                              children: <Widget>[
                                                Container(
                                                  child: Image.asset(
                                                    "assets/images/pay.png",
                                                    fit: BoxFit.cover,),
                                                  height: 50,
                                                ),
//Icon(Icons.payment,size: 36,color: Colors.blueGrey,),
                                                SizedBox(width: 4,),
                                                accountInfos.payment_type!=null&& accountInfos.payment_mode!=null?Column(
                                                  children: <Widget>[
                                                    accountInfos.payment_type!=null?Text(
                                                      accountInfos.payment_type,
                                                      style: TextStyle(
                                                          fontSize: 18
                                                      ),
                                                    ):SizedBox(),
                                                    SizedBox(height: 4,),
                                                    accountInfos.payment_mode!=null? Text(
                                                      accountInfos.payment_mode,
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.black45
                                                      ),
                                                    ):SizedBox()
                                                  ],
                                                ):Text("Payment Type Not available",style: TextStyle(color: Colors.black38),)
                                              ],
                                            ),
                                          ),
                                          accountInfos.date!=null? Text(
                                            accountInfos.date,
                                            style: TextStyle(
                                                color: Colors.black54
                                            ),
                                          ):SizedBox()
                                        ],
                                      ),
                                      SizedBox(height: 10,),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start,
                                        children: <Widget>[

                                          Row(
                                            children: <Widget>[
                                              Icon(
                                                Icons.monetization_on, size: 28,
                                                color: Colors.green,),
                                              SizedBox(width: 4,),
                                              accountInfos
                                                  .payment_amount!=null?Text(accountInfos.payment_amount.toString(),
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16),):Text("Payment amount not available",style:TextStyle(color: Colors.black38))
                                            ],
                                          ),
                                          SizedBox(height: 4,),
                                          Row(
                                            children: <Widget>[
                                              Text("Paid by: ",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold
                                                ),),
                                              accountInfos.paid_user_name!=null?Text(
                                                  accountInfos.paid_user_name):Text("Not available"),
                                            ],
                                          ),
                                          accountInfos.income_expense!=null?Text(accountInfos
                                              .income_expense.toUpperCase()):SizedBox(),
SizedBox(height: 20,),
Container(
  child:FadeInImage.memoryNetwork(
    placeholder: kTransparentImage,
    image: "https://picsum.photos/300",
    fit: BoxFit.fitWidth,
  ),
  width: MediaQuery.of(context).size.width,
),

                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              )
                          ),
                        );
    }
}
Future<AccountInfo> getAccountDetails() async {
    if(accountID!=-1&& accountID!=null){
      print("second api called");
        var params={'account_id':accountID.toString()};

        var uri=Uri.https('delta.nitt.edu', '/recal-uae/api/events/accounts/',params);
        SharedPreferences prefs=await SharedPreferences.getInstance();
        var response=await http.get(
            uri,
            headers: {
              "Accept" : "application/json",
              "Cookie" : "${prefs.getString("cookie")}",
            }
        ) .then((_response) {
          ResponseBody responseBody = new ResponseBody();
          print('Response body: accountDetails ${_response.body}');
          if (_response.statusCode == 200) {
            responseBody = ResponseBody.fromJson(json.decode(_response.body));

            if (responseBody.status_code == 200) {
              if(responseBody.data!=null) {
             // accountInfo=AccountInfo.fromJson(json.decode(responseBody.data));
                print(responseBody.data.toString());
                setState(() {
                //  accountInfos=AccountInfo.fromJson(json.decode(responseBody.data));
                accountInfos.paid_user_name=responseBody.data['paid_user_name'];
                accountInfos.account_id=responseBody.data['account_id'];
                accountInfos.payment_amount=responseBody.data['payment_amount'];
                accountInfos.date=responseBody.data['date'];
                accountInfos.payment_type=responseBody.data['payment_type'];
                accountInfos.payment_mode=responseBody.data['payment_mode'];
                accountInfos.income_expense=responseBody.data['income_expense'];
                accountInfos.invoice_file=responseBody.data['invoice'];
                });
              }
            } else {
              print(responseBody.data);
              return 2;
            }
          } else {
            print('Server error');
            accountServerError=true;

          }
          return accountInfos;
        });

    if(accountInfos==null){
      if(accountServerError==true){
        setState(() {
          accountServerError=true;
          accountID=-3;
        });
      }
else{
setState(() {
  isAccountEmpty=true;
  accountID=-2;
});
      }
    }
    }
}


  @override
  void initState() {
    super.initState();
    getAccountId();
  }
void getId() async{
    accountID=await getAccountId();
    print(accountID.toString());
  }
  Future<dynamic> getAccountId() async {
    List<String> nameList=new List<String>();
    List<int> accountIDList=new List<int>();
    var uri = Uri.https(
        'delta.nitt.edu', '/recal-uae/api/events/all_accounts/');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await http.get(uri, headers: {
      "Accept": "application/json",
      "Cookie": "${prefs.getString("cookie")}",
    }).then((_response) {
      ResponseBody responseBody = new ResponseBody();
      print('Response body: accountID ${_response.body}');
      if (_response.statusCode == 200) {
        responseBody = ResponseBody.fromJson(json.decode(_response.body));
        if (responseBody.status_code == 200) {
          if (responseBody.data.length!=0) {
            for (var u in responseBody.data) {
              if(u['event_id']==widget.event_id) {
                if (u['expenses'] != null) {
                  for(var m in u['expenses']){
                   if(m['account_id']!=null){
                     accountIDList.add(m['account_id']);
                     if(m['paid_user_name']!=null){
                       nameList.add(m['paid_user_name']);
                     }else{
                       nameList.add('null');
                     }
                   }
                  }
                }
              }
            }
            if(accountIDList.length!=0){
           //   getAccountDetails(nameList,accountIDList);
              setState(() {
                accountID=accountIDList[0];
              });
              getAccountDetails();
            }
            else{

              setState(() {
                isAccountEmpty=true;
              });
            }
          }

        } else {
          print(responseBody.data);
        }
      } else {
        print('Server error');
        setState(() {
          accountServerError=true;
        });
      }
    });
  }
}