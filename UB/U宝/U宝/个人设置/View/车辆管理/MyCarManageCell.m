//
//  MyCarManageCell.m
//  UBI
//
//  Created by 冥皇剑 on 15/9/24.
//  Copyright © 2015年 minghuangjian. All rights reserved.
//

#import "MyCarManageCell.h"
#import "BindingCarListModel.h"

@interface MyCarManageCell()

@end

@implementation MyCarManageCell

- (void)awakeFromNib {
   
}

-(void)setModel:(BindingCarListModel *)model{
    _model = model;
    [self setNeedsLayout];
}

-(void)layoutSubviews{
    [self settings];
    [super layoutSubviews];
}

-(void)settings{
    
    _plateNOLabel.text = _model.plateNo;
    _plateNOLabel.layer.cornerRadius = 3;
    
    //设置了masksToBounds，cornerRadius才能显示
    _plateNOLabel.layer.masksToBounds = YES;
    self.plateNOLabel.backgroundColor = IWColor(27, 162, 230);
    
    _selectedImageView.contentMode = UIViewContentModeCenter;
    
    _carView.layer.cornerRadius = 5;
    
    _lineView.backgroundColor = IWColor(239, 239, 239);
    
    _SNLabel.text = _model.imei;
    //放检索后不会出现具体型号
//    _carModelLabel.text = _model.brand;
    
    _carImageView.contentMode = UIViewContentModeScaleAspectFit;
    _carImageView.clipsToBounds = YES;
    if(_model.callLetter.length != 0){
        _carImageView.image = [UIImage imageNamed:@"设备车辆"];
        _carModelLabel.text = @"无法识别该车型";
    }else{
        _carImageView.image = [UIImage imageNamed:@"非设备车辆"];
    }
    
    if(_model.callLetter.length != 0){
        
        for(int i = 0;i < _model.brand.length;i++){
            if(i == 0 || i == 1) continue;
            NSRange rang = NSMakeRange(0, i);
            NSString *substring = [_model.brand substringWithRange:rang];
            
            UIImage *img = [UIImage imageNamed:substring];
            if(img){
                _carImageView.image = img;
//                _carModelLabel.text = substring;
                break;
            }
            _carImageView.image = [UIImage imageNamed:@"设备车辆"];
        }
    }else{
        _carImageView.image = [UIImage imageNamed:@"非设备车辆"];
    }
    
    //2.删除末尾英文
    NSString *chinese = @"";
    for(int i=0; i< _model.brand.length ;i++){
        NSRange rang = NSMakeRange(i, 1);
        NSString *substring = [_model.brand substringWithRange:rang];
        //unichar c = [_model.brand characterAtIndex:i];
        int a = [_model.brand characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff)//中文
        {
            NSLog(@"是中文");
            
            chinese = [chinese  stringByAppendingString:substring];
        }else{
            break;
        }
    }
    
    _model.brand = chinese;
    
    //需要删除末尾英文才能从后面检索到
    if (_model.callLetter.length != 0) {

        //4.从后面开始检索
        for(int i = 0;i <= _model.brand.length;i++){
            
            NSLog(@"%d",i);
            
            if(i == 0 || i == 1) continue;
            
            
            NSRange rang = NSMakeRange(_model.brand.length - i, i);
            NSString *substring = [_model.brand substringWithRange:rang];
            
            UIImage *img = [UIImage imageNamed:substring];
            if(img){
                _carImageView.image = img;
//                _carModelLabel.text = substring;
                break;
            }
        }
    }
    //放检索前面技能显示具体型号，点击是具体型号消失
    if (_model.brand.length != 0) {
        
        _carModelLabel.text = _model.brand;
    }
}



-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    if (highlighted) {
        
        self.carView.backgroundColor = [UIColor whiteColor];
    }else{
        self.carView.backgroundColor = [UIColor whiteColor];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    if (selected) {
//        self.selectedImageView.hidden = NO;
        self.carView.layer.borderColor = kColor.CGColor;
        self.carView.layer.borderWidth = 2;
        self.selectedImageView.image = [UIImage imageNamed:@"选中车辆"];
        
        self.carView.backgroundColor = [UIColor whiteColor];
    }else{
        self.carView.layer.borderColor = [UIColor grayColor].CGColor;
        self.carView.layer.borderWidth = 1;
        self.carView.backgroundColor = [UIColor whiteColor];
        self.selectedImageView.image = [UIImage imageNamed:@"未选中车辆"];
//        self.selectedImageView.hidden = YES;
        self.lineView.backgroundColor = [UIColor lightGrayColor];
    }
}

+(instancetype)cellWithTableView:(UITableView *)tableView{
    
    MyCarManageCell *carCell = [[[NSBundle mainBundle]loadNibNamed:@"MyCarManageCell" owner:nil options:nil]lastObject];
    
    UIView *bg = [[UIView alloc]init];
    bg.backgroundColor = IWColor(237, 238, 239);
    carCell.selectedBackgroundView = bg;
    return carCell;
}

@end
