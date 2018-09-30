/**
 * Copyright (c) 2015-present, Facebook, Inc.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "AppDelegate.h"
#import <React/RCTBundleURLProvider.h>
#import <React/RCTRootView.h>
#import "JSBundleManager.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newJSBundleVersion:) name:@"NewJSBundleVersion" object:@"versionObject"];

  NSURL *jsCodeLocation;

//  jsCodeLocation = [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:@"index.ios" fallbackResource:nil];
//  jsCodeLocation= [[NSBundle mainBundle] URLForResource:@"index.ios" withExtension:@"jsbundle"];
//  jsCodeLocation = [NSURL URLWithString:@"http://localhost:8081/ios/DynamicJSBundleNativeCode/index.ios.jsbundle?platform=ios&dev=true"];
  RCTRootView *rootView = [self getRootViewModuleName:@"DynamicJSBundleNativeCode" launchOptions:launchOptions];
  rootView.backgroundColor = [[UIColor alloc] initWithRed:1.0f green:1.0f blue:1.0f alpha:1];

  self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
  UIViewController *rootViewController = [UIViewController new];
  rootViewController.view = rootView;
  self.window.rootViewController = rootViewController;
  [self.window makeKeyAndVisible];
  return YES;
}

- (void)newJSBundleVersion:(NSNotification *)notification {
  NSDictionary *userInfo = notification.userInfo;
  NSString *version = [userInfo objectForKey:@"version"];
  NSString *base = [@"http://manalife.cn/jsbundle/" stringByAppendingString:version];
  NSString *uRLStr = [base stringByAppendingString:@"/index.ios.jsbundle"];
  NSURL *dstURL = [self URLForCodeInDocumentsDirectory];
  // download jsbundle
  [self downloadJSBundle:uRLStr toURL:dstURL completeHandler:^(BOOL result) {
    NSLog(@"finish: %@", @(result));
  }];
}

@end
