//
//  IS_BaseCell.h
//  iShare
//
//  Created by 伍松和 on 15/1/13.
//  Copyright (c) 2015年 iShare. All rights reserved.
//

#import <UIKit/UIKit.h>
//MGSwipeTableCell
#import "MGSwipeTableCell.h"
#import "MGSwipeButton.h"

/**
    block
 */

@class IS_CaseModel;
@interface IS_RankingCell : MGSwipeTableCell
#pragma mark -模板
@property (strong,nonatomic)IS_CaseModel * senceModel;

@property (weak, nonatomic) IBOutlet UIImageView *logoView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *detailLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (strong,nonatomic)NSIndexPath * indexPath;




#pragma mark -构建Cell（根据数据）
+(id)configureCellWithClass:(Class)cellClass
                 WithCellID:(NSString*)CellIdentifier
              WithTableView:(UITableView*)tableView;

-(NSArray *) createRightButtons;
@end
