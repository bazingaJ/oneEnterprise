//
//  JDTaxiController.m
//  E+TAXI_company
//
//  Created by jeaderq on 16/6/26.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import "JDTaxiController.h"
#import "JDWeiZhangController.h"
#import "JDTAXICell.h"
@interface JDTaxiController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    int page ;
    
}
@property (weak, nonatomic) IBOutlet UIView *seachView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic)  BOOL isloading;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (weak, nonatomic) IBOutlet UITextField *seachField;

@end

@implementation JDTaxiController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.seachView.layer.borderColor = RGBColor(220, 221, 222).CGColor;
    [_seachField addTarget:self  action:@selector(valueChanged:)  forControlEvents:UIControlEventAllEditingEvents];

    [self setpopItem];
    if (self.textFild.length) {
        self.seachField.text = self.textFild;
        JDData *data = [JDData new];
        [data getSeachWithSeachType:@"1" serchContent:self.textFild WithCompletion:^(NSString *returnCode, id res) {
            JDLog(@"chuzuche >>%@",res);
            NSArray *arr = res[@"taxiResult"];
            self.dataArr = [JDModel mj_objectArrayWithKeyValuesArray:arr];
            [self.tableView reloadData];
        }];
    }else{
    [self lodeMoreWithPage];
    }
    // Do any additional setup after loading the view from its nib.
}
-(void)setpopItem{
    self.navigationItem.titleView = [JDTools setTitleViewWithTitle:@"出租车"];
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
-(void)valueChanged:(UITextField *)fild{
    JDLog(@"全局搜索》》》》%@",fild.text);
    if (self.isloading ==NO) {
        [JDTools addMBProgressWithView:self.view style:0];
        [JDTools showMBWithTitle:@""];
        self.isloading = YES;
        [self getDataWithString:fild.text];
    }
    
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容付
    JDLog(@"全局搜索》》》》%@",toBeString);
//    if (self.isloading ==NO) {
//        [JDTools addMBProgressWithView:self.view style:0];
//        [JDTools showMBWithTitle:@""];
//        self.isloading = YES;
//        [self getDataWithString:toBeString];
//    }
    return YES;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}
-(void)getDataWithString:(NSString *)seachString{
     JDData *data = [JDData new];
    [data getSeachWithSeachType:@"1" serchContent:seachString WithCompletion:^(NSString *returnCode, id res) {
        JDLog(@"res>>>>>>>>%@",res);
        if ([returnCode intValue]==0) {
            NSArray * dataArr = res[@"taxiResult"];
            self.dataArr = [JDModel mj_objectArrayWithKeyValuesArray:dataArr];
            
            //            [JDTools hiddenMBWithDelayTimeInterval:0];
            [self.tableView reloadData];
            [JDTools hiddenMBWithDelayTimeInterval:0];
            self.isloading = NO;
        }else{
            page = 0;
            self.isloading = NO;
            [self lodeMoreWithPage];
        }
    }];
    
}
-(void)lodeMoreWithPage{
    if (self.isloading == YES) {
        return;
    }else{
    JDData *data = [JDData new];
    [data getTaxiDetailWithId:self.companyId startIndex:[NSString stringWithFormat:@"%d",page*20] Limit:@"20" WithCompletion:^(NSString *returnCode, id res) {
        JDLog(@"%s res=====%@",__func__,res);
        NSArray *arr  = res[@"array"];
        NSMutableArray *dataA = [NSMutableArray array];
        dataA= [JDModel mj_objectArrayWithKeyValuesArray:arr];
        [self.dataArr addObjectsFromArray:dataA];
        [self.tableView reloadData];
        JDLog(@"数组长度%lu",(unsigned long)self.dataArr.count);
        page++;
        [JDTools hiddenMBWithDelayTimeInterval:0];
        self.isloading = NO;
    }];
    }
}
-(NSMutableArray *)dataArr
{
    if (_dataArr ==nil) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
#pragma mark - table view dataSource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 233;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"MTCell";
    JDModel *mode  = self.dataArr[indexPath.row];
    JDTAXICell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"JDTAXICell" owner:nil options:nil][0];
    }
    cell.model =mode;
    cell.weizhangBtn.tag = indexPath.row;
    [cell.weizhangBtn addTarget:self action:@selector(goWeiZhang:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.selectionStyle =UITableViewCellSelectionStyleNone;

    return cell;
}
-(void)goWeiZhang:(UIButton *)sender{
    JDLog(@"点了.........");
        JDWeiZhangController *WZ = [[JDWeiZhangController alloc]init];
        WZ.model = self.dataArr[sender.tag];
        [self.navigationController pushViewController:WZ animated:YES];
}
#pragma mark - table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.seachField.text.length==0)
    {
    // 如果 tableView还没有数据，就直接返回
    CGFloat offsetY = scrollView.contentOffset.y;
    // 当最后一个cell完全显示在眼前时，contentOffset的y值
    CGFloat judeOffset= scrollView.contentSize.height +scrollView.contentInset.bottom -scrollView.height - self.tableView.tableFooterView.height;
    if (offsetY >= judeOffset) {
        self.tableView.tableFooterView.hidden = NO;
        //参数需要的页码 每次加1 获取下一页的内容
        [self lodeMoreWithPage];
         self.isloading = YES;
    }
    }
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
