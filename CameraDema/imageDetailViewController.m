//
//  imageDetailViewController.m
//  CameraDema
//
//  Created by Eric on 2017/2/9.
//  Copyright © 2017年 micaimanong. All rights reserved.
//
#define kMainScreenWidth [UIScreen mainScreen].bounds.size.width
#define kMainScreenHeight  [UIScreen mainScreen].bounds.size.height
#import "imageDetailViewController.h"
#import "imageViewViewController.h"

@interface imageDetailViewController ()
{
    UIImage *imageIm;

}
@end

@implementation imageDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    UIImageView *imageView =[[UIImageView alloc] initWithFrame:CGRectMake(0, -64, kMainScreenWidth, kMainScreenHeight)];
    imageView.image = [UIImage imageWithData:_data];
    [self.view addSubview:imageView];
   imageIm =[UIImage imageWithData:_data];
    CGSize originalsize = [ imageView.image size];
    
     NSLog(@"改变前图片的宽度为%f,图片的高度为%f",originalsize.width,originalsize.height);
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(15, kMainScreenHeight - 50, 40, 40);
    [button setTitle:@"重拍" forState:UIControlStateNormal];
    [button setTintColor:[UIColor whiteColor]];
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    CALayer *Mylayer=[CALayer layer];
    Mylayer.bounds=CGRectMake(10, (kMainScreenHeight - (kMainScreenWidth - 20)/1.6)/2, kMainScreenWidth - 20, (kMainScreenWidth - 20)/1.6);
    Mylayer.position=CGPointMake(kMainScreenWidth/2, (kMainScreenHeight - 120)/2);
    Mylayer.masksToBounds=YES;
    Mylayer.borderWidth=1;
    Mylayer.borderColor=[UIColor whiteColor].CGColor;
    [self.view.layer addSublayer:Mylayer];
    
    
    
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    rightButton.frame = CGRectMake(kMainScreenWidth - 90, kMainScreenHeight - 50, 80, 40);
    [rightButton setTitle:@"使用照片" forState:UIControlStateNormal];
    [rightButton setTintColor:[UIColor whiteColor]];
    [rightButton addTarget:self action:@selector(rightButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightButton];

    // Do any additional setup after loading the view.
}

-(void)rightButton{
    
    CGRect rect =CGRectMake(10, (kMainScreenHeight - (kMainScreenWidth - 20) /1.6)/2, kMainScreenWidth - 20 , (kMainScreenWidth - 20)/1.6);
 
    
   
    imageIm = [self image:imageIm scaleToSize:CGSizeMake(kMainScreenWidth, kMainScreenHeight)];
    imageIm = [self imageFromImage:imageIm inRect:rect];
     UIImageWriteToSavedPhotosAlbum(imageIm, self, nil, nil);
    imageViewViewController *imageView = [[imageViewViewController alloc]init];
    imageView.image = imageIm;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:imageView];
//    [self.navigationController pushViewController:nav animated:YES];
    [self presentViewController:nav animated:YES completion:nil];
   
}

//截取图片
-(UIImage*)image:(UIImage *)imageI scaleToSize:(CGSize)size{
    
    UIGraphicsBeginImageContext(size);
    
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
