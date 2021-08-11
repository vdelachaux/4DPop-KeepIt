//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : keepit_indentation
// ID[0B876D20D701401A973BEF96B8EF592B]
// Created 11/10/10 by Vincent de Lachaux
// ----------------------------------------------------
// Description
// copy the selected text of the method with indentationation
// to allow pasting in a text editor
// ----------------------------------------------------
// Modified by Vincent de Lachaux (02/07/18)
// Use new commands:
//     - Split string
//     - objects
// Add new   control flow structures:
//     - For each / End for each
//     - Use / End use
// ----------------------------------------------------
// Declarations
C_TEXT:C284($0)
C_TEXT:C284($1)

C_LONGINT:C283($Lon_parameters)
C_TEXT:C284($kTxt_tab; $Txt_code; $Txt_line)
C_OBJECT:C1216($Obj_flow)
C_COLLECTION:C1488($Col_lines)

If (False:C215)
	C_TEXT:C284(keepit_indent; $0)
	C_TEXT:C284(keepit_indent; $1)
End if 

// ----------------------------------------------------
// Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1; "Missing parameter"))
	
	$Txt_code:=$1
	
	ARRAY TEXT:C222($tTxt_controlFlow; 0x0000)
	localizedControlFlow(""; ->$tTxt_controlFlow)
	
	$kTxt_tab:=Char:C90(Space:K15:42)*3
	
Else 
	
	ABORT:C156
	
End if 

// ----------------------------------------------------
If (Length:C16($Txt_code)>0)
	
	$Col_lines:=Split string:C1554($Txt_code; "\r"; sk trim spaces:K86:2)
	
	CLEAR VARIABLE:C89($Txt_code)
	
	$Obj_flow:=New object:C1471(\
		"value"; ""; \
		"level"; 0; \
		"indentation"; 0)
	
	For each ($Txt_line; $Col_lines)
		
		// Remove tabulations
		$Txt_line:=Replace string:C233($Txt_line; "\t"; "")
		
		Case of 
				
				//______________________________________________________
			: (Length:C16($Txt_line)=0)
				
				// <NOTHING MORE TO DO>
				
				//______________________________________________________
			: (Match regex:C1019("(?m-si)^"+$tTxt_controlFlow{2}; $Txt_line; 1))  // Else
				
				If ($Obj_flow.value=$tTxt_controlFlow{4})
					
					// Else into a Case of
					$Obj_flow.indentation:=$Obj_flow.level-1-(2*Num:C11((Num:C11($Obj_flow.caseOf)#0)))
					
				Else 
					
					$Obj_flow.indentation:=$Obj_flow.level-1
					
				End if 
				
				$Obj_flow.value:=$tTxt_controlFlow{2}
				
				//______________________________________________________
			: (Match regex:C1019("(?m-si)^"+$tTxt_controlFlow{1}+"\\W"; $Txt_line; 1))  // If
				
				$Obj_flow.indentation:=$Obj_flow.level
				$Obj_flow.level:=$Obj_flow.level+1
				
				$Obj_flow.value:=$tTxt_controlFlow{1}
				$Obj_flow.caseOf:=Num:C11($Obj_flow.caseOf)+1
				
				//______________________________________________________
			: (Match regex:C1019("(?m-si)^"+$tTxt_controlFlow{4}+"\\W*"; $Txt_line; 1))  // Case of
				
				$Obj_flow.indentation:=$Obj_flow.level
				$Obj_flow.level:=$Obj_flow.level+1
				
				$Obj_flow.value:=$tTxt_controlFlow{4}
				
				//______________________________________________________
			: (Match regex:C1019("(?m-si)^"+$tTxt_controlFlow{14}+"\\W"; $Txt_line; 1))  // For each
				
				$Obj_flow.indentation:=$Obj_flow.level
				$Obj_flow.level:=$Obj_flow.level+1
				
				$Obj_flow.value:=$tTxt_controlFlow{14}
				
				//______________________________________________________
			: (Match regex:C1019("(?m-si)^"+$tTxt_controlFlow{8}+"\\W"; $Txt_line; 1))  // For
				
				$Obj_flow.indentation:=$Obj_flow.level
				$Obj_flow.level:=$Obj_flow.level+1
				
				$Obj_flow.value:=$tTxt_controlFlow{8}
				
				//______________________________________________________
			: (Match regex:C1019("(?m-si)^"+$tTxt_controlFlow{6}+"\\W"; $Txt_line; 1))  // While
				
				$Obj_flow.indentation:=$Obj_flow.level
				$Obj_flow.level:=$Obj_flow.level+1
				
				$Obj_flow.value:=$tTxt_controlFlow{6}
				
				//______________________________________________________
			: (Match regex:C1019("(?m-si)^"+$tTxt_controlFlow{10}+"\\W"; $Txt_line; 1))  // Repeat
				
				$Obj_flow.indentation:=$Obj_flow.level
				$Obj_flow.level:=$Obj_flow.level+1
				
				$Obj_flow.value:=$tTxt_controlFlow{10}
				
				//______________________________________________________
			: (Match regex:C1019("(?m-si)^"+Command name:C538(948); $Txt_line; 1))  // Begin SQL
				
				$Obj_flow.indentation:=$Obj_flow.level
				$Obj_flow.level:=$Obj_flow.level+1
				
				$Obj_flow.value:=Command name:C538(948)
				
				//______________________________________________________
			: (Match regex:C1019("(?m-si)^"+$tTxt_controlFlow{12}+"\\W"; $Txt_line; 1))  // Use
				
				$Obj_flow.indentation:=$Obj_flow.level
				$Obj_flow.level:=$Obj_flow.level+1
				
				$Obj_flow.value:=$tTxt_controlFlow{12}
				
				//______________________________________________________
			: (Match regex:C1019("(?m-si)^"+$tTxt_controlFlow{3}; $Txt_line; 1))  // End if
				
				$Obj_flow.level:=$Obj_flow.level-1
				$Obj_flow.indentation:=$Obj_flow.level
				
				$Obj_flow.value:=$tTxt_controlFlow{3}
				
				//______________________________________________________
			: (Match regex:C1019("(?m-si)^"+$tTxt_controlFlow{5}; $Txt_line; 1))  // End case
				
				$Obj_flow.level:=$Obj_flow.level-1
				$Obj_flow.indentation:=$Obj_flow.level
				
				$Obj_flow.value:=$tTxt_controlFlow{5}
				$Obj_flow.caseOf:=Num:C11($Obj_flow.caseOf)-1
				
				//______________________________________________________
			: (Match regex:C1019("(?m-si)^"+$tTxt_controlFlow{15}; $Txt_line; 1))  // End for each
				
				$Obj_flow.level:=$Obj_flow.level-1
				$Obj_flow.indentation:=$Obj_flow.level
				
				$Obj_flow.value:=$tTxt_controlFlow{15}
				
				//______________________________________________________
			: (Match regex:C1019("(?m-si)^"+$tTxt_controlFlow{9}; $Txt_line; 1))  // End for
				
				$Obj_flow.level:=$Obj_flow.level-1
				$Obj_flow.indentation:=$Obj_flow.level
				
				$Obj_flow.value:=$tTxt_controlFlow{9}
				
				//______________________________________________________
			: (Match regex:C1019("(?m-si)^"+$tTxt_controlFlow{7}; $Txt_line; 1))  // End while
				
				$Obj_flow.level:=$Obj_flow.level-1
				$Obj_flow.indentation:=$Obj_flow.level
				
				$Obj_flow.value:=$tTxt_controlFlow{7}
				
				//______________________________________________________
			: (Match regex:C1019("(?m-si)^"+$tTxt_controlFlow{11}+"\\W"; $Txt_line; 1))  // Until
				
				$Obj_flow.level:=$Obj_flow.level-1
				$Obj_flow.indentation:=$Obj_flow.level
				
				$Obj_flow.value:=$tTxt_controlFlow{11}
				
				//______________________________________________________
			: (Match regex:C1019("(?m-si)^"+$tTxt_controlFlow{13}; $Txt_line; 1))  // End use
				
				$Obj_flow.level:=$Obj_flow.level-1
				$Obj_flow.indentation:=$Obj_flow.level
				
				$Obj_flow.value:=$tTxt_controlFlow{13}
				
				//______________________________________________________
			: (Match regex:C1019("(?m-si)^"+Command name:C538(949); $Txt_line; 1))  // End SQL
				
				$Obj_flow.level:=$Obj_flow.level-1
				$Obj_flow.indentation:=$Obj_flow.level
				
				$Obj_flow.value:=Command name:C538(949)
				
				//______________________________________________________
			Else 
				
				$Obj_flow.indentation:=$Obj_flow.level
				
				//______________________________________________________
		End case 
		
		If (Length:C16($Txt_line)>0)
			
			Case of 
					
					//______________________________________________________
				: ($Txt_line[[1]]=":")
					
					$Txt_line:=Insert string:C231($Txt_line; ($kTxt_tab*($Obj_flow.indentation+1)); 1)
					
					//______________________________________________________
				: ($Txt_line=("/"+"/@"))
					
					$Txt_line:=Insert string:C231($Txt_line; ($kTxt_tab*($Obj_flow.indentation+Num:C11($Obj_flow.caseOf)+1)); 1)
					
					//______________________________________________________
				Else 
					
					$Txt_line:=Insert string:C231($Txt_line; ($kTxt_tab*($Obj_flow.indentation+Num:C11($Obj_flow.caseOf))); 1)
					
					//______________________________________________________
			End case 
		End if 
		
		$Txt_code:=$Txt_code+$Txt_line+"\r"
		
	End for each 
	
	// Delete the last carriage return
	$Txt_code:=Delete string:C232($Txt_code; Length:C16($Txt_code); 1)
	
	$0:=$Txt_code
	
End if 