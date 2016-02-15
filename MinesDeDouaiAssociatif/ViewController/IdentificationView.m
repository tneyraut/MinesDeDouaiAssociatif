//
//  IdentificationView.m
//  MinesDeDouai
//
//  Created by Thomas Mac on 08/05/2015.
//  Copyright (c) 2015 Thomas Mac. All rights reserved.
//

// Première view : Accueil + identification

#import "IdentificationView.h"
#import "MenuView.h"

@interface IdentificationView () <UIAlertViewDelegate>

// Utile pour crypter les password
//@property(nonatomic, strong) EncryptModel *_encryptModel;

@property(nonatomic, strong) UISwitch *afficherImageSwitch;

@property(nonatomic, strong) APIModel *_APIModel;

@property(nonatomic, weak) NSString *API_url;

@property(nonatomic) BOOL updateToDo;

@end

@implementation IdentificationView

// Setting certains éléments graphiques de la view
- (void) initialisationView
{
    [self.navigationItem setTitle:@"Accueil"];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.498 green:0.776 blue:0.737 alpha:1]];
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    shadow.shadowOffset = CGSizeMake(0, 1);
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName, shadow, NSShadowAttributeName, [UIFont fontWithName:NSLocalizedString(@"NAVIGATION_BAR_FONT", @"NAVIGATION_BAR_FONT") size:21.0], NSFontAttributeName, nil]];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15.0f, (self.view.frame.size.height - self.view.frame.size.width + 30.0f) / 2, self.view.frame.size.width - 30.0f, self.view.frame.size.width - 30.0f)];
    [imageView setImage:[UIImage imageNamed:NSLocalizedString(@"ICON_NAME_ECOLE", @"ICON_NAME_ECOLE")]];
    
    UIBarButtonItem *buttonConnexion = [[UIBarButtonItem alloc] initWithTitle:@"Connexion" style:UIBarButtonItemStyleDone target:self action:@selector(actionListenerButtonConnexion)];
    [self.navigationItem setRightBarButtonItem:buttonConnexion];
    
    [buttonConnexion setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName, shadow, NSShadowAttributeName,[UIFont fontWithName:NSLocalizedString(@"BUTTON_FONT", @"BUTTON_FONT") size:21.0], NSFontAttributeName,nil] forState:UIControlStateNormal];
    
    [self.view addSubview:imageView];
    
    UIBarButtonItem *buttonPrevious = [[UIBarButtonItem alloc] initWithTitle:@"Accueil" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    [buttonPrevious setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName, shadow, NSShadowAttributeName,[UIFont fontWithName:NSLocalizedString(@"BUTTON_FONT", @"BUTTON_FONT") size:21.0], NSFontAttributeName,nil] forState:UIControlStateNormal];
    
    self.navigationItem.backBarButtonItem = buttonPrevious;
    
    self.sauvegarde = [NSUserDefaults standardUserDefaults];
    
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    
    self.afficherImageSwitch = [[UISwitch alloc] init];
    
    if (![self.sauvegarde objectForKey:@"affichageImage"])
    {
        [self.sauvegarde setBool:YES forKey:@"affichageImage"];
        
        [self.sauvegarde synchronize];
    }
    
    [self.afficherImageSwitch setOn:[self.sauvegarde boolForKey:@"affichageImage"]];
    
    [self.afficherImageSwitch addTarget:self action:@selector(afficherImageSwitchActionListener) forControlEvents:UIControlEventTouchUpInside];
    
    [self.afficherImageSwitch setFrame:CGRectMake(self.view.frame.size.width - self.afficherImageSwitch.frame.size.width - 15.0f, self.navigationController.toolbar.frame.origin.y - self.afficherImageSwitch.frame.size.height - 15.0f - 45.0f, self.afficherImageSwitch.frame.size.width, self.afficherImageSwitch.frame.size.height)];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, self.afficherImageSwitch.frame.origin.y, self.view.frame.size.width - self.afficherImageSwitch.frame.size.width - 30.0f, self.afficherImageSwitch.frame.size.height)];
    
    [label setText:@"Affichage des images : "];
    
    [label setTextAlignment:NSTextAlignmentCenter];
    
    [self.view addSubview:label];
    
    [self.view addSubview:self.afficherImageSwitch];
}

- (void) afficherImageSwitchActionListener
{
    [self.sauvegarde setBool:self.afficherImageSwitch.on forKey:@"affichageImage"];
}

- (void) verificationAppVersion
{
    self._APIModel = [[APIModel alloc] init];
    
    self._APIModel.delegate = self;
    
    [self._APIModel getAPI_url];
}

- (void) apiChosen:(NSString *)API_url updateToDo:(BOOL)updateToDo
{
    self.API_url = API_url;
    
    self.updateToDo = updateToDo;
    
    if (updateToDo)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Information" message:@"Vous n'avez pas la dernière version de l'application, veuillez télécharger la dernière mise à jour sur l'App Store." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alertView show];
    }
}

// Demande de connexion => appel de cette méthode si aucun identifiant enregistré dans l'application
- (void) connexion
{
    UIAlertView *alertView = [[UIAlertView alloc] init];
    
    [alertView setTitle:@"Connexion"];
    [alertView setMessage:@"Veuillez rentrer vos identifiants pour vous connecter."];
    [alertView setAlertViewStyle:UIAlertViewStyleLoginAndPasswordInput];
    [alertView addButtonWithTitle:@"Se connecter"];
    
    UITextField *loginTextField = [alertView textFieldAtIndex:0];
    UITextField *passwordTextField = [alertView textFieldAtIndex:1];
    
    [loginTextField setPlaceholder:@"login"];
    [passwordTextField setPlaceholder:@"password"];
    [passwordTextField setSecureTextEntry:YES];
    
    [alertView setDelegate:self];
    [alertView show];
}

// ActionListener des boutons des UIAlertView
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Se connecter"])
    {
        [self.sauvegarde setObject:[[alertView textFieldAtIndex:0] text] forKey:@"login"];
        [self.sauvegarde setObject:[[alertView textFieldAtIndex:1] text] forKey:@"password"];
        [self.sauvegarde synchronize];
        
        MenuView *menuView = [[MenuView alloc] initWithStyle:UITableViewStylePlain];
        
        menuView.login = [self.sauvegarde objectForKey:@"login"];
        
        menuView.password = [self.sauvegarde objectForKey:@"password"];
        
        menuView.identificationView = self;
        
        menuView.demandeIdentification = YES;
        
        menuView.afficherImage = [self.sauvegarde boolForKey:@"affichageImage"];
        
        menuView.API_url = self.API_url;
        
        [self.navigationController pushViewController:menuView animated:YES];
    }
    else if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"OK"])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/mines-de-douai-lassociatif/id1023210848?mt=8"]];
    }
}

- (void) actionListenerButtonConnexion
{
    // Uitile pour crypter les password
    //[self downloadedPublicKey];
    
    if (self.updateToDo)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Information" message:@"Vous n'avez pas la dernière version de l'application, veuillez télécharger la dernière mise à jour sur l'App Store." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alertView show];
        
        return;
    }
    
    // Si aucun identifiant enregistré, appel de [self connexion] pour demander de rentrer les identifiants
    // Sinon direction dans le MenuView avec vérification des identifiants...
    if ([[self.sauvegarde objectForKey:@"login"] isEqualToString:@""] || [[self.sauvegarde objectForKey:@"password"] isEqualToString:@""] || [self.sauvegarde objectForKey:@"login"] == nil || [self.sauvegarde objectForKey:@"password"] == nil)
    {
        [self connexion];
    }
    else
    {
        MenuView *menuView = [[MenuView alloc] initWithStyle:UITableViewStylePlain];
        
        menuView.login = [self.sauvegarde objectForKey:@"login"];
        
        menuView.password = [self.sauvegarde objectForKey:@"password"];
        
        menuView.identificationView = self;
        
        menuView.demandeIdentification = YES;
        
        menuView.afficherImage = [self.sauvegarde boolForKey:@"affichageImage"];
        
        menuView.API_url = self.API_url;
        
        [self.navigationController pushViewController:menuView animated:YES];
    }
}

// Utile pour crypter les password
/*- (void) downloadedPublicKey
{
    if (!self._encryptModel)
    {
        self._encryptModel = [[EncryptModel alloc] init];
        
        self._encryptModel.delegate = self;
    }
    
    [self._encryptModel getPublicKey];
}*/

// Utile pour crypter les password
/*- (void) publicKeyDownloaded:(NSString *)publicKey
{
    if (![publicKey isEqualToString:[self.sauvegardeIdentifiants objectForKey:@"publicKey"]])
    {
        [self.sauvegardeIdentifiants setObject:@"" forKey:@"login"];
        [self.sauvegardeIdentifiants setObject:@"" forKey:@"password"];
        [self.sauvegardeIdentifiants setObject:publicKey forKey:@"publicKey"];
        
        [self.sauvegardeIdentifiants synchronize];
    }
}*/

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialisationView];
    
    [self verificationAppVersion];
    
    // Utile pour crypter les password
    //[self downloadedPublicKey];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated
{
    [self.navigationController setToolbarHidden:NO animated:YES];
    
    [self.navigationController.toolbar setBarTintColor:[UIColor colorWithRed:0.498 green:0.776 blue:0.737 alpha:1]];
    
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    shadow.shadowOffset = CGSizeMake(0, 1);
    
    UIBarButtonItem *buttonTitle = [[UIBarButtonItem alloc] initWithTitle:@"Mines de douai : l'Associatif"
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:nil
                                                                   action:nil];
    
    [buttonTitle setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName, shadow, NSShadowAttributeName, [UIFont fontWithName:NSLocalizedString(@"BUTTON_FONT", @"BUTTON_FONT") size:21.0], NSFontAttributeName, nil] forState:UIControlStateNormal];
    
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                      target:nil
                                      action:nil];
    
    [self.navigationController.toolbar setItems:@[ flexibleSpace, buttonTitle, flexibleSpace ]];
    
    [super viewDidAppear:animated];
}

@end
