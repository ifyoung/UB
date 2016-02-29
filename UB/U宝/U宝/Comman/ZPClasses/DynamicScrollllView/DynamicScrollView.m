//
//  DynamicScrollView.m
//  MeltaDemo
//
//  Created by hejiangshan on 14-8-27.
//  Copyright (c) 2014年 hejiangshan. All rights reserved.
//

#import "DynamicScrollView.h"

#define  ScolContentSize   CGSizeMake(singleWidth * imageViews.count + margin * (imageViews.count + 1),scrollView.frame.size.height);

@interface DynamicScrollView ()

@property(nonatomic,retain)UIScrollView *scrollView;

@property(nonatomic,retain)NSMutableArray *images;

@property(nonatomic,retain)NSMutableArray *imageViews;

@property(nonatomic,assign)BOOL isDeleting;

@end

@implementation DynamicScrollView
{
    CGFloat width;
    CGFloat height;
    NSMutableArray *imageViews;
    CGFloat singleWidth;
    CGFloat margin;
    BOOL isDeleting;
    CGPoint startPoint;
    CGPoint originPoint;
    BOOL isContain;
}

@synthesize scrollView,imageViews,isDeleting;


- (id)initWithFrame:(CGRect)frame withImages:(NSMutableArray *)images
{
    self = [super initWithFrame:frame];
    if (self) {
   
        UIScreen *screen = [UIScreen mainScreen];
        width = screen.bounds.size.width;
        height = screen.bounds.size.height;
        imageViews = [NSMutableArray arrayWithCapacity:images.count];
        self.images = images;
        singleWidth =  50;
        margin = 10;
        
        //创建底部滑动视图
        [self _initScrollView];
        
        
        [self _initViews];
        
    }
    return self;
}

- (void)_initScrollView
{
    if (scrollView == nil) {
        scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        scrollView.backgroundColor = [UIColor clearColor];
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        [self addSubview:scrollView];
    }
}

- (void)_initViews
{
    for (int i = 0; i < self.images.count; i++) {
        
        NSString *imageName = self.images[i];
        [self createImageViews:i withImageName:imageName];
    }
    self.scrollView.contentSize = ScolContentSize;
}




/*
 *  手动添加一个新图片
 */
- (void)addImageView:(NSString *)imageName
{
    [self createImageViews:imageViews.count withImageName:imageName];
    
    self.scrollView.contentSize = ScolContentSize;

}



/*
 *  创建UIImageView
 */
- (void)createImageViews:(NSUInteger)i withImageName:(NSString *)imageName{

    UIButton *imgView  = [UIButton buttonWithType:UIButtonTypeCustom];
    imgView.frame = CGRectMake(margin +
                              (singleWidth  + margin) * i, margin, singleWidth, self.scrollView.frame.size.height - margin * 2.0);
    imgView.layer.cornerRadius = 4;
    imgView.layer.borderWidth = .5;
    imgView.layer.borderColor = kColor.CGColor;
    imgView.userInteractionEnabled = YES;
    imgView.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    imgView.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    [imgView setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [imgView setTitle:imageName forState:UIControlStateNormal];
    //[imgView addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
     [self.scrollView addSubview:imgView];
     [imageViews addObject:imgView];
    
//    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longAction:)];
//    [imgView addGestureRecognizer:longPress];
//    
//    UIImageView *deleteButton = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"删除城市"]];
//    deleteButton.userInteractionEnabled = NO;
//    deleteButton.frame = CGRectMake(singleWidth - 7, - 7,15, 15);
//    [imgView addSubview:deleteButton];
}


/*
 *  长按调用的方法
 */

- (void)longAction:(UILongPressGestureRecognizer *)recognizer
{
    UIButton *imageView = (UIButton *)recognizer.view;
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {//长按开始
        
        startPoint = [recognizer locationInView:recognizer.view];
        originPoint = imageView.center;
        isDeleting = !isDeleting;
        
        [UIView animateWithDuration:0.3 animations:^{
            imageView.transform = CGAffineTransformMakeScale(1.1, 1.1);
        }];
        
        for (UIButton *imageView in imageViews){
            
            UIButton *deleteButton = (UIButton *)imageView.subviews[0];
            if (isDeleting) {
                deleteButton.hidden = NO;
            } else {
                deleteButton.hidden = YES;
            }
        }
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {//长按移动
        
        CGPoint newPoint = [recognizer locationInView:recognizer.view];
        CGFloat deltaX = newPoint.x - startPoint.x;
        CGFloat deltaY = newPoint.y - startPoint.y;
        imageView.center = CGPointMake(imageView.center.x + deltaX, imageView.center.y + deltaY);
        NSInteger index = [self indexOfPoint:imageView.center withView:imageView];
        
        if (index < 0){
            
            isContain = NO;
        } else {
            
            [UIView animateWithDuration:0.3 animations:^{
                
                CGPoint temp = CGPointZero;
                UIButton *currentImagView = imageViews[index];
                NSUInteger idx = [imageViews indexOfObject:imageView];
                temp = currentImagView.center;
                currentImagView.center = originPoint;
                imageView.center = temp;
                originPoint = imageView.center;
                isContain = YES;
                [imageViews exchangeObjectAtIndex:idx withObjectAtIndex:index];
                
            } completion:NULL];
        }
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {//长按结束
        
        [UIView animateWithDuration:0.3 animations:^{
            
            imageView.transform = CGAffineTransformIdentity;
            if (!isContain) {
                imageView.center = originPoint;
            }
        }];
    }
}



/*
 *  删除掉用的方法
 */
- (void)deleteAction:(UIButton *)button{
    
    isDeleting = YES;   //正处于删除状态
    UIButton *imageView = button;
    __block NSUInteger index = [imageViews indexOfObject:imageView];
    __block CGRect rect = imageView.frame;
    __weak UIScrollView *weakScroll = scrollView;
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(didDeleteWithCity:)]){
        [self.delegate didDeleteWithCity:button.titleLabel.text];
    }
    [UIView animateWithDuration:0.3 animations:^{
    
        imageView.transform = CGAffineTransformMakeScale(0.01, 0.01);
        
    } completion:^(BOOL finished) {
        
        [imageView removeFromSuperview];
        
                [UIView animateWithDuration:0.3 animations:^{
                    
                    for (NSUInteger i = index + 1; i < imageViews.count; i++) {
                        
                        UIButton *otherImageView = imageViews[i];
                        CGRect originRect = otherImageView.frame;
                        otherImageView.frame = rect;
                        rect = originRect;
                    }
                } completion:^(BOOL finished) {
                    
                    [imageViews removeObject:imageView];
                    
                    weakScroll.contentSize = ScolContentSize;
                    
                }];
    }];
}


/*
 *  获取view在imageViews中的位置
 */
- (NSInteger)indexOfPoint:(CGPoint)point withView:(UIView *)view
{
    UIButton *originImageView = (UIButton *)view;
    for (NSUInteger i = 0; i < imageViews.count; i++) {
        
        UIButton *otherImageView = imageViews[i];
        if (otherImageView != originImageView) {
            
            if (CGRectContainsPoint(otherImageView.frame, point)) {
                return i;
            }
        }
    }
    return -1;
}
@end
