import com.sap.gateway.ip.core.customdev.util.Message;
import java.util.HashMap;
def Message processData(Message message) {
    def body=message.getBody(java.lang.String) as String;
    def sql_statement=new StringBuffer();
    def xml=new XmlSlurper().parseText(body);
    xml.row.each{
        sql_statement=sql_statement.append("INSERT INTO [dbo].[Material]([PRDID],[sourceTable])VALUES(");
        
        sql_statement=sql_statement.append("'").append(it.PRDID.text()).append("',");
        sql_statement=sql_statement.append("'").append(it.sourceTable.text()).append("'");
       

        sql_statement=sql_statement.append(");\n");
    }
    
    message.setBody(sql_statement.toString());
    return message;
    }