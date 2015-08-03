<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    xpath-default-namespace="http://www.w3.org/1999/xhtml"
    version="2.0">
    <xsl:output doctype-public="-//OASIS//DTD DITA Map//EN" doctype-system="map.dtd"/>
    <xsl:template match="/">
        <map>
            <title>
                <xsl:value-of select="(//title)[1]"/>
            </title>
            <xsl:for-each select="//ul[@title='Packages']//a">
                <topicref>
                    <xsl:attribute name="format">ditamap</xsl:attribute>
                    <xsl:variable name="pathTokens" as="xs:string*">
                        <xsl:for-each select="tokenize(base-uri(), '/')">
                            <xsl:if test="position() != last()">
                            <xsl:value-of select="."/>
                            </xsl:if>
                        </xsl:for-each>      
                    </xsl:variable>
                    <xsl:attribute name="href"><xsl:value-of select="
                        concat(string-join($pathTokens, '/'), '/', @href)"/></xsl:attribute>
                </topicref>
            </xsl:for-each>
            <xsl:for-each select="//ul[@title='Classes']//a">
                <topicref>
                    <xsl:attribute name="format">dita</xsl:attribute>
                    <xsl:variable name="pathTokens" as="xs:string*">
                        <xsl:for-each select="tokenize(base-uri(), '/')">
                            <xsl:if test="position() != last()">
                                <xsl:value-of select="."/>
                            </xsl:if>
                        </xsl:for-each>      
                    </xsl:variable>
                    <xsl:attribute name="href"><xsl:value-of select="
                        concat(replace(string-join($pathTokens, '/'), 'javaDocToMap.xsl', 'javaDocToTopic.xsl'), '/', @href)"/></xsl:attribute>
                </topicref>
            </xsl:for-each>
        </map>
    </xsl:template>
</xsl:stylesheet>