@RestResource(urlMapping='/createUserForCommunity/')
global with sharing class CreateCommunityUserAPI {
    @HttpPost 
    global static CommunityUserAPIClassHelper.CreateUserResponse createCommunityUserPOST(CommunityUserAPIClassHelper.CreateUserInput userInput) {
        CommunityUserAPIClassHelper.CreateUserResponse response = CreateCommunityUserAPIHelper.createCommunityUser(userInput);
        return response;
    }    
}