
#import "IS_SenceImagePanView.h"
#import "IS_SenceImageModel.h"
#import "IS_SenceImagePanCell.h"


@implementation IS_SenceImagePanView


-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        //1.默认
        [self addDefault];
    }
    return self;

}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * CellIdentifier= @"IS_SenceImagePanCell";
    [UITableViewCell configureCellWithClass:[IS_SenceImagePanCell class] WithCellID:CellIdentifier WithTableView:tableView];
    IS_SenceImagePanCell * cell = (IS_SenceImagePanCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.contentView.transform = CGAffineTransformMakeRotation(M_PI / 2);
    
    cell.senceImageModel=self.dataSource[indexPath.row];
    
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.sencePanItemDidSelectBlock) {
        if (indexPath.row==0) {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            self.sencePanItemDidSelectBlock(indexPath);
        }else{
            IS_SenceImageModel * imageModel = self.dataSource[indexPath.row];
            imageModel.image_selected_num++;
            [self.dataSource replaceObjectAtIndex:indexPath.row withObject:imageModel];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            self.sencePanItemDidSelectBlock(imageModel);
            
            
            IS_SenceImagePanCell * cell = (IS_SenceImagePanCell *)[self tableView:self.tableView cellForRowAtIndexPath:indexPath];
            [[NSNotificationCenter defaultCenter]postNotificationName:IS_SenceCreateViewDidChangeImage
                                                               object:cell.sencn_image_btn_view
                                                             userInfo:@{@"type":@(1)}];

        }
    }
    
}

#pragma mark 
///1.默认
-(void)addDefault{
    
    //1.
    
    IS_SenceImageModel * senceImageModel = [[IS_SenceImageModel alloc]init];
    senceImageModel.image_selected_num=0;
    senceImageModel.imageData = [UIImage imageNamed:@"sence_add_img_placeholder"];
    [self.dataSource addObject:senceImageModel];
    
}

//2.增加其他
-(void)insertSenceImageArray:(NSArray*)imageArray{

//    NSMutableArray * indexPathArray = [NSMutableArray array];
    NSMutableArray * senceImageModelArray = [NSMutableArray array];
    for (UIImage * imageData in imageArray) {
        IS_SenceImageModel * senceImageModel = [[IS_SenceImageModel alloc]init];
        senceImageModel.image_selected_num=0;
        senceImageModel.imageData = imageData;
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

/*

 NSLog(@"assets %@",assets);
 //    self.labelDescription.text = [NSString stringWithFormat:@"%ld assets selected",(unsigned long)assets.count];
 
 if([[assets[0] valueForProperty:@"ALAssetPropertyType"] isEqualToString:@"ALAssetTypePhoto"]) Photo
 {
 NSMutableArray * arrayM = [NSMutableArray array];
 [assets enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
 ALAsset *representation = obj;
 UIImage *img = [UIImage imageWithCGImage:representation.defaultRepresentation.fullResolutionImage
 scale:representation.defaultRepresentation.scale
 orientation:(UIImageOrientation)representation.defaultRepresentation.orientation];
 [arrayM addObject:img];
 *stop = YES;
 }];
 
 [self.senceImagePanView insertSenceImageArray:arrayM];
 
 }
 else //Video
 {
 ALAsset *alAsset = assets[0];
 
 UIImage *img = [UIImage imageWithCGImage:alAsset.defaultRepresentation.fullResolutionImage
 scale:alAsset.defaultRepresentation.scale
 orientation:(UIImageOrientation)alAsset.defaultRepresentation.orientation];
 //        weakSelf.imageView.image = img;
 
 
 
 ALAssetRepresentation *representation = alAsset.defaultRepresentation;
 NSURL *movieURL = representation.url;
 NSURL *uploadURL = [NSURL fileURLWithPath:[[NSTemporaryDirectory() stringByAppendingPathComponent:@"test"] stringByAppendingString:@".mp4"]];
 AVAsset *asset      = [AVURLAsset URLAssetWithURL:movieURL options:nil];
 AVAssetExportSession *session =
 [AVAssetExportSession exportSessionWithAsset:asset presetName:AVAssetExportPresetMediumQuality];
 
 session.outputFileType  = AVFileTypeQuickTimeMovie;
 session.outputURL       = uploadURL;
 
 [session exportAsynchronouslyWithCompletionHandler:^{
 
 if (session.status == AVAssetExportSessionStatusCompleted)
 {
 NSLog(@"output Video URL %@",uploadURL);
 }
 
 }];
 
 }
 
*/
@end
