//
//  personalizationViewController.m
//  atomemory
//
//  Created by apple on 2018/4/11.
//  Copyright © 2018年 apple. All rights reserved.
/*
 8个属性
 @property (nonatomic, strong)UIButton *selectImage;
 @property (nonatomic, strong)UISlider *slider0;
 @property (nonatomic, strong)UIVisualEffectView *visualEfView;
 @property (nonatomic, strong)personalizationView* pView;
 @property(nonatomic,strong)picture* bg;
 @property (nonatomic, copy)UIImageView* BG;
 @property (nonatomic, strong)UIVisualEffectView *BG_visualEfView;
 @property (nonatomic, strong)UIImageView *icon;
 
 - (void)viewDidLoad 初始化函数 背景 pview 黑色幕布 icon visualeffect BG_visualeffect selectImage按钮 slider0
 slider1 BG 并且全部复制给pview并让pview渲染 selectImage slider0 slider1 绑定函数。
 
 
 */

#import "personalizationViewController.h"
#import "TakePhotoTool.h"
#import "TZImagePickerController.h"

@interface personalizationViewController (){
    UIImageView *icon;
}
@end




@implementation personalizationViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
//---------------------ui 逻辑----------------------------
    //渲染界面
    _pView=[[personalizationView alloc]initWithFrame:CGRectMake(0, 0, SCREENW, SCREENH)];
    //背景
    UIView* blackBG=[[UIView alloc]initWithFrame:CGRectMake((SCREENW)/4, SCREENH/6, SCREENW/2, SCREENH/2)];
    //背景颜色
    blackBG.backgroundColor=[UIColor blackColor];
    //[_pView addSubview:blackBG];
    
    //模版icon
    icon = [[UIImageView alloc]initWithFrame:CGRectMake((SCREENW)/4, SCREENH/6, SCREENW/2, SCREENH/2)];
  
    //选择图片
     _selectImage=[UIButton buttonWithType:UIButtonTypeCustom];
    _SetWhite=[UIButton buttonWithType:UIButtonTypeCustom];
    //滑条
     _slider0 = [[UISlider alloc] initWithFrame:CGRectMake(SCREENW/6, 3*(SCREENH)/4+40, SCREENW*2/3, 20)];
    _slider1 = [[UISlider alloc] initWithFrame:CGRectMake(SCREENW/6, 3*(SCREENH)/4+40+50, SCREENW*2/3, 20)];
    //背景
    _BG=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREENW, SCREENH)];

    
    //把ui传给pview去渲染
    _pView.selectbtn=_selectImage;
    _pView.SetWhitebtn=_SetWhite;
    _pView.slider1=_slider0;
    _pView.slider2=_slider1;
    _pView.icon=icon;
    _pView.visualeffect=_visualEfView;
    _pView.Navbar=self.navigationController.navigationBar;
    _pView.BG1=_BG;
    _pView.BGeffect1=_BG_visualEfView;

    
    //叫pview 去渲染
   
    [_pView setBG];
    [_pView setNavigationBar];
    [_pView addSubview:blackBG];
    [_pView setIcon];
    [_pView setVisualEffect];//设置毛玻璃
    [_pView setSelectbtn];
    [_pView setSlider];
  
     self.view=_pView;
   
    
    //---------------------业务逻辑----------------------------
    
    //选择图片按钮点击事件
    [_selectImage addTarget:self action:@selector(click_selectBtn) forControlEvents:UIControlEventTouchUpInside];
       [_SetWhite addTarget:self action:@selector(click_SetWhite) forControlEvents:UIControlEventTouchUpInside];
    
    //滑动事件
    [_slider0 addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [_slider1 addTarget:self action:@selector(_sliderValueChanged:) forControlEvents:UIControlEventValueChanged];

    //设置导航栏
    [self setBarbutton];
    //icon.image blurryImage:<#(UIImage *)#> withBlurLevel:<#(CGFloat)#>
    
}

//---------------------------业务逻辑------------------------



   //滑动事件
- (void)sliderValueChanged:(UISlider *)slider {
   // self.visualEfView.alpha = _slider0.value;
   // NSLog(@" %f", slider.value);
    if(icon.image!=nil)
    {
      [icon setImage:[ObjectFunction blurryImage:_tempImage withBlurLevel:_slider0.value]];
    }
}

- (void)_sliderValueChanged:(UISlider *)slider {
    icon.alpha = 1-_slider1.value;
    // NSLog(@" %f", slider.value);
}


-(void)click_SetWhite
{
    [JDLAlertView showAlertViewWithMessage:@"完成设置" backgroundStyle:JDLBackgroundStyleNone duration:2 viewController:self];
    UIImage *w=[UIImage imageNamed:@"white.jpg"];
    
    _bg=[[picture alloc]init];
    _bg.content= UIImageJPEGRepresentation(w, 1.0f);
    _bg.PicId=@"systembg";
    
    RLMResults<picture *> *temp = [picture objectsWhere:@"PicId = %@",@"systembg"];
    
    
    //---------------------存图片-------------------------
    if (temp.count == 0) {//如果不存在此数据则存
        [[RLMRealm defaultRealm] transactionWithBlock:^{
            [[RLMRealm defaultRealm] addObject:_bg];
        }];
    } else { //存在此数据则改
        //   NSLog(@"数据库已经有该条数据,只需要修改");
        _bg=[[picture objectsWhere:@"PicId=%@",@"systembg"]firstObject];
        [[RLMRealm defaultRealm] transactionWithBlock:^{
            _bg.content= UIImageJPEGRepresentation(w, 1.0f);
            //再存
            [[RLMRealm defaultRealm] addObject:_bg];
        }];
    }
    //---------------------存模糊度 透明度--------------------------
    RLMResults<appStat *>* temp1=[appStat objectsWhere:@"appstatId = %@",@"systembgAlpha"];
    RLMResults<appStat *>* temp2=[appStat objectsWhere:@"appstatId = %@",@"_systembgAlpha"];
    
    if (temp1.count == 0) {
        
    } else {
        
        appStat* appstat1=[[appStat objectsWhere:@"appstatId=%@",@"systembgAlpha"]firstObject];
        [[RLMRealm defaultRealm] transactionWithBlock:^{
            appstat1.stat=0;
            //再存
            [[RLMRealm defaultRealm] addObject:appstat1];
        }];
    }
    
    if (temp2.count == 0) {
        
    } else {
        appStat* appstat2=[[appStat objectsWhere:@"appstatId=%@",@"_systembgAlpha"]firstObject];
        [[RLMRealm defaultRealm] transactionWithBlock:^{
            appstat2.stat=1;
            //再存
            [[RLMRealm defaultRealm] addObject:appstat2];
        }];
    }
    
    [self viewWillAppear:YES];
    //  [self dismissViewControllerAnimated:YES completion:nil];
}

   //点击换背景按钮事件
-(void)click_selectBtn{
    
 /*   [TakePhotoTool sharePictureWith:self andWith:^(UIImage *image) {
        _tempImage=image;
      [icon setImage:[ObjectFunction blurryImage:_tempImage withBlurLevel:0.0f]];
    }];*/
    
/*    self.customSheet = [[LDActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍摄",@"相册", nil];
    [self.customSheet showInView:_pView];
    //这里需要提取出选中照片的绝对路径，因为有机会要保存起来的。
    NSLog(@"cnm");*/
    [self pushTZImagePickerController];
    
    
}
- (void)pushTZImagePickerController {
   

    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 columnNumber:4 delegate: self pushPhotoPickerVc:YES];
    // imagePickerVc.navigationBar.translucent = NO;
    
#pragma mark - 五类个性化设置，这些参数都可以不传，此时会走默认设置
    imagePickerVc.isSelectOriginalPhoto = NO;
    
    /*if (self.maxCountTF.text.integerValue > 1) {
        // 1.设置目前已经选中的图片数组
        imagePickerVc.selectedAssets = _selectedAssets; // 目前已经选中的图片数组
    }*/
    
    imagePickerVc.allowTakePicture = NO; // 在内部显示拍照按钮
    imagePickerVc.allowTakeVideo = NO;   // 在内部显示拍视频按
    imagePickerVc.videoMaximumDuration = 10; // 视频最大拍摄时间
    
    // imagePickerVc.photoWidth = 1000;
    
    // 2. Set the appearance
    // 2. 在这里设置imagePickerVc的外观
    // if (iOS7Later) {
    // imagePickerVc.navigationBar.barTintColor = [UIColor greenColor];
    // }
    // imagePickerVc.oKButtonTitleColorDisabled = [UIColor lightGrayColor];
    // imagePickerVc.oKButtonTitleColorNormal = [UIColor greenColor];
    // imagePickerVc.navigationBar.translucent = NO;
    
    // 3. Set allow picking video & photo & originalPhoto or not
    // 3. 设置是否可以选择视频/图片/原图
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = NO;
    imagePickerVc.allowPickingGif = NO;
    imagePickerVc.allowPickingMultipleVideo = NO; // 是否可以多选视频
    
    // 4. 照片排列按修改时间升序
    imagePickerVc.sortAscendingByModificationDate = YES;
    
    // imagePickerVc.minImagesCount = 3;
    // imagePickerVc.alwaysEnableDoneBtn = YES;
    
    // imagePickerVc.minPhotoWidthSelectable = 3000;
    // imagePickerVc.minPhotoHeightSelectable = 2000;
    
    /// 5. Single selection mode, valid when maxImagesCount = 1
    /// 5. 单选模式,maxImagesCount为1时才生效
    imagePickerVc.showSelectBtn = NO;
    imagePickerVc.allowCrop = YES;
    imagePickerVc.needCircleCrop = NO;
    // 设置竖屏下的裁剪尺寸
    
    NSInteger left = SCREENW*0.12;
 //   NSInteger widthHeight = self.view.tz_width - 2 * left;
    NSInteger top = SCREENH*0.12;
    imagePickerVc.cropRect = CGRectMake(left, top, SCREENW*0.76, SCREENH*0.76);
    
    //ScreenWidth*0.12, ScreenHeight*0.12, ScreenWidth*0.76, ScreenHeight*0.76
    // 设置横屏下的裁剪尺寸
    // imagePickerVc.cropRectLandscape = CGRectMake((self.view.tz_height - widthHeight) / 2, left, widthHeight, widthHeight);
    /*
     [imagePickerVc setCropViewSettingBlock:^(UIView *cropView) {
     cropView.layer.borderColor = [UIColor redColor].CGColor;
     cropView.layer.borderWidth = 2.0;
     }];*/
    
    //imagePickerVc.allowPreview = NO;
    // 自定义导航栏上的返回按钮
    /*
     [imagePickerVc setNavLeftBarButtonSettingBlock:^(UIButton *leftButton){
     [leftButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
     [leftButton setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 20)];
     }];
     imagePickerVc.delegate = self;
     */
    
    // Deprecated, Use statusBarStyle
    // imagePickerVc.isStatusBarDefault = NO;
    imagePickerVc.statusBarStyle = UIStatusBarStyleLightContent;
    
    // 设置首选语言 / Set preferred language
    // imagePickerVc.preferredLanguage = @"zh-Hans";
    
    // 设置languageBundle以使用其它语言 / Set languageBundle to use other language
    // imagePickerVc.languageBundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"tz-ru" ofType:@"lproj"]];
    
#pragma mark - 到这里为止
    
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        icon.image=[photos objectAtIndex:0];
        _tempImage=[photos objectAtIndex:0];
    }];
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}





/*
- (void)actionSheet:(LDActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ([actionSheet isEqual:self.customSheet]) {
        LDImagePicker *imagePicker = [LDImagePicker sharedInstance];
        imagePicker.delegate = self;
        [imagePicker showImagePickerWithType:buttonIndex InViewController:self Scale:(SCREENH/2)/(SCREENW/2)];
    }
}
- (void)imagePicker:(LDImagePicker *)imagePicker didFinished:(UIImage *)editedImage{
  //  self.imgeView.image = editedImage;
      //[self.icon setImage:[ObjectFunction blurryImage:_tempImage withBlurLevel:_slider0.value]];
    _tempImage=editedImage;
    
}

- (void)imagePickerDidCancel:(LDImagePicker *)imagePicker {
    <#code#>
}*/





//滑动变化事件
- (void)progressSliderDidValueChanged:(CGFloat)value {
    self.slider0.value = value;
    //NSLog(@" %f", value);
}




//导航栏右边按钮点击事件
-(void)setBarbutton
{
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -15;
    
    //导航栏中的空白部分？
    UIButton *profileButton = [[UIButton alloc] init];
    // 设置按钮的背景图片
    UIImage* buttonimage=[UIImage imageNamed:@"right1.png"];
    [profileButton setImage:[buttonimage TransformtoSize:CGSizeMake(SCREENW/13, SCREENW/13)] forState:UIControlStateNormal];
    // 设置按钮的尺寸为背景图片的尺寸
    //profileButton.frame = CGRectMake(0, 0, SCREENW/20, SCREENW/20);
    //监听按钮的点击
    [profileButton addTarget:self action:@selector(saveSetting) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *profile = [[UIBarButtonItem alloc] initWithCustomView:profileButton];
    
    self.navigationItem.rightBarButtonItems = @[negativeSpacer,profile];
}



//保存图片事件
-(void)saveSetting
{
    
    if(icon.image==nil)
    {
        [JDLAlertView showAlertViewWithMessage:@"还没有选择背景图片" backgroundStyle:JDLBackgroundStyleNone duration:2 viewController:self];
        return ;
        
    }
    [JDLAlertView showAlertViewWithMessage:@"完成设置" backgroundStyle:JDLBackgroundStyleNone duration:2 viewController:self];
    
    _bg=[[picture alloc]init];
    _bg.content= UIImageJPEGRepresentation(icon.image, 1.0f);
    _bg.PicId=@"systembg";
    
    RLMResults<picture *> *temp = [picture objectsWhere:@"PicId = %@",@"systembg"];
    
    
    //---------------------存图片-------------------------
    if (temp.count == 0) {//如果不存在此数据则存
        [[RLMRealm defaultRealm] transactionWithBlock:^{
            [[RLMRealm defaultRealm] addObject:_bg];
        }];
    } else { //存在此数据则改
        //   NSLog(@"数据库已经有该条数据,只需要修改");
        _bg=[[picture objectsWhere:@"PicId=%@",@"systembg"]firstObject];
        [[RLMRealm defaultRealm] transactionWithBlock:^{
            _bg.content= UIImageJPEGRepresentation(icon.image, 1.0f);
            //再存
            [[RLMRealm defaultRealm] addObject:_bg];
        }];
    }
    //---------------------存模糊度 透明度--------------------------
    RLMResults<appStat *>* temp1=[appStat objectsWhere:@"appstatId = %@",@"systembgAlpha"];
    RLMResults<appStat *>* temp2=[appStat objectsWhere:@"appstatId = %@",@"_systembgAlpha"];
    
    if (temp1.count == 0) {
        
    } else {
        
        appStat* appstat1=[[appStat objectsWhere:@"appstatId=%@",@"systembgAlpha"]firstObject];
        [[RLMRealm defaultRealm] transactionWithBlock:^{
            appstat1.stat=_slider0.value;
            //再存
            [[RLMRealm defaultRealm] addObject:appstat1];
        }];
    }
    
    if (temp2.count == 0) {
        
    } else {
        appStat* appstat2=[[appStat objectsWhere:@"appstatId=%@",@"_systembgAlpha"]firstObject];
        [[RLMRealm defaultRealm] transactionWithBlock:^{
            appstat2.stat=1-_slider1.value;
            //再存
            [[RLMRealm defaultRealm] addObject:appstat2];
        }];
    }
    
    [self viewWillAppear:YES];
    //  [self dismissViewControllerAnimated:YES completion:nil];
}



//--------------------取背景图数据-------------------------------
- (void)viewWillAppear:(BOOL)animated {
    //取背景图像
    RLMResults<picture *>* temp2=[picture objectsWhere:@"PicId = %@",@"systembg"];
    NSLog(@"%@",temp2);
    if (temp2.count == 0) {
        
    } else {
        picture* p1=[[picture objectsWhere:@"PicId=%@",@"systembg"]firstObject];
        UIImage *_decodedImage = [UIImage imageWithData:p1.content];
        
        _BG.image=_decodedImage;
        icon.image=_decodedImage;
        _tempImage=_decodedImage;
    }
    
    //取背景模糊度
    RLMResults<appStat *>* temp3=[appStat objectsWhere:@"appstatId = %@",@"systembgAlpha"];
    if (temp3.count == 0) {
        
    } else {
        
        appStat* appstat1=[[appStat objectsWhere:@"appstatId=%@",@"systembgAlpha"]firstObject];
        if(_BG.image!=nil)
        {
            [_BG setImage:[ObjectFunction blurryImage: _BG.image withBlurLevel:appstat1.stat]];
        }
        if(icon.image!=nil)
        {
            [icon setImage:[ObjectFunction blurryImage: icon.image withBlurLevel:appstat1.stat]];
        }
        
        //  _visualEfView.alpha=appstat1.stat;
        //  _BG_visualEfView.alpha=appstat1.stat;
        _slider0.value=appstat1.stat;
    }
    
    RLMResults<appStat *>* temp4=[appStat objectsWhere:@"appstatId = %@",@"_systembgAlpha"];
    if (temp4.count == 0) {
        
    } else {
        
        appStat* appstat2=[[appStat objectsWhere:@"appstatId=%@",@"_systembgAlpha"]firstObject];
        if(_BG.image!=nil)
        {
            _pView.backgroundColor=[UIColor blackColor];
            _BG.alpha=appstat2.stat;
        }
        if(icon.image!=nil)
        {
            icon.alpha=appstat2.stat;
        }
        _slider1.value=1-appstat2.stat;
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [self removeObserver:self forKeyPath:@"num" context:nil];
    // Dispose of any resources that can be recreated.
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


@end
