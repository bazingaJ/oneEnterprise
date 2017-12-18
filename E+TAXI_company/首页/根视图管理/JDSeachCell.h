//
//  JDSeachCell.h
//  E+TAXI_company
//
//  Created by jeaderq on 16/6/29.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JDSeachModel;
@interface JDSeachCell : UITableViewCell
//cell1
@property (weak, nonatomic) IBOutlet UILabel *chePaiL;
@property (weak, nonatomic) IBOutlet UILabel *carTypeL;
@property (weak, nonatomic) IBOutlet UILabel *phoneNOL;
@property (weak, nonatomic) IBOutlet UIButton *loadMore1;
@property (weak, nonatomic) IBOutlet UILabel *count1;
@property (weak, nonatomic) IBOutlet UILabel *type;
//cell2
@property (weak, nonatomic) IBOutlet UIImageView *iconImg;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *carTypeL2;
@property (weak, nonatomic) IBOutlet UILabel *phoneNoL;
@property (weak, nonatomic) IBOutlet UILabel *count2;
@property (weak, nonatomic) IBOutlet UIButton *loadMore2;
@property (weak, nonatomic) IBOutlet UILabel *type2;

@property (weak, nonatomic) IBOutlet UILabel *cell3Type;

//
//+(instancetype)cellWithTableView:(UITableView *)tableView;
//@property (nonatomic, strong)  JDSeachF*JDSeachF;

@end
