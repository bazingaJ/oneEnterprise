//
//  JDTAXICell.h
//  E+TAXI_company
//
//  Created by jeaderq on 16/6/26.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JDModel;
@interface JDTAXICell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *taxiNumberL;
@property (weak, nonatomic) IBOutlet UILabel *taxiModelL;
@property (weak, nonatomic) IBOutlet UILabel *taxiCompanyL;
@property (weak, nonatomic) IBOutlet UILabel *padNumberL;
@property (weak, nonatomic) IBOutlet UILabel *simNumberL;
@property (weak, nonatomic) IBOutlet UILabel *engineNumberL;
@property (nonatomic, strong) JDModel *model;
@property (weak, nonatomic) IBOutlet UIButton *weizhangBtn;


@end
