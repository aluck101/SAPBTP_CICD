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
	
    <xsl:param name="IBPWriteBatches" select="'&lt;IBPWriteBatches/&gt;'"/>
	
	<xsl:template match="/">
	    <xsl:choose>
	        <xsl:when test="/multimap:Messages/multimap:Message[@MessageCounter > 0]">
	            <multimap:Messages>
	                <xsl:for-each select="/multimap:Messages/multimap:Message">
	                    <xsl:element name="multimap:Message{@MessageCounter}">
	                        <xsl:copy-of select="node()"/>
	                    </xsl:element>
	                </xsl:for-each>
	            </multimap:Messages>
	        </xsl:when>
	        <xsl:otherwise>
	            <xsl:copy-of select="/multimap:Messages/multimap:Message/node()"/>
	        </xsl:otherwise>
	    </xsl:choose>

        <xsl:variable name="newHeader">
            <IBPWriteBatches>
    	        <xsl:for-each select="parse-xml($IBPWriteBatches)/IBPWRiteBatches/IBPWriteBatch|/multimap:Messages/multimap:Message/IBPWriteBatch[@Id != '']|/IBPWriteBatch[@Id != '']">
    	            <xsl:sort select="@Index"/>
    	            <xsl:copy-of select="."/>
    	        </xsl:for-each>
	        </IBPWriteBatches>
	    </xsl:variable> 
        <xsl:value-of select="cpi:setHeader($exchange, 'IBPWriteBatches', serialize($newHeader))"/>
	</xsl:template>
</xsl:stylesheet>
