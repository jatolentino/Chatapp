//*************    

import 'dart:io';
import 'package:chatapp/Configs/app_constants.dart';

String? getBannerAdUnitId() {
  if (Platform.isIOS) {
    return Admob_BannerAdUnitID_Ios;
  } else if (Platform.isAndroid) {
    return Admob_BannerAdUnitID_Android;
  }
  return null;
}

String? getInterstitialAdUnitId() {
  if (Platform.isIOS) {
    return InterstitialUnit_IOS;
  } else if (Platform.isAndroid) {
    return InterstitialUnit_Android;
  }
  return null;
}

String? getRewardBasedVideoAdUnitId() {
  if (Platform.isIOS) {
    return RewardedAdUnit_IOS;
  } else if (Platform.isAndroid) {
    return RewardedAdUnit_Android;
  }
  return null;
}
