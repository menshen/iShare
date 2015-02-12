//
//  IS_SenceSetView.m
//  iShare
//
//  Created by 伍松和 on 15/2/3.
//  Copyright (c) 2015年 iShare. All rights reserved.
//

#import "IS_EditCollectionView.h"
#import "IS_SenceEditCell.h"
#import "IS_EditSetLayout.h"

@interface IS_EditCollectionView()<UIGestureRecognizerDelegate>{

    @private
        UIGestureRecognizer *longPressGestureRecognizer;
        UIGestureRecognizer *panPressGestureRecognizer;
        UIGestureRecognizer *tapPressGestureRecognizer;

        BOOL                _draggable;
        
        UIImageView         *mockCell;
        CGPoint             mockCenter;
        
        IS_EditSetLayout    *editLayout;
        
        
        //没有长按cell的动作，不需要检测cell的移动
        BOOL                isInLongPress;

}

@end

@implementation IS_EditCollectionView

-(instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{

    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        editLayout =(IS_EditSetLayout*)layout;
    }
    return self;
    
}

-(void)addGestures{
    
    
    
    
    //1.长按
    longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc]
                                  initWithTarget:self
                                  action:@selector(handleLongPressGesture:)];
    longPressGestureRecognizer.delegate=self;
    [self addGestureRecognizer:longPressGestureRecognizer];

    //2.拖动
    panPressGestureRecognizer = [[UIPanGestureRecognizer alloc]
                                 initWithTarget:self action:@selector(handlePanGesture:)];
    panPressGestureRecognizer.delegate = self;
    

    [self addGestureRecognizer:panPressGestureRecognizer];
    

    
    //3.捏合
    
    
   

}




#pragma mark - ---------------Helper ----------------------

#pragma mark - 根据CGPoint对象获取对应的NSIndexPath
- (NSIndexPath *)indexPathForItemClosestToPoint:(CGPoint)point
{
    NSIndexPath *indexPath;
    
    for (UICollectionViewCell *cell in self.visibleCells) {
        if (CGRectContainsPoint(cell.frame, point)) {
            indexPath = [self indexPathForCell:cell];
            break;
        }
    }
    return indexPath;
}
#pragma mark - Cell的截图
- (UIImage *)imageFromCell:(UICollectionViewCell *)cell
{
    UIGraphicsBeginImageContextWithOptions(cell.bounds.size, cell.isOpaque, 0.0f);
    [cell.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
#pragma mark shake
- (void)startShake
{
    for (IS_SenceEditCell *cell in self.visibleCells) {
        [cell startShake];
    }
}

- (void)stopShake
{
    for (IS_SenceEditCell *cell in self.visibleCells) {
        [cell stopShake];
    }
}
- (void)animateMockCellToCorrectPosition:(void(^)())completionBlock
{
    UICollectionViewLayoutAttributes *layoutAttributes = [self layoutAttributesForItemAtIndexPath:editLayout.hiddenIndexPath];
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         mockCell.center = layoutAttributes.center;
                         mockCell.transform = CGAffineTransformMakeScale(1.f, 1.f);
                     }
                     completion:^(BOOL finished) {
                         self.scrollEnabled = YES;
                         
                         [editLayout setHiddenIndexPath:Nil];
                         [editLayout invalidateLayout];
                         
                         [self performSelector:@selector(removeMockCell) withObject:Nil afterDelay:0.1];
                         
                         if (completionBlock)
                             completionBlock();
                     }];
    
}

- (void)removeMockCell
{
    [self stopShake];
    [UIView animateWithDuration:0.3 animations:^{
        [mockCell setAlpha:0.9];
    } completion:^(BOOL finished) {
        [mockCell removeFromSuperview];
        mockCell = nil;
    }];
}
#pragma mark - 手势
#pragma mark - LongGestureAction
- (void)handleLongPressGesture:(UILongPressGestureRecognizer *)sender
{
    
 
    
    if (sender.state == UIGestureRecognizerStateChanged) {
        return;
    }
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        NSIndexPath *indexPath = [self indexPathForItemClosestToPoint:[sender locationInView:self]];
        if (!indexPath) {
            return;
        }
        //  0.长按触发-> 把正在长按记录下来(那样移动图标就不会乱动)
        isInLongPress = YES;
        
        //1.记录正在被长按的位置
        editLayout.fromIndexPath = indexPath;
        
        //2.禁止移动
        self.scrollEnabled = NO;
        
        //3.弄一个虚拟图像->模拟将要移动的cell-
        UICollectionViewCell *cell = [self cellForItemAtIndexPath:indexPath];
        cell.highlighted = NO;
        [mockCell removeFromSuperview];
        mockCell = [[UIImageView alloc] initWithFrame:cell.frame];
        mockCell.image = [self imageFromCell:cell];
        mockCenter = mockCell.center;
        [self addSubview:mockCell];
        [UIView animateWithDuration:0.3
                         animations:^{
                             mockCell.transform = CGAffineTransformMakeScale(1.1f, 1.1f);
                         }
                         completion:nil];
        //4.cell 对应位置设置为布局隐藏位置
        [editLayout setHiddenIndexPath:indexPath];
        //5.禁止旧布局->重新加载布局
        [editLayout invalidateLayout];
        
        //6.所有 cell 抖动
        [self startShake];
    }
    else {
        
        
        /*-------------------------长按结束----------------------------*/
        
        isInLongPress = NO;
        if (!editLayout.fromIndexPath || !editLayout.toIndexPath) {
            [self animateMockCellToCorrectPosition:nil];
            return;
        }
        
        //switch dataSource's item, then move cell.
        [self.move_delegate collectionView:self moveItemAtIndexPath:editLayout.fromIndexPath toIndexPath:editLayout.toIndexPath];
        [self performBatchUpdates:^{
            [self moveItemAtIndexPath:editLayout.fromIndexPath toIndexPath:editLayout.toIndexPath];
            editLayout.fromIndexPath = nil;
            editLayout.toIndexPath = nil;
        } completion:nil];
        
        [self animateMockCellToCorrectPosition:nil];
    }
}

#pragma mark - PanGestures

- (void)handlePanGesture:(UIPanGestureRecognizer *)sender
{
    
  
    
    if(sender.state == UIGestureRecognizerStateChanged &&
       editLayout.fromIndexPath && isInLongPress) {
        CGPoint movePoint = [sender locationInView:self];
        mockCell.center = movePoint;
        
        //  [self ifNeedsPaging:movePoint];
        
        //if (isPaging) return;
        
        NSIndexPath *indexPath = [self indexPathForItemClosestToPoint:movePoint];
        if (indexPath && ![indexPath isEqual:editLayout.fromIndexPath]) {
            if (self.move_delegate) {
                [self performBatchUpdates:^{
                    editLayout.hiddenIndexPath = indexPath;
                    editLayout.toIndexPath = indexPath;
                } completion:^(BOOL finished) {
                    [self startShake];
                }];
            }
        }
    }
}

#pragma mark Gesture delegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer==panPressGestureRecognizer) {
        return isInLongPress;
    }
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if ((gestureRecognizer == longPressGestureRecognizer &&
        otherGestureRecognizer == panPressGestureRecognizer) ||
        (gestureRecognizer == panPressGestureRecognizer &&
         otherGestureRecognizer==longPressGestureRecognizer))
    return YES;
    //
    return NO;
}





@end
