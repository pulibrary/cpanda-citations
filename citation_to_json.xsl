<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:local="http://whatever" xmlns:xs="http://www.w3.org/2001/XMLSchema" version="2.0">

  <xsl:output method="text"/>

  <xsl:template match="/">
    <xsl:text>[</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>]</xsl:text>
  </xsl:template>

  <xsl:template match="*" priority="1">
    <xsl:next-match/>
    <xsl:if test="following-sibling::*">,</xsl:if>
  </xsl:template>

  <!-- work is the primary object -->
    <xsl:template match="work">
    <xsl:text>{</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>}</xsl:text>
  </xsl:template>
  
  <!-- numbers -->
  <xsl:template match="id">
    <xsl:value-of select="concat(local:keyify(local-name()), current())"/>
  </xsl:template>
  
  <!-- arrays -->
  <xsl:template match="authors|editors|keywords">
    <xsl:value-of select="concat(local:keyify(local-name()), ' [')"/>
    <xsl:apply-templates/>
    <xsl:text>]</xsl:text>
  </xsl:template>

  <!-- strings that go in arrays -->
  <xsl:template match="name|word">
    <xsl:value-of select="local:quote(.)"/>
  </xsl:template>
  
  <!-- simple "key" : "values" -->
  <xsl:template match="title|edition|language|publisher|date|pages|url|enum|snum|no|name[parent::container]">
    <xsl:value-of select="concat(local:keyify(local-name()), local:quote(.))"/>
  </xsl:template>

  <xsl:template match="@type">
    <xsl:value-of select="concat(local:keyify('type'), '&quot;', current(), '&quot;,')"/>
  </xsl:template>

  <!-- objects { } -->
  <xsl:template match="physicalObject|container">
    <xsl:value-of select="concat(local:keyify(local-name()), ' {')"/>
    <xsl:apply-templates select="*|@type"/>
    <xsl:text>}</xsl:text>
  </xsl:template>
  
  <!-- helpers -->  
  <xsl:function name="local:keyify" as="xs:string">
    <xsl:param name="key-name" as="xs:string"/>
    <xsl:value-of select="concat(local:quote($key-name), ': ')"/>
  </xsl:function> 

  <xsl:function name="local:quote" as="xs:string">
    <xsl:param name="val" as="xs:string"/>
    <xsl:value-of select="concat('&quot;', normalize-space(local:escape-quotes($val)), '&quot;')"/>
  </xsl:function>

  <xsl:function name="local:escape-quotes" as="xs:string">
    <xsl:param name="val" as="xs:string"/>
    <xsl:value-of select="replace($val, '&quot;', '\\&quot;')"/>
  </xsl:function>

</xsl:stylesheet>
