

#import "IS_EditMusicActionSheet.h"
#import "IS_EditMusicCell.h"

@interface IS_EditMusicActionSheet()<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>
@end
#define IS_EditMusicTableViewHeight ScreenHeight/2
@implementation IS_EditMusicActionSheet
{
    UITableView  * _tableView;
    NSMutableArray * _datasource;
}
#pragma mark - 初始化



-(void)dismissActionSheet{
    
    [UIView animateWithDuration:.25 animations:^{
       [_tableView setFrame:CGRectMake(0, ScreenHeight,ScreenWidth, IS_EditMusicTableViewHeight)];
        self.backgroundColor = [UIColor clearColor];
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
    
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupTableView];
      
    }
    
    
    return self;
}
- (void)addDatasource:(NSMutableArray * )dataSource{
    _datasource= dataSource;
}
#pragma mark - 显示

#pragma mark - 初始化UITableView

- (void)setupTableView{
    
    _datasource = [NSMutableArray array];
    CGRect frame = CGRectMake(0, ScreenHeight, ScreenWidth, IS_EditMusicTableViewHeight);
    _tableView = [[UITableView alloc]initWithFrame:frame style:UITableViewStylePlain];
    _tableView.delegate =self;
    _tableView.dataSource =self;
    [self addSubview:_tableView];
    
    
    UINib *nib = [UINib nibWithNibName:IS_EditMusicCell_ID bundle:[NSBundle mainBundle]];
    [_tableView registerNib:nib forCellReuseIdentifier:IS_EditMusicCell_ID];
    
    [UIView animateWithDuration:.3 animations:^{
        [_tableView setFrame:CGRectMake(0, IS_EditMusicTableViewHeight, ScreenWidth, IS_EditMusicTableViewHeight)];
        
    }];
}
- (void)setupBottomView{
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{return 1;}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  _datasource.count;
}
- (UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    IS_EditMusicCell * cell = [tableView dequeueReusableCellWithIdentifier:IS_EditMusicCell_ID];
    
    return cell;
}
-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

  //  [self dismissActionSheet];
    if (self.actonSheetBlock) {
        self.actonSheetBlock (indexPath);
    }
}

@end
