typedef NS_ENUM(NSInteger, IS_SenceCreateType) {

    IS_SenceCreateTypeFristSence,//场景
    IS_SenceCreateTypeTemplateSence //模板
};
#import "IS_BaseViewController.h"
@interface IS_SenceCreateController : IS_BaseViewController
///类型

@property (assign, nonatomic) IS_SenceCreateType senceCreateType;
@property (weak, nonatomic) IBOutlet UISegmentedControl *sence_segmented_control;
@property (weak, nonatomic) IBOutlet UIView *sence_tool_view;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIView *sence_content_view;
-(instancetype)initWithCreateType:(IS_SenceCreateType)type;

@end
