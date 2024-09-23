/* Refer the link below to learn more about the use cases of script.
https://help.sap.com/viewer/368c481cd6954bdfa5d0435479fd4eaf/Cloud/en-US/148851bf8192412cba1f9d2c17f4bd25.html

If you want to know more about the SCRIPT APIs, refer the link below
https://help.sap.com/doc/a56f52e1a58e4e2bac7f7adbf45b2e26/Cloud/en-US/index.html */
import com.sap.gateway.ip.core.customdev.util.Message;
import java.util.HashMap;
import com.sap.it.api.msglog.*;
import java.io.Reader;


def Message processData(Message message) {
	def messageLog = messageLogFactory.getMessageLog(message);

	if(messageLog != null){
	    def bodyAsString = message.getBody(java.lang.String);
	    def newWriteBatchRequests = new StringReader(message.getProperty('IBPNewWriteBatchRequests'));
        def xmlBatches = new XmlSlurper().parse(newWriteBatchRequests);
	    xmlBatches.children()?.IBPWriteBatch?.@Key.each { messageLog.addCustomHeaderProperty('Write Batch Key', it.text()) };	
	    xmlBatches.children()?.IBPWriteBatch.each {}collect{it.@Destination.text()}.each { it2 -> messageLog.addCustomHeaderProperty("Destination", it2) };	
	    xmlBatches.children()?.IBPWriteBatch.each {}collect{it.@Name.text()}.each { it2 -> messageLog.addCustomHeaderProperty("Batch Name", it2) };	
	    xmlBatches.children()?.IBPWriteBatch.each {}collect{it.@Command.text()}.each { it2 -> messageLog.addCustomHeaderProperty("Batch Command", it2) };	
	    xmlBatches.children()?.IBPWriteBatch.each {}collect{it.@ProcessUnchangedData.text()}.each { it2 -> messageLog.addCustomHeaderProperty("Process Unchanged Data", it2 = 'X' ? 'true' : 'false') };	
	    xmlBatches.children()?.IBPWriteBatch.each {}collect{it.@PlanningArea.text()}.each { it2 -> messageLog.addCustomHeaderProperty("Planning Area", it2) };	
	    xmlBatches.children()?.IBPWriteBatch.each {}collect{it.@PlanningAreaVersion.text()}.each { it2 -> messageLog.addCustomHeaderProperty("Planning Area Version", it2) };	
	    xmlBatches.children()?.IBPWriteBatch.each {}collect{it.@UserDefinedScenario.text()}.each { it2 -> messageLog.addCustomHeaderProperty("User Defined Scenario", it2) };	
	    xmlBatches.children()?.IBPWriteBatch.each {}collect{it.@TimeDisaggregationLevel.text()}.each { it2 -> messageLog.addCustomHeaderProperty("Time Disaggregation Level", it2) };	
	    xmlBatches.children()?.IBPWriteBatch?.@Id.each { messageLog.addCustomHeaderProperty('Write Batch ID', it.text()) };
	    xmlBatches.children()?.IBPWriteBatch?.CreateMessages?.Message.each { addLogCustomHeaderWithSplit(messageLog,"IBP Create Batches " + it?.@Type.text(), it.text()) };
	    
	    xmlBatches.children()?.IBPWriteBatch?.CreateException.each { 
	        addLogCustomHeaderWithSplit(messageLog,"IBP Create Batches Exeption", it.text());
	        addLogCustomHeaderWithSplit(messageLog,"IBP Create Batches FailureEndpoint", it?.@FailureEndpoint.text());
	        addLogCustomHeaderWithSplit(messageLog,"IBP Create Batches FailureRouteId", it?.@FailureRouteId.text());
        };

	    messageLog.addAttachmentAsString('IBPCreateBatchesResults', bodyAsString, 'text/xml');
	}
	return message;
}

def void addLogCustomHeaderWithSplit(MessageLog messageLog, String headerName, String content) {
    def messageLength = content.length();
    if (messageLength<=198) messageLog.addCustomHeaderProperty(headerName, content);
    else {
        int i = 0;
        for (int j = 0; j < messageLength;j += 198) {
            def k = j + 198;
            i++;
            messageLog.addCustomHeaderProperty(headerName + '.' + i.toString(), content.substring(j,k<=messageLength?k:messageLength));
        }
    }
}

def Message attachMergedRequestsToLog(Message message) {
	def messageLog = messageLogFactory.getMessageLog(message);

	if(messageLog != null){
	    def bodyAsString = message.getBody(java.lang.String);
	    messageLog.addAttachmentAsString('IBPCreateBatchesMergedRequests', bodyAsString, 'text/xml');
	}
	return message;
}





