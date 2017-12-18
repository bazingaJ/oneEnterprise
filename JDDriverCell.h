//
//  JDDriverCell.h
//  E+TAXI_company
//
//  Created by jeaderq on 16/6/26.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JDModel;
@interface JDDriverCell : UITableViewCell
@property (nonatomic, strong) JDModel *model;
@property (weak, nonatomic) IBOutlet UILabel *driverName;
@property (weak, nonatomic) IBOutlet UILabel *taxiN;

@property (weak, nonatomic) IBOutlet UILabel *phoneN;
@property (weak, nonatomic) IBOutlet UIImageView *iconImg;

@end
