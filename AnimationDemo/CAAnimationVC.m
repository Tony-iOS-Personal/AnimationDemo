//
//  CAAnimationVC.m
//  AnimationDemo
//
//  Created by 邵广涛 on 2019/3/28.
//  Copyright © 2019年 SGT. All rights reserved.
//

#import "CAAnimationVC.h"

@interface CAAnimationVC ()<CAAnimationDelegate>
{
    NSInteger _transtionIndex;
}
@property(nonatomic,strong)CALayer *animationLayer;
//
@property(nonatomic,strong)CADisplayLink *displayLink;

@end

@implementation CAAnimationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title = @"CAAnimationVC动画";
    
    NSArray *buttonNames = @[@"位移",@"缩放",@"透明度",@"旋转",@"圆角",@"spring动画",@"晃动",@"曲线位移",@"转场",@"动画组"];
    
    self.animationLayer = [[CALayer alloc] init];
    _animationLayer.bounds = CGRectMake(0, 0, 100, 100);
    _animationLayer.position = self.view.center;
    _animationLayer.backgroundColor = [UIColor redColor].CGColor;
    [self.view.layer addSublayer:_animationLayer];
    //
    for (int i = 0; i < buttonNames.count; i++) {
        UIButton *aniButton = [UIButton buttonWithType:UIButtonTypeCustom];
        aniButton.tag = i;
        [aniButton setTitle:buttonNames[i] forState:UIControlStateNormal];
        aniButton.exclusiveTouch = YES;
        aniButton.frame = CGRectMake(10, 50 + 60 * i, 100, 50);
        aniButton.backgroundColor = [UIColor blueColor];
        [aniButton addTarget:self action:@selector(tapAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:aniButton];
    }
    
    
    NSArray *btnNames = @[@"暂停",@"恢复",@"停止"];
    
    for (int i = 0; i < btnNames.count; i++) {
        UIButton *aniButton = [UIButton buttonWithType:UIButtonTypeCustom];
        aniButton.tag = 100 + i;
        [aniButton setTitle:btnNames[i] forState:UIControlStateNormal];
        aniButton.exclusiveTouch = YES;
        aniButton.frame = CGRectMake(300, 50 + 60 * i, 80, 50);
        aniButton.backgroundColor = [UIColor orangeColor];
        [aniButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:aniButton];
    }
}


-(void)tapAction:(UIButton*)button{
    if (button.tag < 5) {
        [self basicAnimationWithTag:button.tag];
    }else if(button.tag == 5){
        [self springAnimation];
    }else if (button.tag == 6 || button.tag == 7){
        [self keyframeAnimationWithTag:button.tag];
    }else if (button.tag == 8){
        [self transitionAnimation];
    }else{
        [self animationGroup];
    }
    
}

-(void)handleDisplayLink:(CADisplayLink *)displayLink{
    NSLog(@"modelLayer_%@,presentLayer_%@",[NSValue valueWithCGPoint:_animationLayer.position],[NSValue valueWithCGPoint:_animationLayer.presentationLayer.position]);
}

-(void)basicAnimationWithTag:(NSInteger)tag{
    CABasicAnimation *basicAni = nil;
    switch (tag) {
        case 0:
            //初始化动画并设置keyPath
            basicAni = [CABasicAnimation animationWithKeyPath:@"position"];
            //到达位置
            basicAni.byValue = [NSValue valueWithCGPoint:CGPointMake(100, 100)];
            break;
        case 1:
            basicAni = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
            //到达缩放
            basicAni.toValue = @(0.1f);
            break;
        case 2:
            basicAni = [CABasicAnimation animationWithKeyPath:@"opacity"];
            basicAni.toValue=@(0.1f);
            break;
        case 3:
            basicAni = [CABasicAnimation animationWithKeyPath:@"transform"];
            //3D
            basicAni.toValue=[NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI_2+M_PI_4, 1, 1, 0)];
            break;
        case 4:
            basicAni = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
            //圆角
            basicAni.toValue=@(50);
            break;
        default:
            break;
    }
    
    //设置代理
    basicAni.delegate = self;
    //延时执行
    //basicAni.beginTime = CACurrentMediaTime() + 2;
    //动画时间
    basicAni.duration = 1;
    //动画节奏
    basicAni.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    //动画速率
    //basicAni.speed = 0.1;
    //图层是否显示执行后的动画执行后的位置以及状态
    //basicAni.removedOnCompletion = NO;
    //basicAni.fillMode = kCAFillModeForwards;
    //动画完成后是否以动画形式回到初始值
    basicAni.autoreverses = YES;
    //动画时间偏移
    //basicAni.timeOffset = 0.5;
    //添加动画
    NSString *key = NSStringFromSelector(_cmd);
    NSLog(@"动画的key ======= %@",key);
    [_animationLayer addAnimation:basicAni forKey:key];
}
//CASpringAnimation
-(void)springAnimation{
    CASpringAnimation *springAni = [CASpringAnimation animationWithKeyPath:@"position"];
    springAni.damping = 2;
    springAni.stiffness = 50;
    springAni.mass = 1;
    springAni.initialVelocity = 2;
    springAni.toValue = [NSValue valueWithCGPoint:CGPointMake(270, 350)];
    springAni.duration = springAni.settlingDuration;
    [_animationLayer addAnimation:springAni forKey:@"springAnimation"];
}
//关键帧动画
-(void)keyframeAnimationWithTag:(NSInteger)tag{
    CAKeyframeAnimation *keyFrameAni = nil;
    if (tag == 6) {
        //晃动
        keyFrameAni = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
        keyFrameAni.duration = 2;
        keyFrameAni.values = @[@(-(6) / 180.0*M_PI),@((6) / 180.0*M_PI),@(-(5) / 180.0*M_PI),@((5) / 180.0*M_PI),@(-(4) / 180.0*M_PI),@((4) / 180.0*M_PI),@(-(4) / 180.0*M_PI)];
        keyFrameAni.keyTimes = @[ @(0), @(0.225), @(0.425), @(0.6), @(0.75), @(0.875), @(1)];
        keyFrameAni.repeatCount = MAXFLOAT;
    }else if (tag == 7){
        //曲线位移
        keyFrameAni = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:_animationLayer.position];
        [path addCurveToPoint:CGPointMake(300, 500) controlPoint1:CGPointMake(100, 400) controlPoint2:CGPointMake(270, 460)];
        keyFrameAni.path = path.CGPath;
        keyFrameAni.duration = 1;
    }
    [_animationLayer addAnimation:keyFrameAni forKey:@"keyFrameAnimation"];
}
//转场动画
-(void)transitionAnimation{
    CATransition *transtion = [CATransition animation];
//    transtion.type = @"rippleEffect";
//    transtion.subtype = kCATransitionFromLeft;//kCATransitionFromLeft  kCATransitionFromRight
    transtion.duration = 1;
    _transtionIndex++;
    switch (_transtionIndex) {
        case 1:
            transtion.type = @"cube";
            transtion.subtype = kCATransitionFromLeft;
            _animationLayer.backgroundColor = [UIColor yellowColor].CGColor;
            break;
        case 2:
            transtion.type = @"rippleEffect";
            transtion.subtype = kCATransitionFromTop;
            _animationLayer.backgroundColor = [UIColor blueColor].CGColor;
            break;
        case 3:
            transtion.type = @"moveIn";
            transtion.subtype = kCATransitionFromRight;
            _animationLayer.backgroundColor = [UIColor magentaColor].CGColor;
            break;
        case 4:
            transtion.type = @"suckEffect";
            transtion.subtype = kCATransitionFromBottom;
            _animationLayer.backgroundColor = [UIColor orangeColor].CGColor;
            break;
        default:
            break;
    }
    if (_transtionIndex >= 4) {
        _transtionIndex = 1;
    }
    [_animationLayer addAnimation:transtion forKey:@"transtion"];
}



//动画组
-(void)animationGroup{
    //弹动动画
    CAKeyframeAnimation *keyFrameAni = [CAKeyframeAnimation animationWithKeyPath:@"position.y"];
    CGFloat ty = _animationLayer.position.y;
    keyFrameAni.values = @[@(ty - 100),@(ty),@(ty - 50),@(ty)];
    //每一个动画可以单独设置时间和重复次数,在动画组的时间基础上,控制单动画的效果
    keyFrameAni.duration = 0.3;
    keyFrameAni.repeatCount= MAXFLOAT;
    keyFrameAni.delegate = self;
    //
    //圆角动画
    CABasicAnimation *basicAni = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
    //到达位置
    basicAni.byValue = @(_animationLayer.bounds.size.width/2);
    //
    basicAni.duration = 1;
    basicAni.repeatCount = 1;
    //
    basicAni.removedOnCompletion = NO;
    basicAni.fillMode = kCAFillModeForwards;
    //设置代理
    basicAni.delegate = self;
    //动画时间
    basicAni.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    CAAnimationGroup *aniGroup = [CAAnimationGroup animation];
    aniGroup.animations = @[keyFrameAni,basicAni];
    aniGroup.autoreverses = YES;
    //动画的表现时间和重复次数由动画组设置的决定
    aniGroup.duration = 3;
    aniGroup.repeatCount= MAXFLOAT;
    //
    [_animationLayer addAnimation:aniGroup forKey:@"groupAnimation"];
}
//控制动画状态按钮点击
-(void)btnClick:(UIButton *)sender{
    switch (sender.tag) {
        case 100:
            [self animationPause];
            break;
        case 101:
            [self animationResume];
            break;
        case 102:
            [self animationStop];
            break;
        default:
            break;
    }
}

//暂停动画
-(void)animationPause{
    //获取当前layer的动画媒体时间
    CFTimeInterval interval = [_animationLayer convertTime:CACurrentMediaTime() toLayer:nil];
    //设置时间偏移量,保证停留在当前位置
    _animationLayer.timeOffset = interval;
    //暂定动画
    _animationLayer.speed = 0;
}
//恢复动画
-(void)animationResume{
    //获取暂停的时间
    CFTimeInterval beginTime = CACurrentMediaTime() - _animationLayer.timeOffset;
    //设置偏移量
    _animationLayer.timeOffset = 0;
    //设置开始时间
    _animationLayer.beginTime = beginTime;
    //开始动画
    _animationLayer.speed = 1;
}
//停止动画
-(void)animationStop{
    [_animationLayer removeAllAnimations];//移除当前层所有动画
    //[_animationLayer removeAnimationForKey:@"groupAnimation"];//移除当前层上名称是groupAnimation的动画
}

#pragma mark - CAAnimationDelegate
-(void)animationDidStart:(CAAnimation *)anim{
    
}
#pragma mark ---- 核心动画代理方法 动画结束时
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    NSLog(@"动画 ---- %@  ---- 已停止",anim);
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
