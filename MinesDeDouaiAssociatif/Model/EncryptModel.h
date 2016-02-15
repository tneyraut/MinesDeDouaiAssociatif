//
//  EncryptModel.h
//  MinesDeDouaiAssociatif
//
//  Created by Thomas Mac on 15/07/2015.
//  Copyright (c) 2015 Thomas Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol EncryptModelProtocol <NSObject>

- (void) publicKeyDownloaded:(NSString*)publicKey;

@end

@interface EncryptModel : NSObject <NSURLConnectionDataDelegate>

@property (nonatomic, weak) id<EncryptModelProtocol> delegate;

@property (nonatomic, weak) NSString *API_url;

- (void) getPublicKey;

@end
