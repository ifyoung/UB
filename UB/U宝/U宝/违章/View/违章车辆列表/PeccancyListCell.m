//
//  PeccancyListCell.m
//  赛格车圣
//
//  Created by 朱鹏的Mac on 15/8/18.
//  Copyright (c) 2015年 朱鹏的Mac. All rights reserved.
//

#import "PeccancyListCell.h"

@interface PeccancyListCell (){

    UIImageView *rightImg;
}

@end
@implementation PeccancyListCell

- (void)configure:(UITableViewCell *)cell
        customObj:(id)obj
        indexPath:(NSIndexPath *)indexPath
{
    BindingCarListModel *myObj = (BindingCarListModel *)obj ;
    PeccancyListCell *mycell = (PeccancyListCell *)cell ;

    mycell.indexP = indexPath;
    mycell.model = myObj;
}

+ (CGFloat)getCellHeightWithCustomObj:(id)obj
                            indexPath:(NSIndexPath *)indexPath
{
    return 100;
}



#pragma mark --
- (void)awakeFromNib{
    
    //我们来看看Facebook的应用。为了检测这些，你可能需要往下滑足够的高度，然后点击状态栏。列表会往上滑动，因此你可以清楚地看到此时没有渲染cell。如果想要更精确，则不能及时获得。
    self.layer.drawsAsynchronously = YES;

    
    rightImg = [[UIImageView alloc]initWithFrame:CGRectZero];
    [self addSubview:rightImg];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self settiings];
}

- (void)setModel:(BindingCarListModel *)model{
    _model = model;
    [self setNeedsLayout];
}

- (void)settiings{

    _carplate.text =  _model.plateNo;
    _carplate.layer.cornerRadius = 3;
    _carplate.layer.masksToBounds = YES;
    _carplate.backgroundColor = kColor;
    
    

     _chaxun.text = @"点击查询违章";
    [_chaxun sizeToFit];
    _chaxun.center = CGPointMake(_carplate.center.x, _chaxun.center.y);

    
    rightImg.frame = CGRectMake(self.width - 67, 0, 67, 50);
    if(_model.callLetter.length != 0){
        rightImg.hidden = NO;
        rightImg.image = [UIImage imageNamed:@"设备车辆标记"];
    }else{
        rightImg.hidden = YES;
        rightImg.image = nil;
    }
  
    
    /*
     *   特殊车标
     */
    [self abNormal];
    
    
    /*
     *   车标
     */
   if(_model.callLetter.length != 0){
        //_carImg.image = [UIImage imageNamed:@"违章车辆示例1"];
       
       //1.不能小于2位
       if(_model.brand.length < 2) {
           _carImg.image = [UIImage imageNamed:@"非设备车辆"];
           _carImg.size = CGSizeMake(44,44);
           _carImg.center = CGPointMake(60, self.height / 2.0);
           return;
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
       
       //3.不能小于2位
       if(_model.brand.length < 2) {
           _carImg.image = [UIImage imageNamed:@"非设备车辆"];
           _carImg.size = CGSizeMake(44,44);
           _carImg.center = CGPointMake(60, self.height / 2.0);
           return;
       }
       
       //4.从后面开始检索
       for(int i = 0;i <= _model.brand.length;i++){
           
           NSLog(@"%d",i);
           
           if(i == 0 || i == 1) continue;
           
           
           NSRange rang = NSMakeRange(_model.brand.length - i, i);
           NSString *substring = [_model.brand substringWithRange:rang];
           
           UIImage *img = [UIImage imageNamed:substring];
           if(img){
               _carImg.image = img;
               CGSize size = CGSizeMake(_carImg.image.size.width, _carImg.image.size.height);
               _carImg.size = CGSizeMake(size.width,size.height);
               break;
           }
       }
       
        //5.从前面开始检索
       if(_carImg.image == nil){
           for(int i = 0;i <= _model.brand.length;i++){
               if(i == 0 || i == 1) continue;
               
               NSRange rang = NSMakeRange(0, i);
               NSString *substring = [_model.brand substringWithRange:rang];
               
               UIImage *img = [UIImage imageNamed:substring];
               if(img){
                   _carImg.image = img;
                   CGSize size = CGSizeMake(_carImg.image.size.width, _carImg.image.size.height);
                   _carImg.size = CGSizeMake(size.width,size.height);
                   break;
               }
           }
       }
       
       
       //6.模糊检索
       if(_carImg.image == nil){
       
       }
       
       //7.无结果
       if(_carImg.image == nil){
           _carImg.image = [UIImage imageNamed:@"非设备车辆"];
           _carImg.size = CGSizeMake(44,44);
       }
       
    }else{
        _carImg.image = [UIImage imageNamed:@"非设备车辆"];
        _carImg.size = CGSizeMake(44,44);
    }
    
    
    _carImg.center = CGPointMake(60, self.height / 2.0);
}


- (void)abNormal{
   
    if([_model.brand iscontainSubString:@"福克斯"]){
        _carImg.image = [UIImage imageNamed:@"福特"];
        
        CGSize size = CGSizeMake(_carImg.image.size.width, _carImg.image.size.height);
        _carImg.size = CGSizeMake(size.width,size.height);

    }
}
@end
