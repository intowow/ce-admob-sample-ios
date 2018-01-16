//  Minimum support Intowow SDK 3.17.0
//
//  CEMediatedNativeContentAd.h
//
//  Copyright © 2017 intowow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CENativeImageAd.h"

@import GoogleMobileAds;

@interface CEMediatedNativeContentAd : NSObject <GADMediatedNativeContentAd>

- (null_unspecified instancetype)init NS_UNAVAILABLE;

- (nullable instancetype)initWithCENativeAd:(nonnull CENativeImageAd *)ceNativeImageAd NS_DESIGNATED_INITIALIZER;

@end
