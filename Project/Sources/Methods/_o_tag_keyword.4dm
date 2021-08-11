//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : element.keyword
// ID[A33501CD2CEF4B5DA3920ED66990CDCD]
// Created 12/11/10 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
// Localize branching and looping structures
// ----------------------------------------------------
// Declarations
C_POINTER:C301($1)

C_LONGINT:C283($Lon_i; $Lon_parameters)
C_TEXT:C284($Txt_buffer; $Txt_code)

If (False:C215)
	C_POINTER:C301(_o_tag_keyword; $1)
End if 

// ----------------------------------------------------
// Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1; "Missing parameter"))
	
	$Txt_code:=$1->
	
Else 
	
	ABORT:C156
	
End if 

// ----------------------------------------------------
ARRAY TEXT:C222($tTxt_US; 11)
$tTxt_US{1}:="if"
$tTxt_US{2}:="else"
$tTxt_US{3}:="end_if"
$tTxt_US{4}:="case_of"
$tTxt_US{5}:="end_case"
$tTxt_US{6}:="while"
$tTxt_US{7}:="end_while"
$tTxt_US{8}:="for"
$tTxt_US{9}:="end_for"
$tTxt_US{10}:="repeat"
$tTxt_US{11}:="until"

If (Command name:C538(41)="ALERT")  //US
	
	For ($Lon_i; 1; Size of array:C274($tTxt_US); 1)
		
		$Txt_buffer:=Replace string:C233($tTxt_US{$Lon_i}; "_"; " ")
		$Txt_code:=Replace string:C233($Txt_code; "<"+$tTxt_US{$Lon_i}+"/>"; $Txt_buffer)
		
	End for 
	
Else 
	
	ARRAY TEXT:C222($tTxt_FR; 11)
	$tTxt_FR{1}:="Si"
	$tTxt_FR{2}:="Sinon"
	$tTxt_FR{3}:="Fin de si"
	$tTxt_FR{4}:="Au cas ou"
	$tTxt_FR{5}:="Fin de cas"
	$tTxt_FR{6}:="Tant que"
	$tTxt_FR{7}:="Fin tant que"
	$tTxt_FR{8}:="Boucle"
	$tTxt_FR{9}:="Fin de boucle"
	$tTxt_FR{10}:="Repeter"
	$tTxt_FR{11}:="Jusque"
	
	For ($Lon_i; 1; Size of array:C274($tTxt_US); 1)
		
		$Txt_code:=Replace string:C233($Txt_code; "<"+$tTxt_US{$Lon_i}+"/>"; $tTxt_FR{$Lon_i})
		
	End for 
	
End if 

$1->:=$Txt_code
// ----------------------------------------------------
// End