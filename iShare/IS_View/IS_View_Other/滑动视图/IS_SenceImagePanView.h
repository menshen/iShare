
#import "IS_SencePanView.h"

@interface IS_SenceImagePanView : IS_SencePanView
///1.默认
-(void)addDefault;

//2.增加其他
-(void)insertSenceImageArray:(NSArray*)imageArray;

//3.删除其他
-(void)deleteSenceImageForIndexPath:(NSIndexPath*)indexPath;

@end
