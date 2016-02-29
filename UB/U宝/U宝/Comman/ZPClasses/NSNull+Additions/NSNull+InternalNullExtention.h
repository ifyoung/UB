//
//  NSNull+InternalNullExtention.h
//  LoginSystem
//
//  Created by midu Mac on 15-1-21.
//  Copyright (c) 2015年 midu Mac. All rights reserved.
//

#import <Foundation/Foundation.h>


#define NSNullObjects @[@"",@0,@{},@[]]

@interface NSNull (InternalNullExtention)

/*
初始化阶段 —— load 和 initialize
load函数
原型：
+(void)load
当类被引用进程序的时候会执行这个函数。
在一个程序开始运行之前（在main函数开始执行之前）,在库开始被程序加载，load函数就会开始被执行。
我们开发的程序都可以认为是一个库，但是库又不会独立存在（我们的程序还会引用其他库，也可能被其他函数引用），所以库的初始化顺序可以如下：
1. 初始化我们引用的库
2. 执行我们自己库的Objective-C的load函数
3. 执行C++和C的static初始化变量
4. 初始化引用我们库的其他库
在我们的编写的库中，会有很多类重写load函数，他们之间的执行顺序是不确定的。
当父类和子类都实现load函数时，父类的load函数会被先执行。load函数是系统自动加载的，因此不需要调用父类的load函数，否则父类的load函数会多次执行。
在Category中写load函数是不会替换原始类中的load函数的，原始类和Category中的load函数都会被执行，原始类的load会先被执行，再执行Category中的load函数。当有多个Category都实现了load函数，这几个load函数执行顺序不确定。
Initialize函数
原型：
+ (void)initialize
当类第一次被执行到的时候这个函数会被执行。
如果类包含继承关系，父类的initialize函数会比子类先执行。由于是系统自动调用，也不需要显式的调用父类的initialize，否则父类的initialize会被多次执行。
假如这个类放到代码中，而这段代码并没有被执行，这个函数是不会被执行的。
Load or Initialize
这两个函数没有交集，也没有执行的先后顺序，他们各自遵循着各自的调用原则。因此在写逻辑的时候，不能有逻辑依赖load函数比initialize函数先行调用。
来看下面这种情况：
@interface NoneClass : NSObject
@end
@implementation NoneClass
+(void)load
{
    NSLog(@“NoneClass _cmd: %@”, NSStringFromSelector(_cmd));
    MyTestObject *test = [[MyTestObject alloc] init];
}

@end

@interface MyTestObject
@end
@implementation MyTestObject
+ (void) load
{
    NSLog(@“MyTestObject _cmd: %@”, NSStringFromSelector(_cmd));
    
}

+ (void)initialize
{
    NSLog(@“MyTestObject _cmd: %@”, NSStringFromSelector(_cmd));
}

@end
输出的结果：
2014-04-11 12:45:44.297 ObjectTest[1617:60b] NoneClass _cmd: load
2014-04-11 12:45:44.300 ObjectTest[1617:60b] MyTestObject _cmd: initialize
2014-04-11 12:45:44.301 ObjectTest[1617:60b] MyTestObject _cmd: load
结果分析：
由于在执行NonoClass的load函数中调用了MyTestObject的构造函数，这样会触发MyTestObject的initialize函数调用。而此时MyTestObject的load函数还没有被调用。
使用场景：
将针对于类修改放在intialize中，将针对Category的修改放在load中。
但是假如我们是修改系统的类，一般会通过添加Category来添加功能，但是如果修改initialize会导致原生的intialize不会执行，所以放在load中会比较妥当。
 */
@end
