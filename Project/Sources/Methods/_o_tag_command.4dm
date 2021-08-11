//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : element.command
// ID[2916DBDFC849421F8A1621F76D8DC637]
// Created 12/11/10 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
//
// ----------------------------------------------------
// Declarations
C_POINTER:C301($1)

C_LONGINT:C283($Lon_i; $Lon_parameters)
C_TEXT:C284($Txt_code; $Txt_commandName; $Txt_commandNumber; $Txt_formula; $Txt_pattern)

If (False:C215)
	C_POINTER:C301(_o_tag_command; $1)
End if 

// ----------------------------------------------------
// Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1; "Missing parameter"))
	
	$Txt_code:=$1->
	
	$Txt_pattern:="<command number=\"([^\"]*)\"/>"
	
Else 
	
	ABORT:C156
	
End if 

// ----------------------------------------------------
ARRAY TEXT:C222($tTxt_segments; 0x0000; 0x0000)

If (Rgx_ExtractText($Txt_pattern; $Txt_code; ""; ->$tTxt_segments)=0)
	
	For ($Lon_i; 1; Size of array:C274($tTxt_segments); 1)
		
		$Txt_commandNumber:=$tTxt_segments{$Lon_i}{1}
		
		If (Num:C11(Application version:C493)>=1730)  // 17R3+
			
			$Txt_formula:=Command name:C538(538)+"("+$Txt_commandNumber+")"
			
			$Txt_commandName:=New object:C1471("eval"; Formula from string:C1601($Txt_formula)).eval()
			
			$Txt_code:=Replace string:C233($Txt_code; $tTxt_segments{$Lon_i}{0}; $Txt_commandName)
			
		Else 
			
			//<>Txt_buffer:=""
			//EXECUTE FORMULA("<>Txt_buffer:="+Command name(538)+"("+$Txt_commandNumber+")")
			//$Txt_code:=Replace string($Txt_code;$tTxt_segments{$Lon_i}{0};<>Txt_buffer)
			
		End if 
	End for 
End if 

$1->:=$Txt_code

// ----------------------------------------------------
// End