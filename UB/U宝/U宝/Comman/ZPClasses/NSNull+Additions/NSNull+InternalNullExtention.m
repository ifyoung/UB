//
//  NSNull+InternalNullExtention.m
//  LoginSystem
//
//  Created by midu Mac on 15-1-21.
//  Copyright (c) 2015年 midu Mac. All rights reserved.
//

#import "NSNull+InternalNullExtention.h"

@implementation NSNull (InternalNullExtention)

/*
在一个函数找不到时，Objective-C提供了三种方式去补救：
1、调用resolveInstanceMethod给个机会让类添加这个实现这个函数
2、调用forwardingTargetForSelector让别的对象去执行这个函数
3、调用methodSignatureForSelector（函数符号制造器）和forwardInvocation（函数执行器）灵活的将目标函数以其他形式执行。
如果都不中，调用doesNotRecognizeSelector抛出异常。
*/


//+ (BOOL)resolveInstanceMethod:(SEL)sel{
//}

//- (id)forwardingTargetForSelector:(SEL)aSelector{
//
//}

//系统方法
- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector{
    
    NSMethodSignature *signature = [super methodSignatureForSelector:selector];
    if (!signature) {
        for (NSObject *object in NSNullObjects) {
            signature = [object methodSignatureForSelector:selector];
            if (signature) {
                break;
            }
        }
    }
    return signature;
}

//系统方法
- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    SEL aSelector = [anInvocation selector];
    
    for (NSObject *object in NSNullObjects) {
        if ([object respondsToSelector:aSelector]) {
            [anInvocation invokeWithTarget:object];
            return;
        }
    }
    
    [self doesNotRecognizeSelector:aSelector];
}


//- (void)doesNotRecognizeSelector:(SEL)aSelector{
//
//
//
//}

@end



/*
 这里还提供一个日本人的封装方案：

 - (void)forwardInvocation:(NSInvocation *)invocation
 {
 if ([self respondsToSelector:[invocation selector]]) {
 [invocation invokeWithTarget:self];
 }
 }
 
 - (NSMethodSignature *)methodSignatureForSelector:(SEL)selector
 {
 NSMethodSignature *sig = [[NSNull class] instanceMethodSignatureForSelector:selector];
 if(sig == nil) {
 sig = [NSMethodSignature signatureWithObjCTypes:"@^v^c"];
 }
 return sig;
 }
*/