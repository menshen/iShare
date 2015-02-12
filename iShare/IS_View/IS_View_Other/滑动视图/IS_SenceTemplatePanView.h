@protocol IS_SenceTemplatePanViewDelegate <NSObject>
@optional

/**
 *  当点击事件后
 */
- (void)IS_SenceTemplatePanViewDidSelectItem:(id)itemData
                                 userinfo:(NSDictionary*)userinfo;


@end

#import "IS_SencePanView.h"

@interface IS_SenceTemplatePanView : IS_SencePanView
/**
 *  代理
 */
@property (nonatomic,weak)id<IS_SenceTemplatePanViewDelegate>delegate;

/**
 *  模板视图滚动
 */
-(void)templateScrollDidChange:(id)itemData;
@end
