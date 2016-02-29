//
//  ViewController.m
//  TestGBoss
//
//  Created by SG on 14-6-16.
//  Copyright (c) 2014年 ChinaGPS. All rights reserved.
//

#import "ViewController.h"
#import "ComCenterDataBuff.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //ComCenterBaseMessage *msgBase = [[ComCenterBaseMessage alloc] init];
    //[msgBase doSomething];
    
    ComCenterMessage *msgCenter = [[ComCenterMessage alloc] init];
    ComCenterBaseMessage *msgBase = [[ComCenterBaseMessage alloc] init];
    
    LoginMessage *msgLogin = [[LoginMessage alloc] init];
    msgLogin.userName = @"zhangxz";
    msgLogin.password = @"abc123";
    
    msgBase.messageType = GBossMessageType_Login;
    msgBase.message = msgLogin;
    
    [msgCenter.messages addObject:msgBase];
    NSData *dataCenter = [msgCenter toData];
    Byte *bytes = (Byte *)[dataCenter bytes];
    
    for (int i = 0; i < 24; i++)
        NSLog(@"%d", (int)bytes[i]);
}

@end
