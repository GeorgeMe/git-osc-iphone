//
//  GLGitlabApi+Projects.m
//  objc gitlab api
//
//  Created by Jeff Trespalacios on 1/22/14.
//  Copyright (c) 2014 Indatus. All rights reserved.
//

#import "GLGitlabApi+Projects.h"
#import "GLGitlabApi+Private.h"
#import "GLProject.h"
#import "GLUser.h"
#import "GLEvent.h"

static NSString * const kProjectEndpoint = @"/projects";
static NSString * const kProjectOwnedProjectsEndPoint = @"/projects/owned";
static NSString * const kProjectAllProjectsEndPoint = @"/projects/all";
static NSString * const kProjectSingleProjectEndPoint = @"/projects/%llu";
static NSString * const kProjectEndpointForUser = @"/projects/user/%llu";
static NSString * const kProjectEventsEndPoint = @"/projects/%llu/events";
static NSString * const kProjectUsersEndPoint = @"/projects/%llu/members";
static NSString * const kProjectPopularProjectEndPoint = @"/projects/popular";
static NSString * const kProjectRecommendedProjectEndPoint = @"/projects/featured";
static NSString * const kProjectLatestProjectEndPoint = @"/projects/latest";

static NSString * const kKeyPrivate_token = @"private_token";

@implementation GLGitlabApi (Projects)
#pragma mark - Project Methods

- (GLNetworkOperation *)getUsersProjectsWithPrivateToken:(NSString *)privateToken
                                                 success:(GLGitlabSuccessBlock)successBlock
                                                 failure:(GLGitlabFailureBlock)failureBlock

{
    NSMutableURLRequest *request = [self requestForEndPoint:kProjectEndpoint
                                                     params:@{kKeyPrivate_token: privateToken}
                                                     method:GLNetworkOperationGetMethod];
    
    GLNetworkOperationSuccessBlock localSuccessBlock = [self multipleObjectSuccessBlockForClass:[GLProject class] successBlock:successBlock];
    GLNetworkOperationFailureBlock localFailureBlock = [self defaultFailureBlock:failureBlock];
    
    return [self queueOperationWithRequest:request
                                      type:GLNetworkOperationTypeJson
                                   success:localSuccessBlock
                                   failure:localFailureBlock];
}

- (GLNetworkOperation *)getUsersOwnedProjectsSuccess:(GLGitlabSuccessBlock)successBlock
                                             failure:(GLGitlabFailureBlock)failureBlock
{
    NSMutableURLRequest *request = [self requestForEndPoint:kProjectOwnedProjectsEndPoint
                                                     method:GLNetworkOperationGetMethod];
    
    GLNetworkOperationSuccessBlock localSuccessBlock = [self multipleObjectSuccessBlockForClass:[GLProject class] successBlock:successBlock];
    GLNetworkOperationFailureBlock localFailureBlock = [self defaultFailureBlock:failureBlock];
    
    return [self queueOperationWithRequest:request
                                      type:GLNetworkOperationTypeJson
                                   success:localSuccessBlock
                                   failure:localFailureBlock];
}

- (GLNetworkOperation *)getProjectWithId:(int64_t)projectId
                                 success:(GLGitlabSuccessBlock)successBlock
                                 failure:(GLGitlabFailureBlock)failureBlock
{
    NSMutableURLRequest *request = [self requestForEndPoint:[NSString stringWithFormat:kProjectSingleProjectEndPoint, projectId]
                                                     method:GLNetworkOperationGetMethod];
    
    GLNetworkOperationSuccessBlock localSuccessBlock = [self singleObjectSuccessBlockForClass:[GLProject class] successBlock:successBlock];
    GLNetworkOperationFailureBlock localFailureBlock = [self defaultFailureBlock:failureBlock];
    
    return [self queueOperationWithRequest:request
                                      type:GLNetworkOperationTypeJson
                                   success:localSuccessBlock
                                   failure:localFailureBlock];
}

- (GLNetworkOperation *)getProjectEventsForProject:(GLProject *)project
                                           success:(GLGitlabSuccessBlock)successBlock
                                           failure:(GLGitlabFailureBlock)failureBlock
{
    return [self getProjectEventsForProjectId:project.projectId
                                      success:successBlock
                                      failure:failureBlock];
}

- (GLNetworkOperation *)getProjectTeamUsers:(int64_t)projectId
                                    success:(GLGitlabSuccessBlock)successBlock
                                    failure:(GLGitlabFailureBlock)failureBlock
{
    NSMutableURLRequest *request = [self requestForEndPoint:[NSString stringWithFormat:kProjectUsersEndPoint, projectId]
                                                     method:GLNetworkOperationGetMethod];
    
    GLNetworkOperationSuccessBlock localCussessBlock = [self multipleObjectSuccessBlockForClass:[GLUser class] successBlock:successBlock];
    GLNetworkOperationFailureBlock localFailureBlock = [self defaultFailureBlock:failureBlock];
    
    return [self queueOperationWithRequest:request
                                      type:GLNetworkOperationTypeJson
                                   success:localCussessBlock
                                   failure:localFailureBlock];
}

- (GLNetworkOperation *)getProjectEventsForProjectId:(int64_t)projectId
                                             success:(GLGitlabSuccessBlock)successBlock
                                             failure:(GLGitlabFailureBlock)failureBlock
{
    NSMutableURLRequest *request = [self requestForEndPoint:[NSString stringWithFormat:kProjectEventsEndPoint, projectId]
                                                     method:GLNetworkOperationGetMethod];
    request.HTTPMethod = GLNetworkOperationGetMethod;
    
    GLNetworkOperationSuccessBlock localSuccessBlock = [self multipleObjectSuccessBlockForClass:[GLEvent class] successBlock:successBlock];
    GLNetworkOperationFailureBlock localFailureBlock = [self defaultFailureBlock:failureBlock];
    
    return [self queueOperationWithRequest:request
                                      type:GLNetworkOperationTypeJson
                                   success:localSuccessBlock
                                   failure:localFailureBlock];
}

- (GLNetworkOperation *)createProjectNamed:(NSString *)projectName
                                   success:(GLGitlabSuccessBlock)successBlock
                                   failure:(GLGitlabFailureBlock)failureBlock
{
    GLProject *project = [GLProject new];
    project.name = projectName;
    
    return [self createProject:project
                       success:successBlock
                       failure:failureBlock];
}

- (GLNetworkOperation *)createProject:(GLProject *)project
                              success:(GLGitlabSuccessBlock)successBlock
                              failure:(GLGitlabFailureBlock)failureBlock
{
    NSMutableURLRequest *request = [self requestForEndPoint:kProjectEndpoint
                                                     method:GLNetworkOperationPostMethod];
    request.HTTPBody = [self urlEncodeParams:[project jsonCreateRepresentation]];
    
    GLNetworkOperationSuccessBlock localSuccessBlock = [self singleObjectSuccessBlockForClass:[GLProject class] successBlock:successBlock];
    GLNetworkOperationFailureBlock localFailureBlock = [self defaultFailureBlock:failureBlock];
    
    return [self queueOperationWithRequest:request
                                      type:GLNetworkOperationTypeJson
                                   success:localSuccessBlock
                                   failure:localFailureBlock];
}


- (GLNetworkOperation *)createProjectNamed:(NSString *)projectName
                                   forUser:(GLUser *)user
                                   success:(GLGitlabSuccessBlock)successBlock
                                   failure:(GLGitlabFailureBlock)failureBlock
{
    GLProject *project = [GLProject new];
    project.name = projectName;
    
    return [self createProject:project
                       forUser:user
                       success:successBlock
                       failure:failureBlock];
}

- (GLNetworkOperation *)createProject:(GLProject *)project
                              forUser:(GLUser *)user
                              success:(GLGitlabSuccessBlock)successBlock
                              failure:(GLGitlabFailureBlock)failureBlock
{
    NSMutableURLRequest *request = [self requestForEndPoint:[NSString stringWithFormat:kProjectEndpointForUser, user.userId]
                                                     method:GLNetworkOperationPostMethod];
    request.HTTPBody = [self urlEncodeParams:[project jsonCreateRepresentation]];
    
    GLNetworkOperationSuccessBlock localSuccessBlock = [self singleObjectSuccessBlockForClass:[GLProject class] successBlock:successBlock];
    GLNetworkOperationFailureBlock localFailureBlock = [self defaultFailureBlock:failureBlock];
    
    return [self queueOperationWithRequest:request
                                      type:GLNetworkOperationTypeJson
                                   success:localSuccessBlock
                                   failure:localFailureBlock];
}

- (GLNetworkOperation *)getExtraProjectsType:(int)type
                                        Page:(int)page
                                     Success:(GLGitlabSuccessBlock)successBlock
                                     Failure:(GLGitlabFailureBlock)failureBlock
{
    NSDictionary *parameters = @{@"page": [NSNumber numberWithInt:page]};
    NSString *endPoint;
    switch (type) {
        case 0:
            endPoint = kProjectRecommendedProjectEndPoint;break;
        case 1:
            endPoint = kProjectPopularProjectEndPoint;break;
        default:
            endPoint = kProjectLatestProjectEndPoint;break;
    }
    NSMutableURLRequest *request = [self requestForEndPoint:endPoint
                                                     params:parameters
                                                     method:GLNetworkOperationGetMethod];
    
    GLNetworkOperationSuccessBlock localSuccessBlock = [self multipleObjectSuccessBlockForClass:[GLProject class] successBlock:successBlock];
    GLNetworkOperationFailureBlock localFailureBlock = [self defaultFailureBlock:failureBlock];
    
    return [self queueOperationWithRequest:request
                                      type:GLNetworkOperationTypeJson
                                   success:localSuccessBlock
                                   failure:localFailureBlock];
}


@end
