#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "IS_EditImageView.h"
#import "IS_EditTemplateModel.h"

@protocol IS_EditContentViewDelegate <NSObject>

/**
 *  当点击事件后
 */
- (void)IS_EditContentViewDidSelectItem:(id)itemData
                                 userinfo:(NSDictionary*)userinfo;

/**
 *   处理图片数据后
 */
- (void)IS_EditViewDidChangeDataAction:(id)itemData
                                   userinfo:(NSDictionary*)userinfo;


@end



@interface IS_EditContentView : UIView

@property (nonatomic,weak)id<IS_EditContentViewDelegate>delegate;
///存放View数组
@property (nonatomic,strong)NSMutableArray *  senceSubModelArray;
//存放view-Frame的标准位置
@property (nonatomic,strong)NSMutableArray *  senceCreateImgViewFramesArray;
////存放ImageView的标准位置
@property (nonatomic,strong)NSMutableArray *  senceSubViewArray;
////存放Image的标准位置
@property (nonatomic,strong)NSMutableArray *  imageArray;
////存放imageAssetURLArray的标准位置
@property (nonatomic,strong)NSMutableArray *  imageAssetURLArray;

@property (nonatomic,strong)UITextView * senceTextView;

/**
 *  模板编辑视图的模板模型
 */
@property (nonatomic,strong)IS_EditTemplateModel * senceTemplateModel;


//-(void)resetSenceCreateImageView:(NSArray*)arrayM;


@end
