
#import <UIKit/UIKit.h>
typedef void(^IS_SencePanItemDidSelectBlock)(id result);
@interface IS_SencePanView : UIView<UITableViewDelegate,UITableViewDataSource>{
    
    NSMutableArray * _dataSource;
}
@property (nonatomic, strong)NSMutableArray * dataSource;
@property (nonatomic, strong)UITableView    * tableView;
@property (nonatomic, strong)UIImageView    * bottomImageView;
-(void)reloadPanData;

//- (id)initWithFrame:(CGRect)frame picCount:(NSInteger)picCount;


@property (copy, nonatomic)IS_SencePanItemDidSelectBlock sencePanItemDidSelectBlock;
/**
 *  点击 Item
 */
-(void)selectPanItem:(IS_SencePanItemDidSelectBlock)sencePanItemDidSelectBlock;
@end
