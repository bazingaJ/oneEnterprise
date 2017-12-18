//
//  JDEnterpriseChooseController.m
//  E+TAXI_company
//
//  Created by jeaderq on 16/6/28.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import "JDEnterpriseChooseController.h"
#import "JDEnterpriseChooseCell.h"
#import "JDTaxiController.h"
#import "JDDriverController.h"

@interface JDEnterpriseChooseController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@end

@implementation JDEnterpriseChooseController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setpopItem];
    [self getData];
    // Do any additional setup after loading the view from its nib.
}
-(void)setpopItem{
    self.navigationItem.titleView = [JDTools setTitleViewWithTitle:@"企业选择"];
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
    return 68;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"MTCell";
    
    JDEnterpriseChooseCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    JDModel *model  = self.dataArr[indexPath.row];

    if(cell == nil) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"JDEnterpriseChooseCell" owner:nil options:nil][0];
    }
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    cell.carCount.text = [NSString stringWithFormat:@"共%d辆出租车",model.taxiCount];
    cell.taxiQY.text = [NSString stringWithFormat:@"%@",model. taxiCompanyName];
    return cell;
}

#pragma mark - table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    JDModel *model  = self.dataArr[indexPath.row];

    if (self.isTaxi) {
        JDTaxiController *taxi = [[JDTaxiController alloc]init];
        taxi.companyId = model.taxiCompanyId;
        [self.navigationController pushViewController:taxi animated:YES];
    }else{
        JDDriverController *drive = [[JDDriverController alloc]init];
        drive.companyId = model.taxiCompanyId;
        [self.navigationController pushViewController:drive animated:YES];
    }
    
    
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
