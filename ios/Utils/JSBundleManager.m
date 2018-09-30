//
//  DownloadManager.m
//  DynamicJSBundleNativeCode
//
//  Created by 于弘达 on 2018/9/30.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <React/RCTBundleURLProvider.h>
#import "JSBundleManager.h"
#import "SLFileManager.h"
#import "SLNetworkManager.h"
#import <CommonCrypto/CommonDigest.h>
#import <React/RCTRootView.h>
#import <React/RCTBridge.h>

@implementation NSObject (JSBundleManager)

- (NSString *)JSBundlePath {
  NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
  NSString *bundlePath = [docPath stringByAppendingPathComponent:@"JSBundle"];
  
  if(![SLFileManager isFileExistAtPath:bundlePath]) {
    NSError *error = nil;
    [SLFileManager createDirectory:@"JSBundle" inDirectory:docPath error:&error];
  }
  return bundlePath;
}

- (NSString *)pathForCodeInDocumentsDirectory {
  NSString *fileName = [@"index.ios" stringByAppendingPathExtension:@"jsbundle"];
  
  NSString *filePath = [[self JSBundlePath] stringByAppendingPathComponent:fileName];
  return filePath;
}

- (NSURL *)URLForCodeInDocumentsDirectory {
  return [NSURL fileURLWithPath:[self pathForCodeInDocumentsDirectory]];
}

- (BOOL)copyBundleFileToURL:(NSURL *)url {
  NSURL *bundleFileURL = [[NSBundle mainBundle] URLForResource:@"index.ios" withExtension:@"jsbundle"];
  return [SLFileManager copyFileAtURL:bundleFileURL toURL:url];
}

- (NSURL *)URLForCodeInBundle {
  return [[NSBundle mainBundle] URLForResource:@"index.ios" withExtension:@"jsbundle"];
}

- (RCTBridge *)createBridgeWithBundleURL:(NSURL *)bundleURL {
  return [[RCTBridge alloc] initWithBundleURL:bundleURL moduleProvider:nil launchOptions:nil];
}

- (RCTRootView *)createRootViewWithModuleName:(NSString *)moduleName
                                       bridge:(RCTBridge *)bridge {
  return [[RCTRootView alloc] initWithBridge:bridge moduleName:moduleName initialProperties:nil];
}

- (BOOL)hasCodeInDocumentsDirectory {
  return [SLFileManager isFileExistAtPath:[self pathForCodeInDocumentsDirectory]];
}

- (BOOL)resetJSBundlePath {
  [SLFileManager deleteFileWithPath:[self JSBundlePath] error:nil];
  
  BOOL(^createBundle)(BOOL) = ^(BOOL retry) {
    NSError *error;
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    [SLFileManager createDirectory:@"JSBundle" inDirectory:docPath error:&error];
    if (error) {
      if (retry) {
        createBundle(NO);
      } else {
        return NO;
      }
    }
    
    return YES;
  };
  return createBundle(YES);
}

- (RCTRootView *)getRootViewModuleName:(NSString *)moduleName
                         launchOptions:(NSDictionary *)launchOptions {
  NSURL *jsCodeLocation = nil;
  RCTRootView *rootView = nil;
//#if DEBUG
//#if TARGET_OS_SIMULATOR
//  //debug simulator
////  jsCodeLocation = [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:@"index.ios" fallbackResource:nil];
//  jsCodeLocation = [NSURL URLWithString:@"http://localhost:8081/index.bundle?platform=ios&dev=true"];
//#else
//  //debug device
////  NSString *serverIP = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"SERVER_IP"];
////  NSString *jsCodeUrlString = [NSString stringWithFormat:@"http://%@:8081/index.ios.bundle?platform=ios&dev=true", serverIP];
////  NSString *jsBundleUrlString = [jsCodeUrlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
////  jsCodeLocation = [NSURL URLWithString:jsBundleUrlString];
//#endif
//  rootView = [[RCTRootView alloc] initWithBundleURL:jsCodeLocation
//                                         moduleName:@"DynamicJSBundleNativeCode"
//                                  initialProperties:nil
//                                      launchOptions:launchOptions];
//
//#else
//  //production
//  jsCodeLocation = [self URLForCodeInDocumentsDirectory];
//  if (![self hasCodeInDocumentsDirectory]) {
//    [self resetJSBundlePath];
//
//    BOOL copyResult = [self copyBundleFileToURL:jsCodeLocation];
//    if (!copyResult) {
//      jsCodeLocation = [self URLForCodeInBundle];
//    }
//  }
//  RCTBridge *bridge = [self createBridgeWithBundleURL:jsCodeLocation];
//  rootView = [self createRootViewWithModuleName:moduleName bridge:bridge];
//
//#endif
  jsCodeLocation = [self URLForCodeInDocumentsDirectory];
  if (![self hasCodeInDocumentsDirectory]) {
    [self resetJSBundlePath];
    
    BOOL copyResult = [self copyBundleFileToURL:jsCodeLocation];
    if (!copyResult) {
      jsCodeLocation = [self URLForCodeInBundle];
    }
  }
  RCTBridge *bridge = [self createBridgeWithBundleURL:jsCodeLocation];
  rootView = [self createRootViewWithModuleName:moduleName bridge:bridge];
  
  return rootView;
}

- (void)downloadJSBundle:(NSString *)srcURLString
toURL:(NSURL *)dstURL
completeHandler:(CompletionBlock)complete {
  
  [SLNetworkManager sendWithRequestMethor:(RequestMethodGET) URLString:srcURLString parameters:nil error:nil completionHandler:^(NSData *data, NSURLResponse *response, NSError *connectionError) {
    if (connectionError) {
      return;
    }
    
    NSError *error = nil;
    [data writeToURL:dstURL options:(NSDataWritingAtomic) error:&error];
    if (error) {
      !complete ?: complete(NO);
      [SLFileManager deleteFileWithURL:dstURL error:nil];
    } else {
      !complete ?: complete(YES);
    }
  }];
}

@end
