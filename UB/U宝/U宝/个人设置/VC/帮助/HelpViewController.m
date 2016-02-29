//
//  HelpViewController.m
//  赛格车圣
//
//  Created by 朱鹏的Mac on 15/8/21.
//  Copyright (c) 2015年 朱鹏的Mac. All rights reserved.
//

#import "HelpViewController.h"
#import "HeaderView.h"
#import "QuestionModel.h"
#import "HelpCell.h"
#import "QuestionFrameModel.h"

@interface HelpViewController ()<HeaderViewDelegate,UIAlertViewDelegate>

@property(nonatomic,strong)UITableView *tbView;
@property(nonatomic,strong)NSArray *questions;
@property(nonatomic,strong)NSArray *questionGroups;
@property(nonatomic,strong)QuestionFrameModel *questionFrameModel;
@property(nonatomic,strong)QuestionModel *questionModel;


@end

@implementation HelpViewController

#pragma mark - lazy

-(QuestionFrameModel *)questionFrameModel{
    if (_questionFrameModel == nil) {
        _questionFrameModel = [[QuestionFrameModel alloc]init];
    }
    return _questionFrameModel;
}

-(QuestionModel *)questionModel{
    if (_questionModel == nil) {
        _questionModel = [[QuestionModel alloc]init];
    }
    return _questionModel;
}

-(NSArray *)questionGroups{
    if (_questionGroups == nil) {
        
        NSMutableArray *models = [NSMutableArray array];
        
        for (NSDictionary *dic in self.questions) {
            
            QuestionModel *qqGroip = [QuestionModel questionGroupWithDict:dic];
            [models addObject:qqGroip];
        }
        
        _questionGroups = models;
    }
    return _questionGroups;
}


-(NSArray *)questions{
    if (_questions == nil) {
        _questions = @[@{@"question":@"1.U宝的出厂标配是哪些?"},@{@"question":@"2.U宝的SIM卡要额外收费吗?"},@{@"question":@"3.U宝安全吗?"},@{@"question":@"4.安装及OBD问题"},@{@"question":@"5.收益及奖励问题"},@{@"question":@"6.其他问题"}];
    }
    return _questions;
}


-(UITableView *)tbView{
    if (_tbView == nil) {
        //高度需要减去导航栏高度才能显示全部内容，因为view的高度有一部分超出了屏幕
        _tbView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KSCREEWIDTH, KSCREEHEGIHT - 64) style:UITableViewStylePlain];
        _tbView.delegate = self;
        _tbView.dataSource = self;
        _tbView.backgroundColor = [UIColor clearColor];
        //去除cell分割线
        _tbView.separatorStyle = UITableViewCellSeparatorStyleNone;

        [self.view addSubview:_tbView];
    }
    return _tbView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"帮助";
    [self createHeaderView];
    [self leftButtonItem];
    [self rightButtonItem];
    [self swipeGestureRecognizer];
}



-(void)createHeaderView{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KSCREEWIDTH, 60)];
    UIView *blueView = [[UIView alloc]init];
    CGPoint center = blueView.center;
    center.x = 15;
    center.y = headerView.center.y - 10;
    blueView.center = center;
    blueView.height = headerView.height / 3;
    blueView.width = 2;
    blueView.backgroundColor = kColor;
    [headerView addSubview:blueView];
    CGFloat xLabel = CGRectGetMaxX(blueView.frame) + 3;
    UILabel *headerLabel = [[UILabel alloc]initWithFrame:CGRectMake(xLabel, 0, KSCREEWIDTH, 60)];
    headerLabel.text = @"热点问题";
    headerLabel.textColor = [UIColor redColor];
    [headerView addSubview:headerLabel];
    self.tbView.tableHeaderView = headerView;
}

#pragma mark - tableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    QuestionModel *group = self.questionGroups[section];
    
    if (group.isOpen) {
        return 1;
    }else{
        
        return 0;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.questionGroups.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HelpCell *hc = [HelpCell cellWithTableView:tableView];
    self.questionModel.answers = hc.answers[indexPath.section];
    self.questionFrameModel.questionModel = self.questionModel;
    hc.questionFrameModel = self.questionFrameModel;
    return hc;
}

#pragma mark - tableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    HeaderView *HV = [HeaderView headerViewWithTableView:tableView];
    HV.delegate = self;
    QuestionModel *qGroup =  self.questionGroups[section];
    HV.questionGroup = qGroup;
    return HV;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (iOS8Earlier) {
        
        return [self rowHeight:indexPath];
        
    }else{//ios7下有BUG
        QuestionFrameModel *questionFrame = self.questionFrameModel;
        return questionFrame.cellHeight;
    }
}

//ios7计算cell高度临时方法
-(CGFloat)rowHeight:(NSIndexPath *)indexPath{
    int H = 0;
    switch (indexPath.section) {
        case 0:
            H = 44;
            break;
        case 1:
            H = 95;
            break;
        case 2:
            H = 95;
            break;
        case 3:
            H = 260;
            break;
        case 4:
            H = 545;
            break;
        case 5:
            H = 142;
            break;
    }
    return H;
}

#pragma mark - HeaderViewDelegate
-(void)headerViewDidClickHeaderView:(HeaderView *)headerView{
    
    [self.tbView reloadData];
}

/*
 *   rightBarButtonItem
 */
- (void)rightButtonItem{
    self.navigationItem.rightBarButtonItem = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.imageView.contentMode = UIViewContentModeCenter;
        button.imageView.clipsToBounds = NO;
        [button setImage:[UIImage changeImg:[UIImage imageNamed:@"me_h5_call_icon"] size:CGSizeMake(25, 21)] forState:UIControlStateNormal];
        [button setImage:[UIImage changeImg:[UIImage imageNamed:@"客服logo蓝色"] size:CGSizeMake(25, 21)] forState:UIControlStateHighlighted];
        button.frame = CGRectMake(0, 0, 50, 42);
        [button addTarget:self action:@selector(callCenter) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *barItem = [[UIBarButtonItem alloc]initWithCustomView:button];
        barItem;
    });
}

-(void)callCenter{
    
    
    if ([UIDevice currentDevice].systemVersion.doubleValue >= 8.0){
#ifdef __IPHONE_8_0

        UIAlertController *av = [UIAlertController alertControllerWithTitle:@"需要帮助吗？" message:@"拨打客服中心热线0755-26719993" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self callUp];
        }];
        [av addAction:cancel];
        [av addAction:confirm];
        [self presentViewController:av animated:YES completion:nil];
#endif
    }else{
    
        UIAlertView *AV = [[UIAlertView alloc]initWithTitle:@"需要帮助吗？" message:@"拨打客服中心热线0755-26719993" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        
        [AV show];
    }
}

/**
 *  客服热线
 */
-(void)callUp{
    NSURL *telUrl = [NSURL URLWithString:@"tel://0755-26719993"];
    [[UIApplication sharedApplication]openURL:telUrl];
}

#pragma mark - UIAlertViewDelegate iOS7
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [self callUp];
    }
}

@end
