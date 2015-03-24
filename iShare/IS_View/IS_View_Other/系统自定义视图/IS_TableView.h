//
//  IS_TableView.h
//  iShare
//
//  Created by 伍松和 on 15/1/15.
//  Copyright (c) 2015年 iShare. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IS_TableView : UITableView
- (void)insertRowsAtIndexPaths:(NSArray *)indexPaths
              withRowAnimation:(UITableViewRowAnimation)animation;
@end
