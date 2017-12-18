//
//  JDDriverDetailsController.m
//  E+TAXI_company
//
//  Created by jeaderq on 16/6/27.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import "JDDriverDetailsController.h"
@interface JDDriverDetailsController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) JDModel *model;
@end

@implementation JDDriverDetailsController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getData];
    [self setpopItem];
    
    // Do any additional setup after loading the view from its nib.
}
-(void)setpopItem{
    self.navigationItem.titleView = [JDTools setTitleViewWithTitle:@"驾驶员详情"];
    UIButton *custumItem =[UIButton buttonWithType:UIButtonTypeCustom];
    [custumItem setBackgroundImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    custumItem.frame = CGRectMake(0,0,24, 24);
    [custumItem addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * backTopItem = [[UIBarButtonItem alloc]initWithCustomView:custumItem];
    self.navigationItem.leftBarButtonItem = backTopItem;
}
-(void)pop{
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSMutableArray *)dataArr{
    if (_dataArr==nil) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

-(void)getData{
    JDData *data = [JDData new];
    
    [data getDriverDetailWithDriverId:self.driverId startIndex:nil Limit:nil WithCompletion:^(NSString *returnCode, id res) {
        JDLog(@"驾驶员详情== %@",res);
        
        JDModel * mode = [JDModel mj_objectWithKeyValues:res];
        self.model = mode;
        [self.tableView reloadData];
    }];

}


#pragma mark - table view dataSource
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }else{
    return 10;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, JDScreenW, 10)];
    view.backgroundColor = RGBColor(241, 241, 242);
    return view;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return 1;
    }else if (section==1) {
        return 7;
    }else if (section==2){
        return 5;
    }else if (section==3){
        return 3;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return HEIGHT(210.5, 667);
    }else{
    return 44;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"MTCell";
    
    UITableViewCell *cell = nil;
    NSArray *arr = @[@"姓名",@"性别",@"所属公司",@"手机号码",@"出生日期",@"居住地址",@"准驾车型"];
    NSArray *arr1 = @[@"车牌号",@"服务证号",@"档案编号",@"领证日期",@"有效期限"];
    NSArray *arr2 = @[@"车品牌型号",@"PAD号",@"SIM卡号"];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    
    if (indexPath.section==0) {
        if (indexPath.row==0) {
        UIImageView *driveIcon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, JDScreenW, HEIGHT(210.5, 667))];
            UIImage * img=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.model.driverHead]]];
            driveIcon.width = img.size.width;
            NSLog(@"%f",driveIcon.width);
            if (driveIcon.width>JDScreenW) {
                driveIcon.width = 252;
            }
            driveIcon.centerX = JDScreenW/2;
        [driveIcon sd_setImageWithURL:[NSURL URLWithString:self.model.driverHead] placeholderImage:[UIImage imageNamed:@"photo_moren_big"]];
        [cell.contentView addSubview:driveIcon];
        }
    }else if (indexPath.section == 1) {
         cell.textLabel.text =arr[indexPath.row];
        if (indexPath.row ==0) {
                cell.detailTextLabel.text = self.model.driverName;
         
        }else if (indexPath.row ==1) {
            if ([self.model.driverSex intValue]==0) {
                cell.detailTextLabel.text = @"男";
                
            }else{
                cell.detailTextLabel.text = @"女";
                
            }
        }else if (indexPath.row ==2){
            cell.detailTextLabel.text = self.model.company;

        }else if (indexPath.row ==3){
            cell.detailTextLabel.text = self.model.driverPhoneNumber;

        }else if (indexPath.row ==4){
            cell.detailTextLabel.text = self.model.driverBirth;

        }else if (indexPath.row ==5){
            cell.detailTextLabel.text = self.model.driverHome;

        }else if (indexPath.row ==6){
            cell.detailTextLabel.text = self.model.drivingType;

        }
    }else if (indexPath.section == 2){
        cell.textLabel.text =arr1[indexPath.row];
        if (indexPath.row ==0) {
            cell.detailTextLabel.text = self.model.taxiNumber;
            
        }else if (indexPath.row ==1) {
            cell.detailTextLabel.text = self.model.serviceNumber;
                
        }else if (indexPath.row ==2){
            cell.detailTextLabel.text = self.model.recordNumber;
            
        }else if (indexPath.row ==3){
            cell.detailTextLabel.text = self.model.getYmd;
            
        }else if (indexPath.row ==4){
            cell.detailTextLabel.text = self.model.endYmd;
            
        }
    }else if (indexPath.section == 3){
        cell.textLabel.text =arr2[indexPath.row];

        if (indexPath.row ==0) {
            cell.detailTextLabel.text = self.model.taxiType;
            
        }else if (indexPath.row ==1) {
            cell.detailTextLabel.text = self.model.padNumber;
            
        }else if (indexPath.row ==2){
            cell.detailTextLabel.text = self.model.simNumber;
            
        }
    }
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
