<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
    xmlns:cpi="http://sap.com/it/" 
    xmlns:map="http://www.w3.org/2005/xpath-functions/map" 
    xmlns:multimap="http://sap.com/xi/XI/SplitAndMerge"
    exclude-result-prefixes="cpi map xs xsi xsl multimap">
	<xsl:output method="xml" encoding="utf-8" indent="yes"/>
	<xsl:preserve-space elements="*"/>
	<xsl:param name="exchange"/>
	<xsl:param name="IBPWriteBatchRequest" select="''"/>
	<xsl:param name="CamelExceptionCaught"/>
	<xsl:param name="CamelFailureEndpoint"/>
	<xsl:param name="CamelFailureRouteId"/>
	<xsl:param name="CamelFatalFallbackErrorHandler"/>
	<xsl:param name="CurrentMessageCounter"/>

	<xsl:template match="/">
	    <xsl:variable name="batchRequest" select="parse-xml($IBPWriteBatchRequest)"/>
	    <multimap:Message>
	        <xsl:attribute name="MessageCounter" select="$CurrentMessageCounter"/>
    	    <xsl:element name="IBPWriteBatch">
    	        <xsl:copy-of select="$batchRequest/IBPWriteBatch/@*[.!='']"/>
    	        <xsl:attribute name="Id">
    	            <xsl:value-of select="/*/EV_BATCH_ID"/>
    	        </xsl:attribute>
    	        <xsl:if test="/*/ET_MESSAGES/item">
        	        <xsl:element name="CreateMessages">
        	            <xsl:for-each select="/*/ET_MESSAGES/item">
                	        <xsl:element name="Message">
                	            <xsl:attribute name="Type" select="if (TYPE='A') then 'Abort' else if (TYPE='E') then 'Error' else if (TYPE='W') then 'Warning' else if (TYPE='I') then 'Information' else if (TYPE='S') then 'Success' else TYPE"/>
                	            <xsl:value-of select="/*/ET_MESSAGES/item/MESSAGE"/>
                	        </xsl:element>
            	        </xsl:for-each>
        	        </xsl:element>
    	        </xsl:if>
                <xsl:if test="$CamelExceptionCaught != ''">
                    <xsl:element name="CreateException">
                        <xsl:attribute name="FailureEndpoint" select="$CamelFailureEndpoint"/>
                        <xsl:attribute name="FailureRouteId" select="$CamelFailureRouteId"/>
                        <xsl:value-of select="$CamelExceptionCaught"/>
                    </xsl:element>
                </xsl:if>
    	    </xsl:element>
	    </multimap:Message>
	</xsl:template>
</xsl:stylesheet>