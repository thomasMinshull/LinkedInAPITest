//
//  ViewController.m
//  PingLinkedInLoginTest
//
//  Created by thomas minshull on 2016-07-23.
//  Copyright © 2016 thomas minshull. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *MartinButton;
@property (weak, nonatomic) IBOutlet UIButton *meButton;

@property (weak, nonatomic) IBOutlet UIImageView *profilePicImageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.MartinButton setEnabled:NO];
    [self.meButton setEnabled:NO];
    
    // LogIn
    
    // CheckKeyChain for access token
        // If there is an acess token attemp to login with access token
    
    
    /* sudo code
            NSString tokenFromKeyChain = [Keychain getObjectForKey: KEY];
            
            if (tokenFromKeyChain) { */
               // LISDKAccessToken *token = [LISDKAccessToken LISDKAccessTokenWithSerializedString:tokenFromKeyChain];
                // LISDKSession *session = [LISDKSessionManager createSessionWithAccessToken:token];
    
    
        // If there is not an access token or if the login attempt with the access token fails...
        // login and request new access token
    
    // once logged in segue to next screen (and start becon)
    
    [LISDKSessionManager
     createSessionWithAuth:[NSArray arrayWithObjects:LISDK_BASIC_PROFILE_PERMISSION, nil]
     state:nil
     showGoToAppStoreDialog:YES
     successBlock:^(NSString *returnState) {
         NSLog(@"%s","success called!");
         LISDKSession *session = [[LISDKSessionManager sharedInstance] session];
         
         NSString *url = @"https://api.linkedin.com/v1/people/~";
         
         if ([LISDKSessionManager hasValidSession]) {
             [[LISDKAPIHelper sharedInstance] getRequest:url
                                                 success:^(LISDKAPIResponse *response) {
                                                     // do something with response
                                                     NSLog(@"got user profile: %@", response.data);
                                                     // get and store my member ID
                                                     
                                                     //pass MyProfile InfoToServer ie picture name id etc
                                                     
                                                     dispatch_async(dispatch_get_main_queue(), ^{
                                                         [self.meButton setEnabled:YES];
                                                         [self.MartinButton setEnabled:YES];
                                                         [self.view setNeedsDisplay];
                                                     });
                                                 }
                                                   error:^(LISDKAPIError *apiError) {
                                                       // do something with error
                                                       NSLog(@"Failed to get user profile: %@", apiError);
                                                   }];
         }
     }
     errorBlock:^(NSError *error) {
         NSLog(@"%s","error called!");
     }];
    

}


#pragma mark -Actions

- (IBAction)martinButtonTapped:(id)sender {
    NSString *martinID = @"Martin'sID";
    
    DeeplinkSuccessBlock success = ^(NSString *returnState) {
        NSLog(@"Success with returned state: %@",returnState);
    };
    DeeplinkErrorBlock error = ^(NSError *error, NSString *returnState) {
        NSLog(@"Error with returned state: %@", returnState);
        NSLog(@"Error %@", error);
    };
    
    [[LISDKDeeplinkHelper sharedInstance] viewOtherProfile:martinID withState:@"viewMemberProfileButton" showGoToAppStoreDialog:NO success:success error:error];
}

- (IBAction)myButtonTapped:(id)sender {
    DeeplinkSuccessBlock success = ^(NSString *returnState) {
        NSLog(@"Success with returned state: %@",returnState);
    };
    DeeplinkErrorBlock error = ^(NSError *error, NSString *returnState) {
        NSLog(@"Error with returned state: %@", returnState);
        NSLog(@"Error %@", error);
    };
    
    [[LISDKDeeplinkHelper sharedInstance] viewCurrentProfileWithState:@"viewMyProfileButton" showGoToAppStoreDialog:YES success:success error:error];
    
}

- (IBAction)profilePicButton:(id)sender {
    NSString *url = @"https://api.linkedin.com/v1/people/~:(id,num-connections,picture-url)?format=json";
    
    
    [[LISDKAPIHelper sharedInstance] getRequest:url success:^(LISDKAPIResponse *response) {
        NSLog(@"successfully retrieved profile pic with response: %@", response.data);
        
        
    } error:^(LISDKAPIError *error) {
        NSLog(@"Error when loading profile Pic: %@", error);
    }];
    
}

@end
