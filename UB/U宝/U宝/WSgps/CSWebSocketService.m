//
//  CSWebSocketService.m
//  cheshenzhushou
//
//  Created by SG on 14-6-20.
//  Copyright (c) 2014年 ChinaGPS. All rights reserved.
//

#import "CSWebSocketService.h"
#import "CipherTool.h"

#define SG_SOCKET_URL                   @"ws://202.105.139.92:8070/websocket"


@implementation CSWebSocketCommand
- (id)init
{
    self = [super init];
    if (self)
    {
        self.retryCount = 0;
    }
    return self;
}
@end

@implementation CSWebSocketGetHistoryInfoCommand

@end

//@implementation CSWebSocketRemoteControlCommand
//- (instancetype)init
//{
//    self = [super init];
//    if (self) {
//        _completed = NO;
//        _ackTime = [[NSDate date] timeIntervalSince1970];
//        _verifyTime = [[NSDate date] timeIntervalSince1970];
//    }
//    return self;
//}
//@end

@implementation CSWebSocketException
- (instancetype)initWithSN:(NSString *)sn message:(NSString *)message
{
    self = [super init];
    if (self)
    {
        _sn = sn;
        _message = message;
    }
    return self;
}
@end

@interface CSWebSocketService (){
 
    dispatch_queue_t _cmdHeartbeats;  //心跳线程
    Reachability *reach;
    
    NSMutableArray *historyBaseInfoMessageArray;  //历史轨迹位置存放
}

@end
@implementation CSWebSocketService

+ (CSWebSocketService *)sharedManager{
    static CSWebSocketService *sharedManager;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {

        //[self initWebSocket];
        
        [self ReachabilitySettings];
        
    }
    return self;
}

#pragma mark - Command routine
/*******************SRWebSocket************************/
/*******************SRWebSocket************************/
/*******************SRWebSocket************************/

- (void)initWebSocket{
    
    userName = @"zhangxz1";
    userPwd = @"abc123";
    userType = @"IOS-HAIMA";
    
    NSString *userTokenName = [[NSUserDefaults standardUserDefaults] stringForKey:@"APP_UserTokenName"];
    NSString *userTokenKey = [[NSUserDefaults standardUserDefaults] stringForKey:@"APP_UserTokenKey"];
    if (userTokenName.length)
        userName = [CipherTool getOriginString:userTokenName];
    if (userTokenKey.length)
        userPwd = [CipherTool getOriginString:userTokenKey];
    
    
    [self destroyWebsocket];

    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:SG_SOCKET_URL]];
    if(_wsRequest == nil){
        _wsRequest = [[SRWebSocket alloc] initWithURLRequest:urlRequest];
        _wsRequest.delegate = self;
       [_wsRequest open];
    }
}

- (void)destroyWebsocket
{
    if (_wsRequest)
    {
         _didLogin = NO;
        [_wsRequest close];
        _wsRequest.delegate = nil;
        _wsRequest = nil;
    }
}


/*******************SRWebSocket************************/
/*******************SRWebSocket************************/
/*******************SRWebSocket************************/
/**
 *   Reachability
 *
 *  @param animated
 */
- (void)ReachabilitySettings{

    __weak typeof(self) this = self;
    reach = [Reachability reachabilityForInternetConnection];
    reach.reachableBlock = ^(Reachability * reachability)
    {
        
        if(reachability.isReachableViaWiFi){
            
            NSLog(@"Wi-Fi");
            
        }else if (reachability.isReachableViaWWAN){
            
            NSLog(@"运营商网络");
        }
        
        [this initWebSocket];
    };
    
    
    reach.unreachableBlock = ^(Reachability * reachability)
    {
    
        [this destroyWebsocket];
    };
    
    [reach startNotifier];
}



- (BOOL)isWebSocketValid
{
    return _wsRequest.readyState == SR_OPEN;
}
- (SRReadyState)state
{
    return _wsRequest ? _wsRequest.readyState : SR_CLOSED;
}


#pragma mark - Websocket delegate
- (void)webSocketDidOpen:(SRWebSocket *)webSocket
{
    NSLog(@":) Websocket connected successfully.");
    //if (!_didLogin)
    //{
        [self sendLoginCommand];
   // }
}
- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError:%@",error);  //比如断网等 Socket is not connected
    _didLogin = NO;
    if(reach.isReachable){
       [self initWebSocket];
    }
}
- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean
{
    NSLog(@":) Websocket didCloseWithCode. %@",reason);
     _didLogin = NO;
    if(reach.isReachable){
        [self initWebSocket];
    }
}
- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message{
    
    NSData *dataDecrypted = [CipherTool decodeData:message];
    
    ComCenterMessage *msgCenterDecrypted = [[ComCenterMessage alloc] initWithData:dataDecrypted];
    
    if (msgCenterDecrypted.messages && msgCenterDecrypted.messages.count > 0)
    {

        for (ComCenterBaseMessage *msgBaseDecrypted in msgCenterDecrypted.messages)
        {

            if(msgBaseDecrypted.messageType == GBossMessageType_Login_ACK){
            
                LoginACKMessage *msgLoginACKDecrypted = (LoginACKMessage *)msgBaseDecrypted.message;
                //长链接登录失败
                if (msgLoginACKDecrypted.resultCode == GBossResultCode_OK)
                {
                    //登录成功标记
                    _didLogin = YES;
            
                    if(self.loginblock)
                        self.loginblock(@"登录成功");

                }else{
                    
                    _didLogin = NO;
                    //再次链接
                    [self sendLoginCommand];
                }
            
            }else if (msgBaseDecrypted.messageType == GBossMessageType_GetLastInfo_ACK){
                
                GetLastInfoACKMessage *lastInfoACKMessage = (GetLastInfoACKMessage *)msgBaseDecrypted.message;
                if (lastInfoACKMessage.resultCode == GBossResultCode_OK)
                {
                    /*
                    baseInfoMessage.gpsTime //GPS时间
                    baseInfoMessage.speed   //速度
                    baseInfoMessage.course  //方向
                    baseInfoMessage.status  //状态数组
                     */
                    //GpsBaseInfoMessage
                    GpsInfoMessage *infoMessage = [lastInfoACKMessage.gpses firstObject];
                    GpsBaseInfoMessage *baseInfoMessage = infoMessage.baseInfo;
                    //硬件信息
                    //OBDInfoMessage *obdInfoMessage = speedMessage.obdInfo;
                    /*
                     positonMessage.province
                     positonMessage.city
                     positonMessage.county
                     positonMessage.roads
                     positonMessage.points
                     */
                    //最后地点
                    GpsReferPositionMessage *positonMessage = infoMessage.referPosition;
                    //NSString *position = [NSString stringWithFormat:@""]
                    
                    if(self.lastblock)
                        self.lastblock(@[baseInfoMessage,positonMessage]);
                    
                }else{

                    if(self.lastblock)
                        self.lastblock(lastInfoACKMessage.resultDescription);
                }
            }else if (msgBaseDecrypted.messageType == GBossMessageType_GetHistoryInfo_ACK){
            
                NSLog(@"%@",msgBaseDecrypted.message);
                GetHistoryInfoACKMessage *historyInfoACKMessage = (GetHistoryInfoACKMessage *)msgBaseDecrypted.message;
                if (historyInfoACKMessage.resultCode == GBossResultCode_OK)
                {
            
                    BOOL isLastPage = historyInfoACKMessage.lastPage;
                    if(historyBaseInfoMessageArray == nil)
                         historyBaseInfoMessageArray = [NSMutableArray array];
                    
                    for(long i =0;i < historyInfoACKMessage.gpses.count;i++){
                        GpsInfoMessage *gpsInforMessage = [historyInfoACKMessage.gpses objectAtIndex:i];
                        GpsBaseInfoMessage *baseInfoMessage = gpsInforMessage.baseInfo;
                        [historyBaseInfoMessageArray addObject:baseInfoMessage];
                    }
                    
                    //TravelInfoMessage *travelInfoMessage = historyInfoACKMessage.travels;
                    //FaultInfoMessage *faultInfoMessage = historyInfoACKMessage.faults;
                    if(isLastPage){
                     
                        if(self.historyblock && historyBaseInfoMessageArray)
                            self.historyblock([historyBaseInfoMessageArray copy]);
                        
                        [historyBaseInfoMessageArray removeAllObjects];
                    }else{
                        
                    }
                    
                }else{
  
                     if(self.historyblock && historyInfoACKMessage.resultDescription)
                       self.historyblock(historyInfoACKMessage.resultDescription);
                }
            }else if (msgBaseDecrypted.messageType == GBossMessageType_AddMonitor_ACK){
            
                NSLog(@"%@",msgBaseDecrypted.message);
                AddMonitorACKMessage *addMonitorACKMessage = (AddMonitorACKMessage *)msgBaseDecrypted.message;
                if (addMonitorACKMessage.resultCode == GBossResultCode_OK)
                {
                    
                    //发送心跳
                    [self runHeartbeats];
                    
                }else{
                
                    [self sendAddMonitorCommand];
                }

            }else if (msgBaseDecrypted.messageType == GBossMessageType_RemoveMonitor_ACK){
            
                NSLog(@"%@",msgBaseDecrypted.message);
                RemoveMonitorACKMessage *removeMonitorACKMessage = (RemoveMonitorACKMessage *)msgBaseDecrypted.message;
                if (removeMonitorACKMessage.resultCode == GBossResultCode_OK)
                {
                    //停止发送心跳
                    [self stopHeartbeats];
                    
                }else{
 
                    
                }
            }
            else if (msgBaseDecrypted.messageType == GBossMessageType_DeliverGPS){
            
                //监听返回数据
                NSLog(@"%@",msgBaseDecrypted.message);
                DeliverGPSMessage *deliverGPSMessage = (DeliverGPSMessage *)msgBaseDecrypted.message;
                GpsInfoMessage *gpsInfoMessage = deliverGPSMessage.gpsInfo;
                GpsBaseInfoMessage *baseInfoMessage = gpsInfoMessage.baseInfo;
                GpsReferPositionMessage *positonMessage = gpsInfoMessage.referPosition;
                
                if(self.lastblock)
                    self.lastblock(@[baseInfoMessage,positonMessage]);
                
            }
            else if (msgBaseDecrypted.messageType == GBossMessageType_ActiveLink_ACK){
            
                NSLog(@"%@",msgBaseDecrypted);
               //* 链路检测（心跳）、链路检测（心跳）应答没有内容, 只有消息ID
            
            }
        }
    }
}

/*******************SRWebSocket************************/
/*******************SRWebSocket************************/
/*******************SRWebSocket************************/



/*********************车辆位置信息**********************/
/*********************车辆位置信息**********************/
#pragma mark - Commands
- (void)sendLoginCommand
{
    LoginMessage *msgLogin = [[LoginMessage alloc] init];
    msgLogin.userName = userName;
    msgLogin.password = userPwd;
    msgLogin.userType = userType;
    msgLogin.userVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    
    ComCenterBaseMessage *msgBase = [[ComCenterBaseMessage alloc] init];
    msgBase.messageType = GBossMessageType_Login;
    msgBase.message = msgLogin;
    
    ComCenterMessage *msgCenter = [[ComCenterMessage alloc] init];
    [msgCenter.messages addObject:msgBase];
    
    //gboss数据转换
    NSData *dataCenter = [msgCenter toData];
    NSData *dataEncrypted = [CipherTool encodeData:dataCenter compress:YES encrypt:YES];
    
    if ([self isWebSocketValid]){
        
        [_wsRequest send:dataEncrypted];
    }
}

- (void)sendLastGpsCommand//:(CSWebSocketCommand *)command
{
    NSString *sn =  [[UIDevice currentDevice] uniqueDeviceIdentifier];
    NSString *callLetter = [CurrentDeviceModel shareInstance].callLetter;
    if(callLetter == nil) return;
    NSArray *callLetters =  @[callLetter];
    
    //这是个数组 允许多个指令同时发出
    ComCenterMessage *msgCenter = [[ComCenterMessage alloc] init];
    
    //最后位置信息模型
    GetLastInfoMessage *msgGetLastInfo = [[GetLastInfoMessage alloc] init];
    msgGetLastInfo.callLetters = [[NSMutableArray alloc] initWithArray:callLetters];
    msgGetLastInfo.infoType = GBossMessageType_DeliverGPS;
    msgGetLastInfo.sn = sn;
    
    //中心数据模型 包含最后位置信息模型
    ComCenterBaseMessage *msgBase = [[ComCenterBaseMessage alloc] init];
    msgBase.messageType = GBossMessageType_GetLastInfo;
    msgBase.message = msgGetLastInfo;
    
    //加速数组 允许多个指令同时发出
    [msgCenter.messages addObject:msgBase];

    NSData *dataCenter = [msgCenter toData];
    NSData *dataEncrypted = [CipherTool encodeData:dataCenter compress:YES encrypt:YES];
    if ([self isWebSocketValid]){
        [_wsRequest send:dataEncrypted];
    }
}

- (void)sendHistoryGpsCommand:(CSWebSocketGetHistoryInfoCommand *)command
{
    ComCenterMessage *msgCenter = [[ComCenterMessage alloc] init];
    
    GetHistoryInfoMessage *msgGetHistoryInfo = [[GetHistoryInfoMessage alloc] init];
    
    msgGetHistoryInfo.callLetter = [command.callLetters objectAtIndex:0];
    
    switch (command.historyType) {
        case CSGpsHistoryInfoBasicType:
            msgGetHistoryInfo.infoType = GBossMessageType_DeliverGPS;
            break;
        case CSGpsHistoryInfoDetailType:
            msgGetHistoryInfo.infoType = GBossMessageType_DeliverTravel;
            break;
        case CSGpsHistoryInfoFaultType:
            msgGetHistoryInfo.infoType = GBossMessageType_DeliverFault;
            break;
        default:
            msgGetHistoryInfo.infoType = GBossMessageType_DeliverGPS;
            break;
    }
    msgGetHistoryInfo.starttime = command.startTime;
    msgGetHistoryInfo.endtime = command.endTime;
    msgGetHistoryInfo.pageNumber = command.pageNumber;
    msgGetHistoryInfo.totalNumber = command.totalNumber;
    msgGetHistoryInfo.autonextpage = command.autonextpage;
    msgGetHistoryInfo.sn = command.sn;
    msgGetHistoryInfo.reversed = command.reversed;
    
    ComCenterBaseMessage *msgBase = [[ComCenterBaseMessage alloc] init];
    msgBase.messageType = GBossMessageType_GetHistoryInfo;
    msgBase.message = msgGetHistoryInfo;
    [msgCenter.messages addObject:msgBase];
    
    NSData *dataCenter = [msgCenter toData];
    NSData *dataEncrypted = [CipherTool encodeData:dataCenter compress:YES encrypt:YES];
    
    if ([self isWebSocketValid]){
        [_wsRequest send:dataEncrypted];
    }
}
/*********************车辆位置信息**********************/
/*********************车辆位置信息**********************/


/*
 *   监听实时实时位置信息
 */
- (void)sendAddMonitorCommand//:(CSWebSocketCommand *)command
{
    ComCenterMessage *msgCenter = [[ComCenterMessage alloc] init];
    ComCenterBaseMessage *msgBase = [[ComCenterBaseMessage alloc] init];
    
    NSString *callLetter = [CurrentDeviceModel shareInstance].callLetter;  //bc07d6 13414238951
    if(callLetter == nil) return;
    NSArray *callLetters =  @[callLetter];
    _currentCallLetter = callLetter;
    
    AddMonitorMessage *msgAddMonitor = [[AddMonitorMessage alloc] init];
    msgAddMonitor.callLetters = [[NSMutableArray alloc] initWithArray:callLetters];
    msgAddMonitor.infoTypes = [[NSMutableArray alloc] initWithObjects:
                               [NSNumber numberWithInt:GBossMessageType_DeliverGPS],
                               //[NSNumber numberWithInt:GBossMessageType_DeliverTravel],
                               //[NSNumber numberWithInt:GBossMessageType_DeliverFault],
                               nil];
    
    msgBase.messageType = GBossMessageType_AddMonitor;
    msgBase.message = msgAddMonitor;
    
    [msgCenter.messages addObject:msgBase];
    NSData *dataCenter = [msgCenter toData];
    NSData *dataEncrypted = [CipherTool encodeData:dataCenter compress:YES encrypt:YES];
    
    if ([self isWebSocketValid]){
        [_wsRequest send:dataEncrypted];
    }
}
/*
 *   移除监听实时实时位置信息
 */
- (void)sendRemoveMonitorCommand//:(CSWebSocketCommand *)command
{
    if(!_currentCallLetter) return;
    
    ComCenterMessage *msgCenter = [[ComCenterMessage alloc] init];
    ComCenterBaseMessage *msgBase = [[ComCenterBaseMessage alloc] init];
    
    NSArray *callLetters =  @[_currentCallLetter];
    RemoveMonitorMessage *msgAddMonitor = [[RemoveMonitorMessage alloc] init];
    msgAddMonitor.callLetters = [[NSMutableArray alloc] initWithArray:callLetters];
    msgAddMonitor.infoTypes = [[NSMutableArray alloc] initWithObjects:
                               [NSNumber numberWithInt:GBossMessageType_DeliverGPS],
                               [NSNumber numberWithInt:GBossMessageType_DeliverTravel],
                               [NSNumber numberWithInt:GBossMessageType_DeliverFault],
                               nil];
    
    msgBase.messageType = GBossMessageType_RemoveMonitor;
    msgBase.message = msgAddMonitor;
    
    [msgCenter.messages addObject:msgBase];
    NSData *dataCenter = [msgCenter toData];
    NSData *dataEncrypted = [CipherTool encodeData:dataCenter compress:YES encrypt:YES];
    
    if ([self isWebSocketValid]){
        [_wsRequest send:dataEncrypted];
    }
}


/*
 *  发送心跳
 */
- (void)sendHeartbeatCommand
{
    ComCenterMessage *msgCenter = [[ComCenterMessage alloc] init];
    ComCenterBaseMessage *msgBase = [[ComCenterBaseMessage alloc] init];
    
    msgBase.messageType = GBossMessageType_ActiveLink;
    
    [msgCenter.messages addObject:msgBase];
    NSData *dataCenter = [msgCenter toData];
    NSData *dataEncrypted = [CipherTool encodeData:dataCenter compress:YES encrypt:YES];
    
    if ([self isWebSocketValid]){
        [_wsRequest send:dataEncrypted];
    }
}

- (void)runHeartbeats
{
    _cmdHeartbeats = dispatch_get_global_queue(0,0);
    dispatch_async(_cmdHeartbeats,^ {
        while(YES)
        {
            [self sendHeartbeatCommand];
            
            sleep(60);  //60秒发送一次
        }
    });
}
- (void)stopHeartbeats
{
    if(_cmdHeartbeats)
    {
        dispatch_suspend(_cmdHeartbeats);
        
        _cmdHeartbeats = nil;
    }
}

@end
