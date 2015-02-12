typedef NS_ENUM(NSInteger, IS_SenceCreateType) {

    IS_SenceCreateTypeFristSence,//场景
    IS_SenceCreateTypeTemplateSence //模板
};
#import "IS_BaseViewController.h"
#import "IS_SenceModel.h"
@interface IS_SenceCreateController : IS_BaseViewController
///类型

@property (assign, nonatomic) IS_SenceCreateType senceCreateType;
-(instancetype)initWithCreateType:(IS_SenceCreateType)type;


@property (strong ,nonatomic)IS_SenceModel * senceModel;



@end
