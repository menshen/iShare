//
//  FrameMarco.h
//  iShare
//
//  Created by wusonghe on 15/3/30.
//  Copyright (c) 2015年 iShare. All rights reserved.
//

#ifndef iShare_FrameMarco_h
#define iShare_FrameMarco_h

#pragma mark - **系统的**
#define IS_KEYBOARD_H_IOS7 216
#define IS_KEYBOARD_H_IOS8 250



#pragma mark - ** 一些控件的SIZE

#define IS_NAV_BAR_HEIGHT 65
#define IS_NAV_TOOLBAT_H 80
#define IS_MAIN_TABBAR_HEIGHT 45
#define IS_MAIN_TABBAR_NUM    3
#define IS_MAIN_TABBAR_ITEM_WIDTH  ScreenWidth/IS_MAIN_TABBAR_NUM



#pragma mark - ** UICollectionViewLayoutItemSize **
//1.制作见面卡片大小控制
#define IS_CARD_LAYOUT_WIDTH 40
#define IS_CARD_LAYOUT_HEIGHT 10
#define IS_CARD_ITEM_WIDTH  (ScreenWidth-IS_NAV_TOOLBAT_H)
#define IS_CARD_ITEM_HEIGHT (ScreenHeight-IS_NAV_BAR_HEIGHT-IS_NAV_TOOLBAT_H-IS_CARD_LAYOUT_HEIGHT*2)


#define IS_CARD_ZOOM_NUM 3
#define IS_CARD_LITTER_ITEM_WIDTH  (IS_CARD_ITEM_WIDTH)/IS_CARD_ZOOM_NUM
#define IS_CARD_LITTER_ITEM_HEIGHT (IS_CARD_ITEM_HEIGHT)/IS_CARD_ZOOM_NUM

//首页活动展示宏
#define IS_ACTIVITY_ITEM_WIDTH  ScreenWidth
#define IS_ACTIVITY_ITEM_HEIGHT 180

//展示排行视图
#define IS_SHOWRANK_ITEM_WIDTH  ScreenWidth
#define IS_SHOWRANK_ITEM_HEIGHT 70

///案例
#define IS_CASE_ITEM_WIDTH  (ScreenWidth/2-1)
#define IS_CASE_ITEM_HEIGHT (CASE_ITEM_WIDTH * 1.5)

/**
 *  模板选择器
 */
#define IS_TEMPLATE_ITEM_WIDTH  (ScreenWidth/3 -10)
#define IS_TEMPLATE_ITEM_HEIGHT (IS_TEMPLATE_ITEM_WIDTH * 1.5)
#endif
