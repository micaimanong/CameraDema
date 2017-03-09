//
//  imageDetailViewController.m
//  CameraDema
//
//  Created by micaimanong on 2017/2/9.
//  Copyright © 2017年 micaimanong. All rights reserved.
//
#define SelfWidth [UIScreen mainScreen].bounds.size.width
#define SelfHeight  [UIScreen mainScreen].bounds.size.height
#import "imageDetailViewController.h"

@interface imageDetailViewController ()
{
    UIImage *imageIm;

}
@end

@implementation imageDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    UIImageView *imageView =[[UIImageView alloc] initWithFrame:CGRectMake(0, -64, SelfWidth, SelfHeight)];
    imageView.image = [UIImage imageWithData:_data];
    [self.view addSubview:imageView];
   imageIm =[UIImage imageWithData:_data];
    CGSize originalsize = [ imageView.image size];
    
     NSLog(@"改变前图片的宽度为%f,图片的高度为%f",originalsize.width,originalsize.height);
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(15, SelfHeight - 50, 40, 40);
    [button setTitle:@"重拍" forState:UIControlStateNormal];
    [button setTintColor:[UIColor whiteColor]];
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    CALayer *Mylayer=[CALayer layer];
    Mylayer.bounds=CGRectMake(10, (SelfHeight - (SelfWidth - 20)/1.6)/2, SelfWidth - 20, (SelfWidth - 20)/1.6);
    Mylayer.position=CGPointMake(SelfWidth/2, (SelfHeight - 120)/2);
    Mylayer.masksToBounds=YES;
    Mylayer.borderWidth=1;
    Mylayer.borderColor=[UIColor whiteColor].CGColor;
    [self.view.layer addSublayer:Mylayer];
    
    
    
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    rightButton.frame = CGRectMake(SelfWidth - 90, SelfHeight - 50, 80, 40);
    [rightButton setTitle:@"使用照片" forState:UIControlStateNormal];
    [rightButton setTintColor:[UIColor whiteColor]];
    [rightButton addTarget:self action:@selector(rightButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightButton];

    // Do any additional setup after loading the view.
}

-(void)rightButton{
   
    
    //截取照片，截取到自定义框内的照片
    imageIm = [self image:imageIm scaleToSize:CGSizeMake(SelfWidth, SelfHeight)];
    //应为在展开相片时放大的两倍，截取时也要放大两倍
    imageIm = [self imageFromImage:imageIm inRect:CGRectMake(10*2, (SelfHeight - (SelfWidth - 20) /1.6)/2*2, (SelfWidth - 20)*2 , (SelfWidth - 20)/1.6*2)];
    
    //将图片存储到相册
     UIImageWriteToSavedPhotosAlbum(imageIm, self, nil, nil);
    
   //截取之后将图片显示在照相时页面，和拍摄时的照片进行像素对比
    UIImageView *imageView =[[UIImageView alloc] initWithFrame:CGRectMake(10, (SelfHeight - (SelfWidth - 20) /1.6)/2  + 170, SelfWidth - 20 , (SelfWidth - 20)/1.6)];
    imageView.image = imageIm;
    [self.view addSubview:imageView];

}

//截取图片
-(UIImage*)image:(UIImage *)imageI scaleToSize:(CGSize)size{
   /*
    UIGraphicsBeginImageContextWithOptions(CGSize size, BOOL opaque, CGFloat scale)
    CGSize size：指定将来创建出来的bitmap的大小
    BOOL opaque：设置透明YES代表透明，NO代表不透明
    CGFloat scale：代表缩放,0代表不缩放
    创建出来的bitmap就对应一个UIImage对象
    */
    UIGraphicsBeginImageContextWithOptions(size, NO, 2.0); //此处将画布放大两倍，这样在retina屏截取时不会影响像素
    
    [imageI drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;
}
-(UIImage *)imageFromImage:(UIImage *)imageI inRect:(CGRect)rect{
    
    CGImageRef sourceImageRef = [imageI CGImage];
    
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, rect);
    
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    
    return newImage;
}


-(void)back{
    [self dismissViewControllerAnimated:NO completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
