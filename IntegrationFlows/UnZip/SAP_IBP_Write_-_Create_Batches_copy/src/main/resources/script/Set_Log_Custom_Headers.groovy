/*
    The integration developer needs to create the method processData 
    This method takes Message object of package com.sap.gateway.ip.core.customdev.util 
    which includes helper methods useful for the content developer:
    The methods available are:
    public java.lang.Object getBody()
    public void setBody(java.lang.Object exchangeBody)
    public java.util.Map<java.lang.String,java.lang.Object> getHeaders()
    public void setHeaders(java.util.Map<java.lang.String,java.lang.Object> exchangeHeaders)
    public void setHeader(java.lang.String name, java.lang.Object value)
    public java.util.Map<java.lang.String,java.lang.Object> getProperties()
    public void setProperties(java.util.Map<java.lang.String,java.lang.Object> exchangeProperties) 
    public void setProperty(java.lang.String name, java.lang.Object value)
    public java.util.List<com.sap.gateway.ip.core.customdev.util.SoapHeader> getSoapHeaders()
    public void setSoapHeaders(java.util.List<com.sap.gateway.ip.core.customdev.util.SoapHeader> soapHeaders) 
    public void clearSoapHeaders()
 */
import com.sap.gateway.ip.core.customdev.util.Message;
import com.sap.it.api.msglog.*;
import java.util.HashMap;
import java.util.UUID; 
import java.util.Iterator; 
import java.util.List; 
import java.lang.Thread;
import java.lang.String;
import java.lang.Integer;
import com.sap.it.api.mapping.*;
import groovy.xml.XmlUtil;


def Message addResultsToLog(Message message) {
	def headers = message.getHeaders();
	def ibpMessages = headers.get("IBPMessages");
	def messageLog = messageLogFactory.getMessageLog(message);
	def ibpStep = headers.get("IBPStep");
	def worstIBPMessageType = headers.get("IBPWorstMessageType");
	def messageTruncated = false;
	if (ibpMessages != null) {
    	for (int i = 0; i < ibpMessages.length; i++) {
    	    def content = mapAbapMessageTypeToString(ibpMessages.item(i).getFirstChild().getTextContent()) + ': ' + ibpMessages.item(i).getLastChild().getTextContent();
            if(messageLog != null){
                if (content.length() > 198) messageTruncated = true;
                messageLog.addCustomHeaderProperty('Message from IBP step ' + ibpStep, content);
            }
        }
        if (messageTruncated == true && messageLog != null) {
            messageLog.addCustomHeaderProperty('Message from IBP step ' + ibpStep, " (There is at least one truncated message. See attachment 'Response Body with Error' for the full message)");
        }
    
        if (worstIBPMessageType in ['Abort','Error']) {
    	    String customStatus = '';
            switch (ibpStep) {
                case 'Handshake': customStatus = 'IBP Handshake Error'; break;
                case 'WriteData': customStatus = 'IBP WriteData Error'; break;
                case 'ScheduleProcessing': customStatus = 'IBP ScheduleProcessing Error'; break;
                case 'GetProcessingStatus': customStatus = 'IBP GetProcessingStatus Error'; break;
                case 'GetProcessingMessages': customStatus = 'IBP GetProcessingMessages Error'; break;
                default: customStatus = "Unexpected IBP Step ${ibpStep}"; break;
    	    }
    	    message.setHeader("IFlowCustomStatus",customStatus);
    	    message.setProperty("SAP_MessageProcessingLogCustomStatus",customStatus);
    	}
	}
	return message;
}

def String mapAbapMessageTypeToString(String abapMessageType) {
    switch (abapMessageType) {
        case 'A': return 'Abort';
        case 'E': return 'Error';
        case 'W': return 'Warning';
        case 'I': return 'Information';
        case 'S': return 'Success';
        default: return abapMessageType;
    }
}

def Message raiseIBPErrorMessage(Message message) {
	def headers = message.getHeaders();
	def ibpStep = headers.get("IBPStep");	
	throw new Exception("Error in IBP step ${ibpStep}");
	return message;
}


def Message setLogCustomHeaders(Message message) {
	def messageLog = messageLogFactory.getMessageLog(message);

	if(messageLog != null){
	    def headers = message.getHeaders();
    	def logCustomHeaders = headers.get("LogCustomHeaders");
    	def logCustomProperties = headers.get("LogCustomProperties");
    	def logAttachmentHeaders = headers.get("LogAttachmentHeaders");
	    if(logCustomHeaders!=null) {
    	    logCustomHeaders.tokenize(',').each() {
    	        setLogCustomHeader(headers, messageLog, it);		
    	    }
	    }
	    if(logCustomProperties!=null) {
    	    logCustomProperties.tokenize(',').each() {
    	        setLogCustomProperty(message, messageLog, it);
    	    }
	    }
	    if(logAttachmentHeaders!=null) {
    	    logAttachmentHeaders.tokenize(',').each() {
    	        setLogAttachmentHeader(headers, messageLog, it);		
    	    }
	    }
	    
	}
	return message;
}

def void setLogCustomHeader(Map<String,Object> headers, MessageLog messageLog, String headerName) {
    
	def header = headers.get(headerName);		
	if(header!=null){
		messageLog.addCustomHeaderProperty(headerName, header.toString());		
    }
}

def void setLogCustomProperty(Message message, MessageLog messageLog, String propertyName) {
    
	def property = message.getProperty(propertyName);		
	if(property!=null){
		messageLog.addCustomHeaderProperty(propertyName, property.toString());		
    }
}

def void setLogAttachmentHeader(Map<String,Object> headers, MessageLog messageLog, String headerName) {
    
	def header = headers.get(headerName);		
	if(header!=null){
		messageLog.addAttachmentAsString(headerName, header.toString(), 'text/plain')	
    }
}

