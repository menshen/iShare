

#import "IS_EditMusicActionSheet.h"
#import "IS_EditMusicCell.h"
#import "MJRefresh.h"
#import "UIDevice+JJ.h"
#import "IS_MusicModel.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
@interface IS_EditMusicActionSheet()<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>
@property (strong,nonatomic)UITableView * tableView;
@property (strong,nonatomic)NSMutableArray * datasource;
@property (strong,nonatomic)MPMoviePlayerViewController * moviePlayer;
@end
#define IS_EditMusicTableViewHeight 40
@implementation IS_EditMusicActionSheet

#pragma mark - 初始化



-(void)dismissActionSheet{
    
    [UIView animateWithDuration:.25 animations:^{
       [_tableView setFrame:CGRectMake(0, ScreenHeight,ScreenWidth, ScreenHeight-IS_EditMusicTableViewHeight)];
        self.backgroundColor = [UIColor clearColor];
    } completion:^(BOOL finished) {
//        [self.actionSheetWindow resignKeyWindow];
//        [self.actionSheetWindow removeFromSuperview];
//        self.actionSheetWindow = nil;

        if (finished) {
            [self removeFromSuperview];
            [_moviePlayer.moviePlayer stop];

        }
    }];
    
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupTableView];
        
        [self.tableView.header beginRefreshing];
        
        
        _moviePlayer = [ [ MPMoviePlayerViewController alloc]initWithContentURL:nil];//远程
      
    }
    
    
    return self;
}
-(UITableView *)tableView{

    if (!_tableView) {
        CGRect frame = CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight-IS_EditMusicTableViewHeight);
        _tableView = [[UITableView alloc]initWithFrame:frame style:UITableViewStylePlain];
        _tableView.delegate =self;
        _tableView.dataSource =self;
        _tableView.tableFooterView = [[UIView alloc]init];
        [self setupRefresh];
        
    }
    return _tableView;
    
}
- (void)addDatasource:(NSMutableArray * )dataSource{
    _datasource= dataSource;
}

#pragma mark - 初始化UITableView
-(void)setupRefresh{
    
    
    NSMutableArray * imgArray = [NSMutableArray array];
    for (int i =0; i<7; i++) {
        NSString * name = [NSString stringWithFormat:@"tt_%d",i+1];
        UIImage * img = [UIImage imageNamed:name];
        [imgArray addObject:img];
    }
    
    WEAKSELF;
    MJRefreshGifHeader * header = [self.tableView addGifHeaderWithRefreshingBlock:^{
        
        [weakSelf loadNetWork];
    }];
    header.stateHidden = YES;
    header.updatedTimeHidden = YES;
    
    [header setImages:imgArray forState:MJRefreshHeaderStateWillRefresh];
    [header setImages:imgArray forState:MJRefreshHeaderStateRefreshing];
    [header setImages:imgArray forState:MJRefreshHeaderStatePulling];
    [header setImages:imgArray forState:MJRefreshHeaderStateIdle];
    
    
   
    
}
- (void)setupTableView{
    
    _datasource = [NSMutableArray array];
    
    [self addSubview:self.tableView];
    
    UINib * nib = [UINib nibWithNibName:IS_EditMusicCell_ID bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nib forCellReuseIdentifier:IS_EditMusicCell_ID];
    
    [UIView animateWithDuration:.3 animations:^{
        [_tableView setFrame:CGRectMake(0, IS_EditMusicTableViewHeight, ScreenWidth, ScreenHeight-IS_EditMusicTableViewHeight)];
        
    }];
}
- (void)loadNetWork{
    
    [HttpTool postWithPath:GET_MUSIC_LIST params:nil success:^(id result) {
        
        if (result[DATA_KEY]) {
            NSArray * arrayM = result[DATA_KEY];
            self.datasource =[NSMutableArray arrayWithArray:[IS_MusicModel objectArrayWithKeyValuesArray:arrayM]];
            [self.tableView reloadData];
        }
        
        [self.tableView.header endRefreshing];
        
    } failure:^(NSError *error) {
        [self.tableView.header endRefreshing];
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
    
    cell.musicModel = self.datasource [indexPath.row];
   // IS_EditMusicCell * cell = [UINib nibWithNibName:IS_EditMusicCell_ID bundle:[NSBundle mainBundle]];
//    [tableView dequeueReusableCellWithIdentifier:IS_EditMusicCell_ID];
//   
//    UINib *nib = [UINib nibWithNibName:IS_EditMusicCell_ID bundle:[NSBundle mainBundle]];
    return cell;
}
-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

  //  [self dismissActionSheet];
    
    IS_MusicModel * musicModel = self.datasource [indexPath.row];
    
    

    _moviePlayer.moviePlayer.contentURL =[NSURL URLWithString:musicModel.musicurl];
    [_moviePlayer.moviePlayer play];
    
    
    if (self.actonSheetBlock) {
        self.actonSheetBlock (musicModel.musicurl);
    }
}



@end
