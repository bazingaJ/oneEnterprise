//
//  JDIllegalCell.m
//  E+TAXI_company
//
//  Created by jeaderq on 16/7/5.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import "JDIllegalCell.h"
#import "JDWeiZhangF.h"
#define JDCHEPAIFONT [UIFont systemFontOfSize:14]
#define JDCHEPAIFONTB [UIFont systemFontOfSize:16]

@interface JDIllegalCell ()


@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UILabel *weizhang;
@property (nonatomic, strong) UILabel *weizhangN;
@property (nonatomic, strong) UILabel *didian;
@property (nonatomic, strong) UILabel *didianN;
@property (nonatomic, strong) UILabel *koufen;
@property (nonatomic, strong) UILabel *koufenN;
@property (nonatomic, strong) UILabel *fukuan;
@property (nonatomic, strong) UILabel *fukuanN;
@property (nonatomic, strong) UIView *line1;
@property (nonatomic, strong) UILabel *neirong;
@property (nonatomic, strong) UILabel *neirongN;
@property (nonatomic, strong) UIView *heiN;

@end
@implementation JDIllegalCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+(instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"status";
    JDIllegalCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[JDIllegalCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.contentView.backgroundColor = RGBColor(224, 224, 224);
        
        [self setSubViews];
    }
    return self;
}
-(void)setSubViews
{
    //cell背景View
    UIView *bgView = [[UIView alloc]init];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:bgView];
    self.bgView = bgView;
    
    UILabel *chePai  = [[UILabel alloc]init];
    chePai.font =JDCHEPAIFONTB;
    chePai.textColor = RGBColor(51, 51, 51);
    [bgView addSubview:chePai];
    self.chepai = chePai;
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = RGBColor(220, 221, 222);
    [bgView addSubview:line];
    self.line = line;
    UIView *line1 = [[UIView alloc]init];
    line1.backgroundColor = RGBColor(220, 221, 222);
    [bgView addSubview:line1];
    self.line1 = line1;
    
    UILabel *shijian = [[UILabel alloc]init];
    shijian.font = JDCHEPAIFONT;
    shijian.textColor = RGBColor(153, 153, 153);
    [bgView addSubview:shijian];
    self.weizhang = shijian;
    
    UILabel *shijianN = [[UILabel alloc]init];
    shijianN.font = JDCHEPAIFONT;
    shijianN.textColor = RGBColor(51, 51,51);
    [bgView addSubview:shijianN];
    self.weizhangN = shijianN;
    
    UILabel *didian = [[UILabel alloc]init];
    didian.font = JDCHEPAIFONT;
    didian.textColor = RGBColor(153, 153, 153);
    [bgView addSubview:didian];
    self.didian = didian;
    
    UILabel *didianN = [[UILabel alloc]init];
    didianN.font = JDCHEPAIFONT;
    didianN.textColor = RGBColor(51, 51,51);
    [bgView addSubview:didianN];
    self.didianN = didianN;
    
    UILabel *koufen = [[UILabel alloc]init];
    koufen.font = JDCHEPAIFONT;
    koufen.textColor = RGBColor(153, 153, 153);
    [bgView addSubview:koufen];
    self.koufen = koufen;
    
    UILabel *koufeL = [[UILabel alloc]init];
    koufeL.font = JDCHEPAIFONT;
    koufeL.textColor = RGBColor(153, 153, 153);
    [bgView addSubview:koufeL];
    self.koufenN = koufeL;
    UILabel *fakuan = [[UILabel alloc]init];
    fakuan.font = JDCHEPAIFONT;
    fakuan.textColor = RGBColor(153, 153, 153);
    [bgView addSubview:fakuan];
    self.fukuan = fakuan;
    
    UILabel *fakuanL = [[UILabel alloc]init];
    fakuanL.font = JDCHEPAIFONT;
    fakuanL.textColor = RGBColor(153, 153, 153);
    [bgView addSubview:fakuanL];
    self.fukuanN = fakuanL;
    
    UILabel *neirong = [[UILabel alloc]init];
    neirong.font = JDCHEPAIFONT;
    neirong.textColor = RGBColor(153, 153, 153);
    [bgView addSubview:neirong];
    self.neirong =  neirong;
    
    UILabel *neirongN = [[UILabel alloc]init];
    neirongN.font = JDCHEPAIFONT;
    neirongN.textColor = RGBColor(242, 48, 48);
    neirongN.numberOfLines = 0;
    [bgView addSubview:neirongN];
    self.neirongN = neirongN;
    
    UIView *heiV = [[UIView alloc]init];
    heiV.backgroundColor = RGBColor(241, 241, 242);
    [bgView addSubview:heiV];
    self.heiN = heiV;
}

-(void)setWeiZhangF:(JDWeiZhangF *)weiZhangF{
    _weiZhangF = weiZhangF;
    
    JDModel *jD = weiZhangF.modelM;
    jD.fen = weiZhangF.modelM.fen;
    
    self.bgView.frame  = weiZhangF.bgViewF;
    self.chepai.frame = weiZhangF.chePaiF;
    self.chepai.font = JDCHEPAIFONTB;
    self.chepai.text = jD.fen;
    self.line.frame = weiZhangF.lineF;
    self.line1.frame = weiZhangF.line1F;
    
    self.weizhang.frame = weiZhangF.shijianF;
    self.weizhang.text = @"违章时间:";
    self.weizhang.font = JDCHEPAIFONT;
    self.weizhangN.frame = weiZhangF.shijianNF;
    self.weizhangN.text = jD.occur_date;
    self.weizhangN.font = JDCHEPAIFONT;

    self.didian.frame = weiZhangF.didianF;
    self.didian.text = @"违章地点:";
    self.didian.font = JDCHEPAIFONT;

    self.didianN.frame = weiZhangF.didianNF;
    self.didianN.text = jD.occur_area;
    self.didianN.font = JDCHEPAIFONT;

    self.koufen.frame = weiZhangF.koufenF;
    self.koufen.text = @"是否扣分:";
    self.koufen.font = JDCHEPAIFONT;

    self.koufenN.frame = weiZhangF.koufeLF;
    if ([jD.fen intValue]==1) {
        self.koufenN.text =@"是";
    }else{
        self.koufenN.text =@"否";
    }
    self.koufenN.font = JDCHEPAIFONT;

    self.fukuan.frame = weiZhangF.fakuanF;
    self.fukuan.text = @"罚款金额:";
    self.fukuan.font = JDCHEPAIFONT;

    self.fukuanN.frame = weiZhangF.fakuanLF;
    self.fukuanN.text = [NSString stringWithFormat:@"%@",jD.money];
    self.fukuanN.font = JDCHEPAIFONT;

    self.neirong.frame = weiZhangF.neirongF;
    self.neirong.text = @"违章内容:";
    self.neirong.font = JDCHEPAIFONT;
    
    self.neirongN.frame = weiZhangF.neirongNF;
    self.neirongN.text = jD.info;
    self.neirongN.font = JDCHEPAIFONT;

    self.heiN.frame = weiZhangF.heiT;
    
    
    
    
}
//-(void)setJokeFrame:(JokeFrame *)model
//{
//    _jokeFrame = model;
//    
//    
//    JokeModel *joke = model.jokeM;
//    joke.author = model.jokeM.author;
//    
//    self.bgView.frame = model.bgViewF;
//    self.neihanTitle.centerX = self.bgView.centerX;
//    self.neihanTitle.y = self.bgView.y-self.neihanTitle.height*0.75;
//    
//    //作者
//    self.author.frame = model.authorF;
//    self.author.text = [NSString stringWithFormat:@"来自: %@",joke.author];
//    self.author.font = JokeAuthorFont;
//    // 正文内容
//    self.content.frame = model.contentF;
//    self.content.text = joke.content;
//    self.content.font = JokeContentFont;
//    //配图
//    if (joke.picUrl) {
//        self.picUrl.frame = model.picUrlF;
//        
//        if (model.picUrlF.size.width> _bgView.frame.size.width) {
//            self.picUrl.width =kScreenW-20;
//            self.picUrl.x = 0;
//            //            self.picUrl.centerX =_bgView.centerX;
//        }
//        [self.picUrl sd_setImageWithURL:[NSURL URLWithString:joke.picUrl]];
//        self.picUrl.hidden= NO;
//    }else{
//        self.picUrl.hidden = YES;
//    }
//    
//    //    CGFloat maxW = kScreenW - jokeMargin*2;
//    //    CGFloat contentY = CGRectGetMaxY(self.author.frame) + jokeMargin;
//    //    CGSize contentSize = [self sizeWithText:model.content font:JokeContentFont maxW:maxW];
//    //    self.content.text = model.content;
//    //    self.content.frame = (CGRect){{authorXY,contentY},contentSize};
//    //
//    //    self.cellHeight = CGRectGetMaxY(self.content.frame)+jokeMargin;
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
