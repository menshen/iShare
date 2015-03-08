//
//  IS_TemplateController.m
//  iShare
//
//  Created by 伍松和 on 15/3/5.
//  Copyright (c) 2015年 iShare. All rights reserved.
//

#import "IS_TemplateCollectionController.h"
#import "IS_TemplateSheetView.h"
@interface IS_TemplateCollectionController ()

@property (weak, nonatomic) IBOutlet IS_TemplateSheetView *templateSheetView;
@property (weak, nonatomic) IBOutlet UICollectionView * collectionView;

@end

@implementation IS_TemplateCollectionController

- (void)viewDidLoad {
    [super viewDidLoad];
}
-(void)viewWillAppear:(BOOL)animated{
    
//    self.navigationController.
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self dismissViewControllerAnimated:YES completion:nil];

}


@end
