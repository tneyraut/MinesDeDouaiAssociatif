//
//  Evenement.h
//  MinesDeDouai
//
//  Created by Thomas Mac on 09/05/2015.
//  Copyright (c) 2015 Thomas Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Evenement : NSObject

@property (nonatomic) int evenement_id;
@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSString* start;
@property (nonatomic, strong) NSString* end;
@property (nonatomic, strong) NSString* descrip;
@property (nonatomic, strong) NSString* lieu;
@property (nonatomic, strong) NSString* image;
@property (nonatomic) BOOL dejaInscrit;
@property (nonatomic) BOOL paymentNecessaire;
@property (nonatomic) float prix;

@end
