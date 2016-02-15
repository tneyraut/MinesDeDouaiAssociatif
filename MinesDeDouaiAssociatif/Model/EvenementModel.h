//
//  EvenementModel.h
//  MinesDeDouai
//
//  Created by Thomas Mac on 09/05/2015.
//  Copyright (c) 2015 Thomas Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol EvenementModelProtocol <NSObject>

- (void) evenementsDownloaded: (NSArray*) items;

@end

@interface EvenementModel : NSObject <NSURLConnectionDataDelegate>

@property (nonatomic, weak) id<EvenementModelProtocol> delegate;

@property (nonatomic, weak) NSString *API_url;

- (void) getAllEvenements;

- (void) getEvenementsByAssociation:(int)association_id;

- (void) inscriptionEvenementWithId:(int)evenement_id;

- (void) desinscriptionEvenementWithId:(int)evenement_id;

@end
