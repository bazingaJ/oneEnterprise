//
//  LostCell.h
//  E+TAXI_company
//
//  Created by jeader on 16/6/27.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LostCell : UITableViewCell
/**
*  cell1
*/
@property (weak, nonatomic) IBOutlet UIImageView *thingImg;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *plateLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
/**
 *  cell2
 */
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
/**
 *  cell3
 */
@property (weak, nonatomic) IBOutlet UILabel *decribelLabel;

/**
 *  cell4
 */
@property (nonatomic, weak) IBOutlet UIImageView * picImg;
@end
