//
//  AppDelegate.m
//  E+TAXI_company
//
//  Created by jeader on 16/6/24.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import "AppDelegate.h"
#import "JDLoginController.h"
#import "JDMainViewController.h"
//注册APNs服务器的时候需要的参数
NSString *const NotificationCategoryIdent = @"ACTIONABLE";
NSString *const NotificationActionOneIdent = @"FIRST_ACTIOIN";
NSString *const NotificationActionTwoIdent = @"SECOND_ACTION";

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

    // Override point for customization after application launch.
    JDMainViewController *main = [[JDMainViewController alloc]init];
    
    UINavigationController*nav = [[UINavigationController alloc]initWithRootViewController:main];
    
    [nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"navBG"]  forBarMetrics:UIBarMetricsDefault];
    [nav.navigationBar setShadowImage:[UIImage new]];
    
    UIWindow *window = [[UIWindow alloc]init];
    window.frame = [UIScreen mainScreen].bounds;
    if (!LOGINTIME) {
        JDLoginController *login = [[JDLoginController alloc]init];
    UINavigationController*nav = [[UINavigationController alloc]initWithRootViewController:login];
    //    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
        [nav.navigationBar setBackgroundImage:[UIImage new]  forBarMetrics:UIBarMetricsDefault];
        [nav.navigationBar setShadowImage:[UIImage new]];
         window.rootViewController =nav;
    }else{
        window.rootViewController =nav;
   
        [JDLoginController automaticLogin];
    }

    self.window = window;
    [self.window makeKeyAndVisible];
//    [AMapServices sharedServices].apiKey=@"cdde8595e26e67d4f30945abec51d621";
    
    // 通过个推平台分配的appId、 appKey 、appSecret 启动SDK，注：该方法需要在主线程中调用
    [GeTuiSdk startSdkWithAppId:kGtAppId appKey:kGtAppKey appSecret:kGtAppSecret delegate:self];
    // 注册APNS
    [self registerUserNotification];
    return YES;
}

- (void)registerUserNotification
{
    //如果是ios8.0 and later
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>= 8.0)
    {
        //IOS8 新的通知机制category注册
        //执行的动作一
        UIMutableUserNotificationAction *action1 ;
        action1 =[[UIMutableUserNotificationAction alloc] init];
        [action1 setActivationMode:UIUserNotificationActivationModeForeground];
        [action1 setIdentifier:NotificationActionOneIdent];
        [action1 setTitle:@"取消"];
        [action1 setDestructive:NO];
        [action1 setAuthenticationRequired:NO];
        //执行的动作二
        UIMutableUserNotificationAction * action2 ;
        action2 =[[UIMutableUserNotificationAction alloc] init];
        [action2 setActivationMode:UIUserNotificationActivationModeBackground];
        [action2 setIdentifier:NotificationActionTwoIdent];
        [action2 setTitle:@"接收"];
        [action2 setDestructive:NO];
        [action2 setAuthenticationRequired:NO];
        //设置categorys
        UIMutableUserNotificationCategory * actionCategorys =[[UIMutableUserNotificationCategory alloc] init];
        [actionCategorys setIdentifier:NotificationCategoryIdent];
        [actionCategorys setActions:@[action1,action2] forContext:UIUserNotificationActionContextDefault];
        //将类型 装在集合里面
        NSSet * categories =[NSSet setWithObject:actionCategorys];
        UIUserNotificationType types =(UIUserNotificationTypeAlert |
                                       UIUserNotificationTypeSound |
                                       UIUserNotificationTypeBadge);
        //设置 set属性
        UIUserNotificationSettings * settings =[UIUserNotificationSettings settingsForTypes:types categories:categories];
        [[UIApplication sharedApplication]registerForRemoteNotifications];
        [[UIApplication sharedApplication]registerUserNotificationSettings:settings];
    }
    else
    {
        UIRemoteNotificationType apn_type =(UIRemoteNotificationType)(UIRemoteNotificationTypeAlert |UIRemoteNotificationTypeSound |UIRemoteNotificationTypeBadge);
        [[UIApplication sharedApplication]registerForRemoteNotificationTypes:apn_type];
    }
    
}//如果APNs注册成功了就会返回一个 ============>>DeviceToken
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(nonnull NSData *)deviceToken
{
    NSString * myToken =[[deviceToken description]stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    myToken =[myToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    [GeTuiSdk registerDeviceToken:myToken]; //向个推服务器注册deviceToken
}

//如果APNS 注册失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    [GeTuiSdk registerDeviceToken:@""];
}

//个推启动成功返回clientID
- (void)GeTuiSdkDidRegisterClient:(NSString *)clientId
{
    if (clientId.length>0)
    {
        NSUserDefaults * us =[NSUserDefaults standardUserDefaults];
        [us setValue:clientId forKey:@"clientID"];
        [us synchronize];
    }
    else
    {
        NSLog(@"没有获取到clientID");
    }
    
}
//个推遇到错误回调
- (void)GeTuiSdkDidOccurError:(NSError *)error
{
    NSLog(@"个推遇到错误 :%@",[error localizedDescription]);
}

- (void)GeTuiSdkDidReceivePayload:(NSString *)payloadId andTaskId:(NSString *)taskId andMessageId:(NSString *)aMsgId andOffLine:(BOOL)offLine fromApplication:(NSString *)appId
{
    
    NSData * payload =[GeTuiSdk retrivePayloadById:payloadId];
    NSString * payloadMsg =nil;
    if (payload)
    {
        payloadMsg=[[NSString alloc]initWithBytes:payload.bytes length:payload.length encoding:NSUTF8StringEncoding];
    }
    //    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //    formatter.dateFormat = @"YYYY/MM/dd HH:mm:ss";
    //    NSString *currentTime = [formatter stringFromDate:[NSDate date]];
    
    //data类型转为JSON数据
    NSJSONSerialization *json = [NSJSONSerialization JSONObjectWithData:payload options:0 error:nil];
    NSDictionary *dict = (NSDictionary *)json;
    
    //    NSMutableDictionary *pushDict = [NSMutableDictionary dictionary];
    //    pushDict[@"title"] = dict[@"title"];
    //    pushDict[@"content"] = dict[@"content"];
    //    pushDict[@"currentTime"] = currentTime;
    //    pushDict[@"flag"] = @"0";
    
    /**
     *  如果传过来的通知是有用的就显示到消息栏，如果没用，只做推送，不展示
     */
   
    NSString * msg =[NSString stringWithFormat:@"payloadId=%@,taskId=%@,messageId:%@,payloadMsg:%@%@",payloadId,taskId,aMsgId,payloadMsg,offLine ? @"<离线消息>":@""];
    NSLog(@"个推收到的payload是%@",msg);
    if ([[NSString stringWithFormat:@"%@",dict[@"content"]] isEqualToString:@"已在别处登录，请注意是否为本人登录！"])
    {
        [JDData publicDeleteInfo];
        NSLog(@"顶掉了");
        UIViewController *rootVc=   [UIApplication sharedApplication].keyWindow.rootViewController;
        JDLoginController *loginVc = [[JDLoginController alloc]init];
        [JDTools addAlertViewInView:rootVc title:@"温馨提示" message:@"已在别处登录，请注意是否为本人登录！" count:0 doWhat:^{
           UIViewController *root= [UIApplication sharedApplication].keyWindow.rootViewController;
            if ([root isKindOfClass:[JDLoginController class]]) {
                return ;
            }
            UINavigationController*nav = [[UINavigationController alloc]initWithRootViewController:loginVc];
            //    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
            [nav.navigationBar setBackgroundImage:[UIImage new]  forBarMetrics:UIBarMetricsDefault];
            [nav.navigationBar setShadowImage:[UIImage new]];
            self.window.rootViewController =nav;
        }];
    }
    
}

//让项目禁止横屏
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(nullable UIWindow *)window
{
    return UIInterfaceOrientationMaskPortrait;
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
