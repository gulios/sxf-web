<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:func="http://exslt.org/functions"
                xmlns:str="http://exslt.org/strings"
                xmlns:php="http://php.net/xsl"
                extension-element-prefixes="str func php">


    <!--type JS add addslashes-->

    <func:function name="str:sxfGetKey">
        <xsl:param name="key"/>

        <xsl:variable name="result">
            <xsl:value-of select="str:sxfGetKeyPHP($key)"/>
        </xsl:variable>

        <func:result select="$result"/>
    </func:function>

    <func:function name="str:sxfGetKeyPHP">
        <xsl:param name="key"/>
        <xsl:param name="getValue"><xsl:value-of select="php:function('class::getkey', normalize-space($key))"  disable-output-escaping="yes"/></xsl:param>

        <xsl:variable name="result">
            <xsl:value-of select="$getValue" disable-output-escaping="yes"/>
        </xsl:variable>
        <func:result select="$result"/>
    </func:function>

</xsl:stylesheet>