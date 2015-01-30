#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "IS_SenceCreateImageView.h"
#import "IS_SenceTemplateModel.h"

@interface IS_SenceCreateEditView : UIView

///存放View数组
@property (nonatomic,strong)NSMutableArray *  senceCreateImgViewArray;
//存放view-Frame的标准位置
@property (nonatomic,strong)NSMutableArray *  senceCreateImgViewFramesArray;
//存放Image的标准位置
@property (nonatomic,strong)NSMutableArray *  senceCreateImgViewImageArray;



/**
 *  模板编辑视图的模板模型
 */
@property (nonatomic,strong)IS_SenceTemplateModel * senceTemplateModel;


//-(void)resetSenceCreateImageView:(NSArray*)arrayM;


@end
