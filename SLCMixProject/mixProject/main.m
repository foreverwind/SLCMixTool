//
//  main.m
//  mixProject
//
//  Created by 魏昆超 on 2018/7/9.
//  Copyright © 2018年 WeiKunChao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SLCMixManager.h"


int main(int argc, const char * argv[]) {
    @autoreleasepool {
        SLCMixManager *mix = [SLCMixManager shared];
//        mix.fileHeader = @"SQZ"; //header
//        mix.fileName = @"QuizProject"; //文件夹名称
//        mix.fileNum = 150; //文件个数
        [mix fire];
    }
    return 0;
}
