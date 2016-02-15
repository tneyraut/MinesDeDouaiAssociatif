//
//  LinkModel.h
//  MinesDeDouaiAssociatif
//
//  Created by Thomas Mac on 17/08/2015.
//  Copyright (c) 2015 Thomas Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LinkModelProtocol <NSObject>

- (void) linksDownloaded:(NSArray *)items;

@end

@interface LinkModel : NSObject <NSURLConnectionDataDelegate>

@property(nonatomic, weak) id<LinkModelProtocol> delegate;

@property(nonatomic, weak) NSString *API_url;

- (void) getAllLinks;

@end
