//
//  NativeNotificationManager.m
//  DynamicJSBundleNativeCode
//
//  Created by 于弘达 on 2018/9/30.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "NotificationManager.h"
#import <React/RCTEventEmitter.h>

@implementation NotificationManager

RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(postNotification:(NSString *)name userInfo: (NSString *)userInfo) {
  NSError *jsonError;
  NSData *webData = [userInfo dataUsingEncoding:NSUTF8StringEncoding];
  NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:webData options:0 error:&jsonError];
  
  [[NSNotificationCenter defaultCenter] postNotificationName:name object:@"versionObject" userInfo:jsonDict];
}

@end

