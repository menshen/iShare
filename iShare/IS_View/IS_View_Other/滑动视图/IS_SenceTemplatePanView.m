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
        
        self.tableView.contentInset =UIEdgeInsetsMake(0, 0, 0, 0);
        
        //1.默认
       [self addDefault];
        
     
        
        
      
    }
    return self;
    
}
-(void)addDefault{

    NSMutableArray * arrayM = [NSMutableArray array];
    [arrayM addObjectsFromArray:TEMPLATE_THEME_1];
    [arrayM addObjectsFromArray:TEMPLATE_THEME_2];
    [arrayM addObjectsFromArray:TEMPLATE_THEME_3];
    
    self.dataSource = arrayM;

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
-(void)templateScrollDidChange:(id)itemData{
    
    if ([itemData isKindOfClass:[IS_SenceTemplateModel class]]) {
        IS_SenceTemplateModel * last_Template = itemData;
       [self clearByIndexPath:last_Template];
        //
    }
    
    
}

/*
 
 if (indexPath.row==0) {
 self.dataSource = [NSMutableArray arrayWithArray:List_Sence_Array_1];
 [tableView reloadData];
 
 return;
 
 }else if (indexPath.row==1){
 
 self.dataSource = [NSMutableArray arrayWithArray:List_Array_1];
 [tableView reloadData];
 
 return;
 }
 */
#pragma mark -点击
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
  
    
//    
    if (self.dataSource[indexPath.row]) {
        [self clearByIndexPath:indexPath];
        IS_SenceTemplatePanModel * senceTemplatePanModel =self.dataSource[indexPath.row];
        if ([self.delegate respondsToSelector:@selector(IS_SenceTemplatePanViewDidSelectItem:userinfo:)]) {
            [self.delegate IS_SenceTemplatePanViewDidSelectItem:senceTemplatePanModel userinfo:nil];
        }
        
    }

    
}

#pragma mark - 清除并添加
-(void)clearByIndexPath:(id)itemData{

    
    if ([itemData isKindOfClass:[NSIndexPath class]]) {
        
        NSIndexPath * indexPath = itemData;
        
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
    }else if ([itemData isKindOfClass:[IS_SenceTemplateModel class]]){
    
        IS_SenceTemplateModel * targetTemplateModel = itemData;
       __block NSInteger cur_row=0;
        [self.dataSource enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            IS_SenceTemplatePanModel * last_Template =obj;
            if (last_Template.s_template_style==targetTemplateModel.s_template_style&&last_Template.s_sub_template_style==targetTemplateModel.s_sub_template_style) {
                
                last_Template.is_selected=YES;
                IS_SenceTemplatePanModel * litter_template_model = self.dataSource[idx];
                litter_template_model.is_selected=YES;
                cur_row=idx;
                [self.dataSource replaceObjectAtIndex:idx withObject:litter_template_model];
                
            }else{
                last_Template.is_selected=NO;
            }
        }];
        
        NSIndexPath * curIndexPath = [NSIndexPath indexPathForRow:cur_row inSection:0];
        [self.tableView scrollToRowAtIndexPath:curIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        [self.tableView reloadData];
        
        
    }
    
    
   
}

@end
