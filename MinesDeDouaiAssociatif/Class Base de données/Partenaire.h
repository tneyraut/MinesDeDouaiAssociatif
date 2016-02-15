//
//  Partenaire.h
//  MinesDeDouai
//
//  Created by Thomas Mac on 09/05/2015.
//  Copyright (c) 2015 Thomas Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Partenaire : NSObject

@property (nonatomic) int partenaire_id;
@property (nonatomic, strong) NSString* nom;
@property (nonatomic, strong) NSString* offre;
@property (nonatomic, strong) NSString* adresse;
@property (nonatomic, strong) NSString* siteweb;
@property (nonatomic, strong) NSString* telephone;
@property (nonatomic, strong) NSString* logo;

@end
