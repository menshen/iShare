
#import "POP.h"
#import "UzysAssetsPickerController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>

#import "IS_SenceCreateController.h"
#import "IS_SenceTemplateModel.h"




#import "IS_SenceTemplatePanView.h"
#import "IS_SenceImagePanView.h"
#import "IS_SenceCreateView.h"

#import "Masonry.h"


@interface IS_SenceCreateController ()<UzysAssetsPickerControllerDelegate>
/**
 *  模板选择视图
 */
@property (nonatomic,strong)IS_SenceTemplatePanView * senceTemplatePanView;
/**
 图片集选择视图
 */
@property (nonatomic,strong)IS_SenceImagePanView * senceImagePanView;
/**
 选择条
 */
@property (nonatomic,strong)IS_SenceCreateView * senceCreateView;

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
    
    //1.加载子视图
    [self loadSenceSubView];

    
    //2.初始化展示数据
    [self showTemplatePan];
    self.senceTemplatePanView.dataSource = [NSMutableArray arrayWithArray:List_Array_1];
    [self.senceTemplatePanView.tableView reloadData];
    [self.senceImagePanView.tableView reloadData];
    
  

}
#pragma mark -通知

//-(void)viewDidLayoutSubviews{
//
//        [super viewDidLayoutSubviews];
//    
//
//    //1.模板 pan
//  
//    
//}
#pragma mark -加载视图
-(void)loadSenceSubView{
    
    //A.
    [self addHeaderViews];
    
    //B
    [self addContentViews];
    
    //C.
    [self addBottomPanViews];
    
    
}
#pragma mark - A.头部

-(void)addHeaderViews{
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTitle:@"生成" themeColor:kColor(44, 166,255) target:self action:@selector(createSence:)];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTitle:@"返回" themeColor:kColor(44, 166,255) target:self action:@selector(backToRoot:)];
    
    //0.标题
    self.title  =(self.senceCreateType==IS_SenceCreateTypeFristSence)?@"场景编辑":@"编辑";
    self.navigationItem.titleView = self.sence_segmented_control;//[[[NSBundle mainBundle]loadNibNamed:@"IS_SenceCreateController" owner:self options:nil]lastObject];
    
    //3。视图
    [self.sence_segmented_control setSelectedSegmentIndex:0];
}

#pragma mark - B.卡片内容
-(void)addContentViews{

    [self.sence_content_view addSubview:self.senceCreateView];
    
}

#pragma mark - C.Pan 视图
-(void)addBottomPanViews{
    
    
    //1.模板 PAN
    [self.sence_tool_view addSubview:self.senceTemplatePanView];
    
    
    //2.照片PAN
    [self.sence_tool_view addSubview:self.senceImagePanView];
    [self.senceImagePanView selectPanItem:^(id result) {
        
        if ([result isKindOfClass:[NSIndexPath class]]) {
            [self pickImageAndVideo];
        }
    }];
   
}


#pragma mark - 展开模板/图片集

- (IBAction)selectAction:(id)sender {
    
    UISegmentedControl *segmentedControl = sender;
    switch (segmentedControl.selectedSegmentIndex) {
        case 0:
            //展开模板
            [self showTemplatePan];
            break;
        case 1:
            //展开图片
             [self showImagePan];
            break;
            
        default:
            break;
    }
   
}
#pragma mark -展示模板
-(void)showTemplatePan{

    

    [UIView animateWithDuration:.2 delay:0 options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
        
        
        self.senceImagePanView.hidden=YES;
        self.senceTemplatePanView.hidden=NO;

    } completion:^(BOOL finished) {
        //
    }];

}
-(void)showImagePan{
    
    

    [UIView animateWithDuration:.2 delay:0 options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
        
        self.senceImagePanView.hidden=NO;
        self.senceTemplatePanView.hidden=YES;
      
    } completion:^(BOOL finished) {
        //
    }];
    
}
#pragma mark - 底部视图
#pragma mark - 内容视图

#pragma mark - 展示图片
-(IS_SenceCreateView *)senceCreateView{
    
    if (!_senceCreateView) {
        _senceCreateView =[[IS_SenceCreateView alloc]initWithFrame:self.sence_content_view.bounds];
        _senceCreateView.userInteractionEnabled=YES;
        
    }
    return _senceCreateView;

}
#pragma mark -模板视图
-(IS_SenceTemplatePanView *)senceTemplatePanView{
    
    if (!_senceTemplatePanView) {
        _senceTemplatePanView = [[IS_SenceTemplatePanView alloc]initWithFrame:self.sence_tool_view.bounds];
    }
    return _senceTemplatePanView;
}
#pragma mark -图片视图
-(IS_SenceImagePanView *)senceImagePanView{
    if (!_senceImagePanView) {
        _senceImagePanView = [[IS_SenceImagePanView alloc]initWithFrame:self.sence_tool_view.bounds];
    }
    return _senceImagePanView;

}

-(void)createSence:(UIBarButtonItem*)item{

}


// Do any additional setup after loading the view, typically from a nib.



-(void)backToRoot:(UIBarButtonItem*)item{

    
    
    
    //
   if (self.senceCreateType==IS_SenceCreateTypeFristSence) {
       [self.navigationController popViewControllerAnimated:YES];
   }else{
       UIAlertView * a=[[UIAlertView alloc]initWithTitle:@"" message:@"结束编辑吗" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
       [a showWithCompletionHandler:^(NSInteger buttonIndex) {
           if (buttonIndex==1) {
               [self.navigationController popViewControllerAnimated:YES];

           }
       }];
   }
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
    [assets enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
         if([[obj valueForProperty:@"ALAssetPropertyType"] isEqualToString:@"ALAssetTypePhoto"])
        {
            ALAsset *representation = obj;
            UIImage *img = [UIImage imageWithCGImage:representation.defaultRepresentation.fullResolutionImage
                                               scale:representation.defaultRepresentation.scale
                                         orientation:(UIImageOrientation)representation.defaultRepresentation.orientation];
            [arrayM addObject:img];
            
        }

    }];
    
    [self.senceImagePanView insertSenceImageArray:arrayM];

    
    
}

@end
