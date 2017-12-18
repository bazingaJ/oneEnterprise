//
//  LostFoundVC.m
//  E+TAXI_company
//
//  Created by jeader on 16/6/25.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import "JDLostFoundVC.h"
#import "JDLostDetailVC.h"
#import "LostCell.h"
#import "UIImageView+WebCache.h"

NSString * const kCellIdentifier1 =@"cell1";

@interface JDLostFoundVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *seachView;
@property (nonatomic, strong) NSMutableArray * dataArr;
@property (nonatomic) BOOL isload;
@property (nonatomic) int page;
@property (weak, nonatomic) IBOutlet UITextField *seachField;

@end

@implementation JDLostFoundVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.seachView.layer.borderColor = RGBColor(220, 221, 222).CGColor;

    [self.navigationController.navigationBar setTitleTextAttributes:
                                              @{NSFontAttributeName:[UIFont systemFontOfSize:19],
                                     NSForegroundColorAttributeName:[UIColor blackColor]}];
    [self setpopItem];
    self.dataArr=[NSMutableArray array];
    self.searchTF.delegate=self;
    if (_text.length==0)
    {
        
        [self sendRequest];
    }
    else
    {
        [self requestWithSearchDataWithCondition:self.text];
        self.searchTF.text=self.text;
    }
    [_seachField addTarget:self  action:@selector(valueChanged:)  forControlEvents:UIControlEventAllEditingEvents];

}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}
-(void)setpopItem
{
    if (_isLost)
    {
        self.navigationItem.titleView = [JDTools setTitleViewWithTitle:@"失物申报"];
    }
    else
    {
        self.navigationItem.titleView = [JDTools setTitleViewWithTitle:@"路况申报"];
    }
    
    UIButton *custumItem = [UIButton buttonWithType:UIButtonTypeCustom];
    [custumItem setBackgroundImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    custumItem.frame = CGRectMake(0,0,24, 24);
    [custumItem addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * backTopItem = [[UIBarButtonItem alloc]initWithCustomView:custumItem];
    self.navigationItem.leftBarButtonItem = backTopItem;
    self.tableVi.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
}
- (void)sendRequest
{
    if (_isLost)
    {
        [self requestLostDataWithAPIName:@"getLostInfo" WithSearchCondition:@""];
    }
    else
    {
        [self requestLostDataWithAPIName:@"getTrafficInfo" WithSearchCondition:@""];
    }
}
-(void)pop
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 发送请求 上拉刷新
- (void)requestLostDataWithAPIName:(NSString *)APIName WithSearchCondition:(NSString *)condition
{
    if (self.isload==YES)
    {
        return;
    }
    else
    {
        NSString * number =[NSString stringWithFormat:@"%d",_page*20];
        NSDictionary * paramDic =[NSDictionary dictionary];
        paramDic=@{@"userName":USERNAME,
                   @"loginTime":LOGINTIME,
                   @"startIndex":number,
                   @"limit":@"20"};
        AFHTTPSessionManager  * manager =[AFHTTPSessionManager manager];
        manager.responseSerializer=[AFJSONResponseSerializer serializer];
        NSString * str =[NSString stringWithFormat:@"%@/%@.json",JDUrl,APIName];
        [manager POST:str parameters:paramDic success:^(NSURLSessionDataTask *task, id responseObject) {
            NSString * returnCode =responseObject[@"returnCode"];
            NSString * msg =responseObject[@"msg"];
            if ([returnCode intValue]==0)
            {
                if (_isLost)
                {
                    NSArray * arr =responseObject[@"lostResult"];
                    [self.dataArr addObjectsFromArray:arr];
                }
                else
                {
                    NSArray * arr =responseObject[@"trafficResult"];
                    [self.dataArr addObjectsFromArray:arr];
                }
                
                [self.tableVi reloadData];
                self.page++;
                self.isload = NO;
            }
            else if ([returnCode intValue]==1)
            {
                JDLog(@"the msg is the %@",msg);
            }
            else
            {
                JDLog(@"the msg is the %@",msg);
            }
            
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
            NSString * str = [NSString stringWithFormat:@"%@",error];
            NSLog(@"%s%@",__func__,str);
            
        }];
    }
    
}

#pragma mark- UITable View DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    LostCell * cell =[tableView dequeueReusableCellWithIdentifier:kCellIdentifier1];
    if (!cell)
    {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"LostCell" owner:nil options:nil]objectAtIndex:0];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    NSDictionary * lostDict = self.dataArr[indexPath.row];
    if (_isLost)
    {
        [cell.thingImg sd_setImageWithURL:[NSURL URLWithString:lostDict[@"lostImg"]] placeholderImage:[UIImage imageNamed:@"photo_moren_sb"]];
        cell.typeLabel.text=[NSString stringWithFormat:@"类    型:  %@",lostDict[@"lostType"]];
        cell.plateLab.text=[NSString stringWithFormat:@"车牌号:  %@",lostDict[@"taxiNumber"]];
        cell.timeLab.text=[NSString stringWithFormat:@"时    间:  %@",lostDict[@"lostTime"]];
    }
    else
    {
        [cell.thingImg sd_setImageWithURL:[NSURL URLWithString:lostDict[@"trafficImg"]] placeholderImage:[UIImage imageNamed:@"photo_moren_sb"]];
        cell.typeLabel.text=[NSString stringWithFormat:@"类    型:  %@",lostDict[@"trafficType"]];
        cell.plateLab.text=[NSString stringWithFormat:@"地    址:  %@",lostDict[@"traffiAddress"]];
        
        NSString * timeDealString =lostDict[@"trafficTime"];
        NSArray * dealArr =[timeDealString componentsSeparatedByString:@"."];
        NSString * timeString =[dealArr firstObject];
        
        cell.timeLab.text=[NSString stringWithFormat:@"时    间:  %@",timeString];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 84;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

#pragma mark - UITable View Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary * lostDict = self.dataArr[indexPath.row];
    
    JDLostDetailVC * vc =[[JDLostDetailVC alloc] init];
    if (self.isLost)
    {
        vc.title=@"失物招领详情";
        vc.lostIdentifier=lostDict[@"lostId"];
        vc.isLost=YES;
    }
    else
    {
        vc.title=@"路况申报详情";
        vc.roadIdentifier=lostDict[@"trafficId"];
        vc.isLost=NO;
    }
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.searchTF.text.length==0)
    {
        // 如果tableView还没有数据，就直接返回
        CGFloat offsetY = scrollView.contentOffset.y;
        // 当最后一个cell完全显示在眼前时，contentOffset的y值
        CGFloat judeOffset= scrollView.contentSize.height +scrollView.contentInset.bottom -scrollView.height - self.tableVi.tableFooterView.height;
        if (offsetY >= judeOffset)
        {
            self.tableVi.tableFooterView.hidden = NO;
            //参数需要的页码 每次加1 获取下一页的内容
            
            if (_isLost)
            {
                [self requestLostDataWithAPIName:@"getLostInfo" WithSearchCondition:@""];
            }
            else
            {
                [self requestLostDataWithAPIName:@"getTrafficInfo" WithSearchCondition:@""];
            }
            
            self.isload = YES;
            
        }
    }
    
}


#pragma mark - UITextField Delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString * text =[textField.text stringByReplacingCharactersInRange:range withString:string];
    if (text.length==0)
    {
        if (_isLost)
        {
            [self requestLostDataWithAPIName:@"getLostInfo" WithSearchCondition:@""];
        }
        else
        {
            [self requestLostDataWithAPIName:@"getTrafficInfo" WithSearchCondition:@""];
        }
    }
    else
    {
        [self requestWithSearchDataWithCondition:text];
    }
    return YES;
}
-(void)valueChanged:(UITextField *)fild{
    JDLog(@"全局搜索》》》》%@",fild.text);
 
    [self requestWithSearchDataWithCondition:fild.text];
   
}
- (void)requestWithSearchDataWithCondition:(NSString *)condition
{
    if (_isLost)
    {
        JDData * data =[JDData new];
        
        [data getSeachWithSeachType:@"3" serchContent:condition WithCompletion:^(NSString *returnCode, id res) {
            
            if ([returnCode intValue]==0)
            {
                [self.dataArr removeAllObjects];
                NSArray * getArr = res[@"lostResult"];
                [self.dataArr addObjectsFromArray:getArr];
                [self.tableVi reloadData];
            }
            else if ([returnCode intValue]==1)
            {
//                [JDTools addAlertViewInView:self title:@"" message:res count:0 doWhat:nil];
            }
            else if ([returnCode intValue]==2)
            {
                [JDTools addAlertViewInView:self title:@"" message:res count:0 doWhat:nil];
            }
            else
            {
                [JDTools addAlertViewInView:self title:@"" message:res count:0 doWhat:nil];
            }
        }];
    }
    else
    {
        JDData * data =[JDData new];
        [data getSeachWithSeachType:@"4" serchContent:condition WithCompletion:^(NSString *returnCode, id res) {
            
            if ([returnCode intValue]==0)
            {
                [self.dataArr removeAllObjects];
                NSArray * getArray = res[@"trafficResult"];
                [self.dataArr addObjectsFromArray:getArray];
                [self.tableVi reloadData];
            }
            else if ([returnCode intValue]==1)
            {
//                [JDTools addAlertViewInView:self title:@"" message:res count:0 doWhat:nil];
            }
            else if ([returnCode intValue]==2)
            {
                [JDTools addAlertViewInView:self title:@"" message:res count:0 doWhat:nil];
            }
            else
            {
                [JDTools addAlertViewInView:self title:@"" message:res count:0 doWhat:nil];
            }
            
        }];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



@end
