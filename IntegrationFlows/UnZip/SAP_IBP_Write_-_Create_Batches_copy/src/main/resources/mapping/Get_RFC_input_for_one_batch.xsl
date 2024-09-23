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
	<xsl:param name="SAP_MplCorrelationId"/>
	<xsl:template match="/multimap:Message/IBPWriteBatch">
		<xsl:value-of select="cpi:setProperty($exchange, 'IBPWriteBatchRequest', serialize(.))"/>
		<xsl:value-of select="cpi:setProperty($exchange, 'IBPCurrentDestination', @Destination)"/>
		<xsl:value-of select="cpi:setProperty($exchange, 'CurrentMessageCounter', ../@MessageCounter)"/>
		<_-IBP_-INTIS_BATCH_INIT>
			<xsl:element name="IV_BATCH_NAME">
				<xsl:value-of select="@Name"/>
			</xsl:element>
   		    <xsl:element name="IV_CALLER_ID">
				<xsl:value-of select="@CallerId"/>
			</xsl:element>
			<xsl:element name="IV_CALLER_DESCR">
				<xsl:value-of select="@CallerDescription"/>
			</xsl:element>
			<xsl:element name="IV_COMMAND">
				<xsl:value-of select="@Command"/>
			</xsl:element>
			<xsl:element name="IV_PROCESS_UNCHANGED_DATA">
				<xsl:value-of select="if(upper-case(@ProcessUnchangedData) = 'TRUE') then 'TRUE' else if(upper-case(@ProcessUnchangedData) = 'FALSE') then 'FALSE' else @ProcessUnchangedData"/>
			</xsl:element>
			<xsl:element name="IV_DETAILED_TRACELOG">
				<xsl:value-of select="if(upper-case(@DetailedTrace) = 'TRUE') then 'X' else ''"/>
			</xsl:element>
			<xsl:element name="IV_PLANNING_AREA">
				<xsl:value-of select="@PlanningArea"/>
			</xsl:element>
			<xsl:element name="IV_PLANNING_AREA_VERSION">
				<xsl:value-of select="@PlanningAreaVersion"/>
			</xsl:element>
			<xsl:element name="IV_TIME_PROFILE">
				<xsl:value-of select="@TimeProfile"/>
			</xsl:element>
		</_-IBP_-INTIS_BATCH_INIT>
	</xsl:template>
</xsl:stylesheet>

