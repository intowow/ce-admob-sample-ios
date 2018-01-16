//
//  AdViewController.h
//  AdMobDemo
//
//  Copyright © 2017年 intowow. All rights reserved.
//

#define AdMob_Banner_Unit_ID @"ca-app-pub-4766247142778820/9320905494"
#define AdMob_Rewarded_Unit_ID @"ca-app-pub-4766247142778820/2141241289"
#define AdMob_Interstitial_Unit_ID @"ca-app-pub-4766247142778820/8017368313"

#import <UIKit/UIKit.h>

@import GoogleMobileAds;

@interface AdViewController : UIViewController <GADBannerViewDelegate, GADRewardBasedVideoAdDelegate, GADNativeContentAdLoaderDelegate, GADInterstitialDelegate>

@property (strong, nonatomic)   IBOutlet UIView * adUIView;
@property (strong, nonatomic)   IBOutlet UIView * adMediaCoverView;
@property (strong, nonatomic)   IBOutlet UIButton *loadBannerBtn;
@property (strong, nonatomic) IBOutlet UIButton *loadRewardedBtn;
@property (strong, nonatomic) IBOutlet UIButton *loadNativeBtn;
@property (strong, nonatomic) IBOutlet UIButton *loadInterstitialBtn;


@end
