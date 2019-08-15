//
//  DemoRouter.m
//  iOSWithFlutterBoost
//
//  Created by 搞得赢 on 2019/8/15.
//  Copyright © 2019 德赢. All rights reserved.
//

#import "DemoRouter.h"
#import <flutter_boost/FLBFlutterViewContainer.h>

@implementation DemoRouter

+ (DemoRouter *)sharedRouter
{
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)openPage:(NSString *)name params:(NSDictionary *)params animated:(BOOL)animated completion:(void (^)(BOOL))completion
{
    if ([params[@"present"] boolValue]) {
        FLBFlutterViewContainer *vc = FLBFlutterViewContainer.new;
        [vc setName:name params:params];
        [self.navigationController presentViewController:vc animated:YES completion:^{
            
        }];
    } else {
        FLBFlutterViewContainer *vc = FLBFlutterViewContainer.new;
        [vc setName:name params:params];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)closePage:(NSString *)uid animated:(BOOL)animated params:(NSDictionary *)params completion:(void (^)(BOOL))completion
{
    FLBFlutterViewContainer *vc = (id)self.navigationController.presentedViewController;
    if ([vc isKindOfClass:FLBFlutterViewContainer.class] && [vc.uniqueIDString isEqualToString:uid]) {
        [vc dismissViewControllerAnimated:YES completion:^{
            
        }];
    } else {
        [self.navigationController popViewControllerAnimated:animated];
    }
}

- (BOOL)accessibilityEnable
{
    return YES;
}

- (void)flutterCanPop:(BOOL)canpop {
    self.navigationController.interactivePopGestureRecognizer.enabled = !canpop;
}


@end
