//
//  LostFoundVC.h
//  E+TAXI_company
//
//  Created by jeader on 16/6/25.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JDLostFoundVC : UIViewController

@property (nonatomic, weak) IBOutlet UITableView * tableVi;
@property (nonatomic, weak) IBOutlet UITextField * searchTF;
@property (nonatomic, strong) NSString * text;
@property BOOL isLost;
@end
