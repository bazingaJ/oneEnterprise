//
//  JDDrivingRecordController.m
//  E+TAXI_company
//
//  Created by jeaderq on 16/6/27.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import "JDDrivingRecordController.h"
#import "JDAccessVideoController.h"
#import "CuiPickerView.h"

@interface JDDrivingRecordController ()<UITextFieldDelegate,CuiPickViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *startTextFiled;
@property (weak, nonatomic) IBOutlet UITextField *endTextFiled;
@property (weak, nonatomic) IBOutlet UITextField *taxiNumberFiled;
@property (nonatomic, strong) CuiPickerView *cuiPickerView;
@property (nonatomic, strong) CuiPickerView *cuiPickerView1;
@property (nonatomic, strong) NSString *dataString;
@property (nonatomic, strong) NSMutableArray *dataArr;
@end

@implementation JDDrivingRecordController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setpopItem];
    _cuiPickerView = [[CuiPickerView alloc]init];
    _cuiPickerView.frame = CGRectMake(0, JDScreenH, JDScreenW, 200);
    
    //这一步很重要
    _cuiPickerView.myTextField = _startTextFiled;
    
    _cuiPickerView.delegate = self;
    _cuiPickerView.curDate=[NSDate date];
    [self.view addSubview:_cuiPickerView];
    _cuiPickerView1 = [[CuiPickerView alloc]init];
    _cuiPickerView1.frame = CGRectMake(0, JDScreenH, JDScreenW, 200);
    
    //这一步很重要
    _cuiPickerView1.myTextField = _endTextFiled;
    
    _cuiPickerView1.delegate = self;
    _cuiPickerView1.curDate=[NSDate date];
    [self.view addSubview:_cuiPickerView1];
    // Do any additional setup after loading the view from its nib.
}


-(void)setpopItem{
    self.navigationItem.titleView = [JDTools setTitleViewWithTitle:@"行车记录"];
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
//开始编辑
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    textField.inputView = [[UIView alloc]initWithFrame:CGRectZero];
    [_cuiPickerView showInView:self.view];
}

//赋值给textField
-(void)didFinishPickView:(NSString *)date
{
    if (date.length == 0) {
        NSDate *currentDate = [NSDate date];//获取当前时间，日期
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm"];
        NSString *dateString = [dateFormatter stringFromDate:currentDate];
        NSLog(@"dateString:%@",dateString);
        if (self.startTextFiled.editing == YES) {

            _startTextFiled.text = dateString;
            [self theTimecpmpare:self.startTextFiled];

        }else{
            _endTextFiled.text = dateString;
            [self theTimecpmpare:self.endTextFiled];

        }
    }else{
        
        self.dataString = date;
        
        if (self.startTextFiled.editing == YES) {
            
            _startTextFiled.text = date;
            [self theTimecpmpare:self.startTextFiled];
        }else{
            
            _endTextFiled.text = date;
            [self theTimecpmpare:self.endTextFiled];

        }
    }
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
    [_cuiPickerView hiddenPickerView];

}

- (IBAction)currentTime:(UIButton *)sender {
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    NSLog(@"dateString:%@",dateString);
    _endTextFiled.text = dateString;
    [self theTimecpmpare:self.endTextFiled];
    [_cuiPickerView hiddenPickerView];

  }
-(void)theTimecpmpare:(UITextField *)textField{
    if (self.startTextFiled.text.length>0&&self.endTextFiled.text.length>0) {
   
    NSString *start = [self.startTextFiled.text stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSString *start1 =[start stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *start2 =[start1 stringByReplacingOccurrencesOfString:@":" withString:@""];
    NSString *ender = [self.endTextFiled.text stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSString *end1 =[ender stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *end2 =[end1 stringByReplacingOccurrencesOfString:@":" withString:@""];

    if ([start2 longLongValue]>[end2 longLongValue]) {
        JDLog(@"大了");
        [JDTools addAlertViewInView:self title:@"温馨提示" message:@"请输入正确的时间区间" count:0 doWhat:^{
            textField.text = @"";
        }];
    }else{
        JDLog(@"小了");

    }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)AccessVideoOrAudio:(UIButton *)sender {
    [JDTools addMBProgressWithView:self.view style:0];
    [JDTools showMBWithTitle:@"正在获取中..."];

    if (self.startTextFiled.text.length>0&&self.endTextFiled.text.length>0) {

        switch (sender.tag ) {
            case 21:
            {
                JDData *data = [JDData new];
                [data getDrivingRecordWithStartTime:self.startTextFiled.text endTime:self.endTextFiled.text taxiNumber:self.taxiNumberFiled.text fileType:@"2" type:@"0" filePath:nil WithCompletion:^(NSString *returnCode, id res) {
                    JDLog(@"shenme======%@",res);
                    if ([returnCode intValue] == 0) {
                        NSArray *arr = res[@"medioList"];
                        self.dataArr = [JDModel mj_objectArrayWithKeyValuesArray:arr];
                        [JDTools hiddenMBWithDelayTimeInterval:0];
                        JDAccessVideoController *VC = [[JDAccessVideoController alloc]init];
                        VC.dataArr = self.dataArr;
                        VC.isVideo = YES;
                        [self.navigationController pushViewController:VC animated:YES];
                        
                    }else{
                        [JDTools addAlertViewInView:self title:@"温馨提示" message:res count:0 doWhat:^{
                            [JDTools hiddenMBWithDelayTimeInterval:0];
                            
                        }];
                    }
                    
                }];

            }
                break;
            case 22:
            {
                JDData *data = [JDData new];
                [data getDrivingRecordWithStartTime:self.startTextFiled.text endTime:self.endTextFiled.text taxiNumber:self.taxiNumberFiled.text fileType:@"1" type:@"0" filePath:nil WithCompletion:^(NSString *returnCode, id res) {
                    JDLog(@"shenme======%@",res);
                    if ([returnCode intValue] == 0) {
                        NSArray *arr = res[@"medioList"];
                        self.dataArr = [JDModel mj_objectArrayWithKeyValuesArray:arr];
                        [JDTools hiddenMBWithDelayTimeInterval:0];
                        JDAccessVideoController *VC = [[JDAccessVideoController alloc]init];
                        VC.dataArr = self.dataArr;
                        VC.isVideo = NO;
                        [self.navigationController pushViewController:VC animated:YES];

                    }else if ([returnCode intValue] == 2){
                        [JDTools addAlertViewInView:self title:@"温馨提示" message:res count:0 doWhat:^{
                            [JDData publicDeleteInfo];
                            NSLog(@"顶掉了");
//                            JDLoginController *loginVc = [[JDLoginController alloc]init];
//                                UIViewController *root= [UIApplication sharedApplication].keyWindow.rootViewController;
//                                if ([root isKindOfClass:[JDLoginController class]]) {
//                                    return ;
//                                }
//                                UINavigationController*nav = [[UINavigationController alloc]initWithRootViewController:loginVc];
//                                [nav.navigationBar setBackgroundImage:[UIImage new]  forBarMetrics:UIBarMetricsDefault];
//                                [nav.navigationBar setShadowImage:[UIImage new]];
//                               root=nav;
                        }];

                    }else{
                        [JDTools addAlertViewInView:self title:@"温馨提示" message:res count:0 doWhat:^{
                            [JDTools hiddenMBWithDelayTimeInterval:0];

                        }];
                    }

                }];
               
            }
                break;
            default:
                break;
            }
    }else{
        [JDTools addAlertViewInView:self title:@"温馨提示" message:@"请输入正确的时间区间" count:0 doWhat:^{
            [JDTools hiddenMBWithDelayTimeInterval:0];

        }];
    }
}




@end
