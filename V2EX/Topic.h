//
//  Topic.h
//  V2ex
//
//  Created by 晓萌 王 on 12-2-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Topic : NSObject

@property (nonatomic, assign) NSUInteger topicId;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *userNameId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *createdTime;
@property (nonatomic, assign) NSUInteger replies;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
