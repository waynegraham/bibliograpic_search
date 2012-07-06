<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
    <xsl:output method="text"/>
    <xsl:output method="html" indent="yes" name="html"/>
    
    <xsl:template match="/">
        
        <xsl:variable name="filename">
            <xsl:value-of select="/*/@id"/>
        </xsl:variable>
        
        <xsl:variable name="title">
            <xsl:value-of select="/TEI.2/teiHeader/fileDesc/titleStmt/title"/>
            <!--<xsl:value-of select="replace(/TEI.2/teiHeader/fileDesc/titleStmt/title,'[a machine-readable transcription]', '')" />-->
        </xsl:variable>
        
        <xsl:variable name="description">
            <xsl:value-of select="/TEI.2/teiHeader/fileDesc/seriesStmt/p" />
        </xsl:variable>
        
        <xsl:result-document href="{$filename}.html" format="html">
            <html lang="en">
                <head>
                    <meta charset="utf-8" />
                    <title><xsl:value-of select="$title"/></title>
                    <meta name="description" content="{$description}"/>
                    <meta name="viewport" content="width=device-width"/>
                    <link rel="stylesheet" href="stylesheets/screen.css"/>
                    <script src="../javascripts/modernizr-2.5.3.min.js"></script>
                </head>
                <body>
                    <div id="container">
            
                        <div class="file_navigation">
                            
                                <xsl:for-each select="//div0">
                                    <p><a href="#{@type}"><xsl:value-of select="@type"/></a> <xsl:value-of select="head"/></p>
                                </xsl:for-each>
                            
                        </div>
                        
                        <div id="contents">
                            <xsl:apply-templates />
                        </div>
                        
                        
                    </div>
                    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7/jquery.min.js"></script>
                    <script src="../javascripts/bootstrap-tooltip.js"></script>
                    <script src="../javascripts/bootstrap-popover.js"></script>
                    <script src="../javascripts/plugin.js"></script>
                </body>
            </html>
        </xsl:result-document>
        <!--
        <xsl:for-each select="//div0">
            
            <xsl:result-document href="{$filename}/{@type}.html" format="html">
            <html>
                <head>
                    <meta charset="utf-8" />
                    <title><xsl:value-of select="$title"/></title>
                    <meta name="description" content="{$description}"/>
                    <meta name="viewport" content="width=device-width"/>
                    <link rel="stylesheet" href="../stylesheets/screen.css"/>
                    <script src="../javascripts/modernizr-2.5.3.min.js"></script>
                </head>
                <body>
                    <div id="container">
                        <xsl:apply-templates />
                    </div>
                    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7/jquery.min.js"></script>
                    <script src="../javascripts/bootstrap-tooltip.js"></script>
                    <script src="../javascripts/bootstrap-popover.js"></script>
                    <script src="../javascripts/plugin.js"></script>
                </body>
            </html>
            </xsl:result-document>
        </xsl:for-each> -->
    </xsl:template>
    
    <xsl:template match="head">
        <h1><xsl:apply-templates /></h1>
    </xsl:template>
    
    <xsl:template match="div1">
        <div class="div1 {@type}">
            <xsl:apply-templates />
        </div>
    </xsl:template>
    
    <xsl:template match="xref">
        <a id="{@doc}" class="fragment" data-fragment="{@doc}" href="../images/{@doc}.jpg"><xsl:apply-templates /></a>
    </xsl:template>
    
    <xsl:template match="div2">
        <div id="{@id}" class="div2 {@type}">
            <xsl:apply-templates />
        </div>
    </xsl:template>
    
    <xsl:template match="list">
        <ul><xsl:apply-templates /></ul>
    </xsl:template>
    
    <xsl:template match="item">
        <li><xsl:apply-templates /></li>
    </xsl:template>
    
    <xsl:template match="figure">
        <img src="../images/{@entity}.gif" alt="{figDesc}" />
    </xsl:template>
    
    <xsl:template match="note">
        <xsl:choose>
            <xsl:when test="@id">
                <div class="note" id="{@id}">
                    <p><xsl:apply-templates /></p>
                </div>
            </xsl:when>
            <xsl:when test="@target">
                <a href="#{@target}"><xsl:value-of select="."/></a>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="hi">
        <xsl:choose>
            <xsl:when test="@rend='bold'">
                <strong><xsl:apply-templates /></strong>
            </xsl:when>
            <xsl:otherwise>
                <em><xsl:apply-templates /></em>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="lb">
        <br/>
    </xsl:template>
    
    <xsl:template match="p">
        <p><xsl:apply-templates /></p>
    </xsl:template>
    
</xsl:stylesheet>