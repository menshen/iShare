#import <UIKit/UIKit.h>
#import "IS_SenceSubTemplateModel.h"

typedef NS_ENUM(NSInteger, IS_SenceCreateImageViewType) {

    IS_SenceCreateImageViewTypeImage,
    IS_SenceCreateImageViewTypeText,
    
};

@protocol IS_SenceCreateImageViewDelegate;

@interface IS_SenceCreateImageView : UIView//<UIScrollViewDelegate>
/**
 *  数据
 */
@property (nonatomic, strong) IS_SenceSubTemplateModel  * senceSubTemplateModel;
/**
 *  内容视图
 */
@property (nonatomic, strong) UIView  *contentView;
/**
 *  可以点击
 */
@property (nonatomic, strong) UIButton *imageBtnView;

/**
 *  编辑子视图的类型 1、图片 2、文字 3、视频
 */
@property (nonatomic, assign)IS_SenceCreateImageViewType createImageViewType;
/**
 *  协议
 */
@property (nonatomic, assign) id<IS_SenceCreateImageViewDelegate> editViewDelegate;
/**
 *   是否被选择中
 */
@property (nonatomic, assign)BOOL isSelected;

@end

@protocol IS_SenceCreateImageViewDelegate <NSObject>

/**
 *  拖动状态
 */
- (void)panSenceCreateSubView:(IS_SenceCreateImageView *)sender
                        state:(UIGestureRecognizerState)pan_state;




@end
