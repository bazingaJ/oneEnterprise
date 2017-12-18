//
//  JDConfirmPSWController.m
//  E+TAXI_company
//
//  Created by jeaderq on 16/7/1.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import "JDConfirmPSWController.h"

@interface JDConfirmPSWController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nePass;
@property (weak, nonatomic) IBOutlet UITextField *nePass1;

@end

@implementation JDConfirmPSWController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setpopItem];
}
-(void)setpopItem{
    self.navigationItem.titleView = [JDTools setTitleViewWithTitle:@"修改密码"];

    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"NavW"]  forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];

    UIButton *custumItem =[UIButton buttonWithType:UIButtonTypeCustom];
    [custumItem setBackgroundImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    custumItem.frame = CGRectMake(0,0, 24, 24);
    [custumItem addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * backTopItem = [[UIBarButtonItem alloc]initWithCustomView:custumItem];
    self.navigationItem.leftBarButtonItem = backTopItem;
}
-(void)pop{
    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"NavW"]  forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];

}
- (IBAction)restPassword:(UIButton *)sender {
    if (self.nePass.text.length==0) {
        [JDTools addAlertViewInView:self title:@"温馨提示" message:@"密码不能为空" count:0 doWhat:nil];
    }else{
        if (![self.nePass.text isEqualToString:self.nePass1.text]) {
            [JDTools addAlertViewInView:self title:@"温馨提示" message:@"两次输入的密码不相同" count:0 doWhat:nil];
        }else{
            /**请求公钥*/
            [JDTools getPublicKey];
            NSString * pass=[EPRSA encryptString:self.nePass1.text publicKey:publicKeyRSA];
            NSString * pass1=[EPRSA encryptString:self.oldPassword publicKey:publicKeyRSA];
            JDData *data = [JDData new];
            [data goLoginWithloginWithUserName:USERNAME WithPsw:pass1 withPostType:@"2" withManual:pass withCompletion:^(NSString *returnCode, NSString *msg) {
                if ([returnCode intValue]==0) {
                    NSLog(@"%@",msg);
                    [JDTools addAlertViewInView:self title:@"温馨提示" message:@"密码修改成功" count:0 doWhat:^{
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    }];
                    
                }else{
                    [JDTools addAlertViewInView:self title:@"温馨提示" message:msg count:0 doWhat:^{
                    }];
                }
            }];
        }
    }

    
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
