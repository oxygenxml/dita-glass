<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    xpath-default-namespace="http://www.w3.org/1999/xhtml"
    version="2.0">
    <xsl:output doctype-public="-//OASIS//DTD DITA Topic//EN" doctype-system="topic.dtd"/>
    <xsl:include href="h2d.xsl"/>
 
 <xsl:template match="div">
  <p>
  <xsl:apply-templates select="*|text()|comment()"/>
  </p>
 </xsl:template>
    <xsl:template match="/">
        <topic id="tid">
            <title>
                [Javadoc] <xsl:value-of select="(//h2)[1]"/>
            </title>
            <body>
                <xsl:apply-templates select="//table"/>
            </body>
        </topic>
    </xsl:template>
    <xsl:template match="a">
     <i><xsl:apply-templates select="*|text()|comment()"/></i>
        <!--<xref>
            <xsl:variable name="pathTokens" as="xs:string*">
                <xsl:for-each select="tokenize(base-uri(), '/')">
                    <xsl:if test="position() != last()">
                        <xsl:value-of select="."/>
                    </xsl:if>
                </xsl:for-each>      
            </xsl:variable>
            <xsl:attribute name="href"><xsl:value-of select="
                concat(string-join($pathTokens, '/'), '/', @href)"/></xsl:attribute>
            <xsl:apply-templates select="*|text()|comment()"/>
        </xref>-->
    </xsl:template>
</xsl:stylesheet>