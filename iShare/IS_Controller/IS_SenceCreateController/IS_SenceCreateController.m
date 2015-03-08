

#import "UzysAssetsPickerController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>

#import "IS_SenceCreateController.h"
#import "IS_SenceTemplateModel.h"
#import "IS_CardCollectionView.h"
#import "IS_TemplateSheetView.h"


#import "UIImage+ImageEffects.h"
#import "UIWindow+JJ.h"
#import "IS_SenceGirdController.h"
#import "IS_SenceEditTool.h"
#import "IS_TemplateCollectionController.h"


@interface IS_SenceCreateController ()<UzysAssetsPickerControllerDelegate,IS_SenceGirdControllerDelegate,
IS_CardCollectionViewDelegate>




/**
  滚动视图
 */
@property (nonatomic,weak)IBOutlet IS_CardCollectionView * collectionView;

/**
 * 选择条
 */
@property (strong, nonatomic)  UIPageControl *sence_pageControl;


@end

@implementation IS_SenceCreateController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    

    //1.加载子视图
    [self loadSenceSubView];
}
//#pragma mark -加载
#pragma mark -加载视图
-(void)loadSenceSubView{
    
    //A.
    [self addHeaderViews];
    
 
    self.view.backgroundColor =kColor(244, 244, 244);//[UIColor redColor];// kColor(240, 240, 240);
    
    self.collectionView.collection_delegate = self;
    [self.collectionView addDefaultSenceTemplateData:self.senceModel.sence_template_array];

    
    
    
}
#pragma mark - A.头部

-(void)addHeaderViews{
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTitle:@"生成" themeColor:kColor(44, 166,255) target:self action:@selector(createSence:)];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTitle:@"返回" themeColor:kColor(44, 166,255) target:self action:@selector(backToRoot:)];
    
    //0.标题
    self.title  =@"场景编辑";

}



#pragma mark - Action


#pragma mark - 跳转到总览九宫格界面
- (IBAction)jumpToMenuAction:(id)sender {
 
    
    IS_SenceGirdController * GirdCtrl = [[IS_SenceGirdController alloc]init];
    GirdCtrl.delegate=self;
    GirdCtrl.sence_array = self.collectionView.senceDataSource;
    [self presentNextController:GirdCtrl];

}
#pragma mark  - 跳转到模板选择界面
- (IBAction)jumpToTemplateSheetAction:(id)sender {
    
    IS_TemplateCollectionController * templateController = [[IS_TemplateCollectionController alloc]init];
    [self presentNextController:templateController];

}





-(void)createSence:(UIBarButtonItem*)item{
    
    
    [self.navigationController popViewControllerAnimated:YES];
}


// Do any additional setup after loading the view, typically from a nib.
#pragma mark  -保存并且离开


-(void)backToRoot:(UIBarButtonItem*)item{

    
  
//

    UIAlertView * a=[[UIAlertView alloc]initWithTitle:@"" message:@"是否保存编辑" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确认",@"继续", nil];
       [a showWithCompletionHandler:^(NSInteger buttonIndex) {
           
           switch (buttonIndex) {
               case 0:
               {
                    [self.navigationController popViewControllerAnimated:YES];
                     break;
               }
               case 1:
               {
                   break;
               }
               case 2:
               {
                   break;
               }
                 
                   
               default:
                   break;
           }
        //   [IS_SenceEditTool saveSenceModelWithSenceID:self.senceModel.sence_id
            //                                             TemplateArray:self.collectionView.senceDataSource
            //                                      SubTemplateDataArray:self.senceImagePanView.dataSource
            //                                             CompleteBlock:^(id results) {
            //                             if (results) {
            //                                 [UIWindow dismissWithHUD];
            //
            //                                 [self.navigationController popViewControllerAnimated:YES];
            //                             }
            //                             
            //                         }];

       }];
    
    

////    [self saveSenceData];
//    //
//   if (self.senceCreateType==IS_SenceCreateTypeFristSence) {
//       [self.navigationController popViewControllerAnimated:YES];
//   }else{
//
//   }
}
/**
 * 
    1. 点击 '+'
    2. 点击视图中的占位符
 */
#pragma mark -图片选择器
-(void)pickImageAndVideo{

    UzysAssetsPickerController *picker = [[UzysAssetsPickerController alloc] init];
    picker.delegate = self;
    picker.maximumNumberOfSelectionPhoto = INT16_MAX;
    [self presentViewController:picker animated:YES completion:^{
        
    }];

}
- (void)UzysAssetsPickerController:(UzysAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    
    
    
    NSMutableArray * arrayM = [NSMutableArray array];
    NSMutableArray * assetURLM=[NSMutableArray array];
    ALAssetsLibrary * assetLibrary = [[ALAssetsLibrary alloc]init];
    
    [assets enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
         if([[obj valueForProperty:@"ALAssetPropertyType"] isEqualToString:@"ALAssetTypePhoto"])
        {
//           [arrayM addObject:image];
//            [assetURLM addObject:representation.defaultRepresentation.url];

            ALAsset *representation = obj;
            [assetLibrary assetForURL:representation.defaultRepresentation.url resultBlock:^(ALAsset *asset) {
                UIImage  *copyOfOriginalImage = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullResolutionImage]];
                [arrayM addObject:copyOfOriginalImage];
                [assetURLM addObject:representation.defaultRepresentation.url.absoluteString];

                if (arrayM.count==assets.count) {
                    [self IS_SenceImagePanViewDidInsertImageItems:arrayM urlArray:assetURLM];

                }
            } failureBlock:nil];
            
            
//            UIImage *img = [UIImage imageWithCGImage:representation.defaultRepresentation.fullResolutionImage
//                                               scale:representation.defaultRepresentation.scale
//                                         orientation:(UIImageOrientation)representation.defaultRepresentation.orientation];
//
//            
//            [arrayM addObject:img];
        }
    }];
//    [self IS_SenceImagePanViewDidInsertItems:arrayM];


    
    
}

#pragma mark ------------------------------代理方法--------------------------------------

#pragma mark - IS_CardCollectionVoewDelegate

-(void)IS_CardCollectionViewDidEndPinch:(id)itemData{

    
    IS_SenceGirdController * GirdCtrl = [[IS_SenceGirdController alloc]init];
    GirdCtrl.delegate=self;
    GirdCtrl.sence_array = self.collectionView.senceDataSource;
    [self presentNextController:GirdCtrl];
}
/**
 *  当点击事件后
 */
- (void)IS_CardCollectionViewDidSelectImageViewItem:(id)itemData
                                           userinfo:(NSDictionary*)userinfo{
   
    if ([itemData image_data]) {
        //
    }else{
        [self pickImageAndVideo];
    }
    
}
#pragma mark - IS_SenceImagePanViewDelegate

-(void)IS_SenceImagePanViewDidSelectItem:(id)itemData userinfo:(NSDictionary *)userinfo{
      if (![itemData image_data]) {
        [self pickImageAndVideo];

    }else{
        [self.collectionView insertAssetIntoEditViewDidthumbnailImageAction:itemData userInfo:userinfo];

    }
}
-(void)IS_SenceImagePanViewDidInsertImageItems:(NSMutableArray*)itemArray
                                      urlArray:(NSMutableArray*)urlArray{
//    [self.senceImagePanView insertSenceImageArray:itemArray WithAssetURLArray:urlArray];
    [self.collectionView insertAssetIntoEditView:itemArray WithAssetURLArray:urlArray];
    
}

#pragma mark -  IS_SenceTemplatePanViewDelegate
-(void)IS_SenceTemplatePanViewDidSelectItem:(id)itemData userinfo:(NSDictionary *)userinfo{
    
   
    
    [self.collectionView templateToCollectionView:itemData];

    
}
-(void)IS_SenceGirdControllerDidUpdate:(id)itemData{
    
    if (!itemData) {
        return;
    }
    NSIndexPath * cur_indexPath = itemData;
    self.collectionView.currentIndexPath=cur_indexPath;
    [self.collectionView scrollToItemAtIndexPath:cur_indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    [self.collectionView reloadData];
}






#pragma mark - 把当前背景截图
-(UIImage*)getSnapshotFromCurWindow{

    CGSize windowSize = self.view.window.bounds.size;
    //
    UIGraphicsBeginImageContextWithOptions(windowSize, YES, 2.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.view.window.layer renderInContext:context];
    UIImage *snapshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    snapshot = [snapshot applyBlurWithRadius:20
                                   tintColor:Color(0, 0, 0, .3)
                       saturationDeltaFactor:0.6
                                   maskImage:nil];
    
    return snapshot;
}
#pragma mark -背景蒙板
- (void)presentNextController:(UIViewController*)destination
{
    CGSize windowSize = self.view.window.bounds.size;
    UIImage * snapshot =[self getSnapshotFromCurWindow];
    UIImageView* backgroundImageView = [[UIImageView alloc] initWithImage:snapshot];
    backgroundImageView.frame =  CGRectMake(0, -windowSize.height, windowSize.width, windowSize.height);;
    [destination.view addSubview:backgroundImageView];
    [destination.view sendSubviewToBack:backgroundImageView];
//    destination backgroundImageView = backgroundImageView;
   
       
    [self presentViewController:destination animated:YES completion:nil];
    
    [destination.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        [UIView animateWithDuration:[context transitionDuration] animations:^{
            backgroundImageView.frame = CGRectMake(0, 0, windowSize.width, windowSize.height);
        }];
    } completion:nil];
}

- (BOOL)prefersStatusBarHidden
{
    return NO; //返回NO表示要显示，返回YES将hiden
}

@end
