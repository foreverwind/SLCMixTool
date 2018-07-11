//
//  SLCMixManager.h
//  mixProject
//
//  Created by 魏昆超 on 2018/7/9.
//  Copyright © 2018年 WeiKunChao. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef GCD_Async_Serial
#define GCD_Async_Serial(block)\
dispatch_async(dispatch_queue_create("com.slc.queue", DISPATCH_QUEUE_SERIAL),block);
#endif

#ifndef GCD_Semaphore
#define GCD_Semaphore(num)\
dispatch_semaphore_create(num);
#endif

#ifndef GCD_Lock
#define GCD_Lock(lock)\
dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
#endif

#ifndef GCD_Unlock
#define GCD_Unlock(lock)\
dispatch_semaphore_signal(lock);
#endif

@interface SLCMixManager : NSObject

#pragma mark ---<只对fireOnBorn有效>---
/**header字符串 -默认SLC*/
@property (nonatomic, copy) NSString * fileHeader;
/**body字符串 - 不给随机*/
@property (nonatomic, copy) NSString * mixedBody;
/**尾部统一字符串 - 不给随机*/
@property (nonatomic, copy) NSString * tailS;
/**文件夹名称 - 默认mixedProject*/
@property (nonatomic, copy) NSString * fileName;
/**目的路径 - 默认桌面*/
@property (nonatomic, copy) NSString * fullPath;
/**多少组文件 - 默认120*/
@property (nonatomic, assign) NSInteger fileNum;

#pragma mark ---<只对fireOnChild有效>---

/**
 * 默认不处理包含@".xcassets"、@".xcworkspace"、@".xcodeproj"、@".framework"、@".lproj"、@"main"、@"AppDelegate"、@".plist"、@".json"、@".zip"、@".storyboard"、@"Podfile"、@"Pods"、@".zip"、@"README"、@".git"、 @".gitignore"、@".DS_Store"、@".png"、@".jpg"、@".data"、@".bin"、@".mko"、@".txt"、@".mp4"、@".pch"、@".mov" 如有其它可更改和添加.
 */

/**文件路径*/
@property (nonatomic, copy) NSString * childFullPath;
/**需要生成的方法个数 - 不指定随机(1 - 6)*/
@property (nonatomic, assign) NSUInteger childMethodNum;
/**距离最末端@end位置处添加 - 一个数代表一个字母 - 不设置默认在最结尾处*/
@property (nonatomic, assign) NSUInteger childTailPosition;
/**指定的包含某些字符串的特殊类 - 不设不处理*/
@property (nonatomic, strong) NSArray <NSString *>* contaisArray;

#pragma mark ---<调用方法>---

/**生成垃圾文件和函数*/
- (void)fireOnBorn;
/**在已有文件生成垃圾函数*/
- (void)fireOnChild;
@end
