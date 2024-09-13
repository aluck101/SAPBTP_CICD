<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:rfc="urn:sap-com:document:sap:rfc:functions">
    <xsl:output method="xml" indent="yes"/>

    <xsl:template match="/">
        <xsl:apply-templates select="//rfc:RFC_READ_TABLE.Response/DATA"/>
    </xsl:template>

    <xsl:template match="DATA">
        <DATA>
            <xsl:apply-templates select="item"/>
            <xsl:apply-templates select="//rfc:RFC_READ_TABLE.Response/FIELDS/item"/>
        </DATA>
    </xsl:template>

    <xsl:template match="item">
        <row>
            <WA>
                <xsl:value-of select="WA"/>
            </WA>
        </row>
    </xsl:template>

    <xsl:template match="FIELDS/item">
        <FIELDNAME>
            <xsl:value-of select="FIELDNAME"/>
        </FIELDNAME>
    </xsl:template>

</xsl:stylesheet>
