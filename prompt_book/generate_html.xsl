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
                    <script src="javascripts/modernizr-2.5.3.min.js"></script>
                </head>
                <body>

                    <div class="container">

                        <header role="banner">Shakespearean Prompt-Books</header>

                        <div class="masthead">
                            <img src="http://bsuva-epubs.org/wordpress/wp-content/themes/bsuva/images/type.jpg"/>
                        </div>

                        <div id="content">

                            <div class="span2 well sidebar-nav">
                                <ul class="nav nav-list">
                                <xsl:for-each select="//div0">
                                      <li class="nav-header"><xsl:value-of select="@type"/></li>
                                      <xsl:choose>
                                          <xsl:when test="@type = 'introduction'">
                                              <li><a href="div0_#{@type}"><xsl:value-of select="head"/></a></li>
                                          </xsl:when>
                                          <xsl:when test="@type = 'preface'">
                                              <li><a href="div0_#{@type}"><xsl:value-of select="head"/></a></li>
                                          </xsl:when>
                                          <xsl:when test="@type = 'notes'">
                                              <li><a href="div0_#{@type}"><xsl:value-of select="head"/></a></li>
                                          </xsl:when>
                                          <xsl:otherwise>
                                              <xsl:call-template name="page-navigation" />
                                          </xsl:otherwise>
                                      </xsl:choose>
                                  </xsl:for-each>
                                  </ul>
                              </div>

                              <!-- <xsl:apply-templates select="//div0"/>-->
                              <xsl:apply-templates />

                          </div>

                          <script src="http://platform.twitter.com/widgets.js"></script>
                          <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js"></script>
                          <script src="javascripts/jquery.lightbox.js"></script>
                          <script src="javascripts/bootstrap.min.js"></script>
                          <script src="javascripts/plugin.js"></script>

                      </div>

                </body>
            </html>
        </xsl:result-document>

    </xsl:template>

    <xsl:template match="head">
        <xsl:choose>
            <xsl:when test="parent::div0">
                <h1><xsl:apply-templates /></h1>
            </xsl:when>
            <xsl:when test="parent::div1">
                <h2><xsl:apply-templates /></h2>
            </xsl:when>
            <xsl:when test="parent::div2">
                <h3><xsl:apply-templates /></h3>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="div0">
        <div id="div0_{@type}" class="div0">
            <xsl:apply-templates />
        </div>
    </xsl:template>

    <xsl:template match="div1">
        <div id="div1_{@type}" class="div1">
            <xsl:apply-templates />
        </div>
    </xsl:template>

    <xsl:template match="div2">
        <div id="div2_{@n}" class="div2 {@type}">
            <xsl:apply-templates />
        </div>
    </xsl:template>

    <xsl:template name="page-navigation">

        <xsl:for-each select="div1">
            <xsl:for-each select="div2">
                <li><a href="#div2_{@n}" class="nav-heading">Act <xsl:value-of select="head" /></a></li>
            </xsl:for-each>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="xref">
        <a class="fragment" data-toggle="{@doc}" href="images/{@doc}.jpg"><xsl:apply-templates /></a>
    </xsl:template>

    <xsl:template match="list">
        <ul><xsl:apply-templates /></ul>
    </xsl:template>

    <xsl:template match="item">
        <li><xsl:apply-templates /></li>
    </xsl:template>

    <xsl:template match="figure">
        <a href="images/{@entity}.jpg">
            <img src="images/{@entity}.gif" alt="{figDesc}" />
        </a>
    </xsl:template>

    <xsl:template match="note">
        <xsl:choose>
            <xsl:when test="@id">
                <div class="note" id="note_{@id}">
                    <p><xsl:apply-templates /></p>
                </div>
            </xsl:when>
            <xsl:when test="@target">
                <a href="#{@target}" class="super"><xsl:value-of select="."/></a>
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
