#import <UIKit/UIKit.h>
#import "IS_SenceSubTemplateModel.h"


@protocol IS_SenceCreateImageViewDelegate;

@interface IS_SenceCreateImageView : UIScrollView//<UIScrollViewDelegate>
/**
 *  数据
 */
@property (nonatomic, strong) IS_SenceSubTemplateModel  * subTemplateModel;
/*
 *  内容视图
 */
@property (nonatomic, strong) UIButton  *imageBtnView;
/**
 *   是否被选择中
 */
@property (nonatomic, assign)BOOL isSelected;
@property (nonatomic ,strong)UIImageView * operationBar;
/*
 图片数据
 */
- (void)setImageViewData:(UIImage *)imageData
                isAdjust:(BOOL)isAdjust;

/**
 *  协议
 */
@property (nonatomic, assign) id<IS_SenceCreateImageViewDelegate> imageViewDelegate;


@end

@protocol IS_SenceCreateImageViewDelegate <NSObject>

/**
 *  拖动状态
 */
- (void)IS_SenceCreateImageViewPanning:(IS_SenceCreateImageView *)sender
                        state:(UIGestureRecognizerState)pan_state;


/**
 *  处理图片完毕
 */
-(void)IS_SenceCreateImageViewDidDealImage:(id)result;
/**
 *  处理图片完毕
 */
-(void)IS_SenceCreateImageViewDidBtnAction:(id)result;



@end
