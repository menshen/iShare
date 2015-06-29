#import <UIKit/UIKit.h>
#import "IS_EditSubTemplateModel.h"
@class  RTSpinKitView;
@interface IS_EditLoadingView : UIView

@property (strong,nonatomic) UIButton * stateBtn;
/**
 *  加载视图
 */
@property (nonatomic,strong)RTSpinKitView * loadingView;

/*!
 *  上传状态
 */
@property (assign,nonatomic)IS_ImageUploadState uploadState;

-(void)showLoading;
- (void)hideLoading;
- (void)addActionBlock:(BtnActionBlock)btnActionBlock;
@end
