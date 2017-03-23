<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    <xsl:output method="xml" doctype-public="-//OASIS//DTD DocBook XML V4.5//EN" 
        doctype-system="http://docbook.org/xml/4.5/docbookx.dtd" indent="yes"/>
    <xsl:template match="sheets">
        <xsl:choose>
            <xsl:when test="count(sheet) > 1" xmlns="http://docbook.org/ns/docbook">
                <section xml:id="sheets">
                    <title>Multiple Excel Tables:</title>
                    <xsl:apply-templates/>
                </section>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="sheet">
        <table frame="all" xml:id="table_{@name}" xmlns="http://docbook.org/ns/docbook">
                    <title><xsl:value-of select="@name"/></title>
                    <tgroup>
                        <xsl:attribute name="cols"><xsl:value-of select="count(//row[1]/*)"/></xsl:attribute>
                        <thead>
                            <row>
                                <xsl:for-each select="//row[1]/*">
                                    <entry><xsl:value-of select="."/></entry>
                                </xsl:for-each>
                            </row>
                        </thead>
                        <tbody>
                            <xsl:for-each select="//row[position() != 1]">
                                <row>
                                    <xsl:for-each select="*">
                                        <entry><xsl:value-of select="."/></entry>
                                    </xsl:for-each>
                                </row>
                            </xsl:for-each>
                        </tbody>
                    </tgroup>
                </table>
            
        
    </xsl:template>
</xsl:stylesheet>