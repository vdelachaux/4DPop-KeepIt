//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : element.constant
// ID[0E3002BB36E64D1787DB1D50C9E03761]
// Created 12/11/10 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
// ----------------------------------------------------
// Declarations
C_POINTER:C301($1)

C_LONGINT:C283($Lon_i; $Lon_ii; $Lon_parameters; $Lon_x)
C_TEXT:C284($Dom_root; $Dom_target; $Txt_buffer; $Txt_code; $Txt_id; $Txt_path)
C_TEXT:C284($Txt_pattern; $Txt_value)

If (False:C215)
	C_POINTER:C301(_o_tag_constant; $1)
End if 

ARRAY TEXT:C222($tTxt_segments; 0x0000; 0x0000)

// ----------------------------------------------------
// Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1; "Missing parameter"))
	
	$Txt_code:=$1->
	
	$Txt_pattern:="<constant id=\"([^\"]*)\"/>"
	
Else 
	
	ABORT:C156
	
End if 

// ----------------------------------------------------
If (Size of array:C274(<>_o_constantName)=0)
	
	ARRAY TEXT:C222($tTxt_Components; 0x0000)
	
	COMPONENT LIST:C1001($tTxt_Components)
	
	If (Asserted:C1132(Find in array:C230($tTxt_Components; "4DPop")>0; "The component '4dPop' is not installed or loaded."))
		
		ARRAY LONGINT:C221($tLon_size; 0x0000)
		ARRAY TEXT:C222($tDom_groups; 0x0000)
		ARRAY TEXT:C222($tDom_units; 0x0000)
		ARRAY TEXT:C222($tTxt_files; 0x0000)
		EXECUTE METHOD:C1007("4DPop_applicationFolder"; $Txt_path; kLanguage)
		DOCUMENT LIST:C474($Txt_path; $tTxt_files)
		$Lon_x:=Find in array:C230($tTxt_files; "4D_Constants@.xlf")
		
		If ($Lon_x>0)
			
			$Txt_path:=$Txt_path+$tTxt_files{$Lon_x}
			
			If (Test path name:C476($Txt_path)=Is a document:K24:1)
				
				$Dom_root:=DOM Parse XML source:C719($Txt_path)
				
				If (OK=1)
					
					$tDom_groups{0}:=DOM Find XML element:C864($Dom_root; "/xliff/file/body/group"; $tDom_groups)
					ON ERR CALL:C155("noError")
					
					For ($Lon_i; 1; Size of array:C274($tDom_groups); 1)
						
						$tDom_units{0}:=DOM Find XML element:C864($tDom_groups{$Lon_i}; "/group/trans-unit"; $tDom_units)
						
						For ($Lon_ii; 1; Size of array:C274($tDom_units); 1)
							
							DOM GET XML ATTRIBUTE BY NAME:C728($tDom_units{$Lon_ii}; "d4:value"; $Txt_buffer)
							
							If (OK=1)
								
								$Dom_target:=DOM Find XML element:C864($tDom_units{$Lon_ii}; "/trans-unit/target")
								
								If (OK=0)
									
									$Dom_target:=DOM Find XML element:C864($tDom_units{$Lon_ii}; "/trans-unit/source")
									
								End if 
								
								DOM GET XML ELEMENT VALUE:C731($Dom_target; $Txt_value)
								DOM GET XML ATTRIBUTE BY NAME:C728($tDom_units{$Lon_ii}; "id"; $Txt_id)
								APPEND TO ARRAY:C911(<>_o_constantName; $Txt_value)
								APPEND TO ARRAY:C911(<>_o_constantToken; Replace string:C233($Txt_id; "_"; "."))
								APPEND TO ARRAY:C911($tLon_size; Length:C16($Txt_value))
								
							End if 
						End for 
					End for 
					
					ON ERR CALL:C155("")
					DOM CLOSE XML:C722($Dom_root)
					SORT ARRAY:C229($tLon_size; <>_o_constantName; <>_o_constantToken; <)
					
				End if 
			End if 
		End if 
	End if 
End if 

If (Rgx_ExtractText($Txt_pattern; $Txt_code; ""; ->$tTxt_segments)=0)
	
	For ($Lon_i; 1; Size of array:C274($tTxt_segments); 1)
		
		$Lon_x:=Find in array:C230(<>_o_constantToken; $tTxt_segments{$Lon_i}{1})
		$Txt_code:=Replace string:C233($Txt_code; $tTxt_segments{$Lon_i}{0}; Choose:C955($Lon_x>0; <>_o_constantName{$Lon_x}; "•"+$tTxt_segments{$Lon_i}{0}+"•"))
		
	End for 
End if 

$1->:=$Txt_code

// ----------------------------------------------------
// End