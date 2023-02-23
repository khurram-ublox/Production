public without sharing class CommunitiesURLRedirect {
    String refererUrl = '';           
    public CommunitiesURLRedirect() {
        PageReference cPage = ApexPages.currentPage();
        this.refererUrl = cPage.getHeaders()!=null ? cPage.getHeaders().get('Referer'):null;
    }
	public PageReference redirectToSelfRegistration(){ 
        String baseUrl = Site.getBaseSecureUrl();
        string selfRegisterRelativeUrl = '/login/SelfRegister';
        string oldPageRelativeUrl = '/user-registration';
        String redirectTargetUrl = baseUrl+'/s'+selfRegisterRelativeUrl;
        PageReference cPage = ApexPages.currentPage();        
        if(cPage != null ){            
            URL referURL = null;
            //Considering ReferUrl because in Community VF pages are rendered as iframe under main page.
            if(!string.isEmpty(this.refererUrl) ){
                referURL = new URL(this.refererUrl);
            }else{
                referURL = new URL(cPage.getUrl());
            }
            String refURLPath = referURL.getPath();
            if(refURLPath.indexOf(oldPageRelativeUrl)>-1){
                String selfRegisterParamString = referURL.getQuery();
                if(!String.isEmpty(selfRegisterParamString)){
                    selfRegisterParamString = '?'+selfRegisterParamString;
                    redirectTargetUrl = redirectTargetUrl+selfRegisterParamString;
                }
            }                        
        }
        PageReference page = new PageReference(redirectTargetUrl);
        page.setRedirect(true);
        return page;
    }
}