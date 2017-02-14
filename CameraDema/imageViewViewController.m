//
//  imageViewViewController.m
//  CameraDema
//
//  Created by Eric on 2017/2/14.
//  Copyright © 2017年 micaimanong. All rights reserved.
//
#define kMainScreenWidth [UIScreen mainScreen].bounds.size.width
#define kMainScreenHeight  [UIScreen mainScreen].bounds.size.height
#import "imageViewViewController.h"

@interface imageViewViewController ()

@end

@implementation imageViewViewController





- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGRect rect =CGRectMake(10, (kMainScreenHeight - (kMainScreenWidth - 20) /1.6)/2, kMainScreenWidth - 20 , (kMainScreenWidth - 20)/1.6);

    UIImageView *imageView =[[UIImageView alloc] initWithFrame:rect];
    imageView.image = _image;
    [self.view addSubview:imageView];
    
    // Do any additional setup after loading the view.
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
