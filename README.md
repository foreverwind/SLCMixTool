# SLCMixTool

iOS 代码混淆:
1.生成无用的文件和内部属性及函数.
2.在已有文件内增加无用的函数

## 生成无用的文件和内部属性及函数.
1.  设置变量

在执行文件`main.m`内修改变量.
```
SLCMixManager *mix = [SLCMixManager new];
mix.fileHeader = @"SQZ"; //header
mix.fileName = @"QuizProject"; //文件夹名称
mix.fileNum = 150; //文件个数
[mix fireOnBorn];
```

2. 执行
 command + r 运行,文件夹(不设置的情况下，默认在桌面)生成.

3. 调用
代码拉进项目(或设置路径直接在工程生成)后,有一个默认调用类.
`#import "设置的fileHeader + Bullets.h"`,例如`#import "SQZBullets.h"`.

所有的类会生成一个对象,并且简单操作其内的属性和方法,执行完成后会立即被释放.
```
[SQZBullets fire];
```

##  在已有文件内增加无用的函数
原理同上.
1. 调用 
在`main.m`内调用
```
SLCMixManager *mix = [SLCMixManager new];
mix.childFullPath = @"/Users/weikunchao/Desktop/aa";
mix.contaisArray = @[@"SLCmixLayout"];
mix.childMethodNum = 10;
[mix fireOnChild];
```


