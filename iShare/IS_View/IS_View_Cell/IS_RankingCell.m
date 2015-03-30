#import "IS_RankingCell.h"
#import "IS_CaseModel.h"
#import "UIImage+JJ.h"
@implementation IS_RankingCell
//i_cell_bkg
- (void)awakeFromNib {
    
    [super awakeFromNib];
    //0.背景
    [self setBackgroundView:@"i_cell_bkg" selectBackgroundView:@"i_cell_bkg_select"];
    //1.
//    [self.logoView setRoundedCorners:UIRectCornerAllCorners radius:CGSizeMake(55/2, 55/2)];
}

-(void)setSenceModel:(IS_CaseModel *)senceModel{
    _senceModel =senceModel;
    //1.头像
//    self.logoView.image = [UIImage imageNamed:senceModel.i_image];
//    //2.标题
//    self.titleLab.text = senceModel.i_title;
//    //3.详情
//    self.detailLab.text = senceModel.i_detail;

    //4.时间
    //
}

#pragma mark -构建Cell（根据数据）
+(id)configureCellWithClass:(Class)cellClass
                 WithCellID:(NSString*)CellIdentifier
              WithTableView:(UITableView*)tableView{
    
    
    //NIB万岁
    BOOL nibsRegistered = NO;
    if (!nibsRegistered) {
        UINib *nib = [UINib nibWithNibName:NSStringFromClass([IS_RankingCell class]) bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:CellIdentifier];
        nibsRegistered = YES;
    }
    IS_RankingCell *cell = (IS_RankingCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    UIView *v=[[UIView alloc]initWithFrame:cell.bounds];
    v.backgroundColor=[UIColor clearColor];
    cell.multipleSelectionBackgroundView=v;//UITableViewCellStateShowingEditControlMask=UITableViewCellSelectionStyleGray;
    
    return cell;
    
}
-(void)setBackgroundView:(NSString *)imgName
    selectBackgroundView:(NSString*)select_imgName{

    UIImageView *bg = [[UIImageView alloc] init];
    bg.image = [UIImage resizedImage:imgName];
    self.backgroundView = bg;
    
    UIImageView *selectedBg = [[UIImageView alloc] init];
    selectedBg.image = [UIImage resizedImage:select_imgName];
    self.selectedBackgroundView = selectedBg;
    self.backgroundColor = [UIColor clearColor];
}

-(NSArray *) createRightButtons
{
    NSMutableArray * result = [NSMutableArray array];
    NSArray * titleArray =@[@"  查看资料  ",@"  关注TA  "];
    NSArray *colorArray=@[[UIColor redColor],[UIColor lightGrayColor]];;
    for (int i = 0; i < titleArray.count; ++i)
    {
        
        MGSwipeButton * button=nil;
        button.tag=i;
        if (i==0) {
            button = [MGSwipeButton buttonWithTitle:titleArray[i] backgroundColor:colorArray[i] callback:^BOOL(MGSwipeTableCell *sender) {
                return YES;
            }];
        }else if (i==1){
            button = [MGSwipeButton buttonWithTitle:titleArray[i] backgroundColor:colorArray[i] callback:^BOOL(MGSwipeTableCell *sender) {
                //[self jumpToPerson:indexPath];
                return YES;
            }];
        }
        
        
        [result addObject:button];
    }
    return result;
}
@end
