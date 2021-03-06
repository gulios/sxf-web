<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE stylesheet [
        <!ENTITY nbsp  "&#160;" ><!-- space -->
        <!ENTITY copy  "&#169;" ><!-- copyright -->
        ]>
<xsl:stylesheet
        version="1.0"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:exslt="http://exslt.org/common"
        xmlns:date="http://exslt.org/dates-and-times"
        xmlns:math="http://exslt.org/math"
        xmlns:set="http://exslt.org/sets"
        xmlns:dyn="http://exslt.org/dynamic"
        xmlns:str="http://exslt.org/strings"
        xmlns:php="http://php.net/xsl"
        exclude-result-prefixes="exslt date math set dyn str php ">

    <xsl:import href="GlobalVariablesView.xsl"/>
    <xsl:import href="GetTranslationsView.xsl"/>

    <xsl:output encoding="UTF-8" method="xml"
                omit-xml-declaration="yes" indent="yes" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
                doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"
                cdata-section-elements="script"/>

    <xsl:template match="/">
        <html xml:lang="en" lang="en">
            <head>
                <xsl:call-template name="HeadTitle"/>
                <xsl:call-template name="HeadDescription"/>
                <xsl:call-template name="HeadKeywords"/>
                <meta name="robots" content="noodp" />
                <meta name="author" content="Artur Gulios Milkowski" />
                <meta http-equiv="Expires" content="0" />
                <meta http-equiv="Pragma" content="no-cache" />
                <meta http-equiv="Cache-Control" content="no-cache" />
                <meta http-equiv="content-type" content="text/html; charset=utf-8" />
                <meta http-equiv="content-language" content="en"/>
                <xsl:call-template name="HeadCss"/>

                <xsl:if test="$sxfDebug = 1">
                    <xsl:value-of select="php:function('SXF\Web\Controllers\WebController::debugHead')"  disable-output-escaping="yes"/>
                </xsl:if>

            </head>
            <body>

                <div class="container">

                    <div style="color:black;padding: 0; background-image: url('{$sxfImagesPath}header.jpg')">
                        <h1>Simple XML Framework PHP</h1>
                    </div>

                    <div class="content">

                        <a href="{$sxfBaseUrl}test/123/abc">Check params validation test</a>

                        <form action="" method="POST">
                            <input hidden="yes" name="testpost" type="text" value="ZZZZZZ"/>
                            <input type="submit" value="False request test"/>
                        </form>

                        <xsl:call-template name="controllerContent"/>

                        Copyright &copy; <xsl:value-of select="$sxfTimeYear"/> Gulios. All rights reserved. <small> <xsl:value-of select="php:function('phpversion')"/></small>


                    </div>
                </div>

                <xsl:if test="$sxfDebug = 1">
                    <xsl:value-of select="php:function('SXF\Web\Controllers\WebController::debugBody')"  disable-output-escaping="yes"/>
                </xsl:if>


                <!--<xsl:for-each select="/xml/item/group_by[not(.=preceding::*)]">-->
                <!--</xsl:for-each>-->
                <!--<xsl:for-each select="/xml/item[current() = group_by]"></xsl:for-each>-->



            </body>
        </html>
    </xsl:template>

    <xsl:template name="controllerContent">
        <!--<xsl:apply-templates select="/xml/child::*"/>-->
        <xsl:apply-templates select="/xml/controller"/>
    </xsl:template>

    <xsl:template name="HeadTitle"><title>SXF - Simple XML Framework PHP</title></xsl:template>

    <xsl:template name="HeadDescription">
        <meta name="description">
            <xsl:attribute name="content">SXF - Simple XML Framework PHP</xsl:attribute>
        </meta>
    </xsl:template>

    <xsl:template name="HeadKeywords">
        <meta name="keywords">
            <xsl:attribute name="content">SXF, simple, php, framework, xslt, xslt transformation</xsl:attribute>
        </meta>
    </xsl:template>

    <xsl:template name="HeadCss">
        <link href="https://fonts.googleapis.com/css?family=Open+Sans:400,300,600,700&amp;subset=all" rel="stylesheet" type="text/css"/>

        <style>
            html, body {
            height: 100%;
            }
            body {
            margin: 0;
            padding: 0;
            width: 100%;
            color: #B0BEC5;
            display: table;
            font-weight: 300;
            font-family: "Open Sans",sans-serif;
            background-color:rgba(249,250,251,.45);
            background-image: url('images/background.jpg');
            }

            .container {
            text-align: center;
            display: table-cell;
            vertical-align: text-top;
            }
            a {
            text-decoration: none;
            color: #337ab7;
            }
            a:hover {
            text-decoration:underline;
            }

            .cover-ico {
            color:rgba(133,147,165,.2);
            font-size:10em;
            line-height:1;
            }
            .cover-heading,
            .cover-desc {
            margin:1em 0;
            }
            .cover-heading {
            color:#2f353b;
            font-size:1em;
            font-weight:600;
            }
            .cover-desc {
            color:#708096;
            font-size:.8em;
            font-weight:400;
            }
            .cover-block {
            text-align:center;
            display:table;
            max-width:580px;
            margin:0 auto;
            padding:2em;
            }
        </style>
    </xsl:template>

</xsl:stylesheet>
