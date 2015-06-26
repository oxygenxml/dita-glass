<?xml version="1.0" encoding="UTF-8"?>
<!-- ========================================= 
     created: 2015-06-21
     by:      Markus Wiedenmaier
              http://www.practice-innovation.de
              info@practice-innovation.de
     Descr.:  Schematron business rules for XGlass document types
     License: delivered "as is" with no warranties
              feel free in any case
     ========================================= -->

<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2"
    xmlns:sqf="http://www.schematron-quickfix.com/validator/process" defaultPhase="edit">
    
    <sch:phase id="edit">
        <sch:active pattern="conversion.protocol"/>
        <sch:active pattern="conversion.processor.parameters"/>
        <sch:active pattern="definitions.urn"/>
        <sch:active pattern="conversion.processors"/>
    </sch:phase>
    
    <sch:pattern id="conversion.protocol">
        <sch:rule context="conversion">
            <sch:report role="error" test="./preceding-sibling::conversion[@protocol = current()/@protocol]">
                conversion protocol '<sch:value-of select="@protocol"/>' declared more than once
            </sch:report>
        </sch:rule>
    </sch:pattern>
    <sch:pattern id="conversion.processor.parameters">
        <sch:rule context="parameter">
            <sch:report role="error" test="./preceding-sibling::parameter[@name= current()/@name]">
                parameter '<sch:value-of select="@name"/>' declared more than once
            </sch:report>
        </sch:rule>
    </sch:pattern>
    <sch:pattern id="definitions.urn">
        <sch:rule context="urn">
            <sch:report role="error" test="./preceding-sibling::urn[@name= current()/@name]">
                urn '<sch:value-of select="@name"/>' declared more than once
            </sch:report>
        </sch:rule>
    </sch:pattern>
    <sch:pattern id="conversion.processors">
        <sch:rule context="read | write">
            <sch:assert test="*">
                no processor defined in <sch:value-of select="name()"/>-pipeline
            </sch:assert>
        </sch:rule>
    </sch:pattern>
</sch:schema>