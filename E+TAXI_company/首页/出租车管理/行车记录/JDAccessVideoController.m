//
//  JDAccessVideoController.m
//  E+TAXI_company
//
//  Created by jeaderq on 16/6/27.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import "JDAccessVideoController.h"
#import "JDAccessCell.h"
#import "MoviePlayerViewController.h"

@interface JDAccessVideoController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation JDAccessVideoController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setpopItem];
    // Do any additional setup after loading the view from its nib.
}

-(void)setpopItem
{
    if (self.isVideo == YES) {
        self.navigationItem.titleView = [JDTools setTitleViewWithTitle:@"视频"];

    }else{
        self.navigationItem.titleView = [JDTools setTitleViewWithTitle:@"音频"];

    }
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - table view dataSource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 56;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"MTCell";
    
    JDAccessCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    JDModel *model = self.dataArr[indexPath.row];
    if(cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"JDAccessCell" owner:nil options:nil][0];
    }
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    cell.timeL.text =model.time;
    
    return cell;
}

#pragma mark - table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [JDTools addMBProgressWithView:self.view style:0];
    [JDTools showMBWithTitle:@"加载中..."];
    JDModel *model = self.dataArr[indexPath.row];
    NSString *fileType;
    if (self.isVideo == YES) {
        fileType =@"2";
    }else{
       fileType =@"1";
    }
    JDData *data = [JDData new];
    [data getDrivingRecordWithStartTime:nil endTime:nil taxiNumber:model.taxiNumber fileType:fileType type:@"1" filePath:model.medioHost WithCompletion:^(NSString *returnCode, id res) {
        JDLog(@"结果是什么呢%@，错了吗%@",model.medioHost,res);
        if ([returnCode intValue] == 0) {
            [JDTools hiddenMBWithDelayTimeInterval:0];
            MoviePlayerViewController *movie = [[MoviePlayerViewController alloc]init];
            movie.url = model.medioHost;
                [self presentViewController:movie animated:YES completion:^{
            
                
                }];

            
        }else{
        [JDTools hiddenMBWithDelayTimeInterval:0];
        [JDTools addAlertViewInView:self title:@"温馨提示" message:res count:0 doWhat:^{
            
        }];
        }
    }];
//    MoviePlayerViewController *movie = [[MoviePlayerViewController alloc]init];
//    [self presentViewController:movie animated:YES completion:^{
//        
//    
//    }];

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
