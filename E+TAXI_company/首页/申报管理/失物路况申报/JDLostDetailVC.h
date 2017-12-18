//
//  JDLostDetailVC.h
//  E+TAXI_company
//
//  Created by jeader on 16/6/27.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JDLostDetailVC : UIViewController

@property (nonatomic, weak) IBOutlet UITableView * tableVi;
@property BOOL isLost;
@property (nonatomic, strong) NSString * lostIdentifier;
@property (nonatomic, strong) NSString * roadIdentifier;
@end
