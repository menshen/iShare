//
//  IS_SenceTemplatePanView.m
//  iShare
//
//  Created by 伍松和 on 15/1/22.
//  Copyright (c) 2015年 iShare. All rights reserved.
//

#import "IS_SenceTemplatePanView.h"
#import "IS_SenceTemplatePanModel.h"
#import "IS_SenceTempateItemCell.h"
#import "IS_SenceTemplateModel.h"

#define IS_SenceCreateViewDidChangeTemplate @"IS_SenceCreateViewDidChangeTemplate"


@implementation IS_SenceTemplatePanView

-(void)dealloc{[[NSNotificationCenter defaultCenter]removeObserver:self];}
-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.tableView.contentInset =UIEdgeInsetsMake(-40, 0, 0, 0);
        
        //1.默认
       [self addDefault];
        
        //2.模板改变
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(templateToPanView:) name:COLLECTION_VIEW_SCROLL_CHANGE_TEMPLATE_PAN object:nil];
        
      
    }
    return self;
    
}
-(void)addDefault{

    self.dataSource = [NSMutableArray arrayWithArray:List_Array_1];
    IS_SenceTemplatePanModel * s =[self.dataSource firstObject];
    s.is_selected=YES;

}
-(void)setDataSource:(NSMutableArray *)dataSource{

    _dataSource =dataSource;
    //1.
    NSMutableArray * arrayM = [NSMutableArray array];
    for (NSDictionary * dic in dataSource) {
        IS_SenceTemplatePanModel * senceTemplatePanModel = [[IS_SenceTemplatePanModel alloc]initWithDictionary:dic];
        [arrayM addObject:senceTemplatePanModel];
    }
    _dataSource =arrayM;

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * CellIdentifier= @"sence_litter_cell";
    [UITableViewCell configureCellWithClass:[IS_SenceTempateItemCell class] WithCellID:CellIdentifier WithTableView:tableView];
    IS_SenceTempateItemCell * cell = (IS_SenceTempateItemCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.senceTemplatePanModel=self.dataSource[indexPath.row];
    cell.contentView.transform = CGAffineTransformMakeRotation(M_PI / 2);
    
    return cell;
    
}
#pragma mark -当下一页->模板改变
-(void)templateToPanView:(NSNotification*)notification{
  
    
    if ([notification.userInfo[IS_NOTIFICATION_OPTION] isEqualToString:COLLECTION_VIEW_SCROLL_CHANGE_TEMPLATE_PAN]) {
        if ([notification.object isKindOfClass:[IS_SenceTemplateModel class]]) {
            IS_SenceTemplateModel * last_Template = notification.object;
            NSIndexPath * indexPath = [NSIndexPath indexPathForRow:last_Template.s_sub_template_style inSection:0];
            [self clearByIndexPath:indexPath];
//
        }
    }

}

#pragma mark -点击
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
//    
    if (self.dataSource[indexPath.row]) {
        [self clearByIndexPath:indexPath];
        IS_SenceTemplatePanModel * senceTemplatePanModel =self.dataSource[indexPath.row];
        NSDictionary * user_info = @{IS_NOTIFICATION_OPTION:TEMPLATE_TO_COLLECTION_VIEW_BY_TAP};
        [[NSNotificationCenter defaultCenter]postNotificationName:TEMPLATE_TO_COLLECTION_VIEW_BY_TAP object:senceTemplatePanModel userInfo:user_info];
        
    }

    
}

#pragma mark - 清除并添加
-(void)clearByIndexPath:(NSIndexPath*)indexPath{

    
    [self.dataSource enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        IS_SenceTemplatePanModel * last_Template =obj;
        if (idx==indexPath.row) {
            last_Template.is_selected=YES;
            IS_SenceTemplatePanModel * litter_template_model = self.dataSource[indexPath.row];
            litter_template_model.is_selected=YES;
            [self.dataSource replaceObjectAtIndex:indexPath.row withObject:litter_template_model];
            
        }else{
            last_Template.is_selected=NO;
        }
    }];
    
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    [self.tableView reloadData];
}

@end
