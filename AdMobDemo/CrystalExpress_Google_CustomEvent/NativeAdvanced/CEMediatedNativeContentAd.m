//  Minimum support Intowow SDK 3.17.0
//
//  CEMediatedNativeContentAd.m
//
//  Copyright © 2017 intowow. All rights reserved.
//

#import "CEMediatedNativeContentAd.h"

//The default value for Headline, Body and Call_to_action field
#define TITLE_DEFAULT_VALUE @"Sponsor"
#define DESCRIPTION_DEFAULT_VALUE @"Description"
#define CTA_DEFAULT_VALUE @"Learn More"

@interface CEMediatedNativeContentAd () <GADMediatedNativeAdDelegate>
@property(nonatomic, strong) CENativeImageAd *ceNativeImageAd;
@property(nonatomic, strong) GADNativeAdImage *mappedLogo;
@property(nonatomic, copy) NSArray *mappedImages;
@end

@implementation CEMediatedNativeContentAd

- (instancetype) initWithCENativeAd:(CENativeImageAd *)ceNativeImageAd
{
    if (!ceNativeImageAd) {
        return nil;
    }

    self = [super init];
    if (self) {
        _ceNativeImageAd = ceNativeImageAd;

        UIImage *iconImage = [[UIImage alloc] initWithContentsOfFile:_ceNativeImageAd.icon.url.path];
        _mappedLogo = [[GADNativeAdImage alloc] initWithImage:iconImage];

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
    return (self.ceNativeImageAd.title) ? : TITLE_DEFAULT_VALUE;
}

- (NSString *)body
{
    return (self.ceNativeImageAd.body) ? : DESCRIPTION_DEFAULT_VALUE;
}

- (NSArray *)images
{
    return self.mappedImages;
}

- (GADNativeAdImage *)logo
{
    return self.mappedLogo;
}

- (NSString *)callToAction
{
    return (self.ceNativeImageAd.callToAction) ? : CTA_DEFAULT_VALUE;
}

- (NSString *)advertiser
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
