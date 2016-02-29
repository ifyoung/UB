//
//  ZPCircleLabelView.h
//  赛格车圣
//
//  Created by 朱鹏的Mac on 15/7/2.
//  Copyright (c) 2015年 朱鹏的Mac. All rights reserved.
//

#import "ZPCircleLabelView.h"

@interface ZPCircleLabelView (){
 
    UIImageView *im;
}

@property (nonatomic) CGPoint circleCenterPoint;

@end

@implementation ZPCircleLabelView

#define VISUAL_DEBUGGING NO

+ (void)initialize{
 
    if (self == [ZPCircleLabelView class]) {
        ZPCircleLabelView *circular = [ZPCircleLabelView appearance];
        circular.textAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:10],NSForegroundColorAttributeName:[UIColor whiteColor]};
        circular.textAttributes1 = @{NSFontAttributeName: [UIFont systemFontOfSize:12], NSForegroundColorAttributeName:[UIColor whiteColor]};
        circular.textAlignment = NSTextAlignmentCenter;
        circular.baseAngle = 270 * M_PI / 180;
        circular.characterSpacing = 0.8;
        circular.radius = 45;
    }
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        
        //self.contentMode = UIViewContentModeTop;
        //self.image = [UIImage imageNamed:@"扇形"];
    }
    return self;
}

- (void)startAnimation{
    self.transform = CGAffineTransformMakeRotation(-M_PI_4 / 2.0);
    [UIView animateKeyframesWithDuration:2 delay:0 options:UIViewKeyframeAnimationOptionAutoreverse | UIViewKeyframeAnimationOptionRepeat animations:^{
        
        self.transform = CGAffineTransformMakeRotation(M_PI_4 / 2.0);
    } completion:NULL];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.circleCenterPoint = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    [self drawShan_shape];
    
    [self drawRectWithText:self.text  radius:self.radius textAttributes:self.textAttributes];
    
    [self drawRectWithText:self.text1 radius:self.radius - 12 textAttributes:self.textAttributes1];
}





- (float) kerningForCharacter:(NSString *)currentCharacter afterCharacter:(NSString *)previousCharacter
{
    float totalSize = [[NSString stringWithFormat:@"%@%@", previousCharacter, currentCharacter] sizeWithAttributes:self.textAttributes].width;
    float currentCharacterSize = [currentCharacter sizeWithAttributes:self.textAttributes].width;
    float previousCharacterSize = [previousCharacter sizeWithAttributes:self.textAttributes].width;
    
    return (currentCharacterSize + previousCharacterSize) - totalSize;
}

- (void)drawRectWithText:(NSString *)text radius:(float)selfradius textAttributes:(NSDictionary *)textAttributes
{
    //Get the string size.
    CGSize stringSize = [text sizeWithAttributes:textAttributes];
    
    //If the radius not set, calculate the maximum radius.
    float radius = (selfradius <=0) ? (self.bounds.size.width <= self.bounds.size.height) ? self.bounds.size.width / 2 - stringSize.height: self.bounds.size.height / 2 - stringSize.height : selfradius;
    
    
    //Calculate the angle per charater.
    self.characterSpacing = (self.characterSpacing > 0) ? self.characterSpacing : 1;
    float circumference = 2 * radius * M_PI;
    float anglePerPixel = M_PI * 2 / circumference * self.characterSpacing;
    
    //Set initial angle.
    float startAngle;
    if (self.textAlignment == NSTextAlignmentRight) {
        startAngle = self.baseAngle - (stringSize.width * anglePerPixel);
    } else if(self.textAlignment == NSTextAlignmentLeft) {
        startAngle = self.baseAngle;
    } else {
        startAngle = self.baseAngle - (stringSize.width * anglePerPixel/2);
    }
    
    //Set drawing context.
    CGContextRef context = UIGraphicsGetCurrentContext();
    float characterPosition = 0;
    NSString *lastCharacter;

    //Loop thru characters of string.
    for (NSInteger charIdx = 0; charIdx < text.length; charIdx++) {
        
        //Set current character.
        NSString *currentCharacter =  [NSString stringWithFormat:@"%@",[text substringWithRange:NSMakeRange(charIdx, 1)]];
        
        //[NSString stringWithFormat:@"%c", [text characterAtIndex:charIdx]];
        
        CGSize stringSize = [currentCharacter sizeWithAttributes:textAttributes];
        
        float kerning = (lastCharacter) ? [self kerningForCharacter:currentCharacter afterCharacter:lastCharacter] : 0;
        
        characterPosition += (stringSize.width / 2) - kerning;
        
        float angle = characterPosition * anglePerPixel + startAngle;
        
        CGPoint characterPoint = CGPointMake(
                                             radius * cos(angle) + self.circleCenterPoint.x,
                                             radius * sin(angle) + self.circleCenterPoint.y
                                             );
        
        CGPoint stringPoint = CGPointMake(
                                          characterPoint.x - stringSize.width/2 ,
                                          characterPoint.y - stringSize.height
                                          );
        CGContextSaveGState(context);
        
        CGContextTranslateCTM(context, characterPoint.x, characterPoint.y);
        
        CGContextConcatCTM(context, CGAffineTransformMakeRotation(angle + M_PI_2));
        
        CGContextTranslateCTM(context, -characterPoint.x, -characterPoint.y);
        
        [currentCharacter drawAtPoint:stringPoint withAttributes:textAttributes];
        
        CGContextRestoreGState(context);
        
        characterPosition += stringSize.width / 2;
        
        if (characterPosition * anglePerPixel >= M_PI*2) break;
        
        lastCharacter = currentCharacter;
    }
    
    
    /*
     if (!VISUAL_DEBUGGING){
         [[UIColor blueColor] setStroke];
         [[UIBezierPath bezierPathWithArcCenter:self.circleCenterPoint radius:radius startAngle:0 endAngle:2*M_PI clockwise:YES] stroke];
         
         UIBezierPath *line = [UIBezierPath bezierPath];
         [line moveToPoint:CGPointMake(self.circleCenterPoint.x, self.circleCenterPoint.y - radius)];
         [line addLineToPoint:CGPointMake(self.circleCenterPoint.x, self.circleCenterPoint.y + radius)];
         [line moveToPoint:CGPointMake(self.circleCenterPoint.x-radius, self.circleCenterPoint.y)];
         [line addLineToPoint:CGPointMake(self.circleCenterPoint.x+radius, self.circleCenterPoint.y)];
         [line stroke];
     }
    */
}


- (void)drawShan_shape{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);
    CGContextSetFillColorWithColor(context, IWColorAlpha(36, 123, 214,.7).CGColor);
    CGMutablePathRef pathRef  = CGPathCreateMutable();
    CGPathMoveToPoint(pathRef, NULL, self.circleCenterPoint.x, self.circleCenterPoint.y);
    CGPathAddArc(pathRef, NULL,
                 
                 self.circleCenterPoint.x,
                 self.circleCenterPoint.y,
                 self.circleCenterPoint.x - 1,
                 -M_PI / 4.0 * 3,
                 -M_PI_2 / 2.0 ,
                 NO);
    CGPathCloseSubpath(pathRef);
    CGContextAddPath(context, pathRef);
    CGContextDrawPath(context, kCGPathFill);
    CGPathRelease(pathRef);
    //CGContextFillPath(context);
    
    CGContextSaveGState(context);
    //CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextSetBlendMode(context, kCGBlendModeClear);
    CGRect clearRect = (CGRect) {
        .origin.x    = self.circleCenterPoint.x / 2.0,
        .origin.y    = self.circleCenterPoint.y / 2.0,
        .size.width  = self.circleCenterPoint.x ,
        .size.height = self.circleCenterPoint.x
    };
    CGContextAddEllipseInRect(context, clearRect);
    //CGContextFillPath(context);
    CGContextDrawPath(context, kCGPathFill);
    CGContextRestoreGState(context);
}


#pragma mark Getters & Setters
- (void)setText:(NSString *)text
{
    _text = text;
    [self setNeedsDisplay];
}
- (void)setText1:(NSString *)text1
{
    _text1 = text1;
    [self setNeedsDisplay];
}
- (void)setTextAttributes:(NSDictionary *)textAttributes
{
    _textAttributes = textAttributes;
    [self setNeedsDisplay];
}
- (void)setTextAttributes1:(NSDictionary *)textAttributes1{

    _textAttributes1 = textAttributes1;
    [self setNeedsDisplay];
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment
{
    _textAlignment = textAlignment;
    [self setNeedsDisplay];
}
-(void)setRadius:(float)radius
{
    _radius = radius;
    [self setNeedsDisplay];
}
- (void)setBaseAngle:(float)baseAngle
{
    _baseAngle = baseAngle;
    [self setNeedsDisplay];
}
- (void)setCharacterSpacing:(float)characterSpacing
{
    _characterSpacing = characterSpacing;
    [self setNeedsDisplay];
}

@end
