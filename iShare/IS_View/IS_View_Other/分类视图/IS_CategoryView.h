

#import <UIKit/UIKit.h>
@protocol IS_CategoryViewDelegate <NSObject>
/**
 *  When NavTabBar Item Is Pressed Call Back
 *
 *  @param index - pressed item's index
 */
- (void)itemDidSelectedWithIndex:(NSInteger)index;

@end
@interface IS_CategoryView : UIScrollView
@property (nonatomic, assign) NSInteger               currentItemIndex;
@property (nonatomic, strong) NSArray                 *itemTitles;// all items' title
@property (nonatomic, weak  ) id<IS_CategoryViewDelegate> ca_delegate;

/**
 *  Update Item Data
 */
- (void)updateData;
@end
