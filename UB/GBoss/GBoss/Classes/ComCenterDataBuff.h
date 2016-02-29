//
//  ComCenterDataBuff.h
//  testpb
//
//  Created by SG on 14-6-12.
//  Copyright (c) 2014年 ChinaGPS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageType.h"
#import "ResultCode.h"

@interface GBossPBObject : NSObject

- (void)doSomething;
- (id)initWithData:(NSData *)data;
- (NSData *)toData;

@end

@interface ComCenterMessage : GBossPBObject

@property (nonatomic, strong) NSMutableArray *messages;

@end

@interface ComCenterBaseMessage : GBossPBObject

@property (nonatomic, assign) GBossMessageType messageType;
@property (nonatomic, strong) GBossPBObject *message;

@end

#pragma mark - Authorization

@interface LoginMessage : GBossPBObject

@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *userType;
@property (nonatomic, strong) NSString *userVersion;

@end

@interface LoginACKMessage : GBossPBObject

@property (nonatomic, assign) GBossResultCode resultCode;
@property (nonatomic, strong) NSString *resultDescription;
@property (nonatomic, strong) NSString *userName;

@end

#pragma mark - Fault Info

@interface NodeLostInfoMessage : GBossPBObject

@property (nonatomic, assign) int abs;
@property (nonatomic, assign) int esp;
@property (nonatomic, assign) int ems;
@property (nonatomic, assign) int peps;
@property (nonatomic, assign) int tcu;
@property (nonatomic, assign) int bcm;
@property (nonatomic, assign) int icm;

@end

@interface NodeFaultInfoMessage : GBossPBObject

@property (nonatomic, assign) int ebd;
@property (nonatomic, assign) int abs;
@property (nonatomic, assign) int esp;
@property (nonatomic, assign) int svs;
@property (nonatomic, assign) int mil;
@property (nonatomic, assign) int tcu;
@property (nonatomic, assign) int peps;
@property (nonatomic, assign) int tbox;

@end

@interface FaultLightStatusMessage : GBossPBObject

@property (nonatomic, strong) NodeLostInfoMessage *nodeLostInfo;
@property (nonatomic, strong) NodeFaultInfoMessage *nodeFaultInfo;

@end

@interface ECUConfigMessage : GBossPBObject

@property (nonatomic, strong) NSString *callLetter;
@property (nonatomic, assign) long long updateTime;
@property (nonatomic, assign) int abs;
@property (nonatomic, assign) int esp;
@property (nonatomic, assign) int srs;
@property (nonatomic, assign) int ems;
@property (nonatomic, assign) int immo;
@property (nonatomic, assign) int peps;
@property (nonatomic, assign) int bcm;
@property (nonatomic, assign) int tcu;
@property (nonatomic, assign) int tpms;
@property (nonatomic, assign) int apm;
@property (nonatomic, assign) int icm;
@property (nonatomic, assign) int eps;

@end

#pragma mark - OBD info

@interface OBDInfoMessage : GBossPBObject

@property (nonatomic, assign) int remainOil;
@property (nonatomic, assign) int remainPercentOil;
@property (nonatomic, assign) int averageOil;
@property (nonatomic, assign) int hourOil;
@property (nonatomic, assign) int totalDistance;
@property (nonatomic, assign) int waterTemperature;
@property (nonatomic, assign) int reviseOil;
@property (nonatomic, assign) int rotationSpeed;
@property (nonatomic, assign) int intakeAirTemperature;
@property (nonatomic, assign) int airDischange;
@property (nonatomic, strong) NSMutableDictionary *otherInfoes;
@property (nonatomic, assign) int speed;
@property (nonatomic, assign) int remainDistance;

@end

@interface GpsBaseInfoMessage : GBossPBObject

@property (nonatomic, assign) long long gpsTime;
@property (nonatomic, assign) BOOL loc;
@property (nonatomic, assign) int lat;
@property (nonatomic, assign) int lng;
@property (nonatomic, assign) int speed;
@property (nonatomic, assign) int course;
@property (nonatomic, strong) NSMutableArray *status;
@property (nonatomic, assign) int totalDistance;
@property (nonatomic, assign) int oil;
@property (nonatomic, assign) int oilPercent;
@property (nonatomic, assign) int temperature1;
@property (nonatomic, assign) int temperature2;
@property (nonatomic, strong) NSMutableDictionary *appendParams;
@property (nonatomic, strong) OBDInfoMessage *obdInfo;
@property (nonatomic, strong) FaultLightStatusMessage *faultLightStatus;

@end

@interface GpsRoadInfoMessage : GBossPBObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) int level;
@property (nonatomic, assign) int distance;
@property (nonatomic, assign) int id;
@property (nonatomic, assign) int latOnRoad;
@property (nonatomic, assign) int lngOnRoad;

@end

@interface GpsPointInfoMessage : GBossPBObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) int type;
@property (nonatomic, assign) int distance;
@property (nonatomic, assign) int id;

@end

@interface GpsReferPositionMessage : GBossPBObject

@property (nonatomic, strong) NSString *province;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *county;
@property (nonatomic, strong) NSMutableArray *roads;
@property (nonatomic, strong) NSMutableArray *points;

@end

@interface GpsInfoMessage : GBossPBObject

@property (nonatomic, strong) NSString *callLetter;
@property (nonatomic, strong) GpsBaseInfoMessage *baseInfo;
@property (nonatomic, strong) GpsReferPositionMessage *referPosition;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, assign) int history;

@end

@interface TravelInfoMessage : GBossPBObject

@property (nonatomic, strong) NSString *callLetter;
@property (nonatomic, assign) long long startTime;
@property (nonatomic, assign) long long endTime;
@property (nonatomic, assign) int distance;
@property (nonatomic, assign) int maxSpeed;
@property (nonatomic, assign) int overSpeedTime;
@property (nonatomic, assign) int quickBrakeCount;
@property (nonatomic, assign) int emergencyBrakeCount;
@property (nonatomic, assign) int quickSpeedUpCount;
@property (nonatomic, assign) int emergencySpeedUpCount;
@property (nonatomic, assign) int averageSpeed;
@property (nonatomic, assign) int maxWaterTemperature;
@property (nonatomic, assign) int maxRotationSpeed;
@property (nonatomic, assign) int voltage;
@property (nonatomic, assign) int totalOil;
@property (nonatomic, assign) int averageOil;
@property (nonatomic, assign) int tiredDrivingTime;
@property (nonatomic, assign) int serialNumber;
@property (nonatomic, assign) int averageRotationSpeed;
@property (nonatomic, assign) int maxOil;
@property (nonatomic, assign) int idleTime;
@property (nonatomic, strong) GpsBaseInfoMessage *startGps;
@property (nonatomic, strong) GpsReferPositionMessage *startReferPos;
@property (nonatomic, strong) GpsBaseInfoMessage *endGps;
@property (nonatomic, strong) GpsReferPositionMessage *endReferPos;

@end

@interface FaultDefineMessage : GBossPBObject

@property (nonatomic, assign) int faultType;
@property (nonatomic, strong) NSMutableArray *faultCode;

@end

@interface FaultInfoMessage : GBossPBObject

@property (nonatomic, strong) NSString *callLetter;
@property (nonatomic, assign) long long faultTime;
@property (nonatomic, strong) NSMutableArray *faults;

@end

//@interface FaultInfoMessage : GBossPBObject
//
//@property (nonatomic, strong) NSString *callLetter;
//@property (nonatomic, assign) long long faultTime;
//@property (nonatomic, strong) NSMutableArray *faultCode;
//
//@end

@interface AlarmInfoMessage : GBossPBObject

@property (nonatomic, strong) NSString *callLetter;
@property (nonatomic, strong) GpsBaseInfoMessage *baseInfo;
@property (nonatomic, strong) GpsReferPositionMessage *referPosition;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, assign) int history;

@end

#pragma mark - GPS info

@interface GetLastInfoMessage : GBossPBObject

@property (nonatomic, assign) GBossMessageType infoType;
@property (nonatomic, strong) NSMutableArray *callLetters;
@property (nonatomic, strong) NSString *sn;

@end

@interface GetLastInfoACKMessage : GBossPBObject

@property (nonatomic, assign) GBossResultCode resultCode;
@property (nonatomic, strong) NSString *resultDescription;
@property (nonatomic, strong) NSMutableArray *gpses;
@property (nonatomic, strong) NSMutableArray *travels;
@property (nonatomic, strong) NSMutableArray *faults;
@property (nonatomic, strong) NSString *sn;

@end

#pragma mark - History info

@interface GetHistoryInfoMessage : GBossPBObject

@property (nonatomic, strong) NSString *callLetter;
@property (nonatomic, assign) int infoType;
@property (nonatomic, assign) long long starttime;
@property (nonatomic, assign) long long endtime;
@property (nonatomic, assign) int pageNumber;
@property (nonatomic, assign) int totalNumber;
@property (nonatomic, assign) BOOL autonextpage;
@property (nonatomic, strong) NSString *sn;
@property (nonatomic, assign) BOOL reversed;

@end

@interface GetHistoryInfoNextPageMessage : GBossPBObject

@property (nonatomic, strong) NSString *callLetter;
@property (nonatomic, assign) int infoType;
@property (nonatomic, strong) NSString *sn;

@end

@interface GetHistoryInfoACKMessage : GBossPBObject

@property (nonatomic, assign) GBossResultCode resultCode;
@property (nonatomic, strong) NSString *resultDescription;
@property (nonatomic, assign) BOOL lastPage;
@property (nonatomic, strong) NSMutableArray *gpses;
@property (nonatomic, strong) NSMutableArray *travels;
@property (nonatomic, strong) NSMutableArray *faults;
@property (nonatomic, strong) NSString *sn;

@end

#pragma mark - Remote control

@interface SendCommandMessage : GBossPBObject

@property (nonatomic, strong) NSMutableArray *callLetters;
@property (nonatomic, assign) int cmdId;
@property (nonatomic, strong) NSMutableArray *params;
@property (nonatomic, strong) NSString *ackProxy;
@property (nonatomic, assign) int channelId;
@property (nonatomic, strong) NSString *sn;

@end

@interface SendCommandACKMessage : GBossPBObject

@property (nonatomic, assign) GBossResultCode resultCode;
@property (nonatomic, strong) NSString *resultDescription;
@property (nonatomic, strong) NSString *callLetter;
@property (nonatomic, assign) int cmdId;
@property (nonatomic, strong) NSMutableArray *params;
@property (nonatomic, strong) NSMutableArray *gpsInfo;
@property (nonatomic, strong) NSString *sn;
@property (nonatomic, assign) BOOL isSendACK;

@end

@interface SendCommandSendACKMessage : GBossPBObject

@property (nonatomic, assign) GBossResultCode resultCode;
@property (nonatomic, strong) NSString *resultDescription;
@property (nonatomic, strong) NSString *callLetter;
@property (nonatomic, assign) int cmdId;
@property (nonatomic, strong) NSString *sn;

@end

#pragma mark - Monitor

@interface AddMonitorMessage : GBossPBObject

@property (nonatomic, strong) NSMutableArray *callLetters;
@property (nonatomic, strong) NSMutableArray *infoTypes;

@end

@interface AddMonitorACKMessage : GBossPBObject

@property (nonatomic, assign) GBossResultCode resultCode;
@property (nonatomic, strong) NSString *resultDescription;
@property (nonatomic, strong) NSMutableArray *callLetters;

@end

@interface RemoveMonitorMessage : GBossPBObject

@property (nonatomic, strong) NSMutableArray *callLetters;
@property (nonatomic, strong) NSMutableArray *infoTypes;

@end

@interface RemoveMonitorACKMessage : GBossPBObject

@property (nonatomic, assign) GBossResultCode resultCode;
@property (nonatomic, strong) NSString *resultDescription;
@property (nonatomic, strong) NSMutableArray *callLetters;

@end

@interface DeliverGPSMessage : GBossPBObject

@property (nonatomic, strong) GpsInfoMessage *gpsInfo;
@property (nonatomic, assign) int gatewayId;
@property (nonatomic, assign) int gatewayType;

@end

@interface DeliverTravelMessage : GBossPBObject

@property (nonatomic, strong) TravelInfoMessage *travelInfo;
@property (nonatomic, assign) int gatewayId;
@property (nonatomic, assign) int gatewayType;

@end

@interface DeliverFaultMessage : GBossPBObject

@property (nonatomic, strong) FaultInfoMessage *faultInfo;
@property (nonatomic, assign) int gatewayId;
@property (nonatomic, assign) int gatewayType;

@end

@interface DeliverAlarmMessage : GBossPBObject

@property (nonatomic, strong) AlarmInfoMessage *alarmInfo;
@property (nonatomic, assign) int gatewayId;
@property (nonatomic, assign) int gatewayType;

@end

#pragma mark - Websocket Push Notice

@interface AppNoticeInfoMessage : GBossPBObject

@property (nonatomic, strong) NSString *callLetter;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) GpsBaseInfoMessage *baseInfo;
@property (nonatomic, strong) GpsReferPositionMessage *referPosition;
@property (nonatomic, assign) int cmdId;
@property (nonatomic, assign) int cmdretcode;
@property (nonatomic, strong) NSString *cmdretmsg;
@property (nonatomic, assign) int noticetype;
@property (nonatomic, assign) int alarmstatus;
@property (nonatomic, strong) NSString *cmdsn;

@end

@interface DeliverAppNoticeMessage : GBossPBObject

@property (nonatomic, strong) AppNoticeInfoMessage *noticeInfo;
@property (nonatomic, assign) int gatewayId;
@property (nonatomic, assign) int gatewayType;

@end
