//
//  JDNoticeVC.m
//  E+TAXI_company
//
//  Created by jeader on 16/6/27.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import "JDNoticeVC.h"
#import "NoticeCell.h"
#import "JDNoticeDetailVC.h"


@interface JDNoticeVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UILabel * nonNoticeLabel;

@property (nonatomic, strong) NSArray * noticeArr;

@property (nonatomic, strong) NSMutableArray * pointArr;

@property (nonatomic, strong) NSMutableDictionary * bigDict;

@end

@implementation JDNoticeVC


/**
 懒加载无数据控件

 @return 返回一个完璧的控件
 */
- (UILabel *)nonNoticeLabel
{
    if (_nonNoticeLabel == nil)
    {
        UILabel * nonNoticeLab = [[UILabel alloc] init];
        nonNoticeLab.bounds= CGRectMake(0, 0, 120, 30);
        nonNoticeLab.center= CGPointMake(self.view.centerX, self.view.centerY-64);
        nonNoticeLab.text= @"暂无消息";
        nonNoticeLab.textColor= [UIColor darkTextColor];
        nonNoticeLab.textAlignment= NSTextAlignmentCenter;
        _nonNoticeLabel = nonNoticeLab;
        [self.view addSubview:_nonNoticeLabel];
    }
    return _nonNoticeLabel;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setpopItem];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSFileManager * manager =[NSFileManager defaultManager];
    NSString * documentsPath =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    NSString * filePath =[documentsPath stringByAppendingPathComponent:@"point.txt"];
    if ([manager fileExistsAtPath:filePath])
    {
        self.pointArr=[NSMutableArray arrayWithContentsOfFile:filePath];
    }
    else
    {
        self.pointArr=[NSMutableArray array];
    }
}
-(void)setpopItem
{
    self.navigationItem.titleView = [JDTools setTitleViewWithTitle:@"历史通知"];
    UIButton *custumItem =[UIButton buttonWithType:UIButtonTypeCustom];
    [custumItem setBackgroundImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    custumItem.frame = CGRectMake(0,0,24, 24);
    [custumItem addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * backTopItem = [[UIBarButtonItem alloc]initWithCustomView:custumItem];
    self.navigationItem.leftBarButtonItem = backTopItem;
    
    [self requestNoticeInfo];
}
-(void)pop
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)requestNoticeInfo
{
    NSDictionary * paramDic =[NSDictionary dictionary];
    paramDic=@{@"userName":USERNAME,
               @"loginTime":LOGINTIME};
    AFHTTPSessionManager  * manager =[AFHTTPSessionManager manager];
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    NSString * str =[NSString stringWithFormat:@"%@/getHistoryList.json",JDUrl];
    [manager POST:str parameters:paramDic success:^(NSURLSessionDataTask *task, id responseObject) {
        JDLog(@"the  is %@",responseObject);
        self.noticeArr=responseObject[@"historyList"];
        if (self.noticeArr.count==0)
        {
            self.tableVi.hidden=YES;
            self.nonNoticeLabel.hidden=NO;
        }
        else
        {
            self.nonNoticeLabel.hidden=YES;
            self.tableVi.hidden=NO;
            [self changeDataForSaveLocalWithArray:self.noticeArr];
            [self.tableVi reloadData];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSString * str = [NSString stringWithFormat:@"%@",error];
        NSLog(@"%s%@",__func__,str);
    }];
}



#pragma mark- UITable View DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.noticeArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%ld%ld", (long)[indexPath section], (long)[indexPath row]];
    NoticeCell * cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell)
    {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"NoticeCell" owner:nil options:nil]objectAtIndex:0];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    NSDictionary * dataDic =self.noticeArr[indexPath.row];
    
    cell.titleLabel.text=dataDic[@"from"];
    cell.detailLabel.text=dataDic[@"subject"];
    cell.contentLabel.text=dataDic[@"detail"];
    
    cell.timeLabel.text=[self getTimeString:dataDic[@"time"]];
    
    NSString * type =dataDic[@"type"];
    if ([type intValue]==0)
    {
        cell.signImg.hidden=YES;
    }
    
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumber * number =[NSNumber numberWithInteger:indexPath.row];
    for (NSNumber * num in self.pointArr)
    {
        if ([num integerValue] != indexPath.row)
        {
            [self.pointArr addObject:number];
        }
    }
    
    NSString * documentsPath =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    NSString * filePath =[documentsPath stringByAppendingPathComponent:@"point.txt"];
    [self.pointArr writeToFile:filePath atomically:YES];
    
    
    NoticeCell * cell =[tableView cellForRowAtIndexPath:indexPath];
    cell.signImg.hidden=YES;
    
    NSDictionary * noticeDic =self.noticeArr[indexPath.row];
    JDNoticeDetailVC * vc = [[JDNoticeDetailVC alloc] init];
    vc.noticeIdStr=noticeDic[@"id"];
    [self.navigationController pushViewController:vc animated:YES];
}
// 改变已读未读状态存入本地
- (void)changeDataForSaveLocalWithArray:(NSArray *)array
{
    NSMutableArray * readArr =[NSMutableArray array];
    self.bigDict=[NSMutableDictionary dictionary];
    for (int i = 0; i < array.count; i++)
    {
        NSNumber * number =[NSNumber numberWithBool:NO];
        [readArr addObject:number];
    }
    self.bigDict[@"data"]=array;
    self.bigDict[@"read"]=readArr;
    JDLog(@"the bigDictionary is %@",self.bigDict);
}
//单元格上时间的显示 格式设定
- (NSString *)getTimeString:(NSString *)string
{
    //获取到服务器回传过来的时间
    NSRange yearRange = NSMakeRange(0, 4);
    NSRange moutnRange = NSMakeRange(5, 2);
    NSRange dayRange = NSMakeRange(8, 2);
    NSRange timeRange =NSMakeRange(0, 10);
    NSRange mouthRange =NSMakeRange(5, 5);
    NSRange secondRange =NSMakeRange(11, 8);
    
    NSString * a =[string substringWithRange:yearRange];
    NSString * b =[string substringWithRange:moutnRange];
    NSString * c =[string substringWithRange:dayRange];
    
    NSString * onlyYear =[string substringWithRange:timeRange];
    NSString * onlyMouth =[string substringWithRange:mouthRange];
    NSString * onlySecond =[string substringWithRange:secondRange];
    
    //获取当前的时间
    NSDate * nowDate =[NSDate date];
    NSDateFormatter * formatt =[[NSDateFormatter alloc] init];
    [formatt setDateFormat:@"yyyyMMddhhmmss"];
    NSString * nowTime =[formatt stringFromDate:nowDate];
    NSRange year = NSMakeRange(0, 4);
    NSRange mouth = NSMakeRange(4, 2);
    NSRange day = NSMakeRange(6, 2);
    NSString * y =[nowTime substringWithRange:year];
    NSString * m =[nowTime substringWithRange:mouth];
    NSString * d =[nowTime substringWithRange:day];
    NSString * outString =nil;
    if ([a intValue]<[y intValue])//-----如果历史消息比今年的年份小  就显示YYYY-MM-DD
    {
        outString =onlyYear;
    }
    else
    {
        if ([a intValue] == [y intValue])//-----如果历史消息的年份和今年的一样
        {
            if ([b intValue] == [m intValue] && [c intValue] == [d intValue])//--------如果历史消息的日期和今天的一样
            {
                outString=onlySecond;
            }
            else                        //-------如果历史消息的年份和今天年份一样  然而日期时间不一样
            {
                outString=onlyMouth;
            }
        }
    }
    return outString;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}



@end
