//  Minimum support Intowow SDK 3.26.1
//
//  CEMediatedNativeAppInstallAd.m
//
//  Copyright © 2017 intowow. All rights reserved.
//

#import "CEMediatedNativeAppInstallAd.h"

@interface CEMediatedNativeAppInstallAd () <GADMediatedNativeAdDelegate>
@property(nonatomic, strong) CENativeImageAd *ceNativeImageAd;
@property(nonatomic, strong) GADNativeAdImage *mappedIcon;
@property(nonatomic, copy) NSArray *mappedImages;
@end

@implementation CEMediatedNativeAppInstallAd

- (instancetype)initWithCENativeAd:(CENativeImageAd *)ceNativeImageAd
{
    if (!ceNativeImageAd) {
        return nil;
    }

    self = [super init];
    if (self) {
        _ceNativeImageAd = ceNativeImageAd;

        UIImage *iconImage = [[UIImage alloc] initWithContentsOfFile:_ceNativeImageAd.icon.url.path];
        _mappedIcon = [[GADNativeAdImage alloc] initWithImage:iconImage];

        if (self.ceNativeImageAd.adImagePath == nil || [self.ceNativeImageAd.adImagePath isEqualToString:@""]) {
            return nil;
        }
        UIImage *image = [[UIImage alloc] initWithContentsOfFile:self.ceNativeImageAd.adImagePath];
        _mappedImages = @[ [[GADNativeAdImage alloc] initWithImage:image] ];
    }
    return self;
}

- (NSString *)headline
{
    return self.ceNativeImageAd.title;
}

- (NSArray *)images
{
    return self.mappedImages;
}

- (NSString *)body
{
    return self.ceNativeImageAd.body;
}

- (GADNativeAdImage *)icon
{
    return self.mappedIcon;
}

- (NSString *)callToAction
{
    return self.ceNativeImageAd.callToAction;
}

- (NSDecimalNumber *)starRating
{
    return 0;
}

- (NSString *)store
{
    return @"";
}

- (NSString *)price
{
    return @"";
}

- (NSDictionary *)extraAssets
{
    return nil;
}

- (id<GADMediatedNativeAdDelegate>)mediatedNativeAdDelegate
{
    return self;
}

#pragma mark - GADMediatedNativeAdDelegate
- (void)mediatedNativeAd:(id<GADMediatedNativeAd>)mediatedNativeAd
         didRenderInView:(UIView *)view
          viewController:(UIViewController *)viewController
{
    [self.ceNativeImageAd handleDidRenderWithContainerView:view];
    [self.ceNativeImageAd registerViewForInteraction:view
                                  withViewController:viewController
                                  withClickableViews:@[view]];
}

- (void)mediatedNativeAdDidRecordImpression:(id<GADMediatedNativeAd>)mediatedNativeAd
{
    [self.ceNativeImageAd handleImpression];
}

@end
