

#import "UzysAssetsPickerController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>

#import "IS_SenceCreateController.h"
#import "IS_ShareMenuController.h"
#import "IS_SenceTemplateModel.h"
#import "IS_CardCollectionView.h"
#import "IS_TemplateSheetView.h"


#import "UIImage+ImageEffects.h"
#import "UIWindow+JJ.h"
#import "IS_SenceGirdController.h"
#import "IS_SenceEditTool.h"
#import "IS_TemplateCollectionController.h"
#import "IS_SenceCollectionController.h"
#import "IS_BottomEditView.h"
#import "KVNProgress.h"


@interface IS_SenceCreateController ()<UzysAssetsPickerControllerDelegate,IS_SenceGirdControllerDelegate,
IS_CardCollectionViewDelegate,IS_TemplateCollectionControllerDelegate>




/**
  滚动视图
 */
@property (nonatomic,weak)IBOutlet IS_CardCollectionView * collectionView;

/**
 * 选择条
 */
@property (strong, nonatomic)  UIPageControl *sence_pageControl;

@property (weak, nonatomic) IBOutlet UIView *bottomView;



@end

@implementation IS_SenceCreateController
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [UIApplication sharedApplication].statusBarHidden = NO;

}
- (void)viewDidLoad {

    
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor =kColor(244, 244, 244);//[UIColor redColor];// kColor(240, 240, 240);


    //1.加载子视图
    [self setupSubview];
}

#pragma mark - 视图初始化
- (void)setupSubview{
    
    [self setupHeaderViews];

    
    //1.
    [self setupSenceSubView];

    //2.
    [self setupBottomView];
    
}
//#pragma mark -加载
#pragma mark -加载视图
-(void)setupSenceSubView{
    
    //A.
    
 
    
    self.collectionView.collection_delegate = self;
    [self.collectionView addDefaultWithSenceType:_senceModel.sence_style
                                    SubSenceType:_senceModel.sence_sub_type
                                       ExistData:_senceModel.sence_template_array];

    
    
    
}
#pragma mark - A.头部

//#import "UIButton+JJ.h"
-(void)setupHeaderViews{
  
//    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTitle:@"返回" themeColor:kColor(44, 166,255) target:self action:@selector(backToRoot:)];
    
    //0.标题
    self.title  =@"编辑";

}
#pragma mark  -底部视图
- (void)setupBottomView{
    
    CGRect rect = CGRectMake(0, ScreenHeight-50, ScreenWidth, 50);
    IS_BottomEditView * editView = [[IS_BottomEditView alloc]initWithFrame:rect btnBlock:^(id result) {
        if (!result) {
            return;
        }else{
            UIButton * btn = result;
            IS_BottomEditViewButtonType type = btn.tag;
            switch (type) {
                case IS_BottomEditViewButtonTypeTemplate:
                {
                    [self jumpToTemplateSheetAction:btn];
                break;
                }
                case IS_BottomEditViewButtonTypeMenu:
                {
                    [self jumpToMenuAction:btn];
                    break;
                }
                 case IS_BottomEditViewButtonTypeAdd:
                {
                    break;
                }
                case IS_BottomEditViewButtonTypeTrash:
                {
                    break;
                }
                case IS_BottomEditViewButtonTypeMusic:
                {
                    break;
                }
                case IS_BottomEditViewButtonTypeDone:
                {
                    [self createSence:nil];
                    break;
                }
                    
                    
                    
                default:
                    break;
            }
        }
       
        
        
        
    }];
    [self.view addSubview:editView];
    
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
    templateController.delegate =self;
    [self presentNextController:templateController];
  

}
-(void)createSence:(UIBarButtonItem*)item{
    
    
    IS_ShareMenuController * shareMenu = [[IS_ShareMenuController alloc]init];
//    [self.navigationController pushViewController:shareMenu animated:YES];
    [self presentViewController:shareMenu animated:YES completion:^{
        
       //        [IS_SenceEditTool saveSenceModelWithSenceID:nil TemplateArray:self.collectionView.senceDataSource SubTemplateDataArray:nil CompleteBlock:nil];
    }];
    
    
    
}
#pragma mark  -保存并且离开


-(void)backToRoot:(UIBarButtonItem*)item{

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
     

       }];
    
    

 
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
    picker.maximumNumberOfSelectionPhoto = 9;
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
                UIImage  *image = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullResolutionImage]];
                NSData * imageData=UIImageJPEGRepresentation(image, 0.000000001);
                [arrayM addObject:[UIImage imageWithData:imageData]];
                [assetURLM addObject:representation.defaultRepresentation.url.absoluteString];

                if (arrayM.count==assets.count) {
                    [self.collectionView insertAssetIntoEditView:arrayM WithAssetURLArray:assetURLM];

                }
            } failureBlock:nil];
            
            

        }
    }];
//    [self IS_SenceImagePanViewDidInsertItems:arrayM];


    
    
}

#pragma mark ------------------------------代理方法--------------------------------------


#pragma mark - 点击切换模板
-(void)IS_TemplateCollectionControllerDidSelectItem:(id)result{
    
    [self.collectionView collectionToChangeTemplate:result];
}

#pragma mark - IS_CardCollectionVoewDelegate

/**
 *  当点击事件后
 */
- (void)IS_CardCollectionViewDidSelectImageViewItem:(id)itemData
                                           userinfo:(NSDictionary*)userinfo{
   
    if ([itemData img]) {
        //
    }else{
        [self pickImageAndVideo];
    }
    
}



-(void)IS_SenceGirdControllerDidUpdate:(id)itemData{
    
    if (!itemData) {
    }else{
        NSIndexPath * cur_indexPath = itemData;
        self.collectionView.currentIndexPath=cur_indexPath;
        [self.collectionView scrollToItemAtIndexPath:cur_indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];

    }
       [self.collectionView reloadData];
}






#pragma mark - 把当前背景截图
-(UIImage*)getSnapshotFromCurWindow:(UIView*)view{

    CGSize windowSize = view.window.bounds.size;
    UIGraphicsBeginImageContextWithOptions(windowSize, YES, 2.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [view.window.layer renderInContext:context];
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
    UIImage * snapshot =[self getSnapshotFromCurWindow:self.view];
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

@end
