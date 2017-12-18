//
//  AppDelegate.h
//  E+TAXI_company
//
//  Created by jeader on 16/6/24.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GeTuiSdk.h"     // GetuiSdk头文件，需要使用的地方需要添加此代码

/// 个推开发者网站中申请App时，注册的AppId、AppKey、AppSecret
#define kGtAppId           @"4knBnyICxf9SARcgZ91gT8"
#define kGtAppKey          @"3blIjg1TF09OP1JBodbhZ2"
#define kGtAppSecret       @"866xzRzf2b7NEu1NJjv987"

/// 需要使用个推回调时，需要添加"GeTuiSdkDelegate"
@interface AppDelegate : UIResponder <UIApplicationDelegate,GeTuiSdkDelegate>

@property (strong, nonatomic) UIWindow *window;


@end

