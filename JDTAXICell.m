//
//  JDTAXICell.m
//  E+TAXI_company
//
//  Created by jeaderq on 16/6/26.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import "JDTAXICell.h"

@implementation JDTAXICell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setModel:(JDModel *)model{
    _model = model;
    
    self.taxiNumberL.text = model.taxiNumber;
    self.taxiModelL.text = model.taxiModel;
    self.taxiCompanyL.text = model.taxiCompany;
    self.padNumberL.text = model.padNumber;
    self.simNumberL.text = model.simNumber;
    self.engineNumberL.text = model.engineNumber;
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
