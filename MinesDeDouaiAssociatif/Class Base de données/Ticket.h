//
//  Ticket.h
//  MinesDeDouaiAssociatif
//
//  Created by Thomas Mac on 08/09/2015.
//  Copyright (c) 2015 Thomas Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "User.h"

@interface Ticket : NSObject

@property(nonatomic) int ticket_id;
@property(nonatomic, strong) NSString *dateCreation;
@property(nonatomic) BOOL isPublic;
@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSString *labelType;
@property(nonatomic, strong) NSString *status;
@property(nonatomic, strong) User *createur;
@property(nonatomic, strong) User *airMember;

@end
