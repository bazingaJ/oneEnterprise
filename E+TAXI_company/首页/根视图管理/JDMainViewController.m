//
//  JDMainViewController.m
//  E+TAXI_company
//
//  Created by jeaderq on 16/6/24.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import "JDMainViewController.h"
#import "JDBrandController.h"
#import "JDEnterpriseController.h"
#import "JDTaxiController.h"
#import "JDDriverController.h"
#import "JDLostFoundVC.h"
#import "JDNoticeVC.h"
#import "JDDrivingRecordController.h"
#import "JDLineVC.h"
#import "JDSeachController.h"
#import "JDLoginController.h"
#import "JDSetUpController.h"
#import "JDEnterpriseChooseController.h"

@interface JDMainViewController ()
@property (weak, nonatomic) IBOutlet UIView *seachBtn;

@end

@implementation JDMainViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)viewDidLoad {

 
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    self.navigationItem.titleView = [self setTitleView];
    self.navigationItem.rightBarButtonItem = [self setRightItem];


    self.seachBtn.layer.borderColor = RGBColor(220, 221, 222).CGColor;
    // Do any additional setup after loading the view from its nib.
    [self setSubViews];
}

//设置子控件
-(void)setSubViews{
    
    NSArray *imgArr = @[@"btn_cppxh",@"btn_czcqy",@"btn_czc",@"btn_jsy",@"btn_xcgj",@"btn_xcjl",@"btn_swsb",@"btn_lksb",@"btn_lstz"];
    NSArray *titleArr = @[@"车品牌型号",@"出租车企业",@"出租车",@"驾驶员",@"行车轨迹",@"行车记录",@"失物申报",@"路况申报",@"历史通知"];

    for (int i = 0; i<9; i++) {
        [self setMenuBtnWithInt:i imgArr:imgArr titleArr:titleArr];
    }
    
}
-(void)setMenuBtnWithInt:(int)i imgArr:(NSArray *)imgArr titleArr:(NSArray *)titleArr{
    CGFloat meunBtnWH = JDScreenW/3;
    CGFloat meunBtnX = meunBtnWH *(i%3);
   
    CGFloat meunBtnY = (CGRectGetMaxY(self.seachBtn.frame)+7)+meunBtnWH*(i/3);
    if (i>2) {
        meunBtnY =(CGRectGetMaxY(self.seachBtn.frame)+7)+meunBtnWH*(i/3)+10;
    }
    if (i>5) {
        meunBtnY =(CGRectGetMaxY(self.seachBtn.frame)+7)+meunBtnWH*(i/3)+10+10;

    }
    UIView *menuView = [[UIView alloc]init];
    menuView.frame = CGRectMake(meunBtnX, meunBtnY, meunBtnWH, meunBtnWH);
    menuView.layer.borderWidth = 0.5;
    menuView.layer.borderColor = RGBColor(217, 217, 217).CGColor;
    menuView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:menuView];


    UIImageView *centerImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imgArr[i]]];
    centerImg.userInteractionEnabled = YES;
    centerImg.centerX = menuView.width/2;
    centerImg.y = HEIGHT(29.0, 667);
    [menuView addSubview:centerImg];
    UILabel *menuTitle = [[UILabel alloc]init];
    CGSize menuTitleSize = [JDTools sizeWithText:titleArr[i] font:[UIFont systemFontOfSize:14]];
    menuTitle.userInteractionEnabled= YES;
    menuTitle.text = titleArr[i];
    menuTitle.textColor = RGBColor(51, 51, 51);
    menuTitle.font = [UIFont systemFontOfSize:14];
    menuTitle.size = menuTitleSize;
    menuTitle.centerX = menuView.width/2;
    menuTitle.y = CGRectGetMaxY(centerImg.frame)+HEIGHT(10.0, 667);
    [menuView addSubview:menuTitle];
    
    UIButton *menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [menuBtn setFrame:CGRectMake(0, 0, menuView.width, menuView.height)];
    [menuView addSubview:menuBtn];
    menuBtn.tag = i+10;
    [menuBtn addTarget:self action:@selector(menuBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}
//首页菜单点击事件
-(void)menuBtnClick:(UIButton *)sender{
    switch (sender.tag) {
        case 10:
        {
            JDBrandController * vc =[[JDBrandController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 11:
        {
            //出租车企业
            JDEnterpriseController *Enterprise = [[JDEnterpriseController alloc]init];
            [self.navigationController pushViewController:Enterprise animated:YES];
        }
            break;
        case 12:
        { //出租车
            
            if ([PERMISSION intValue]==3) {
                JDEnterpriseChooseController *EnterpriseChoose = [[JDEnterpriseChooseController alloc]init];
                 EnterpriseChoose.isTaxi = YES;
                [self.navigationController pushViewController:EnterpriseChoose animated:YES];
            }else{
            
                JDTaxiController *TAXI = [[JDTaxiController alloc]init];
                [self.navigationController pushViewController:TAXI animated:YES];
            }
        }
            break;
        case 13:
        {
            if ([PERMISSION intValue]==3) {
                JDEnterpriseChooseController *EnterpriseChoose = [[JDEnterpriseChooseController alloc]init];
                EnterpriseChoose.isTaxi = NO;
                [self.navigationController pushViewController:EnterpriseChoose animated:YES];
            }else{
                //驾驶员
                
                JDDriverController *driver = [[JDDriverController alloc]init];
                
                [self.navigationController pushViewController:driver animated:YES];
            
            }
        }
            break;
        case 14:
        {
            JDLineVC * vc=[[JDLineVC alloc] init];
            vc.title=@"行车轨迹";
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 15:
        {
            //驾驶员
            JDDrivingRecordController *driver = [[JDDrivingRecordController alloc]init];
            [self.navigationController pushViewController:driver animated:YES];
        }
            break;
        case 16:
        {
            JDLostFoundVC * vc =[[JDLostFoundVC alloc] init];
            vc.isLost=YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 17:
        {
            JDLostFoundVC * vc =[[JDLostFoundVC alloc] init];
            vc.isLost=NO;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 18:
        {
            JDNoticeVC * vc =[[JDNoticeVC alloc] init];
            vc.title=@"历史通知";
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        default:
            break;
    }
    
    
    
}

//跳转搜索页面
- (IBAction)pushSeach:(UIButton *)sender {

    //驾驶员
    JDSeachController *seach = [[JDSeachController alloc]init];
    [self.navigationController pushViewController:seach animated:YES];

}

//导航标题
-(UIView *)setTitleView{
    UILabel *titleV = [[UILabel alloc]init];
    titleV.text = @"E+TAXI企业端";
    CGSize titleSize =  [JDTools sizeWithText:@"E+TAXI企业端" font:[UIFont systemFontOfSize:19]];
    titleV.size = titleSize;
    titleV.font = [UIFont systemFontOfSize:19];
    titleV.textColor = RGBColor(255, 255, 255);
    return titleV;
}
//注销按钮
-(UIBarButtonItem *)setRightItem
{
    UIButton *custumItem =[UIButton buttonWithType:UIButtonTypeCustom];
    custumItem.frame = CGRectMake(0,0, 24, 24);
    [custumItem setBackgroundImage:[UIImage imageNamed:@"setting"] forState:UIControlStateNormal];
    [custumItem setTitleColor:RGBColor(51, 51, 51) forState:UIControlStateNormal];
    custumItem.titleLabel.font = [UIFont systemFontOfSize:16];
//    custumItem.size = [JDTools sizeWithText:@"注销" font:[UIFont systemFontOfSize:16]];
    [custumItem addTarget:self action:@selector(cancellation:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * backTopItem = [[UIBarButtonItem alloc]initWithCustomView:custumItem];
    return backTopItem;
}
//点击设置      
-(void)cancellation:(UIButton *)btn{
    JDSetUpController *setUp = [[JDSetUpController alloc]init];
    [self.navigationController pushViewController:setUp animated:YES];
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
