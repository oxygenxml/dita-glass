<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    <xsl:output method="xml" doctype-public="-//OASIS//DTD DITA Topic//EN" 
        doctype-system="http://docs.oasis-open.org/dita/v1.1/OS/dtd/topic.dtd" indent="yes"/>
    <xsl:template match="sheets">
        <xsl:choose>
            <xsl:when test="count(sheet) > 1">
                <topic id="sheets">
                    <title>Multiple Excel Sheets:</title>
                    <xsl:apply-templates/>
                </topic>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="sheet">
        <topic id="{@name}">
            <title>[Excel] Imported Table "<xsl:value-of select="@name"/>" </title>
            <body>
                <table frame="none" id="table_{@name}">
                    <title>Car Parts</title>
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
            </body>
        </topic>
    </xsl:template>
</xsl:stylesheet>