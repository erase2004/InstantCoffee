import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:readr_app/blocs/memberCenter/subscriptionSelect/bloc.dart';
import 'package:readr_app/blocs/memberCenter/subscriptionSelect/events.dart';
import 'package:readr_app/blocs/memberCenter/subscriptionSelect/states.dart';
import 'package:readr_app/helpers/dataConstants.dart';
import 'package:readr_app/helpers/routeGenerator.dart';

class SubscriptionSelectWidget extends StatefulWidget {
  @override
  _SubscriptionSelectWidgetState createState() => _SubscriptionSelectWidgetState();
}

class _SubscriptionSelectWidgetState extends State<SubscriptionSelectWidget> {
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _fetchSubscriptionProducts();
  }

  _fetchSubscriptionProducts() {
    context.read<SubscriptionSelectBloc>().add(
      FetchSubscriptionProducts()
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubscriptionSelectBloc, SubscriptionSelectState>(
      builder: (BuildContext context, SubscriptionSelectState state) {
        if (state is SubscriptionProductsLoadedFail) {
          final error = state.error;
          print('SubscriptionProductsLoadedFail: ${error.message}');
          return Container();
        }

        if (state is SubscriptionProductsLoaded) {
          List<ProductDetails> productDetailList = state.productDetailList;
          
          return ListView(
            children: [
              SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 0.0),
                child: _memberIntroBlock(productDetailList),
              ),
              SizedBox(height: 48),
              Padding(
                padding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 0.0),
                child: _memberAttention(),
              ),
              SizedBox(height: 48),
            ],
          );
        }

        // state is Init, Loading
        return _loadingWidget();
      }
    );
  }

  Widget _loadingWidget() {
    return Center(child: CircularProgressIndicator(),);
  }

  Widget _memberIntroBlock(List<ProductDetails> productDetailList) {
    double width = MediaQuery.of(context).size.width;

    return Card(
      elevation: 10,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Premium 會員',
                  style: TextStyle(
                    color: appColor,
                    fontSize: 20,
                  ),
                ),
                Image.asset(
                  'assets/image/badge.png',
                  width: 60,
                  height:80,
                ),
              ],
            ),
            _memberClause('支持鏡週刊報導精神'),
            Divider(),
            _memberClause('暢讀鏡週刊全站內容'),
            Divider(),
            _memberClause('會員專區零廣告純淨閱覽'),
            Divider(),
            _memberClause('專區好文不分頁流暢閱讀'),
            Divider(),
            _memberClause('免費閱覽最新電子版週刊'),
            Divider(),
            _memberClause('月方案定價\$99元，限時優惠\$49元'),
            Divider(),
            _memberClause('年方案定價\$1,188元，限時優\$499元'),
            SizedBox(height: 24),
            ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              separatorBuilder: (BuildContext context, int index) => SizedBox(height: 12),
              itemCount: productDetailList.length,
              itemBuilder: (context, index) {
                final ButtonStyle buttonStyle = TextButton.styleFrom(
                  backgroundColor: index%2==0 ? appColor : Colors.white,
                  padding: const EdgeInsets.only(top: 12, bottom: 12),
                );

                return OutlinedButton(
                  style: buttonStyle,
                  child: Container(
                    width: width,
                    child: Center(
                      child: Column(
                        children: [
                          Text(
                            productDetailList[index].title,
                            style: TextStyle(
                              fontSize: 18,
                              color: index%2==0 ? Colors.white : Colors.black,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '優惠 ${productDetailList[index].price} 元',
                            style: TextStyle(
                              fontSize: 13,
                              color: index%2==0 ? Colors.white60 : Colors.black38,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  onPressed: () async{
                    await _auth.currentUser.reload();
                    if(_auth.currentUser.emailVerified) {
                      Fluttertoast.showToast(
                        msg: '執行購買～',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.green,
                        textColor: Colors.white,
                        fontSize: 16.0
                      );
                    } else {
                      RouteGenerator.navigateToEmailVerification(context);
                    }
                  },
                );
              }
            ),
          ],
        ),
      )
    );
  }

  Widget _memberClause(String title) {
    return Row(
      children: [
        Icon(
          Icons.check,
          color: appColor,
        ),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              color: Colors.black54,
              fontSize: 16,
            ),
          ),
        ),
      ]
    );
  }

  Widget _memberAttention() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '注意事項',
          style: TextStyle(
            fontSize: 22,
          ),
        ),
        SizedBox(height: 12),
        _orderClause(1, '月方案計算天數為 30 日，年方案計算天數為 365 日。'),
        _orderClause(2, '月訂閱方案經會員授權扣款購買即為完成服務，所以月費會員無法退費，但可取消繼續訂閱。'),
        _orderClause(3, '訂閱購買的同時會開啓自動續費(扣款)，在訂閱到期時將依據原訂閱方案自動扣款，並延續訂閱。'),
        _orderClause(4, '訂閱相關問題請 email 至會員專屬客服信箱 MM-onlineservice@mirrormedia.mg， 我們會盡快為您協助處理。'),
        _orderClause(5, '更多詳細內容，請至服務條款。'),
      ],
    );
  }

  Widget _orderClause(int order, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Text(
            "$order.",
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              content,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}