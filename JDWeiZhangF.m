//
//  JDWeiZhangF.m
//  E+TAXI_company
//
//  Created by jeaderq on 16/7/5.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import "JDWeiZhangF.h"
#define JDCHEPAIFONT [UIFont systemFontOfSize:14]
#define JDCHEPAIFONTB [UIFont systemFontOfSize:16]

@implementation JDWeiZhangF
-(void)setModelM:(JDModel *)modelM{
    _modelM = modelM;
    CGFloat bgViewW = JDScreenW;
    CGFloat maxW = bgViewW - 24;
    CGFloat bgViewH = 0;
    CGFloat chepaiX = 12;
    CGFloat chepaiY = 10;
    CGSize chepaiSize = [self sizeWithText:@"苏AJ08G9 " font:JDCHEPAIFONTB];
    self.chePaiF = (CGRect){{chepaiX,chepaiY},chepaiSize};
    
    CGSize lineSize = CGSizeMake(JDScreenW, .5);
    CGFloat lineY = CGRectGetMaxY(self.chePaiF)+10;
    self.lineF = (CGRect){{0,lineY},lineSize};
    
    CGSize shijianSize = [self sizeWithText:@"违章时间:" font:JDCHEPAIFONT];
    CGFloat shijianY = CGRectGetMaxY(self.lineF)+10;
    self.shijianF = (CGRect){{chepaiX,shijianY},shijianSize};
    
    
    NSString *shijian = modelM.occur_date;
    CGSize shijianNSize =[self sizeWithText:shijian font:JDCHEPAIFONT];
    CGFloat shijianX = CGRectGetMaxX(self.shijianF)+5;
    self.shijianNF = (CGRect){{shijianX,shijianY},shijianNSize};
    
    CGFloat didianY = CGRectGetMaxY(self.shijianF)+10;
    self.didianF =(CGRect){{chepaiX,didianY},shijianSize};
    
    NSString *diandianN = modelM.occur_area;
    CGSize didianNSize = [self sizeWithText:diandianN font:JDCHEPAIFONT];
    self.didianNF = (CGRect){{shijianX,didianY},didianNSize};
    
    CGFloat koufenY =CGRectGetMaxY(self.didianF)+10;
    self.koufenF = (CGRect){{chepaiX,koufenY},shijianSize};
    

    
    CGSize koufenSize =[self sizeWithText:@"有" font:JDCHEPAIFONT];
    self.koufeLF = (CGRect){{shijianX,koufenY},koufenSize};
    
    
    CGFloat fakuanY = CGRectGetMaxY(self.koufenF)+10;
    self.fakuanF = (CGRect){{chepaiX,fakuanY},shijianSize};
    
    NSString *jine = [NSString stringWithFormat:@"%@",modelM.money];
    CGSize fakuanSize = [self sizeWithText:jine font:JDCHEPAIFONT];
    self.fakuanLF = (CGRect){{shijianX,fakuanY},fakuanSize};
    
    CGFloat line1Y = CGRectGetMaxY(self.fakuanF)+10;
    self.line1F = (CGRect){{0,line1Y},lineSize};
    
    CGFloat neirongY = CGRectGetMaxY(self.line1F)+15;
    self.neirongF = (CGRect){{chepaiX,neirongY},shijianSize};
    
    CGSize neirongSize = [self sizeWithText:modelM.info font:JDCHEPAIFONT maxW:maxW];
    CGFloat neirongNY = CGRectGetMaxY(self.neirongF)+10;
    self.neirongNF = (CGRect){{chepaiX,neirongNY},neirongSize};
    
    CGFloat heiY = CGRectGetMaxY(self.neirongNF)+15;
    CGSize heiSize = CGSizeMake(JDScreenW, 6);
    self.heiT = (CGRect){{0,heiY},heiSize};
    bgViewH = CGRectGetMaxY(self.heiT);
    self.bgViewF = CGRectMake(0, 0, bgViewW, bgViewH);
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
