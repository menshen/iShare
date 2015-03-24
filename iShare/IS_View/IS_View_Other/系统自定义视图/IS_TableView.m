//
//  IS_TableView.m
//  iShare
//
//  Created by 伍松和 on 15/1/15.
//  Copyright (c) 2015年 iShare. All rights reserved.
//

#import "IS_TableView.h"

@implementation IS_TableView

- (void)insertRowsAtIndexPaths:(NSArray *)indexPaths
              withRowAnimation:(UITableViewRowAnimation)animation
{
    [super insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
//    [self endUpdates]; // Populates UITableView with data
//    [self beginUpdates];
//    for (NSIndexPath *indexPath in indexPaths) {
//        __block UITableViewCell *cell = [super cellForRowAtIndexPath:indexPath];
//        if (cell) { // If indexPath isn't visible we'll get nil here
//            // Custom animation
//            CGRect frame = cell.frame;
//            frame.origin.y = cell.frame.size.height;
//            cell.frame = frame;
//            frame.origin.y = 0;
//            void (^animationsBlock)() = ^{
//                cell.frame = frame;
//            };
//            if ([[UIView class] respondsToSelector:
//                 @selector(animateWithDuration:delay:usingSpringWithDamping:
//                           initialSpringVelocity:options:animations:completion:)]) {
//                     [UIView animateWithDuration:0.3
//                                           delay:0
//                          usingSpringWithDamping:0.5
//                           initialSpringVelocity:0
//                                         options:0
//                                      animations:animationsBlock
//                                      completion:NULL];
//                 } else {
//                     [UIView animateWithDuration:0.3
//                                           delay:0
//                                         options:UIViewAnimationOptionCurveEaseIn
//                                      animations:animationsBlock
//                                      completion:NULL];
//                 }
//        }
//    }
}

@end
