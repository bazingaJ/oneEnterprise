//
//  JDModel.m
//  E+TAXI_company
//
//  Created by jeaderq on 16/7/1.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import "JDModel.h"

@implementation JDModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{
             @"taxiResult" : @"JDSeachModel",
             @"driverResult" : @"JDSeachModel",
             @"lostResult":@"JDSeachModel",
             @"trafficResult":@"JDSeachModel"
             };

}
@end
