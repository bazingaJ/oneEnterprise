//
//  JDRestPasswordController.m
//  E+TAXI_company
//
//  Created by jeaderq on 16/7/1.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import "JDRestPasswordController.h"
#import "JDMainViewController.h"
@interface JDRestPasswordController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *NPassWordT;
@property (weak, nonatomic) IBOutlet UITextField *NPassWordTT;

@end

@implementation JDRestPasswordController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setpopItem];
    // Do any additional setup after loading the view from its nib.
}
-(void)setpopItem{
    self.navigationItem.titleView = [JDTools setTitleViewWithTitle:@""];
    UIButton *custumItem =[UIButton buttonWithType:UIButtonTypeCustom];
    [custumItem setBackgroundImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [custumItem setBackgroundImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateHighlighted];
    custumItem.frame = CGRectMake(0,0, 24, 24);
    [custumItem addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * backTopItem = [[UIBarButtonItem alloc]initWithCustomView:custumItem];
    self.navigationItem.leftBarButtonItem = backTopItem;
}
-(void)pop{
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)RestBtn:(UIButton *)sender {
    
    if (self.NPassWordT.text.length==0) {
        [JDTools addAlertViewInView:self title:@"温馨提示" message:@"密码不能为空" count:0 doWhat:nil];
    }else{
        if (![self.NPassWordT.text isEqualToString:self.NPassWordTT.text]) {
            [JDTools addAlertViewInView:self title:@"温馨提示" message:@"两次输入的密码不相同" count:0 doWhat:nil];
        }else{
            /**请求公钥*/
            [JDTools getPublicKey];
            NSString * pass=[EPRSA encryptString:self.NPassWordT.text publicKey:publicKeyRSA];
            JDData *data = [JDData new];
            [data goLoginWithloginWithUserName:self.userName WithPsw:pass withPostType:@"3" withManual:self.validCode withCompletion:^(NSString *returnCode, NSString *msg) {
                if ([returnCode intValue]==0) {
                    NSLog(@"%@",msg);
                    [JDTools addAlertViewInView:self title:@"温馨提示" message:@"密码修改成功" count:0 doWhat:^{
                        [self goMain];
                    }];

                }else{
                    [JDTools addAlertViewInView:self title:@"温馨提示" message:msg count:0 doWhat:^{
                    }];
                }
            }];
        }
    }
}
-(void)goMain{
    
    JDMainViewController *main = [[JDMainViewController alloc]init];
    
    UINavigationController*nav = [[UINavigationController alloc]initWithRootViewController:main];
    
    [nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"navBG"]  forBarMetrics:UIBarMetricsDefault];
    [nav.navigationBar setShadowImage:[UIImage new]];
    
    [UIApplication sharedApplication].keyWindow.rootViewController = nav;
    
}
//限制文本框输入的字数长度
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
        NSInteger loc =range.location;
        if (loc < 19)
        {
            return YES;
        }
        else
        {
            return NO;
        }
      return NO;

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
