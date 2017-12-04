//
//  MineInfoViewController.m
//  MasterKA
//
//  Created by xmy on 16/4/15.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "MineInfoViewController.h"
#import "BaseModel.h"
@interface MineInfoViewController ()<UIImagePickerControllerDelegate,UITextFieldDelegate>
@property (nonatomic, strong) NSMutableDictionary *modiInfo;
@property (nonatomic, strong) NSMutableDictionary *saveInfo;
@end

@implementation MineInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"个人资料"];
    self.userName.delegate=self;
    self.signature.delegate=self;
    UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeHeadimg:)];
    self.userHeadImage.userInteractionEnabled=YES;
    [self.userHeadImage addGestureRecognizer:singleTap];
    _modiInfo=[NSMutableDictionary dictionary];
//    SevenSwitch *mySwitch2 = [[SevenSwitch alloc] initWithFrame:CGRectMake(200, 200, 54, 27)];
    _mySwitch2.center = CGPointMake(self.view.bounds.size.width * 0.5, self.view.bounds.size.height * 0.5 - 80);
    [_mySwitch2 addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    _mySwitch2.offImage = @"女";
    _mySwitch2.onImage = @"男";
    
    
    _mySwitch2.onColor =[UIColor colorWithRed:0.f green:150/255.f  blue:230/255.f  alpha:1.f];
    //[UIColor colorWithHue:0.f saturation:150/255.f brightness:230/255.f alpha:1.00f];
    _mySwitch2.borderColor=_mySwitch2.inactiveColor =[UIColor colorWithRed:227/255.f green:102/255.f  blue:165/255.f  alpha:1.f];
    //[UIColor colorWithHue:227/255.f saturation:102/255.f brightness:165/255.f alpha:1.00f];

//    [self.view addSubview:_mySwitch2];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSDictionary *userInfo =[UserClient sharedUserClient].userInfo;
    _saveInfo=[[NSMutableDictionary alloc]initWithDictionary:userInfo];
   // self.userHeadImage.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[userInfo objectForKey:@"img_top"]]]];
    [_userHeadImage setImageWithURLString:[userInfo objectForKey:@"img_top"] placeholderImage:[UIImage imageNamed:@"DefaultImage.png"]];
    self.signature.text=[userInfo objectForKey:@"intro"];
    self.userName.text=[userInfo objectForKey:@"nikename"];
    if([[userInfo objectForKey:@"sex"] intValue] ==1){
        _mySwitch2.on=YES;
    }else{
        _mySwitch2.on=NO;
    }
    NSLog(@"======== %@",userInfo);
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)switchChanged:(SevenSwitch *)sender {
    sender.on ? [_modiInfo setObject:@"1" forKey:@"sex"]:[_modiInfo setObject:@"2" forKey:@"sex"];
    sender.on ? [_saveInfo setObject:@"1" forKey:@"sex"]:[_saveInfo setObject:@"2" forKey:@"sex"];
    [self modifileInfo:_modiInfo];
}

#pragma UIImagePickerControllerDelegate -modiImg
-(void)changeHeadimg:(id)sender{
    UIActionSheet* actionSheet = [[UIActionSheet alloc] init];
    id __strong sself =self;
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
//        sheet  = [[UIActionSheet alloc] initWithTitle:nil delegate:sself cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"从相册选择",@"拍照",@"取消", nil];

        [actionSheet addButtonWithTitle:@"取消"];
        [actionSheet addButtonWithTitle:@"拍照"];
        [actionSheet addButtonWithTitle:@"从相册选择"];
        [actionSheet setCancelButtonIndex:0];
//        [actionSheet showInView:self.view];
    }else {
        [actionSheet addButtonWithTitle:@"取消"];
        [actionSheet addButtonWithTitle:@"从相册选择"];
        [actionSheet setCancelButtonIndex:0];
//        sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:sself cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"从相册选择", nil];
    }
    actionSheet.tag = 255;
    actionSheet.delegate=sself;
    [actionSheet showInView:self.view];
    
}
-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{    id __strong sself =self;
    if (actionSheet.tag == 255) {
        NSUInteger sourceType = 0;
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            switch (buttonIndex) {
                case 0:
                    // 取消
                    return;
                case 1:
                    // 相机
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                    break;
                    
                case 2:
                    // 相册
                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    break;
            }
        }else {
            if (buttonIndex == 0) {
                return;
            } else {
                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            }
        }
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = sself;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = sourceType;
        [self presentViewController:imagePickerController animated:YES completion:^{}];
    }
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    /* 此处info 有六个值
     * UIImagePickerControllerMediaType; // an NSString UTTypeImage)
     * UIImagePickerControllerOriginalImage;  // a UIImage 原始图片
     * UIImagePickerControllerEditedImage;    // a UIImage 裁剪后图片
     * UIImagePickerControllerCropRect;       // an NSValue (CGRect)
     * UIImagePickerControllerMediaURL;       // an NSURL
     * UIImagePickerControllerReferenceURL    // an NSURL that references an asset in the AssetsLibrary framework
     * UIImagePickerControllerMediaMetadata    // an NSDictionary containing metadata from a captured photo
     */
    // 保存图片至本地，方法见下文
    NSData* data;
//           if (UIImagePNGRepresentation(image)) {
//            //返回为png图像。
//            data = UIImagePNGRepresentation(image);
//        }else {
//            //返回为JPEG图像。
            data = UIImageJPEGRepresentation(image, 0.5);
//        }
    NSString* str=[data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength ];
    str=[@"data:image/jpeg;base64,"stringByAppendingString:str];
    @weakify(self);
    [[[HttpManagerCenter sharedHttpManager] updateHeadIma:str resultClass:nil] subscribeNext:^(BaseModel *model){
        @strongify(self);
        if(model.code==200){
            self.userHeadImage.image=image;
            [self.modiInfo setObjectNotNull:[model.data objectForKey:@"url"] forKey:@"portrait"];
             [self.saveInfo setObject:[model.data objectForKey:@"url"] forKey:@"img_top"];
            [self modifileInfo:self.modiInfo];
        }else{
//             [self hiddenHUDWithString:model.message error:NO];
            [self showRequestErrorMessage:model];
        }
    }];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}
#pragma UITextFieldDelegate -modiname
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if(textField.tag ==12){
        [_modiInfo setObject:textField.text forKey:@"signature"];
        [_saveInfo setObject:textField.text forKey:@"intro"];
    }else{
        [_modiInfo setObject:textField.text forKey:@"nickname"];
        [_saveInfo setObject:textField.text forKey:@"nikename"];
    }
    [self modifileInfo:_modiInfo];
}

-(void) modifileInfo:(NSMutableDictionary *)infoDic{
//    [[[HttpManagerCenter sharedHttpManager] loginByPhone:@"17717045596"password:@"aaaaaa" resultClass:nil] subscribeNext:^(BaseModel *model) {
//        if (model.code==200) {
    [[UserClient sharedUserClient] setUserInfo:_saveInfo];
    @weakify(self);
    [[[HttpManagerCenter sharedHttpManager] modifilrUserInfo:infoDic resultClass:nil] subscribeNext:^(BaseModel *model){
        @strongify(self);
        if (model.code==200) {
            [self toastWithString:model.message error:NO];
        }else {
            [self toastWithString:model.message error:NO];
        }
    }];
    
//        }}] ;

}
@end
