//
//  JDLineVC.m
//  E+TAXI_company
//
//  Created by jeader on 16/6/28.
//  Copyright © 2016年 yangjx. All rights reserved.
//


#import "JDLineVC.h"
#import "CuiPickerView.h"

@interface JDLineVC ()<MAMapViewDelegate,UITextFieldDelegate,CuiPickViewDelegate>
{
    BOOL isPushed;
    BOOL isPlayback;
    dispatch_source_t GCDTime;
    
    CLLocationCoordinate2D * _runningCoords;
    NSUInteger _count;
    MAMultiPolyline * _polyline;
}
@property (nonatomic, strong) NSMutableArray * locationArr;
@property (nonatomic, strong) CuiPickerView *cuiPickerView;
@property (nonatomic, strong) CuiPickerView *cuiPickerView1;
@property (nonatomic, strong) NSString *dataStr;
@end

@implementation JDLineVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor yellowColor];
    [_mapView setZoomLevel:16.1 animated:YES];
    //MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    
    [self mapAndTabelView];
    [self setpopItem];
    [self prepareForPickerView];
    [self.view insertSubview:self.whiteVi aboveSubview:_mapView];
    [self.view insertSubview:self.littleVi aboveSubview:_mapView];
    [self.view insertSubview:self.containBtn aboveSubview:_mapView];
    self.nowTextF.returnKeyType=UIReturnKeyDefault;
    
    self.nowTextF.delegate=self;
    self.plateNoTF.delegate=self;
    self.beginTF.delegate=self;
    self.overTF.delegate=self;
}

//- (void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//    [_mapView addOverlay:_polyline];
//    
//    const CGFloat screenEdgeInset = 20;
//    UIEdgeInsets inset = UIEdgeInsetsMake(screenEdgeInset, screenEdgeInset, screenEdgeInset, screenEdgeInset);
//    [_mapView setVisibleMapRect:_polyline.boundingMapRect edgePadding:inset animated:NO];
//}
- (void)dealloc
{
    if (_runningCoords) {
        free(_runningCoords);
        _count = 0;
    }
}
-(void)setpopItem
{
    //标题按钮
    UIButton *titleBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [titleBtn setTitle:@"行车轨迹" forState:UIControlStateNormal];
    [titleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    titleBtn.frame = CGRectMake(0,0,70, 24);
    [titleBtn addTarget:self action:@selector(whiteViewAnimation) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView * btnDown =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_down"]];
    btnDown.bounds=CGRectMake(0, 0, 8, 4);
    btnDown.center=CGPointMake(titleBtn.center.x, titleBtn.center.y+15);
    [titleBtn addSubview:btnDown];
    
    self.navigationItem.titleView=titleBtn;
    isPushed=NO;
    isPlayback=NO;
    
    //左侧按钮
    UIButton *custumItem =[UIButton buttonWithType:UIButtonTypeCustom];
    [custumItem setBackgroundImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    custumItem.frame = CGRectMake(0,0,24, 24);
    [custumItem addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * backTopItem = [[UIBarButtonItem alloc]initWithCustomView:custumItem];
    self.navigationItem.leftBarButtonItem = backTopItem;
    //右侧按钮
    UIButton * rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame=CGRectMake(0, 0, 40, 30);
    [rightBtn setTitle:@"回放" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(playback:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem =[[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem=rightItem;
    
    self.locationArr =[NSMutableArray array];
}

- (void)prepareForPickerView
{
    _cuiPickerView = [[CuiPickerView alloc]init];
    _cuiPickerView.frame = CGRectMake(0, JDScreenH, JDScreenW, 200);
    _cuiPickerView.backgroundColor=[UIColor whiteColor];
    //这一步很重要
    _cuiPickerView.myTextField = self.beginTF;
    
    _cuiPickerView.delegate = self;
    _cuiPickerView.curDate=[NSDate date];
    [self.view addSubview:_cuiPickerView];
    
    _cuiPickerView1 = [[CuiPickerView alloc]init];
    _cuiPickerView1.frame = CGRectMake(0, JDScreenH, JDScreenW, 200);
    _cuiPickerView1.backgroundColor=[UIColor whiteColor];
    //这一步很重要
    _cuiPickerView1.myTextField = self.overTF;
    
    _cuiPickerView1.delegate = self;
    _cuiPickerView1.curDate=[NSDate date];
    [self.view addSubview:_cuiPickerView1];
}

-(void)pop
{
    [self.navigationController popViewControllerAnimated:YES];
    if (GCDTime)
    {
        dispatch_cancel(GCDTime);
        GCDTime=nil;
    }
    _mapView.showsUserLocation=NO;
}



//添加地图和tableView
-(void)mapAndTabelView
{
    //配置用户Key
    [AMapServices sharedServices].apiKey = @"e41bb08c669d2cdbe908821b8d43e4eb";
    
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
    _mapView.delegate = self;
    _mapView.showsScale=NO;
    _mapView.showsUserLocation=YES;
    _mapView.userTrackingMode = MAUserTrackingModeFollowWithHeading;
    _mapView.showsCompass=NO;
    [self.view addSubview:_mapView];
    
    
}


-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation
updatingLocation:(BOOL)updatingLocation
{
    if(updatingLocation)
    {
        //取出当前位置的坐标
        NSLog(@"latitude : %f,longitude: %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
        CLLocationCoordinate2D loc = [userLocation coordinate];
        //放大地图到自身的经纬度位置。
        
        MACoordinateRegion region = MACoordinateRegionMakeWithDistance(loc, 500, 500);
        [_mapView setRegion:region animated:YES];
        [_mapView setCenterCoordinate:loc animated:YES];
        
        
        
        
        
    }
}
//设置轮询
- (void)setPolling
{
    NSTimeInterval period = 5.0; //设置时间间隔
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    GCDTime = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(GCDTime, dispatch_walltime(NULL, 0), period * NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(GCDTime, ^{ //在这里执行事件
        
        [self requestRouteWithPlateNo:_nowTextF.text WithBegin:nil WithOver:nil];
    });
    
    dispatch_resume(GCDTime);
    
    
}

//实时定位返回的数据进行一个返回
- (void)setCurrentLocationWithDict:(NSDictionary *)dict
{
    _mapView.showsUserLocation=NO;
    CLLocationCoordinate2D loc = {[dict[@"latitude"] doubleValue], [dict[@"longitude"] doubleValue]};
    //放大地图到自身的经纬度位置。
    MACoordinateRegion region = MACoordinateRegionMakeWithDistance(loc, 500, 500);
    
    
    [_mapView setRegion:region animated:YES];
    [_mapView setCenterCoordinate:loc animated:YES];
    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
    pointAnnotation.coordinate = loc;
    [_mapView addAnnotation:pointAnnotation];
    
    
}
- (void)setPolyLineWithLineArray:(NSArray *)arr
{
    NSMutableArray * indexes = [NSMutableArray array];
    _count = arr.count;
    _runningCoords = (CLLocationCoordinate2D *)malloc(_count * sizeof(CLLocationCoordinate2D));
    for (int i = 0; i < _count; i++)
    {
        @autoreleasepool {
            NSDictionary * data = arr[i];
            _runningCoords[i].latitude = [data[@"latitude"] doubleValue];
            _runningCoords[i].longitude = [data[@"longitude"] doubleValue];
            
            [indexes addObject:@(i)];
        }
    }
    _polyline = [MAMultiPolyline polylineWithCoordinates:_runningCoords count:_count drawStyleIndexes:indexes];
    
}


#pragma mark -
#pragma mark - 发送请求
- (void)requestRouteWithPlateNo:(NSString *)plateNo WithBegin:(NSString *)beginTime WithOver:(NSString *)overTime
{
    NSDictionary * paramDic =[NSDictionary dictionary];
    if (isPlayback)
    {
        paramDic=@{@"userName":USERNAME,
                   @"loginTime":LOGINTIME,
                   @"taxiNumber":plateNo,
                   @"startTime":beginTime,
                   @"endTime":overTime,
                   @"type":@"1"};
    }
    else
    {
        paramDic=@{@"userName":USERNAME,
                   @"loginTime":LOGINTIME,
                   @"taxiNumber":plateNo,
                   @"type":@"0"};
    }
    
    AFHTTPSessionManager  * manager =[AFHTTPSessionManager manager];
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    NSString * str =[NSString stringWithFormat:@"%@/getRoute.json",JDUrl];
    [manager POST:str parameters:paramDic success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString * returnCode =responseObject[@"returnCode"];
        NSString * msg =responseObject[@"msg"];
        if ([returnCode intValue]==0)
        {
            [JDTools hiddenMBWithDelayTimeInterval:0];
            JDLog(@"the res is the %@",responseObject);
            
            
            if (isPlayback)
            {
            NSArray * routeArr =responseObject[@"taxiRoute"];
            [self setPolyLineWithLineArray:routeArr];
                
                
            }
            else
            {
                
                NSDictionary * locationDic =responseObject[@"taxiRoute"];
                [self setCurrentLocationWithDict:locationDic];
            }
            

        }
        else if ([returnCode intValue]==1)
        {
            [JDTools hiddenMBWithDelayTimeInterval:0];
//            [self setPolyLine];
            [JDTools addAlertViewInView:self title:@"" message:msg count:0 doWhat:nil];
        }
        else
        {
            [JDTools hiddenMBWithDelayTimeInterval:0];
            [JDTools addAlertViewInView:self title:@"" message:msg count:0 doWhat:nil];
        }
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        dispatch_cancel(GCDTime);
        NSString * str = [NSString stringWithFormat:@"%@",error];
        NSLog(@"%s%@",__func__,str);
        
    }];
    
}
- (IBAction)containBtnClick
{
    if (isPlayback)
    {
        if ([_plateNoTF.text isEqualToString:@""]||[_plateNoTF.text isEqualToString:@"苏A"])
        {
            [JDTools addAlertViewInView:self title:@"" message:@"请输入车牌号" count:0 doWhat:nil];
        }
        if ([_beginTF.text isEqualToString:@""]||[_overTF.text isEqualToString:@""])
        {
            [JDTools addAlertViewInView:self title:@"" message:@"请选择时间" count:0 doWhat:nil];
        }
        else
        {
            [self cancelWhiteViewAnimation];
            _mapView.showsUserLocation=NO;
            NSString * beginStr =[NSString stringWithFormat:@"%@:00",_beginTF.text];
            NSString * overStr =[NSString stringWithFormat:@"%@:00",_overTF.text];
            [JDTools addMBProgressWithView:self.view style:0];
            [JDTools showMBWithTitle:@"正在获取..."];
            [self requestRouteWithPlateNo:self.plateNoTF.text WithBegin:beginStr WithOver:overStr];
        }
    }
    else
    {
        if ([_nowTextF.text isEqualToString:@""]||[_nowTextF.text isEqualToString:@"苏A"])
        {
            [JDTools addAlertViewInView:self title:@"" message:@"请输入车牌号" count:0 doWhat:nil];
        }
        else
        {
            [self cancelLittleViAnimation];
            [self setPolling];
            [JDTools addMBProgressWithView:self.view style:0];
            [JDTools showMBWithTitle:@"正在获取..."];
            [self requestRouteWithPlateNo:self.nowTextF.text WithBegin:@"" WithOver:@""];
        }
    }
}


- (void)playback:(UIButton *)button
{
    if ([button.currentTitle isEqualToString:@"回放"])
    {
        [button setTitle:@"实时" forState:UIControlStateNormal];
        isPlayback=YES;
        isPushed=NO;
        [self cancelLittleViAnimation];
        [self whiteViewAnimation];
        
    }
    else
    {
        [button setTitle:@"回放" forState:UIControlStateNormal];
        isPlayback=NO;
        isPushed=NO;
        [self cancelWhiteViewAnimation];
        [self whiteViewAnimation];
    }
}
#pragma mark - 
#pragma mark - spring动画  弹性动画
/**
 *   Damping   阻尼系数,阻止弹簧伸缩的系数,阻尼系数越大,停止越快
 *   Velocity  速率,动画视图的初始速度大小速率为正数时,速度方向与运动方向一致,速率为负数时,速度方向与运动方向相反
 *   options 
 *   animation  执行的动画
 *   completion 成功之后的执行的动画
 */
- (void)whiteViewAnimation
{
    if (isPlayback)//-------回放
    {
        if (!isPushed)
        {
            [UIView animateWithDuration:.5 delay:0 usingSpringWithDamping:.5f initialSpringVelocity:10.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.whiteVi.transform=CGAffineTransformMakeTranslation(0, 152);
                self.containBtn.transform=CGAffineTransformMakeTranslation(0, -68);
                
            } completion:^(BOOL finished) {
                [self.plateNoTF becomeFirstResponder];
                isPushed=YES;
            }];
        }
        else
        {
            [self cancelWhiteViewAnimation];
        }
    }
    else//-------------实时
    {
        if (!isPushed)
        {
            [UIView animateWithDuration:.5 delay:0 usingSpringWithDamping:.5f initialSpringVelocity:10.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.littleVi.transform=CGAffineTransformMakeTranslation(0, 62);
                self.containBtn.transform=CGAffineTransformMakeTranslation(0, -68);
            } completion:^(BOOL finished) {
                [self.nowTextF becomeFirstResponder];
                isPushed=YES;
            }];
        }
        else
        {
            [self cancelLittleViAnimation];
        }
    }
}
- (void)cancelWhiteViewAnimation
{
    [UIView animateWithDuration:.5 delay:0 usingSpringWithDamping:.5f initialSpringVelocity:10.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.whiteVi.transform=CGAffineTransformIdentity;
        self.containBtn.transform=CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [self.view endEditing:YES];
        isPushed=NO;
    }];
}
- (void)cancelLittleViAnimation
{
    [UIView animateWithDuration:.5 delay:0 usingSpringWithDamping:.5f initialSpringVelocity:10.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.littleVi.transform=CGAffineTransformIdentity;
        self.containBtn.transform=CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [self.view endEditing:YES];
        isPushed=NO;
    }];
}
//开始编辑
-(void)textFieldDidBeginEditing:(UITextField *)textField
{

    if (textField==self.beginTF || textField== self.overTF)
    {
        textField.inputView = [[UIView alloc]initWithFrame:CGRectZero];
        [_cuiPickerView showInView:self.view];
    }
}
//赋值给textField
-(void)didFinishPickView:(NSString *)date
{
    if (date.length == 0) {
        NSDate *currentDate = [NSDate date];//获取当前时间，日期
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"YYYY-MM-dd hh:mm"];
        NSString *dateString = [dateFormatter stringFromDate:currentDate];
        NSLog(@"dateString:%@",dateString);
        
        if (self.beginTF.editing == YES) {
            //          BOOL isOK = [self date:dateString endStartDate:_endTextFiled.text];
            //            if (isOK) {
            //
            self.beginTF.text = dateString;
            //            }else{
            //                [JDTools addAlertViewInView:self title:@"温馨提示" message:@"您输入的时间段有误请重新输入" count:0 doWhat:^{
            //                }];
            //            }
        }else{
            //           BOOL isOK =  [self date:dateString endStartDate:_endTextFiled.text];
            //            if (isOK) {
            self.overTF.text = dateString;
            //            }else{
            //                [JDTools addAlertViewInView:self title:@"温馨提示" message:@"您输入的时间段有误请重新输入" count:0 doWhat:^{
            //                }];
            //            }
        }
        
    }else{
        self.dataStr = date;
        if (self.beginTF.editing == YES) {
            //         BOOL isOK =[self date:date endStartDate:_endTextFiled.text];
            //        if (isOK) {
            //
            self.beginTF.text = date;
            //        }else{
            //            [JDTools addAlertViewInView:self title:@"温馨提示" message:@"您输入的时间段有误请重新输入" count:0 doWhat:^{
            //            }];
            //        }
        }else{
            //        BOOL isOK = [self date:_startTextFiled.text endStartDate:date];
            //        if (isOK) {
            self.overTF.text = date;
            //
            //        }else{
            //            [JDTools addAlertViewInView:self title:@"温馨提示" message:@"您输入的时间段有误请重新输入" count:0 doWhat:^{
            //            }];
            //        }
            
        }
    }
    
    if (self.beginTF.text.length>0&&self.overTF.text.length>0) {
        
//        JDData *data = [JDData new];
//        [data getDrivingRecordWithStartTime:self.beginTF.text endTime:self.overTF.text taxiNumber:self.plateNoTF.text fileType:@"1" type:@"0" filePath:nil WithCompletion:^(NSString *returnCode, id res) {
//            JDLog(@"res====%@",res);
//        }];
    }
}
-(void)pickerviewbuttonclick:(UIButton *)sender
{
    
}
-(void)hiddenPickerView
{
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}
- (void)mapView:(MAMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    
    MAAnnotationView *view = views[0];
    
    // 放到该方法中用以保证userlocation的annotationView已经添加到地图上了。
    if ([view.annotation isKindOfClass:[MAUserLocation class]])
    {
        MAUserLocationRepresentation *pre = [[MAUserLocationRepresentation alloc] init];
        pre.fillColor = [UIColor colorWithRed:100/255.0 green:200/255.0 blue:240/255.0 alpha:0.3];
        pre.strokeColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.9 alpha:1.0];
        pre.image = [UIImage imageNamed:@"location.png"];
        pre.lineWidth = 0;
//        pre.lineDashPattern = @[@6, @3];
        [_mapView updateUserLocationRepresentation:pre];
        
        view.calloutOffset = CGPointMake(0, 0);
    } 
}
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *reuseIndetifier = @"annotationReuseIndetifier";
        MAAnnotationView *annotationView = (MAAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation
                                                          reuseIdentifier:reuseIndetifier];
        }
        annotationView.image = [UIImage imageNamed:@"img_taxi"];
        //设置中心点偏移，使得标注底部中间点成为经纬度对应点
        annotationView.centerOffset = CGPointMake(0, 0);
        return annotationView;
    }
    return nil;
}

@end
