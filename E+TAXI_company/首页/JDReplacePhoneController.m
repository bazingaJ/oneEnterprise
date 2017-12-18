//
//  JDReplacePhoneController.m
//  E+TAXI_company
//
//  Created by jeaderq on 16/7/1.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import "JDReplacePhoneController.h"

@interface JDReplacePhoneController ()
@property (weak, nonatomic) IBOutlet UITextField *NPhoneL;
@property (weak, nonatomic) IBOutlet UITextField *yanZhengL;

@end

@implementation JDReplacePhoneController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setpopItem];
    // Do any additional setup after loading the view from its nib.
}
-(void)setpopItem{
    self.navigationItem.titleView = [JDTools setTitleViewWithTitle:@"修改绑定手机"];
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//获取验证码
- (IBAction)GetVerificationCode:(UIButton *)sender {
    
    if (self.NPhoneL.text.length==0) {
        [JDTools addAlertViewInView:self title:@"温馨提示" message:@"手机号不能为空" count:0 doWhat:nil];
    }else{
        
        NSString * url=[NSString  stringWithFormat:@"%@/getVaildCodeForManagement.json",JDUrl];
        NSMutableDictionary *paramer = [NSMutableDictionary dictionary];
        paramer[@"phoneNo"]= self.NPhoneL.text;
        paramer[@"type"]= @"1";
        paramer[@"loginTime"]= LOGINTIME;
        paramer[@"userName"]= USERNAME;
        AFHTTPRequestOperationManager * manager =[AFHTTPRequestOperationManager manager];
        [manager GET:url parameters:paramer success:^(AFHTTPRequestOperation *operation, id responseObject) {
            int  returnCode=[[responseObject objectForKey:@"returnCode"] intValue];
            if (returnCode==0)
            {
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
    

    
    [sender startWithTime:59 title:@"重新获取" countDownTitle:@"秒后重试" mainColor:RGBColor(75, 187, 245)  countColor:[UIColor whiteColor]];
    
}
- (IBAction)nextBtn:(UIButton *)sender {
    
    if (self.NPhoneL.text.length==0) {
        [JDTools addAlertViewInView:self title:@"温馨提示" message:@"手机号不能为空" count:0 doWhat:nil];

    }else if (self.yanZhengL.text.length==0){
        [JDTools addAlertViewInView:self title:@"温馨提示" message:@"请输入正确的验证码" count:0 doWhat:nil];

    }else{
        /**请求公钥*/
        [JDTools getPublicKey];
        NSString * pass1=[EPRSA encryptString:self.oldPassword publicKey:publicKeyRSA];
        JDData *data = [JDData new];
        [data goLoginWithloginWithUserName:self.NPhoneL.text WithPsw:pass1 withPostType:@"1" withManual:self.yanZhengL.text withCompletion:^(NSString *returnCode, NSString *msg) {
            if ([returnCode intValue]==0) {
                [JDTools addAlertViewInView:self title:@"温馨提示" message:msg count:0 doWhat:nil];

            }else{
                [JDTools addAlertViewInView:self title:@"温馨提示" message:msg count:0 doWhat:nil];

            }
        }];
    }
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
