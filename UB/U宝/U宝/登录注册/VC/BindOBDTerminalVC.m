//
//  BindOBDTerminalVC.m
//  赛格车圣
//
//  Created by 朱鹏的Mac on 15/8/19.
//  Copyright © 2015年 朱鹏的Mac. All rights reserved.
//

#import "BindOBDTerminalVC.h"
#import "ScanfOBDbarCodeVC.h"

@interface BindOBDTerminalVC (){
 
    UILabel *bottomLabel;
}

@end

@implementation BindOBDTerminalVC
- (BOOL)hidesBottomBarWhenPushed{
    return YES;
}

- (void)loadView{
    [super loadView];
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectZero];
    scrollView.contentSize = CGSizeMake(KSCREEWIDTH,KSCREEHEGIHT - 64 + 1);
    scrollView.showsVerticalScrollIndicator = NO;
    self.view = scrollView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"绑定OBD智能终端";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createSubViews];
}


/*
 *   createSubViews
 */
- (void)createSubViews{

    UILabel *topLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, 0, 20)];
    topLabel.text = @"温馨提示";
    topLabel.textColor = kColor;
    [topLabel sizeToFit];
    topLabel.center = CGPointMake(KSCREEWIDTH / 2.0, topLabel.center.y);
    [self.view addSubview:topLabel];

    UILabel *middleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, topLabel.bottom + 20, KSCREEWIDTH - 40, 0)];
    middleLabel.text = @"       为了更好的体验“车圣U宝”，请您进行一下步骤操作：";
    middleLabel.numberOfLines = 0;
    [middleLabel sizeToFit];
    [self.view addSubview:middleLabel];
    
    CGFloat left = 0;
    NSArray *titles = @[@"1、扫描OBD条形码",@"2、填写车牌号",@"3、选择里程奖励"];
    for(NSInteger i=0;i < 3;i++){
        UILabel *bottom = [[UILabel alloc]initWithFrame:CGRectMake(0,middleLabel.bottom + 20 + 30 * i, 0, 20)];
        bottom.text = titles[i];
        [bottom sizeToFit];
        bottom.center = CGPointMake(KSCREEWIDTH / 2.0, bottom.center.y);
        if(i==0){
           left = bottom.left;
        }else{
            bottom.left = left;
        }
        bottomLabel = bottom;
        [self.view addSubview:bottom];
    }
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.layer.cornerRadius = KSCREEWIDTH / 3.0 / 2.0;
    button.layer.masksToBounds = YES;
    button.userInteractionEnabled  = YES;
    button.showsTouchWhenHighlighted = YES;
    button.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    [button setTitleColor:[UIColor whiteColor]  forState:UIControlStateNormal];
    [button addTarget:self action:@selector(startAction) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = IWColor(38, 210, 77);
    [button setTitle:@"开始" forState:UIControlStateNormal];
    button.frame = CGRectMake(KSCREEWIDTH / 3.0, 0, KSCREEWIDTH / 3.0, KSCREEWIDTH / 3.0);
    button.center = CGPointMake(KSCREEWIDTH / 2.0, bottomLabel.bottom + (KSCREEHEGIHT - 64 - bottomLabel.bottom) / 2.0);
    [self.view addSubview:button];
}


/*
 *   开始扫描步骤
 */
- (void)startAction{

    ScanfOBDbarCodeVC *scan = [[ScanfOBDbarCodeVC alloc]init];
    [self.navigationController pushViewController:scan animated:YES];
}
@end
