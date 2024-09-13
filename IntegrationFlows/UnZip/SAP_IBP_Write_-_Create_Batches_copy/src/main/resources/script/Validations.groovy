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
import java.io.Reader


def validateBody(Message message) {
    try{
        //def headers = message.getHeaders();
        def body = message.getBody() as String
        //will not work because it uses the same xml parser
        containsIllegalCharacters(body)
        def xmlReader = new XmlSlurper().parse(message.getBody(java.io.Reader))
        //xmlReader?.IBPWriteBatches?.IBPWriteBatch?.@Name.find() {it -> containsIllegalCharacters(it.text())} != null
        
        
    }catch(Exception e){
        throw new Exception('Validaton Error: ' + e.getMessage(),e)
    }
    return message;
}

def containsIllegalCharacters(String stringToCheck){
    //(?<==")[^"]*([&<>])[^"]*(?=")/
    def pattern = /(?<==")[^"]*([<>])[^"]*(?=")/   
    def matcher = (stringToCheck =~ pattern)
    if(matcher.find()){throw new Exception('Illegal Character(s) in XML body(>;<)')}
    
}
