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
#import "FirstFlutterPage.h"

@interface ViewController ()

@property(nonatomic, strong) FlutterViewController *flutterPage;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)clickedToFlutter:(UIButton *)sender {
    FlutterEngine *flutterEngine = [(AppDelegate *)[[UIApplication sharedApplication] delegate] flutterEngine];
    self.flutterPage = [[FlutterViewController alloc] initWithEngine:flutterEngine nibName:nil bundle:nil];
    [self.navigationController pushViewController:self.flutterPage animated:YES];
}

- (IBAction)clickedToFlutter2:(id)sender {
    FlutterEngine *flutterEngine = [(AppDelegate *)[[UIApplication sharedApplication] delegate] flutterEngine];
    FirstFlutterPage *ffp = [[FirstFlutterPage alloc] initWithEngine:flutterEngine nibName:nil bundle:nil];
    [self.navigationController pushViewController:ffp animated:YES];
}


- (void)initFlutterRouter
{
    FlutterEngine *flutterEngine = [(AppDelegate *)[[UIApplication sharedApplication] delegate] flutterEngine];
    FlutterViewController *flutterVC = [[FlutterViewController alloc] initWithEngine:flutterEngine nibName:nil bundle:nil];
    [flutterVC setInitialRoute:@"FlutterVC1"];
}


@end
