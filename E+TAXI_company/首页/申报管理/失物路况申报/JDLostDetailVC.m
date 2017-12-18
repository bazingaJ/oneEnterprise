//
//  JDLostDetailVC.m
//  E+TAXI_company
//
//  Created by jeader on 16/6/27.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import "JDLostDetailVC.h"
#import "LostCell.h"

static NSString *  kCellIdentifier =@"cell2";
static NSString *  kCellIdentifier1 =@"cell3";
static NSString *  kCellIdentifier2 =@"cell4";

@interface JDLostDetailVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSArray * titleArr;
@property (nonatomic, strong) NSArray * roadArr;
@property (nonatomic, strong) NSArray * detailArr;
@end

@implementation JDLostDetailVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:19],
       NSForegroundColorAttributeName:[UIColor blackColor]}];
    self.tableVi.tableFooterView=[[UIView alloc] init];
    
    [self setpopItem];
    
}
-(void)setpopItem
{
    if (_isLost)
    {
        self.navigationItem.titleView = [JDTools setTitleViewWithTitle:@"失物申报详情"];
        [self requestLostDataWithAPIName:@"getLostDetail" WithSearchId:self.lostIdentifier];
    }
    else
    {
          self.navigationItem.titleView = [JDTools setTitleViewWithTitle:@"路况申报详情"];
        [self requestLostDataWithAPIName:@"getTrafficDetail" WithSearchId:self.roadIdentifier];
    }
  
    UIButton *custumItem =[UIButton buttonWithType:UIButtonTypeCustom];
    [custumItem setBackgroundImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    custumItem.frame = CGRectMake(0,0,24, 24);
    [custumItem addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * backTopItem = [[UIBarButtonItem alloc]initWithCustomView:custumItem];
    self.navigationItem.leftBarButtonItem = backTopItem;
}
-(void)pop
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark - 发送请求
- (void)requestLostDataWithAPIName:(NSString *)APIName WithSearchId:(NSString *)identifier
{
    NSDictionary * paramDic =[NSDictionary dictionary];
    paramDic=@{@"userName":USERNAME,
               @"loginTime":LOGINTIME,
               @"id":identifier};
    AFHTTPSessionManager  * manager =[AFHTTPSessionManager manager];
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    NSString * str =[NSString stringWithFormat:@"%@/%@.json",JDUrl,APIName];
    [manager POST:str parameters:paramDic success:^(NSURLSessionDataTask *task, id responseObject) {
        if (_isLost)
        {
            [self dealLostDataWithResponse:responseObject];
        }
        else
        {
            [self dealLostDataWithResponse:responseObject];
        }
        
        [self.tableVi reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSString * str = [NSString stringWithFormat:@"%@",error];
        NSLog(@"%s%@",__func__,str);
    }];
}


- (NSArray *)titleArr
{
    if (!_titleArr)
    {
        _titleArr=[NSArray arrayWithObjects:@{@"title":
                                            @[@"失物类型",@"联系电话",@"申报车牌号",@"申报人姓名",@"丢失时间",@"状态"]},
                                            nil];
    }
    return  _titleArr;
}
- (NSArray *)roadArr
{
    if (!_roadArr)
    {
        
        _roadArr=[NSArray arrayWithObjects:@{@"title":
                                           @[@"路况类型",@"地址",@"申报时间",@"申报车牌号",@"申报人姓名",@"联系电话",@"状态"]},
                                            nil];
    }
    return _roadArr;
}

#pragma mark- UITable View DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.isLost)
    {
        if (section==1) return 6;
        else return 1;
    }
    else
    {
        if (section==1) return 7;
        else return 1;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LostCell * cell =nil;
    if (indexPath.section==0)
    {
        cell=[tableView dequeueReusableCellWithIdentifier:kCellIdentifier2];
        if (!cell)
        {
            cell=[[[NSBundle mainBundle]loadNibNamed:@"LostCell" owner:nil options:nil]objectAtIndex:3];
        }
        if (_isLost)
        {
            [cell.picImg sd_setImageWithURL:[NSURL URLWithString:self.detailArr[7]] placeholderImage:[UIImage imageNamed:@"photo_moren_big"]];
        }
        else
        {
            [cell.picImg sd_setImageWithURL:[NSURL URLWithString:self.detailArr[8]] placeholderImage:[UIImage imageNamed:@"photo_moren_big"]];
        }
    }
    else if (indexPath.section==1)
    {
        cell=[tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
        if (!cell)
        {
            cell=[[[NSBundle mainBundle]loadNibNamed:@"LostCell" owner:nil options:nil]objectAtIndex:1];
        }
        if (_isLost)
        {
            cell.titleLabel.text=self.titleArr[0][@"title"][indexPath.row];
            cell.contentLabel.text=self.detailArr[indexPath.row];
        }
        else
        {
            cell.titleLabel.text=self.roadArr[0][@"title"][indexPath.row];
            cell.contentLabel.text=self.detailArr[indexPath.row];
        }
        
    }
    else
    {
        cell=[tableView dequeueReusableCellWithIdentifier:kCellIdentifier1];
        if (!cell)
        {
            cell=[[[NSBundle mainBundle]loadNibNamed:@"LostCell" owner:nil options:nil]objectAtIndex:2];
        }
        if (_isLost)
        {
            cell.decribelLabel.text=self.detailArr[6];
        }
        else
        {
            cell.decribelLabel.text=self.detailArr[7];
        }
    }
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) return 0;
    else return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)  return 211;
    else if (indexPath.section==1) return 44;
    else return 68;
}




#pragma mark - 
#pragma mark - 返回的数据处理

- (void)dealLostDataWithResponse:(id)response
{
    //是否有描述
    NSString * detail =response[@"detail"];
    
    NSString * status = [NSString stringWithFormat:@"%@",response[@"lostStatus"]];
    NSString * str = nil;
    if ([status intValue]==0)
    {
        str =@"新增";
    }
    else if ([status intValue]==1)
    {
        str =@"废弃";
    }
    else if ([status intValue]==2)
    {
        str =@"有效";
    }
    else
    {
        str =@"完成";
    }
    if (_isLost)
    {
        
        if([detail isEqual:[NSNull null]])
        {
            self.detailArr=@[response[@"lostType"],
                             response[@"phone"],
                             response[@"taxiNumber"],
                             response[@"taxiName"],
                             response[@"lostTime"],
                             str,
                             @"暂无描述",
                             response[@"lostImg"]];
        }
        else
        {
            self.detailArr=@[response[@"lostType"],
                             response[@"phone"],
                             response[@"taxiNumber"],
                             response[@"taxiName"],
                             response[@"lostTime"],
                             str,
                             detail,
                             response[@"lostImg"]];
        }
    }
    else
    {
        
        NSString * timeDealString =response[@"trafficTime"];
        NSArray * dealArr =[timeDealString componentsSeparatedByString:@"."];
        NSString * timeString =[dealArr firstObject];
        
        if([detail isEqual:[NSNull null]])
        {
            self.detailArr=@[response[@"trafficType"],
                             response[@"traffiAddress"],
                             timeString,
                             response[@"taxiNumber"],
                             response[@"name"],
                             response[@"phoneNumber"],
                             str,
                             @"暂无描述",
                             response[@"trafficImg"]];
        }
        else
        {
            self.detailArr=@[response[@"trafficType"],
                             response[@"traffiAddress"],
                             timeString,
                             response[@"taxiNumber"],
                             response[@"name"],
                             response[@"phoneNumber"],
                             str,
                             detail,
                             response[@"trafficImg"]];
        }
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



@end
