<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:local="http://whatever" xmlns:xs="http://www.w3.org/2001/XMLSchema" version="2.0">

  <xsl:output method="text"/>

  <xsl:template match="/">
    <xsl:text>[</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>]</xsl:text>
  </xsl:template>
  
  <xsl:template match="work">
    <xsl:text>{</xsl:text>
    <xsl:apply-templates select="id"/>
    <xsl:if test="authors|editors">,</xsl:if>
    <xsl:apply-templates select="authors|editors"/>
    <xsl:if test="title">,</xsl:if>
    <xsl:apply-templates select="title"/>
    <xsl:if test="edition">,</xsl:if>
    <xsl:apply-templates select="edition"/>
    <xsl:if test="keywords">,</xsl:if>
    <xsl:apply-templates select="keywords"/>
    <xsl:text>}</xsl:text>
    <xsl:if test="following-sibling::work">,</xsl:if>
  </xsl:template>
  
  <xsl:template match="id">
    <xsl:value-of select="local:quote('id')"/>
    <xsl:text>: </xsl:text>
    <xsl:value-of select="."/>
  </xsl:template>
  
  <xsl:template match="authors|editors|keywords">
    <xsl:value-of select="concat(local:quote(local-name()), ': [')"/>
    <xsl:apply-templates/>
    <xsl:text>]</xsl:text>
    <xsl:if test="following-sibling::authors or following-sibling::editors">,</xsl:if>
  </xsl:template>

  <xsl:template match="name|word">
    <xsl:value-of select="local:quote(.)"/>
    <xsl:if test="following-sibling::*">,</xsl:if>
  </xsl:template>
  
  <xsl:template match="title|edition">
    <xsl:value-of select="concat(local:quote(local-name()), ': ')"/>
    <xsl:value-of select="local:quote(.)"/>
  </xsl:template>
  


  <xsl:function name="local:quote" as="xs:string">
    <xsl:param name="val"/>
    <xsl:value-of select="concat('&quot;', normalize-space(local:escape-quotes($val)), '&quot;')"/>
  </xsl:function>

  <xsl:function name="local:escape-quotes" as="xs:string">
    <xsl:param name="val"/>
    <xsl:value-of select="replace($val, '&quot;', '\\&quot;')"/>
  </xsl:function>

</xsl:stylesheet>
