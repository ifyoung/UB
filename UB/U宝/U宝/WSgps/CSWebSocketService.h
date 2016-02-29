//
//  CSWebSocketService.h
//  cheshenzhushou
//
//  Created by SG on 14-6-20.
//  Copyright (c) 2014年 ChinaGPS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SRWebSocket.h"
#import "GBoss.h"


typedef enum _CSWebSocketCommandType
{
    CSWebSocketCommandLoginType = 1,
    CSWebSocketCommandGetLastInfoType = 2,
    CSWebSocketCommandGetHistoryInfoType = 3,
    CSWebSocketCommandGetHistoryNextInfoType = 4,
    CSWebSocketCommandRemoteControlType = 5,
    CSWebSocketCommandAddMonitorType = 6,
    CSWebSocketCommandRemoveMonitorType = 7,
    CSWebSocketCommandHeartbeatsType = 8
}CSWebSocketCommandType;

typedef enum _CSGpsHistoryInfoType
{
    CSGpsHistoryInfoBasicType = 1,
    CSGpsHistoryInfoDetailType = 2,
    CSGpsHistoryInfoFaultType = 3
}CSGpsHistoryInfoType;

@interface CSWebSocketCommand : NSObject

@property (nonatomic, strong) NSArray *callLetters;
@property (nonatomic, assign) CSWebSocketCommandType commandType;
@property (nonatomic, strong) NSString *sn;
@property (nonatomic, strong) NSString *baseSN;
@property (nonatomic, assign) long long enqueueTime;
@property (nonatomic, assign) long long executeTime;
@property (nonatomic, assign) int expectedResponseCount;
@property (nonatomic, assign) int receivedResponseCount;
@property (nonatomic, assign) int retryCount;

@end

@interface CSWebSocketGetHistoryInfoCommand : CSWebSocketCommand

@property (nonatomic, assign) long long startTime;
@property (nonatomic, assign) long long endTime;
@property (nonatomic, assign) int pageNumber;
@property (nonatomic, assign) int totalNumber;
@property (nonatomic, assign) BOOL autonextpage;
@property (nonatomic, assign) CSGpsHistoryInfoType historyType;
@property (nonatomic, assign) BOOL reversed;

@end

//@interface CSWebSocketRemoteControlCommand : CSWebSocketCommand
//
//@property (nonatomic, assign) int commandID;
//@property (nonatomic, strong) NSArray *params;
//@property (nonatomic, strong) NSString *ackProxy;
//@property (nonatomic, assign) int channelID;
//@property (nonatomic, assign) BOOL completed;
//@property (nonatomic, assign) long long ackTime;
//@property (nonatomic, assign) long long verifyTime;
//
//@end

typedef void(^GetCommandFailHander)     (id result);
typedef void(^GetSendLoginHander)     (id result);
typedef void(^GetLastInfoACKHander)   (id result);
typedef void(^GetHistoryInfoACKHander)(id result);

@interface CSWebSocketException : NSObject

@property (nonatomic, strong) NSString *sn;
@property (nonatomic, strong) NSString *message;

- (instancetype)initWithSN:(NSString *)sn message:(NSString *)message;

@end

@interface CSWebSocketService : NSObject<SRWebSocketDelegate>
{
    
    NSString *userName;
    NSString *userPwd;
    NSString *userType;
}

@property (nonatomic, copy)NSString *currentCallLetter;
@property (nonatomic, assign) BOOL didLogin;
@property (nonatomic, strong) SRWebSocket *wsRequest;
@property (nonatomic, readonly) SRReadyState state;

@property (nonatomic,copy)GetCommandFailHander     failHander;
@property (nonatomic,copy)GetSendLoginHander       loginblock;
@property (nonatomic,copy)GetLastInfoACKHander     lastblock;
@property (nonatomic,copy)GetHistoryInfoACKHander  historyblock;


+ (CSWebSocketService *)sharedManager;

/*
 *  WebSocket
 */
- (void)initWebSocket;
- (void)destroyWebsocket;

/*
 *  登录
 */
- (void)sendLoginCommand;

/*
 *  车辆最后位置信息
 */
- (void)sendLastGpsCommand;//:(CSWebSocketCommand *)command

/*
 *  车辆历史位置信息
 */
- (void)sendHistoryGpsCommand:(CSWebSocketGetHistoryInfoCommand *)command;

/*
 *  监听\移除 车辆
 */
- (void)sendAddMonitorCommand;
- (void)sendRemoveMonitorCommand;

/*
 *  心跳链接
 */
- (void)sendHeartbeatCommand;

@end
