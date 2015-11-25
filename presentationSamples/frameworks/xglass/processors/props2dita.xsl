<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:fn="fn"
    exclude-result-prefixes="xs fn xd">
    
    <!--
        Doctales JavaProperties2Dita Stylesheet
        
        Licensed to the Apache Software Foundation (ASF) under one or more
        contributor license agreements. See the NOTICE file distributed with
        this work for additional information regarding copyright ownership.
        The ASF licenses this file to You under the Apache License, Version 2.0
        (the “License”); you may not use this file except in compliance with
        the License. You may obtain a copy of the License at
        
        http://www.apache.org/licenses/LICENSE-2.0
        
        Unless required by applicable law or agreed to in writing, software
        distributed under the License is distributed on an “AS IS” BASIS,
        WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
        See the License for the specific language governing permissions and
        limitations under the License.
    -->
    
    <xsl:param name="lineFeedChar">�</xsl:param>
    <xsl:param name="newlineWithSpace">\n </xsl:param>
    <xsl:param name="newlineWithoutSpace">\n</xsl:param>
    <xsl:param name="aumlOld">\\u00e4</xsl:param>
    <xsl:param name="aumlNew">ä</xsl:param>
    <xsl:param name="oumlOld">\\u00f6</xsl:param>
    <xsl:param name="oumlNew">ö</xsl:param>
    <xsl:param name="uumlOld">\\u00fc</xsl:param>
    <xsl:param name="uumlNew">ü</xsl:param>
    <xsl:param name="AumlOld">\\u00c4</xsl:param>
    <xsl:param name="AumlNew">Ä</xsl:param>
    <xsl:param name="OumlOld">\\u00d6</xsl:param>
    <xsl:param name="OumlNew">Ö</xsl:param>
    <xsl:param name="UumlOld">\\u00dc</xsl:param>
    <xsl:param name="UumlNew">Ü</xsl:param>
    <xsl:param name="szligOld">\\u00df</xsl:param>
    <xsl:param name="szligNew">ß</xsl:param>
    
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Sep 30, 2015</xd:p>
            <xd:p><xd:b>Author:</xd:b> Stefan Eike</xd:p>
        </xd:desc>
    </xd:doc>
    
    <xsl:output method="xml"
        doctype-public="-//OASIS//DTD DITA Topic//EN"
        doctype-system="http://docs.oasis-open.org/dita/v1.1/OS/dtd/topic.dtd"
        indent="yes"/>
    
    <xsl:param name="text-encoding" as="xs:string" select="'UTF-8'"/>
    
    <xsl:function name="fn:getTokens" as="xs:string+">
        <xsl:param name="str" as="xs:string"/>
        <xsl:analyze-string select="concat($str, '�')" regex='(("[^"]*")+|[^,]*)�'>
            <xsl:matching-substring>
                <xsl:sequence select='replace(regex-group(1), "^""|""$|("")""", "$1")'/>
            </xsl:matching-substring>
        </xsl:analyze-string>
    </xsl:function>
    
    <xsl:function name="fn:getKey" as="xs:string+">
        <xsl:param name="str" as="xs:string"/>
        <xsl:analyze-string select="concat($str, '�')" regex='(("[^"]*")+|[^,]*)�'>
            <xsl:matching-substring>
                <xsl:sequence select="substring-before(., '=')"/>
            </xsl:matching-substring>
        </xsl:analyze-string>
    </xsl:function>
    
    <xsl:function name="fn:getValue" as="xs:string+">
        <xsl:param name="str" as="xs:string"/>
        
        <xsl:analyze-string select="concat($str, '�')" regex='(("[^"]*")+|[^,]*)�'>
            <xsl:matching-substring>
                <xsl:sequence select="replace(
                    replace(
                    replace(
                    replace(
                    replace(
                    replace(
                    replace(
                    replace(
                    replace(
                    replace(substring-after(., '='),
                    $newlineWithSpace, ' '),
                    $newlineWithoutSpace, ''),
                    $aumlOld, $aumlNew),
                    $oumlOld, $oumlNew),
                    $uumlOld, $uumlNew),
                    $AumlOld, $AumlNew),
                    $OumlOld, $OumlNew),
                    $UumlOld, $UumlNew),
                    $szligOld, $szligNew),
                    $lineFeedChar, '')"/>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
                <!--  -->
            </xsl:non-matching-substring>
        </xsl:analyze-string>
    </xsl:function>
    
    <xsl:template name="getFilenameFromPath">
        <xsl:param name="string"/>
        <xsl:param name="char"/>
        <xsl:choose>
            <xsl:when test="contains($string, $char)">
                <xsl:call-template name="getFilenameFromPath">
                    <xsl:with-param name="string" select="substring-after($string, $char)"/>
                    <xsl:with-param name="char" select="$char"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$string"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="/*">
        <xsl:variable name="properties" select="text()"/>
        
        <xsl:variable name="inputFilePath" select="base-uri()"/>
        <xsl:variable name="stylesheetFilePath" select="base-uri(document(''))"/>
        
        <xsl:variable name="lines" select="tokenize($properties, '&#xa;')" as="xs:string+"/>
        
        <topic id="properties">
            <title>Language Properties</title>
            <body>
                <ul>
                    <xsl:for-each select="$lines">
                        <xsl:variable name="key" select="fn:getKey(.)" as="xs:string+"/>
                        <xsl:variable name="value" select="fn:getValue(.)" as="xs:string+"/>
                        <xsl:choose>
                            <xsl:when test="$key != '' and $value != ''">
                                <xsl:element name="li">
                                    <xsl:element name="ph">
                                        <xsl:attribute name="id"><xsl:value-of select="$key"/></xsl:attribute>
                                        <xsl:value-of select="$value"/>
                                    </xsl:element>
                                </xsl:element>                                
                            </xsl:when>
                            <xsl:otherwise>
                                <!-- -->
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>
                </ul>
            </body>
        </topic>
    </xsl:template>
    
</xsl:stylesheet>