//
//  JDNoticeDetailVC.h
//  E+TAXI_company
//
//  Created by jeader on 16/6/28.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JDNoticeDetailVC : UIViewController

@property (nonatomic, strong) NSString * noticeIdStr;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *fromLabel;
@property (nonatomic, weak) IBOutlet UILabel *getLabel;
@property (weak, nonatomic) IBOutlet UILabel *tiemLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *explainLabel;
@property (weak, nonatomic) IBOutlet UIImageView *noticeImg;

@end
