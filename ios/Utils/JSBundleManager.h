//
//  DownloadManager.h
//  DynamicJSBundleNativeCode
//
//  Created by 于弘达 on 2018/9/30.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RCTRootView;

@interface NSObject (JSBundleManager)

typedef void(^CompletionBlock)(BOOL result);

- (BOOL)resetJSBundlePath;

- (NSURL *)URLForCodeInDocumentsDirectory;

- (RCTRootView *)getRootViewModuleName:(NSString *)moduleName
                         launchOptions:(NSDictionary *)launchOptions;

- (void)downloadJSBundle:(NSString *)srcURLString
    toURL:(NSURL *)dstURL
    completeHandler:(CompletionBlock)complete;

@end
