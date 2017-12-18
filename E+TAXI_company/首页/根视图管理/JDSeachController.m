//
//  JDSeachController.m
//  E+TAXI_company
//
//  Created by jeaderq on 16/6/28.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import "JDSeachController.h"
#import "JDSeachCell.h"
#import "JDSeachModel.h"
#import "JDTaxiController.h"
#import "JDLostDetailVC.h"
#import "JDDriverController.h"
#import "JDLostFoundVC.h"
#import "JDWeiZhangController.h"
#import "JDDriverDetailsController.h"

@interface JDSeachController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *JDSeachView;
@property (weak, nonatomic) IBOutlet UITextField *JDSeachF;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *taxiResult;
@property (nonatomic, strong) NSArray *driverResult;
@property (nonatomic, strong) NSArray *lostResult;
@property (nonatomic, strong) NSArray *trafficResult;
@property (nonatomic, assign) int taxiCount;
@property (nonatomic, assign) int driverCount;
@property (nonatomic, assign) int lostCount;
@property (nonatomic, assign) int trafficCount;
@property (nonatomic, assign) BOOL isLoading;
@end

@implementation JDSeachController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setpopItem];
    self.JDSeachView.layer.borderColor = RGBColor(220, 221, 222).CGColor;
    [self.JDSeachF becomeFirstResponder];
    self.tableView.hidden = YES;
    [_JDSeachF addTarget:self  action:@selector(valueChanged:)  forControlEvents:UIControlEventAllEditingEvents];

    // Do any additional setup after loading the view from its nib.
}
-(void)setpopItem{
    self.navigationItem.titleView = [JDTools setTitleViewWithTitle:@"搜索"];
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

#pragma mark - table view dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    if (self.taxiCount > 0||self.driverCount>0||self.lostCount>0||self.trafficCount>0) {
//        return 4;
//    }else{
        return 1;
//    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.taxiCount > 0||self.driverCount>0||self.lostCount>0||self.trafficCount>0) {
            return 4;
        }else{
    return 0;
        }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row ==0) {
        if (self.taxiCount==0) {
            return 39;
        }else{
            return 183;
        }
    }else if (indexPath.row ==1){
        if (self.driverCount==0) {
            return 39;
        }else{
            return 183;
        }
    }else if (indexPath.row ==2){
        if (self.lostCount==0) {
            return 39;
        }else{
            return 183;
        }
    }else if (indexPath.row ==3){
        if (self.trafficCount==0) {
            return 39;
        }else{
            return 183;
        }
    }
    return 0;
}

-(NSMutableAttributedString *)stringByAttributedString:(NSString *)inteStr seachString:(NSString *)numStr{
      NSMutableAttributedString *inteMutStr = [[NSMutableAttributedString alloc] initWithString:inteStr];
        NSRange orangeRange = NSMakeRange([[inteMutStr string] rangeOfString:numStr].location, [[inteMutStr string] rangeOfString:numStr].length);
    [inteMutStr addAttribute:NSForegroundColorAttributeName value:RGBColor(75, 187, 245) range:orangeRange];
    return inteMutStr;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JDSeachCell *cell = nil;
    
        if (indexPath.row==0) {
            if (self.taxiResult.count==0) {
                    cell = [[NSBundle mainBundle]loadNibNamed:@"JDSeachCell" owner:nil options:nil][2];
                }else{

                cell = [[NSBundle mainBundle]loadNibNamed:@"JDSeachCell" owner:nil options:nil][0];
                JDSeachModel *seach = self.taxiResult[0];
               
                cell.count1.text = [NSString stringWithFormat:@"%d",self.taxiCount];
                    
                [cell.chePaiL setAttributedText:[self stringByAttributedString:[NSString stringWithFormat:@"车牌号: %@",seach.taxiNumber] seachString:self.JDSeachF.text]];
//                cell.chePaiL.text = [NSString stringWithFormat:@"车牌号:%@",seach.taxiNumber];
                    [cell.carTypeL setAttributedText:[self stringByAttributedString:[NSString stringWithFormat:@"车型号: %@",seach.taxiModel] seachString:self.JDSeachF.text]];
//                cell.carTypeL.text =[NSString stringWithFormat:@"车型号:%@",seach.taxiModel];
                    [cell.phoneNOL setAttributedText:[self stringByAttributedString:[NSString stringWithFormat:@"公    司: %@",seach.taxiCompany] seachString:self.JDSeachF.text]];
//                cell.phoneNOL.text = [NSString stringWithFormat:@"手机号:%@",seach.phoneNumber];
                cell.type.text = @"出租车";
                    cell.loadMore1.tag = 110;
                [cell.loadMore1 addTarget:self action:@selector(loadMore:) forControlEvents:UIControlEventTouchUpInside];
                
            }

        }else if (indexPath.row == 1){
            
            if (self.driverResult.count==0) {
                cell = [[NSBundle mainBundle]loadNibNamed:@"JDSeachCell" owner:nil options:nil][2];
                cell.cell3Type.text = [NSString stringWithFormat:@"驾驶员"];
                }else{
                cell = [[NSBundle mainBundle]loadNibNamed:@"JDSeachCell" owner:nil options:nil][1];
                                JDSeachModel *seach = self.driverResult[0];
                [cell.iconImg sd_setImageWithURL:[NSURL URLWithString:seach.driverHead] placeholderImage:[UIImage imageNamed:@"photo_moren_jsy"]];
                cell.count2.text = [NSString stringWithFormat:@"%d",self.driverCount];
//                cell.nameL.text = [NSString stringWithFormat:@"姓    名:%@",seach.driverName];
                [cell.nameL setAttributedText:[self stringByAttributedString:[NSString stringWithFormat:@"姓    名: %@",seach.driverName] seachString:self.JDSeachF.text]];
                [cell.carTypeL2 setAttributedText:[self stringByAttributedString:[NSString stringWithFormat:@"车牌号: %@",seach.taxiNumber] seachString:self.JDSeachF.text]];
                [cell.phoneNoL setAttributedText:[self stringByAttributedString:[NSString stringWithFormat:@"手机号: %@",seach.phoneNumber] seachString:self.JDSeachF.text]];
//                cell.carTypeL2.text = [NSString stringWithFormat:@"车牌号:%@",seach.taxiNumber];
//                cell.phoneNoL.text = [NSString stringWithFormat:@"手机号:%@",seach.phoneNumber];
                cell.type2.text = @"驾驶员";
                cell.loadMore2.tag = 111;
                [cell.loadMore2 addTarget:self action:@selector(loadMore:) forControlEvents:UIControlEventTouchUpInside];
                }
            
        }else if (indexPath.row == 2){
            if (self.lostResult.count==0) {
                cell = [[NSBundle mainBundle]loadNibNamed:@"JDSeachCell" owner:nil options:nil][2];
                cell.cell3Type.text = [NSString stringWithFormat:@"失物申报"];
            }else{
                cell = [[NSBundle mainBundle]loadNibNamed:@"JDSeachCell" owner:nil options:nil][1];
                JDSeachModel *seach = self.lostResult[0];
                [cell.iconImg sd_setImageWithURL:[NSURL URLWithString:seach.lostImg] placeholderImage:[UIImage imageNamed:@"photo_moren_sb"]];
                cell.count2.text = [NSString stringWithFormat:@"%d",self.lostCount];
                
                [cell.nameL setAttributedText:[self stringByAttributedString:[NSString stringWithFormat:@"类    型: %@",seach.lostType] seachString:self.JDSeachF.text]];
                [cell.carTypeL2 setAttributedText:[self stringByAttributedString:[NSString stringWithFormat:@"车牌号: %@",seach.taxiNumber] seachString:self.JDSeachF.text]];
                [cell.phoneNoL setAttributedText:[self stringByAttributedString:[NSString stringWithFormat:@"时    间: %@",seach.lostTime] seachString:self.JDSeachF.text]];

                
//                cell.nameL.text = [NSString stringWithFormat:@"类    型:%@",seach.lostType];
//                cell.carTypeL2.text = [NSString stringWithFormat:@"车牌号:%@",seach.taxiNumber];
//                cell.phoneNoL.text = [NSString stringWithFormat:@"时    间:%@",seach.lostTime];
                cell.type2.text = @"失物申报";
                cell.loadMore2.tag = 112;
                [cell.loadMore2 addTarget:self action:@selector(loadMore:) forControlEvents:UIControlEventTouchUpInside];
            
            }
    
            
        }else if (indexPath.row == 3){
            if (self.trafficResult.count==0) {
                cell = [[NSBundle mainBundle]loadNibNamed:@"JDSeachCell" owner:nil options:nil][2];
                cell.cell3Type.text = [NSString stringWithFormat:@"路况申报"];
            }else{
                cell = [[NSBundle mainBundle]loadNibNamed:@"JDSeachCell" owner:nil options:nil][1];
                JDSeachModel *seach = self.trafficResult[0];
                [cell.iconImg sd_setImageWithURL:[NSURL URLWithString:seach.trafficImg] placeholderImage:[UIImage imageNamed:@"photo_moren_sb"]];
                cell.count2.text = [NSString stringWithFormat:@"%d",self.trafficCount];
                [cell.nameL setAttributedText:[self stringByAttributedString:[NSString stringWithFormat:@"类    型: %@",seach.trafficType] seachString:self.JDSeachF.text]];
                [cell.carTypeL2 setAttributedText:[self stringByAttributedString:[NSString stringWithFormat:@"地    点: %@",seach.traffiAddress] seachString:self.JDSeachF.text]];
                [cell.phoneNoL setAttributedText:[self stringByAttributedString:[NSString stringWithFormat:@"时    间: %@",seach.trafficTime] seachString:self.JDSeachF.text]];
                
//                cell.nameL.text = [NSString stringWithFormat:@"类    型:%@",seach.trafficType];
//                cell.carTypeL2.text = [NSString stringWithFormat:@"地    点:%@",seach.traffiAddress];
//                cell.phoneNoL.text = [NSString stringWithFormat:@"时    间:%@",seach.trafficTime];
                cell.type2.text = @"路况申报";
                cell.loadMore2.tag = 113;
                [cell.loadMore2 addTarget:self action:@selector(loadMore:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}
-(void)loadMore:(UIButton *)sender{
    switch (sender.tag) {
        case 110:
        {
            JDTaxiController *taxi = [[JDTaxiController alloc]init];
            taxi.textFild = self.JDSeachF.text;
            [self.navigationController pushViewController:taxi animated:YES];
        }
            break;
        case 111:
        {
            JDDriverController *driver = [[JDDriverController alloc]init];
            driver.textFild = self.JDSeachF.text;
            [self.navigationController pushViewController:driver animated:YES];
        }
            break;
        case 112:
        {
            JDLostFoundVC *lostFound = [[JDLostFoundVC alloc]init];
            lostFound.text = self.JDSeachF.text;
            lostFound.isLost = YES;
            [self.navigationController pushViewController:lostFound animated:YES];
        }
            break;
        case 113:
        {
            JDLostFoundVC *lostFound = [[JDLostFoundVC alloc]init];
            lostFound.text = self.JDSeachF.text;
            lostFound.isLost = NO;
            [self.navigationController pushViewController:lostFound animated:YES];
        }
            break;

        default:
            break;
    }
}

#pragma mark - table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==0) {
        if (self.taxiResult.count>0) {
            JDWeiZhangController *weiZhang  = [[JDWeiZhangController alloc] init];
            weiZhang.model = self.taxiResult[0];
            [self.navigationController pushViewController:weiZhang animated:YES];
        }
    }else if (indexPath.row == 1){
        if (self.driverResult.count>0) {
            JDSeachModel *mode = self.driverResult[0];

            JDDriverDetailsController *driver = [[JDDriverDetailsController alloc]init];
            driver.driverId = mode.driverId;
            [self.navigationController pushViewController:driver animated:YES];
        }
    }else if (indexPath.row == 2){
        if (self.lostResult.count > 0) {
            JDSeachModel *mode = self.lostResult[0];

            JDLostDetailVC *lostDetail = [[JDLostDetailVC alloc]init];
            lostDetail.lostIdentifier = mode.lostId;
            lostDetail.isLost = YES;
            [self.navigationController pushViewController:lostDetail animated:YES];
        }
    }else if (indexPath.row == 3){
        if (self.trafficResult.count > 0) {
            JDSeachModel *mode = self.trafficResult[0];
            JDLostDetailVC *lostDetail = [[JDLostDetailVC alloc]init];
            lostDetail.roadIdentifier = mode.trafficId;
            lostDetail.isLost = NO;
            [self.navigationController pushViewController:lostDetail animated:YES];
        }

    }
}
-(void)valueChanged:(UITextField *)fild{
    JDLog(@"全局搜索》》》》%@",fild.text);
    if (self.isLoading ==NO) {
        [JDTools addMBProgressWithView:self.view style:0];
        [JDTools showMBWithTitle:@""];
        self.isLoading = YES;
        [self getDataWithString:fild.text];
    }
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
        NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容付
    JDLog(@"全局搜索》》》》%@",toBeString);
//    [JDTools addMBProgressWithView:self.view style:0];
//    [JDTools showMBWithTitle:@""];
//    [self getDataWithString:toBeString];
    return YES;
}

-(void)getDataWithString:(NSString *)seachString{
    JDData *data = [JDData new];
    [data getSeachWithSeachType:@"" serchContent:seachString WithCompletion:^(NSString *returnCode, id res) {
        JDLog(@"搜索>>> %@",res);
        JDModel *mode = [JDModel mj_objectWithKeyValues:res];
        JDLog(@"model==driverResult>> %@  lostResult=%@  trafficResult=%@  taxiResult=%@  ",mode.driverResult,mode.lostResult,mode.trafficResult,mode.taxiResult);
        
        if (mode.lostCount>0) {
            self.lostCount = mode.lostCount;
            self.lostResult = mode.lostResult;
        }else{
            self.lostCount = 0;
            self.lostResult =[NSArray array];
        }
        if (mode.taxiCount>0) {
            self.taxiCount = mode.taxiCount;
            self.taxiResult = mode.taxiResult;
        }else{
            self.taxiCount = 0;
            self.taxiResult =[NSArray array];

        }
        if (mode.driverCount>0) {
            self.driverCount = mode.driverCount;
            self.driverResult = mode.driverResult;
        }else{
            self.driverCount = 0;
            self.driverResult =[NSArray array];

        }
        if (mode.trafficCount>0) {
            self.trafficCount = mode.trafficCount;
            self.trafficResult = mode.trafficResult;
        }else{
            self.trafficCount = 0;
            self.trafficResult =[NSArray array];

        }
        if (self.taxiCount == 0&&self.driverCount ==0&&self.lostCount==0&&self.trafficCount==0) {
            self.tableView.hidden = YES;
        }else{
            self.tableView.hidden = NO;
        }
        JDLog(@"失物招领%d出租车>>%d司机>>%d路况>>%d",mode.lostCount,mode.taxiCount,mode.driverCount,mode.trafficCount);
        [self.tableView reloadData];
        [JDTools hiddenMBWithDelayTimeInterval:0];
        self.isLoading = NO;
    }];

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
