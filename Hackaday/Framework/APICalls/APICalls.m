//
//  APICalls.m
//  Hackaday
//
//  Created by Bosko Petreski on 4/1/16.
//  Copyright © 2016 Bosko Petreski. All rights reserved.
//

#import "APICalls.h"
#import "UIWebView+Blocks.h"

@implementation APICalls

#pragma mark - Common
+(void)auth:(NSString *)code success:(Success)success failed:(Failed)failed{
    NSString *strUrl = [NSString stringWithFormat:@"https://auth.hackaday.io/access_token?client_id=%@&client_secret=%@&code=%@&grant_type=authorization_code",CLIENT_ID,SECRET_KEY,code];
    NSURL *URL = [NSURL URLWithString:strUrl];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    
    [request setHTTPMethod:@"POST"];
    
    NSLog(@"URL: %@",URL);
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler: ^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
        
        if([[NSThread currentThread] isMainThread]){
            if(error){
                failed(error.userInfo[@"NSLocalizedDescription"]);
                NSLog(@"status code: %ld RESPOND: %@",(long)[httpResponse statusCode],error.userInfo);
            }
            else{
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                if(dict){
                    success(dict);
                }
                else{
                    NSLog(@"status code: %ld RESPOND: %@",(long)[httpResponse statusCode],[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
                    failed(@"JSON error");
                }
            }
            
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                if(error){
                    failed(error.userInfo[@"NSLocalizedDescription"]);
                    NSLog(@"status code: %ld RESPOND: %@",(long)[httpResponse statusCode],error.userInfo);
                }
                else{
                    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                    if(dict){
                        success(dict);
                    }
                    else{
                        NSLog(@"status code: %ld RESPOND: %@",(long)[httpResponse statusCode],[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
                        failed(@"JSON error");
                    }
                }
            });
        }
    }] resume];
}
+(void)get:(NSString *)url success:(Success)success failed:(Failed)failed{
    NSURL *URL = [NSURL URLWithString:@""];
    if([url containsString:@"?"]){
       URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@&api_key=%@",API_URL,url,API_KEY]];
    }
    else{
        URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@?api_key=%@",API_URL,url,API_KEY]];
    }
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    
    if([[[NSUserDefaults standardUserDefaults] dictionaryRepresentation].allKeys containsObject:@"hackaday_token"]){
        NSString *authorizationHeader = [NSString stringWithFormat:@"token %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"hackaday_token"]];
        [request addValue:authorizationHeader forHTTPHeaderField:@"authorization"];
    }
    [request setHTTPMethod:@"GET"];
    NSLog(@"Headers: %@",request.allHTTPHeaderFields);
    NSLog(@"URL: %@",URL);
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler: ^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
        
        if([[NSThread currentThread] isMainThread]){
            if(error){
                failed(error.userInfo[@"NSLocalizedDescription"]);
                NSLog(@"status code: %ld RESPOND: %@",(long)[httpResponse statusCode],error.userInfo);
            }
            else{
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                if(dict){
                    success(dict);
                }
                else{
                    NSLog(@"status code: %ld RESPOND: %@",(long)[httpResponse statusCode],[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
                    failed(@"JSON error");
                }
            }
            
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                if(error){
                    failed(error.userInfo[@"NSLocalizedDescription"]);
                    NSLog(@"status code: %ld RESPOND: %@",(long)[httpResponse statusCode],error.userInfo);
                }
                else{
                    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                    if(dict){
                        success(dict);
                    }
                    else{
                        NSLog(@"status code: %ld RESPOND: %@",(long)[httpResponse statusCode],[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
                        failed(@"JSON error");
                    }
                }
            });
        }
    }] resume];
}

#pragma mark - OAuth
+(void)GetAccessToken:(UIViewController *)viewController{
    NSString *strUrl = [NSString stringWithFormat:@"https://hackaday.io/authorize?client_id=%@&response_type=code",CLIENT_ID];
    NSURL *url = [NSURL URLWithString:strUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    UIWebView *webView = [UIWebView loadRequest:request
                                         loaded:^(UIWebView *webView) {
                                             
                                             NSString *currentURL = webView.request.URL.absoluteString;
                                             NSLog(@"currentURL: %@",currentURL);
                                             
                                             if([currentURL containsString:@"code="]){
                                                 NSString *code = [currentURL componentsSeparatedByString:@"code="][1];
                                                 NSLog(@"code: %@",code);
                                                 
                                                 [self auth:code success:^(NSDictionary *dictData) {
                                                     NSString *accessToken = dictData[@"access_token"];
                                                     NSLog(@"AccessToken: %@",accessToken);
                                                     [[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:@"hackaday_token"];
                                                     [[NSUserDefaults standardUserDefaults] synchronize];
                                                     
                                                     UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Login success" message:nil preferredStyle:UIAlertControllerStyleAlert];
                                                     UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                                         [webView removeFromSuperview];
                                                     }];
                                                     [alert addAction:okAction];
                                                     [viewController presentViewController:alert animated:YES completion:nil];
                                                     
                                                 } failed:^(NSString *message) {
                                                     NSLog(@"error token: %@",message);
                                                     
                                                     UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Invalid login" message:nil preferredStyle:UIAlertControllerStyleAlert];
                                                     UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                                         [webView removeFromSuperview];
                                                     }];
                                                     [alert addAction:okAction];
                                                     [viewController presentViewController:alert animated:YES completion:nil];
                                                 }];
                                                 
                                             }
                                             else{
                                                 NSString *htmlFromWeb = [webView stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML"];
                                                 NSLog(@"Loaded successfully: %@",htmlFromWeb);
                                                 if([htmlFromWeb containsString:@"Invalid email or password"]){
                                                     UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Invalid login" message:nil preferredStyle:UIAlertControllerStyleAlert];
                                                     UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                                         [webView removeFromSuperview];
                                                     }];
                                                     [alert addAction:okAction];
                                                     [viewController presentViewController:alert animated:YES completion:nil];
                                                 }
                                             }
                                         }
                                         failed:^(UIWebView *webView, NSError *error) {
                                             NSLog(@"Failed loading %@", error);
                                         }];
    webView.frame = viewController.view.frame;
    [viewController.view addSubview:webView];
}

#pragma mark - Search
+(void)SearchTerm:(NSString *)term success:(Success)success failed:(Failed)failed{
    [self get:[NSString stringWithFormat:@"search?search_term=%@",term] success:^(NSDictionary *dictData) {
        success(dictData);
    } failed:^(NSString *message) {
        failed(message);
    }];
}
+(void)SearchUsers:(NSString *)users success:(Success)success failed:(Failed)failed{
    [self get:[NSString stringWithFormat:@"search/users?search_term=%@",users] success:^(NSDictionary *dictData) {
        success(dictData);
    } failed:^(NSString *message) {
        failed(message);
    }];
}
+(void)SearchProjects:(NSString *)projects success:(Success)success failed:(Failed)failed{
    [self get:[NSString stringWithFormat:@"search/projects?search_term=%@",projects] success:^(NSDictionary *dictData) {
        success(dictData);
    } failed:^(NSString *message) {
        failed(message);
    }];
}

#pragma mark - Projects
+(void)GetProjects:(Success)success failed:(Failed)failed{
    [self get:@"projects" success:^(NSDictionary *dictData) {
        success(dictData);
    } failed:^(NSString *message) {
        failed(message);
    }];
}
+(void)GetProjectInfo:(NSString *)projectID success:(Success)success failed:(Failed)failed{
    [self get:[NSString stringWithFormat:@"projects/%@",projectID] success:^(NSDictionary *dictData) {
        success(dictData);
    } failed:^(NSString *message) {
        failed(message);
    }];
}
+(void)GetProjectTeam:(NSString *)projectID success:(Success)success failed:(Failed)failed{
    [self get:[NSString stringWithFormat:@"projects/%@/team",projectID] success:^(NSDictionary *dictData) {
        success(dictData);
    } failed:^(NSString *message) {
        failed(message);
    }];
}
+(void)GetProjectFollowers:(NSString *)projectID success:(Success)success failed:(Failed)failed{
    [self get:[NSString stringWithFormat:@"projects/%@/followers",projectID] success:^(NSDictionary *dictData) {
        success(dictData);
    } failed:^(NSString *message) {
        failed(message);
    }];
}
+(void)GetProjectSkulls:(NSString *)projectID success:(Success)success failed:(Failed)failed{
    [self get:[NSString stringWithFormat:@"projects/%@/skulls",projectID] success:^(NSDictionary *dictData) {
        success(dictData);
    } failed:^(NSString *message) {
        failed(message);
    }];
}
+(void)GetProjectComments:(NSString *)projectID success:(Success)success failed:(Failed)failed{
    [self get:[NSString stringWithFormat:@"projects/%@/comments",projectID] success:^(NSDictionary *dictData) {
        success(dictData);
    } failed:^(NSString *message) {
        failed(message);
    }];
}
+(void)GetProjectTags:(NSString *)projectID success:(Success)success failed:(Failed)failed{
    [self get:[NSString stringWithFormat:@"projects/%@/tags",projectID] success:^(NSDictionary *dictData) {
        success(dictData);
    } failed:^(NSString *message) {
        failed(message);
    }];
}
+(void)GetProjectImages:(NSString *)projectID success:(Success)success failed:(Failed)failed{
    [self get:[NSString stringWithFormat:@"projects/%@/images",projectID] success:^(NSDictionary *dictData) {
        success(dictData);
    } failed:^(NSString *message) {
        failed(message);
    }];
}
+(void)GetProjectLinks:(NSString *)projectID success:(Success)success failed:(Failed)failed{
    [self get:[NSString stringWithFormat:@"projects/%@/links",projectID] success:^(NSDictionary *dictData) {
        success(dictData);
    } failed:^(NSString *message) {
        failed(message);
    }];
}
+(void)GetProjectComponents:(NSString *)projectID success:(Success)success failed:(Failed)failed{
    [self get:[NSString stringWithFormat:@"projects/%@/components",projectID] success:^(NSDictionary *dictData) {
        success(dictData);
    } failed:^(NSString *message) {
        failed(message);
    }];
}
+(void)GetProjectLogs:(NSString *)projectID success:(Success)success failed:(Failed)failed{
    [self get:[NSString stringWithFormat:@"projects/%@/logs",projectID] success:^(NSDictionary *dictData) {
        success(dictData);
    } failed:^(NSString *message) {
        failed(message);
    }];
}
+(void)GetProjectInstructions:(NSString *)projectID success:(Success)success failed:(Failed)failed{
    [self get:[NSString stringWithFormat:@"projects/%@/instructions",projectID] success:^(NSDictionary *dictData) {
        success(dictData);
    } failed:^(NSString *message) {
        failed(message);
    }];
}
+(void)GetProjectDetails:(NSString *)projectID success:(Success)success failed:(Failed)failed{
    [self get:[NSString stringWithFormat:@"projects/%@/details",projectID] success:^(NSDictionary *dictData) {
        success(dictData);
    } failed:^(NSString *message) {
        failed(message);
    }];
}
+(void)GetProjectsFromID:(NSString *)fromID toID:(NSString *)toID success:(Success)success failed:(Failed)failed{
    [self get:[NSString stringWithFormat:@"projects/range?ids=%@,%@",fromID,toID] success:^(NSDictionary *dictData) {
        success(dictData);
    } failed:^(NSString *message) {
        failed(message);
    }];
}
+(void)GetProjectsDetailsIDs:(NSArray *)arrProjectsID success:(Success)success failed:(Failed)failed{
    NSString *strBatch = [arrProjectsID componentsJoinedByString:@","];
    
    [self get:[NSString stringWithFormat:@"projects/batch?ids=%@",strBatch] success:^(NSDictionary *dictData) {
        success(dictData);
    } failed:^(NSString *message) {
        failed(message);
    }];
}
+(void)GetProjectsByTerm:(NSString *)projectTerm success:(Success)success failed:(Failed)failed{
    [self get:[NSString stringWithFormat:@"projects/search?search_term=%@",projectTerm] success:^(NSDictionary *dictData) {
        success(dictData);
    } failed:^(NSString *message) {
        failed(message);
    }];
}

#pragma mark - Users
+(void)GetUsers:(Success)success failed:(Failed)failed{
    [self get:@"users" success:^(NSDictionary *dictData) {
        success(dictData);
    } failed:^(NSString *message) {
        failed(message);
    }];
}
+(void)GetUserDetails:(NSString *)userID success:(Success)success failed:(Failed)failed{
    [self get:[NSString stringWithFormat:@"users/%@",userID] success:^(NSDictionary *dictData) {
        success(dictData);
    } failed:^(NSString *message) {
        failed(message);
    }];
}
+(void)GetUserFollowers:(NSString *)userID success:(Success)success failed:(Failed)failed{
    [self get:[NSString stringWithFormat:@"users/%@/followers",userID] success:^(NSDictionary *dictData) {
        success(dictData);
    } failed:^(NSString *message) {
        failed(message);
    }];
}
+(void)GetUserFollowing:(NSString *)userID success:(Success)success failed:(Failed)failed{
    [self get:[NSString stringWithFormat:@"users/%@/following",userID] success:^(NSDictionary *dictData) {
        success(dictData);
    } failed:^(NSString *message) {
        failed(message);
    }];
}
+(void)GetUserProjects:(NSString *)userID success:(Success)success failed:(Failed)failed{
    [self get:[NSString stringWithFormat:@"users/%@/projects",userID] success:^(NSDictionary *dictData) {
        success(dictData);
    } failed:^(NSString *message) {
        failed(message);
    }];
}
+(void)GetUserSkulls:(NSString *)userID success:(Success)success failed:(Failed)failed{
    [self get:[NSString stringWithFormat:@"users/%@/skulls",userID] success:^(NSDictionary *dictData) {
        success(dictData);
    } failed:^(NSString *message) {
        failed(message);
    }];
}
+(void)GetUserLinks:(NSString *)userID success:(Success)success failed:(Failed)failed{
    [self get:[NSString stringWithFormat:@"users/%@/links",userID] success:^(NSDictionary *dictData) {
        success(dictData);
    } failed:^(NSString *message) {
        failed(message);
    }];
}
+(void)GetUserBadges:(NSString *)userID success:(Success)success failed:(Failed)failed{
    [self get:[NSString stringWithFormat:@"users/%@/badges",userID] success:^(NSDictionary *dictData) {
        success(dictData);
    } failed:^(NSString *message) {
        failed(message);
    }];
}
+(void)GetUserTags:(NSString *)userID success:(Success)success failed:(Failed)failed{
    [self get:[NSString stringWithFormat:@"users/%@/tags",userID] success:^(NSDictionary *dictData) {
        success(dictData);
    } failed:^(NSString *message) {
        failed(message);
    }];
}
+(void)GetUserPages:(NSString *)userID success:(Success)success failed:(Failed)failed{
    [self get:[NSString stringWithFormat:@"users/%@/pages",userID] success:^(NSDictionary *dictData) {
        success(dictData);
    } failed:^(NSString *message) {
        failed(message);
    }];
}
+(void)GetUsersFromID:(NSString *)fromID toID:(NSString *)toID success:(Success)success failed:(Failed)failed{
    [self get:[NSString stringWithFormat:@"users/range?ids=%@,%@",fromID,toID] success:^(NSDictionary *dictData) {
        success(dictData);
    } failed:^(NSString *message) {
        failed(message);
    }];
}
+(void)GetUsersDetailsIDs:(NSArray *)arrUsersID success:(Success)success failed:(Failed)failed{
    NSString *strBatch = [arrUsersID componentsJoinedByString:@","];
    
    [self get:[NSString stringWithFormat:@"users/batch?ids=%@",strBatch] success:^(NSDictionary *dictData) {
        success(dictData);
    } failed:^(NSString *message) {
        failed(message);
    }];
}
+(void)SearchUsersByName:(NSString *)name andLocation:(NSString *)location success:(Success)success failed:(Failed)failed{
    NSString *strSearch = [NSString stringWithFormat:@"users/search?screen_name=%@",name];
    
    if(name.length > 0 && location.length > 0){
        strSearch = [NSString stringWithFormat:@"users/search?screen_name=%@&location=%@",name,location];
    }
    else if(name.length > 0){
        strSearch = [NSString stringWithFormat:@"users/search?screen_name=%@",name];
    }
    else{
        strSearch = [NSString stringWithFormat:@"users/search?location=%@",location];
    }
    
    [self get:strSearch success:^(NSDictionary *dictData) {
        success(dictData);
    } failed:^(NSString *message) {
        failed(message);
    }];
}
+(void)GetMe:(Success)success failed:(Failed)failed{
    [self get:@"me" success:^(NSDictionary *dictData) {
        success(dictData);
    } failed:^(NSString *message) {
        failed(message);
    }];
}

#pragma mark - Comments
+(void)GetCommentsFromUser:(NSString *)userID success:(Success)success failed:(Failed)failed{
    [self get:[NSString stringWithFormat:@"comments/users/%@",userID] success:^(NSDictionary *dictData) {
        success(dictData);
    } failed:^(NSString *message) {
        failed(message);
    }];
}
+(void)GetCommentsFromProject:(NSString *)projectID success:(Success)success failed:(Failed)failed{
    [self get:[NSString stringWithFormat:@"comments/projects/%@",projectID] success:^(NSDictionary *dictData) {
        success(dictData);
    } failed:^(NSString *message) {
        failed(message);
    }];
}
+(void)GetCommentsFromProjectLog:(NSString *)projectID success:(Success)success failed:(Failed)failed{
    [self get:[NSString stringWithFormat:@"comments/logs/%@",projectID] success:^(NSDictionary *dictData) {
        success(dictData);
    } failed:^(NSString *message) {
        failed(message);
    }];
}
+(void)GetCommentsFromProjectInstructions:(NSString *)projectID success:(Success)success failed:(Failed)failed{
    [self get:[NSString stringWithFormat:@"comments/instructions/%@",projectID] success:^(NSDictionary *dictData) {
        success(dictData);
    } failed:^(NSString *message) {
        failed(message);
    }];
}
+(void)GetCommentsFromContest:(NSString *)contestID success:(Success)success failed:(Failed)failed{
    [self get:[NSString stringWithFormat:@"comments/contests/%@",contestID] success:^(NSDictionary *dictData) {
        success(dictData);
    } failed:^(NSString *message) {
        failed(message);
    }];
}
+(void)GetCommentsFromEvents:(NSString *)eventID success:(Success)success failed:(Failed)failed{
    [self get:[NSString stringWithFormat:@"comments/events/%@",eventID] success:^(NSDictionary *dictData) {
        success(dictData);
    } failed:^(NSString *message) {
        failed(message);
    }];
}
+(void)GetCommentsFromHackerSpace:(NSString *)hackerSpaceID success:(Success)success failed:(Failed)failed{
    [self get:[NSString stringWithFormat:@"comments/hackerspaces/%@",hackerSpaceID] success:^(NSDictionary *dictData) {
        success(dictData);
    } failed:^(NSString *message) {
        failed(message);
    }];
}
+(void)GetCommentsFromStack:(NSString *)stackID success:(Success)success failed:(Failed)failed{
    [self get:[NSString stringWithFormat:@"comments/stack/%@",stackID] success:^(NSDictionary *dictData) {
        success(dictData);
    } failed:^(NSString *message) {
        failed(message);
    }];
}

#pragma mark - Pages
+(void)GetLists:(Success)success failed:(Failed)failed{
    [self get:@"pages/lists" success:^(NSDictionary *dictData) {
        success(dictData);
    } failed:^(NSString *message) {
        failed(message);
    }];
}
+(void)GetListDetails:(NSString *)listID success:(Success)success failed:(Failed)failed{
    [self get:[NSString stringWithFormat:@"pages/lists/%@",listID] success:^(NSDictionary *dictData) {
        success(dictData);
    } failed:^(NSString *message) {
        failed(message);
    }];
}
+(void)GetStacks:(Success)success failed:(Failed)failed{
    [self get:@"pages/stack" success:^(NSDictionary *dictData) {
        success(dictData);
    } failed:^(NSString *message) {
        failed(message);
    }];
}
+(void)GetStackDetails:(NSString *)stackID success:(Success)success failed:(Failed)failed{
    [self get:[NSString stringWithFormat:@"pages/stack/%@",stackID] success:^(NSDictionary *dictData) {
        success(dictData);
    } failed:^(NSString *message) {
        failed(message);
    }];
}
+(void)GetEvents:(Success)success failed:(Failed)failed{
    [self get:@"pages/events" success:^(NSDictionary *dictData) {
        success(dictData);
    } failed:^(NSString *message) {
        failed(message);
    }];
}
+(void)GetContasts:(Success)success failed:(Failed)failed{
    [self get:@"pages/contests" success:^(NSDictionary *dictData) {
        success(dictData);
    } failed:^(NSString *message) {
        failed(message);
    }];
}
+(void)GetHackerSpaces:(Success)success failed:(Failed)failed{
    [self get:@"pages/hackerspaces" success:^(NSDictionary *dictData) {
        success(dictData);
    } failed:^(NSString *message) {
        failed(message);
    }];
}

#pragma mark - Feeds
+(void)GetFeedGlobal:(Success)success failed:(Failed)failed{
    [self get:@"feeds/global" success:^(NSDictionary *dictData) {
        success(dictData);
    } failed:^(NSString *message) {
        failed(message);
    }];
}

@end
