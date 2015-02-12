
#import "POP.h"
#import "UzysAssetsPickerController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>

#import "IS_SenceCreateController.h"
#import "IS_SenceTemplateModel.h"




#import "IS_CardCollectionView.h"
#import "IS_SenceTemplatePanView.h"
#import "IS_SenceImagePanView.h"


#import "UIImage+ImageEffects.h"
#import "UIWindow+JJ.h"
#import "IS_SenceGirdController.h"
#import "IS_SenceEditTool.h"


@interface IS_SenceCreateController ()<UzysAssetsPickerControllerDelegate,IS_SenceGirdControllerDelegate,
IS_CardCollectionViewDelegate,IS_SenceImagePanViewDelegate,IS_SenceTemplatePanViewDelegate>



/**
 *  模板选择视图
 */
@property (nonatomic,strong)IS_SenceTemplatePanView * senceTemplatePanView;
/**
 图片集选择视图
 */
@property (nonatomic,strong)IS_SenceImagePanView * senceImagePanView;
/**
  滚动视图
 */
@property (nonatomic,strong) IS_CardCollectionView * collectionView;
/**
 *  底部视图
 */
@property (strong, nonatomic)  UIView *sence_tool_view;
/**
 * 选择条
 */
@property (strong, nonatomic) IBOutlet UIView *senceSelectBar;
/**
 *  上个选择 btn
 */
@property (strong,nonatomic)UIButton * last_selected_btn;
/**
    按钮数组
 */
@property (strong,nonatomic)NSMutableArray  * selected_btn_array;

@end

@implementation IS_SenceCreateController
-(instancetype)initWithCreateType:(IS_SenceCreateType)type{

    if (self = [super init]) {
        self.senceCreateType =type;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    

    //1.加载子视图
    [self loadSenceSubView];

 

    
   [self showTemplatePan:nil];


    

  

}
//#pragma mark -加载
#pragma mark -加载视图
-(void)loadSenceSubView{
    
    //A.
    [self addHeaderViews];
    
    //B
    [self addCenterViews];
    
  
    
    //D.
    [self addBottomPanViews];
    
    
    
    
    
}
#pragma mark - A.头部

-(void)addHeaderViews{
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTitle:@"生成" themeColor:kColor(44, 166,255) target:self action:@selector(createSence:)];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTitle:@"返回" themeColor:kColor(44, 166,255) target:self action:@selector(backToRoot:)];
    
    //0.标题
    self.title  =(self.senceCreateType==IS_SenceCreateTypeFristSence)?@"场景编辑":@"编辑";

}

#pragma mark - B.卡片内容
-(void)addCenterViews{
    
    [self.view addSubview:self.collectionView];
    [self.collectionView addDefaultSenceTemplateData:self.senceModel.sence_template_array];


}

#pragma mark -  C.Pan 视图
-(void)addBottomPanViews{
    
    //0.
    [self.view addSubview:self.sence_tool_view];
    //1.
    [self.sence_tool_view addSubview:self.senceSelectBar];
    
    //2.模板 PAN
    [self.sence_tool_view addSubview:self.senceTemplatePanView];
    
    
    //3.照片PAN
    [self.sence_tool_view addSubview:self.senceImagePanView];
    
}
#pragma mark - 边栏点击事件
-(NSMutableArray *)selected_btn_array{

    if (!_selected_btn_array) {
        _selected_btn_array = [NSMutableArray array];
    }
    return _selected_btn_array;
    
}
-(void)btnSelectAction:(UIButton*)btn{
    
    _last_selected_btn.selected = NO;
    btn.selected = !btn.selected;
    _last_selected_btn = btn;
  
    if (btn.tag==0) {
        [self showTemplatePan:btn];
    }else{
        [self showImagePan:btn];
    }
    
}

#pragma mark -展示模板
-(void)showTemplatePan:(UIButton*)btn{

    
    if (!btn) {
        UIButton * t_btn = _selected_btn_array[0];
        [self btnSelectAction:t_btn];
    }
    
    
    [UIView animateWithDuration:.2 delay:0 options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
        
        
        self.senceImagePanView.hidden=YES;
        self.senceTemplatePanView.hidden=NO;

    } completion:^(BOOL finished) {
        //
    }];

}
-(void)showImagePan:(UIButton*)btn{
    
    if (!btn) {
        UIButton * i_btn = _selected_btn_array[1];
        [self btnSelectAction:i_btn];
    }
   
   
    
    [UIView animateWithDuration:.2 delay:0 options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
        
        self.senceImagePanView.hidden=NO;
        self.senceTemplatePanView.hidden=YES;
      
    } completion:^(BOOL finished) {
        if (self.senceImagePanView.dataSource.count<2) {
            [self pickImageAndVideo];
        }else{
        
        }
    }];
    
}
#pragma mark - 内容视图
-(IS_CardCollectionView *)collectionView{
    
    if (!_collectionView) {
        CGRect rect =  CGRectMake(0, 60, self.view.width, self.view.height-120-50);
        IS_CardLayout * cardLayout = [[IS_CardLayout alloc]init];
        _collectionView = [[IS_CardCollectionView alloc]initWithFrame:rect collectionViewLayout:cardLayout];
        _collectionView.collection_delegate=self;
    }
    return _collectionView;
}
#pragma mark - 底部视图
-(UIView *)sence_tool_view{

    if (!_sence_tool_view) {
        _sence_tool_view = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.height-100, self.view.width, 100)];
    }
    return _sence_tool_view;
    
}

#pragma mark -模板视图
-(IS_SenceTemplatePanView *)senceTemplatePanView{
    
    if (!_senceTemplatePanView) {
        _senceTemplatePanView = [[IS_SenceTemplatePanView alloc]initWithFrame:CGRectMake(30, 0, self.sence_tool_view.width-30, self.sence_tool_view.height)];
        _senceTemplatePanView.delegate =self;
    }
    return _senceTemplatePanView;
}
#pragma mark -图片视图
-(IS_SenceImagePanView *)senceImagePanView{
    if (!_senceImagePanView) {
        _senceImagePanView = [[IS_SenceImagePanView alloc]initWithFrame:CGRectMake(30, 0, self.sence_tool_view.width-30, self.sence_tool_view.height)];
        [_senceImagePanView addDefaultImgaeData:self.senceModel.image_array];
        _senceImagePanView.delegate =self;
    }
    return _senceImagePanView;

}
-(UIView *)senceSelectBar{
    
    if (!_senceSelectBar) {
        _senceSelectBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 30, 100)];
        
        for (int i =0; i<2; i++) {
            UIButton * selected_btn = [[UIButton alloc]initWithFrame:CGRectMake(0, self.senceSelectBar.height/2*i, self.senceSelectBar.width, self.senceSelectBar.height/2)];
            selected_btn.tag = i;
            //0.文字
            NSString * title = (i==0)?@"模":@"图";
            [selected_btn setTitle:title forState:UIControlStateNormal];
            [selected_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            //1.背景
            [selected_btn setBackgroundImage:[UIImage imageNamed:@"sence_slice_drak"] forState:UIControlStateNormal];
            [selected_btn setBackgroundImage:[UIImage imageNamed:@"sence_slice_blue"] forState:UIControlStateSelected];
            
            //2.点击
            [selected_btn addTarget:self action:@selector(btnSelectAction:) forControlEvents:UIControlEventTouchUpInside];
            
            //3.
            
            
            //4.
            [self.selected_btn_array addObject:selected_btn];
            
            
            [_senceSelectBar addSubview:selected_btn];
            
        }
        
        
    }
    return _senceSelectBar;
    
}

-(void)createSence:(UIBarButtonItem*)item{
    
//    IS_SenceGirdController * GirdCtrl = [[IS_SenceGirdController alloc]init];
//    GirdCtrl.delegate=self;
//    GirdCtrl.sence_array = self.collectionView.senceDataSource;
//    [self presentNextController:GirdCtrl];
    
    [self.navigationController popViewControllerAnimated:YES];
}


// Do any additional setup after loading the view, typically from a nib.
#pragma mark  -保存并且离开


-(void)backToRoot:(UIBarButtonItem*)item{

    
  
//

    UIAlertView * a=[[UIAlertView alloc]initWithTitle:@"" message:@"是否保存编辑" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
       [a showWithCompletionHandler:^(NSInteger buttonIndex) {
           if (buttonIndex==1) {
               
               [IS_SenceEditTool saveSenceModelWithSenceID:self.senceModel.sence_id
                                             TemplateArray:self.collectionView.senceDataSource
                                      SubTemplateDataArray:self.senceImagePanView.dataSource
                                             CompleteBlock:^(id results) {
                             if (results) {
                                 [UIWindow dismissWithHUD];

                                 [self.navigationController popViewControllerAnimated:YES];
                             }
                             
                         }];
               
           }else{
               [self.navigationController popViewControllerAnimated:YES];

           }

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
/**
 *  点击单一图片视图
 */
-(void)IS_CardCollectionViewDidSelectImageViewItem:(id)itemData userinfo:(NSDictionary *)userinfo{
    [self showImagePan:nil];
    //0.直接选择图片
    if (self.senceImagePanView.dataSource.count<2) {
    }else {
        [self.senceImagePanView bigImageDidActionImagePan:itemData];
    }
}
-(void)IS_CardCollectionViewDidEndDecelerating:(id)itemData userinfo:(NSDictionary *)userinfo{
   
        [self showTemplatePan:nil];
        [self.senceImagePanView templateDidChangeClearIndexPath:itemData];
        [self.senceTemplatePanView templateScrollDidChange:itemData];
    
   
}
-(void)IS_CardCollectionViewDidEndPinch:(id)itemData{

    
    IS_SenceGirdController * GirdCtrl = [[IS_SenceGirdController alloc]init];
    GirdCtrl.delegate=self;
    GirdCtrl.sence_array = self.collectionView.senceDataSource;
    [self presentNextController:GirdCtrl];
}

#pragma mark - IS_SenceImagePanViewDelegate

-(void)IS_SenceImagePanViewDidSelectItem:(id)itemData userinfo:(NSDictionary *)userinfo{
    if (!itemData) {
        [self pickImageAndVideo];

    }else{
        [self.collectionView insertAssetIntoEditViewDidthumbnailImageAction:itemData userInfo:userinfo];

    }
}
-(void)IS_SenceImagePanViewDidInsertImageItems:(NSMutableArray*)itemArray
                                      urlArray:(NSMutableArray*)urlArray{
    [self.senceImagePanView insertSenceImageArray:itemArray WithAssetURLArray:urlArray];
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
    
    snapshot = [snapshot applyBlurWithRadius:35
                                   tintColor:[UIColor clearColor]
                       saturationDeltaFactor:.45
                                   maskImage:nil];
    
    return snapshot;
}
#pragma mark -背景蒙板
- (void)presentNextController:(IS_SenceGirdController*)destination
{
    CGSize windowSize = self.view.window.bounds.size;
    UIImage * snapshot =[self getSnapshotFromCurWindow];
    UIImageView* backgroundImageView = [[UIImageView alloc] initWithImage:snapshot];
    backgroundImageView.frame =  CGRectMake(0, -windowSize.height, windowSize.width, windowSize.height);;
    [destination.view addSubview:backgroundImageView];
    [destination.view sendSubviewToBack:backgroundImageView];
    destination.backgroundImageView = backgroundImageView;
   
       
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
