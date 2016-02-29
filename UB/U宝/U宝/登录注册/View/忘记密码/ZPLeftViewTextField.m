
//
//  ZPLeftViewTextField.m
//  PekingEMBA
//
//  Created by midu on 14-8-15.
//  Copyright (c) 2014年 midu. All rights reserved.
//

#import "ZPLeftViewTextField.h"

@implementation ZPLeftViewTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.leftViewMode = UITextFieldViewModeAlways;
        
        [self setAutocorrectionType:UITextAutocorrectionTypeNo];
        
        [self setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        
    }
    return self;
}


- (void)addLeftImgViewText:(NSString *)imgName{
    UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 30, 30)];
    img.image = [UIImage imageNamed:imgName];
    self.leftView = img;
}


- (CGRect)leftViewRectForBounds:(CGRect)bounds{

    return CGRectMake(10, 10, 30, 30);
}

-(CGRect)textRectForBounds:(CGRect)bounds{

    return CGRectMake(50, 0, bounds.size.width - 50, bounds.size.height);

}

-(CGRect)editingRectForBounds:(CGRect)bounds{
   return CGRectMake(50, 0, bounds.size.width - 50, bounds.size.height);
}

-(CGRect)placeholderRectForBounds:(CGRect)bounds{
    return CGRectMake(50, 0, bounds.size.width - 50, bounds.size.height);
}

@end

