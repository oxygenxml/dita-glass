<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    exclude-result-prefixes="xs xd"
    version="2.0">
    
    <xsl:output method="text"/>
    <xsl:variable name="quotes">"</xsl:variable>

    <xsl:template match="/">
        <xsl:if test="not(//table[@id='csv_table'])">
            <xsl:message terminate="yes">A table with the id 'csv_table' is not present in your topic!
                <xsl:copy-of select="."/>
            </xsl:message>
        </xsl:if>
        <xsl:apply-templates select="//table[@id='csv_table']"/>
    </xsl:template>

    <xsl:template match="table[@id='csv_table']">
        <!-- TODO: check table structure -->
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="row[following::row]">
        <xsl:apply-templates/>
        <xsl:text>&#10;</xsl:text>
    </xsl:template>
    
    
    <xsl:template match="entry">
        <xsl:value-of select="if (contains(., ',')) then concat($quotes, ., $quotes) else ."/>
        <xsl:if test="following-sibling::entry">
            <xsl:text>,</xsl:text>
        </xsl:if>
    </xsl:template>

    <xsl:template match="text()"/>
        
</xsl:stylesheet>