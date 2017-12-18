//
//  JDData.h
//  E+TAXI_company
//
//  Created by jeaderq on 16/6/30.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JDData : NSObject
//登录
-(void)goLoginWithloginWithUserName:(NSString *)name WithPsw:(NSString *)psw withPostType:(NSString *)type withManual:(NSString *)manual withCompletion:(void(^)(NSString * returnCode,NSString * msg))block;
+ (void)publicDeleteInfo;
//车品牌型号
-(void)brandDataWithCompletion:(void(^)(NSString * returnCode,id res))block;
//企业
-(void)EnterpriseDataWithCompletion:(void(^)(NSString * returnCode,id res))block;
//企业详情
-(void)enterpriseDetailWithId:(NSString *)taxiCompanyId WithCompletion:(void(^)(NSString * returnCode,id res))block;
//出租车详情
-(void)getTaxiDetailWithId:(NSString *)carTypeId startIndex:(NSString *)start Limit:(NSString *)limit WithCompletion:(void(^)(NSString * returnCode,id res))block;
//违章查询
-(void)getPeccDataWithLicenseNo:(NSString *)licenseNo engineNo:(NSString *)engineNo WithCompletion:(void(^)(NSString * returnCode,id res))block;

//驾驶员
-(void)getDriverDetailWithId:(NSString *)carTypeId startIndex:(NSString *)start Limit:(NSString *)limit WithCompletion:(void(^)(NSString * returnCode,id res))block;

//驾驶员详情
-(void)getDriverDetailWithDriverId:(NSString *)DriverDetial startIndex:(NSString *)start Limit:(NSString *)limit WithCompletion:(void(^)(NSString * returnCode,id res))block;

// 行车记录
-(void)getDrivingRecordWithStartTime:(NSString *)star endTime:(NSString *)endTime taxiNumber:(NSString *)taxiNumber fileType:(NSString *)fileType type:(NSString *)type filePath:(NSString *)filePath WithCompletion:(void(^)(NSString * returnCode,id res))block;
//搜索
-(void)getSeachWithSeachType:(NSString *)seachType serchContent:(NSString *)seachText WithCompletion:(void(^)(NSString * returnCode,id res))block;


@end
