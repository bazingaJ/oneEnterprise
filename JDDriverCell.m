//
//  JDDriverCell.m
//  E+TAXI_company
//
//  Created by jeaderq on 16/6/26.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import "JDDriverCell.h"
@implementation JDDriverCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setModel:(JDModel *)model{
    _model = model;
    self.driverName.text = [NSString stringWithFormat:@"姓    名：%@",model.driverName];
    self.taxiN.text =[NSString stringWithFormat:@"车牌号：%@", model.taxiNumber];
    self.phoneN.text =[NSString stringWithFormat:@"手机号：%@", model.phoneNumber];
    [self.iconImg sd_setImageWithURL:[NSURL URLWithString:model.driverHead] placeholderImage:[UIImage imageNamed:@"photo_moren_jsy"]];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
