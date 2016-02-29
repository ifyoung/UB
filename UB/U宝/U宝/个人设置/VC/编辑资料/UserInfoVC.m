//
//  UserInfoVC.m
//  赛格车圣
//
//  Created by 朱鹏的Mac on 15/8/18.
//  Copyright (c) 2015年 朱鹏的Mac. All rights reserved.
//

#import "UserInfoVC.h"
#import "UserInfoCell.h"
#import "phoneNumModel.h"

#define topImgHeight (470 / 2.0)

@interface UserInfoVC ()<ELCImagePickerControllerDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIActionSheetDelegate>{

    UITableView *table;
    UIImageView *bannner;
    UIVisualEffectView  *blurView;
    UIImageView *userImageView;
    NSMutableArray *dataArray;
    phoneNumModel *phoneModel;
    /**
     *  是否打开键盘
     */
    BOOL isOpen;
    /**
     *  是否切换键盘
     */
     BOOL switchingKeybaord;
}

@end

@implementation UserInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"编辑资料";
    self.view.backgroundColor = bggrayColor;
    [self createTBView];
    [self leftButtonItem];
    [self swipeGestureRecognizer];

    //监听键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    if (iOS8Earlier) {
        
        [self createTBView];
    }
}

//移除通知
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

//判断网络状态
//-(void)viewWillAppear:(BOOL)animated{
//    if(![UIDevice checkNowNetworkStatus]){
//        if(!self.isLoadDataCompete)
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [MBProgressHUD showIndicator:KNetworkError];
//            });
//        return;
//    }
//    
//}

#pragma mark - keyboardeChange
//键盘处理
-(void)keyboardDidChangeFrame:(NSNotification *)noti{

    //最终键盘的frame
    CGRect frame = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    //键盘实时y
    CGFloat keyY = frame.origin.y;
    NSLog(@"KSCREEHEGIHT == %f",KSCREEHEGIHT);
    
    //切换键盘是不要再改变view的transform
    if (switchingKeybaord == YES && keyY < KSCREEHEGIHT) {
        return;
    }
    
    CGFloat offset = 0;
    if (KSCREEHEGIHT < 667) {//根据屏幕高度设置滚动距离
        offset = -60;
    }
    if (KSCREEHEGIHT <= 480) {
        offset = -bannner.height;
    }
    //动画时间
    CGFloat keyDuration = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    //执行动画
    [UIView animateWithDuration:keyDuration animations:^{
        
        if (isOpen == NO) {//默认为NO
            
            table.transform = CGAffineTransformMakeTranslation(0, offset);
            isOpen = YES;
            switchingKeybaord = YES;
        }else if (isOpen == YES){
            //恢复变形前状态
            table.transform = CGAffineTransformIdentity;
            isOpen = NO;
            switchingKeybaord = NO;
        }
    }];

}

/*
 *   UITableView
 */
- (void)createTBView{
    
    //导航栏高度h = 44，不包括状态栏h = 20
    CGFloat h = self.navigationController.navigationBar.height;

    CGRect rect =  CGRectMake(0, 0, KSCREEWIDTH, KSCREEHEGIHT - h);
    table = [[UITableView alloc]initWithFrame:rect style:UITableViewStyleGrouped];
    table.delegate = self;
    table.dataSource = self;
//    table.tableFooterView = [UIView new];
    table.contentInset = UIEdgeInsetsMake(topImgHeight, 0, 0, 0);
    [self.view addSubview:table];
    
    [table addSubview:({
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSData *imgData = [defaults objectForKey:@"userImg"];
        UIImage *img;
        if (imgData) {
            
            img = [UIImage imageWithData:imgData];
        }else{
            img = [UIImage imageNamed:@"组-21"];
        }
        
        bannner = [[UIImageView alloc]initWithImage:img];
        bannner.contentMode = UIViewContentModeScaleToFill;
        bannner.userInteractionEnabled = YES;
        bannner.frame = CGRectMake(0, -topImgHeight, table.width, topImgHeight);
        
        if (iOS8Earlier) {
        
            /**
             *  ios7图片模糊效果
             */
            [bannner blur];
            
        }else{//ios8模糊效果
#ifdef __IPHONE_8_0
            
            UIBlurEffect *blurEffect  = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
            blurView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
            blurView.frame = bannner.bounds;
            [bannner addSubview:blurView];
#endif
        }

        
        userImageView = [[UIImageView alloc]initWithImage:img];
        userImageView.contentMode = UIViewContentModeScaleAspectFill;
        userImageView.frame = CGRectMake(KSCREEWIDTH / 3.0, 40, KSCREEWIDTH / 3.0, KSCREEWIDTH/ 3.0);
       
        userImageView.layer.cornerRadius = KSCREEWIDTH / 3.0 / 2.0;
        userImageView.layer.masksToBounds =  YES;
        userImageView.layer.borderWidth = 1.0f;
        userImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        
        if (iOS8Earlier) {//ios7之前
        
            [bannner addSubview:userImageView];
        }else{
            [blurView.contentView addSubview:userImageView];
        }

        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.layer.cornerRadius = 15;
        button.layer.masksToBounds = YES;
        button.userInteractionEnabled  = YES;
        button.showsTouchWhenHighlighted = YES;
        button.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        [button setTitleColor:[UIColor whiteColor]  forState:UIControlStateNormal];
        [button addTarget:self action:@selector(changeUserImgAction) forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor = IWColorAlpha(114, 140, 140,0.5);
        [button setTitle:@"更换头像" forState:UIControlStateNormal];
        button.frame = CGRectMake(0, userImageView.bottom + 20, KSCREEWIDTH  / 3.0  - 20, 30);
        button.center = CGPointMake(userImageView.center.x, button.center.y);
        
        if (iOS8Earlier) {//ios7之前
            
            [bannner addSubview:button];
        }else{
            [blurView.contentView addSubview:button];
        }
      
        bannner;
    })];
}


/*
 *   changeUserImgAction
 */
- (void)changeUserImgAction{

    if ([UIDevice currentDevice].systemVersion.doubleValue >= 8.0) {//ios8以上

#ifdef __IPHONE_8_0
        __weak typeof(self) this = self;
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *cancelAction2 = [UIAlertAction actionWithTitle:@"取消" style: UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
        }];
        
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            [this openCamera];
        }];
        
        UIAlertAction *cancelAction1 = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
//            ELCImagePickerController *imagePickerController = [[ELCImagePickerController alloc] init];
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
//            [imagePickerController setImagePickerDelegate:self];
            
            imagePickerController.delegate = self;
            imagePickerController.allowsEditing = YES;
            [self presentViewController:imagePickerController animated:YES completion:nil];

            
        }];
       
        [alert addAction:cancelAction];
        [alert addAction:cancelAction1];
        [alert addAction:cancelAction2];
        [self presentViewController:alert animated:YES completion:NULL];
#endif
    }else{//ios7
        
        UIActionSheet *as = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册选择", nil];
        [as showInView:self.view];
    }
}

#pragma mark - UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [self openCamera];
    }else if (buttonIndex == 1){
//        ELCImagePickerController *imagePickerController = [[ELCImagePickerController alloc] init];
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
//        [imagePickerController setImagePickerDelegate:self];
        imagePickerController.allowsEditing = YES;
        imagePickerController.delegate = self;
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }
}

#pragma mark - scrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat y = scrollView.contentOffset.y;
    if (y < -topImgHeight && !iOS8Earlier) {
        CGRect frame = bannner.frame;
        frame.origin.y = y;
        frame.size.height =  -y;
        bannner.frame = frame;
        blurView.frame = bannner.bounds;
    }
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
    switchingKeybaord = NO;
}


#pragma mark - UITableView delegate  and dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) return 1;
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //cell不可被选中
    tableView.allowsSelection = NO;
    
       UserInfoCell *cell = [UserInfoCell cellWithTableView:tableView andIndexPath:indexPath phoneModel:phoneModel];
    
    if (indexPath.section == 0 && indexPath.row == 0 && [_delegate respondsToSelector:@selector(userInfoVC:changeName:)]) {
        [_delegate userInfoVC:self changeName:cell.rightText.text];
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section == 0 ? 20 : 15;
}

//获取用户资料
//-(void)getUserInfo{
//    
//    if(![UIDevice checkNowNetworkStatus]){
//        if(!self.isLoadDataCompete)
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [MBProgressHUD showIndicator:KNetworkError];
//            });
//        return;
//    }
//    
//    __weak typeof(self) this = self;
//    [MBProgressHUD showMessage:KIndicatorStr];
//    [Interface getUserDetailMessageWithblock:^(id result) {
//
//        NSDictionary *dic = [result objectForKey:KServerdataStr];
//        
//        phoneModel = [phoneNumModel phoneWithDict:dic];
//
//        dispatch_async(dispatch_get_main_queue(), ^{
//            
//            //回到主线程在创建，防止数组为nil
//            [this createTBView];
//            [MBProgressHUD hideHUD];
//        });
//    }];
//    
//}


//*****************************************************************************/
#pragma mark - elcImagePickerControllerDelegate
//*****************************************************************************/
- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info{
    
    NSDictionary *dictionary = [info firstObject];
        
    UIImage *image = [dictionary objectForKey:UIImagePickerControllerOriginalImage];
    
    [self _upLoadImgToGetImgUrl:image];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    [self userDelegateMethod:image];
    
}
- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker{

    [self dismissViewControllerAnimated:YES completion:nil];

}


//2.打开照相机
- (void)openCamera{
    if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
    
        return;
    }
    //创建一个相册的控制器（相册控制器继承于导航控制器）
    UIImagePickerController *pickerController = [[UIImagePickerController alloc]init];
    pickerController.delegate = self;
    
    pickerController.allowsEditing = YES;
    //打开的相册类型
    pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:pickerController animated:YES completion:^{
        NSLog(@"已经打开了");
    }];
}


#pragma mark - UIImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    NSLog(@"info=============:%@",info);

    [self dismissViewControllerAnimated:YES completion:^{
        
        //获取当前媒体的类型
        NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
        
        
        if ([mediaType isEqualToString:@"public.image"]) {
            //获取当前点击切编辑后的图片,必须设置allowsEditing
            UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
            
            [self _upLoadImgToGetImgUrl:image];
            
            [self userDelegateMethod:image];
            
        } else if ([mediaType isEqualToString:@"public.movie"]) {
            //NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
            //MPMoviePlayerController *player = [[MPMoviePlayerController alloc]initWithContentURL:videoURL];
            //UIImage  *thumbnail = [player thumbnailImageAtTime:1.0 timeOption:MPMovieTimeOptionNearestKeyFrame];
            //[self _upLoadImgToGetImgUrl:thumbnail];
        }
    }];
    
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{

    [self dismissViewControllerAnimated:YES completion:NULL];
  
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:NULL];
}


/**
 *  上传照片
 *
 *  @param image
 */
- (void)_upLoadImgToGetImgUrl:(UIImage *)image{
//    NSData *imageData = UIImageJPEGRepresentation(image, 1);
//    if(imageData.length > 1024 * 1024){//大于1M则压缩
//        imageData = UIImageJPEGRepresentation(image, 0.3);
//    }
    
    MAIN(^{
        userImageView.image = image;
        bannner.image = image;
    });
    
}

-(void)userDelegateMethod:(UIImage *)image{
    if ([_delegate respondsToSelector:@selector(userInfoVC:changeImage:)]) {
        [_delegate userInfoVC:self changeImage:image];
    }
    NSData *data = UIImagePNGRepresentation(image);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:data forKey:@"userImg"];
    [defaults synchronize];
}


@end
