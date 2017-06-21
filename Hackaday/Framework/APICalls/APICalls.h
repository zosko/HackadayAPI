//
//  APICalls.h
//  Hackaday
//
//  Created by Bosko Petreski on 4/1/16.
//  Copyright © 2016 Bosko Petreski. All rights reserved.
//

#import <Foundation/Foundation.h>

@import UIKit;

typedef void(^Success)(NSDictionary *dictData);
typedef void(^Failed)(NSString *message);

#define CLIENT_ID   @"Q4qkCGiKthvFrOXpD9ASWDBmDyL7nfDs9Icb11KH7nFptJ0Q"
#define SECRET_KEY  @"rbEUTRnQiT7n0gn47Wfh2oVCtFF50x9zqMLQKJrGNHVivrEu"
#define API_KEY     @"uc5JeEBDTvUnyhHR"
#define API_URL     @"http://api.hackaday.io/v1/"

@interface APICalls : NSObject

#pragma mark - OAuth
+(void)GetAccessToken:(UIViewController *)viewController;

#pragma mark - Search
+(void)SearchTerm:(NSString *)term success:(Success)success failed:(Failed)failed;
+(void)SearchUsers:(NSString *)users success:(Success)success failed:(Failed)failed;
+(void)SearchProjects:(NSString *)projects success:(Success)success failed:(Failed)failed;

#pragma mark - Projects
+(void)GetProjects:(Success)success failed:(Failed)failed;
+(void)GetProjectInfo:(NSString *)projectID success:(Success)success failed:(Failed)failed;
+(void)GetProjectTeam:(NSString *)projectID success:(Success)success failed:(Failed)failed;
+(void)GetProjectFollowers:(NSString *)projectID success:(Success)success failed:(Failed)failed;
+(void)GetProjectSkulls:(NSString *)projectID success:(Success)success failed:(Failed)failed;
+(void)GetProjectComments:(NSString *)projectID success:(Success)success failed:(Failed)failed;
+(void)GetProjectTags:(NSString *)projectID success:(Success)success failed:(Failed)failed;
+(void)GetProjectImages:(NSString *)projectID success:(Success)success failed:(Failed)failed;
+(void)GetProjectLinks:(NSString *)projectID success:(Success)success failed:(Failed)failed;
+(void)GetProjectComponents:(NSString *)projectID success:(Success)success failed:(Failed)failed;
+(void)GetProjectLogs:(NSString *)projectID success:(Success)success failed:(Failed)failed;
+(void)GetProjectInstructions:(NSString *)projectID success:(Success)success failed:(Failed)failed;
+(void)GetProjectDetails:(NSString *)projectID success:(Success)success failed:(Failed)failed;
+(void)GetProjectsFromID:(NSString *)fromID toID:(NSString *)toID success:(Success)success failed:(Failed)failed;
+(void)GetProjectsDetailsIDs:(NSArray *)arrProjectsID success:(Success)success failed:(Failed)failed;
+(void)GetProjectsByTerm:(NSString *)projectTerm success:(Success)success failed:(Failed)failed;

#pragma mark - Users
+(void)GetUsers:(Success)success failed:(Failed)failed;
+(void)GetUserDetails:(NSString *)userID success:(Success)success failed:(Failed)failed;
+(void)GetUserFollowers:(NSString *)userID success:(Success)success failed:(Failed)failed;
+(void)GetUserFollowing:(NSString *)userID success:(Success)success failed:(Failed)failed;
+(void)GetUserProjects:(NSString *)userID success:(Success)success failed:(Failed)failed;
+(void)GetUserSkulls:(NSString *)userID success:(Success)success failed:(Failed)failed;
+(void)GetUserLinks:(NSString *)userID success:(Success)success failed:(Failed)failed;
+(void)GetUserBadges:(NSString *)userID success:(Success)success failed:(Failed)failed;
+(void)GetUserTags:(NSString *)userID success:(Success)success failed:(Failed)failed;
+(void)GetUserPages:(NSString *)userID success:(Success)success failed:(Failed)failed;
+(void)GetUsersFromID:(NSString *)fromID toID:(NSString *)toID success:(Success)success failed:(Failed)failed;
+(void)GetUsersDetailsIDs:(NSArray *)arrUsersID success:(Success)success failed:(Failed)failed;
+(void)SearchUsersByName:(NSString *)name andLocation:(NSString *)location success:(Success)success failed:(Failed)failed;
+(void)GetMe:(Success)success failed:(Failed)failed;

#pragma mark - Comments
+(void)GetCommentsFromUser:(NSString *)userID success:(Success)success failed:(Failed)failed;
+(void)GetCommentsFromProject:(NSString *)projectID success:(Success)success failed:(Failed)failed;
+(void)GetCommentsFromProjectLog:(NSString *)projectID success:(Success)success failed:(Failed)failed;
+(void)GetCommentsFromProjectInstructions:(NSString *)projectID success:(Success)success failed:(Failed)failed;
+(void)GetCommentsFromContest:(NSString *)contestID success:(Success)success failed:(Failed)failed;
+(void)GetCommentsFromEvents:(NSString *)eventID success:(Success)success failed:(Failed)failed;
+(void)GetCommentsFromHackerSpace:(NSString *)hackerSpaceID success:(Success)success failed:(Failed)failed;
+(void)GetCommentsFromStack:(NSString *)stackID success:(Success)success failed:(Failed)failed;

#pragma mark - Pages
+(void)GetLists:(Success)success failed:(Failed)failed;
+(void)GetListDetails:(NSString *)listID success:(Success)success failed:(Failed)failed;
+(void)GetStacks:(Success)success failed:(Failed)failed;
+(void)GetStackDetails:(NSString *)stackID success:(Success)success failed:(Failed)failed;
+(void)GetEvents:(Success)success failed:(Failed)failed;
+(void)GetContasts:(Success)success failed:(Failed)failed;
+(void)GetHackerSpaces:(Success)success failed:(Failed)failed;

#pragma mark - Feeds
+(void)GetFeedGlobal:(Success)success failed:(Failed)failed;

@end
