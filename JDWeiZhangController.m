//
//  JDWeiZhangController.m
//  E+TAXI_company
//
//  Created by jeaderq on 16/6/26.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import "JDWeiZhangController.h"
#import "JDWeiZhangCell.h"
#import "JDIllegalCell.h"
#import "JDWeiZhangF.h"


@interface JDWeiZhangController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@end

@implementation JDWeiZhangController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setpopItem];
    [self getData];
    // Do any additional setup after loading the view from its nib.
}
-(void)setpopItem{
//    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"navBG"]];
//    imageView.x = 0;
//    imageView.y = 0;
//    imageView.userInteractionEnabled = YES;
//    [self.view addSubview:imageView];
    self.navigationItem.titleView = [JDTools setTitleViewWithTitle:@"违章查询"];
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
    [data getPeccDataWithLicenseNo:@"苏AJ08G9" engineNo:@"005362" WithCompletion:^(NSString *returnCode, id res) {
        JDLog(@"%s  %@",__func__,res);
        NSArray *historys = res[@"historys"];
        NSMutableArray *dataArr = [JDModel mj_objectArrayWithKeyValuesArray:historys];
        JDLog(@"%s 数组中是 %@",__func__,dataArr);
        self.dataArr  = [self moreJDWithDataArr:dataArr];
        [self.tableView reloadData];
    }];
    
}
-(NSMutableArray *)moreJDWithDataArr:(NSMutableArray *)array{
    NSMutableArray *joke =[NSMutableArray array];
    for (JDModel *mode in array) {
        JDWeiZhangF *j = [[JDWeiZhangF alloc]init];
        j.modelM = mode;
        [joke addObject:j];
    }
    return joke;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - table view dataSource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    JDWeiZhangF *cell = self.dataArr[indexPath.row];
    
    return cell.cellHeigh;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JDIllegalCell *cell = [JDIllegalCell cellWithTableView:tableView];
    cell.weiZhangF = self.dataArr[indexPath.row];
//    cell.weiZhangF = 
//    JDWeiZhangCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//    
//    if(cell == nil) {
//        cell = [[NSBundle mainBundle] loadNibNamed:@"JDWeiZhangCell" owner:nil options:nil][0];
//    }
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    cell.chepai.text = self.model.taxiNumber;
    
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
