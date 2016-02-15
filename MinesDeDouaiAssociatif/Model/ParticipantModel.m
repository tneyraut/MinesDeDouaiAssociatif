//
//  ParticipantModel.m
//  MinesDeDouaiAssociatif
//
//  Created by Thomas Mac on 17/08/2015.
//  Copyright (c) 2015 Thomas Mac. All rights reserved.
//

#import "ParticipantModel.h"

#import "User.h"

@interface ParticipantModel()

@property(nonatomic, strong) NSMutableData* downloadedParticipant;

@end

@implementation ParticipantModel

- (void)getAllParticipantsByEvenementID:(int)evenement_id
{
    NSURL* jsonFileUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@evenement/view?id=%d", self.API_url, evenement_id]];
    
    NSURLRequest* urlRequest = [[NSURLRequest alloc] initWithURL:jsonFileUrl];
    
    [NSURLConnection connectionWithRequest:urlRequest delegate:self];
}

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    self.downloadedParticipant = [[NSMutableData alloc] init];
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.downloadedParticipant appendData:data];
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
    NSMutableArray* participants = [[NSMutableArray alloc] init];
    
    NSError* error;
    
    NSDictionary* jsonArray = [NSJSONSerialization JSONObjectWithData:self.downloadedParticipant options:NSJSONReadingAllowFragments error:&error];
    
    if (jsonArray[@"inscrits"])
    {
        NSArray* participantsArray = jsonArray[@"inscrits"];
        
        for (int i=0;i<participantsArray.count;i++)
        {
            NSDictionary *participant = participantsArray[0];
            
            User *unParticipant = [[User alloc] init];
            
            unParticipant.prenom = participant[@"prenom"];
            
            unParticipant.nom = participant[@"nom"];
            
            unParticipant.avatar = participant[@"avatar"];
            
            [participants addObject:unParticipant];
        }
    }
    
    if (self.delegate)
    {
        [self.delegate participantsDownloaded:participants];
    }
}

@end
