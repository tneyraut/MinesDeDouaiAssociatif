//
//  UserModel.h
//  MinesDeDouai
//
//  Created by Thomas Mac on 09/05/2015.
//  Copyright (c) 2015 Thomas Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UserModelProtocol <NSObject>

- (void) getUserDownloaded: (NSArray*) items;

@end

@interface UserModel : NSObject <NSURLConnectionDataDelegate>

@property (nonatomic, weak) id<UserModelProtocol> delegate;

@property (nonatomic, weak) NSString *API_url;

- (void) getUser: (NSString*)login pass:(NSString*)password;

- (void) updateUser:(NSString *)chambre residence:(NSString *)residence telephone:(NSString *)telephone;

@end
