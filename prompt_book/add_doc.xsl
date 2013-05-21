<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="2.0">

    <xsl:output encoding="UTF-8" />
    <xsl:strip-space elements="*"/>

    <xsl:template match="/">

        <xsl:variable name="filename" select="/*/@id"/>

        <add>
            <!--
            <xsl:apply-templates select="TEI.2/teiHeader">
                <xsl:with-param name="filename" select="$filename"/>
            </xsl:apply-templates>
            <xsl:apply-templates select="TEI.2/text/front" >
                <xsl:with-param name="filename" select="$filename"/>
            </xsl:apply-templates>
            <xsl:apply-templates select="TEI.2/text/body/div0" >
                <xsl:with-param name="filename" select="$filename"/>
            </xsl:apply-templates>
            <xsl:apply-templates select="TEI.2/text/body/div0/div1" >
                <xsl:with-param name="filename" select="$filename"/>
            </xsl:apply-templates>
            -->
            <xsl:apply-templates select="TEI.2/text/body/div0/div1/div2" >
                <xsl:with-param name="filename" select="$filename"/>
            </xsl:apply-templates>
        </add>

    </xsl:template>

    <!--
    <xsl:template match="div0">
        <xsl:param name="filename" />
        <xsl:choose>
            <xsl:when test="@type='introduction'">
                <doc>
                    <field name="id"><xsl:value-of select="generate-id()"/></field>
                    <field name="slug_s">/bsuva/promptbook/</field>
                    <field name="project_s">Shakespearean Prompt-Books</field>
                    <field name="section_s"><xsl:value-of select="@type" /></field>
                    <field name="title_s"><xsl:value-of select="head" /></field>
                    <field name="fulltext_t"><xsl:value-of select="node()"/></field>
                    <field name="file_s"><xsl:value-of select="$filename"/></field>
                </doc>
            </xsl:when>
            <xsl:when test="collation">
                <xsl:apply-templates select="div1"/>
            </xsl:when>
        </xsl:choose>

    </xsl:template>
    -->

    <xsl:template match="div2">
        <xsl:param name="filename" />
        <doc>
            <field name="id"><xsl:value-of select="generate-id()"/></field>
            <field name="slug_s">/bsuva/promptbook/</field>
            <field name="project_s">Shakespearean Prompt-Books</field>
            <field name="section_s">div2_<xsl:value-of select="@n" /></field>
            <field name="title_s"><xsl:value-of select="/TEI.2/teiHeader/fileDesc/sourceDesc/biblFull/titleStmt/title" /></field>
            <field name="fulltext_t"><xsl:value-of select="."/></field>
            <field name="file_s"><xsl:value-of select="$filename"/></field>
        </doc>
    </xsl:template>

    <!--
    <xsl:template match="div1">
        <xsl:param name="filename" />
        <doc>
            <field name="id"><xsl:value-of select="generate-id()"/></field>
            <field name="slug_s">/bsuva/promptbook/</field>
            <field name="project_s">Shakespearean Prompt-Books</field>
            <field name="section_s">div1_<xsl:value-of select="@type" /></field>
            <field name="title_s"><xsl:value-of select="/TEI.2/teiHeader/fileDesc/sourceDesc/biblFull/titleStmt/title" /></field>
            <field name="fulltext_t"><xsl:value-of select="."/></field>
            <field name="file_s"><xsl:value-of select="$filename"/></field>
        </doc>
    </xsl:template>

    <xsl:template match="front">
        <xsl:param name="filename" />
        <doc>
            <field name="id"><xsl:value-of select="generate-id()" /></field>
            <field name="slug_s">/bsuva/promptbook/</field>
            <field name="project_s">Shakespearean Prompt-Books</field>
            <field name="section_s">front</field>
            <field name="title_s"><xsl:value-of select="/TEI.2/teiHeader/fileDesc/sourceDesc/biblFull/titleStmt/title" /></field>
            <field name="fulltext_t"><xsl:value-of select="node()"/></field>
            <field name="file_s"><xsl:value-of select="$filename"/></field>
        </doc>

    </xsl:template>

    <xsl:template match="teiHeader" >
        <xsl:param name="filename" />
        <doc>
            <field name="id"><xsl:value-of select="generate-id()"/></field>
            <field name="slug_s">/bsuva/promptbook/</field>
            <field name="project_s">Shakespearean Prompt-Books</field>
            <field name="section_s">header</field>
            <field name="title_s"><xsl:value-of select="/TEI.2/teiHeader/fileDesc/sourceDesc/biblFull/titleStmt/title" /></field>
            <field name="fulltext_t"><xsl:value-of select="node()"/></field>
            <field name="file_s"><xsl:value-of select="$filename"/></field>
        </doc>
    </xsl:template>
    -->

</xsl:stylesheet>
