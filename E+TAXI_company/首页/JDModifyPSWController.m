//
//  JDModifyPSWController.m
//  E+TAXI_company
//
//  Created by jeaderq on 16/7/1.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import "JDModifyPSWController.h"
#import "JDConfirmPSWController.h"
#import "JDReplacePhoneController.h"
@interface JDModifyPSWController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *oldPassword;

@end

@implementation JDModifyPSWController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setpopItem];
    // Do any additional setup after loading the view from its nib.
}
-(void)setpopItem{
    self.navigationItem.titleView = [JDTools setTitleViewWithTitle:@"验证旧密码"];

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
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navBG"]  forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}
- (IBAction)nextClick:(UIButton *)sender {
    /**请求公钥*/
    [JDTools getPublicKey];
    JDData *data = [JDData new];
    NSString * pass=[EPRSA encryptString:self.oldPassword.text publicKey:publicKeyRSA];
    [data goLoginWithloginWithUserName:USERNAME WithPsw:pass withPostType:@"5" withManual:nil withCompletion:^(NSString *returnCode, NSString *msg) {
        JDLog(@"%s%@",__func__,returnCode);
        if ([returnCode intValue]==0) {
            
            if (self.isPassword == YES) {
                
                JDConfirmPSWController *confirm = [[JDConfirmPSWController alloc]init];
                confirm.oldPassword = self.oldPassword.text;
                [self.navigationController pushViewController:confirm animated:YES];
                self.oldPassword.text = @"";

            }else{
                JDReplacePhoneController *confirm = [[JDReplacePhoneController alloc]init];
                confirm.oldPassword = self.oldPassword.text;
                [self.navigationController pushViewController:confirm animated:YES];
                self.oldPassword.text = @"";

            }
        }else{
            [JDTools addAlertViewInView:self title:@"温馨提示" message:msg count:0 doWhat:^{
            }];

        }
        
    }];
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
