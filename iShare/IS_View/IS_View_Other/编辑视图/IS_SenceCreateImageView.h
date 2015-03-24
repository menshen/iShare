#import <UIKit/UIKit.h>
#import "IS_SenceSubTemplateModel.h"
#import "RTSpinKitView.h"


@protocol IS_SenceCreateImageViewDelegate;

@interface IS_SenceCreateImageView : UIView//<UIScrollViewDelegate>
/*
 *  内容视图
 */
@property (nonatomic, strong) UIScrollView             * contentView;
/**
 *  图片视图
 */
@property (nonatomic, strong) UIButton                 *imageBtnView;
/**
 *  数据
 */
@property (nonatomic, strong) IS_SenceSubTemplateModel * subTemplateModel;

/**
 *  加载状态
 */

@property (nonatomic,assign ) IS_ImageUploadState      uploadState;
/**
 *   是否被选择中
 */
@property (nonatomic, assign) BOOL                     isSelected;
/**
 *  直接设置图片,动态改变内部的偏移量跟内容大小
 *
 *  @param imageData 图片数据
 *  @param isAdjust  是否调整
 *  @param isExchage 是否在交换图片
 */
- (void)setImageViewData:(UIImage *)imageData
                isAdjust:(BOOL)isAdjust
               isExchage:(BOOL)isExchage;

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
