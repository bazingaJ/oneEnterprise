//
//  JDWeiZhangF.h
//  E+TAXI_company
//
//  Created by jeaderq on 16/7/5.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import <Foundation/Foundation.h>
@class JDModel;

@interface JDWeiZhangF : NSObject
@property (nonatomic, strong) JDModel *modelM;

@property (nonatomic,assign) CGRect chePaiF;

@property (nonatomic,assign) CGRect shijianF;

@property (nonatomic,assign) CGRect shijianNF;

@property (nonatomic,assign) CGRect didianF;
@property (nonatomic,assign) CGRect didianNF;
@property (nonatomic,assign) CGRect koufenF;
@property (nonatomic,assign) CGRect koufeLF;
@property (nonatomic,assign) CGRect fakuanF;
@property (nonatomic,assign) CGRect fakuanLF;
@property (nonatomic,assign) CGRect neirongF;
@property (nonatomic,assign) CGRect neirongNF;
@property (nonatomic,assign) CGRect lineF;
@property (nonatomic,assign) CGRect line1F;
@property (nonatomic, assign) CGRect heiT;
@property (nonatomic, assign) CGFloat cellHeigh;

@property (nonatomic, assign) CGRect bgViewF;
@end
