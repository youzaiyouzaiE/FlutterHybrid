//
//  SecondNativePage.m
//  iOSWithFlutterSingleVC
//
//  Created by 搞得赢 on 2019/8/5.
//  Copyright © 2019 德赢工作室. All rights reserved.
//

#import "SecondNativePage.h"
#import <FlutterPluginRegistrant/GeneratedPluginRegistrant.h>
#import <Flutter/Flutter.h>

@interface SecondNativePage ()

@end

@implementation SecondNativePage

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (IBAction)clickedToFlutter:(id)sender {
//    FlutterEngine *engine = [[FlutterEngine alloc] initWithName:@"Flutter.io" project:nil];
//    [engine runWithEntrypoint:nil];
    
    FlutterViewController *thirdFlutterPage = [[FlutterViewController alloc] init];
    [self.navigationController pushViewController:thirdFlutterPage animated:YES];
    
}


@end
