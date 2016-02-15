//
//  LinkModel.m
//  MinesDeDouaiAssociatif
//
//  Created by Thomas Mac on 17/08/2015.
//  Copyright (c) 2015 Thomas Mac. All rights reserved.
//

#import "LinkModel.h"

#import "Link.h"

@interface LinkModel()

@property(nonatomic, strong) NSMutableData* downloadedLinks;

@end

@implementation LinkModel

- (void)getAllLinks
{
    NSURL* jsonFileUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@link/list", self.API_url]];
    
    NSURLRequest* urlRequest = [[NSURLRequest alloc] initWithURL:jsonFileUrl];
    
    [NSURLConnection connectionWithRequest:urlRequest delegate:self];
}

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    self.downloadedLinks = [[NSMutableData alloc] init];
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.downloadedLinks appendData:data];
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
    NSMutableArray* links = [[NSMutableArray alloc] init];
    
    NSError* error;
    
    NSDictionary* jsonArray = [NSJSONSerialization JSONObjectWithData:self.downloadedLinks options:NSJSONReadingAllowFragments error:&error];
    
    NSArray* documentations = jsonArray[@"Documentation"];
    
    NSArray* sitesAssociations = jsonArray[@"Sites des associations"];
    
    NSArray* sitesUtiles = jsonArray[@"Sites utiles"];
    
    NSMutableArray *arrayDocumentations = [[NSMutableArray alloc] init];
    
    NSMutableArray *arraySitesAssociations = [[NSMutableArray alloc] init];
    
    NSMutableArray *arraySitesUtiles = [[NSMutableArray alloc] init];
    
    for (int i=0;i<documentations.count;i++)
    {
        NSDictionary *jsonElement = documentations[i];
        
        Link *link = [[Link alloc] init];
        
        link.label = jsonElement[@"label"];
        
        link.descrip = jsonElement[@"description"];
        
        link.url = jsonElement[@"url"];
        
        [arrayDocumentations addObject:link];
    }
    
    for (int i=0;i<sitesAssociations.count;i++)
    {
        NSDictionary *jsonElement = sitesAssociations[i];
        
        Link *link = [[Link alloc] init];
        
        link.label = jsonElement[@"label"];
        
        link.descrip = jsonElement[@"description"];
        
        link.url = jsonElement[@"url"];
        
        [arraySitesAssociations addObject:link];
    }
    
    for (int i=0;i<sitesUtiles.count;i++)
    {
        NSDictionary *jsonElement = sitesUtiles[i];
        
        Link *link = [[Link alloc] init];
        
        link.label = jsonElement[@"label"];
        
        link.descrip = jsonElement[@"description"];
        
        link.url = jsonElement[@"url"];
        
        [arraySitesUtiles addObject:link];
    }
    
    [links addObject:arrayDocumentations];
    
    [links addObject:arraySitesAssociations];
    
    [links addObject:arraySitesUtiles];
    
    if (self.delegate)
    {
        [self.delegate linksDownloaded:links];
    }
}

@end
