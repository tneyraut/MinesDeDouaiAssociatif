//
//  MembreModel.h
//  MinesDeDouai
//
//  Created by Thomas Mac on 19/05/2015.
//  Copyright (c) 2015 Thomas Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MembreModelProtocol <NSObject>

- (void) membresDownloaded: (NSArray*) items;

@end

@interface MembreModel : NSObject

@property (nonatomic, weak) id<MembreModelProtocol> delegate;

@property (nonatomic, weak) NSString *API_url;

- (void) getMembresByAssociation:(int)association_id;

@end

