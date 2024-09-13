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
	<xsl:param name="IBPWriteBatchKey1" select="''"/>
	<xsl:param name="DestinationforSAPIBP" select="''"/>
	<xsl:param name="IBPWriteBatchName1"/>
	<xsl:param name="CallerDescription"/>
	<xsl:param name="WriteBatchCommand"/>
	<xsl:param name="DetailedTraceLog"/>
	<xsl:param name="ProcessUnchangedData"/>
	<xsl:param name="PlanningArea"/>
	<xsl:param name="PlanningAreaVersion"/>
	<xsl:param name="UserDefinedScenario"/>
	<xsl:param name="TimeDisaggregationLevel"/>
	<xsl:param name="TimeProfile"/>
	<xsl:param name="IBPWriteBatches" select="'&lt;IBPWriteBatches/&gt;'"/>
	<xsl:param name="SAP_MplCorrelationId"/>
	<xsl:variable name="multimap" select="'http://sap.com/xi/XI/SplitAndMerge'"/>
	<xsl:variable name="highestExistingIndex" select="max((0,parse-xml($IBPWriteBatches)/IBPWriteBatches/IBPWriteBatch/xs:integer(@Index)))"/>
	<xsl:template match="/">
	    <multimap:Messages>
	         <xsl:iterate select="/multimap:Messages/multimap:Message">
	            <xsl:param name="currentIndex" select="$highestExistingIndex"/>
	            <xsl:param name="shortenedMessages" select="''"/>
	            <xsl:variable name="newIndex" select="$currentIndex + (if(IBPWriteBatch) then 1 else 0)"/>
	            <xsl:variable name="messageContent">
            	    <xsl:choose>
            	        <xsl:when test="IBPWriteBatch">
            	            <xsl:apply-templates select="IBPWriteBatch">
            	                <xsl:with-param name="newIndex" select="$newIndex"/>
            	            </xsl:apply-templates>
            	        </xsl:when>
            	        <xsl:otherwise>
            	            <xsl:copy-of select="node()"/>
            	        </xsl:otherwise>
            	    </xsl:choose>
	            </xsl:variable>
       	        <multimap:Message>
        	        <xsl:copy-of select="@*"/>
        	        <xsl:copy-of select="$messageContent"/>
        	    </multimap:Message>
        	    <xsl:variable name="newShortenedMessages">
        	        <xsl:copy-of select="$shortenedMessages"/>
        	        <xsl:element name="multimap:Message{@MessageCounter}" namespace="http://sap.com/xi/XI/SplitAndMerge">
                	    <xsl:choose>
                	        <xsl:when test="IBPWriteBatch">
                	            <xsl:copy-of select="$messageContent"/>
                	        </xsl:when>
                	        <xsl:otherwise>
                	            <xsl:attribute name="ContentSkipped" select="'true'"/>
                	        </xsl:otherwise>
                	    </xsl:choose>
        	        </xsl:element>
        	    </xsl:variable>
        	    <xsl:on-completion>
        	        <xsl:variable name="shortenedInclMessages"><multimap:Messages xmlns:multimap="http://sap.com/xi/XI/SplitAndMerge"><xsl:copy-of select="$shortenedMessages"/></multimap:Messages></xsl:variable>
        	        <xsl:variable name="shortened"><xsl:copy-of select="$shortenedInclMessages"/></xsl:variable>
                    <xsl:value-of select="cpi:setProperty($exchange, 'IBPNewWriteBatchRequests', serialize($shortened))"/>
        	    </xsl:on-completion>
        	    <xsl:next-iteration>
                    <xsl:with-param name="currentIndex" select="$newIndex"/>
                    <xsl:with-param name="shortenedMessages" select="$newShortenedMessages"/>
                </xsl:next-iteration>  
	        </xsl:iterate>
	    </multimap:Messages>
	</xsl:template>
	<xsl:template match="IBPWriteBatch">
	    <xsl:param name="newIndex"/>
 	    <xsl:element name="IBPWriteBatch">
		    <xsl:attribute name="Key">
				<xsl:value-of select="if(@Key) then @Key else if ($newIndex = 1) then $IBPWriteBatchKey1 else '-not defined-'"/>
			</xsl:attribute>
		    <xsl:attribute name="Index">
				<xsl:value-of select="$newIndex"/>
			</xsl:attribute>
		    <xsl:attribute name="Destination">
				<xsl:value-of select="if(@Destination) then @Destination else $DestinationforSAPIBP"/>
			</xsl:attribute>
		    <xsl:attribute name="Name">
				<xsl:value-of select="if(@Name) then @Name else if ($newIndex = 1) then $IBPWriteBatchName1 else '-not defined-'"/>
			</xsl:attribute>
   		    <xsl:attribute name="CallerId">
				<xsl:value-of select="$SAP_MplCorrelationId"/>
			</xsl:attribute>
			<xsl:attribute name="CallerDescription">
				<xsl:value-of select="if(@CallerDescription) then @CallerDescription else $CallerDescription"/>
			</xsl:attribute>
			<xsl:attribute name="Command">
				<xsl:value-of select="if (@Command) then @Command else $WriteBatchCommand"/>
			</xsl:attribute>
			<xsl:attribute name="ProcessUnchangedData">
				<xsl:value-of select="if (@ProcessUnchangedData) then @ProcessUnchangedData else $ProcessUnchangedData"/>
			</xsl:attribute>
			<xsl:attribute name="DetailedTrace">
				<xsl:value-of select="if (@DetailedTrace) then @DetailedTrace else $DetailedTraceLog"/>
			</xsl:attribute>
			<xsl:attribute name="PlanningArea">
				<xsl:value-of select="if(@PlanningArea) then @PlanningArea else $PlanningArea"/>
			</xsl:attribute>
			<xsl:attribute name="PlanningAreaVersion">
				<xsl:value-of select="if(@PlanningAreaVersion) then @PlanningAreaVersion else $PlanningAreaVersion"/>
			</xsl:attribute>
			<xsl:attribute name="TimeProfile">
				<xsl:value-of select="if(@TimeProfile) then @TimeProfile else $TimeProfile"/>
			</xsl:attribute>
			<xsl:attribute name="UserDefinedScenario">
				<xsl:value-of select="if(@UserDefinedScenario) then @UserDefinedScenario else $UserDefinedScenario"/>
			</xsl:attribute>
		</xsl:element>
	</xsl:template>
</xsl:stylesheet>
