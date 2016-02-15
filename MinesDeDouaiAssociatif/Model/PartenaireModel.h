//
//  PartenaireModel.h
//  MinesDeDouai
//
//  Created by Thomas Mac on 09/05/2015.
//  Copyright (c) 2015 Thomas Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PartenaireModelProtocol <NSObject>

- (void) partenairesDownloaded: (NSArray *) items;

@end

@interface PartenaireModel : NSObject

@property (nonatomic, weak) id<PartenaireModelProtocol> delegate;

@property (nonatomic, weak) NSString *API_url;

- (void) getPartenairesByAssociation:(int)association_id;

- (void) getAllPartenaires;

@end
