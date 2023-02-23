/*
 * Title: AssistNowTemporary
 * Description: Trigger creates temporary token in the Lead record for the AssistNow application 
 * Author:  ldra
 * Created:  2018-10-09
 */

trigger createTemporaryToken on Lead (after insert) {
    AssistNow.updateTokens(Trigger.newMap.keySet());
}