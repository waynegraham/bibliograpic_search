<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="2.0">
    
    <xsl:output encoding="UTF-8"/>
    <xsl:strip-space elements="*"/>
    
    <xsl:template match="/">
        <add>
        <xsl:for-each select="//div1">
            <xsl:apply-templates />
        </xsl:for-each>
        </add>
    </xsl:template>
    
    <xsl:template match="div1">
        <xsl:variable name="filename">
            <xsl:value-of select="f"/>
        </xsl:variable>
        
        <xsl:apply-templates select="p/list/item">
            <xsl:with-param name="filename" select="$filename"/>
        </xsl:apply-templates>
    </xsl:template>
    
    <xsl:template match="item">
        <xsl:param name="filename" />
        
        <doc>
            <field name="id"><xsl:value-of select="generate-id()"/></field>
            <field name="section_s"><xsl:value-of select="position()"/></field>
            <field name="fulltext_t"><xsl:value-of select="node()"/></field>
            <field name="file_s"><xsl:value-of select="$filename" /></field>
        </doc>
    </xsl:template>
</xsl:stylesheet>