//
//  AssociationModel.h
//  MinesDeDouai
//
//  Created by Thomas Mac on 09/05/2015.
//  Copyright (c) 2015 Thomas Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Association.h"

@protocol AssociationModelProtocol <NSObject>

- (void) associationsDownloaded: (NSArray*) items;

@end

@interface AssociationModel : NSObject <NSURLConnectionDataDelegate>

@property (nonatomic, weak) id<AssociationModelProtocol> delegate;

@property (nonatomic, weak) Association *associationParente;

@property (nonatomic, weak) NSString *API_url;

- (void) getListeAsssociations: (NSString*)nom;
- (void) getAssociationByName: (NSString*)nom;
- (void) getAssociationById: (int)ID;

@end
