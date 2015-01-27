//
//  IS_SenceTemplatePanView.m
//  iShare
//
//  Created by 伍松和 on 15/1/22.
//  Copyright (c) 2015年 iShare. All rights reserved.
//

#import "IS_SenceTemplatePanView.h"
#import "IS_SenceModel.h"
#import "IS_SenceTempateItemCell.h"

#define IS_SenceCreateViewDidChangeTemplate @"IS_SenceCreateViewDidChangeTemplate"


@implementation IS_SenceTemplatePanView

-(void)setDataSource:(NSMutableArray *)dataSource{

    _dataSource =dataSource;
    //1.
    NSMutableArray * arrayM = [NSMutableArray array];
    for (NSDictionary * dic in dataSource) {
        IS_SenceTemplateModel * senceTemplateModel = [[IS_SenceTemplateModel alloc]initWithDictionary:dic];
        [arrayM addObject:senceTemplateModel];
    }
    _dataSource =arrayM;

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * CellIdentifier= @"sence_litter_cell";
    [UITableViewCell configureCellWithClass:[IS_SenceTempateItemCell class] WithCellID:CellIdentifier WithTableView:tableView];
    IS_SenceTempateItemCell * cell = (IS_SenceTempateItemCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.senceTemplateModel=self.dataSource[indexPath.row];
    cell.contentView.transform = CGAffineTransformMakeRotation(M_PI / 2);
    
    return cell;
    
}
#pragma mark -点击
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    if (self.dataSource[indexPath.row]) {
        IS_SenceTemplateModel * senceTemplateModel =self.dataSource[indexPath.row];
        [[NSNotificationCenter defaultCenter]postNotificationName:IS_SenceCreateViewDidChangeTemplate object:senceTemplateModel];
        
    }
    
//    if (self.sencePanItemDidSelectBlock) {
//        if (self.dataSource[indexPath.row]) {
//            IS_SenceTemplateModel * senceTemplateModel =self.dataSource[indexPath.row];
//            [[NSNotificationCenter defaultCenter]postNotificationName:IS_SenceCreateViewDidChangeTemplate object:senceTemplateModel];
//
//            self.sencePanItemDidSelectBlock(senceTemplateModel);
//        }
//    }
    
}
@end
