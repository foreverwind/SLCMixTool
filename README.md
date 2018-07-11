# SLCMixTool

iOS 代码混淆(生成无用的代码和内部属性及函数)

## 设置变量
在执行文件`main.m`内修改变量.
```
SLCMixManager *mix = [SLCMixManager new];
mix.fileHeader = @"SQZ"; //header
mix.fileName = @"QuizProject"; //文件夹名称
mix.fileNum = 150; //文件个数
[mix fire];
```

## 运行
command + r 运行,文件夹(不设置的情况下，默认在桌面)生成.

## 调用
代码拉进项目(或设置路径直接在工程生成)后,有一个默认调用类.
`#import "设置的fileHeader + Bullets.h"`,例如`#import "SQZBullets.h"`.

所有的类会生成一个对象,并且简单操作其内的属性和方法,执行完成后会立即被释放.
```
[SQZBullets fire];
```
