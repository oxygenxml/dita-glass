<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    <xsl:output method="xml" doctype-public="-//OASIS//DTD DITA Topic//EN" 
        doctype-system="http://docs.oasis-open.org/dita/v1.1/OS/dtd/topic.dtd" indent="yes"/>
    <xsl:template match="/">
        <topic id="tid">
            <title>[Excel] Imported Table of animals </title>
            <body>
                <table frame="none">
                    <title>Flowers</title>
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