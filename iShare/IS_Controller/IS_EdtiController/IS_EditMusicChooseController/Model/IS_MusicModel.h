//
//  IS_MusicModel.h
//  iShare
//
//  Created by wusonghe on 15/4/7.
//  Copyright (c) 2015年 iShare. All rights reserved.
//

#import "IS_BaseModel.h"


typedef NS_ENUM(NSInteger, IS_MusicPlayState) {

    IS_MusicPlayStatePause,
    IS_MusicPlayStatePlaying,
    IS_MusicPlayStateStop,
};
@interface IS_MusicModel : IS_BaseModel
/**
 *  @brief "http://7vznnu.com2.z0.glb.qiniucdn.com/bgm/qinzi_4.mp3",

 */
@property (copy,nonatomic)NSString * musicurl;
/**
 *  @brief  猫耳朵音乐绘本系列
 */
@property (copy,nonatomic)NSString * src_name;
/**
 *  @brief  parents,lover,etc
 */

@property (copy,nonatomic)NSString * type;

@property (assign,nonatomic)IS_MusicPlayState playState;
@end
