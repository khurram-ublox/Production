global with sharing class SKYVVA_UBloxAccountIntegration 
    extends skyvvasolutions.IProcessCustomAbs  
    implements skyvvasolutions.GisOdbgIntegration.IProcess
    {
    
    public static final String EXCEPTIONAL_ERR_MSG_1 = 'unable to obtain exclusive access to this record';
    public static final String EXCEPTIONAL_ERR_MSG_2 = 'no exclusive access';

    List<skyvvasolutions__IMapping__c> mapAccount;
    
    List<skyvvasolutions__IMessage__c> listMessage;
    List<Map<String,String>> aMessage;
    String interfaceIdTemp;
    
  
    private final Schema.SObjectField extId=Account.Customer_No__c;
    
    List<Account> listAcc = new List<Account>();
    
    
    Map<String,Account> mapUsedToBeImportedAccount=new Map<String,Account>();
    
    
    global override void init(String interfaceId) {
        
        //mapAccount = IServicesUtil.loadMapping(interfaceId);
        mapAccount = [Select skyvvasolutions__Type__c,skyvvasolutions__Target_Object__c,
                        skyvvasolutions__EXT_ID__c,skyvvasolutions__InFixToPostFix__c,
                        skyvvasolutions__Target__c,skyvvasolutions__Source__c, 
                        skyvvasolutions__Source_Long__c,skyvvasolutions__Source_Type__c,
                        skyvvasolutions__Target_Type__c,skyvvasolutions__Interface__c,Id,
                        skyvvasolutions__Interface__r.skyvvasolutions__No_Import_NULL_value__c 
                        From skyvvasolutions__IMapping__c where skyvvasolutions__Interface__c=:interfaceId];
        // should raise an exception if the mapping is empty
        
        interfaceIdTemp = interfaceId;
       
    
        
        if (listAcc!=null) {
            listAcc.clear();
        }
    }
    
    
    public String genAbacusZipCode(Map<String,String> mapRecord){
    
        String zip=mapRecord.get('zipcode'); //Abacus
        
        /*#1040, 08-May-2014, City and Start, ZipCode come separate fields
        if(zip==null || zip==''){ //let's try find in resp imported Abacus city
            String[] abacusCSZ=splitAbacusCityStateZip(mapRecord.get('city'));
            zip=abacusCSZ[2]!=null?abacusCSZ[2]:'';
         }    
         */
         return zip;
   }
       
    
    public Map<String,Account> getMapExisitingAccounts(skyvvasolutions.IServicesUtil.IMessageResult iResult){
    
        //System.debug('>>> getMapExisitingAccounts() entered');
        
        Map<String,Account> mExistingAccounts=new Map<String,Account>(); 
        List<Map<String,String>> aMessage = iResult.listMapRecord;
        
        //Abacusi
        Set<String> sNames=new Set<String>(); //store all imported Abacus acc names
        Map<String,String> mNameZipCodeAbacus=new Map<String,String>(); //store all Abacus acc name and zip code
        Map<String,String> mCusNoAbacus=new Map<String,String>(); //store all Abacus acc cus no
        
        if(aMessage==null) return mExistingAccounts;
        
        //loop thru message
        for(integer i=0;i<aMessage.size();i++){
            Map<String,String> mapRecord = aMessage.get(i);
            
            if(mapRecord!=null){
            
                String accName=mapRecord.get('companyname'); //Abacus 
                if(accName!=null) sNames.add(accName.trim());   
                
                String cusNo=mapRecord.get('customernumber'); //Abacus 
                if(cusNo!=null) mCusNoAbacus.put(cusNo,cusNo);            
                
                String zip=genAbacusZipCode(mapRecord);  
                 String nameZipcode2=(accName!=null?accName:'')+(zip!=null?zip:'');
                 //System.debug('>>> nameZipcode: ' + nameZipcode2);
                 
                 if(nameZipcode2!=null && nameZipcode2.length()>0) mNameZipCodeAbacus.put(nameZipcode2.toLowerCase(),nameZipcode2.toLowerCase()); 
            }
        }
        
        System.debug('>>> sNames: ' + sNames + '; mNameZipCodeAbacus: ' + mNameZipCodeAbacus.values() + ';  mCusNoAbacus: ' + mCusNoAbacus);        
               
        
        /**CASE: in SF there are more than one Accs with same name and billing postal code but one no Customer No and other has
        ** and the import acc match those accounts, so update which account has Customer No 
        */        
        //Find all Accounts that have Customer No and put their Name and Billing Zip code into a map
        Map<String,String> mapNameZipSF=new Map<String,String>(); //store existing SF account for those with Customer No
        Map<String,String> mapCusNoSF=new Map<String,String>();  //SF
        Map<String,Account[]> mNameZipToAccountsSF=new Map<String,Account[]>();
                
        for(Account acc:[select name,id,Customer_No__c, BillingPostalCode from Account where name in:sNames or Customer_No__c in:mCusNoAbacus.keyset()]){           
                
                String accName=(acc.Name!=null?acc.Name:'');//SF
                String zipCode=(acc.BillingPostalCode!=null?acc.BillingPostalCode:'');//SF
                String key1=(accName+zipCode).toLowerCase();//SF
                
                /*Account[] lAccounts=mNameZipToAccountsSF.get(key1);
                if(lAccounts==null) lAccounts=new List<Account>();
                if(acc!=null) lAccounts.add(acc);               
                mNameZipToAccountsSF.put(key1,lAccounts); */
                
                if(acc.Customer_No__c!=null) {                  
                    mapNameZipSF.put(key1,key1);
                    
                    
                    mapCusNoSF.put(acc.Customer_No__c,acc.Customer_No__c);
                }               
        }
        System.debug('>>> mapNameZipSF: ' + mapNameZipSF + '; mapCusNoSF: ' + mapCusNoSF);// + '; mNameZipToAccountsSF: ' + mNameZipToAccountsSF);
        

        for(Account acc:[select name, id, Customer_No__c, Linked_to_Abacus__c, BillingPostalCode,ShippingStreet 
                        from Account where name in:sNames or Customer_No__c in:mCusNoAbacus.keyset()]){
            
            String accName=(acc.Name!=null?acc.Name:''); //SF
            String zipCode=(acc.BillingPostalCode!=null?acc.BillingPostalCode:'');  //SF
            //System.debug('>>> the sf account: ' + acc + '; Customer_No__c' + acc.Customer_No__c);                        
            
            String key1=(accName+zipCode).toLowerCase(); //SF
            //System.debug('>>> acc key1: ' +key1);
            //System.debug('>>> mNameZipCodeAbacus.get(key1) ' + mNameZipCodeAbacus.get(key1) + '; mapNameZipSF.get(key1) ' + mapNameZipSF.get(key1));                       
            
            //SF account has Customer NO
            if(mapCusNoSF.get(acc.Customer_No__c)!=null){
                
                //store sf account used to be imported from xml to update part of Abacus Street based on imported data
                //the key is based on Customer No
                if(acc.Customer_No__c!=null && acc.Linked_to_Abacus__c!=''){                
                    //System.debug('>>> the sf account used to be imported from abacus');
                    mapUsedToBeImportedAccount.put(acc.Customer_No__c,acc);
                }  
                
                //if(mNameZipCodeAbacus.get(key1)==null){ //a different acc in sf with customer no existing in abacus import data, do not add to the map
                    //System.debug('>>> This account has customer no exists in Sf. Nothing done');
                    continue;   
                //}
            }
            
            /*
            //In case, in Sf there are many accounts with the same name and visiting address
            Boolean hasCusNo=false; //default
            Account[] accounts=mNameZipToAccountsSF.get(key1);
            System.debug('>>> in loop accounts: ' +accounts);
            if(accounts!=null){
                hasCusNo=checkAccountsWithCusNo(accounts);
            }
            System.debug('>>> in loop hasCusNo: ' +hasCusNo);                        
            //one of them has customer no, so do not add to the map
            if(hasCusNo==true){
                System.debug('>>> The other same account has custome no. Nothing done');
                continue;
            }  */         
            
            
            /**
            SF account has no customer no
            */            
            //Rule in order to match a new Abacus account with an existing Salesforce account: 
            //- Account Name needs to be identical (capital and small letters can be different, eg THALES can be matched with Thales)
            //- ZIP code needs to be identical
            //- Salesforce Account does not contain a customer number yet 
            if(acc.Customer_No__c==null && mNameZipCodeAbacus.get(key1)!=null){//i.e. exists in sf (with no Customer No)
                
                //This account has no other sf account with  the same name and zip code
                if(mapNameZipSF.get(key1)==null     //
                    && mapNameZipSF.get(accName.toLowerCase())==null) //not in mapNameZipSF (existing acc with Customer NO)
                {
                    
                    //System.debug('>>>> This account has no other sf account with the same name and zip code');
                    
                    //store that account (no customer No) but linked to Abacus account (same name and zip code[Abacus-SF zipcode])  
                    mExistingAccounts.put(key1,acc);
                }
            }                                                      
        }
        
        //System.debug('>>> mExistingAccounts: ' + mExistingAccounts.values());        
        //System.debug('>>> mapUsedToBeImportedAccount: ' + mapUsedToBeImportedAccount.values());        
        //System.debug('>>> getMapExisitingAccounts() finished');
        
        return mExistingAccounts;
    }
 
    /**
* Search all Failed Message for the given interface and based on the ext id field name
* Map<String, String> : extId value, Message Id
*
*
*/
    public static Map<String,String> searchAllFailedMessages(String interfaceId, String extIdFieldName){
        
        Map<String,String> mData=new Map<String,String>();

        for(skyvvasolutions__IData__c d:[Select skyvvasolutions__Value__c,skyvvasolutions__Message__r.Name 
                        From skyvvasolutions__IData__c 
                        where skyvvasolutions__Name__c=:extIdFieldName 
                        AND skyvvasolutions__Message__r.skyvvasolutions__Interface__c=:interfaceId 
                        AND skyvvasolutions__Message__r.skyvvasolutions__Status__c='Failed' 
                        order by skyvvasolutions__Message__r.Name desc]){
            mData.put(d.skyvvasolutions__value__c, d.skyvvasolutions__Message__r.Name);
        }  
        return mData;
    }

    public static String appendLog(Database.Error[] err) {
        
        String sError = '';
        if (err!=null && err.size()>0)
        for (Database.Error e : err) {
            sError =+ e.getMessage();
        }
    
        return sError; 
    }

    global override List<skyvvasolutions.IServicesUtil.UpsertResult2> upsert2(){
    
        BeforeUpdateAbacusAccount.fromAbacus=true;
        
       // System.debug('>>> Account: List<IServices.UpsertResult2> upsert2() entered');
       // System.debug('>>> account record size: ' + listAcc.size());
        
        List<skyvvasolutions.IServicesUtil.UpsertResult2> upsertRes = new List<skyvvasolutions.IServicesUtil.UpsertResult2>();   
        
        // load all pending message for the given interface
        Map<String, String> mDataFailed = searchAllFailedMessages(interfaceIdTemp, 'CustomerNumber');
        
                           
        
        integer mes =0;    
        for(Account acc: listAcc){
        
          // System.debug('>>> acc: ' + acc);
            skyvvasolutions__IMessage__c imessage = listMessage.get(mes++);
            
            
            try {
                String resid;
                boolean success = true;
                String errors='';
                
                //System.debug('UBloxAccountIntegration.upsert2 acc.id' + acc.Id);
                
                // for this case check if there is a Failed Message, if so dont process
                    String messageId = mDataFailed.get(acc.Customer_No__c);
                    //System.debug('Check existing failed message id=' + messageId  + ' with value ' + acc.Customer_No__c);
                    if (messageId!=null && messageId!=imessage.Name) {
                        // the message stays pending with a comment
                         imessage.skyvvasolutions__Comment__c = 'Message queued - Waiting Message=' + messageId + ' to be processed first';
                         imessage.skyvvasolutions__Modification_Date__c = System.now();
                         imessage.skyvvasolutions__Status__c ='Pending';
                         continue; 
                    }
                    
                    if(acc.Id!=null){//match with the existing in sf
                    
    
                            update acc; //update the existing one
                            imessage.skyvvasolutions__Comment__c ='Modification of an Account';
                            
                        
                    }else{            
                        Database.UpsertResult u=Database.upsert(acc,extId,false);
                        resid = u.getId();
                        success = u.isSuccess();
                        if(u.isCreated()) {
                        
                            imessage.skyvvasolutions__Comment__c = 'Creation of an Account';
                        }
                        else {
                            imessage.skyvvasolutions__Comment__c ='Modification of an Account';
                        }
                        errors = appendLog(u.getErrors());
                    }
                
                    if (success) {
                        imessage.skyvvasolutions__Status__c = 'Completed';
                        imessage.skyvvasolutions__Related_To__c = resid;
                        imessage.skyvvasolutions__Modification_Date__c = System.now();
                        //imessage.Comment__c ='';
                        
                        // remove from failed msg
                        if (acc.Customer_No__c!=null) {
                            messageId = mDataFailed.get(acc.Customer_No__c);
                            if (messageId!=null && messageId==imessage.Name) {
                                mDataFailed.remove(acc.Customer_No__c);
                             }
                            
                        }
                    
                    }
                    else {
                        
                        //no exclusive acess, the msg status should be yellow (pending)
                        if(errors.toLowerCase().contains(EXCEPTIONAL_ERR_MSG_1) ||
                            errors.toLowerCase().contains(EXCEPTIONAL_ERR_MSG_2)){
                            
                            imessage.skyvvasolutions__Status__c = 'Pending';    
                        }
                        else{    
                                        
                            imessage.skyvvasolutions__Status__c = 'Failed';
                        }
                        
                        imessage.skyvvasolutions__Modification_Date__c = System.now();
                        imessage.skyvvasolutions__Comment__c =errors;
                        
                        if (acc.Customer_No__c!=null)
                            mDataFailed.put(acc.Customer_No__c, imessage.Name);
                    }
                    
            
            }
             catch (Exception e) {
                // exception like duplicate
                
                    //no exclusive acess, the msg status should be yellow (pending)
                    if(e.getMessage().toLowerCase().contains(EXCEPTIONAL_ERR_MSG_1) ||
                        e.getMessage().toLowerCase().contains(EXCEPTIONAL_ERR_MSG_2)){
                            
                        imessage.skyvvasolutions__Status__c = 'Pending';    
                    }
                    else{  
                                      
                        imessage.skyvvasolutions__Status__c = 'Failed';
                    }
                        
                    imessage.skyvvasolutions__Modification_Date__c = System.now();
                    imessage.skyvvasolutions__Comment__c = e.getMessage();
                    
                    if (acc.Customer_No__c!=null)
                        mDataFailed.put(acc.Customer_No__c, imessage.Name);
                
                    
            }
        }
     
        
        //System.debug('>>> Account UpsertResult2 size: ' + upsertRes.size());        
        //System.debug('>>> Account: List<IServices.UpsertResult2> upsert2() finished');
        
        return upsertRes;
        
    }
      
    
    global override void doMap(skyvvasolutions.IServicesUtil.IMessageResult iResult){
        //system.debug('>>>>>>>>>>iResult:'+iResult);
        
        if(iResult==null) return;
        
        aMessage = iResult.listMapRecord;
        
        // save the list of message
        listMessage = iResult.listMessage;
        
        
        // check for failed message 
        
        
        if(aMessage==null) return;
        
        Map<String,Account> mExistingAccounts=getMapExisitingAccounts(iResult);
    
        for(integer i=0;i<aMessage.size();i++){
        
            try {
                 
                 //System.debug('>>> account: before doMap');
                 
                 Map<String,String> mapRecord = aMessage.get(i);
                 
                 if(mapRecord==null) continue;
                 
                 //System.debug('>>> mapRecord: ' + mapRecord.values());
                 
                 String accName=(mapRecord.get('companyname')!=null?mapRecord.get('companyname'):'');                 
                 String zip=mapRecord.get('zipcode')!=null?mapRecord.get('zipcode'):'';
                 
                 /*#1040, 08-May-2014, No need bzc City, State ZipCode are comming separated fields
                 String[] abacusCSZ=splitAbacusCityStateZip(mapRecord.get('city'));
                 if(zip==null || zip=='') zip=abacusCSZ[2]!=null?abacusCSZ[2]:'';
                 */
                 
                 String key1=(accName+zip).toLowerCase();
                 
                 Account acc =(mExistingAccounts!=null?mExistingAccounts.get(key1):null);
                 
                 //System.debug('>>> acount from existing : ' + acc);
                 
                 if(acc==null) acc= new Account();
                 
                 autoMap(acc,mapRecord,mapAccount);   
                 
                 //System.debug('>>> account: after doMap'); 
                     
                 //Account.ShippingCity: Abacus City
                 //   Account.ShippingPostalCode: Abacus Zip or Postal code
                 // Account.ShippingState: Abacus State
                 
                 
                 //Manage Abacus City, State & Zip or Postal code
                 //String[] abacusCSZ2=splitAbacusCityStateZip(acc.ShippingCity);
                 
                 /*#1040, 08-May-2014, No need bzc City, State ZipCode are comming separated fields
                 acc.ShippingCity=abacusCSZ[0];
                 acc.ShippingState=abacusCSZ[1];
                 acc.ShippingPostalCode=zip;
                 */
                 
                 //if(acc.ShippingPostalCode==null) acc.ShippingPostalCode=abacusCSZ2[2];   
                     
                 //System.debug('>>> city: ' + acc.ShippingCity + ' state: ' + acc.ShippingState + ' zip: ' + acc.ShippingPostalCode);
                 
                 //Mange Abacus Street: Address AddressExtension NameExtension1 NameExtension2
                 String vorname=mapRecord.get('nameextension1');//
                 String z1=mapRecord.get('nameextension2');//
                 String z2=mapRecord.get('address');//
                 String z3=mapRecord.get('addressextension');//
                 //New
                 String z4=mapRecord.get('addressextension2');
                 String z5=mapRecord.get('addressextension3');                  
                 
                 
                 //System.debug('>>> before usedToImportedAcc: vorname: ' + vorname + '; z1: '+ z1 + '; z2: ' + z2 + '; z3: ' + z3 + '; z4: ' + z4 + '; z5: ' + z5);                                  
                 Account usedToImportedAcc=mapUsedToBeImportedAccount.get(acc.Customer_No__c);
                 //System.debug('>>> usedToImportedAcc: ' + usedToImportedAcc);
                 if(usedToImportedAcc!=null){                     
                     if(usedToImportedAcc.ShippingStreet!=null) { //exist
                         String[] addr=usedToImportedAcc.ShippingStreet.trim().split('\n'); //0: name ext1; 1: name ext2; 2: address; 3: addExt
                         //System.debug('>>> existing account street: '  +addr);
                         
                         if(addr.size()>=4){
                             //System.debug('>>> start managing the existing imported account street');
                             vorname=(vorname==null?addr[0]:vorname); //null:not imported from xml file, use existing value
                             z1=(z1==null?addr[1]:z1);
                             z2=(z2==null?addr[2]:z2);
                             z3=(z3==null?addr[3]:z3);
                         }
                         
                         if(addr.size()==6){                                                         
                             z4=(z4==null?addr[4]:z4);
                             z5=(z3==null?addr[5]:z5);
                         }
                     }
                 }
                 //System.debug('>>> after usedToImportedAcc: vorname: ' + vorname + '; z1: '+ z1 + '; z2: ' + z2 + '; z3: ' + z3 + '; z4: ' + z4 + '; z5: ' + z5);
                 
                 
                 if(vorname!=null || z1!=null || z2!=null || z3!=null || z4!=null || z5!=null){
                     //acc.ShippingStreet=  vorname + '\n' + z1+ '\n' + z2 + '\n' + z3 + '\n' + z4 + '\n' + z5;
                     acc.ShippingStreet=(vorname!=null?vorname:'') + '\n' + (z1!=null?z1:'')+ '\n' + (z2!=null?z2:'') + '\n' + (z3!=null?z3:'') + '\n' + (z4!=null?z4:'') + '\n' + (z5!=null?z5:'');
                 }
                 //System.debug('>>> street: ' + acc.ShippingStreet);              
                 
                 
                 listAcc.add(acc);
                 
            }       
        
            catch (Exception e) {           
                iResult.addMappingError(i, e.getMessage());
            }   
        }
            
        
      
    }

    /*
    * Country specific formats:
    * US: Entered as Ort="Palm Bay, FL  32905"=>split in City, State, Zip
    * CA: Entered as Ort="Sherbrooke, QC J1K 2R1"=>split in City, State, Zip(Comma separated, as somtimes state is written in full)       
    */
    
    /*#1040, 08-May-2014, No need bzc City, State, ZipCode are comming separated fields
    private String[] splitAbacusCityStateZip(String city){
        
        String[] abacusCSZ=new String[3]; 
        
        if(city!=null){

            //split City and others
            String[] temp=city.split(',' , 2);
            
            abacusCSZ[0]=temp[0].trim();
                        
            if(temp.size()==2){             
                //split State and Zip
                String[] temp2=temp[1].trim().split(' ' , 2);               

                abacusCSZ[1]=temp2[0].trim();
                
                if(temp2.size()==2){
                    abacusCSZ[2]=temp2[1].trim(); 
                } 
            }               
        }
        
        return abacusCSZ; 
    
    }
    */
    

    
    
    /** LOG INFO: 
    
    + Static-defined Abacus-SF mapping fields
    
    + Dealing with Abacus City with Postal Code
        Country specific formats:
        - US: Entered as Ort="Palm Bay, FL  32905"=>split in City, State, Zip
        -CA: Entered as Ort="Sherbrooke, QC J1K 2R1"=>split in City, State, Zip(Comma separated, as somtimes state is written in full)          
    
    + Rule in order to match a new Abacus account with an existing Salesforce account: 
       - Account Name needs to be identical (capital and small letters can be different, eg THALES can be matched with Thales)
       - ZIP code needs to be identical
       - Salesforce Account does not contain a customer number yet 
    
    + Manage Ability to modify all fields accounts in SF for Abacus import
      key Fields: Account Name, Phone, Fax and Customer No
      //BeforeUpdateAbacusAccount.fromAbacus=true;
       
    +  In SF, there are more than one Accs with same name and billing postal code but one no Customer No and other has
       and the import acc match those accounts, so update which account with Customer No                     
    
       
    + PB with No Exclusive Access
        In our implementation we often have the case that a record cannot be updated because there is no exclusive access. 
        This is a situation which in my view should have status “yellow” and should not create an alert. 
        
    
    === last modified: 06-05-09
       
    */

}