//
//  DemoRouter.h
//  iOSWithFlutterBoost
//
//  Created by 搞得赢 on 2019/8/15.
//  Copyright © 2019 德赢. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <flutter_boost/FLBPlatform.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DemoRouter : NSObject<FLBPlatform>

@property(nonatomic, strong)UINavigationController *navigationController;

+ (DemoRouter *)sharedRouter;

@end

NS_ASSUME_NONNULL_END
