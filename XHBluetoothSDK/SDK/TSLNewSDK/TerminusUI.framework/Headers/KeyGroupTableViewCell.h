//
//  KeyGroupTableViewCell.h
//  TerminusUI
//
//  Created by Tom on 2017/6/16.
//  Copyright © 2017年 LL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KeyCardModel.h"
typedef void(^TSLTouchBlock)(id obj);


/**
 @class 分组cell
 */
@interface KeyGroupTableViewCell : UITableViewCell

/**
 点击事件
 */
@property (nonatomic,copy)TSLTouchBlock onTouchBlock;



/**
 设置cell 数据源

 @param blue 当前蓝牙分组数据源
 */
- (void)setCellViewData:(KeyBlueModel *)blue;
@end




/**
 @class UITableViewHeaderFooterView 设置headerView
 */
@interface KeyHeaderFootView : UITableViewHeaderFooterView

/**
 UITableViewHeaderFooterView 类型

 @param type 分类类型
 @param infor 地理位置信息
 */
- (void)setGroupHeaderViewType:(NSUInteger) type villageInfor:(NSString *)infor;

@end
