//
//  IS_SenceSetView.h
//  iShare
//
//  Created by 伍松和 on 15/2/3.
//  Copyright (c) 2015年 iShare. All rights reserved.
//

#import <UIKit/UIKit.h>
@class IS_EditGirdCollectionView;
@class IS_EditSetLayout;
@protocol IS_EditCollectionViewDelegate <NSObject>

@required
/**
 *  移动item
 */
- (void)collectionView:(IS_EditGirdCollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath;

//- (void)IS_EditCollectionViewDismissDidHandleTapAndPinch;
@end
@interface IS_EditGirdCollectionView : UICollectionView<UIGestureRecognizerDelegate>

/**
 *  增加一个变量->>滑动刷新
 */
@property (nonatomic, weak) id<IS_EditCollectionViewDelegate> move_delegate;
@property (nonatomic, assign) BOOL draggable;

-(void)addGestures;
@end
