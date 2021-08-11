//%attributes = {"invisible":true}
// ----------------------------------------------------
// Method : Rgx_Get_Pattern
// Created 16/12/05 by Vincent de Lachaux
// ----------------------------------------------------
// Description
//
// ----------------------------------------------------
// Modified by Vincent (28/09/07)
// 2004 -> v11
C_TEXT:C284($0)
C_TEXT:C284($1)
C_TEXT:C284($2)
C_POINTER:C301($3)

C_LONGINT:C283($Lon_error; $Lon_parameters)
C_TEXT:C284($Dom_pattern; $Dom_patterns; $Dom_root; $Txt_buffer; $Txt_elementName; $Txt_Path)
C_TEXT:C284($Txt_patternName)

If (False:C215)
	C_TEXT:C284(Rgx_Get_Pattern; $0)
	C_TEXT:C284(Rgx_Get_Pattern; $1)
	C_TEXT:C284(Rgx_Get_Pattern; $2)
	C_POINTER:C301(Rgx_Get_Pattern; $3)
End if 

$Lon_parameters:=Count parameters:C259

If ($Lon_parameters>0)
	
	$Txt_patternName:=$1
	
	If ($Lon_parameters>=2)
		$Txt_Path:=$2
	End if 
	
	If (Length:C16($Txt_Path)=0)
		$Txt_Path:=Get 4D folder:C485(_o_Extras folder:K5:12)+"regex.xml"
	End if 
	
	OK:=Num:C11(Test path name:C476($Txt_Path)=Is a document:K24:1)
	
	If (OK=1)
		$Dom_root:=DOM Parse XML source:C719($Txt_Path; False:C215)
		If (OK=1)
			$Dom_patterns:=DOM Find XML element:C864($Dom_root; "/REGEX/patterns/")
			If (OK=1)
				$Dom_pattern:=DOM Get first child XML element:C723($Dom_patterns)
				If (OK=1)
					Repeat 
						DOM GET XML ATTRIBUTE BY NAME:C728($Dom_pattern; "name"; $Txt_elementName)
						If ($Txt_patternName=$Txt_elementName)
							DOM GET XML ELEMENT VALUE:C731($Dom_pattern; $Txt_buffer; $Txt_buffer)
							If (Count parameters:C259>=3)
								DOM GET XML ATTRIBUTE BY NAME:C728($Dom_pattern; "groupsToExtract"; $3->)
							End if 
						Else 
							$Dom_pattern:=DOM Get next sibling XML element:C724($Dom_pattern)
						End if 
					Until ($Txt_patternName=$Txt_elementName) | (OK=0)
				End if 
			End if 
			DOM CLOSE XML:C722($Dom_root)
		End if 
		
		//Deleting Spaces & Comments
		$Lon_error:=Rgx_SubstituteText("\\s*\\(\\?#[^)]*\\)|\\s"; ""; ->$Txt_buffer)
	End if 
End if 

$0:=$Txt_buffer