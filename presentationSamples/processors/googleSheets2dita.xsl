<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xhtml="http://www.w3.org/1999/xhtml"
    xmlns:saxon="http://saxon.sf.net/"
    version="3.0">
    
    <!-- Sample input: https://docs.google.com/spreadsheets/d/1FdPXq56h6-VqLFlMfWxv5myk6Yyxy4rKiNUYXJnA3cA/edit?usp=sharing -->
    <!-- Sample input: https://docs.google.com/spreadsheets/d/1FdPXq56h6-VqLFlMfWxv5myk6Yyxy4rKiNUYXJnA3cA/pubhtml -->
    
    <xsl:template match="/">
        <xsl:apply-templates mode="html"/>
    </xsl:template>
    
    
    <xsl:template match="xhtml:html|xhtml:head" mode="html">
        <xsl:copy>
            <xsl:apply-templates mode="html"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="xhtml:title[empty(.)]" mode="html"/>
    
    <xsl:template match="xhtml:body" mode="html">
        <xsl:copy>
            <xhtml:h1>Google Sheets import</xhtml:h1>
            <xsl:apply-templates mode="html"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="xhtml:div[@id='0-grid-table-container' or @id='sheets-viewport']" mode="html">
        <xsl:apply-templates select="." mode="div"/>
    </xsl:template>    
    <xsl:template match="@*" mode="html"><xsl:copy/></xsl:template>
    <xsl:template match="text()" mode="html"/>
    
    
    <xsl:template match="node() | @*" mode="div">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*" mode="div"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="xhtml:table" mode="div">
        <xsl:variable name="tableID" select="(ancestor::xhtml:div[@id][1]/@id, 'Sheet1')[1]"/>
        <xsl:variable name="title" select="(//xhtml:li[@id=concat('sheet-button-', $tableID)]/xhtml:a/string(.), 'Google Sheet')[1]"/>             
        
                
        <xsl:variable name="maxCols" 
            select="1+max(xhtml:tbody/xhtml:tr/
                            (let $rowPosition:=count(preceding-sibling::xhtml:tr)+1
                            return 
                            (sum(xhtml:td[following-sibling::*/text()]/(if (@colspan) then @colspan else 1))) +
                             sum(preceding-sibling::xhtml:tr/xhtml:td[@rowspan][@rowspan > $rowPosition - 1 - count(../preceding-sibling::xhtml:tr)]/(if (@colspan) then @colspan else 1))
                            )
                         )"/>
        
        <xhtml:div><p xmlns="http://www.w3.org/1999/xhtml"><xsl:value-of select="$title"/></p></xhtml:div>
        <xsl:copy>
            <xsl:attribute name="id" select="concat('table-', replace($tableID, '-grid-table-container', ''))"/>
            <xsl:apply-templates select="@*" mode="div"/>
            
            <xsl:apply-templates select="node()" mode="div">
                <xsl:with-param name="maxCols" select="$maxCols" tunnel="yes"/>
            </xsl:apply-templates>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="xhtml:tr" mode="div">
        <xsl:if test="xhtml:td/text()">
            <xsl:copy>
                <xsl:apply-templates select="node() | @*" mode="div">
                    <xsl:with-param name="rowPosition" select="position()"/>
                </xsl:apply-templates>
            </xsl:copy>
        </xsl:if>
    </xsl:template>
    <xsl:template match="xhtml:td" mode="div">
        <xsl:param name="rowPosition"/>
        <xsl:param name="maxCols" tunnel="yes"/>
        <xsl:variable name="rowspans" select="sum(../preceding-sibling::xhtml:tr/xhtml:td[@rowspan][@rowspan>$rowPosition - 1 - count(../preceding-sibling::xhtml:tr)]/(if (@colspan) then @colspan else 1))"/>
        <xsl:choose>
            <xsl:when test="text()">
                <xsl:copy>
                    <xsl:apply-templates select="node() | @*" mode="td"/>
                </xsl:copy>    
            </xsl:when>
            <xsl:when test="sum(preceding-sibling::xhtml:td/(if (@colspan) then @colspan else 1)) &lt; $maxCols - $rowspans">
                <xsl:copy>
                    <xsl:apply-templates select="node() | @*" mode="td"/>
                </xsl:copy>
            </xsl:when>
            <xsl:otherwise>
                
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:template>
    
    <xsl:template match="@id" mode="div">
        <xsl:attribute name="id">x-<xsl:value-of select="."/></xsl:attribute>
    </xsl:template>
    <xsl:template match="xhtml:thead | xhtml:th" mode="div"/>
    <xsl:template match="@cellpadding | @cellspacing | @rowspan[.=1] | @colspan[.=1]" mode="div"/>
    <xsl:template match="text()" mode="div"/>
    
    <xsl:template match="node() | @*" mode="td">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*" mode="td"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="xhtml:td" mode="td">
        <xsl:copy>
            <xsl:apply-templates select="@*" mode="td"/>
            <xsl:if test=".//xhtml:br">
                <xsl:attribute name="xml:space">preserve</xsl:attribute>
            </xsl:if>
            <xsl:apply-templates select="node() | @*" mode="td"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="xhtml:br" mode="td">
        <xsl:text>&#10;</xsl:text>
    </xsl:template>
</xsl:stylesheet>