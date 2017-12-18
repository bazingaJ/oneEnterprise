//
//  JDBrandController.m
//  E+TAXI_company
//
//  Created by jeaderq on 16/6/26.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import "JDBrandController.h"
#import "JDBrandCell.h"

@interface JDBrandController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@end

@implementation JDBrandController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setpopItem];
    [self getData];
    // Do any additional setup after loading the view from its nib.
}
-(void)getData{
    JDData *data = [JDData new];
    [data brandDataWithCompletion:^(NSString *returnCode, id res) {
        if ([returnCode intValue]==0) {
            self.dataArr = [JDModel mj_objectArrayWithKeyValuesArray:res];
            JDLog(@"%@",self.dataArr);
            [self.tableView reloadData];
        }
    }];
}
-(void)setpopItem{
    self.navigationItem.titleView = [JDTools setTitleViewWithTitle:@"车品牌型号"];
    UIButton *custumItem =[UIButton buttonWithType:UIButtonTypeCustom];
    [custumItem setBackgroundImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [custumItem setBackgroundImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateHighlighted];
    custumItem.frame = CGRectMake(0,0, 24, 24);
    [custumItem addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * backTopItem = [[UIBarButtonItem alloc]initWithCustomView:custumItem];
    self.navigationItem.leftBarButtonItem = backTopItem;
  
}
-(void)pop{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - table view dataSource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 89;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"MTCell";
    
    JDBrandCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    JDModel *model  = self.dataArr[indexPath.row];
    if(cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"JDBrandCell" owner:nil options:nil][0];
    }
    cell.xuHaoL.text = [NSString stringWithFormat:@"序号 : %ld", (long)indexPath.row];
    cell.texiBrandL.text = [NSString stringWithFormat:@"品牌 : %@",model.taxiBrand];
    cell.taxiModelL.text =[NSString stringWithFormat:@"型号 : %@",model.taxiModel];
   
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
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
