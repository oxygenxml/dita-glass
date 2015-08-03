<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs p"
    xpath-default-namespace="http://www.w3.org/1999/xhtml"
    xmlns:p="http://www.oxygenxml.com/ns/samples/personal"
    version="2.0">
    <xsl:output doctype-public="-//OASIS//DTD DITA Topic//EN" doctype-system="topic.dtd" indent="yes"/>
    <xsl:template match="/">
        <topic id="tid">
            <title>
                [XSD Doc] Documentation for the schema.
            </title>
            <body>
                <xsl:apply-templates select="//xs:element[@name]"/>
            </body>
        </topic>
    </xsl:template>
    <xsl:template match="xs:element[@name]">
        <section id="{@name}">
            <title>Element "<xsl:value-of select="@name"/>"</title>
            <xsl:if test="xs:annotation/xs:documentation">
                <p><xsl:copy-of select="xs:annotation/xs:documentation/node()"></xsl:copy-of></p>
            </xsl:if>
            <p>
             <xsl:choose>
                 <xsl:when test="xs:complexType/xs:sequence">
                     Sequence of:
                 </xsl:when>
                 <xsl:when test="xs:complexType/xs:all">
                     All of:
                 </xsl:when>
                 <xsl:when test="xs:complexType/xs:choice">
                     Choice of:
                 </xsl:when>
                 <xsl:when test="@type">
                     Type: <b><xsl:value-of select="@type"/></b>
                 </xsl:when>
                 <xsl:otherwise></xsl:otherwise>
             </xsl:choose>
                 <xsl:for-each select="xs:complexType/*/xs:element">
                     <xref href="#tid/{substring-after(@ref, ':')}">
                        <xsl:value-of select="@ref"/>
                     </xref>
                     <xsl:if test="last() != position()">, </xsl:if>
                 </xsl:for-each>
            </p>
            <codeblock outputclass="language-xml">
                <xsl:text disable-output-escaping="yes">&lt;![CDATA[</xsl:text>
                <xsl:copy-of select="."/>
                <xsl:text disable-output-escaping="yes">]]&gt;</xsl:text>
            </codeblock>
        </section>
    </xsl:template>
</xsl:stylesheet>