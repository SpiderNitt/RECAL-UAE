import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:iosrecal/Constant/ColorGlobal.dart';
import 'package:iosrecal/Constant/utils.dart';
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
  int countDetailsCall=0;
  bool isCompleted=false;
  List<int> accountIDList=new List<int>();
  List<AccountInfo> accountDetailsList=new List<AccountInfo>();
  String baseURL = "https://delta.nitt.edu/recal-uae";
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery
        .of(context)
        .size;
    UIUtills().updateScreenDimesion(
        width: screenSize.width, height: screenSize.height);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        //0XFF0288d1
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
    if(!isCompleted){
      if(accountID==-2||isAccountEmpty){
        return Center(
            child: Text(
                "No account information for this event!!", style: GoogleFonts.kalam(fontSize: 22,color: ColorGlobal.textColor))
        );
      }
      else if(accountID==-3||accountServerError){
        return Center(
            child: Text(
                "Server Error", style: GoogleFonts.kalam(fontSize: 22,color: ColorGlobal.textColor))
        );
      }
      else   if(accountID==-1||accountID==null){
        return
          Center(
            child: SpinKitDoubleBounce(
              color: Colors.lightBlueAccent,
            ),

          );
      }    }
    else{
      print(accountDetailsList.length.toString()+"length");
      return Container(
        margin: EdgeInsets.only(top:6),
        child: ListView.builder(
            itemCount: accountDetailsList.length, itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    spreadRadius: 0.75,
                    blurRadius: 100.0,
                    offset: Offset(
                        0, // Move to right 10  horizontally
                        0.75// Move to bottom 5 Vertically
                    ),
                    color: Colors.black12
                )
              ],
            ),
            margin:EdgeInsets.only(top:5,bottom:5,left:10,right: 10),
            child: ExpansionTile(
              backgroundColor: Colors.white,
              title: Row(
                children: <Widget>[
                  Icon(
                    Icons.monetization_on, size: 34,
                    color: Colors.green,),
                  SizedBox(width: 8,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 8,),
                      accountDetailsList[index]
                          .payment_amount!=null?Container(
                        width:UIUtills().getProportionalWidth(width: 200),
                        child: Text(
                          accountDetailsList[index].income_expense!=null?
                          (accountDetailsList[index].income_expense.toUpperCase()=="INCOME"?
                          "+" +accountDetailsList[index]
                            .payment_amount.toString():"-"+accountDetailsList[index]
                              .payment_amount.toString()):accountDetailsList[index]
                              .payment_amount.toString(),
                        overflow:TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                              color: ColorGlobal.textColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),),
                          ):Text("Payment amount not available",style:TextStyle(color: Colors.black38)),
                      SizedBox(height: 4,),
                      accountDetailsList[index].income_expense!=null?Text(accountDetailsList[index].income_expense.substring(0,1).toUpperCase()+accountDetailsList[index].income_expense.substring(1),
                        style: TextStyle(
                            color: accountDetailsList[index].income_expense.toUpperCase()=="INCOME"?Colors.green[800]:Colors.red[800],
                            fontStyle: FontStyle.italic,
                            fontSize: 16),):SizedBox(),
                      SizedBox(height: 8,)
                    ],
                  ),
                ],
              ),

              trailing: Icon(
                Icons.keyboard_arrow_down,
                color: ColorGlobal.textColor,
              ),
              children: <Widget>[
                Container(
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
                                        accountDetailsList[index].payment_type!=null&& accountDetailsList[index].payment_mode!=null?Column(
                                         crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            accountDetailsList[index].payment_type!=null?Container(
                                            width:UIUtills().getProportionalWidth(width: 150),
                                              child: Text(
                                                accountDetailsList[index].payment_type,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                style: TextStyle(
                                                    fontSize: 18
                                                ),
                                              ),
                                            ):SizedBox(),
                                            SizedBox(height: 4,),
                                            accountDetailsList[index].payment_mode!=null? Container(
                                              width:UIUtills().getProportionalWidth(width: 100),
                                              child: Text(
                                                accountDetailsList[index].payment_mode,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.black45
                                                ),
                                              ),
                                            ):SizedBox()
                                          ],
                                        ):Text("Payment Type Not available",style: TextStyle(color: Colors.black38),)
                                      ],
                                    ),
                                  ),
                                  accountDetailsList[index].date!=null? Text(
                                    getDate(accountDetailsList[index].date),
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

                                      SizedBox(width: 4,),

                                    ],
                                  ),
                                  SizedBox(height: 4,),
                                  Row(
                                    children: <Widget>[
                                      Container(

                                        child: Text("Paid by: ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                          ),),
                                      ),
                                      accountDetailsList[index].paid_user_name!=null?Container(
                                        width:UIUtills().getProportionalWidth(width: 200),
                                        child: Text(
                                          accountDetailsList[index].paid_user_name,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,),
                                      ):Text("Not available"),
                                    ],
                                  ),

                                  SizedBox(height: 20,),
                                  accountDetailsList[index].invoice_file!=null?
                                  Container(
                                    child:FadeInImage.memoryNetwork(
                                      placeholder: kTransparentImage,
                                      image: baseURL+accountDetailsList[index].invoice_file,
                                      fit: BoxFit.fitWidth,
                                    ),
                                    width: MediaQuery.of(context).size.width,
                                  ):SizedBox(),
                          // accountDetailsList[index]
                          //     .invoice_file != null?Container(
                          //     child:FadeInImage.memoryNetwork(
                          //            placeholder: kTransparentImage,
                          //            image: (baseURL +
                          //                accountDetailsList[index].invoice_file),
                          //            fit: BoxFit.fitWidth,
                          //          ),
                          //     ): SizedBox(),
                                ],
                              )
                            ],
                          ),
                        ),
                      )
                  ),
                )
              ],
            ),
          );
        }),
      );
    }

  }
  Future<AccountInfo> getAccountDetails() async {
    print("second api");
    AccountInfo accountInfos=new AccountInfo();
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
            countDetailsCall++;
            if(responseBody.data.length!=0) {
              // accountInfo=AccountInfo.fromJson(json.decode(responseBody.data));
              print("final Response"+responseBody.data.toString());
              //  accountInfos=AccountInfo.fromJson(json.decode(responseBody.data));

              accountInfos.paid_user_name=responseBody.data['paid_user_name'];
              accountInfos.account_id=responseBody.data['account_id'];
              accountInfos.payment_amount=responseBody.data['payment_amount'];
              accountInfos.date=responseBody.data['date'];
              accountInfos.payment_type=responseBody.data['payment_type'];
              accountInfos.payment_mode=responseBody.data['payment_mode'];
              accountInfos.income_expense=responseBody.data['income_expense'];
              accountInfos.invoice_file=responseBody.data['invoice'];
              accountDetailsList.add(accountInfos);
              if(accountIDList.length==countDetailsCall){
                setState(() {
                  isCompleted=true;
                });
              }

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

String getDate(String date){
  final DateFormat formatter = DateFormat('dd-MM-yyyy');
return formatter.format(DateFormat('yyyy-MM-dd').parse(date));

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
                      if(m['paid_user_id'].toString()== prefs.getString('user_id').toString()) {
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
                if (u['income'] != null) {
                  for(var m in u['income']){
                    if(m['account_id']!=null){
                      if(m['paid_user_id'].toString()== prefs.getString('user_id').toString()) {
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
            }
            if(accountIDList.length!=0){
              //   getAccountDetails(nameList,accountIDList);
              for(int i=0;i<accountIDList.length;i++){
                setState(() {
                  accountID=accountIDList[i];
                });
                getAccountDetails();
              }
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