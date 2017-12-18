//
//  JDForgotController.m
//  E+TAXI_company
//
//  Created by jeaderq on 16/6/30.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import "JDForgotController.h"
#import "JDRestPasswordController.h"

@interface JDForgotController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *GetBtn;
@property (weak, nonatomic) IBOutlet UITextField *tfPhone;
@property (weak, nonatomic) IBOutlet UITextField *yanZhengL;

@end

@implementation JDForgotController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setpopItem];
    // Do any additional setup after loading the view from its nib.
}

-(void)setpopItem{
    self.navigationItem.titleView = [JDTools setTitleViewWithTitle:@""];
    UIButton *custumItem =[UIButton buttonWithType:UIButtonTypeCustom];
    [custumItem setBackgroundImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    custumItem.frame = CGRectMake(0,0, 24, 24);
    [custumItem addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * backTopItem = [[UIBarButtonItem alloc]initWithCustomView:custumItem];
    self.navigationItem.leftBarButtonItem = backTopItem;

    [self.GetBtn addTarget:self action:@selector(getBtnClick:) forControlEvents:UIControlEventTouchUpInside];

}
-(void)pop{
    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]  forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)getBtnClick:(UIButton *)sender {
    
    
    if (self.tfPhone.text.length==0) {
        [JDTools addAlertViewInView:self title:@"温馨提示" message:@"用户名或手机号不能为空" count:0 doWhat:nil];
    }else{

        NSString * url=[NSString  stringWithFormat:@"%@/getVaildCodeForManagement.json",JDUrl];
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:self.tfPhone.text forKey:@"userName"];
        [dict setObject:@"0" forKey:@"type"];
        AFHTTPRequestOperationManager * manager =[AFHTTPRequestOperationManager manager];
        [manager GET:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            int  returnCode=[[responseObject objectForKey:@"returnCode"] intValue];
            if (returnCode==0)
            {
                NSUserDefaults * us =[NSUserDefaults standardUserDefaults];
                [us setValue:self.tfPhone.text forKey:@"phonePass"];
                [us synchronize];
                [JDTools addAlertViewInView:self title:@"温馨提示" message:@"成功发送验证码" count:0 doWhat:nil];
                [sender startWithTime:59 title:@"重新获取" countDownTitle:@"秒后重试" mainColor:RGBColor(75, 187, 245)  countColor:[UIColor whiteColor]];
            }
            else if (returnCode==1)
            {
                NSString * msg=[responseObject objectForKey:@"msg"];
                [JDTools addAlertViewInView:self title:@"温馨提示" message:msg count:0 doWhat:nil];
            }else if (returnCode==2)
            {
                NSString * msg=[responseObject objectForKey:@"msg"];
                [JDTools addAlertViewInView:self title:@"温馨提示" message:msg count:0 doWhat:nil];
            }else{
                [JDTools addAlertViewInView:self title:@"温馨提示" message:@"数据获取失败，请稍后重试" count:0 doWhat:nil];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@",error);
        }];
    }



}
//下一步
- (IBAction)nextClick:(UIButton *)sender {
    if (self.tfPhone.text.length==0) {
        [JDTools addAlertViewInView:self title:@"温馨提示" message:@"用户名或手机号不能为空" count:0 doWhat:nil];
    }else{
    JDData *data = [JDData new];
    [data goLoginWithloginWithUserName:self.tfPhone.text WithPsw:nil withPostType:@"6" withManual:self.yanZhengL.text withCompletion:^(NSString *returnCode, NSString *msg) {
        if ([returnCode intValue]==0) {
            JDRestPasswordController *forgot = [[JDRestPasswordController alloc]init];
            forgot.validCode =self.yanZhengL.text;
            forgot.userName = self.tfPhone.text;
            [self.navigationController pushViewController:forgot animated:YES];
            self.tfPhone.text = @"";
            self.yanZhengL.text = @"";
        }else{
            [JDTools addAlertViewInView:self title:@"温馨提示" message:msg count:0 doWhat:^{
            }];
        }
    }];
    }

}
//限制文本框输入的字数长度
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
        if (textField == self.yanZhengL)
        {
            NSInteger loc =range.location;
            if (loc < 6)
            {
                return YES;
            }
            else
            {
                return NO;
            }
        }else if (textField == self.tfPhone)
        {
            NSInteger loc =range.location;
            if (loc < 11)
            {
                return YES;
            }
            else
            {
                return NO;
            }
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
