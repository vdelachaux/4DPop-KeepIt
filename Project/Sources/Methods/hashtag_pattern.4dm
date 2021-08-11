//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : hashtag.pattern
// Database: 4DPop KeepIt
// ID[2AAA2D92B8F24C258EBD4F1DC8B260E1]
// Created 6-2-2013 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
//
// ----------------------------------------------------
// Declarations
C_TEXT:C284($0)

C_LONGINT:C283($Lon_parameters)
C_TEXT:C284($Txt_pattern)

If (False:C215)
	C_TEXT:C284(hashtag_pattern; $0)
End if 

// ----------------------------------------------------
// Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=0; "Missing parameter"))
	
	//NO PARAMETERS REQUIRED
	
Else 
	
	ABORT:C156
	
End if 

// ----------------------------------------------------
//$Txt_pattern:="(?mx)^(?=.*/{2})(.*?)$"
//$Txt_pattern:="(?mx)^(?=[^\\x22]*//)(?=.*//).*\\#"+"([^\\s]*)"
//$Txt_pattern:="(?mx)^(?=[^\\x22]*//)(?=.*//)(?:.*\\#"+"([^\\s]{4,}).*)*$"
//$Txt_pattern:="(?mx)^(?=[^\\x22]*//)(?=.*//)(?:.*\\#"+"([^\\s]{4,})(?!.*//).*)*$"
//$Txt_pattern:="(?mx)^(?=[^\\x22]*//)(?=.*//)(?:.*\\#"+"([^\\s\\$\"]{4,})(?!.*//).*)*$"
//$Txt_pattern:="(?mx)^(?=[^\\x22]*//)(?=.*//)(?:[^\"]*\\#"+"((?:[^\\s\\$\"0-9(#!?†<])+[^\\s\\$]{4,})(?!.*//).*)*$"
//$Txt_pattern:="(?mx)^(?=[^\\x22]*//)(?=.*//)(?:[^\"]*\\#([a-zA-Z]+[^\\s\\$]{3,})(?!.*//).*)*$"
//^(?=.*//)[^#]*#([^-#"][a-zA-Z0-9-]*).*$
//$Txt_pattern:="(?mi-s)^(?=.*?//.*$)[^#]*#([^-#\"][:a-zA-Z0-9-]*).*$"
//$Txt_pattern:="(?mi-s)^.*?//[^#]*#([^-#\"<\\$][:a-zA-Z0-9-]*).*$"
//$Txt_pattern:="(?mi-s)^.*//[^#]*#([^-#\"][:a-zA-Z0-9-]*).*$"
//$Txt_pattern:="(?mi-s)^(?=.*//.*#).*//[^#]*#([^-#\"<>†!?][:_/a-zA-Z0-9-]*).*$"
//$Txt_pattern:="(?mi-s)^(?=.*//.*#).*//[^#]*#([a-zA-Z][:_/a-zA-Z0-9-]*).*$"
$Txt_pattern:="(?mi-s)^(?=.*//.*#).*//[^#]*#([a-zA-Z0-9][:_a-zA-Z0-9-]{4,}).*$"

$0:=$Txt_pattern

// ----------------------------------------------------
// End