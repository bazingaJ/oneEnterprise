//
//  JDLineVC.h
//  E+TAXI_company
//
//  Created by jeader on 16/6/28.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>

@interface JDLineVC : UIViewController
{
    MAMapView *_mapView;
}
@property (weak, nonatomic) IBOutlet UIView *whiteVi;
@property (nonatomic, weak) IBOutlet UITextField * plateNoTF;
@property (nonatomic, weak) IBOutlet UITextField * beginTF;
@property (nonatomic, weak) IBOutlet UITextField * overTF;
@property (nonatomic, weak) IBOutlet UIButton * containBtn;

@property (nonatomic, weak) IBOutlet UIView * littleVi;
@property (nonatomic, weak) IBOutlet UITextField * nowTextF;

@end
