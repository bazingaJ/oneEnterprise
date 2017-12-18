//
//  NoticeCell.h
//  E+TAXI_company
//
//  Created by jeader on 16/6/27.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoticeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView * signImg;
@property (nonatomic, weak) IBOutlet UILabel * titleLabel;
@property (nonatomic, weak) IBOutlet UILabel * timeLabel;
@property (nonatomic, weak) IBOutlet UILabel * detailLabel;
@property (nonatomic, weak) IBOutlet UILabel * contentLabel;


@end
