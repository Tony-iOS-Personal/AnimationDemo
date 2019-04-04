//
//  UIImageViewController.m
//  AnimationDemo
//
//  Created by 邵广涛 on 2019/3/30.
//  Copyright © 2019年 SGT. All rights reserved.
//

#import "UIImageViewController.h"

@interface UIImageViewController ()

@property (strong,nonatomic) UIImageView *imgV;

@end

@implementation UIImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.imgV];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(20, 300, 50, 50);
//    btn.backgroundColor = [UIColor redColor];
    [btn setImage:[UIImage imageNamed:@"switch"] forState:(UIControlStateNormal)];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btn];
}
-(void)btnClick{
    //首先判断视图是否在动画，如果在动画，关闭动画
    if ([self.imgV isAnimating]) {
        [self clearAinimationImageMemory];
    }else{
        //设置视图的动画属性
        //设置UIImageViews 动画图片数组
        self.imgV.animationImages = [self imageArr];
        //设置动画时长
        [self.imgV setAnimationDuration:26/10.0];
        //设置动画次数
        [self.imgV setAnimationRepeatCount:1];
        //开始动画
        [self.imgV startAnimating];
        
        [self performSelector:@selector(clearAinimationImageMemory) withObject:nil afterDelay:3.f];// 此处我在执行完序列帧以后我执行了一个清除内存的操作
    }
}
// 清除animationImages所占用内存
- (void)clearAinimationImageMemory {
    [self.imgV stopAnimating];
    self.imgV.animationImages = nil;
}
-(UIImageView *)imgV{
    if (!_imgV) {
        _imgV = [[UIImageView alloc]initWithFrame:self.view.bounds];
        _imgV.image = [UIImage imageNamed:@"cat_angry0000.jpg"];
    }
    return _imgV;
}
-(NSMutableArray *)imageArr{
    NSMutableArray *imageArr = [NSMutableArray array];
    for (NSInteger i = 0; i < 26; i++) {
        NSString *imageFile = [NSString stringWithFormat:@"cat_angry%04ld.jpg", (long)i];
        //imageNamed带有缓存，通过它创建的图片会放到缓存中
        //UIImage *image = [UIImage imageNamed:imageFile];
        //imageWithContentsOfFile这种方式不带缓存，不会使内存占用率飙升
        NSString *path = [[NSBundle mainBundle] pathForResource:imageFile ofType:nil];
        UIImage *image = [UIImage imageWithContentsOfFile:path];
        [imageArr addObject:image];
        
    }
    return imageArr;
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
