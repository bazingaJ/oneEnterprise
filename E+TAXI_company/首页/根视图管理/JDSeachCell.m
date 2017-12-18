//
//  JDSeachCell.m
//  E+TAXI_company
//
//  Created by jeaderq on 16/6/29.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import "JDSeachCell.h"
#define JDTitleFont [UIFont systemFontOfSize:12]
#define JDContentFont [UIFont systemFontOfSize:14]
//@interface JDSeachCell ()
//@property (nonatomic, strong) UIView *bgView;
//@property (nonatomic, strong) UILabel *typeL;
//@property (nonatomic, strong) UILabel *rightCountL;
//@property (nonatomic, strong) UILabel *rightL;
//@property (nonatomic, strong) UIView *line;
//@property (nonatomic, strong) UIView *line1;
//
//@property (nonatomic, strong) UILabel *cheTypeL;
//@property (nonatomic, strong) UILabel *phoneL;
//
//@property (nonatomic, strong) UIView *below;
//@property (nonatomic, strong) UIButton *loadMore;
//@end

@implementation JDSeachCell
//
//+(instancetype)cellWithTableView:(UITableView *)tableView
//{
//    static NSString *ID = @"status";
//    JDSeachCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
//    if (!cell) {
//        cell = [[JDSeachCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
//    }
//    return cell;
//}
//-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
//{
//    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//    if (self) {
//        self.selectionStyle = UITableViewCellSelectionStyleNone;
//        
//        self.contentView.backgroundColor = RGBColor(224, 224, 224);
//        
//        [self setSubViews];
//    }
//    return self;
//}
//-(void)setSubViews
//{
//    //cell背景View
//    UIView *bgView = [[UIView alloc]init];
//    bgView.backgroundColor = [UIColor whiteColor];
//    [self.contentView addSubview:bgView];
//    self.bgView = bgView;
//    
//    UILabel *typeL = [[UILabel alloc]init];
//    typeL.textColor = RGBColor(153, 153, 153);
//    typeL.font =JDTitleFont;
//    [self.bgView addSubview:typeL];
//    self.typeL = typeL;
//    
//    UILabel *rightCountL = [[UILabel alloc]init];
//    rightCountL.textColor = RGBColor(51, 51, 51);
//    rightCountL.font = JDContentFont;
//    [bgView addSubview:rightCountL];
//    self.rightCountL = rightCountL;
//    
//    UILabel *rightL = [[UILabel alloc]init];
//    rightL.textColor = RGBColor(153, 153, 153);
//    rightL.font = JDTitleFont;
//    [bgView addSubview:rightL];
//    self.rightL = rightL;
//    
//    UIView *line = [[UIView alloc]init];
//    line.backgroundColor = RGBColor(220, 221, 222);
//    [bgView addSubview:line];
//    self.line = line;
//    
//    UIView *line1 = [[UIView alloc]init];
//    line1.backgroundColor = RGBColor(220, 221, 222);
//    [bgView addSubview:line1];
//    self.line1 = line1;
//    
//    UILabel *chePaiL = [[UILabel alloc]init];
//    chePaiL.font = JDContentFont;
//    chePaiL.textColor = RGBColor(51, 51, 51);
//    [bgView addSubview:chePaiL];
//    self.chePaiL = chePaiL;
//    
//    UILabel *cheTypeL = [[UILabel alloc]init];
//    cheTypeL.font = JDContentFont;
//    cheTypeL.textColor = RGBColor(51, 51, 51);
//    [bgView addSubview:cheTypeL];
//    self.cheTypeL = cheTypeL;
//    
//    UILabel *phoneL = [[UILabel alloc]init];
//    phoneL.font = JDContentFont;
//    phoneL.textColor = RGBColor(51, 51, 51);
//    [bgView addSubview:phoneL];
//    self.phoneL = phoneL;
//    
//    UIImageView *imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"btn_arrow_right"]];
//    imageV.x = JDScreenW-12;
//    imageV.y = 108;
//    [bgView addSubview:imageV];
//    
//    UIButton *loadMore = [UIButton buttonWithType:UIButtonTypeCustom];
//    [loadMore setTitleColor:RGBColor(75, 187, 245) forState:UIControlStateNormal];
//    [bgView addSubview:loadMore];
//    self.loadMore = loadMore;
//    
//    UIView * below = [[UIView alloc]init];
//    below.backgroundColor = RGBColor(241, 241, 242);
//    [bgView addSubview:below];
//    self.below = below;
//    
//    UIImageView *iconImg = [[UIImageView alloc]init];
//    [bgView addSubview:iconImg];
//    self.iconImg = iconImg;
//    
//}
//-(void)setJDSeachF:(JDSeachF *)JDSeachF{
//    _JDSeachF = JDSeachF;
//    
//    
//    
//}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
