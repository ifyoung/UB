//
//  PeccancyCityseekVC.m
//  赛格车圣
//
//  Created by 朱鹏的Mac on 15/6/10.
//  Copyright (c) 2015年 朱鹏的Mac. All rights reserved.
//

#import "PeccancyCityseekVC.h"
#import "PeccancyCitySeekTBView.h"

@interface PeccancyCityseekVC ()<PeccancyCitySeekTBViewDelegate>{
    
    NSMutableArray *provinces;
}

@property(nonatomic,strong)PeccancyCitySeekTBView *tbview;

@property(nonatomic,strong)DynamicScrollView *selectedCity;

@end

@implementation PeccancyCityseekVC

- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"选择城市";
    
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    provinces = delegate.provinces;
    
    [self createTBView];
    
    [self location];
}


- (void)location{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if(delegate.userlocation) return;
    [delegate getUserLocation];
    delegate.block = ^{
        [SeekparamModel shareInstance].city = [SFHFKeychainUtils getPasswordForUsername:@"UserLocationCity" andServiceName:[[NSBundle mainBundle] bundleIdentifier] error:NULL];
        [SeekparamModel shareInstance].cityNickName = [SFHFKeychainUtils getPasswordForUsername:@"UserProvinceNickName1" andServiceName:[[NSBundle mainBundle] bundleIdentifier] error:NULL];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
        [_tbview reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    };
    if(![[NSUserDefaults standardUserDefaults] objectForKey:@"JUHEprovincesAndCitys"]){
        [delegate loadAllCitys];
    }
}


/*
 *   UITableView
 */
- (void)createTBView{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KSCREEWIDTH, KSCREEHEGIHT - 64) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
}

#pragma mark tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 2) return provinces.count;
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString  *identifier = @"PeccancyCityseekVCCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil){
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }

    if(indexPath.section == 0){
        
        static NSString  *identifier = @"PeccancyCityseekVCCell0";
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
        
        [cell.contentView addSubview:self.selectedCity];
        return cell;
    }
    else if(indexPath.section == 1){
        
         cell.imageView.image =  [UIImage changeImg:[UIImage imageNamed:@"违章地点"] size:CGSizeMake(25 / 2.0, 33 / 2.0)];
        
         NSString *locantion =  [SFHFKeychainUtils getPasswordForUsername:@"UserLocationCity" andServiceName:[[NSBundle mainBundle] bundleIdentifier] error:NULL];
        
        if(locantion.length != 0){
           cell.textLabel.text = KLocationCity;
        }
         cell.accessoryView = [self accessoryViewSelf];
  
        
    }else {
        
        if(indexPath.row > 4){
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.accessoryView = nil;
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.accessoryView = nil;
        }
        
        cell.imageView.image = nil;
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        cell.textLabel.text = provinces[indexPath.row][@"province"];
    }
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(section == 2)  return @"全部城市";
    if(section == 1)  return @"定位城市";
    return @"已选城市";
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  
    if (indexPath.section < 2)  return 50;
    return 44;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.section == 0)  return;
    if(indexPath.section == 1) {
        [appdelegate getUserLocation];
        return;
    }else {
        self.tbview.cityNames = [self CityNameOfProvice:provinces[indexPath.row][@"province"]];
        [self.view addSubview:self.tbview];
        [self moveTBViewToitsLocaiton:100];
    }
}



/*
 *   PeccancyCitySeekTBViewDelegate
 */
- (void)didSelectCitys:(NSString *)city{
    [SeekparamModel shareInstance].city  = city;
}


/*
 *   DynamicScrollViewDelegate
 */
//- (void)didDeleteWithCity:(NSString *)city{
////    [[SeekparamModel shareInstance].citys removeObject:city];
//}



/*
 *   getters
 */
- (PeccancyCitySeekTBView *)tbview{
    if(!_tbview){
     _tbview = [[PeccancyCitySeekTBView alloc
                                       ]initWithFrame:CGRectMake(KSCREEWIDTH, 0, KSCREEWIDTH - 80, KSCREEHEGIHT - 64) style:UITableViewStylePlain];
        [_tbview addShadow];
    }
    _tbview.citydelegate = self;
    return _tbview;
}
- (void)moveTBViewToitsLocaiton:(CGFloat)distance{
    [UIView animateWithDuration:.5 animations:^{
        _tbview.left = distance;
    }];
}

- (DynamicScrollView *)selectedCity{
    NSString *city = [SeekparamModel shareInstance].city;
    NSMutableArray *array = [NSMutableArray arrayWithObject:city];
    if(!_selectedCity){
      _selectedCity = [[DynamicScrollView alloc]initWithFrame:CGRectMake(0, 0, KSCREEWIDTH, 50) withImages:array ];
    }
    return _selectedCity;
}


- (UIView *)accessoryViewSelf{
    UIImage *img = [UIImage imageNamed:@"违章查询-问号"];
    UIImageView *imgv = [[UIImageView alloc]initWithImage:[UIImage changeImg:img size:CGSizeMake(30, 30)]];
    return (UIView *)imgv;
}


/*
 *   获取对应省份的所有城市
 */
- (NSArray *)CityNameOfProvice:(NSString *)proviceName{
    NSMutableArray *citiesNames = [NSMutableArray array];
    for(NSDictionary *dic in provinces){
        if([[dic objectForKey:@"province"] isEqualToString:proviceName]){
            for(NSDictionary *subDic in [dic objectForKey:@"citys"]){
                [citiesNames addObject:[subDic objectForKey:@"city_name"]];
            }
        }
    }
    return citiesNames;
}
@end
