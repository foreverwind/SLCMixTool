//
//  SLCMixManager.m
//  mixProject
//
//  Created by 魏昆超 on 2018/7/9.
//  Copyright © 2018年 WeiKunChao. All rights reserved.
//

#import "SLCMixManager.h"
#import "SLCDataManager.h"

@interface SLCMixManager()

@property (nonatomic, assign) NSUInteger randomBodyNum; //body随机数
@property (nonatomic, assign) NSUInteger randomTailNum; //tail随机数
@property (nonatomic, copy) NSString *bodyString; //body字符串
@property (nonatomic, copy) NSString * tailString; //tail字符串
@property (nonatomic, copy) NSString *defaultFullPath; //默认全路径 - 桌面

@end

@implementation SLCMixManager

+ (instancetype)shared {
    return [[self alloc] init];
}

- (instancetype)init {
    if (self = [super init]) {
        self.fileNum = 120;
        self.fileName = @"mixProject";
        self.fullPath = [self defaultFullPath];
        self.fileHeader = @"SLC";
    }
    return self;
}

- (void)setFileName:(NSString *)fileName {
    _fileName = fileName;
    self.fullPath = [self defaultFullPath];
}

- (void)fire {
    
    BOOL isCreateDirectory = [self createDirectory];
    dispatch_semaphore_t semaphore = GCD_Semaphore(1);
    if (isCreateDirectory) {
        GCD_Lock(semaphore);
        for (NSInteger i = 0; i < self.fileNum; i ++) { //垃圾文件
            [self createFile];
            GCD_Unlock(semaphore);
        }
        
        [self createBulletsFile];
        NSLog(@"====%ld组文件创建完成",self.fileNum);
    }
}

#pragma mark ---<PrivateMethod>---

- (void)createBulletsFile {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *fileName = [NSString stringWithFormat:@"%@Bullets",self.fileHeader];
    NSString *filePath = [self.fullPath stringByAppendingPathComponent:fileName];
    BOOL isFileExists = [fileManager fileExistsAtPath:[NSString stringWithFormat:@"%@.h",filePath]];
    if (isFileExists) return; //文件已存在,立即停止
    
    NSString *propertyString = @"/**文件夹路径*/\n@property (nonatomic, copy) NSString * fullPath;";
    NSString *methodString = @"+ (instancetype)shared;\n/**调用所有方法 - (模拟调用,fire完所有局部对象会立即被释放)*/\n- (void)fire;";
    NSString *hString = [NSString stringWithFormat:@"\n\n\n\n\n#import <Foundation/Foundation.h>\n\n\n\n@interface %@ : NSObject\n%@\n%@\n@end",fileName,propertyString,methodString]; //.h文件内容
    NSString *mString = [self createBulletsM:fileName methodString:methodString]; //.m文件内容
    
    
    BOOL isCreateH = [fileManager createFileAtPath:[NSString stringWithFormat:@"%@.h",filePath] contents:[hString dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
    if (isCreateH) {
        NSLog(@"%@___文件创建成功!",fileName);
        [fileManager createFileAtPath:[NSString stringWithFormat:@"%@.m",filePath] contents:[mString dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
    }else {
        NSLog(@"%@文件创建失败,重名了!",fileName);
    }
}

- (NSString *)createBulletsM:(NSString *)fileName
                methodString:(NSString *)method {
    NSString *bulletsM = [NSString stringWithFormat:@"\n\n\n\n\n#import \"%@.h\"\n#import <objc/runtime.h>\n@interface %@()\n@property (nonatomic, copy) NSString * homeString;\n@end\n\n\n@implementation %@\n",fileName,fileName,fileName];
    
    NSString *methodShared = @"\n+ (instancetype)shared\n{\n    return [[self alloc] init];\n}\n"; //shared方法
    
    bulletsM = [bulletsM stringByAppendingString:[NSString stringWithFormat:@"%@",methodShared]];
    
    NSString *methodHome = [NSString stringWithFormat:@"\n- (NSString *)homeString {\n    return @\"%@/Desktop/\";\n}\n",NSHomeDirectory()];
    
    bulletsM = [bulletsM stringByAppendingString:[NSString stringWithFormat:@"%@",methodHome]];
    
    NSString *methodFire = @"\n- (void)fire\n{\n    NSFileManager *fileManager = [NSFileManager defaultManager];\n    NSArray *fileList = [fileManager contentsOfDirectoryAtPath:[NSString stringWithFormat:@\"%@/%@\",self.homeString,self.fullPath] error:nil];\n     @autoreleasepool {\n      NSMutableArray *classList = [NSMutableArray array];\n      for (NSString *file in fileList) {\n       if ([file hasSuffix:@\".h\"] && ![file containsString:@\"Bullets\"]) {\n        NSString *className = [self removeLastOneChar:file];\n        [classList addObject:className];\n      }\n}\n      for (NSString *className in classList) {\n       Class aClass = NSClassFromString(className);\n       NSObject *object = [aClass new];\n       NSLog(@\"===生成的对象是%@\",object);\n       [self getAllMethods:aClass];\n     }\n      }\n}\n"; //fire方法
    
     bulletsM = [bulletsM stringByAppendingString:[NSString stringWithFormat:@"%@",methodFire]];
    
    NSString *methodLists = @"\n- (NSArray <NSString *>*)getAllMethods:(id)obj{\n    unsigned int methodCount =0;\n    Method* methodList = class_copyMethodList([obj class],&methodCount);\n    NSMutableArray *methodsArray = [NSMutableArray arrayWithCapacity:methodCount];\n    for(int i = 0; i < methodCount; i++){\n     Method temp = methodList[i];\n     method_getImplementation(temp);\n     method_getName(temp);\nconst char* name_s =sel_getName(method_getName(temp));\n     int arguments = method_getNumberOfArguments(temp);\n     const char* encoding =method_getTypeEncoding(temp);\n     if (![[NSString stringWithUTF8String:name_s] containsString:@\"set\"]) {\n //不要setter\n       NSLog(@\"方法名：%@,参数个数：%d,编码方式：%@\",[NSString stringWithUTF8String:name_s],arguments,[NSString stringWithUTF8String:encoding]);\n       [methodsArray addObject:[NSString stringWithUTF8String:name_s]];\n    }\n     }\n     free(methodList);\n    return methodsArray;\n}\n";
    
    bulletsM = [bulletsM stringByAppendingString:[NSString stringWithFormat:@"%@",methodLists]];
    
    NSString *methodRemove = @"\n- (NSString*)removeLastOneChar:(NSString*)origin{\n    NSString* cutted;\n    if([origin length] > 0){\n     cutted = [origin substringToIndex:([origin length]-2)];\n      }else{\n      cutted = origin;\n     }\n    return cutted;\n}\n";
    
    bulletsM = [bulletsM stringByAppendingString:[NSString stringWithFormat:@"%@",methodRemove]];
    
     bulletsM = [bulletsM stringByAppendingString:@"@end"];
    
    return bulletsM;
}

- (BOOL)createDirectory {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL create = [fileManager createDirectoryAtPath:self.fullPath withIntermediateDirectories:YES attributes:nil error:nil];
    if (create) {
        NSLog(@"%@文件夹创建成功!",self.fullPath.lastPathComponent);
    }else {
        NSLog(@"文件夹创建失败,重名!");
    }
    return create;
}

- (void)createFile {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *file = [NSString stringWithFormat:@"%@%@%@",self.fileHeader,self.bodyString,self.tailString];
    NSString *filePath = [self.fullPath stringByAppendingPathComponent:file];
    
    BOOL isFileExists = [fileManager fileExistsAtPath:[NSString stringWithFormat:@"%@.h",filePath]];
    if (isFileExists) return; //文件已存在,立即停止
    
   __block NSString *hString = [NSString stringWithFormat:@"\n\n\n\n\n#import <Foundation/Foundation.h>\n\n\n\n@interface %@ : NSObject\n%@\n",file,[self randomProperty]]; //.h文件内容
    
    __block NSString *mString = [NSString stringWithFormat:@"\n\n\n\n\n#import \"%@.h\"\n\n\n\n@implementation %@",file,file]; //.m文件内容
    
    void(^handle)(NSArray <NSString *>*methodArray) = ^(NSArray <NSString *>*methodArray){
        
        for (NSString *method in methodArray) {
            hString = [hString stringByAppendingString:[NSString stringWithFormat:@"\n\n%@",method]];
        }
        
        for (NSString *method in methodArray) {
            mString = [mString stringByAppendingString:[NSString stringWithFormat:@"\n\n%@",[self removeLastOneChar:method]]];
            mString = [mString stringByAppendingString:[NSString stringWithFormat:@"\n{\n      for (NSInteger i = 0; i < 3; i++) {\n        NSString *str = @\"func name = %@\";\n        [str stringByAppendingString:@\"time is 3\"];\n       }\n}\n",method]];
        }
    };
    
    [self randomMethod:handle];
    
    
    hString = [hString stringByAppendingString:@"\n@end"];
    BOOL isCreateH = [fileManager createFileAtPath:[NSString stringWithFormat:@"%@.h",filePath] contents:[hString dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
    if (isCreateH) {
        NSLog(@"%@___文件创建成功!",file);
        mString = [mString stringByAppendingString:@"\n@end"];
        [fileManager createFileAtPath:[NSString stringWithFormat:@"%@.m",filePath] contents:[mString dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
    }else {
        NSLog(@"%@文件创建失败,重名了!",file);
    }
}

//随机变量
- (NSString *)randomProperty {
    NSUInteger randomNum = arc4random() % 6;
    if (randomNum == 0) return @"\n";
    NSString *property = @"\n";
    for (NSInteger i = 0; i < randomNum; i ++) {
        if ([property containsString:[self randomPerProperty]]) continue; //如果有,跳过
        property = [NSString stringWithFormat:@"%@\n%@",property,[self randomPerProperty]];
    }
    return property;
}

//随机一个变量
- (NSString *)randomPerProperty {
    NSString *propertyName = [NSString stringWithFormat:@"%@%@",bodyArray()[self.randomBodyNum],[self randomChar]];
    NSArray <NSString *>*propertyArray = @[
                                           @"\n",
                                           [NSString stringWithFormat:@"@property (nonatomic, assign) BOOL %@;",propertyName],
                                           [NSString stringWithFormat:@"@property (nonatomic, assign) NSInteger %@;",propertyName],
                                           [NSString stringWithFormat:@"@property (nonatomic, copy) NSString *%@;",propertyName],
                                           [NSString stringWithFormat:@"@property (nonatomic, strong) NSArray *%@;",propertyName],
                                           [NSString stringWithFormat:@"@property (nonatomic, strong) NSDictionary *%@;",propertyName],
                                           ];
    NSUInteger randomNum = arc4random() % 5;
    return propertyArray[randomNum];
}

//随机方法
- (void)randomMethod:(void(^)(NSArray <NSString *>*methodArray))handle {
    NSUInteger randomNum = 1 + arc4random() % 6;
    NSString *method = nil;
    NSMutableArray *array = [NSMutableArray array];
    for (NSInteger i = 0; i < randomNum; i ++) {
        NSString *methodString = [self randomPerMethod];
        if ([method containsString:methodString]) continue; //如果有,跳过
        [array addObject:methodString];
    }
    if (handle) handle(array);
}

//随机一个方法
- (NSString *)randomPerMethod {
    NSUInteger randomNum = arc4random() % 4;
    return [self recursiveMethod:randomNum];
}

- (NSString *)recursiveMethod:(NSInteger)times {
    if (times == 0) {
        NSString *methodName = bodyArray()[self.randomBodyNum];
        return [NSString stringWithFormat:@"- (void)%@;",methodName];
    }else {
        NSString *methodName = bodyArray()[self.randomBodyNum];
        for (NSInteger i = 0; i < times; i ++ ) {
            NSString *newMethod = bodyArray()[self.randomBodyNum];
            NSUInteger randomM = arc4random() % 4;
            if (![methodName containsString:newMethod]) { //不包含拼接的新串
                if (i == 0) {
                    methodName = [NSString stringWithFormat:@"%@%@:(%@)%@",methodName,newMethod.capitalizedString,typesArray()[randomM],newMethod];
                }else {
                  methodName = [NSString stringWithFormat:@"%@ and%@:(%@)%@",methodName,newMethod.capitalizedString,typesArray()[randomM],newMethod];
                }
            }else { //包含,跳过
                break;
            }
        }
        return [NSString stringWithFormat:@"- (void)%@;",methodName];
    }
}

- (NSString *)defaultFullPath {
    NSString *desk = [NSSearchPathForDirectoriesInDomains(NSDesktopDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return  [desk stringByAppendingPathComponent:self.fileName];
}

- (NSString *)bodyString {
    NSString *body = nil;
    if (self.mixedBody && self.mixedBody.length != 0) {
        body = self.mixedBody;
    }else {
        body = bodyArray()[self.randomBodyNum];
    }
    return body;
}

- (NSString *)tailString {
    NSString *tail = nil;
    if (self.tailS && self.tailS.length != 0) {
        tail = self.tailS;
    }else {
        tail = tailArray()[self.randomTailNum];
    }
    return tail;
}

- (NSUInteger)randomBodyNum {
    return arc4random() % (int)(bodyArray().count - 1);
}

- (NSUInteger)randomTailNum {
    return arc4random() % (int)(tailArray().count - 1);
}

//随机一个字母
- (NSString *)randomChar {
    NSArray *array = @[@"a",@"b",@"c",@"d",@"e",@"f",@"g",@"h",@"i",@"g",@"k",@"l",@"m",@"n",@"o",@"p",@"q",@"r",@"s",@"t",@"u",@"v",@"w",@"x",@"y",@"z"];
   NSUInteger randomNum = arc4random() % 25;
    return array[randomNum];
}

//删除最后一个字符
- (NSString*)removeLastOneChar:(NSString*)origin {
    NSString* cutted;
    if([origin length] > 0){
        cutted = [origin substringToIndex:([origin length]-1)];
    }else{
        cutted = origin;
    }
    return cutted;
}

@end
