//
//  UBILookCodeEngineCell.m
//  赛格车圣
//
//  Created by 朱鹏的Mac on 15/9/17.
//  Copyright (c) 2015年 朱鹏的Mac. All rights reserved.
//

#import "UBILookCodeEngineCell.h"
#import "UBIMobileUnusefulModel.h"

@interface UBILookCodeEngineCell ()<UITextFieldDelegate>{
    UILabel *leftLabel;
    UITextField *middleTextF;
}
@end
@implementation UBILookCodeEngineCell
+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"UBILookCodeEngineCell";
    UBILookCodeEngineCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UBILookCodeEngineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryView = [UBILookCodeEngineCell accessoryViewSelf];
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        
        [self createSubViews];
    }
    return self;
}

+ (UIView *)accessoryViewSelf{
    UIImage *img = [UIImage imageNamed:@"违章查询-问号"];
    UIImageView *imgv = [[UIImageView alloc]initWithImage:[UIImage changeImg:img size:CGSizeMake(30, 30)]];
    return (UIView *)imgv;
}

- (void)createSubViews{
    
    leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 60, self.height)];
    leftLabel.font = [UIFont systemFontOfSize:13.0f];
    //leftLabel.backgroundColor = [UIColor greenColor];
    [self.contentView addSubview:leftLabel];
    
    
    middleTextF =  [[UITextField alloc]initWithFrame:CGRectMake(leftLabel.right + 20, 0, KSCREEWIDTH - leftLabel.right - 10 - 70, self.height)];
    middleTextF.delegate =self;
    middleTextF.returnKeyType = UIReturnKeyDone;
    middleTextF.font = [UIFont systemFontOfSize:14.0f];
    middleTextF.clearButtonMode = UITextFieldViewModeWhileEditing;
    //middleTextF.backgroundColor = [UIColor redColor];
    
    [self.contentView addSubview:middleTextF];
    
    [middleTextF addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];
}

/**
 *  textFieldDelegate
 *
 *  @param textField
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField  resignFirstResponder];
    return YES;
}

- (void)textFieldWithText:(UITextField *)textField{
    if(_indexPath.row == 0){
        
        [UBIMobileUnusefulModel shareInstance].engineNo = textField.text;
    }else{
        [UBIMobileUnusefulModel shareInstance].vin = textField.text;
    }
}


- (void)setIndexPath:(NSIndexPath *)indexPath{
    
    _indexPath = indexPath;
    if(indexPath.row == 0){
        
        leftLabel.text = @"发动机号";
        middleTextF.placeholder = @"请输入发动机号后6位";
        middleTextF.text =   [UBIMobileUnusefulModel shareInstance].engineNo;
    }else {
        
        leftLabel.text = @"车  架  号";
        
        middleTextF.placeholder = @"请输入车架号后6位";
        middleTextF.text = [UBIMobileUnusefulModel shareInstance].vin;
    }
}
@end
