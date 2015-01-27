//
//  iShare_Marco.h
//  iShare
//
//  Created by 伍松和 on 15/1/13.
//  Copyright (c) 2015年 iShare. All rights reserved.
//

#ifndef iShare_iShare_Marco_h
#define iShare_iShare_Marco_h

#define temp_url    [[NSBundle mainBundle]URLForResource:@"iShare-Temp" withExtension:@"plist"]
#define temp_dic    [NSDictionary dictionaryWithContentsOfURL:temp_url]
#define temp_array_1  temp_dic[@"iShare_Edit_List"]
#define temp_array_2  temp_dic[@"iShare_Done_List"]
#define temp_array_3  temp_dic[@"iShare_Best_List"]


#define List_URL_1      [[NSBundle mainBundle]URLForResource:@"iShare_Template_List_1" withExtension:@"plist"]
#define List_DIC_1      [NSDictionary dictionaryWithContentsOfURL:List_URL_1]
#define List_Array_1    List_DIC_1[@"First_Template"]


#import "CategoryMarco.h"


///1.系统颜色

#define IS_SYSTEM_COLOR kColor(0, 157, 255)



//2.系统通知

#define IS_SenceCreateViewDidChangeTemplate @"IS_SenceCreateViewDidChangeTemplate"  //当模板改变时候

#define IS_SenceCreateViewDidChangeImage @"IS_SenceCreateViewDidChangeImage"        //当图片改变时候

#define IS_SenceCreateImageViewGestureNotification @"IS_SenceCreateImageViewGestureNotification" //手势在变化




#endif