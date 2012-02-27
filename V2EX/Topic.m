//
//  Topic.m
//  V2ex
//
//  Created by 晓萌 王 on 12-2-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Topic.h"

@implementation Topic

@synthesize topicId = _topicId;
@synthesize userName = _userName;
@synthesize title = _title;
@synthesize content = _content;
@synthesize createdTime = _createdTime;
@synthesize replies = _replies;
@synthesize userNameId = _userNameId;


- (id)initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [super init])
    {
        self.topicId = [[dictionary objectForKey:@"id"] intValue];
        self.userName = [dictionary valueForKeyPath:@"member.username"];
        self.userNameId = [dictionary valueForKeyPath:@"member.id"];
        self.title = [dictionary objectForKey:@"title"];    
        self.content = [dictionary objectForKey:@"content"];
        self.createdTime = [dictionary objectForKey:@"created"];
        self.replies = [[dictionary objectForKey:@"replies"] intValue];
        
    }
    return self;
}

@end
