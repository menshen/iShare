#import <UIKit/UIKit.h>
#import "IS_SenceSubTemplateModel.h"


@protocol IS_SenceCreateImageViewDelegate;

@interface IS_SenceCreateImageView : UIScrollView//<UIScrollViewDelegate>
/**
 *  数据
 */
@property (nonatomic, strong) IS_SenceSubTemplateModel  * senceSubTemplateModel;
/**
 *  内容视图
 */
@property (nonatomic, strong) UIButton  *imageBtnView;
/*
 图片数据
 */
- (void)setImageViewData:(UIImage *)imageData;

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


/**
 *  处理图片完毕
 */
-(void)IS_SenceCreateImageViewDidDealImage:(id)sender;



@end
