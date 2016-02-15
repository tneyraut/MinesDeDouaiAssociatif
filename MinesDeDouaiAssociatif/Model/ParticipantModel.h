//
//  ParticipantModel.h
//  MinesDeDouaiAssociatif
//
//  Created by Thomas Mac on 17/08/2015.
//  Copyright (c) 2015 Thomas Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ParticipantModelProtocol <NSObject>

- (void) participantsDownloaded:(NSArray *)items;

@end

@interface ParticipantModel : NSObject <NSURLConnectionDataDelegate>

@property(nonatomic, weak) id<ParticipantModelProtocol> delegate;

@property(nonatomic, weak) NSString *API_url;

- (void) getAllParticipantsByEvenementID:(int)evenement_id;

@end
