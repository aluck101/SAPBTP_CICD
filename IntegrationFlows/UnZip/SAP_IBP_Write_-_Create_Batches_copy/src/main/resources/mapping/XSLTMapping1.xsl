<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
    xmlns:multimap="http://sap.com/xi/XI/SplitAndMerge" 
    xmlns:cpi="http://sap.com/it/" exclude-result-prefixes="cpi multimap xsl xs xsi">
	<xsl:output method="xml" encoding="utf-8" indent="yes"/>
	<xsl:preserve-space elements="*"/>
	<xsl:param name="exchange"/>
	<xsl:variable name="multimap" select="'http://sap.com/xi/XI/SplitAndMerge'"/>
	<xsl:template match="/">
        <xsl:value-of select="cpi:setHeader($exchange, 'IBPWriteStep', 'Create Batches')"/>
        <multimap:Messages>
            <xsl:apply-templates select="/multimap:Messages/*[namespace-uri()='http://sap.com/xi/XI/SplitAndMerge' and matches(local-name(),'^Message\d*$')]"/>
            <xsl:if test="local-name()=IBPWriteBatch">
                <multimap:Message>
                   <xsl:copy-of select="."/>
                </multimap:Message>                
            </xsl:if>
            <xsl:variable name="highestMultiCount" select="max(/multimap:Messages/*[namespace-uri()='http://sap.com/xi/XI/SplitAndMerge' and matches(local-name(),'^Message\d+$')]/number(substring(local-name(),8)))"/>
            <xsl:for-each select="/multimap:Messages/*[namespace-uri()='http://sap.com/xi/XI/SplitAndMerge' and matches(local-name(),'^Message\d*$')]/IBPWriteBatches/IBPWriteBatch[position()!=1]|/IBPWriteBatches/IBPWriteBatch">
                <multimap:Message>
                    <xsl:attribute name="MessageCounter" select="if($highestMultiCount>0) then $highestMultiCount + position() else position()"/>
                    <xsl:copy-of select="."/>
                </multimap:Message>
            </xsl:for-each>
	    </multimap:Messages>
	</xsl:template>
	<xsl:template match="/multimap:Messages/*[namespace-uri()='http://sap.com/xi/XI/SplitAndMerge' and matches(local-name(),'^Message\d*$')]">
	    <multimap:Message>
	        <xsl:attribute name="MessageCounter" select="substring(local-name(),8)"/>
	        <xsl:copy-of select="IBPWriteBatch|IBPWriteBatches/IBPWriteBatch[1]|*[local-name()!='IBPWriteBatches'and local-name()!='IBPWriteBatch']"/>
	    </multimap:Message>
	</xsl:template>
</xsl:stylesheet>
