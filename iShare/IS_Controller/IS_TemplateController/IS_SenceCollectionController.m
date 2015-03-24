//
//  IS_SenceCollectionController.m
//  iShare
//
//  Created by 伍松和 on 15/3/5.
//  Copyright (c) 2015年 iShare. All rights reserved.
//

#import "IS_SenceCollectionController.h"
#import "IS_SenceCreateController.h"
#import "IS_TemplateActonSheet.h"
@interface IS_SenceCollectionController ()
@end

@implementation IS_SenceCollectionController

-(void)viewDidLoad{

    [super viewDidLoad];
    self.collectionview.height-=100;
    self.view.backgroundColor = [UIColor clearColor];
    self.collectionview.backgroundColor = [UIColor clearColor];
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
   
    IS_SenceCreateController * sc = [[IS_SenceCreateController alloc]init];
    NSDictionary * dic = self.template_dataSource [indexPath.row];
    IS_SenceTemplatePanModel * s =[[IS_SenceTemplatePanModel alloc]initWithDictionary:dic];
    IS_SenceModel * cur_senceModel = [[IS_SenceModel alloc]init];
    cur_senceModel.sence_style=s.type;
    cur_senceModel.sence_sub_type = s.sub_type;
    sc.senceModel=cur_senceModel;
    [self.navigationController pushViewController:sc animated:YES];
    
}
#pragma mark - ...
-(void)addDefault{
    
    NSMutableArray * arrayM = [NSMutableArray array];
    [arrayM addObjectsFromArray:SENCE_1_ARRAY];
    self.template_dataSource = arrayM;
        
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
@end
