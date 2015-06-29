#define ITEM_MARGIN 5 //间距
#define ITEM_WIDTH  ScreenWidth
#define ITEM_HEIGHT ITEM_WIDTH*1.5 //高度

#import "IS_ActivityShowView.h"
#import "IS_ActivityShowCell.h"

@interface IS_ActivityShowView()<UIScrollViewDelegate>
//1.页面视图
@property (strong,nonatomic)UIPageControl * pageControl;
@end

@implementation IS_ActivityShowView

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.c_datasource = [NSMutableArray array];
        for (int i=0; i<1000; i++) {
            [self.c_datasource addObject:@"1"];
        }
        
        self.commonLayout.itemSize = CGSizeMake(ITEM_WIDTH, self.collectionView.height);
        [self.collectionView setCollectionViewLayout:self.commonLayout];
        UINib * nib = [UINib nibWithNibName:IS_ActivityShowCell_ID bundle:[NSBundle mainBundle]];
        [self.collectionView registerNib:nib forCellWithReuseIdentifier:IS_ActivityShowCell_ID];
    }
    return self;
}
#pragma mark - UICollectionViewDelegate

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    IS_ActivityShowCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:IS_ActivityShowCell_ID forIndexPath:indexPath];
    
    //id exhibitModel = self.exhibitDatasource[indexPath.row];
    
    
    int num = (int)random()%4+1;
    NSString * name = [NSString stringWithFormat:@"temp_%d",num];
    cell.imageView.image = [UIImage imageNamed:name];
    cell.titleLab.text = @"来来来";
    return cell;
}

@end
