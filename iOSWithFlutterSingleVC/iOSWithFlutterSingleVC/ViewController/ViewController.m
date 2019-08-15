//
//  ViewController.m
//  iOSWithFlutterSingleVC
//
//  Created by 搞得赢 on 2019/8/5.
//  Copyright © 2019 德赢工作室. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import <Flutter/FlutterViewController.h>
#import <FlutterPluginRegistrant/GeneratedPluginRegistrant.h>
#import "SecondFlutterPage.h"
#import <Flutter/Flutter.h>

@interface ViewController ()


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)clickedToFlutter:(UIButton *)sender {
    
    FlutterViewController *firstFlutterPage = [[FlutterViewController alloc] init];
    [firstFlutterPage setInitialRoute:@"/FirstFlutterPage"];
    [firstFlutterPage setTitle:@"FirstFlutterPage"];
    [self.navigationController pushViewController:firstFlutterPage animated:YES];
    
}

- (IBAction)clickedToFlutter2:(id)sender {

    SecondFlutterPage *secondFlutterPage = [[SecondFlutterPage alloc] init];
    [secondFlutterPage setInitialRoute:@"/"];
    [self.navigationController pushViewController:secondFlutterPage animated:YES];
}


@end
