//
//  ViewController.m
//  iOSWithFlutterSingleVC
//
//  Created by 搞得赢 on 2019/8/5.
//  Copyright © 2019 德赢工作室. All rights reserved.
//

#import "ViewController.h"
#import <Flutter/Flutter.h>
#import "AppDelegate.h"
#import <Flutter/FlutterViewController.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)clickedToFlutter:(UIButton *)sender {
    FlutterEngine *flutterEngine = [(AppDelegate *)[[UIApplication sharedApplication] delegate] flutterEngine];
    FlutterViewController *flutterVC = [[FlutterViewController alloc] initWithEngine:flutterEngine nibName:nil bundle:nil];
    [self.navigationController pushViewController:flutterVC animated:YES];
}

@end
