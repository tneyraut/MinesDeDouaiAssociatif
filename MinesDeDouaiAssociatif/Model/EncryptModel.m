//
//  EncryptModel.m
//  MinesDeDouaiAssociatif
//
//  Created by Thomas Mac on 15/07/2015.
//  Copyright (c) 2015 Thomas Mac. All rights reserved.
//

#import "EncryptModel.h"

@interface EncryptModel()

@property(nonatomic, strong) NSMutableData *downloadedPublicKey;

@end

@implementation EncryptModel

- (void) getPublicKey
{
    NSURL* jsonFileUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@encryption/publicKey", self.API_url]];
    
    NSURLRequest* urlRequest = [[NSURLRequest alloc] initWithURL:jsonFileUrl];
    
    [NSURLConnection connectionWithRequest:urlRequest delegate:self];
}

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    self.downloadedPublicKey = [[NSMutableData alloc] init];
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.downloadedPublicKey appendData:data];
    
    if (data)
    {
        NSString *contentOfURL = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        if (self.delegate)
        {
            [self.delegate publicKeyDownloaded:contentOfURL];
        }
    }
}

@end
