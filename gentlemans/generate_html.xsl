<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
    <xsl:output method="text"/>
    <xsl:output method="html" indent="yes" name="html"/>


    <xsl:template match="/">
        <xsl:variable name="description">
            <xsl:value-of select="//fileDesc/sourceDesc/biblFull/titleStmt/title"/> by <xsl:value-of
                select="//fileDesc/sourceDesc/biblFull/titleStmt/author"/>
        </xsl:variable>

        <xsl:for-each select="//div1">
            <xsl:variable name="filename" select="concat(@id, '.html')"/>
            <xsl:value-of select="$filename"/>

            <xsl:result-document href="{$filename}" format="html">

                <html lang="en">
                    <xsl:call-template name="head">
                        <xsl:with-param name="description" />
                    </xsl:call-template>
                    <body>
                        <div id="container">
                            <xsl:call-template name="header"/>
                            <xsl:apply-templates/>
                        </div>
                    </body>
                </html>
            </xsl:result-document>

        </xsl:for-each>

        <xsl:result-document href="index.html" format="html">
            <html lang="en">
                <xsl:call-template name="head">
                    <xsl:with-param name="description" />
                </xsl:call-template>
                <body>
                    <div id="container">
                        <xsl:call-template name="header"/>
                        <h2 class="center">Attributions by Volume</h2>
                        <div class="file_navigation">
                            <p>
                            <xsl:for-each select="//div1">

                                <a href="{@id}.html">
                                    <xsl:value-of select="head/date"/>
                                </a>&#xA0;

                            </xsl:for-each>
                            </p>
                        </div>
                    </div>
                </body>
            </html>
        </xsl:result-document>
    </xsl:template>

    <xsl:template name="head">
        <xsl:param name="description"/>
        <xsl:param name="title"/>
        <head>
            <meta content="utf-8"/>
            <xsl:choose>
                <xsl:when test="string-length($title) > 0">
                    <title>Attributions of Authorship in the Gentleman's Magazine | <xsl:value-of
                    select="$title"/></title>
                </xsl:when>
                <xsl:otherwise><title>Attributions of Authorship in the Gentleman's Magazine</title></xsl:otherwise>
            </xsl:choose>

            <meta name="description" content="{$description}"/>
            <meta name="viewport" content="width=device-width"/>
            <link href="stylesheets/screen.css" media="screen, projection" rel="stylesheet"
                type="text/css"/>
        </head>
    </xsl:template>

    <xsl:template name="header">
        <header>
            <img src="images/gate2.gif" alt="gate2"/>
            <nav>
                <ul>
                    <li>
                        <a href="http://bsuva-epubs.org/bsuva/gm2/">Home</a>
                    </li>
                    <li>
                        <a href="http://bsuva-epubs.org/bsuva/gm2/GMintro.html">Introduction</a>
                    </li>
                    <li>
                        <a href="">Search</a>
                    </li>
                    <li>
                        <a href="http://bsuva-epubs.org/bsuva/gm2/GMintro.html#howto">Help</a>
                    </li>
                    <li>
                        <a href="mailto:edemontluzin@fmarion.edu">Email the Author</a>
                    </li>
                </ul>
            </nav>
        </header>
        <h1 class="center">Attributions of Authorship in the <em>Gentleman's Magazine</em>,<br/>
            1731-1868: An Electronic Union List</h1>
        <img class="center" src="images/leafrev.gif"/>
        <h2 class="center">Emily Lorraine de Montluzin</h2>
        <hr/>
    </xsl:template>

    <xsl:template match="head">
        <h3>
            <xsl:value-of select="."/>
        </h3>
    </xsl:template>

    <xsl:template match="p">
        <div class="p">
            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <xsl:template match="list">
        <ul>
            <xsl:apply-templates/>
        </ul>
    </xsl:template>

    <xsl:template match="item">
        <xsl:variable name="id">
            <xsl:value-of select="position()"/>
        </xsl:variable>
        <li id="{$id}">
            <xsl:apply-templates/>
            <hr/>
        </li>
    </xsl:template>

    <xsl:template match="xref">
        <span class="xref">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <xsl:template match="rs">
        <span class="{@type}">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <xsl:template match="ref">
        <span class="ref">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <xsl:template match="bibl">
        <span class="bibl">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <xsl:template match="date">
        <span class="date">(<xsl:value-of select="."/>)</span>
    </xsl:template>

    <xsl:template match="name">
        <p class="name">
            <xsl:apply-templates/>
        </p>
    </xsl:template>

    <xsl:template match="s">
        <span class="sentence">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <xsl:template match="orig">
        <span class="orig">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <xsl:template match="hi">
        <xsl:choose>
            <xsl:when test="@rend='bold'">
                <strong>
                    <xsl:apply-templates/>
                </strong>
            </xsl:when>
            <xsl:otherwise>
                <em>
                    <xsl:apply-templates/>
                </em>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
