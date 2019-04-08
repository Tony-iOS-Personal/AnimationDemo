//
//  ViewController.m
//  AnimationDemo
//
//  Created by 邵广涛 on 2019/3/27.
//  Copyright © 2019年 SGT. All rights reserved.
//

#import "ViewController.h"

#import "UIAnimationViewController.h"
#import "CAAnimationVC.h"
#import "UIImageViewController.h"
#import "CAEmitterLayerVC.h"

NSString *const CellId = @"cellId";


@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,UIViewControllerTransitioningDelegate>

@property(strong,nonatomic) UITableView *tableView;

@property(strong,nonatomic) NSArray *dataArr;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"动画";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.view addSubview:self.tableView];
}

#pragma mark ---Getter
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView  =[[UITableView alloc]initWithFrame:self.view.bounds style:(UITableViewStylePlain)];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellId];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
    }
    return _tableView;
}
-(NSArray *)dataArr{
    if (!_dataArr) {
        _dataArr = @[@"UI动画",@"基础动画",@"序列帧动画",@"粒子动画"];
    }
    return _dataArr;
}


#pragma mark --UITableViewDelegate,UITableViewDataSource


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellId];
    cell.textLabel.text = self.dataArr[indexPath.row];
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIViewController * animaVC;
    CATransition *transtion = [CATransition animation];
    transtion.duration = 2;
    switch (indexPath.row) {
        case 0:
            animaVC = [[UIAnimationViewController alloc]init];
            transtion.type = @"rippleEffect";
            transtion.subtype = kCATransitionFromBottom;//kCATransitionFromLeft  kCATransitionFromRight
            break;
        case 1:
            animaVC = [[CAAnimationVC alloc]init];
            transtion.type = @"cube";
            transtion.subtype = kCATransitionFromRight;
            break;
        case 2:
            animaVC = [[UIImageViewController alloc]init];
            transtion.type = @"MoveIn";
            transtion.subtype = kCATransitionFromRight;
            break;
        case 3:
            animaVC = [[CAEmitterLayerVC alloc]init];
            transtion.type = @"reveal";
            transtion.subtype = kCATransitionFromLeft;
            break;
        default:
            break;
    }
    [self.view.window.layer addAnimation:transtion forKey:nil];
    [self.navigationController pushViewController:animaVC animated:YES];
}

@end
