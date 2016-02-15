//
//  APIModel.h
//  MinesDeDouaiAssociatif
//
//  Created by Thomas Mac on 23/09/2015.
//  Copyright © 2015 Thomas Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol APIModelProtocol <NSObject>

- (void) apiChosen:(NSString *)API_url updateToDo:(BOOL)updateToDo;

@end

@interface APIModel : NSObject <NSURLConnectionDataDelegate>

@property(nonatomic, weak) id<APIModelProtocol> delegate;

- (void) getAPI_url;

@end
