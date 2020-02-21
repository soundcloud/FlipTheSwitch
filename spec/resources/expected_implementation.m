/* AUTO-GENERATED. DO NOT ALTER */
#import "FTSFlipTheSwitch+Features.h"

@implementation FTSFlipTheSwitch (Features)

+ (BOOL)isFirstFeatureEnabled
{
    return [[FTSFlipTheSwitch sharedInstance] isFeatureEnabled:[self firstFeatureKey]];
}

+ (void)enableFirstFeature
{
    [[FTSFlipTheSwitch sharedInstance] enableFeature:[self firstFeatureKey]];
}

+ (void)disableFirstFeature
{
    [[FTSFlipTheSwitch sharedInstance] disableFeature:[self firstFeatureKey]];
}

+ (void)setFirstFeatureEnabled:(BOOL)enabled
{
    [[FTSFlipTheSwitch sharedInstance] setFeature:[self firstFeatureKey] enabled:enabled];
}

+ (void)resetFirstFeature
{
    [[FTSFlipTheSwitch sharedInstance] resetFeature:[self firstFeatureKey]];
}

+ (NSString *)firstFeatureKey
{
    return @"first_feature";
}

+ (void)resetAll
{
    [self resetFirstFeature];
}

@end
