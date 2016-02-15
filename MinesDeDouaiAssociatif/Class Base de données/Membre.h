//
//  Membre.h
//  MinesDeDouai
//
//  Created by Thomas Mac on 19/05/2015.
//  Copyright (c) 2015 Thomas Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Membre : NSObject

@property (nonatomic) int membre_id;
@property (nonatomic, strong) NSString* prenom;
@property (nonatomic, strong) NSString* nom;
@property (nonatomic, strong) NSString* email;
@property (nonatomic, strong) NSString* chambre;
@property (nonatomic, strong) NSString* telephone;
@property (nonatomic, strong) NSString* role;
@property (nonatomic, strong) NSString* residence;
@property (nonatomic, strong) NSString* avatar;

@end
