<?xml version="1.0" encoding="UTF-8"?>
<!-- ========================================= 
     created: 2015-06-21
     by:      Markus Wiedenmaier
              http://www.practice-innovation.de
              info@practice-innovation.de
     Descr.:  Transforms XGlass documents to XML catalog files
     License: delivered "as is" with no warranties
              feel free in any case
     ========================================= -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="urn:oasis:names:tc:entity:xmlns:xml:catalog"
    version="1.0">
    <xsl:output encoding="UTF-8" indent="yes"/>
    
    <xsl:template match="/">
        <xsl:apply-templates select="*"/>
    </xsl:template>
    <xsl:template match="xglass">
        <xsl:comment>Catalog file automatically generated from an xglass XML configuration file.</xsl:comment>
        <xsl:element name="catalog">
            <xsl:apply-templates select="*"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="definitions">
        <xsl:apply-templates select="*"/>
    </xsl:template>
    <xsl:template match="urns">
        <xsl:comment>resource collections</xsl:comment>
        <xsl:apply-templates select="*"/>
    </xsl:template>
    <xsl:template match="urn">
        <xsl:element name="rewriteURI">
            <xsl:attribute name="uriStartString">
                <xsl:text>urn:</xsl:text>
                <xsl:apply-templates select="ancestor-or-self::urn" mode="name"/>
            </xsl:attribute>
            <xsl:attribute name="rewritePrefix">
                <xsl:apply-templates select="ancestor-or-self::urn" mode="path"/>
            </xsl:attribute>
        </xsl:element>
        <xsl:apply-templates select="urn"/>
    </xsl:template>
    <xsl:template match="urn" mode="name">
        <xsl:value-of select="@name"/>
        <xsl:text>:</xsl:text>
    </xsl:template>
    <xsl:template match="urn" mode="path">
        <xsl:value-of select="@path"/>
        <xsl:text>/</xsl:text>
    </xsl:template>
    
    <xsl:template match="conversions">
        <xsl:comment>aliases for conversion protocols</xsl:comment>
        <xsl:apply-templates select="*"/>
    </xsl:template>
    <xsl:template match="conversion">
        <xsl:apply-templates select="comment"/>
        <xsl:element name="rewriteURI">
            <xsl:attribute name="uriStartString">
                <xsl:value-of select="@protocol"/>
                <xsl:text>:/</xsl:text>
            </xsl:attribute>
            <xsl:attribute name="rewritePrefix">
                <xsl:text>convert:</xsl:text>
                <xsl:apply-templates select="*[not(self::comment)]"/>
                <xsl:text>!/</xsl:text>
            </xsl:attribute>
        </xsl:element>
    </xsl:template>
    <xsl:template match="comment">
        <xsl:text>
</xsl:text>
        <xsl:comment>
            <xsl:apply-templates/>
        </xsl:comment>
    </xsl:template>
    <xsl:template match="read | write">
        <xsl:for-each select="*">
            <xsl:sort select="position()" data-type="number" order="descending"/>
            <xsl:variable name="processorSettings">
                <xsl:apply-templates select=".">
                    <xsl:sort select="position()" data-type="number" order="descending"/>
                </xsl:apply-templates>
            </xsl:variable>
            <!--        <xsl:value-of select="$prefix"/>-->
            <xsl:value-of select="substring($processorSettings,1, string-length($processorSettings)-1)"/>
        </xsl:for-each>
    </xsl:template>

    <!-- ========== -->
    <!-- Processors -->
    <!-- ========== -->
    
    <!-- ========== -->
    <!-- XSLT       -->
    <!-- ========== -->
    <xsl:template match="xslt">
        <xsl:call-template name="writeProcessor"/>
        <xsl:apply-templates select="*"/>
    </xsl:template>
    <xsl:template match="xslt/stylesheet">
        <xsl:text>ss=</xsl:text>
        <xsl:if test="@urn">
            <xsl:text>urn:</xsl:text>
            <xsl:value-of select="@urn"/>
            <xsl:text>:</xsl:text>
        </xsl:if>
        <xsl:value-of select="."/>
        <xsl:text>;</xsl:text>
    </xsl:template>
    <!-- ========== -->
    <!-- XQUERY      -->
    <!-- ========== -->
    <xsl:template match="xquery">
        <xsl:call-template name="writeProcessor"/>
        <xsl:apply-templates select="*"/>
    </xsl:template>
    <xsl:template match="xquery/script">
        <xsl:text>ss=</xsl:text>
        <xsl:if test="@urn">
            <xsl:text>urn:</xsl:text>
            <xsl:value-of select="@urn"/>
            <xsl:text>:</xsl:text>
        </xsl:if>
        <xsl:value-of select="."/>
        <xsl:text>;</xsl:text>
    </xsl:template>
    
    <!-- ========== -->
    <!-- Excel      -->
    <!-- ========== -->
    <xsl:template match="excel">
        <xsl:call-template name="writeProcessor"/>
        <xsl:apply-templates select="*"/>
    </xsl:template>
    <xsl:template match="excel/sheet">
        <xsl:text>sn=</xsl:text>
        <xsl:value-of select="."/>
        <xsl:text>;</xsl:text>
    </xsl:template>
    
    <!-- ========== -->
    <!-- Java       -->
    <!-- ========== -->
    <xsl:template match="java">
        <xsl:call-template name="writeProcessor"/>
        <xsl:apply-templates select="*"/>
    </xsl:template>
    <xsl:template match="java/jars">
        <xsl:text>jars=</xsl:text>
        <xsl:apply-templates select="*"/>
        <xsl:text>;</xsl:text>
    </xsl:template>
    <xsl:template match="java/jars/dir">
        <xsl:if test="@urn">
            <xsl:text>urn:</xsl:text>
            <xsl:value-of select="@urn"/>
            <xsl:text>:</xsl:text>
        </xsl:if>
        <xsl:value-of select="."/>
        <xsl:if test="following-sibling::*">
            <xsl:text>,</xsl:text>
        </xsl:if>
    </xsl:template>
    <xsl:template match="java/jars/jar">
        <xsl:if test="@urn">
            <xsl:text>urn:</xsl:text>
            <xsl:value-of select="@urn"/>
            <xsl:text>/</xsl:text>
        </xsl:if>
        <xsl:value-of select="."/>
        <xsl:if test="following-sibling::*">
            <xsl:text>,</xsl:text>
        </xsl:if>
    </xsl:template>
    <xsl:template match="java/class">
        <xsl:text>ccn=</xsl:text>
        <xsl:value-of select="."/>
        <xsl:text>;</xsl:text>
    </xsl:template>
    
    <!-- ========== -->
    <!-- JavaScript -->
    <!-- ========== -->
    <xsl:template match="js">
        <xsl:call-template name="writeProcessor"/>
        <xsl:apply-templates select="*"/>
    </xsl:template>
    <xsl:template match="js/script">
        <xsl:text>js=</xsl:text>
        <xsl:if test="@urn">
            <xsl:text>urn:</xsl:text>
            <xsl:value-of select="@urn"/>
            <xsl:text>:</xsl:text>
        </xsl:if>
        <xsl:value-of select="."/>
        <xsl:text>;</xsl:text>
    </xsl:template>
    <xsl:template match="js/method">
        <xsl:text>fn=</xsl:text>
        <xsl:value-of select="."/>
        <xsl:text>;</xsl:text>        
    </xsl:template>
    <!-- ========== -->
    <!-- JSON       -->
    <!-- ========== -->
    <xsl:template match="json">
        <xsl:call-template name="writeProcessor"/>
        <!-- no parameters -->
    </xsl:template>
    <!-- ========== -->
    <!-- XHTML      -->
    <!-- ========== -->
    <xsl:template match="xhtml">
        <xsl:call-template name="writeProcessor"/>
        <!-- no parameters -->
    </xsl:template>
    <!-- ========== -->
    <!-- wrap       -->
    <!-- ========== -->
    <xsl:template match="wrap">
        <xsl:call-template name="writeProcessor"/>
        <xsl:apply-templates select="*"/>
    </xsl:template>
    <xsl:template match="roottag">
        <xsl:text>rn=</xsl:text>
        <xsl:value-of select="."/>
        <xsl:text>;</xsl:text>
    </xsl:template>
    <xsl:template match="encoding">
        <xsl:text>encoding=</xsl:text>
        <xsl:value-of select="."/>
        <xsl:text>;</xsl:text>
    </xsl:template>
    
    <!-- ========== -->
    <!-- parameters -->
    <!-- ========== -->
    <xsl:template match="parameters">
        <xsl:apply-templates select="*"/>
    </xsl:template>
    <xsl:template match="parameter">
        <xsl:value-of select="@name"/>
        <xsl:text>=</xsl:text>
        <xsl:value-of select="."/>
        <xsl:text>;</xsl:text>
    </xsl:template>
    <!-- ========== -->
    <!-- helpers    -->
    <!-- ========== -->
    <xsl:template name="writeProcessor">
        <xsl:param name="processor" select="."/>
        <xsl:param name="processorName" select="name($processor)"/>
        <xsl:text>/</xsl:text>
        <xsl:if test="$processor/parent::write">
            <xsl:text>r</xsl:text>
        </xsl:if>
        <xsl:text>processor=</xsl:text>
        <xsl:value-of select="$processorName"/>
        <xsl:text>;</xsl:text>
    </xsl:template>
    
</xsl:stylesheet>