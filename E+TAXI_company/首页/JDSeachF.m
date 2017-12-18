//
//  JDSeachF.m
//  E+TAXI_company
//
//  Created by jeaderq on 16/7/11.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import "JDSeachF.h"
#import "JDSeachModel.h"
#define JDTITLEFONT [UIFont systemFontOfSize:12]
#define JDCONTONTFONT [UIFont systemFontOfSize:14]
@implementation JDSeachF
-(void)setJDModel:(JDModel *)JDModel{
    _JDModel = JDModel;
    JDSeachModel *seachModel = _JDModel.seachModel;
    
    CGFloat bgViewW = JDScreenW;
    CGFloat bgViewH = 0;
    CGFloat typeX = 12;
    CGFloat typeY = 10;
    CGSize typeSize = [self sizeWithText:@"失物招领" font:JDTITLEFONT];
    self.typeF = (CGRect){{typeX,typeY},typeSize};
    
    CGSize rightCountSize  = [self sizeWithText:@"条信息" font:JDTITLEFONT];
    CGFloat rightCountX  = JDScreenW-rightCountSize.width;
    self.rightCountF = (CGRect){{rightCountX,typeY},rightCountSize};
    
    CGSize rightSize = [self sizeWithText:@"000000" font:JDTITLEFONT];
    CGFloat rightX = CGRectGetMinX(self.rightCountF)-3;
    self.rightF = (CGRect){{rightX,typeY},rightSize};
    
    self.lineF = CGRectMake(0, CGRectGetMaxY(self.typeF)+10, JDScreenW, 0.5);

    
    CGFloat chepaiY = CGRectGetMaxY(self.lineF)+16;
    NSString *chepai = [NSString stringWithFormat:@"车牌号:%@",seachModel.taxiNumber];
    CGSize chePaiSize =[self sizeWithText:chepai font:JDCONTONTFONT];
    
    if (seachModel.driverHead.length>0) {
        self.iconImaF = CGRectMake(12, CGRectGetMaxY(self.lineF)+16, 63, 63);
        CGFloat chePaiX  = CGRectGetMaxX(self.iconImaF)+10;
        self.chePaiF = (CGRect){{chePaiX,chepaiY},chePaiSize};

    }else{
        self.iconImaF = CGRectZero;
        self.chePaiF = (CGRect){{typeX,chepaiY},chePaiSize};

    }
    CGFloat carTypeY = CGRectGetMaxY(self.chePaiF)+6;
    CGSize carTypeSize = [self sizeWithText:[NSString stringWithFormat:@"车型号:%@",seachModel.taxiModel] font:JDCONTONTFONT];
    self.cheTypeF = (CGRect){{self.chePaiF.origin.x,carTypeY},carTypeSize};
    
    CGFloat phoneY = CGRectGetMaxY(self.cheTypeF)+6;
    CGSize phoneSize = [self sizeWithText:[NSString stringWithFormat:@"手机号:%@",seachModel.phoneNumber] font:JDCONTONTFONT];
    self.phoneF = (CGRect){{self.cheTypeF.origin.x,phoneY},phoneSize};
    
    self.line1F = CGRectMake(0, CGRectGetMaxY(self.phoneF)+16, JDScreenW, 0.5);
    
    self.loadMoreF = CGRectMake(0, CGRectGetMaxY(self.line1F), JDScreenW, 45);
    
    self.belowF = CGRectMake(0, CGRectGetMaxY(self.loadMoreF), JDScreenW, 6);
    if (JDModel.taxiCount>0||JDModel.driverCount>0||JDModel.lostCount>0||JDModel.trafficCount>0) {
        bgViewH = CGRectGetMaxY(self.belowF);
    }else if (JDModel.taxiCount==0||JDModel.driverCount==0||JDModel.lostCount==0||JDModel.trafficCount==0){
        bgViewH = 33;
    }
    self.bgViewF = (CGRect){{0,0},{bgViewW,bgViewH}};
    self.cellHeigh = CGRectGetMaxY(self.bgViewF);
    
}
-(CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxW:(CGFloat)maxW
{
    NSMutableDictionary *attri  =[NSMutableDictionary dictionary];
    attri[NSFontAttributeName] = font;
    CGSize maxSize =CGSizeMake(maxW, MAXFLOAT);
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attri context:nil].size;
    
}

-(CGSize)sizeWithText:(NSString *)text font:(UIFont *)font
{
    return [self sizeWithText:text font:font maxW:MAXFLOAT];
}

@end
