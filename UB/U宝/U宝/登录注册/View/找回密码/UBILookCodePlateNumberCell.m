//
//  UBILookCodePlateNumberCell.m
//  赛格车圣
//
//  Created by 朱鹏的Mac on 15/9/17.
//  Copyright (c) 2015年 朱鹏的Mac. All rights reserved.
//

#import "UBILookCodePlateNumberCell.h"
#import "UBIMobileUnusefulModel.h"

@interface UBILookCodePlateNumberCell ()<UITextFieldDelegate>{

    UILabel *leftLabel;
    UILabel *rightLabel;
    UIImageView *arrow;
    UITextField *textF;
}
@end
@implementation UBILookCodePlateNumberCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"UBILookCodePlateNumberCell";
    UBILookCodePlateNumberCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UBILookCodePlateNumberCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
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


- (void)createSubViews{
    
    leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 60, self.height)];
    leftLabel.font = [UIFont systemFontOfSize:13.0f];
    leftLabel.text = @"车牌号码";
    [self.contentView addSubview:leftLabel];
    
    rightLabel = [[UILabel alloc]initWithFrame:CGRectMake(leftLabel.right + 20, 0, 20, self.height)];
    rightLabel.font = [UIFont systemFontOfSize:13.0f];
    [self.contentView addSubview:rightLabel];
    
    
    arrow = [[UIImageView alloc]initWithFrame:CGRectMake(rightLabel.right, (self.height - 20) / 2.0 , 15, 20)];
    arrow.contentMode = UIViewContentModeScaleAspectFit;
    arrow.image = [UIImage imageNamed:@"下"];
    [self.contentView addSubview:arrow];
    
    
    textF =  [[UITextField alloc]initWithFrame:CGRectMake(arrow.right + 10, 0, KSCREEWIDTH - arrow.right - 20, self.height)];
    textF.delegate = self;
    textF.returnKeyType = UIReturnKeyDone;
    textF.font = [UIFont systemFontOfSize:13.0f];
    textF.clearButtonMode = UITextFieldViewModeWhileEditing;
    textF.placeholder = @"请输入车牌号码";
    [self.contentView addSubview:textF];
    
    [textF addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];
}


- (void)layoutSubviews{
    [super layoutSubviews];
    
    rightLabel.text = [UBIMobileUnusefulModel shareInstance].cityNickName;
    
    textF.text = [UBIMobileUnusefulModel shareInstance].plateNo;
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
    [UBIMobileUnusefulModel shareInstance].plateNo = [NSString stringWithFormat:@"%@",textField.text];
}
@end
