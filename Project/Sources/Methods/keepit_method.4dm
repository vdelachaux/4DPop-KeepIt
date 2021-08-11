//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : keepit_method
// ID[FFFA0EE535B14A178F8EB7C772140745]
// Created 03/05/10 by Vincent de Lachaux
// ----------------------------------------------------
// Modified #20-9-2018 by Vincent de Lachaux
// Modernization
// ----------------------------------------------------
// Declarations
C_TEXT:C284($0)
C_TEXT:C284($1)

C_LONGINT:C283($Lon_parameters)
C_TEXT:C284($Txt_code; $Txt_methodName; $Txt_result)
C_COLLECTION:C1488($Col_parametters)

If (False:C215)
	C_TEXT:C284(keepit_method; $0)
	C_TEXT:C284(keepit_method; $1)
End if 

// ----------------------------------------------------
// Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1))
	
	$Txt_code:=$1
	
End if 

// ----------------------------------------------------
If (Asserted:C1132(Length:C16($Txt_code)>0; "The method name is mandatory"))
	
	ARRAY TEXT:C222($tTxt_; 0x0000)
	Rgx_MatchText("(?m-si)^([^(\\s]+)(?:\\s*\\(([^\\)]+)\\))?$"; $Txt_code; ->$tTxt_)
	
	If (Asserted:C1132(Size of array:C274($tTxt_)>0; "The method name is mandatory"))
		
		$Txt_methodName:=$tTxt_{1}
		
		If (Asserted:C1132(Length:C16($Txt_methodName)>0; "The method name is mandatory"))
			
			If (Length:C16($tTxt_{2})>0)
				
				$Col_parametters:=Split string:C1554(Replace string:C233($tTxt_{2}; "\""; ""); ";")
				
				If (Asserted:C1132($Col_parametters.length<=10; "The number of parameters must not exceed 10"))
					
					Case of 
							
							//______________________________________________________
						: ($Col_parametters.length=0)
							
							EXECUTE METHOD:C1007($Txt_methodName; $Txt_result)
							
							//______________________________________________________
						: ($Col_parametters.length=1)
							
							EXECUTE METHOD:C1007($Txt_methodName; $Txt_result; $Col_parametters[0])
							
							//______________________________________________________
						: ($Col_parametters.length=2)
							
							EXECUTE METHOD:C1007($Txt_methodName; $Txt_result; $Col_parametters[0]; $Col_parametters[1])
							
							//______________________________________________________
						: ($Col_parametters.length=3)
							
							EXECUTE METHOD:C1007($Txt_methodName; $Txt_result; $Col_parametters[0]; $Col_parametters[1]; $Col_parametters[2])
							
							//______________________________________________________
						: ($Col_parametters.length=4)
							
							EXECUTE METHOD:C1007($Txt_methodName; $Txt_result; $Col_parametters[0]; $Col_parametters[1]; $Col_parametters[2]; $Col_parametters[3])
							
							//______________________________________________________
						: ($Col_parametters.length=5)
							
							EXECUTE METHOD:C1007($Txt_methodName; $Txt_result; $Col_parametters[0]; $Col_parametters[1]; $Col_parametters[2]; $Col_parametters[3]; $Col_parametters[4])
							
							//______________________________________________________
						: ($Col_parametters.length=6)
							
							EXECUTE METHOD:C1007($Txt_methodName; $Txt_result; $Col_parametters[0]; $Col_parametters[1]; $Col_parametters[2]; $Col_parametters[3]; $Col_parametters[4]; $Col_parametters[5])
							
							//______________________________________________________
						: ($Col_parametters.length=7)
							
							EXECUTE METHOD:C1007($Txt_methodName; $Txt_result; $Col_parametters[0]; $Col_parametters[1]; $Col_parametters[2]; $Col_parametters[3]; $Col_parametters[4]; $Col_parametters[5]; $Col_parametters[6])
							
							//______________________________________________________
						: ($Col_parametters.length=8)
							
							EXECUTE METHOD:C1007($Txt_methodName; $Txt_result; $Col_parametters[0]; $Col_parametters[1]; $Col_parametters[2]; $Col_parametters[3]; $Col_parametters[4]; $Col_parametters[5]; $Col_parametters[6]; $Col_parametters[7])
							
							//______________________________________________________
						: ($Col_parametters.length=9)
							
							EXECUTE METHOD:C1007($Txt_methodName; $Txt_result; $Col_parametters[0]; $Col_parametters[1]; $Col_parametters[2]; $Col_parametters[3]; $Col_parametters[4]; $Col_parametters[5]; $Col_parametters[6]; $Col_parametters[7]; $Col_parametters[8])
							
							//______________________________________________________
						: ($Col_parametters.length=10)
							
							EXECUTE METHOD:C1007($Txt_methodName; $Txt_result; $Col_parametters[0]; $Col_parametters[1]; $Col_parametters[2]; $Col_parametters[3]; $Col_parametters[4]; $Col_parametters[5]; $Col_parametters[6]; $Col_parametters[7]; $Col_parametters[8]; $Col_parametters[9])
							
							//______________________________________________________
					End case 
				End if 
			End if 
			
		Else 
			
			EXECUTE METHOD:C1007($Txt_code; $Txt_result)
			
		End if 
		
	End if 
End if 

// ----------------------------------------------------
// Return
$0:=$Txt_result

// ----------------------------------------------------
// End