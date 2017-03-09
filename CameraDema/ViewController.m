//
//  ViewController.m
//  CameraDema
//
//  Created by micaimanong on 2017/2/8.
//  Copyright © 2017年 micaimanong. All rights reserved.
//


#define SelfWidth [UIScreen mainScreen].bounds.size.width
#define SelfHeight  [UIScreen mainScreen].bounds.size.height
#import "ViewController.h"
#import "imageDetailViewController.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    
    if (self.session) {
        
        [self.session startRunning];
    }
}


- (void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:YES];
    
    if (self.session) {
        
        [self.session stopRunning];
    }
}

- (void)viewDidLoad {
    self.view.backgroundColor = [UIColor blackColor];
    
    self.backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,SelfWidth, SelfHeight - 120)];
    [self.view addSubview:self.backView];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(SelfWidth/2 - 30, SelfHeight - 120 + 30, 60, 60)];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.cornerRadius = 30;
    [view.layer masksToBounds];
    [self.view addSubview:view];
    
    //自己定义一个和原生的相机一样的按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(SelfWidth/2 - 25, SelfHeight - 120 + 35, 50, 50);
    button.backgroundColor = [UIColor whiteColor];
    button.layer.cornerRadius = 25;
    button.layer.borderWidth = 2;
    button.layer.borderColor = [UIColor blackColor].CGColor;
    [button.layer masksToBounds];
    [button addTarget:self action:@selector(buttondown) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
   //在相机中加个框
    CALayer *Mylayer=[CALayer layer];
    Mylayer.bounds=CGRectMake(10, (SelfHeight - (SelfWidth - 20)/1.6)/2, SelfWidth - 20, (SelfWidth - 20)/1.6);
    Mylayer.position=CGPointMake(SelfWidth/2, (SelfHeight - 120)/2);
    Mylayer.masksToBounds=YES;
    Mylayer.borderWidth=1;
    Mylayer.borderColor=[UIColor whiteColor].CGColor;
    [self.view.layer addSublayer:Mylayer];
    
    
    UIButton *Lbtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    Lbtn.frame = CGRectMake(20, SelfHeight - 80 , 40, 40);
    [Lbtn setTitle:@"取消" forState:UIControlStateNormal];
    Lbtn.titleLabel.font = [UIFont  systemFontOfSize:15];
    [Lbtn setTintColor:[UIColor whiteColor]];
    [Lbtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:Lbtn];
    
    
    [self initAVCaptureSession]; //设置相机属性
    self.effectiveScale = 1.0f;
}

//设置相机属性
- (void)initAVCaptureSession{
    
    self.session = [[AVCaptureSession alloc] init];
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    
    NSError *error;
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    //更改这个设置的时候必须先锁定设备，修改完后再解锁，否则崩溃
    [device lockForConfiguration:nil];
    //设置闪光灯为自动
    [device setFlashMode:AVCaptureFlashModeAuto];
    [device unlockForConfiguration];
    
    self.videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:device error:&error];
    AVCaptureVideoDataOutput *captureOutput = [[AVCaptureVideoDataOutput alloc] init];
    if (error) {
        NSLog(@"%@",error);
    }
    self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    //输出设置。AVVideoCodecJPEG   输出jpeg格式图片
    NSDictionary * outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey, nil];
    [self.stillImageOutput setOutputSettings:outputSettings];
    
    if ([self.session canAddInput:self.videoInput]) {
        [self.session addInput:self.videoInput];
    }
    if ([self.session canAddOutput:captureOutput]) {
        [self.session addOutput:captureOutput];
    }
    if ([self.session canAddOutput:self.stillImageOutput]) {
        [self.session addOutput:self.stillImageOutput];
    }
    
    //初始化预览图层
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    [self.previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    NSLog(@"%f",SelfWidth);
    self.previewLayer.frame = CGRectMake(0, 0,SelfWidth, SelfHeight - 120);
    self.backView.layer.masksToBounds = YES;
    [self.backView.layer addSublayer:self.previewLayer];
}
- (AVCaptureVideoOrientation)avOrientationForDeviceOrientation:(UIDeviceOrientation)deviceOrientation
{
    AVCaptureVideoOrientation result = (AVCaptureVideoOrientation)deviceOrientation;
    if ( deviceOrientation == UIDeviceOrientationLandscapeLeft )
        result = AVCaptureVideoOrientationLandscapeRight;
    else if ( deviceOrientation == UIDeviceOrientationLandscapeRight )
        result = AVCaptureVideoOrientationLandscapeLeft;
    return result;
}

//照相按钮点击事件
-(void)buttondown{
    NSLog(@"takephotoClick...");
    AVCaptureConnection *stillImageConnection = [self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    UIDeviceOrientation curDeviceOrientation = [[UIDevice currentDevice] orientation];
    AVCaptureVideoOrientation avcaptureOrientation = [self avOrientationForDeviceOrientation:curDeviceOrientation];
    [stillImageConnection setVideoOrientation:avcaptureOrientation];
    [stillImageConnection setVideoScaleAndCropFactor:self.effectiveScale];
    
    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:stillImageConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        
        NSData *jpegData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        
        [self makeImageView:jpegData];
        NSLog(@"jpegDatajpegData == %ld",(unsigned long)[jpegData length]/1024);
        
    }];
}


//拍照之后调到相片详情页面
-(void)makeImageView:(NSData*)data{

    imageDetailViewController*imageView = [[imageDetailViewController alloc] init];
    imageView.data = data;
    
    [self presentViewController:imageView animated:NO completion:nil];
    
}
//返回
-(void)back{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
