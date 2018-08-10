<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <!-- xml -->
    <xsl:variable name="sxfDebug"><xsl:value-of select="/xml/data/@debug"/></xsl:variable>
    <xsl:variable name="sxfSessionId"><xsl:value-of select="/xml/data/@session_id"/></xsl:variable>
    <xsl:variable name="sxfBaseUrl"><xsl:value-of select="/xml/data/@baseUrl"/></xsl:variable>
    <xsl:variable name="sxfUri"><xsl:value-of select="/xml/data/@uri"/></xsl:variable>
    <xsl:variable name="sxfHttpHost"><xsl:value-of select="/xml/data/@httpHost"/></xsl:variable>
    <xsl:variable name="sxfIsSecure"><xsl:value-of select="/xml/data/@isSecure"/></xsl:variable>

    <!-- time -->
    <xsl:variable name="sxfTimeTime"><xsl:value-of select="/xml/time/@time"/></xsl:variable>
    <xsl:variable name="sxfTimeTimestamp"><xsl:value-of select="/xml/time/@timestamp"/></xsl:variable>
    <xsl:variable name="sxfTimeMicrotime"><xsl:value-of select="/xml/time/@microtime"/></xsl:variable>
    <xsl:variable name="sxfTimeTimezone"><xsl:value-of select="/xml/time/@timezone"/></xsl:variable>
    <xsl:variable name="sxfTimeDay"><xsl:value-of select="/xml/time/@day"/></xsl:variable>
    <xsl:variable name="sxfTimeMonth"><xsl:value-of select="/xml/time/@month"/></xsl:variable>
    <xsl:variable name="sxfTimeYear"><xsl:value-of select="/xml/time/@year"/></xsl:variable>

    <!-- geo -->
    <xsl:variable name="sxfGeoIp"><xsl:value-of select="/xml/geo/@ip"/></xsl:variable>
    <xsl:variable name="sxfGeoIsoCode"><xsl:value-of select="/xml/geo/@isoCode"/></xsl:variable>
    <xsl:variable name="sxfGeoCountry"><xsl:value-of select="/xml/geo/@country"/></xsl:variable>
    <xsl:variable name="sxfGeoCity"><xsl:value-of select="/xml/geo/@city"/></xsl:variable>
    <xsl:variable name="sxfGeoState"><xsl:value-of select="/xml/geo/@state"/></xsl:variable>
    <xsl:variable name="sxfGeoPostalCode"><xsl:value-of select="/xml/geo/@postal_code"/></xsl:variable>
    <xsl:variable name="sxfGeoLatitude"><xsl:value-of select="/xml/geo/@lat"/></xsl:variable>
    <xsl:variable name="sxfGeoLongitude"><xsl:value-of select="/xml/geo/@lon"/></xsl:variable>
    <xsl:variable name="sxfGeoTimezone"><xsl:value-of select="/xml/geo/@timezone"/></xsl:variable>
    <xsl:variable name="sxfGeoContinent"><xsl:value-of select="/xml/geo/@continent"/></xsl:variable>
    <xsl:variable name="sxfGeoDefault"><xsl:value-of select="/xml/geo/@default"/></xsl:variable>

    <!-- public -->
    <xsl:variable name="sxfImagesPath"><xsl:value-of select="$sxfBaseUrl"/>images/</xsl:variable>
    <xsl:variable name="sxfCssPath"><xsl:value-of select="$sxfBaseUrl"/>css/</xsl:variable>

</xsl:stylesheet>