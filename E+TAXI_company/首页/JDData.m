//
//  JDData.m
//  E+TAXI_company
//
//  Created by jeaderq on 16/6/30.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import "JDData.h"
#import "JDLoginController.h"
@implementation JDData
#pragma mark- 登陆
-(void)goLoginWithloginWithUserName:(NSString *)name WithPsw:(NSString *)psw withPostType:(NSString *)type withManual:(NSString *)manual withCompletion:(void(^)(NSString * returnCode,NSString * msg))block
{
    NSMutableDictionary * paramDic =[NSMutableDictionary dictionary];
//        NSDictionary * inDic1 =@{@"phoneNo":name,@"password":psw,@"type":@"0",@"manual":@"1",@"clientId":CLIENTID,@"app":@"2"};
//            paramDic=inDic1;
    paramDic[@"userName"] = name;
    paramDic[@"password"] = psw;
    paramDic[@"type"] = type;
    paramDic[@"manual"] = manual;
    paramDic[@"clientId"] = CLIENTID;
    paramDic[@"app"] = @"2";
    paramDic[@"loginTime"]= LOGINTIME;
    
    if ([type intValue]==6) {
    //验证验证码
        paramDic[@"manual"] = nil;
        paramDic[@"validCode"]=manual;
    }else if ([type intValue]==3){
    //找回密码的修改密码
        paramDic[@"password"] = nil;
        paramDic[@"manual"] = nil;
        paramDic[@"newPassword"] = psw;
        paramDic[@"validCode"] = manual;
        
    }else if ([type intValue]==5){
        //验证密码
        paramDic[@"manual"] = nil;
        paramDic[@"password"]=psw;
    }else if ([type intValue]==2){
        //修改密码
        paramDic[@"newPassword"]=manual;
    }else if ([type intValue]==1){
        //修改手机号
        paramDic[@"userName"] = USERNAME;
        paramDic[@"manual"] = nil;
        paramDic[@"newPhoneNo"] = name;
        paramDic[@"password"] = psw;
        paramDic[@"validCode"] = manual;
    }
    JDLog(@"%@",paramDic);
    AFHTTPSessionManager  * manager =[AFHTTPSessionManager manager];
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    NSString * str =[NSString stringWithFormat:@"%@/loginForManagement.json",JDUrl];
    [manager POST:str parameters:paramDic success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString * returnCode =[responseObject objectForKey:@"returnCode"];
        NSString * msg =[responseObject objectForKey:@"msg"];
        NSString * loginTime =[responseObject objectForKey:@"loginTime"];
        NSString *permission = responseObject[@"permission"];
        if (loginTime)
        {
            NSUserDefaults * us =[NSUserDefaults standardUserDefaults];
            [us setValue:loginTime forKey:@"loginTime"];
            [us setValue:permission forKey:@"permission"];
            [us setValue:name forKey:@"userName"];

            [us synchronize];
        }
        if ([returnCode intValue]==0)
        {
            block(returnCode,permission);
        }
        else if ([returnCode intValue]==1)
        {
            block(returnCode,msg);
        }
        else if ([returnCode intValue] == 2)
        {
            block(returnCode,msg);
            [JDData publicDeleteInfo];

        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%s%@",__func__,error);
    }];
}
//退出登录
+ (void)publicDeleteInfo
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userName"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"loginTime"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"permission"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"publicKey"];
    
}
//车品牌型号
-(void)brandDataWithCompletion:(void(^)(NSString * returnCode,id res))block{
    NSMutableDictionary * paramDic =[NSMutableDictionary dictionary];
    AFHTTPSessionManager  * manager =[AFHTTPSessionManager manager];
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    NSString * str =[NSString stringWithFormat:@"%@/getTaxiBrand.json",JDUrl];
    
    [manager POST:str parameters:paramDic success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString * returnCode =[responseObject objectForKey:@"returnCode"];
        NSString * msg =[responseObject objectForKey:@"msg"];
        NSArray *arr= responseObject[@"array"];
        if ([returnCode intValue]==0)
        {
            block(returnCode,arr);
        }
        else if ([returnCode intValue]==1)
        {
            block(returnCode,msg);
        }else if ([returnCode intValue] == 2)
        {
            block(returnCode,msg);
            [JDData publicDeleteInfo];
            [self getOut];
        }

        else
        {
            block(returnCode,msg);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%s%@",__func__,error);
    }];
}
-(void)getOut{
    JDLoginController *loginVc = [[JDLoginController alloc]init];
    UIViewController * rootVc = [UIApplication sharedApplication].keyWindow.rootViewController ;
    [JDTools addAlertViewInView:rootVc title:@"温馨提示" message:@"已在别处登录，请注意是否为本人登录！" count:0 doWhat:^{
        UIViewController *root= [UIApplication sharedApplication].keyWindow.rootViewController;
        if ([root isKindOfClass:[JDLoginController class]]) {
            return ;
        }
        UINavigationController*nav = [[UINavigationController alloc]initWithRootViewController:loginVc];
        //    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
        [nav.navigationBar setBackgroundImage:[UIImage new]  forBarMetrics:UIBarMetricsDefault];
        [nav.navigationBar setShadowImage:[UIImage new]];
        [UIApplication sharedApplication].keyWindow.rootViewController = nav;
    }];
}
//企业选择
-(void)EnterpriseDataWithCompletion:(void(^)(NSString * returnCode,id res))block{
    NSMutableDictionary * paramDic =[NSMutableDictionary dictionary];
    paramDic[@"userName"]=USERNAME;
    paramDic[@"loginTime"]= LOGINTIME;
    
    AFHTTPSessionManager  * manager =[AFHTTPSessionManager manager];
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    NSString * str =[NSString stringWithFormat:@"%@/getTaxiCompanyInfo.json",JDUrl];
    JDLog(@"%@",paramDic);
    [manager POST:str parameters:paramDic success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString * returnCode =[responseObject objectForKey:@"returnCode"];
        NSString * msg =[responseObject objectForKey:@"msg"];
        NSArray *arr= responseObject[@"array"];
        if ([returnCode intValue]==0)
        {
            block(returnCode,arr);
        }
        else if ([returnCode intValue]==1)
        {
            block(returnCode,msg);
        }else if ([returnCode intValue] == 2)
        {
            block(returnCode,msg);
            [JDData publicDeleteInfo];
            [self getOut];
        }
        else
        {
            block(returnCode,msg);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%s%@",__func__,error);
    }];
}
//企业详情
-(void)enterpriseDetailWithId:(NSString *)taxiCompanyId WithCompletion:(void(^)(NSString * returnCode,id res))block{
    NSMutableDictionary * paramDic =[NSMutableDictionary dictionary];
    paramDic[@"userName"]=USERNAME;
    paramDic[@"loginTime"]= LOGINTIME;
    paramDic[@"taxiCompanyId"] = taxiCompanyId;
    AFHTTPSessionManager  * manager =[AFHTTPSessionManager manager];
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    NSString * str =[NSString stringWithFormat:@"%@/getTaxiCompanyDetailInfo.json",JDUrl];
    JDLog(@"%@",paramDic);
    [manager POST:str parameters:paramDic success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString * returnCode =[responseObject objectForKey:@"returnCode"];
        NSString * msg =[responseObject objectForKey:@"msg"];
        if ([returnCode intValue]==0)
        {
            block(returnCode,responseObject);
        }
        else if ([returnCode intValue]==1)
        {
            block(returnCode,msg);
        }else if ([returnCode intValue] == 2)
        {
            block(returnCode,msg);
            [JDData publicDeleteInfo];
            [self getOut];
        }
        else
        {
            block(returnCode,msg);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%s%@",__func__,error);
    }];

}
//出租车详情
-(void)getTaxiDetailWithId:(NSString *)carTypeId startIndex:(NSString *)start Limit:(NSString *)limit WithCompletion:(void(^)(NSString * returnCode,id res))block{
    NSMutableDictionary * paramDic =[NSMutableDictionary dictionary];
    paramDic[@"userName"]=USERNAME;
    paramDic[@"companyId"]= carTypeId;
    paramDic[@"loginTime"] = LOGINTIME;
    paramDic[@"limit"]= limit;
    paramDic[@"startIndex"]=start;
    AFHTTPSessionManager  * manager =[AFHTTPSessionManager manager];
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    NSString * str =[NSString stringWithFormat:@"%@/getTaxiDetail.json",JDUrl];
    JDLog(@"%@",paramDic);
    [manager POST:str parameters:paramDic success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString * returnCode =[responseObject objectForKey:@"returnCode"];
        NSString * msg =[responseObject objectForKey:@"msg"];
        if ([returnCode intValue]==0)
        {
            block(returnCode,responseObject);
        }
        else if ([returnCode intValue]==1)
        {
            block(returnCode,msg);
        }else if ([returnCode intValue] == 2)
        {
            block(returnCode,msg);
            [JDData publicDeleteInfo];
            [self getOut];
        }
        else
        {
            block(returnCode,msg);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%s%@",__func__,error);
    }];

}
//违章查询
-(void)getPeccDataWithLicenseNo:(NSString *)licenseNo engineNo:(NSString *)engineNo WithCompletion:(void(^)(NSString * returnCode,id res))block{
    NSMutableDictionary * paramDic =[NSMutableDictionary dictionary];
    paramDic[@"userName"]=USERNAME;
    paramDic[@"licenseNo"]= licenseNo;
    paramDic[@"loginTime"] = LOGINTIME;
    paramDic[@"engineNo"]= engineNo;
    AFHTTPSessionManager  * manager =[AFHTTPSessionManager manager];
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    NSString * str =[NSString stringWithFormat:@"%@/getViolationForManagement.json",JDUrl];
    JDLog(@"%@",paramDic);
    [manager POST:str parameters:paramDic success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString * returnCode =[responseObject objectForKey:@"returnCode"];
        NSString * msg =[responseObject objectForKey:@"msg"];
        if ([returnCode intValue]==0)
        {
            block(returnCode,responseObject);
        }
        else if ([returnCode intValue]==1)
        {
            block(returnCode,msg);
        }else if ([returnCode intValue] == 2)
        {
            block(returnCode,msg);
            [JDData publicDeleteInfo];
            [self getOut];
        }
        else
        {
            block(returnCode,msg);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%s%@",__func__,error);
    }];

}
//出租车详情
-(void)getDriverDetailWithId:(NSString *)driverId startIndex:(NSString *)start Limit:(NSString *)limit WithCompletion:(void(^)(NSString * returnCode,id res))block{
    NSMutableDictionary * paramDic =[NSMutableDictionary dictionary];
    paramDic[@"userName"]=USERNAME;
    paramDic[@"companyId"]= driverId;
    paramDic[@"loginTime"] = LOGINTIME;
    paramDic[@"limit"]= limit;
    paramDic[@"startIndex"]=start;
    AFHTTPSessionManager  * manager =[AFHTTPSessionManager manager];
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    NSString * str =[NSString stringWithFormat:@"%@/getTaxiDriver.json",JDUrl];
    JDLog(@"%@",paramDic);
    [manager POST:str parameters:paramDic success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString * returnCode =[responseObject objectForKey:@"returnCode"];
        NSString * msg =[responseObject objectForKey:@"msg"];
        if ([returnCode intValue]==0)
        {
            block(returnCode,responseObject);
        }
        else if ([returnCode intValue]==1)
        {
            block(returnCode,msg);
        }else if ([returnCode intValue] == 2)
        {
            block(returnCode,msg);
            [JDData publicDeleteInfo];
            [self getOut];
        }
        else
        {
            block(returnCode,msg);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%s%@",__func__,error);
    }];
}

//驾驶员详情
-(void)getDriverDetailWithDriverId:(NSString *)DriverDetial startIndex:(NSString *)start Limit:(NSString *)limit WithCompletion:(void(^)(NSString * returnCode,id res))block{
    NSMutableDictionary * paramDic =[NSMutableDictionary dictionary];
    paramDic[@"userName"]=USERNAME;
    paramDic[@"driverId"]= DriverDetial;
    paramDic[@"loginTime"] = LOGINTIME;
    paramDic[@"limit"]= limit;
    paramDic[@"startIndex"]=start;
    AFHTTPSessionManager  * manager =[AFHTTPSessionManager manager];
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    NSString * str =[NSString stringWithFormat:@"%@/getDriverDetial.json",JDUrl];
    JDLog(@"%@",paramDic);
    [manager POST:str parameters:paramDic success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString * returnCode =[responseObject objectForKey:@"returnCode"];
        NSString * msg =[responseObject objectForKey:@"msg"];
        if ([returnCode intValue]==0)
        {
            block(returnCode,responseObject);
        }
        else if ([returnCode intValue]==1)
        {
            block(returnCode,msg);
        }else if ([returnCode intValue] == 2)
        {
            block(returnCode,msg);
            [JDData publicDeleteInfo];
            [self getOut];
        }
        else
        {
            block(returnCode,msg);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%s%@",__func__,error);
    }];
}
-(void)getDrivingRecordWithStartTime:(NSString *)star endTime:(NSString *)endTime taxiNumber:(NSString *)taxiNumber fileType:(NSString *)fileType type:(NSString *)type filePath:(NSString *)filePath WithCompletion:(void(^)(NSString * returnCode,id res))block{
    NSMutableDictionary * paramDic =[NSMutableDictionary dictionary];
    paramDic[@"userName"]=USERNAME;
    paramDic[@"startTime"]= [NSString stringWithFormat:@"%@:00",star];
    paramDic[@"loginTime"] = LOGINTIME;
    paramDic[@"taxiNumber"]= taxiNumber;
    paramDic[@"endTime"]= [NSString stringWithFormat:@"%@:00",endTime];
    paramDic[@"filePath"]=filePath;
    paramDic[@"type"]=type;
    paramDic[@"fileType"]=fileType;
    if ([type intValue]==1) {
        paramDic[@"startTime"]= nil;
        paramDic[@"endTime"]= nil;
    }
    JDLog(@"paramer == %@",paramDic);
    
    AFHTTPSessionManager  * manager =[AFHTTPSessionManager manager];
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    NSString * str =[NSString stringWithFormat:@"%@/getDrivingMedio.json",JDUrl];
    JDLog(@"%@",paramDic);
    [manager POST:str parameters:paramDic success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString * returnCode =[responseObject objectForKey:@"returnCode"];
        NSString * msg =[responseObject objectForKey:@"msg"];
        if ([returnCode intValue]==0)
        {
            block(returnCode,responseObject);
        }
        else if ([returnCode intValue]==1)
        {
            block(returnCode,msg);
        }else if ([returnCode intValue] == 2)
        {
            block(returnCode,msg);
            [JDData publicDeleteInfo];
            [self getOut];
        }
        else
        {
            block(returnCode,msg);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%s%@",__func__,error);
    }];
}
-(void)getSeachWithSeachType:(NSString *)seachType serchContent:(NSString *)seachText WithCompletion:(void(^)(NSString * returnCode,id res))block{
    NSMutableDictionary * paramDic =[NSMutableDictionary dictionary];
    paramDic[@"userName"]=USERNAME;
    paramDic[@"loginTime"] = LOGINTIME;
    paramDic[@"searchType"]= seachType;
    paramDic[@"searchText"] = seachText;
    AFHTTPSessionManager  * manager =[AFHTTPSessionManager manager];
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    NSString * str =[NSString stringWithFormat:@"%@/searchForManagement.json",JDUrl];
    [manager POST:str parameters:paramDic success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString * returnCode =[responseObject objectForKey:@"returnCode"];
        NSString * msg =[responseObject objectForKey:@"msg"];
        if ([returnCode intValue]==0)
        {
            block(returnCode,responseObject);
        }
        else if ([returnCode intValue]==1)
        {
            block(returnCode,msg);
        }else if ([returnCode intValue] == 2)
        {
            block(returnCode,msg);
            [JDData publicDeleteInfo];
            [self getOut];
        }
        else
        {
            block(returnCode,msg);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%s%@",__func__,error);
    }];

}
@end
