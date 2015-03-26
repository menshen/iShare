@protocol IS_SenceTemplatePanViewDelegate <NSObject>
@optional

/**
 *  当点击事件后
 */
- (void)IS_SenceTemplatePanViewDidSelectItem:(id)itemData
                                 userinfo:(NSDictionary*)userinfo;


@end

#import <UIKit/UIKit.h>

@interface IS_TemplateSheetView : UIView

/**
 *  模板数据源
 */
@property (nonatomic,strong)NSMutableArray * template_dataSource;
/**
 *  代理
 */
@property (nonatomic,weak)id<IS_SenceTemplatePanViewDelegate>template_delegate;

@end
