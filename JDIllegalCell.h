//
//  JDIllegalCell.h
//  E+TAXI_company
//
//  Created by jeaderq on 16/7/5.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JDWeiZhangF;
@interface JDIllegalCell : UITableViewCell
+(instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) JDWeiZhangF *weiZhangF;
@property (nonatomic, strong) UILabel *chepai;
@end
