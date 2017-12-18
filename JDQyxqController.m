
//
//  JDQyxqController.m
//  E+TAXI_company
//
//  Created by jeaderq on 16/6/26.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import "JDQyxqController.h"

@interface JDQyxqController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSMutableArray *dataArr1;
@property (nonatomic, strong) NSMutableArray *dataArr2;
@end

@implementation JDQyxqController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBColor(241, 241, 242);
    self.tableView.backgroundColor = RGBColor(241, 241, 242);
    [self setpopItem];
    [self getData];
    // Do any additional setup after loading the view from its nib.
}
-(void)setpopItem{
    self.navigationItem.titleView = [JDTools setTitleViewWithTitle:@"企业详情"];
    UIButton *custumItem =[UIButton buttonWithType:UIButtonTypeCustom];
    [custumItem setBackgroundImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    custumItem.frame = CGRectMake(0,0, 24, 24);
    [custumItem addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * backTopItem = [[UIBarButtonItem alloc]initWithCustomView:custumItem];
    self.navigationItem.leftBarButtonItem = backTopItem;
    
}
-(void)pop{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)getData{
    JDData *data = [JDData new];
    [data enterpriseDetailWithId:self.taxiCompanyId WithCompletion:^(NSString *returnCode, id res) {
        JDLog(@"res>>>>>%@",res);
        JDModel *model = [JDModel mj_objectWithKeyValues:res];
        self.dataArr = [NSMutableArray array];
        self.dataArr1 = [NSMutableArray array];
        self.dataArr2 = [NSMutableArray array];
        [self.dataArr addObject:model.taxiCompanyName];
        [self.dataArr addObject:model.taxiCompanyNo];
        [self.dataArr addObject:model.taxiCompanyPhone];
        [self.dataArr addObject:model.zioCode];
        [self.dataArr addObject:model.faxNumber];
        [self.dataArr addObject:model.taxiCompanyWeb];
        [self.dataArr1 addObject:model.taxiCompanyType];
        [self.dataArr1 addObject:model.legalPerson];
        [self.dataArr1 addObject:model.parentCompany];
        [self.dataArr1 addObject:model.contactName];
        [self.dataArr1 addObject:model.contactPhone];
        [self.dataArr1 addObject:model.email];
        [self.dataArr2 addObject:model.supervisePhone];
        [self.dataArr2 addObject:model.reportPhone];
        [self.tableView reloadData];
    }];
    
    
}

#pragma mark - table view dataSource
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, JDScreenW, 10)];
    view.backgroundColor = RGBColor(241, 241, 242);
//    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, JDScreenW, 1)];
//    line.backgroundColor = RGBColor(220, 221, 222);
//    [view addSubview:line];
//    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 9, JDScreenW, 1)];
//    line1.backgroundColor = RGBColor(220, 221, 222);
//    [view addSubview:line1];
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 2) {
        return 2;
    }else{
    return 6;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"MTCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    NSArray *arr = @[@"企业名",@"企业号",@"企业电话",@"邮编",@"传真",@"网站"];
    NSArray *arr1 = @[@"企业性质",@"企业法人",@"母公司",@"企业联系人",@"联系人电话",@"Email"];
    NSArray *arr2 = @[@"企业监督电话",@"违章举报电话"];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    if (indexPath.section== 0) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@", arr[indexPath.row]];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", self.dataArr[indexPath.row]];

    }else if (indexPath.section==1){
        cell.textLabel.text = [NSString stringWithFormat:@"%@", arr1[indexPath.row]];

        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", self.dataArr1[indexPath.row]];

    }else{
    cell.textLabel.text = [NSString stringWithFormat:@"%@", arr2[indexPath.row]];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", self.dataArr2[indexPath.row]];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:14];

    cell.detailTextLabel.font = [UIFont systemFontOfSize:14];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
