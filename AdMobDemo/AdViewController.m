//
//  AdViewController.m
//  AdMobDemo
//
//  Copyright © 2017年 intowow. All rights reserved.
//

#import "AdViewController.h"
#import "UIView+CELayoutAdditions.h"

@interface AdViewController ()
@property (nonatomic, assign) CGRect rectOriginal;
@property (nonatomic, strong) GADBannerView * bannerView;
@property (nonatomic, strong) GADNativeContentAdView *contentAdView;
@property (nonatomic, strong) GADAdLoader * adLoader;
@property (nonatomic, strong) GADInterstitial *interstitial;
@end

@implementation AdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    _rectOriginal = _adMediaCoverView.frame;//keep auto resize view

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL) shouldAutorotate {
    return NO;
}

- (void)clearView
{
    [self.bannerView removeFromSuperview];
    [self.contentAdView removeFromSuperview];
}

#pragma mark - Load AdMob Ads

- (IBAction)loadBannerAd:(id)sender {
    [self clearView];
    //Basic Setting for bannerView
    GADAdSize customAdSize = GADAdSizeFromCGSize(_rectOriginal.size);
    self.bannerView = [[GADBannerView alloc] initWithAdSize:customAdSize];
    self.bannerView.adUnitID = AdMob_Banner_Unit_ID;
    self.bannerView.rootViewController = self;
    self.bannerView.delegate = self;
    [self.bannerView loadRequest:[GADRequest request]];
}
- (IBAction)loadRewardedBtn:(id)sender {
    [self clearView];
    GADRequest *request = [GADRequest request];
    [GADRewardBasedVideoAd sharedInstance].delegate = self;
    [[GADRewardBasedVideoAd sharedInstance] loadRequest:request
                                           withAdUnitID:AdMob_Rewarded_Unit_ID];
}
- (IBAction)loadNativeBtn:(id)sender {
    [self clearView];

    GADVideoOptions *adVideoOptions = [[GADVideoOptions alloc] init];

    self.adLoader = [[GADAdLoader alloc] initWithAdUnitID:@"Please use your unit id"
                                       rootViewController:self
                                                  adTypes:@[kGADAdLoaderAdTypeNativeContent]
                                                  options:@[adVideoOptions]];
    self.adLoader.delegate = self;
    [self.adLoader loadRequest:[GADRequest request]];
}

- (IBAction)loadInterstitialBtn:(id)sender {
    [self clearView];
    self.interstitial = [[GADInterstitial alloc] initWithAdUnitID:AdMob_Interstitial_Unit_ID];
    self.interstitial.delegate = self;
    GADRequest *request = [GADRequest request];
    [self.interstitial loadRequest:request];

}

#pragma mark - GADNativeContentAdLoaderDelegate
- (void)adLoader:(GADAdLoader *)adLoader didReceiveNativeContentAd:(GADNativeContentAd *)nativeContentAd
{
    // Create and place ad in view hierarchy.
    self.contentAdView =
    [[[NSBundle mainBundle] loadNibNamed:@"NativeContentAdView"
                                   owner:nil
                                 options:nil] firstObject];
    self.contentAdView.frame = _adUIView.frame;
    [self.view addSubview:self.contentAdView];

    // Associate the content ad view with the content ad object. This is required to make the ad
    // clickable.
    self.contentAdView.nativeContentAd = nativeContentAd;

    // Populate the content ad view with the content ad assets.
    // Some assets are guaranteed to be present in every content ad.
    // Headline and body will have default value "Sponsor" and "Description" when ad don't have these fields, feel free to customized these value
    ((UILabel *)self.contentAdView.headlineView).text = ([nativeContentAd.headline isEqualToString:@"Sponsor"]) ? @"" : nativeContentAd.headline;
    ((UILabel *)self.contentAdView.bodyView).text = ([nativeContentAd.body isEqualToString:@"Description"]) ? @"" : nativeContentAd.body;
    ((UIImageView *)self.contentAdView.imageView).image =
    ((GADNativeAdImage *)[nativeContentAd.images firstObject]).image;
    ((UILabel *)self.contentAdView.advertiserView).text = nativeContentAd.advertiser;
    [((UIButton *)self.contentAdView.callToActionView)setTitle:nativeContentAd.callToAction
                                                      forState:UIControlStateNormal];

    // Other assets are not, however, and should be checked first.
    if (nativeContentAd.logo && nativeContentAd.logo.image) {
        ((UIImageView *)self.contentAdView.logoView).image = nativeContentAd.logo.image;
        self.contentAdView.logoView.hidden = NO;
    } else {
        self.contentAdView.logoView.hidden = YES;
    }

    // In order for the SDK to process touch events properly, user interaction should be disabled on
    // all views associated with the GADNativeContentAdView. Since UIButton has userInteractionEnabled
    // set to YES by default, views of this type must explicitly set userInteractionEnabled to NO.
    self.contentAdView.callToActionView.userInteractionEnabled = NO;
}

- (void)adLoader:(GADAdLoader *)adLoader didFailToReceiveAdWithError:(GADRequestError *)error
{
    NSLog(@"adLoader:didFailToReceiveAdWithError, error: %@", error);
}

#pragma mark - GADBannerViewDelegate
- (void)adViewDidReceiveAd:(GADBannerView *)bannerView
{
    self.bannerView.frame = CGRectMake((UIScreen.mainScreen.bounds.size.width - bannerView.frame.size.width) / 2, _rectOriginal.origin.y + _adUIView.frame.origin.y, bannerView.frame.size.width, bannerView.frame.size.height);
    [self.view addSubview:self.bannerView];
    NSLog(@"AdMob: Banner ad did load");
}

- (void)adView:(GADBannerView *)bannerView didFailToReceiveAdWithError:(GADRequestError *)error
{
    NSLog(@"adView:didFailToReceiveAdWithError: %@", [error localizedDescription]);
}

#pragma mark - GADRewardBasedVideoAdDelegate

- (void)rewardBasedVideoAd:(GADRewardBasedVideoAd *)rewardBasedVideoAd
   didRewardUserWithReward:(GADAdReward *)reward {
    NSString *rewardMessage =
    [NSString stringWithFormat:@"Reward received with currency %@ , amount %lf",
     reward.type,
     [reward.amount doubleValue]];
    NSLog(@"%@", rewardMessage);
}

- (void)rewardBasedVideoAdDidReceiveAd:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
    NSLog(@"Reward based video ad is received.");
    if ([[GADRewardBasedVideoAd sharedInstance] isReady]) {
        [[GADRewardBasedVideoAd sharedInstance] presentFromRootViewController:self];
    }
}

- (void)rewardBasedVideoAdDidOpen:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
    NSLog(@"Opened reward based video ad.");
}

- (void)rewardBasedVideoAdDidStartPlaying:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
    NSLog(@"Reward based video ad started playing.");
}

- (void)rewardBasedVideoAdDidClose:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
    NSLog(@"Reward based video ad is closed.");
}

- (void)rewardBasedVideoAdWillLeaveApplication:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
    NSLog(@"Reward based video ad will leave application.");
}

- (void)rewardBasedVideoAd:(GADRewardBasedVideoAd *)rewardBasedVideoAd
    didFailToLoadWithError:(NSError *)error {
    NSLog(@"Reward based video ad failed to load.");
}

#pragma mark - GADInterstitialDelegate
/// Tells the delegate an ad request succeeded.
- (void)interstitialDidReceiveAd:(GADInterstitial *)ad
{
    if (ad.isReady) {
        [ad presentFromRootViewController:self];
    }
}

/// Tells the delegate an ad request failed.
- (void)interstitial:(GADInterstitial *)ad didFailToReceiveAdWithError:(GADRequestError *)error
{
    NSLog(@"interstitial:didFailToReceiveAdWithError: %@", [error localizedDescription]);
}

/// Tells the delegate that an interstitial will be presented.
- (void)interstitialWillPresentScreen:(GADInterstitial *)ad {
    NSLog(@"interstitialWillPresentScreen");
}

/// Tells the delegate the interstitial is to be animated off the screen.
- (void)interstitialWillDismissScreen:(GADInterstitial *)ad {
    NSLog(@"interstitialWillDismissScreen");
}

/// Tells the delegate the interstitial had been animated off the screen.
- (void)interstitialDidDismissScreen:(GADInterstitial *)ad {
    NSLog(@"interstitialDidDismissScreen");
}

/// Tells the delegate that a user click will open another app
/// (such as the App Store), backgrounding the current app.
- (void)interstitialWillLeaveApplication:(GADInterstitial *)ad {
    NSLog(@"interstitialWillLeaveApplication");
}
@end
