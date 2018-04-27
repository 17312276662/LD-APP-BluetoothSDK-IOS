//
//  KeyNomalTableViewCell.h
//  TerminusUI
//
//  Created by Tom on 2017/6/16.
//  Copyright © 2017年 LL. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 @class 非分组cell
 */
@interface KeyNomalTableViewCell : UITableViewCell

/**
 设置cell 显示

 @param keyName 钥匙名称
 */
- (void)setCellName:(NSString * )keyName;

@end
