# ce-admob-sample-ios

## Mediate CrystalExpress Ads through AdMob

The full integration guide: https://intowow.gitbooks.io/crystalexpress-documentation-v3-x/content/mediation-guidelines/admob/ios.html

The CrystalExpress AdMob Custom Event allows AdMob publishers to add CrystalExpress as a Custom Ad Network within the AdMob platform.

CrystalExpress provides four ad formats for AdMob mediation. The relationship between AdMob ad unit and ad format in CrystalExpress is as following:

| AdMob ad unit | AD format from CrystalExpress |
| --- | --- |
| Banner | Card AD |
| Rewarded Video | Rewarded Video AD |
| Interstitial | Splash AD |
| Native Advanced | Native AD \(image only\) |

Before adding CrystalExpress as Custom network, you have to integrate AdMob SDK by following the instructions on the [AdMob website](https://developers.google.com/admob/ios/quick-start).


** NOTICE: This porject does not contain CrystalExpress SDK. Please contact your Intowow account manager. We will provide the appropriate version of SDK and Crystal ID to fit your needs.**

The custom event is under folder 'AdMobDemo/CrystalExpress_Google_CustomEvent/'


## CHANGELOG

#### Version 4 (2017-12-14)

#### Features
* Implement AdMob Interstitial Custom Event.


#### Version 3 (2017-09-28)

#### Features
* Implement AdMob Native Advanced Custom Event.


#### Version 2 (2017-08-31)

#### Features
* Implement AdMob adapter for CE rewarded video.


#### Version 1 (2017-08-08)

#### Features
* Implement AdMob Custom Events for CE Card.