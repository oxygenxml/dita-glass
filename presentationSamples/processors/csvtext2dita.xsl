<?xml version="1.0"?>
<!--
	A CSV to XML transform
	Version 2
	Andrew Welch
	http://andrewjwelch.com
	
	Modify or supply the $pathToCSV parameter and run the transform
	using "main" as the initial template.
	
	For bug reports or modification requests contact me at andrew.j.welch@gmail.com
	
	George Bina: 
	   Modified to work with input that contains the CSV content inside a text element.
	   Convert to a DITA topic.
-->
  		
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:fn="fn"
	exclude-result-prefixes="xs fn">

<xsl:output method="xml" doctype-public="-//OASIS//DTD DITA Topic//EN" 
        doctype-system="http://docs.oasis-open.org/dita/v1.1/OS/dtd/topic.dtd" indent="yes"/>

<xsl:function name="fn:getTokens" as="xs:string+">
	<xsl:param name="str" as="xs:string"/>
		<xsl:analyze-string select="concat($str, ',')" regex='(("[^"]*")+|[^,]*),'>
			<xsl:matching-substring>
				<xsl:sequence select='replace(regex-group(1), "^""|""$|("")""", "$1")'/>
			</xsl:matching-substring>
		</xsl:analyze-string>
</xsl:function>


<!--<xsl:template match="/">
    <xsl:copy-of select="."/>
</xsl:template>-->
    
<xsl:template match="/*">
    <xsl:variable name="csv" select="."/>
    <xsl:variable name="lines" select="tokenize($csv, '&#xa;')" as="xs:string+"/>
    <xsl:variable name="elemNames" select="fn:getTokens($lines[1])" as="xs:string+"/>
    <topic id="csv">
        <title>[CSV] Imported Table</title>
        <body>
            <table frame="none" id="csv_table">
                <tgroup>
                    <xsl:attribute name="cols"><xsl:value-of select="count($elemNames)"/></xsl:attribute>
                    <thead>
                        <row>
                            <xsl:for-each select="$elemNames">
                                <entry><xsl:value-of select="."/></entry>
                            </xsl:for-each>
                        </row>
                    </thead>
                    <tbody>
                        <xsl:for-each select="$lines[position() > 1]">
                            <row>
                                <xsl:variable name="lineItems" select="fn:getTokens(.)" as="xs:string+"/>
                                <xsl:for-each select="$elemNames">
                                    <xsl:variable name="pos" select="position()"/>
                                    <entry>
                                        <xsl:value-of select="$lineItems[$pos]"/>
                                    </entry>
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