#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [GeneratedPluginRegistrant registerWithRegistry:self];
  // Override point for customization after application launch.

    self.window = [[UIWindow alloc] initWithFrame: [UIScreen mainScreen].bounds];
    UIButton *nativeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nativeButton.frame = CGRectMake(100, 100, 100, 100);
    nativeButton.backgroundColor = [UIColor redColor];
    [nativeButton setTitle:@"push native" forState:UIControlStateNormal];
    [nativeButton addTarget:self action:@selector(pushNative) forControlEvents:UIControlEventTouchUpInside];
    
    FlutterViewController *page = [[FlutterViewController alloc] init];
    [page.view addSubview:nativeButton];
    [page.view bringSubviewToFront:nativeButton];
    
    self.window.rootViewController = page;
    [self.window addSubview:nativeButton];
    [self.window bringSubviewToFront:nativeButton];
    
    
    
    return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

- (void)pushNative {

}

@end
