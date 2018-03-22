//  Minimum support Intowow SDK 3.26.1
//
//  CECustomEventNative.m
//
//  Copyright © 2017 intowow. All rights reserved.
//

#import "CECustomEventNative.h"
#import "CEMediatedNativeContentAd.h"
#import "CENativeImageAd.h"

#define LoadAdTimeout 10
#define ERROR_DOMAIN @"com.intowow.CrystalExpress"

@interface CECustomEventNative () <CENativeImageAdDelegate>

@property (nonatomic, strong) CENativeImageAd * ceNativeImageAd;

@end

@implementation CECustomEventNative

@synthesize delegate;

- (void)requestNativeAdWithParameter:(NSString *)serverParameter
                             request:(GADCustomEventRequest *)request
                             adTypes:(NSArray *)adTypes
                             options:(NSArray *)options
                  rootViewController:(UIViewController *)rootViewController
{
    NSString *placement = serverParameter;

    if (placement == nil || [placement isEqualToString:@""]) {
        NSError *error = [NSError errorWithDomain:ERROR_DOMAIN code:kGADErrorInvalidArgument userInfo:nil];
        [self.delegate customEventNativeAd:self didFailToLoadWithError:error];
        return;
    }

    CERequestInfo *info = [CERequestInfo new];
    info.placement = placement;
    info.timeout = LoadAdTimeout;
    self.ceNativeImageAd = [[CENativeImageAd alloc] init];
    [self.ceNativeImageAd setDelegate:self];
    [self.ceNativeImageAd loadAdWithInfo:info];
}

- (BOOL)handlesUserClicks {
    return YES;
}

- (BOOL)handlesUserImpressions {
    return NO;
}

#pragma mark - CENativeAdDelegate
- (void) nativeImageAdDidLoad:(CENativeImageAd *)nativeImageAd
{
    CEMediatedNativeContentAd *mediatedAd = [[CEMediatedNativeContentAd alloc] initWithCENativeAd:nativeImageAd];
    if (mediatedAd == nil) {
        NSError *error = [NSError errorWithDomain:ERROR_DOMAIN code:kGADErrorReceivedInvalidResponse userInfo:nil];
        [self.delegate customEventNativeAd:self didFailToLoadWithError:error];
    } else {
        [self.delegate customEventNativeAd:self didReceiveMediatedNativeAd: mediatedAd];
    }
}

- (void)nativeImageAd:(CENativeImageAd *)nativeImageAd didFailWithError:(NSError *)error
{
    NSError *err = [NSError errorWithDomain:ERROR_DOMAIN code:error.code userInfo:nil];
    [self.delegate customEventNativeAd:self didFailToLoadWithError:err];
}
@end
