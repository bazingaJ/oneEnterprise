//
//  JDSetUpController.m
//  E+TAXI_company
//
//  Created by jeaderq on 16/6/30.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import "JDSetUpController.h"
#import "JDLoginController.h"
#import "JDModifyPSWController.h"
#import "JDReplacePhoneController.h"




@interface JDSetUpController ()

@end

@implementation JDSetUpController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setpopItem];
    // Do any additional setup after loading the view from its nib.
}
-(void)setpopItem{
    self.navigationItem.titleView = [JDTools setTitleViewWithTitle:@"设置"];
    UIButton *custumItem =[UIButton buttonWithType:UIButtonTypeCustom];
    [custumItem setBackgroundImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    custumItem.frame = CGRectMake(0,0, 24, 24);
    [custumItem addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * backTopItem = [[UIBarButtonItem alloc]initWithCustomView:custumItem];
    self.navigationItem.leftBarButtonItem = backTopItem;
}
-(void)pop{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//修改密码
- (IBAction)clickPassword:(UIButton *)sender {
    JDModifyPSWController *modify = [[JDModifyPSWController alloc]init];
    modify.isPassword = YES;
    [self.navigationController pushViewController:modify animated:YES];
}
//修改手机
- (IBAction)clickPhone:(UIButton *)sender {
    
    JDModifyPSWController *modify =[[JDModifyPSWController alloc]init];
    modify.isPassword = NO;
    [self.navigationController pushViewController:modify animated:YES];
    
}
//退出登录
- (IBAction)getOut:(UIButton *)sender {
    [JDTools addAlertViewInView:self title:@"温馨提示" message:@"您确认要退出登录" count:1 doWhat:^{
        [JDLoginController logOut];
        [JDData publicDeleteInfo];
        JDLoginController *login = [[JDLoginController alloc]init];
        UINavigationController*nav = [[UINavigationController alloc]initWithRootViewController:login];
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
        [nav.navigationBar setBackgroundImage:[UIImage new]  forBarMetrics:UIBarMetricsDefault];
        [nav.navigationBar setShadowImage:[UIImage new]];
        [UIApplication sharedApplication].keyWindow.rootViewController = nav;
    }];
    
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
