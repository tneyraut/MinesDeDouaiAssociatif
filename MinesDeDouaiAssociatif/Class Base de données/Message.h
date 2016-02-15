//
//  Message.h
//  MinesDeDouaiAssociatif
//
//  Created by Thomas Mac on 09/09/2015.
//  Copyright (c) 2015 Thomas Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Message : NSObject

@property(nonatomic) int message_id;
@property(nonatomic) int author_id;
@property(nonatomic, strong) NSString *message;
@property(nonatomic, strong) NSString *date;

@end
