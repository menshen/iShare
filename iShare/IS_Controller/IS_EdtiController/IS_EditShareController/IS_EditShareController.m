//
//  IS_EditShareController.m
//  iShare
//
//  Created by wusonghe on 15/4/15.
//  Copyright (c) 2015年 iShare. All rights reserved.
//

#import "IS_EditShareController.h"
#import "PhotoPickerTool.h"
#import "IS_TextView.h"
#import "IS_AccountModel.h"
#import "KVNProgress.h"

@interface IS_EditShareController ()
@property (weak,nonatomic)IBOutlet IS_TextView * textView;
@property (weak,nonatomic)IBOutlet UIButton * imgBtn;
@property (strong,nonatomic)UIImageView * loadingImgView;
@end

@implementation IS_EditShareController

- (instancetype)initWithCompleteBlock:(CompleteResultBlock)completeResultBlock
{
    self = [super init];
    if (self) {
        self.completeResultBlock = completeResultBlock;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];


    self.view.backgroundColor = Color(0, 0, 0, .2);
 
    [self setup];
}
#pragma mark - 

- (void)setup{
    [self setupTextView];
    [self setupImgBtn];
}
#pragma mark - 输入

-(void)setupTextView{
    self.textView.text = nil;
    self.textView.placeHolder = @"请输入你的分享语";
}

#pragma mark - 图片
- (void)setupImgBtn{
    self.imgBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.imgBtn addSubview:self.loadingImgView];
}
-(UIImageView *)loadingImgView{
    if (!_loadingImgView) {
        
        _loadingImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
        _loadingImgView.center = CGPointMake(_imgBtn.width/2, _imgBtn.height/2);
        _loadingImgView.userInteractionEnabled = YES;
        _loadingImgView.image = [UIImage imageNamed:UPLOAD_IMAGE];
        
    }
    return _loadingImgView;
}
-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    [_textView becomeFirstResponder];
}


- (void)dismiss{
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
}
- (IBAction)cancelAction:(id)sender {
    
    [self dismiss];
    
}
- (IBAction)confirmAction:(id)sender {
    
    
    self.caseModel.title = self.textView.text;
    self.caseModel.detailTitle = self.textView.text;
    if (self.completeResultBlock) {
        self.completeResultBlock(self.caseModel);
        [self dismiss];

    }
    
}
- (IBAction)uploadAction:(id)sender {
 
      WEAKSELF;
    [[PhotoPickerTool sharedPhotoPickerTool]showOnPickerViewControllerSourceType:UIImagePickerControllerSourceTypePhotoLibrary onViewController:self compled:^(UIImage *image, NSDictionary *editingInfo) {
        
        
        if ([IS_AccountModel getToken]) {
            NSDictionary * params = @{TOKEN:[IS_AccountModel getToken]};
            [KVNProgress showWithStatus:@"正在上传.."];
             [HttpTool upLoadimage:image path:UPLOAD_IMG_DATA param:params imageKey:PIC_KEY success:^(id result) {
                 self.caseModel.share_img = result[IMAGE_URL_KEY];
                 [weakSelf.imgBtn setImage:image forState:UIControlStateNormal];
                 _loadingImgView.hidden = YES;
                 [KVNProgress dismiss];

             } failure:^(NSError *error) {
                 _loadingImgView.hidden = NO;
                 [KVNProgress showError];

             }];
        }
       
        
    }];
}

-(IS_CaseModel *)caseModel{
    if (!_caseModel) {
        _caseModel = [[IS_CaseModel alloc]init];
        
    }
    return _caseModel;
}
@end
