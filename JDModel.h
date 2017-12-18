//
//  JDModel.h
//  E+TAXI_company
//
//  Created by jeaderq on 16/7/1.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import <Foundation/Foundation.h>
@class JDSeachModel;
@interface JDModel : NSObject
//品牌
@property (nonatomic, strong) NSString *taxiBrand;
//型号
@property (nonatomic, strong) NSString *taxiModel;
//企业地址
@property (nonatomic, strong) NSString *taxiCompanyAddress;
//企业名称
@property (nonatomic, strong) NSString *taxiCompanyName;
//企业ID
@property (nonatomic, strong) NSString *taxiCompanyId;
//企业电话
@property (nonatomic, strong) NSString *taxiCompanyPhone;
//出租车数量
@property (nonatomic, assign) int taxiCount;
//司机数量
@property (nonatomic, assign) int driverCount;
//企业详情模型
@property (nonatomic, strong) NSString *contactName;
@property (nonatomic, strong) NSString *contactPhone;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *faxNumber;
@property (nonatomic, strong) NSString *legalPerson;
@property (nonatomic, strong) NSString *parentCompany;
@property (nonatomic, strong) NSString *reportPhone;
@property (nonatomic, strong) NSString *returnCode;
@property (nonatomic, strong) NSString *supervisePhone;
@property (nonatomic, strong) NSString *taxiCompanyNo;
@property (nonatomic, strong) NSString *taxiCompanyType;
@property (nonatomic, strong) NSString *taxiCompanyWeb;
@property (nonatomic, strong) NSString *zioCode;

//出租车详情model
@property (nonatomic, strong) NSString *taxiId;
@property (nonatomic, strong) NSString *taxiNumber;
@property (nonatomic, strong) NSString *taxiCompany;
@property (nonatomic, strong) NSString *padNumber;
@property (nonatomic, strong) NSString *simNumber;
@property (nonatomic, strong) NSString *engineNumber;
//违章model
/**
 *  违章扣分
 */
@property (nonatomic, copy) NSString *fen;
/**
 *  违章记录id
 */
@property (nonatomic, copy) NSString *id;
/**
 *  违章具体信息
 */
@property (nonatomic, copy) NSString *info;
/**
 *  违章罚款数
 */
@property (nonatomic, copy) NSString *money;
/**
 *  违章地点
 */
@property (nonatomic, copy) NSString *occur_area;
/**
 *  违章时间
 */
@property (nonatomic, copy) NSString *occur_date;


//驾驶员信息
@property (nonatomic, strong) NSString *driverId;
@property (nonatomic, strong) NSString *driverName;
@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic, strong) NSString *driverHead;


//驾驶员详情
@property (nonatomic, strong) NSString *company;
@property (nonatomic, strong) NSString *driverPhoneNumber;
@property (nonatomic, strong) NSString *driverBirth;
@property (nonatomic, strong) NSString *driverHome;
@property (nonatomic, strong) NSString *drivingType;
@property (nonatomic, strong) NSString *serviceNumber;
@property (nonatomic, strong) NSString *recordNumber;
@property (nonatomic, strong) NSString *getYmd;
@property (nonatomic, strong) NSString *endYmd;
@property (nonatomic, strong) NSString *taxiType;
@property (nonatomic, strong) NSString *driverSex;

//搜索
@property (nonatomic, assign) int lostCount;
@property (nonatomic, strong) NSArray *taxiResult;
@property (nonatomic, strong) NSArray *driverResult;
@property (nonatomic, strong) NSArray *lostResult;
@property (nonatomic, strong) NSArray *trafficResult;
@property (nonatomic, assign) int trafficCount;
@property (nonatomic, strong) JDSeachModel *seachModel;

//行车记录
@property (nonatomic, strong) NSString *fileType;
@property (nonatomic, strong) NSString *medioHost;
@property (nonatomic, strong) NSString *time;
@end
