//
//  JDEnterpriseController.m
//  E+TAXI_company
//
//  Created by jeaderq on 16/6/26.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import "JDEnterpriseController.h"
#import "JDQyxqController.h"
#import "JDEnterCell.h"
@interface JDEnterpriseController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@end

@implementation JDEnterpriseController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setpopItem];
    [self getData];
    // Do any additional setup after loading the view from its nib.
}
-(void)setpopItem{
    self.navigationItem.titleView = [JDTools setTitleViewWithTitle:@"出租车企业"];
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
    [data EnterpriseDataWithCompletion:^(NSString *returnCode, id res) {
        JDLog(@"res===%@",res);
        self.dataArr = [JDModel mj_objectArrayWithKeyValuesArray:res];
        [self.tableView reloadData];
    }];
}
#pragma mark - table view dataSource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 79;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"MTCell";
    JDModel *model  = self.dataArr[indexPath.row];
    JDEnterCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"JDEnterCell" owner:nil options:nil][0];
    }
    cell.taxiNameL.text = model.taxiCompanyName;
    cell.taxiPhoneL.text = model.taxiCompanyPhone;
    cell.taxAddressL.text = model.taxiCompanyAddress;
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JDModel *model  = self.dataArr[indexPath.row];
    JDQyxqController *xq = [[JDQyxqController alloc]init];
    xq.taxiCompanyId = model.taxiCompanyId;
    [self.navigationController pushViewController:xq animated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
