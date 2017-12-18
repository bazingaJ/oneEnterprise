//
//  LostCell.m
//  E+TAXI_company
//
//  Created by jeader on 16/6/27.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import "LostCell.h"

@implementation LostCell
static CGFloat kTableViewWidth = -1;
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+ (void)setTableViewWidth:(CGFloat)tableWidth
{
    kTableViewWidth = tableWidth;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
