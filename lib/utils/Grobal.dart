import 'dart:io';

import 'package:admob_flutter/admob_flutter.dart';

final String bannerAdUnitId = (Platform.isIOS) ? 'ca-app-pub-3919640760442445/3680293709' : (Platform.isAndroid) ? 'ca-app-pub-3919640760442445/1688555189' : null;
final String appId =  (Platform.isIOS) ? 'ca-app-pub-3919640760442445~1385302852' : (Platform.isAndroid) ? 'ca-app-pub-3919640760442445~8090312004' : null;
AdmobInterstitial interstitialAd = AdmobInterstitial(
  adUnitId: (Platform.isIOS) ? 'ca-app-pub-3919640760442445/9423590886' : (Platform.isAndroid) ? 'ca-app-pub-3919640760442445/2839954942' : null,
);

bool languageJa;

enum Mode{
  add,
  edit
}

enum SelectTeam{
  myTeam,
  enemyTeam,
}
enum Position{
  backRight,
  frontRight,
  frontCenter,
  frontLeft,
  backLeft,
  backCenter
}
enum InputFormat{
  formatOK,
  duplicateTeamName,
  emptyTeamName,
  emptyPlayerNum,
  duplicatePlayerNum,
}

class PointName{
  final String pointName;
  final String pointNameEn;
  final String pointSymbol;
  final String pointType;
  PointName({this.pointName, this.pointNameEn, this.pointSymbol, this.pointType });

  static List<Map<String, dynamic>> listMap = [
    {
      'pointName' : 'サービスエース(SA)',
      'pointNameEn' : 'Service Ace(SA)',
      'pointSymbol' : 'SA',
      'position' : 'server',
      'pointType' : 'Get'
    },{
      'pointName' : 'スパイク(K)',
      'pointNameEn' : 'Spike Kill(K)',
      'pointSymbol' : 'K',
      'position' : 'front',
      'pointType' : 'Get'
    },{
      'pointName' : 'フェイント(F)',
      'pointNameEn' : 'Feint Kill(F)',
      'pointSymbol' : 'F',
      'position' : 'front',
      'pointType' : 'Get'
    },{
      'pointName' : 'ブロック(B)',
      'pointNameEn' : 'Block Kill(B)',
      'pointSymbol' : 'B',
      'position' : 'front',
      'pointType' : 'Get'
    },{
      'pointName' : 'バックアタック(BA)',
      'pointNameEn' : 'Back row Attack(BA)',
      'pointSymbol' : 'BA',
      'position' : 'back',
      'pointType' : 'Get'
    },{
      'pointName' : 'ツーアタック(2)',
      'pointNameEn' : 'Dump(2)',
      'pointSymbol' : '2',
      'position' : 'front',
      'pointType' : 'Get'
    },{
      'pointName' : 'その他得点(AO)',
      'pointNameEn' : 'Other Ace(AO)',
      'pointSymbol' : 'AO',
      'position' : 'all',
      'pointType' : 'Get'
    },{
      'pointName' : 'サーブミス(MS)',
      'pointNameEn' : 'Serve Miss(MS)',
      'pointSymbol' : 'MS',
      'position' : 'server',
      'pointType' : 'Lost'
    },{
      'pointName' : 'スパイクミス(MK)',
      'pointNameEn' : 'Spike Miss(MK)',
      'pointSymbol' : 'MK',
      'position' : 'all',
      'pointType' : 'Lost'
    },{
      'pointName' : 'フェイントミス(MF)',
      'pointNameEn' : 'Feint Miss(MF)',
      'pointSymbol' : 'MF',
      'position' : 'front',
      'pointType' : 'Lost'
    },{
      'pointName' : 'ブロックミス(MB)',
      'pointNameEn' : 'Block Miss(MB)',
      'pointSymbol' : 'MB',
      'position' : 'front',
      'pointType' : 'Lost'
    },{
      'pointName' : 'レシーブミス(MR)',
      'pointNameEn' : 'Dig Miss(MR)',
      'pointSymbol' : 'MR',
      'position' : 'all',
      'pointType' : 'Lost'
    },{
      'pointName' : 'その他ミス(MO)',
      'pointNameEn' : 'Other Miss(MO)',
      'pointSymbol' : 'MO',
      'position' : 'all',
      'pointType' : 'Lost'
    },{
      'pointName' : 'タッチネット(TN)',
      'pointNameEn' : 'Touch Net(TN)',
      'pointSymbol' : 'TN',
      'position' : 'front',
      'pointType' : 'Lost'
    },{
      'pointName' : 'パッシングセンターライン(PC)',
      'pointNameEn' : 'Passing Center line(PC)',
      'pointSymbol' : 'PC',
      'position' : 'all',
      'pointType' : 'Lost'
    },{
      'pointName' : 'ホールディング(H)',
      'pointNameEn' : 'Holding(H)',
      'pointSymbol' : 'H',
      'position' : 'all',
      'pointType' : 'Lost'
    },{
      'pointName' : 'ダブルコンタクト(D)',
      'pointNameEn' : 'Double contact(D)',
      'pointSymbol' : 'D',
      'position' : 'all',
      'pointType' : 'Lost'
    },{
      'pointName' : 'フォアヒット(FH)',
      'pointNameEn' : 'Fore hit(FH)',
      'pointSymbol' : 'FH',
      'position' : 'all',
      'pointType' : 'Lost'
    },{
      'pointName' : 'その他反則(FO)',
      'pointNameEn' : 'Other Foul(FO)',
      'pointSymbol' : 'FO',
      'position' : 'all',
      'pointType' : 'Lost'
    },
  ];
}
