<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="2.0">
    
    <!-- Sample input file
        convert:/processor=java;jars=urn:processors:jars;ccn=j.to.xml.JavaToXML!/urn:files:java/WSEditorBase.java
    
    -->
    
    <xsl:output doctype-public="-//OASIS//DTD DITA Topic//EN" doctype-system="topic.dtd" indent="yes"/>
    <xsl:template match="/*">
        <topic id="{@name}">
            <title>
                [Java] Documentation for "<xsl:value-of select="@name"/>"
            </title>
            <shortdesc><xsl:value-of select="javadoc"/></shortdesc>
            <body>
                <xsl:for-each select="method">
                    <section id="method_{translate(declaration, ' (),', '____')}">
                        <title>Method "<xsl:value-of select="@name"/>"</title>
                        <syntaxdiagram id="sd_method_{translate(declaration, ' (),', '____')}">
                            <title>Declaration</title>
                            <groupseq>
                                <xsl:analyze-string select="declaration" regex="[\s\(\),]">
                                    <xsl:matching-substring><sep><xsl:value-of select="normalize-space(.)"/></sep></xsl:matching-substring>
                                    <xsl:non-matching-substring><kwd><xsl:value-of select="."/></kwd></xsl:non-matching-substring>
                                </xsl:analyze-string>
                            </groupseq>
                        </syntaxdiagram>
                        <pre id="comment_method_{translate(declaration, ' (),', '____')}"><xsl:value-of select="javadoc"/></pre>
                    </section>
                </xsl:for-each>
            </body>
        </topic>
    </xsl:template>
</xsl:stylesheet>