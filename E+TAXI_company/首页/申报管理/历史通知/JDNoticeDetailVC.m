//
//  JDNoticeDetailVC.m
//  E+TAXI_company
//
//  Created by jeader on 16/6/28.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import "JDNoticeDetailVC.h"

@interface JDNoticeDetailVC ()

@property (nonatomic, strong) NSArray * noticeDetailArr;

@end

@implementation JDNoticeDetailVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setpopItem];
}
-(void)setpopItem
{
    self.navigationItem.titleView = [JDTools setTitleViewWithTitle:@"历史通知详情"];
    UIButton *custumItem =[UIButton buttonWithType:UIButtonTypeCustom];
    [custumItem setBackgroundImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    custumItem.frame = CGRectMake(0,0,24, 24);
    [custumItem addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * backTopItem = [[UIBarButtonItem alloc]initWithCustomView:custumItem];
    self.navigationItem.leftBarButtonItem = backTopItem;
    
    [self requestNoticeDetailWithId:self.noticeIdStr];
}
-(void)pop
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)requestNoticeDetailWithId:(NSString *)noticeId
{
    NSDictionary * paramDic =[NSDictionary dictionary];
    paramDic=@{@"userName":USERNAME,
               @"loginTime":LOGINTIME,
               @"id":noticeId};
    AFHTTPSessionManager  * manager =[AFHTTPSessionManager manager];
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    NSString * str =[NSString stringWithFormat:@"%@/getMessageDetail.json",JDUrl];
    [manager POST:str parameters:paramDic success:^(NSURLSessionDataTask *task, id responseObject) {
        
        
        self.noticeDetailArr=[self dealDataForRefreshWithDic:responseObject];
        [self refreshLayoutView];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSString * str = [NSString stringWithFormat:@"%@",error];
        NSLog(@"%s%@",__func__,str);
    }];
}

- (NSArray *)dealDataForRefreshWithDic:(NSDictionary *)noticeDict
{
    NSString * timeDealString =noticeDict[@"time"];
    NSArray * dealArr =[timeDealString componentsSeparatedByString:@"."];
    NSString * timeString =[dealArr firstObject];
    
    NSArray * noticeDetailArr = @[noticeDict[@"subject"],noticeDict[@"from"],noticeDict[@"to"],timeString,noticeDict[@"detail"]];
    return noticeDetailArr;
}
- (void)refreshLayoutView
{
    self.titleLabel.text=self.noticeDetailArr[0];
    self.fromLabel.text=self.noticeDetailArr[1];
    self.getLabel.text=self.noticeDetailArr[2];
    self.tiemLabel.text=self.noticeDetailArr[3];
    self.contentLabel.text=self.noticeDetailArr[4];
    self.explainLabel.hidden=YES;
    self.noticeImg.hidden=YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}



@end
