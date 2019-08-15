//
//  FirstFlutterPage.m
//  iOSWithFlutterSingleVC
//
//  Created by 搞得赢 on 2019/8/6.
//  Copyright © 2019 . All rights reserved.
//

#import "SecondFlutterPage.h"
#import <Flutter/Flutter.h>
#import <FlutterPluginRegistrant/GeneratedPluginRegistrant.h>

@interface SecondFlutterPage ()<FlutterStreamHandler>

@property (nonatomic) FlutterBasicMessageChannel* messageChannel;
@property (nonatomic) FlutterEventChannel* eventChannel;
@property (nonatomic) FlutterMethodChannel* methodChannel;

@property (nonatomic) FlutterEventSink eventSink;

@property (nonatomic, strong) UILabel *flutterVersionLabel;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) int i;

@property (nonatomic, strong) UITextField *sendMessageTF;

@property (nonatomic, strong) UILabel *receiveMessageLabel;

@property (nonatomic, strong) UILabel *eventSendLabel;

@end

@implementation SecondFlutterPage

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpView];
    [self initChannel];
}

#pragma mark - Init channel
- (void)initChannel{
    [self initMessageChannel];
    [self initMethodChannel];
    [self initEventChannel];
}

- (void)initMessageChannel {
    self.messageChannel = [FlutterBasicMessageChannel messageChannelWithName:@"BasicMessageChannelPlugin" binaryMessenger:self codec:[FlutterStringCodec sharedInstance]];
    __weak typeof(self) weakSelf = self;
    [self.messageChannel setMessageHandler:^(NSString* message, FlutterReply reply) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.receiveMessageLabel setText:message];
        reply([NSString stringWithFormat:@"iOS收到：%@",message]);
    }];
}

- (void)initMethodChannel {
    self.methodChannel = [FlutterMethodChannel methodChannelWithName:@"MethodChannelPlugin" binaryMessenger:self];
    __weak typeof(self) weakSelf = self;
    [self.methodChannel setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if ([@"getSystemVerison" isEqualToString:call.method]) {
            NSString *systemVersion = [strongSelf getSystemVersionFromFlutter];
            result(systemVersion);
        } else {
            result(FlutterMethodNotImplemented);
        }
    }];
}

- (void)initEventChannel {
    self.eventChannel = [FlutterEventChannel eventChannelWithName:@"EventChannelPlugin" binaryMessenger:self];
    [self.eventChannel setStreamHandler:self];
}

#pragma mark - Message Channel
- (void)sendMessageByMessageChannel {
    [self.messageChannel sendMessage:self.sendMessageTF.text reply:^(id  _Nullable reply) {
        
    }];
}

#pragma mark - Method Channel
- (void)getFlutterVersionToFlutter {
    [self.methodChannel invokeMethod:@"getFlutterVersion" arguments:@[@"Methond Channel: From iOS To Flutter, getFlutterVersion"] result:^(id  _Nullable result) {
        [self.flutterVersionLabel setText:result];
    }];
}

#pragma mark - Event Channel FlutterStreamHandler
- (FlutterError* _Nullable)onListenWithArguments:(id _Nullable)arguments eventSink:(FlutterEventSink)eventSink {
    self.eventSink = eventSink;
    
    self.i = 1;
    if (@available(iOS 10.0, *)) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(sendEventChannelMessageToFlutter) userInfo:nil repeats:YES];
        [self.timer fire];
    } else {
        
    }
    return nil;
}

- (FlutterError* _Nullable)onCancelWithArguments:(id _Nullable)arguments {
    self.eventSink = nil;
    return nil;
}

- (void)sendEventChannelMessageToFlutter {
    if (!self.eventSink) return;
    NSString *str = [NSString stringWithFormat:@"%d", self.i++];
    [self.eventSendLabel setText:str];
    self.eventSink(str);
}

#pragma mark - SetUp Views
- (void)setUpView
{
    [self setInitialRoute:@"/"];
    [self.navigationItem setTitle:@"Flutter Page"];
    UITabBarItem *tabbarButton = [[UITabBarItem alloc] initWithTitle:@"Flutter Page" image:nil tag:9999];
    [self setTabBarItem:tabbarButton];
    UIView *nativeV = [[UIView alloc] initWithFrame:CGRectMake(10, 64+20+60, [UIScreen mainScreen].bounds.size.width-20, 230)];
    [nativeV setBackgroundColor:[UIColor blueColor]];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
    [titleLabel setTextColor:[UIColor yellowColor]];
    [titleLabel setText:@"iOS"];
    [nativeV addSubview:titleLabel];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setFrame:CGRectMake(10, 30, 150, 30)];
    [btn setTitle:@"MC获取Flutter版本: " forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor lightGrayColor];
    [btn addTarget:self action:@selector(getFlutterVersionToFlutter) forControlEvents:UIControlEventTouchUpInside];
    [nativeV addSubview:btn];
    
    self.flutterVersionLabel = [[UILabel alloc] initWithFrame:CGRectMake(150 + 20, 30, 215, 30)];
    [self.flutterVersionLabel setText:@"NO FlutterVerison"];
    [self.flutterVersionLabel setTextAlignment:NSTextAlignmentCenter];
    [self.flutterVersionLabel setTextColor:[UIColor yellowColor]];
    [nativeV addSubview:self.flutterVersionLabel];
    
    UIButton *chatSendBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [chatSendBtn setFrame:CGRectMake(10, 80, 150, 30)];
    [chatSendBtn setTitle:@"MessageC发送信息: " forState:UIControlStateNormal];
    [chatSendBtn setBackgroundColor:[UIColor lightGrayColor]];
    [chatSendBtn addTarget:self action:@selector(sendMessageByMessageChannel) forControlEvents:UIControlEventTouchUpInside];
    [nativeV addSubview:chatSendBtn];
    
    self.sendMessageTF = [[UITextField alloc] initWithFrame:CGRectMake(150 + 20, 80, 215, 30)];
    [nativeV addSubview:self.sendMessageTF];
    [self.sendMessageTF setBackgroundColor:[UIColor whiteColor]];
    [self.sendMessageTF setTextColor:[UIColor blueColor]];
    
    UIButton *chatReceiveBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [chatReceiveBtn setFrame:CGRectMake(10, 130, 150, 30)];
    [chatReceiveBtn setTitle:@"MessageC收到信息: " forState:UIControlStateNormal];
    [chatReceiveBtn setBackgroundColor:[UIColor lightGrayColor]];
    [nativeV addSubview:chatReceiveBtn];
    
    self.receiveMessageLabel = [[UILabel alloc] initWithFrame:CGRectMake(150 + 20, 130, 215, 30)];
    [self.receiveMessageLabel setText:@"NO ReceiveMessage"];
    [self.receiveMessageLabel setTextAlignment:NSTextAlignmentCenter];
    [self.receiveMessageLabel setTextColor:[UIColor yellowColor]];
    [nativeV addSubview:self.receiveMessageLabel];
    
    UIButton *eventSendBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [eventSendBtn setFrame:CGRectMake(10, 180, 150, 30)];
    [eventSendBtn setTitle:@"EventC发送: " forState:UIControlStateNormal];
    [eventSendBtn setBackgroundColor:[UIColor lightGrayColor]];
    [nativeV addSubview:eventSendBtn];
    
    self.eventSendLabel = [[UILabel alloc] initWithFrame:CGRectMake(150 + 20, 180, 215, 30)];
    [self.eventSendLabel setText:@"NO ReceiveMessage"];
    [self.eventSendLabel setTextAlignment:NSTextAlignmentCenter];
    [self.eventSendLabel setTextColor:[UIColor yellowColor]];
    [nativeV addSubview:self.eventSendLabel];
    
    [self.view addSubview:nativeV];
    [self.view bringSubviewToFront:nativeV];
}


#pragma mark - Private Method
- (NSString *)getSystemVersionFromFlutter {
    UIDevice *device = UIDevice.currentDevice;
    return device.systemVersion;
}


@end
