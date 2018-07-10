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

- (void)fire;

@end
