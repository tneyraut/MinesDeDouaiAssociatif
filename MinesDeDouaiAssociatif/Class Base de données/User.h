//
//  User.h
//  MinesDeDouai
//
//  Created by Thomas Mac on 09/05/2015.
//  Copyright (c) 2015 Thomas Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (nonatomic) int user_id;
@property (nonatomic, strong) NSString* login;
@property (nonatomic, strong) NSString* chambre;
@property (nonatomic, strong) NSString* residence;
@property (nonatomic, strong) NSString* prenom;
@property (nonatomic, strong) NSString* nom;
@property (nonatomic, strong) NSString* telephone;
@property (nonatomic, strong) NSString* promotion;
@property (nonatomic, strong) NSString* avatar;
@property (nonatomic) BOOL respo_notifications_mobiles;
@property (nonatomic) BOOL administrateur;
@property (nonatomic) BOOL airMember;

@end
