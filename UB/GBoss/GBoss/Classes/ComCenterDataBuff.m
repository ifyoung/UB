//
//  ComCenterDataBuff.m
//  testpb
//
//  Created by SG on 14-6-12.
//  Copyright (c) 2014年 ChinaGPS. All rights reserved.
//

#import "ComCenterDataBuff.h"
#import "comcenter.pb.h"
#import "GBoss.pb.h"

#pragma mark - GBossPBObject super object

@interface GBossPBObject()
{
    
}

- (std::string)toCString;
+ (NSString *)objcStringFromCString:(std::string)cstring;
+ (std::string)cstringFromObjcString:(NSString *)string;
+ (NSData *)dataFromCString:(std::string)cstring;

@end

#pragma mark - Extended interface

@interface OBDInfoMessage()

- (id)initWithPBObject:(gboss::OBDInfo &)obdInfo;

@end

@interface GpsBaseInfoMessage()

- (id)initWithPBObject:(gboss::GpsBaseInfo &)gpsBaseInfo;

@end

@interface GpsRoadInfoMessage()

- (id)initWithPBObject:(gboss::GpsRoadInfo &)road;

@end

@interface GpsPointInfoMessage()

- (id)initWithPBObject:(gboss::GpsPointInfo &)point;

@end

@interface GpsReferPositionMessage()

- (id)initWithPBObject:(gboss::GpsReferPosition &)gpsPosition;

@end

@interface GpsInfoMessage()

- (id)initWithPBObject:(gboss::GpsInfo &)gpsInfo;

@end

@interface AlarmInfoMessage()

- (id)initWithPBObject:(gboss::AlarmInfo &)alarmInfo;

@end

@interface TravelInfoMessage()

- (id)initWithPBObject:(gboss::TravelInfo &)travel;

@end

@interface FaultDefineMessage()

- (id)initWithPBObject:(gboss::FaultDefine &)faultDefine;

@end

@interface FaultInfoMessage()

- (id)initWithPBObject:(gboss::FaultInfo &)fault;

@end

@interface AppNoticeInfoMessage()

- (id)initWithPBObject:(gboss::AppNoticeInfo &)appNoticeInfo;

@end

@interface NodeLostInfoMessage()

- (id)initWithPBObject:(gboss::NodeLostInfo &)nodeLostInfo;

@end

@interface NodeFaultInfoMessage()

- (id)initWithPBObject:(gboss::NodeFaultInfo &)nodeFaultInfo;

@end

@interface FaultLightStatusMessage()

- (id)initWithPBObject:(gboss::FaultLightStatus &)faultLightStatus;

@end

@implementation GBossPBObject

#pragma mark - Abstract member methods

- (void)doSomething
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

- (id)initWithData:(NSData *)data
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

- (NSData *)toData
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

- (std::string)toCString
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

#pragma mark - Static utility methods

+ (NSString *)objcStringFromCString:(std::string)cstring
{
//    [NSString stringWithCString:cstring.c_str() encoding:[NSString defaultCStringEncoding]];
    return [NSString stringWithUTF8String:cstring.c_str()];
}

+ (std::string)cstringFromObjcString:(NSString *)string
{
//    return [string cStringUsingEncoding:[NSString defaultCStringEncoding]];
    return [string UTF8String];
}

+ (NSData *)dataFromCString:(std::string)cstring
{
    return [NSData dataWithBytes:cstring.c_str() length:cstring.size()];
}

@end

#pragma mark - ComCenterMessage
@implementation ComCenterMessage

- (id)initWithData:(NSData *)data
{
    self = [super init];
    if (self)
    {
        gboss::ComCenterMessage *pbCenter = [self getMessageFromData:data];
        
        _messages = [[NSMutableArray alloc] init];
        for (int i = 0; i < pbCenter->messages_size(); i++)
        {
            gboss::ComCenterMessage_ComCenterBaseMessage pbBase = pbCenter->messages(i);
            
            ComCenterBaseMessage *msgBase = [[ComCenterBaseMessage alloc] init];
            msgBase.messageType = (GBossMessageType)pbBase.id();
            switch (msgBase.messageType) {
                case GBossMessageType_Login:
                    {
                        LoginMessage *msgLogin = [[LoginMessage alloc] initWithData:[GBossPBObject dataFromCString:pbBase.content()]];
                        msgBase.message = msgLogin;
                    }
                    break;
                case GBossMessageType_Login_ACK:
                    {
                        LoginACKMessage *msgLoginACK = [[LoginACKMessage alloc] initWithData:[GBossPBObject dataFromCString:pbBase.content()]];
                        msgBase.message = msgLoginACK;
                    }
                    break;
                case GBossMessageType_GetLastInfo_ACK:
                    {
                        GetLastInfoACKMessage *msgLastInfoACK = [[GetLastInfoACKMessage alloc] initWithData:[GBossPBObject dataFromCString:pbBase.content()]];
                        msgBase.message = msgLastInfoACK;
                    }
                    break;
                case GBossMessageType_GetHistoryInfo_ACK:
                    {
                        GetHistoryInfoACKMessage *msgHistoryInfoACK = [[GetHistoryInfoACKMessage alloc] initWithData:[GBossPBObject dataFromCString:pbBase.content()]];
                        msgBase.message = msgHistoryInfoACK;
                    }
                    break;
                case GBossMessageType_AddMonitor_ACK:
                    {
                        AddMonitorACKMessage *msgAddMonitorACK = [[AddMonitorACKMessage alloc] initWithData:[GBossPBObject dataFromCString:pbBase.content()]];
                        msgBase.message = msgAddMonitorACK;
                    }
                    break;
                case GBossMessageType_RemoveMonitor_ACK:
                    {
                        RemoveMonitorACKMessage *msgRemoveMonitor = [[RemoveMonitorACKMessage alloc] initWithData:[GBossPBObject dataFromCString:pbBase.content()]];
                        msgBase.message = msgRemoveMonitor;
                    }
                    break;
                case GBossMessageType_ActiveLink_ACK:
                    break;
                case GBossMessageType_DeliverGPS:
                    {
                        DeliverGPSMessage *msgDeliverGPS = [[DeliverGPSMessage alloc] initWithData:[GBossPBObject dataFromCString:pbBase.content()]];
                        msgBase.message = msgDeliverGPS;
                    }
                    break;
                case GBossMessageType_DeliverTravel:
                    {
                        DeliverTravelMessage *msgDeliverTravel = [[DeliverTravelMessage alloc] initWithData:[GBossPBObject dataFromCString:pbBase.content()]];
                        msgBase.message = msgDeliverTravel;
                    }
                    break;
                case GBossMessageType_DeliverFault:
                    {
                        DeliverFaultMessage *msgDeliverFault = [[DeliverFaultMessage alloc] initWithData:[GBossPBObject dataFromCString:pbBase.content()]];
                        msgBase.message = msgDeliverFault;
                    }
                    break;
                case GBossMessageType_DeliverAlarm:
                    {
                        DeliverAlarmMessage *msgDeliverAlarm = [[DeliverAlarmMessage alloc] initWithData:[GBossPBObject dataFromCString:pbBase.content()]];
                        msgBase.message = msgDeliverAlarm;
                    }
                    break;
                case GBossMessageType_DeliverAppNotice:
                    {
                        DeliverAppNoticeMessage *msgDeliverAppNotice = [[DeliverAppNoticeMessage alloc] initWithData:[GBossPBObject dataFromCString:pbBase.content()]];
                        msgBase.message = msgDeliverAppNotice;
                    }
                    break;
                case GBossMessageType_SendCommand_ACK:
                    {
                        SendCommandACKMessage *msgSendCommand = [[SendCommandACKMessage alloc] initWithData:[GBossPBObject dataFromCString:pbBase.content()]];
                        msgBase.message = msgSendCommand;
                    }
                    break;
                case GBossMessageType_SendCommandSend_ACK:
                    {
                        SendCommandSendACKMessage *msgSendCommand = [[SendCommandSendACKMessage alloc] initWithData:[GBossPBObject dataFromCString:pbBase.content()]];
                        msgBase.message = msgSendCommand;
                    }
                    break;
            }
            [_messages addObject:msgBase];
        }
        
        free(pbCenter);
    }
    return self;
}

- (NSMutableArray *)messages
{
    if (_messages == nil)
        _messages = [[NSMutableArray alloc] init];
    return _messages;
}

- (NSData *)toData
{
    if (_messages == nil || _messages.count == 0)
        return nil;
    
    gboss::ComCenterMessage *pbCenter = new gboss::ComCenterMessage();
    
    for (ComCenterBaseMessage *msgBase in _messages)
    {
        gboss::ComCenterMessage_ComCenterBaseMessage *pbBase = pbCenter->add_messages();
        
        pbBase->set_id(msgBase.messageType);
        pbBase->set_content([msgBase.message toCString]);
    }
    
    std::string ps = pbCenter->SerializeAsString();
    NSData *dataCenter = [NSData dataWithBytes:ps.c_str() length:ps.size()];
    
    free(pbCenter);
    return dataCenter;
}

- (gboss::ComCenterMessage *)getMessageFromData:(NSData *)data
{
    int len = (int)[data length];
    char raw[len];
    gboss::ComCenterMessage *message = new gboss::ComCenterMessage;
    [data getBytes:raw length:len];
    message->ParseFromArray(raw, len);
    return message;
}

@end

#pragma mark - ComCenterBaseMessage

@implementation ComCenterBaseMessage

- (void)doSomething {
    gboss::Login *login = new gboss::Login();
    login->set_username("zhangxz");
    login->set_password("abc123");
    
    gboss::ComCenterMessage *centerMsg = new gboss::ComCenterMessage();
    gboss::ComCenterMessage_ComCenterBaseMessage *baseMsg = centerMsg->add_messages();
    baseMsg->set_id(GBossMessageType_Login);
    baseMsg->set_content(login->SerializeAsString());
    
    std::string ps = centerMsg->SerializeAsString();
    NSData *rawCenterMsg = [NSData dataWithBytes:ps.c_str() length:ps.size()];
    Byte *bytes = (Byte *)[rawCenterMsg bytes];
    NSString *s = [GBossPBObject objcStringFromCString:ps];
    NSLog(@"Final message: %@", s);
    
    for (int i = 0; i < 24; i++)
        NSLog(@"%d", (int)bytes[i]);
    free(centerMsg);
    free(baseMsg);
    free(login);
}

- (NSData *)getDataForMessage:(gboss::ComCenterMessage_ComCenterBaseMessage *)message
{
    std::string ps = message->SerializeAsString();
    return [NSData dataWithBytes:ps.c_str() length:ps.size()];
}

- (NSString *)getByteStringForMessage:(gboss::ComCenterMessage_ComCenterBaseMessage *)message
{
    std::string ps = message->SerializeAsString();
    NSString *s = [GBossPBObject objcStringFromCString:ps];
    return s;
}

- (gboss::ComCenterMessage_ComCenterBaseMessage *)getMessageFromData:(NSData *)data
{
    int len = (int)[data length];
    char raw[len];
    gboss::ComCenterMessage_ComCenterBaseMessage *message = new gboss::ComCenterMessage_ComCenterBaseMessage;
    [data getBytes:raw length:len];
    message->ParseFromArray(raw, len);
    return message;
}

@end

#pragma mark - Authorization

#pragma mark - LoginMessage

@implementation LoginMessage

- (id)initWithData:(NSData *)data
{
    self = [super init];
    if (self)
    {
        gboss::Login *login = [self getMessageFromData:data];
        
        _userName = [GBossPBObject objcStringFromCString:login->username()];
        _password = [GBossPBObject objcStringFromCString:login->password()];
        
        free(login);
    }
    return self;
}

- (void)doSomething
{
    gboss::Login *login = new gboss::Login();
    login->set_username("zhangxz");
    login->set_password("abc123");
    
    std::string x = login->DebugString();
    NSString *output = [NSString stringWithCString:x.c_str() encoding:[NSString defaultCStringEncoding]];
    NSLog(@"loginMessage: %@", output);
    
    NSData *rawLogin = [self getDataForMessage:login];
    NSString *s = [self getByteStringForMessage:login];
    NSLog(@"%@", s);
    gboss::Login *otherLogin = [self getMessageFromData:rawLogin];
    
    NSString *newOutput = [NSString stringWithCString:otherLogin->DebugString().c_str() encoding:[NSString defaultCStringEncoding]];
    NSLog(@"other zombie: %@", newOutput);
    
    free(login);
    free(otherLogin);
}

-(std::string)toCString
{
    gboss::Login *login = new gboss::Login();
    
    login->set_username([GBossPBObject cstringFromObjcString:_userName]);
    login->set_password([GBossPBObject cstringFromObjcString:_password]);
    login->set_usertype([GBossPBObject cstringFromObjcString:_userType]);
    login->set_userversion([GBossPBObject cstringFromObjcString:_userVersion]);
    std::string ps = login->SerializeAsString();
    
    free(login);
    return ps;
}

- (NSData *)getDataForMessage:(gboss::Login *)message
{
    std::string ps = message->SerializeAsString();
    return [NSData dataWithBytes:ps.c_str() length:ps.size()];
}

- (NSString *)getByteStringForMessage:(gboss::Login *)message
{
    std::string ps = message->SerializeAsString();
    NSString *s = [GBossPBObject objcStringFromCString:ps];
    return s;
}

- (gboss::Login *)getMessageFromData:(NSData *)data
{
    int len = (int)[data length];
    char raw[len];
    gboss::Login *message = new gboss::Login;
    [data getBytes:raw length:len];
    message->ParseFromArray(raw, len);
    return message;
}

@end

#pragma mark - LoginACKMessage

@implementation LoginACKMessage

- (id)initWithData:(NSData *)data
{
    self = [super init];
    if (self)
    {
        gboss::Login_ACK *loginAck = [self getMessageFromData:data];
        
        _resultCode = (GBossResultCode)loginAck->retcode();
        _resultDescription = [GBossPBObject objcStringFromCString:loginAck->retmsg()];
        _userName = [GBossPBObject objcStringFromCString:loginAck->username()];
        
        free(loginAck);
    }
    return self;
}

- (gboss::Login_ACK *)getMessageFromData:(NSData *)data
{
    int len = (int)[data length];
    char raw[len];
    gboss::Login_ACK *message = new gboss::Login_ACK;
    [data getBytes:raw length:len];
    message->ParseFromArray(raw, len);
    return message;
}

@end

#pragma mark - OBD info

@implementation OBDInfoMessage

- (id)initWithPBObject:(gboss::OBDInfo &)obdInfo
{
    self = [super init];
    if (self)
    {
        _remainOil = obdInfo.has_remainoil() ? obdInfo.remainoil() : INT_MAX;
        _remainPercentOil = obdInfo.has_remainpercentoil() ? obdInfo.remainpercentoil() : INT_MAX;
        _averageOil = obdInfo.has_averageoil() ? obdInfo.averageoil() : INT_MAX;
        _hourOil = obdInfo.has_houroil() ? obdInfo.houroil() : INT_MAX;
        _totalDistance = obdInfo.has_totaldistance() ? obdInfo.totaldistance() : INT_MAX;
        _waterTemperature = obdInfo.has_watertemperature() ? obdInfo.watertemperature() : INT_MAX;
        _reviseOil = obdInfo.has_reviseoil() ? obdInfo.reviseoil() : INT_MAX;
        _rotationSpeed = obdInfo.has_rotationspeed() ? obdInfo.rotationspeed() : INT_MAX;
        _intakeAirTemperature = obdInfo.has_intakeairtemperature() ? obdInfo.intakeairtemperature() : INT_MAX;
        _airDischange = obdInfo.has_airdischange() ? obdInfo.airdischange() : INT_MAX;
        if (obdInfo.otherinfo_size())
        {
            _otherInfoes = [[NSMutableDictionary alloc] initWithCapacity:obdInfo.otherinfo_size()];
            for (int j = 0; j < obdInfo.otherinfo_size(); j++)
            {
                gboss::MapEntry map = obdInfo.otherinfo(j);
                [_otherInfoes setObject:[GBossPBObject objcStringFromCString:map.value()] forKey:[GBossPBObject objcStringFromCString:map.key()]];
            }
        }
        _speed = obdInfo.has_speed() ? obdInfo.speed() : INT_MAX;
        _remainDistance = obdInfo.has_remaindistance() ? obdInfo.remaindistance() : INT_MAX;
    }
    return self;
}

@end

@implementation GpsBaseInfoMessage

- (id)initWithPBObject:(gboss::GpsBaseInfo &)gpsBaseInfo
{
    self = [super init];
    if (self)
    {
        _gpsTime = gpsBaseInfo.gpstime();
        _loc = gpsBaseInfo.loc();
        _lat = gpsBaseInfo.lat();
        _lng = gpsBaseInfo.lng();
        _speed = gpsBaseInfo.speed();
        _course = gpsBaseInfo.course();
        if (gpsBaseInfo.status_size())
        {
            _status = [[NSMutableArray alloc] initWithCapacity:gpsBaseInfo.status_size()];
            for (int j = 0; j < gpsBaseInfo.status_size(); j++)
                [_status addObject:[NSNumber numberWithInt:gpsBaseInfo.status(j)]];
        }
        _totalDistance = gpsBaseInfo.totaldistance();
        _oil = gpsBaseInfo.oil();
        _oilPercent = gpsBaseInfo.oilpercent();
        _temperature1 = gpsBaseInfo.temperature1();
        _temperature2 = gpsBaseInfo.temperature2();
        if (gpsBaseInfo.appendparams_size())
        {
            _appendParams = [[NSMutableDictionary alloc] initWithCapacity:gpsBaseInfo.appendparams_size()];
            for (int j = 0; j < gpsBaseInfo.appendparams_size(); j++)
            {
                gboss::MapEntry map = gpsBaseInfo.appendparams(j);
                [_appendParams setObject:[GBossPBObject objcStringFromCString:map.value()] forKey:[GBossPBObject objcStringFromCString:map.key()]];
            }
        }
        
        // OBD Info
        gboss::OBDInfo obdInfo = gpsBaseInfo.obdinfo();
        _obdInfo = [[OBDInfoMessage alloc] initWithPBObject:obdInfo];
        
        // Fault Info
        if (gpsBaseInfo.has_faultlightstatus())
        {
            gboss::FaultLightStatus faultLightStatus = gpsBaseInfo.faultlightstatus();
            _faultLightStatus = [[FaultLightStatusMessage alloc] initWithPBObject:faultLightStatus];
        }
    }
    return self;
}

@end

@implementation GpsRoadInfoMessage

- (id)initWithPBObject:(gboss::GpsRoadInfo &)road
{
    self = [super init];
    if (self)
    {
        _name = [GBossPBObject objcStringFromCString:road.name()];
        _level = road.level();
        _distance = road.distance();
        _id = road.id();
        _latOnRoad = road.latonroad();
        _lngOnRoad = road.lngonroad();
    }
    return self;
}

@end

@implementation GpsPointInfoMessage

- (id)initWithPBObject:(gboss::GpsPointInfo &)point
{
    self = [super init];
    if (self)
    {
        _name = [GBossPBObject objcStringFromCString:point.name()];
        _type = point.type();
        _distance = point.distance();
        _id = point.id();
    }
    return self;
}

@end

@implementation GpsReferPositionMessage

- (id)initWithPBObject:(gboss::GpsReferPosition &)gpsPosition
{
    self = [super init];
    if (self)
    {
        _province = [GBossPBObject objcStringFromCString:gpsPosition.province()];
        _city = [GBossPBObject objcStringFromCString:gpsPosition.city()];
        _county = [GBossPBObject objcStringFromCString:gpsPosition.county()];
        if (gpsPosition.roads_size())
        {
            _roads = [[NSMutableArray alloc] initWithCapacity:gpsPosition.roads_size()];
            for (int j = 0; j < gpsPosition.roads_size(); j++)
            {
                gboss::GpsRoadInfo road = gpsPosition.roads(j);
                GpsRoadInfoMessage *msgRoad = [[GpsRoadInfoMessage alloc] initWithPBObject:road];
                [_roads addObject:msgRoad];
            }
        }
        if (gpsPosition.points_size())
        {
            _points = [[NSMutableArray alloc] initWithCapacity:gpsPosition.points_size()];
            for (int j = 0; j < gpsPosition.points_size(); j++)
            {
                gboss::GpsPointInfo point = gpsPosition.points(j);
                GpsPointInfoMessage *msgPoint = [[GpsPointInfoMessage alloc] initWithPBObject:point];
                [_points addObject:msgPoint];
            }
        }
    }
    return self;
}

@end

@implementation GpsInfoMessage

- (id)initWithPBObject:(gboss::GpsInfo &)gpsInfo
{
    self = [super init];
    if (self)
    {
        _callLetter = [GBossPBObject objcStringFromCString:gpsInfo.callletter()];
        _content = [GBossPBObject objcStringFromCString:gpsInfo.content()];
        _history = gpsInfo.has_history() ? gpsInfo.history() : 0;
        
        // --------------- Start GpsBase Info --------------- //
        gboss::GpsBaseInfo gpsBaseInfo = gpsInfo.baseinfo();
        GpsBaseInfoMessage *msgBaseInfo = [[GpsBaseInfoMessage alloc] initWithPBObject:gpsBaseInfo];
        _baseInfo = msgBaseInfo;
        
        
        // --------------- End GpsBase Info --------------- //
        
        // GpsReferPositin Info
        gboss::GpsReferPosition gpsPosition = gpsInfo.referposition();
        _referPosition = [[GpsReferPositionMessage alloc] initWithPBObject:gpsPosition];
    }
    return self;
}

@end

@implementation AlarmInfoMessage

- (id)initWithPBObject:(gboss::AlarmInfo &)alarmInfo
{
    self = [super init];
    if (self)
    {
        _callLetter = [GBossPBObject objcStringFromCString:alarmInfo.callletter()];
        _content = [GBossPBObject objcStringFromCString:alarmInfo.content()];
        _history = alarmInfo.history();
        
        // --------------- Start GpsBase Info --------------- //
        gboss::GpsBaseInfo gpsBaseInfo = alarmInfo.baseinfo();
        GpsBaseInfoMessage *msgBaseInfo = [[GpsBaseInfoMessage alloc] initWithPBObject:gpsBaseInfo];
        _baseInfo = msgBaseInfo;
        
        
        // --------------- End GpsBase Info --------------- //
        
        // GpsReferPositin Info
        gboss::GpsReferPosition gpsPosition = alarmInfo.referposition();
        _referPosition = [[GpsReferPositionMessage alloc] initWithPBObject:gpsPosition];
    }
    return self;
}

@end

@implementation TravelInfoMessage

- (id)initWithPBObject:(gboss::TravelInfo &)travel
{
    self = [super init];
    if (self)
    {
        _callLetter = [GBossPBObject objcStringFromCString:travel.callletter()];
        _startTime = travel.starttime();
        _endTime = travel.endtime();
        _distance = travel.distance();
        _maxSpeed = travel.maxspeed();
        _overSpeedTime = travel.overspeedtime();
        _quickBrakeCount = travel.quickbrakecount();
        _emergencyBrakeCount = travel.emergencybrakecount();
        _quickSpeedUpCount = travel.quickspeedupcount();
        _emergencySpeedUpCount = travel.emergencyspeedupcount();
        _averageSpeed = travel.averagespeed();
        _maxWaterTemperature = travel.maxwatertemperature();
        _maxRotationSpeed = travel.maxrotationspeed();
        _voltage = travel.voltage();
        _totalOil = travel.totaloil();
        _averageOil = travel.averageoil();
        _tiredDrivingTime = travel.tireddrivingtime();
        _serialNumber = travel.serialnumber();
        _averageRotationSpeed = travel.averagerotationspeed();
        _maxOil = travel.maxoil();
        _idleTime = travel.idletime();
        
        gboss::GpsBaseInfo startBaseInfo = travel.startgps();
        _startGps = [[GpsBaseInfoMessage alloc] initWithPBObject:startBaseInfo];
        gboss::GpsReferPosition startPosition = travel.startreferpos();
        _startReferPos = [[GpsReferPositionMessage alloc] initWithPBObject:startPosition];
        gboss::GpsBaseInfo endBaseInfo = travel.endgps();
        _endGps = [[GpsBaseInfoMessage alloc] initWithPBObject:endBaseInfo];
        gboss::GpsReferPosition endPosition = travel.endreferpos();
        _endReferPos = [[GpsReferPositionMessage alloc] initWithPBObject:endPosition];
    }
    return self;
}

@end

@implementation FaultDefineMessage

- (id)initWithPBObject:(gboss::FaultDefine &)faultDefine
{
    self = [super init];
    if (self)
    {
        _faultType = faultDefine.faulttype();
        if (faultDefine.faultcode_size())
        {
            _faultCode = [[NSMutableArray alloc] initWithCapacity:faultDefine.faultcode_size()];
            for (int i = 0; i < faultDefine.faultcode_size(); i++)
            {
                NSString *code = [GBossPBObject objcStringFromCString:faultDefine.faultcode(i)];
                [_faultCode addObject:code];
            }
        }
    }
    return self;
}

@end

@implementation FaultInfoMessage

- (id)initWithPBObject:(gboss::FaultInfo &)fault
{
    self = [super init];
    if (self)
    {
        _callLetter = [GBossPBObject objcStringFromCString:fault.callletter()];
        _faultTime = fault.faulttime();
        if (fault.faults_size())
        {
            _faults = [[NSMutableArray alloc] initWithCapacity:fault.faults_size()];
            for (int i = 0; i < fault.faults_size(); i++)
            {
                gboss::FaultDefine faultDefine = fault.faults(i);
                FaultDefineMessage *faultDefineMessage = [[FaultDefineMessage alloc] initWithPBObject:faultDefine];
                [_faults addObject:faultDefineMessage];
            }
        }
//        if (fault.faultcode_size())
//        {
//            _faultCode = [[NSMutableArray alloc] initWithCapacity:fault.faultcode_size()];
//            for (int i = 0; i < fault.faultcode_size(); i++)
//            {
//                NSString *faultCode = [GBossPBObject objcStringFromCString:fault.faultcode(i)];
//                [_faultCode addObject:faultCode];
//            }
//        }
    }
    return self;
}

@end

#pragma mark - GPS info

@implementation GetLastInfoMessage

-(std::string)toCString
{
    gboss::GetLastInfo *message = new gboss::GetLastInfo();
    
    message->set_infotype(_infoType);
    if (_callLetters && _callLetters.count > 0)
    {
        int i = 0;
        for (NSString *callLetter in _callLetters)
        {
            if (callLetter.length)
            {
                std::string *cl = message->add_callletters();
                *cl = [GBossPBObject cstringFromObjcString:callLetter];
                i++;
            }
        }
    }
    if (_sn.length)
        message->set_sn([GBossPBObject cstringFromObjcString:_sn]);
    std::string ps = message->SerializeAsString();
    
    free(message);
    return ps;
}

@end

@implementation GetLastInfoACKMessage

- (id)initWithData:(NSData *)data
{
    self = [super init];
    if (self)
    {
        gboss::GetLastInfo_ACK *message = [self getMessageFromData:data];
        
        _resultCode = (GBossResultCode)message->retcode();
        _resultDescription = [GBossPBObject objcStringFromCString:message->retmsg()];
        _sn = [GBossPBObject objcStringFromCString:message->sn()];
        
        // --------------- Start Gps Info --------------- //
        if (message->gpses_size())
        {
            _gpses = [[NSMutableArray alloc] initWithCapacity:message->gpses_size()];
            for (int i = 0; i < message->gpses_size(); i++)
            {
                gboss::GpsInfo gpsInfo = message->gpses(i);
                GpsInfoMessage *msgGpsInfo = [[GpsInfoMessage alloc] initWithPBObject:gpsInfo];
//                if (msgGpsInfo.baseInfo.loc)
                    [_gpses addObject:msgGpsInfo];
            }
        }
        // --------------- End Gps Info --------------- //
        
        // --------------- Start Travel Info --------------- //
        if (message->travels_size())
        {
            _travels = [[NSMutableArray alloc] initWithCapacity:message->travels_size()];
            for (int i = 0; i < message->travels_size(); i++)
            {
                gboss::TravelInfo travel = message->travels(i);
                TravelInfoMessage *msgTravel = [[TravelInfoMessage alloc] initWithPBObject:travel];
                [_travels addObject:msgTravel];
            }
        }
        // --------------- End Travel Info --------------- //
        
        // --------------- Start Fault Info --------------- //
        if (message->faults_size())
        {
            _faults = [[NSMutableArray alloc] initWithCapacity:message->faults_size()];
            for (int i = 0; i < message->faults_size(); i++)
            {
                gboss::FaultInfo fault = message->faults(i);
                FaultInfoMessage *msgFault = [[FaultInfoMessage alloc] initWithPBObject:fault];
                [_faults addObject:msgFault];
            }
        }
        // --------------- End Fault Info --------------- //
        
        free(message);
    }
    return self;
}

- (gboss::GetLastInfo_ACK *)getMessageFromData:(NSData *)data
{
    int len = (int)[data length];
    char raw[len];
    gboss::GetLastInfo_ACK *message = new gboss::GetLastInfo_ACK;
    [data getBytes:raw length:len];
    message->ParseFromArray(raw, len);
    return message;
}

@end

#pragma mark - History info

@implementation GetHistoryInfoMessage

-(std::string)toCString
{
    gboss::GetHistoryInfo *message = new gboss::GetHistoryInfo();
    
    message->set_infotype(_infoType);
    message->set_callletter([GBossPBObject cstringFromObjcString:_callLetter]);
    message->set_starttime(_starttime);
    message->set_endtime(_endtime);
    message->set_pagenumber(_pageNumber);
    message->set_totalnumber(_totalNumber);
    message->set_autonextpage(_autonextpage);
    message->set_reversed(_reversed);
    if (_sn.length)
        message->set_sn([GBossPBObject cstringFromObjcString:_sn]);
    std::string ps = message->SerializeAsString();
    
    free(message);
    return ps;

}

@end

@implementation GetHistoryInfoNextPageMessage

-(std::string)toCString
{
    gboss::GetHistoryInfoNextPage *message = new gboss::GetHistoryInfoNextPage();
    
    message->set_infotype(_infoType);
    message->set_callletter([GBossPBObject cstringFromObjcString:_callLetter]);
    if (_sn.length)
        message->set_sn([GBossPBObject cstringFromObjcString:_sn]);
    std::string ps = message->SerializeAsString();
    
    free(message);
    return ps;
    
}

@end

@implementation GetHistoryInfoACKMessage

- (id)initWithData:(NSData *)data
{
    self = [super init];
    if (self)
    {
        gboss::GetHistoryInfo_ACK *message = [self getMessageFromData:data];
        
        _resultCode = (GBossResultCode)message->retcode();
        _resultDescription = [GBossPBObject objcStringFromCString:message->retmsg()];
        _sn = [GBossPBObject objcStringFromCString:message->sn()];
        _lastPage = message->lastpage();
        
        // --------------- Start Gps Info --------------- //
        if (message->gpses_size())
        {
            _gpses = [[NSMutableArray alloc] initWithCapacity:message->gpses_size()];
            for (int i = 0; i < message->gpses_size(); i++)
            {
                gboss::GpsInfo gpsInfo = message->gpses(i);
                GpsInfoMessage *msgGpsInfo = [[GpsInfoMessage alloc] initWithPBObject:gpsInfo];
//                if (msgGpsInfo.baseInfo.loc)
                    [_gpses addObject:msgGpsInfo];
            }
        }
        // --------------- End Gps Info --------------- //
        
        // --------------- Start Travel Info --------------- //
        if (message->travels_size())
        {
            _travels = [[NSMutableArray alloc] initWithCapacity:message->travels_size()];
            for (int i = 0; i < message->travels_size(); i++)
            {
                gboss::TravelInfo travel = message->travels(i);
                TravelInfoMessage *msgTravel = [[TravelInfoMessage alloc] initWithPBObject:travel];
                [_travels addObject:msgTravel];
            }
        }
        // --------------- End Travel Info --------------- //
        
        // --------------- Start Fault Info --------------- //
        if (message->faults_size())
        {
            _faults = [[NSMutableArray alloc] initWithCapacity:message->faults_size()];
            for (int i = 0; i < message->faults_size(); i++)
            {
                gboss::FaultInfo fault = message->faults(i);
                FaultInfoMessage *msgFault = [[FaultInfoMessage alloc] initWithPBObject:fault];
                [_faults addObject:msgFault];
            }
        }
        // --------------- End Fault Info --------------- //
        
        free(message);
    }
    return self;
}

- (gboss::GetHistoryInfo_ACK *)getMessageFromData:(NSData *)data
{
    int len = (int)[data length];
    char raw[len];
    gboss::GetHistoryInfo_ACK *message = new gboss::GetHistoryInfo_ACK;
    [data getBytes:raw length:len];
    message->ParseFromArray(raw, len);
    return message;
}

@end

#pragma mark - Remote control

@implementation SendCommandMessage

-(std::string)toCString
{
    gboss::SendCommand *message = new gboss::SendCommand();
    
    if (_callLetters && _callLetters.count > 0)
    {
        int i = 0;
        for (NSString *callLetter in _callLetters)
        {
            if (callLetter.length)
            {
                std::string *cl = message->add_callletters();
                *cl = [GBossPBObject cstringFromObjcString:callLetter];
                i++;
            }
        }
    }
    if (_params && _params.count > 0)
    {
        int i = 0;
        for (NSString *param in _params)
        {
            if (param.length)
            {
                std::string *p = message->add_params();
                *p = [GBossPBObject cstringFromObjcString:param];
                i++;
            }
        }
    }
    message->set_cmdid(_cmdId);
    if (_ackProxy.length)
        message->set_ackproxy([GBossPBObject cstringFromObjcString:_ackProxy]);
    message->set_channelid(_channelId);
    if (_sn.length)
        message->set_sn([GBossPBObject cstringFromObjcString:_sn]);
    std::string ps = message->SerializeAsString();
    
    free(message);
    return ps;
}

@end

@implementation SendCommandACKMessage

- (id)initWithData:(NSData *)data
{
    self = [super init];
    if (self)
    {
        _isSendACK = NO;
        
        gboss::SendCommand_ACK *message = [self getMessageFromData:data];
        
        _resultCode = (GBossResultCode)message->retcode();
        _resultDescription = [GBossPBObject objcStringFromCString:message->retmsg()];
        _sn = [GBossPBObject objcStringFromCString:message->sn()];
        _callLetter = [GBossPBObject objcStringFromCString:message->callletter()];
        _cmdId = message->cmdid();
        if (message->params_size())
        {
            _params = [[NSMutableArray alloc] initWithCapacity:message->params_size()];
            for (int i = 0; i < message->params_size(); i++)
                [_params addObject:[GBossPBObject objcStringFromCString:message->params(i)]];
        }
        if (message->gpsinfo_size())
        {
            _gpsInfo = [[NSMutableArray alloc] initWithCapacity:message->gpsinfo_size()];
            for (int i = 0; i < message->gpsinfo_size(); i++)
            {
                gboss::GpsInfo gpsInfo = message->gpsinfo(i);
                GpsInfoMessage *msgGpsInfo = [[GpsInfoMessage alloc] initWithPBObject:gpsInfo];
                [_gpsInfo addObject:msgGpsInfo];
            }
        }
        
        free(message);
    }
    return self;
}

- (gboss::SendCommand_ACK *)getMessageFromData:(NSData *)data
{
    int len = (int)[data length];
    char raw[len];
    gboss::SendCommand_ACK *message = new gboss::SendCommand_ACK;
    [data getBytes:raw length:len];
    message->ParseFromArray(raw, len);
    return message;
}

@end

@implementation SendCommandSendACKMessage

- (id)initWithData:(NSData *)data
{
    self = [super init];
    if (self)
    {
        gboss::SendCommandSend_ACK *message = [self getMessageFromData:data];
        
        _resultCode = (GBossResultCode)message->retcode();
        _resultDescription = [GBossPBObject objcStringFromCString:message->retmsg()];
        _sn = [GBossPBObject objcStringFromCString:message->sn()];
        _callLetter = [GBossPBObject objcStringFromCString:message->callletter()];
        _cmdId = message->cmdid();
        
        free(message);
    }
    return self;
}

- (gboss::SendCommandSend_ACK *)getMessageFromData:(NSData *)data
{
    int len = (int)[data length];
    char raw[len];
    gboss::SendCommandSend_ACK *message = new gboss::SendCommandSend_ACK;
    [data getBytes:raw length:len];
    message->ParseFromArray(raw, len);
    return message;
}

@end

#pragma mark - Monitor

@implementation AddMonitorMessage

-(std::string)toCString
{
    gboss::AddMonitor *message = new gboss::AddMonitor();
    
    if (_callLetters && _callLetters.count > 0)
    {
        int i = 0;
        for (NSString *callLetter in _callLetters)
        {
            if (callLetter.length)
            {
                std::string *cl = message->add_callletters();
                *cl = [GBossPBObject cstringFromObjcString:callLetter];
                i++;
            }
        }
    }
    if (_infoTypes && _infoTypes.count > 0)
    {
        for (int i = 0; i < _infoTypes.count; i++)
            message->add_infotypes([[_infoTypes objectAtIndex:i] intValue]);
    }
    std::string ps = message->SerializeAsString();
    
    free(message);
    return ps;
}

@end

@implementation AddMonitorACKMessage

- (id)initWithData:(NSData *)data
{
    self = [super init];
    if (self)
    {
        gboss::AddMonitor_ACK *message = [self getMessageFromData:data];
        
        _resultCode = (GBossResultCode)message->retcode();
        _resultDescription = [GBossPBObject objcStringFromCString:message->retmsg()];
        if (message->callletters_size())
        {
            _callLetters = [[NSMutableArray alloc] initWithCapacity:message->callletters_size()];
            for (int i = 0; i < message->callletters_size(); i++)
                [_callLetters addObject:[GBossPBObject objcStringFromCString:message->callletters(i)]];
        }
        
        free(message);
    }
    return self;
}

- (gboss::AddMonitor_ACK *)getMessageFromData:(NSData *)data
{
    int len = (int)[data length];
    char raw[len];
    gboss::AddMonitor_ACK *message = new gboss::AddMonitor_ACK;
    [data getBytes:raw length:len];
    message->ParseFromArray(raw, len);
    return message;
}

@end

@implementation RemoveMonitorMessage

-(std::string)toCString
{
    gboss::AddMonitor *message = new gboss::AddMonitor();
    
    if (_callLetters && _callLetters.count > 0)
    {
        int i = 0;
        for (NSString *callLetter in _callLetters)
        {
            if (callLetter.length)
            {
                std::string *cl = message->add_callletters();
                *cl = [GBossPBObject cstringFromObjcString:callLetter];
                i++;
            }
        }
    }
    if (_infoTypes && _infoTypes.count > 0)
    {
        for (int i = 0; i < _infoTypes.count; i++)
            message->add_infotypes([[_infoTypes objectAtIndex:i] intValue]);
    }
    std::string ps = message->SerializeAsString();
    
    free(message);
    return ps;
}

@end

@implementation RemoveMonitorACKMessage

- (id)initWithData:(NSData *)data
{
    self = [super init];
    if (self)
    {
        gboss::RemoveMonitor_ACK *message = [self getMessageFromData:data];
        
        _resultCode = (GBossResultCode)message->retcode();
        _resultDescription = [GBossPBObject objcStringFromCString:message->retmsg()];
        if (message->callletters_size())
        {
            _callLetters = [[NSMutableArray alloc] initWithCapacity:message->callletters_size()];
            for (int i = 0; i < message->callletters_size(); i++)
                [_callLetters addObject:[GBossPBObject objcStringFromCString:message->callletters(i)]];
        }
        
        free(message);
    }
    return self;
}

- (gboss::RemoveMonitor_ACK *)getMessageFromData:(NSData *)data
{
    int len = (int)[data length];
    char raw[len];
    gboss::RemoveMonitor_ACK *message = new gboss::RemoveMonitor_ACK;
    [data getBytes:raw length:len];
    message->ParseFromArray(raw, len);
    return message;
}

@end

@implementation DeliverGPSMessage

- (id)initWithData:(NSData *)data
{
    self = [super init];
    if (self)
    {
        gboss::DeliverGPS *message = [self getMessageFromData:data];
        
        gboss::GpsInfo gpsInfo = message->gpsinfo();
        _gpsInfo = [[GpsInfoMessage alloc] initWithPBObject:gpsInfo];
        _gatewayId = message->gatewayid();
        _gatewayType = message->gatewaytype();
        
        free(message);
    }
    return self;
}

- (gboss::DeliverGPS *)getMessageFromData:(NSData *)data
{
    int len = (int)[data length];
    char raw[len];
    gboss::DeliverGPS *message = new gboss::DeliverGPS;
    [data getBytes:raw length:len];
    message->ParseFromArray(raw, len);
    return message;
}

@end

@implementation DeliverTravelMessage

- (id)initWithData:(NSData *)data
{
    self = [super init];
    if (self)
    {
        gboss::DeliverTravel *message = [self getMessageFromData:data];
        
        gboss::TravelInfo travelInfo = message->travelinfo();
        _travelInfo = [[TravelInfoMessage alloc] initWithPBObject:travelInfo];
        _gatewayId = message->gatewayid();
        _gatewayType = message->gatewaytype();
        
        free(message);
    }
    return self;
}

- (gboss::DeliverTravel *)getMessageFromData:(NSData *)data
{
    int len = (int)[data length];
    char raw[len];
    gboss::DeliverTravel *message = new gboss::DeliverTravel;
    [data getBytes:raw length:len];
    message->ParseFromArray(raw, len);
    return message;
}

@end

@implementation DeliverFaultMessage

- (id)initWithData:(NSData *)data
{
    self = [super init];
    if (self)
    {
        gboss::DeliverFault *message = [self getMessageFromData:data];
        
        gboss::FaultInfo faultInfo = message->faultinfo();
        _faultInfo = [[FaultInfoMessage alloc] initWithPBObject:faultInfo];
        _gatewayId = message->gatewayid();
        _gatewayType = message->gatewaytype();
        
        free(message);
    }
    return self;
}

- (gboss::DeliverFault *)getMessageFromData:(NSData *)data
{
    int len = (int)[data length];
    char raw[len];
    gboss::DeliverFault *message = new gboss::DeliverFault;
    [data getBytes:raw length:len];
    message->ParseFromArray(raw, len);
    return message;
}

@end

@implementation DeliverAlarmMessage

- (id)initWithData:(NSData *)data
{
    self = [super init];
    if (self)
    {
        gboss::DeliverAlarm *message = [self getMessageFromData:data];
        
        gboss::AlarmInfo alarmInfo = message->alarminfo();
        _alarmInfo = [[AlarmInfoMessage alloc] initWithPBObject:alarmInfo];
        _gatewayId = message->gatewayid();
        _gatewayType = message->gatewaytype();
        
        free(message);
    }
    return self;
}

- (gboss::DeliverAlarm *)getMessageFromData:(NSData *)data
{
    int len = (int)[data length];
    char raw[len];
    gboss::DeliverAlarm *message = new gboss::DeliverAlarm;
    [data getBytes:raw length:len];
    message->ParseFromArray(raw, len);
    return message;
}

@end

#pragma mark - Websocket Push Notice

@implementation AppNoticeInfoMessage

- (id)initWithPBObject:(gboss::AppNoticeInfo &)appNoticeInfo
{
    self = [super init];
    if (self)
    {
        _callLetter = [GBossPBObject objcStringFromCString:appNoticeInfo.callletter()];
        _title = [GBossPBObject objcStringFromCString:appNoticeInfo.title()];
        _content = [GBossPBObject objcStringFromCString:appNoticeInfo.content()];
        _cmdId = appNoticeInfo.cmdid();
        _cmdretcode = appNoticeInfo.cmdretcode();
        _cmdretmsg = [GBossPBObject objcStringFromCString:appNoticeInfo.cmdretmsg()];
        _noticetype = appNoticeInfo.noticetype();
        _alarmstatus = appNoticeInfo.alarmstatus();
        _cmdsn = [GBossPBObject objcStringFromCString:appNoticeInfo.cmdsn()];
        
        // --------------- Start GpsBase Info --------------- //
        gboss::GpsBaseInfo gpsBaseInfo = appNoticeInfo.baseinfo();
        GpsBaseInfoMessage *msgBaseInfo = [[GpsBaseInfoMessage alloc] initWithPBObject:gpsBaseInfo];
        _baseInfo = msgBaseInfo;
        
        
        // --------------- End GpsBase Info --------------- //
        
        // GpsReferPositin Info
        gboss::GpsReferPosition gpsPosition = appNoticeInfo.referposition();
        _referPosition = [[GpsReferPositionMessage alloc] initWithPBObject:gpsPosition];
    }
    return self;
}

@end

@implementation DeliverAppNoticeMessage

- (id)initWithData:(NSData *)data
{
    self = [super init];
    if (self)
    {
        gboss::DeliverAppNotice *message = [self getMessageFromData:data];
        
        gboss::AppNoticeInfo appNoticeInfo = message->noticeinfo();
        _noticeInfo = [[AppNoticeInfoMessage alloc] initWithPBObject:appNoticeInfo];
        _gatewayId = message->gatewayid();
        _gatewayType = message->gatewaytype();
        
        free(message);
    }
    return self;
}

- (gboss::DeliverAppNotice *)getMessageFromData:(NSData *)data
{
    int len = (int)[data length];
    char raw[len];
    gboss::DeliverAppNotice *message = new gboss::DeliverAppNotice;
    [data getBytes:raw length:len];
    message->ParseFromArray(raw, len);
    return message;
}

@end

#pragma mark - Fault Info

@implementation NodeLostInfoMessage

- (id)initWithPBObject:(gboss::NodeLostInfo &)nodeLostInfo
{
    self = [super init];
    if (self)
    {
        _abs = nodeLostInfo.has_abs() ? nodeLostInfo.abs() : INT_MAX;
        _esp = nodeLostInfo.has_esp() ? nodeLostInfo.esp() : INT_MAX;
        _ems = nodeLostInfo.has_ems() ? nodeLostInfo.ems() : INT_MAX;
        _peps = nodeLostInfo.has_peps() ? nodeLostInfo.peps() : INT_MAX;
        _tcu = nodeLostInfo.has_tcu() ? nodeLostInfo.tcu() : INT_MAX;
        _bcm = nodeLostInfo.has_bcm() ? nodeLostInfo.bcm() : INT_MAX;
        _icm = nodeLostInfo.has_icm() ? nodeLostInfo.icm() : INT_MAX;
    }
    return self;
}

@end

@implementation NodeFaultInfoMessage

- (id)initWithPBObject:(gboss::NodeFaultInfo &)nodeFaultInfo
{
    self = [super init];
    if (self)
    {
        _ebd = nodeFaultInfo.has_ebd() ? nodeFaultInfo.ebd() : INT_MAX;
        _abs = nodeFaultInfo.has_abs() ? nodeFaultInfo.abs() : INT_MAX;
        _esp = nodeFaultInfo.has_esp() ? nodeFaultInfo.esp() : INT_MAX;
        _svs = nodeFaultInfo.has_svs() ? nodeFaultInfo.svs() : INT_MAX;
        _mil = nodeFaultInfo.has_mil() ? nodeFaultInfo.mil() : INT_MAX;
        _tcu = nodeFaultInfo.has_tcu() ? nodeFaultInfo.tcu() : INT_MAX;
        _peps = nodeFaultInfo.has_peps() ? nodeFaultInfo.peps() : INT_MAX;
        _tbox = nodeFaultInfo.has_tbox() ? nodeFaultInfo.tbox() : INT_MAX;
    }
    return self;
}

@end

@implementation FaultLightStatusMessage

- (id)initWithPBObject:(gboss::FaultLightStatus &)faultLightStatus
{
    self = [super init];
    if (self)
    {
        gboss::NodeLostInfo nodeLostInfo = faultLightStatus.nodelostinfo();
        _nodeLostInfo = [[NodeLostInfoMessage alloc] initWithPBObject:nodeLostInfo];
        gboss::NodeFaultInfo nodeFaultInfo = faultLightStatus.nodefaultinfo();
        _nodeFaultInfo = [[NodeFaultInfoMessage alloc] initWithPBObject:nodeFaultInfo];
    }
    return self;
}

@end

@implementation ECUConfigMessage

- (id)initWithData:(NSData *)data
{
    self = [super init];
    if (self)
    {
        gboss::ECUConfig *message = [self getMessageFromData:data];
        
        _callLetter = [GBossPBObject objcStringFromCString:message->callletter()];
        _updateTime = message->updatetime();
        _abs = message->has_abs() ? message->abs() : INT_MAX;
        _esp = message->has_esp() ? message->esp() : INT_MAX;
        _srs = message->has_srs() ? message->srs() : INT_MAX;
        _ems = message->has_ems() ? message->ems() : INT_MAX;
        _immo = message->has_immo() ? message->immo() : INT_MAX;
        _peps = message->has_peps() ? message->peps() : INT_MAX;
        _bcm = message->has_bcm() ? message->bcm() : INT_MAX;
        _tcu = message->has_tcu() ? message->tcu() : INT_MAX;
        _tpms = message->has_tpms() ? message->tpms() : INT_MAX;
        _apm = message->has_apm() ? message->apm() : INT_MAX;
        _icm = message->has_icm() ? message->icm() : INT_MAX;
        _eps = message->has_eps() ? message->eps() : INT_MAX;
        
        free(message);
    }
    return self;
}

- (gboss::ECUConfig *)getMessageFromData:(NSData *)data
{
    int len = (int)[data length];
    char raw[len];
    gboss::ECUConfig *message = new gboss::ECUConfig;
    [data getBytes:raw length:len];
    message->ParseFromArray(raw, len);
    return message;
}

@end