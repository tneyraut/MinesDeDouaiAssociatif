//
//  Association.h
//  MinesDeDouai
//
//  Created by Thomas Mac on 09/05/2015.
//  Copyright (c) 2015 Thomas Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

@interface Association : NSObject

@property (nonatomic) int association_id;
@property (nonatomic, strong) NSString* nom;
@property (nonatomic, strong) NSString* descrip;
@property (nonatomic, strong) NSString* type;
@property (nonatomic, strong) NSString* site;
@property (nonatomic, strong) NSString* alias;
@property (nonatomic, strong) NSString* logo;

@end
