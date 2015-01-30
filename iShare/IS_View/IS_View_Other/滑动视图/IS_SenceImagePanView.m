
#import "IS_SenceImagePanView.h"
#import "IS_SenceSubTemplateModel.h"
#import "IS_SenceTemplateModel.h"
#import "IS_SenceImagePanCell.h"
#import "IS_SenceCreateImageView.h"
@interface IS_SenceImagePanView()
///插入还是代替
@property (nonatomic,assign)BOOL isReplace;
///当前选择的 tag
@property (nonatomic,assign)NSInteger cur_selected_tag;
///当前数据
@property (nonatomic,strong)UIImage * cur_image;

@property (nonatomic,strong)IS_SenceSubTemplateModel * cur_subTemplateModel;

@end

@implementation IS_SenceImagePanView

-(void)setIsReplace:(BOOL)isReplace{
    
    _isReplace = isReplace;
    if (!_isReplace) {
        [self clearByIndexPath:nil];
    }
    
    
    
}
-(void)dealloc{[[NSNotificationCenter defaultCenter]removeObserver:self];}
-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        //1.默认
        [self addDefault];
        
        //2.模板改变
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleTemplateChange:) name:COLLECTION_VIEW_SCROLL_CHANGE_TEMPLATE_PAN object:nil];
        
        //3.图片改变
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(bigImageToImagePan:) name:BIG_IMAGE_TO_IMAGE_PAN object:nil];
    }
    return self;

}
-(void)handleTemplateChange:(NSNotification*)notification{
    
    //当模板改变时候,把状态改为插入状态
    
    if ([notification.object isKindOfClass:[IS_SenceTemplateModel class]]) {
        //
        self.cur_subTemplateModel=nil;
        [self clearByIndexPath:nil];
    }
}
#pragma mark -点击大图->选中状态更新
-(void)bigImageToImagePan:(NSNotification*)notification{
    
    if ([notification.object isKindOfClass:[IS_SenceSubTemplateModel class]]) {
        
        IS_SenceSubTemplateModel * subTemplateModel =notification.object;
        if (subTemplateModel.image_selected==0) {
            self.cur_subTemplateModel=nil;
            [self clearByIndexPath:nil];
        }else{
            self.cur_subTemplateModel=subTemplateModel;
            self.cur_image=subTemplateModel.image_data;
            [self clearByCurImage:_cur_image];
            self.isReplace=subTemplateModel.image_selected;
        }
       

        
    }else{
        
    }

}
-(void)clearByCurImage:(UIImage*)image{
    
    [self.dataSource enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        IS_SenceSubTemplateModel * senceImageModel = obj;
        if ([senceImageModel.image_data isEqual:image]) {
            [self clearByIndexPath:[NSIndexPath indexPathForRow:idx inSection:0]];
              *stop=YES;
        }
    }];
    
}
#pragma mark - 清除并添加
-(void)clearByIndexPath:(NSIndexPath*)indexPath{
    
    
    [self.dataSource enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        IS_SenceSubTemplateModel * last_Template =obj;
        if (idx==indexPath.row&&indexPath) {
            last_Template.image_selected=YES;
            IS_SenceSubTemplateModel * litter_image_model = self.dataSource[indexPath.row];
            litter_image_model.image_selected=YES;
            [self.dataSource replaceObjectAtIndex:indexPath.row withObject:litter_image_model];
            
        }else{
            last_Template.image_selected=NO;
        }
    }];
    
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    [self.tableView reloadData];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * CellIdentifier= @"IS_SenceImagePanCell";
    [UITableViewCell configureCellWithClass:[IS_SenceImagePanCell class] WithCellID:CellIdentifier WithTableView:tableView];
    IS_SenceImagePanCell * cell = (IS_SenceImagePanCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.contentView.transform = CGAffineTransformMakeRotation(M_PI / 2);
    
    cell.senceImageModel=self.dataSource[indexPath.row];
  
    
    return cell;
    
}
#define UPLOAD_IMAGE @"UPLOAD_IMAGE"

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self clearByIndexPath:indexPath];
    
    if (self.sencePanItemDidSelectBlock) {
        if (indexPath.row==0) {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            [[NSNotificationCenter defaultCenter]postNotificationName:THUMBNAIL_IMAGE_TO_CONTROLLER
                                                               object:nil];
            
        }else{
            
            //0.把选择次数+1
            IS_SenceSubTemplateModel * subTemplateModel = self.dataSource[indexPath.row];
            [self.dataSource replaceObjectAtIndex:indexPath.row withObject:subTemplateModel];
            
            
            //1.发送出去的对象
            id notification_obj =nil;
            NSDictionary * user_info =nil;
            if (!_cur_subTemplateModel) {
                notification_obj =subTemplateModel.image_data;
            }else{
                _cur_subTemplateModel.image_data=subTemplateModel.image_data;
                notification_obj=_cur_subTemplateModel;
                

            }
            
           //1.
            [[NSNotificationCenter defaultCenter]postNotificationName:THUMBNAIL_IMAGE_TO_COLLECTION_VIEW
                                                               object:notification_obj
                                                             userInfo:user_info];

        }
    }
    
}

#pragma mark 
///1.默认
-(void)addDefault{
    
    //1.
    
    IS_SenceSubTemplateModel * senceImageModel = [[IS_SenceSubTemplateModel alloc]init];
    senceImageModel.image_selected_num=0;
    senceImageModel.image_data = [UIImage imageNamed:@"sence_add_img_placeholder"];
    [self.dataSource addObject:senceImageModel];
    
}

//2.增加其他
-(void)insertSenceImageArray:(NSArray*)imageArray{

//    NSMutableArray * indexPathArray = [NSMutableArray array];
    NSMutableArray * senceImageModelArray = [NSMutableArray array];
    for (UIImage * image_data in imageArray) {
        IS_SenceSubTemplateModel * senceImageModel = [[IS_SenceSubTemplateModel alloc]init];
        senceImageModel.image_selected_num=0;
        senceImageModel.image_data = image_data;
        //3.发送通知到
        [[NSNotificationCenter defaultCenter]postNotificationName:THUMBNAIL_IMAGE_TO_COLLECTION_VIEW
                                                           object:senceImageModel.image_data
                                                         userInfo:nil];
        [senceImageModelArray addObject:senceImageModel];
    }
    
    [self.dataSource insertObjects:senceImageModelArray atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1, senceImageModelArray.count)]];
    [self.tableView reloadData];
    
   

}

//3.删除其他
-(void)deleteSenceImageForIndexPath:(NSIndexPath*)indexPath{

    NSInteger row = indexPath.row;
    [self.dataSource removeObjectAtIndex:row];
}
#pragma mark 


@end
