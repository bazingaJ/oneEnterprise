//
//  JDLoginController.m
//  E+TAXI_company
//
//  Created by jeaderq on 16/6/24.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import "JDLoginController.h"
#import "JDMainViewController.h"
#import "JDForgotController.h"

@interface JDLoginController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *accountT;
@property (weak, nonatomic) IBOutlet UITextField *passwordT;

@end

@implementation JDLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    /**请求公钥*/
    [JDTools getPublicKey];
    NSLog(@"clientID ===%@",CLIENTID);
    _passwordT.secureTextEntry = YES;
    _passwordT.clearsOnBeginEditing = YES;
    _accountT.clearsOnBeginEditing = YES;
    _passwordT.returnKeyType =UIReturnKeyDone;
    _accountT.returnKeyType =UIReturnKeyDone;
    [_passwordT setValue:RGBColor(204, 204, 204) forKeyPath:@"_placeholderLabel.textColor"];
    [_passwordT setValue:[UIFont boldSystemFontOfSize:16] forKeyPath:@"_placeholderLabel.font"];
    [_accountT setValue:RGBColor(204, 204, 204) forKeyPath:@"_placeholderLabel.textColor"];
    [_accountT setValue:[UIFont boldSystemFontOfSize:16] forKeyPath:@"_placeholderLabel.font"];
    [self.accountT addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    // Do any additional setup after loading the view from its nib.
}
-(void)textFieldDidChange :(UITextField *)tf{



}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)even{
    [self.view endEditing:YES];
}
- (IBAction)fogotPassword:(UIButton *)sender {

    JDForgotController *forgot = [[JDForgotController alloc]init];
    [self.navigationController pushViewController:forgot animated:YES];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"NavW"]  forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}
+(void)automaticLogin{
  
    
    JDData *data = [JDData new];
    [data goLoginWithloginWithUserName:USERNAME WithPsw:nil withPostType:@"0" withManual:@"0" withCompletion:^(NSString *returnCode, NSString *msg) {
        JDLog(@"自动登录结果returnCode%@",returnCode);
    }];
}
+(void)logOut{
    JDData *data = [JDData new];
    [data goLoginWithloginWithUserName:USERNAME WithPsw:nil withPostType:@"4" withManual:nil withCompletion:^(NSString *returnCode, NSString *msg) {
        JDLog(@"退出登录returnCode===%@",returnCode);
    }];

}
- (IBAction)goMain:(UIButton *)sender {
    /**请求公钥*/
    [JDTools getPublicKey];

    [self.view endEditing:YES];
    if ([self.accountT.text isEqualToString:@""]||[self.passwordT.text isEqualToString:@""])
    {
        [JDTools hiddenMBWithDelayTimeInterval:0];
        [JDTools addAlertViewInView:self title:@"温馨提示" message:@"输入的用户名或者密码不能为空" count:0 doWhat:nil];
    }
//    else if (self.passwordT.text.length<6)
//    {
//        [JDTools addAlertViewInView:self title:@"温馨提示" message:@"您的密码输入格式不对" count:0 doWhat:nil];
//    }
    else
    {
//        if ([JDTools validatePhone:self.accountT.text]&&[JDTools validatePassword:self.passwordT.text])
//        {
        
        NSLog(@"%@  ===%@",self.accountT.text,self.passwordT.text);
            [JDTools addMBProgressWithView:self.view style:0];
            [JDTools showMBWithTitle:@"正在登陆..."];
            NSString * pass=[EPRSA encryptString:self.passwordT.text publicKey:publicKeyRSA];
            JDData *data = [JDData new];
            if (CLIENTID==nil)
            {
                [JDTools addAlertViewInView:self title:@"温馨提示" message:@"您的网络有点问题,请重试" count:0 doWhat:nil];
            }else{
                [data goLoginWithloginWithUserName:self.accountT.text WithPsw:pass withPostType:@"0" withManual:@"1" withCompletion:^(NSString *returnCode, NSString *msg) {
                    switch ([returnCode intValue])
                    {
                        case 0:
                        {
                            [JDTools hiddenMBWithDelayTimeInterval:0];
                        JDMainViewController *main = [[JDMainViewController alloc]init];
                            
                            UINavigationController*nav = [[UINavigationController alloc]initWithRootViewController:main];
                            [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
                            [nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"navBG"]  forBarMetrics:UIBarMetricsDefault];
                            [nav.navigationBar setShadowImage:[UIImage new]];
                            [UIApplication sharedApplication].keyWindow.rootViewController = nav;
                            break;
                        }
                        case 1:
                        {
                            [JDTools hiddenMBWithDelayTimeInterval:0];
                            [JDTools addAlertViewInView:self title:@"温馨提示" message:msg count:0 doWhat:nil];
                        }
                            break;
                        case 2:
                        {
                            [JDTools hiddenMBWithDelayTimeInterval:0];
                            [JDTools addAlertViewInView:self title:@"温馨提示" message:msg count:0 doWhat:nil];
                        }
                            break;
                        case 666:
                        {
                            [JDTools hiddenMBWithDelayTimeInterval:0];
                            [JDTools addAlertViewInView:self title:@"温馨提示" message:@"您的网络有点问题,请重试" count:0 doWhat:nil];
                        }
                            break;
                            
                        default:
                            break;
                    }
                }];
            }
//        }else
//        {
//            [JDTools addAlertViewInView:self title:@"温馨提示" message:@"请输入正确的手机号" count:0 doWhat:nil];
//        }
    }
    
//      [self dismissViewControllerAnimated:YES completion:^{
//      }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//限制文本框输入的字数长度
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
//    if (textField == self.passwordT)
//    {
//        NSInteger loc =range.location;
//        if (loc < 6)
//        {
//            return YES;
//        }
//        else
//        {
//            return NO;
//        }
//    }else if (textField == self.accountT)
//    {
//        NSInteger loc =range.location;
//        if (loc < 11)
//        {
//            return YES;
//        }
//        else
//        {
//            return NO;
//        }
//    }
//    return NO;
    return YES;
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
