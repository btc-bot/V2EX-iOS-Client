//
//  TitleViewCell.h
//  V2ex
//
//  Created by 晓萌 王 on 12-2-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TitleViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *repliesLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIImageView *avatarImgView;

@end
