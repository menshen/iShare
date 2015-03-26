@protocol IS_SenceTemplatePanViewDelegate <NSObject>
@optional

/**
 *  当点击事件后
 */
- (void)IS_SenceTemplatePanViewDidSelectItem:(id)itemData
                                 userinfo:(NSDictionary*)userinfo;


@end

#import <UIKit/UIKit.h>
#import "IS_CollectionView.h"

@interface IS_EditTemplateActionView : IS_CollectionView


/**
 *  代理
 */
@property (nonatomic,weak)id<IS_SenceTemplatePanViewDelegate>template_delegate;


- (void)reloadCollectionViewData;

@end
