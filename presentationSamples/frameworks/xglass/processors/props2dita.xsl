<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:fn="fn"
    xmlns:saxon="http://saxon.sf.net/"
    exclude-result-prefixes="xs fn xd saxon">
    
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
    
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Sep 30, 2015</xd:p>
            <xd:p><xd:b>Author:</xd:b> Stefan Eike</xd:p>
            <xd:p><xd:b>Modified by:</xd:b> Radu Coravu</xd:p>
        </xd:desc>
    </xd:doc>
    
    <xsl:output method="xml"
        doctype-public="-//OASIS//DTD DITA Topic//EN"
        doctype-system="http://docs.oasis-open.org/dita/v1.1/OS/dtd/topic.dtd"
        indent="yes"/>
    
    <xsl:function name="fn:getKey" as="xs:string">
        <xsl:param name="str" as="xs:string"/>
        <xsl:analyze-string select="concat($str, '�')" regex='(("[^"]*")+|[^,]*)�'>
            <xsl:matching-substring>
                <xsl:variable name="unparsed">
                    &lt;x><xsl:value-of select="replace(
                        replace(
                        replace(replace(substring-before(., '='), '\\u([0-9a-fA-F]{4})', '&amp;#x$1;'),
                        $newlineWithSpace, ' '),
                        $newlineWithoutSpace, ''),
                        $lineFeedChar, '')"/>&lt;/x>
                </xsl:variable>
                <xsl:value-of select="saxon:parse($unparsed)/*/text()"/>
            </xsl:matching-substring>
        </xsl:analyze-string>
    </xsl:function>
    
    <xsl:function name="fn:getValue" as="xs:string">
        <xsl:param name="str" as="xs:string"/>
        <xsl:analyze-string select="concat($str, '�')" regex='(("[^"]*")+|[^,]*)�'>
            <xsl:matching-substring>
                <xsl:variable name="unparsed">
                    &lt;x><xsl:value-of select="replace(
                            replace(
                            replace(replace(substring-after(., '='), '\\u([0-9a-fA-F]{4})', '&amp;#x$1;'),
                            $newlineWithSpace, ' '),
                            $newlineWithoutSpace, ''),
                            $lineFeedChar, '')"/>&lt;/x>
                </xsl:variable>
                <xsl:value-of select="saxon:parse($unparsed)/*/text()"/>
            </xsl:matching-substring>
        </xsl:analyze-string>
    </xsl:function>
    
    <xsl:template match="/*">
        <!-- The received properties file is wrapped in XML content. -->
        <xsl:variable name="properties" select="text()"/>
        
        <xsl:variable name="lines" select="tokenize($properties, '&#xa;')" as="xs:string+"/>
        
        <topic id="properties">
            <title>Reusable User Interface Actions</title>
            <body>
                <dl>
                    <xsl:for-each select="$lines">
                        <xsl:variable name="key" select="fn:getKey(.)" as="xs:string+"/>
                        <xsl:variable name="value" select="fn:getValue(.)" as="xs:string+"/>
                        <xsl:if test="$key != '' and $value != ''">
                            <dlentry>
                                <dt><xsl:value-of select="$key"/></dt> 
                                <dd>
                                    <ph>
                                        <xsl:attribute name="id"><xsl:value-of select="$key"/></xsl:attribute>
                                        <xsl:value-of select="$value"/>
                                    </ph>
                                </dd>
                            </dlentry>                                
                        </xsl:if>
                    </xsl:for-each>
                </dl>
            </body>
        </topic>
    </xsl:template>
    
</xsl:stylesheet>