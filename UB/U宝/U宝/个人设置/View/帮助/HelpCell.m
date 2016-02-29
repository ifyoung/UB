//
//  HelpCell.m
//  车圣U宝
//
//  Created by 冥皇剑 on 15/11/3.
//  Copyright © 2015年 朱鹏的Ma. All rights reserved.
//

#import "HelpCell.h"
#import "NSString+Utils.h"
#import "QuestionModel.h"
#import "QuestionFrameModel.h"

@interface HelpCell ()
@property (nonatomic, strong) UILabel *answerLabel;
@end

@implementation HelpCell

+(instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"cell";
    
    HelpCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[self alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        
    }

    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UILabel *answerLabel = [[UILabel alloc] init];
        answerLabel.font = [UIFont systemFontOfSize:14];
        answerLabel.numberOfLines = 0;
        [self.contentView addSubview:answerLabel];
        self.answerLabel = answerLabel;
        self.backgroundColor = IWColorAlpha(250, 250, 250, 0.5);
    }
    return self;
}


-(void)setQuestionFrameModel:(QuestionFrameModel *)questionFrameModel{
    _questionFrameModel = questionFrameModel;
    
    QuestionModel *questionModel = self.questionFrameModel.questionModel;
    self.answerLabel.text = questionModel.answers;
    
    self.answerLabel.frame = self.questionFrameModel.answersF;
}

-(NSArray *)answers{
    if (_answers == nil) {
        _answers = @[@"    U宝硬件1个、SIM卡1张（已插入硬件）、安装说明1份、外盒包装1套、合格证1张。",@"    赛格车圣绝不额外收费，包括SIM卡本身工本费及正常使用车圣U宝产生的流量费用， 但是，如果我们监测到异常状态，会在后台停止SIM卡工作，U宝也就无法继续工作。所以，请勿将U宝里自带的SIM卡拔出另用。",@"    车圣U宝是智能行车辅助设备，只读取车辆行车电脑数据、不写入数据，所以对车辆安全不会有影响；同时读取的车辆数据都在用户个人云端账户，保证数据的安全性。最后，U宝自身不带电源，所以不会有充电发热的问题。",@"    1、怎么样才算U宝安装成功呢？当您按照产品说明书把硬件与手机APP上绑定成功后，将U宝插入OBD接口，指示灯蓝灯闪烁后保持长亮即为安装成功。\n    2、车辆的OBD接口在哪？OBD接口一般在方向盘下方中控台附近（参考说明书配图）。如果仍然找不到，建议咨询汽车维修店铺。\n    3、什么情况可以申领OBD设备延长线？\n  （1）OBD接口有盖板，插入车宝后无法安装盖板。\n  （2）OBD接口距离脚踏板较近，影响行车安全。请联系U宝客服（0755-26719993），在核实您车辆OBD接口的具体情况，并确认安插不便后，为您发放OBD延长线。每位用户最多可领取一条延长线，发货时间约为3~5天左右。",@"    1.车圣U宝的收益由以下几个部分构成：\n    1)【绑定奖励】在您绑定车辆时，车圣U宝发放50元奖励。\n    2)	【安全驾驶奖励】根据您的驾驶行为，综合分析行车里程、时长、时间段、速度、急刹车、急加速等驾驶数据，给出当日行车安全驾驶评分。基于该评分，给予您不同金额的奖励。\n    3)【绿色出行奖励】车圣U宝提倡绿色出行，最高奖励200元。\n    4)【里程奖励】车圣U宝建议您少开车，一年行驶里程越低奖励越高，最高奖励300元。\n    5)【推荐奖励】推荐亲友参与安全驾驶奖励计划，可获得50元/人奖励，无上限。总收益=累计安全驾驶奖励+累计绿色出行奖励+累计推荐奖励+绑定奖励累计总收益，可用于您下一年度的车险保费返现，享受安全驾驶奖励服务是以用户在太平洋车险投保了车辆保险（须包含商业险）为前提的。为避免不必要的损失，请购买下一年车险后及时联系U宝客服（0755-26719993）。\n    2. 不开车也有收益吗？U宝用户如果24小时内不开车（00:00至次日24:00）将获得绿色出行收益，谢谢。\n    3. 用户安全驾驶奖励折扣方式：\n        出险情况=1:奖励折扣=60%。\n        出险情况=2:奖励折扣=30%。\n        出险情况=3:奖励折扣=0%。\n    备注：若用户在保险有效期内退保、或保险有效期内出险情况≥3次、或理赔金额超过5000元，奖励金额清零；若用户在在保险有效期内出险情况=0，则约定奖励服务继续生效；\n    4.每天的奖励什么时候到账？您今天的开车奖励将在次日的收益中看到。",@"    1、在地下车库信号不好，数据会不会丢失，或者有误差呢？在信号不好的地方，车圣U宝数据会存在设备内，等到了信号好的地方，数据会一并上传。一般不会丢失或误差，请放心使用。\n    2. 行车过程中，收益忽然没有了，这是什么情况？行车过程中，当车辆驶入无信号地区（如地下车库、山洞、隧道等），车圣U宝无法记录收益。"];
    }
    return _answers;
}

@end
