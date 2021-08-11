// ----------------------------------------------------
// Form method : ASK
// Created 12/11/10 by Vincent de Lachaux
// ----------------------------------------------------
// Declarations
C_LONGINT:C283($Lon_formEvent; $Lon_i; $Lon_j; $Lon_page; $Lon_x; $Lst_fields)
C_POINTER:C301($Ptr_list)
C_TEXT:C284($Txt_buffer; $Txt_table; $Txt_type)

ARRAY LONGINT:C221($tLon_buffer; 0)

// ----------------------------------------------------
// Initialisations
$Lon_formEvent:=Form event code:C388

// ----------------------------------------------------

Case of 
		
		//______________________________________________________
	: ($Lon_formEvent=On Load:K2:1)
		
		//$Dom_buffer:=DOM Find XML element by ID(<>Dom_parameters;"question")
		// If (OK=1)
		//DOM GET XML ELEMENT VALUE($Dom_buffer;(OBJECT Get pointer(Object named;"question"))->)
		// End if
		//$Dom_buffer:=DOM Find XML element by ID(<>Dom_parameters;"type")
		// If (OK=1)
		//DOM GET XML ELEMENT VALUE($Dom_buffer;$Txt_type)
		// End if
		
		$Txt_type:=Form:C1466.type
		
		$Ptr_list:=OBJECT Get pointer:C1124(Object named:K67:5; "list")
		$Ptr_list->:=New list:C375
		
		Case of 
				
				//…………………………………………
			: ($Txt_type="text")
				
				OBJECT SET FILTER:C235(*; "txt.box"; "")
				FORM GOTO PAGE:C247(1)
				
				//…………………………………………
			: ($Txt_type="integer")
				
				OBJECT SET FILTER:C235(*; "txt.box"; "|integer")
				FORM GOTO PAGE:C247(1)
				
				//…………………………………………
			: ($Txt_type="real")
				
				OBJECT SET FILTER:C235(*; "txt.box"; "|real")
				FORM GOTO PAGE:C247(1)
				
				//…………………………………………
			: ($Txt_type="table")
				
				//<>Lst_buffer:=New list
				
				For ($Lon_i; 1; Get last table number:C254; 1)
					
					If (Is table number valid:C999($Lon_i))
						
						$Txt_buffer:="["+Table name:C256($Lon_i)+"]"
						
						$Lon_x:=$Lon_x+1
						
						//APPEND TO LIST(<>Lst_buffer;$Txt_buffer;$Lon_x)
						//SET LIST ITEM PARAMETER(<>Lst_buffer;$Lon_x;"value";$Txt_buffer)
						APPEND TO LIST:C376($Ptr_list->; $Txt_buffer; $Lon_x)
						SET LIST ITEM PARAMETER:C986($Ptr_list->; $Lon_x; "value"; $Txt_buffer)
						
					End if 
				End for 
				
				FORM GOTO PAGE:C247(2)
				
				//…………………………………………
			: ($Txt_type="field")
				
				//<>Lst_buffer:=New list
				
				For ($Lon_i; 1; Get last table number:C254; 1)
					
					If (Is table number valid:C999($Lon_i))
						
						$Txt_table:="["+Table name:C256($Lon_i)+"]"
						$Lst_fields:=New list:C375
						
						For ($Lon_j; 1; Get last field number:C255($Lon_i); 1)
							
							If (Is field number valid:C1000($Lon_i; $Lon_j))
								
								$Lon_x:=$Lon_x+1
								$Txt_buffer:=Field name:C257($Lon_i; $Lon_j)
								APPEND TO LIST:C376($Lst_fields; $Txt_buffer; $Lon_x)
								SET LIST ITEM PARAMETER:C986($Lst_fields; $Lon_x; "value"; $Txt_table+$Txt_buffer)
								
							End if 
						End for 
						
						$Lon_x:=$Lon_x+1
						
						//APPEND TO LIST(<>Lst_buffer;$Txt_table;$Lon_x;$Lst_fields;True)
						APPEND TO LIST:C376($Ptr_list->; $Txt_table; $Lon_x; $Lst_fields; True:C214)
						
					End if 
				End for 
				
				FORM GOTO PAGE:C247(2)
				
				//…………………………………………
			: ($Txt_type="user")\
				 | ($Txt_type="group")
				
				//<>Lst_buffer:=New list
				
				If ($Txt_type="user")
					
					GET USER LIST:C609($tTxt_buffer; $tLon_buffer)
					
				Else 
					
					GET GROUP LIST:C610($tTxt_buffer; $tLon_buffer)
					
				End if 
				
				For ($Lon_i; 1; Size of array:C274($tTxt_buffer); 1)
					
					//APPEND TO LIST(<>Lst_buffer;$tTxt_buffer{$Lon_i};$Lon_i)
					//SET LIST ITEM PARAMETER(<>Lst_buffer;$Lon_i;"value";$tTxt_buffer{$Lon_i})
					APPEND TO LIST:C376($Ptr_list->; $tTxt_buffer{$Lon_i}; $Lon_i)
					SET LIST ITEM PARAMETER:C986($Ptr_list->; $Lon_i; "value"; $tTxt_buffer{$Lon_i})
					
				End for 
				
				FORM GOTO PAGE:C247(2)
				
				//…………………………………………
			: ($Txt_type="{@}")  // User list
				
				$Txt_type:=Delete string:C232($Txt_type; 1; 1)
				$Txt_type:=Delete string:C232($Txt_type; Length:C16($Txt_type); 1)
				
				ARRAY TEXT:C222($tTxt_buffer; 0x0000)
				
				If (Rgx_SplitText(";"; $Txt_type; ->$tTxt_buffer; 0)=0)
					
					//<>Lst_buffer:=New list
					
					For ($Lon_i; 1; Size of array:C274($tTxt_buffer); 1)
						
						$Txt_buffer:=$tTxt_buffer{$Lon_i}
						$Lon_x:=Position:C15(":"; $Txt_buffer)
						
						//If ($Lon_x>0)  //     Label:value
						//APPEND TO LIST(<>Lst_buffer;Substring($Txt_buffer;1;$Lon_x-1);$Lon_i)
						//SET LIST ITEM PARAMETER(<>Lst_buffer;$Lon_i;"value";Substring($Txt_buffer;$Lon_x+1))
						//Else   //     Label is value
						//APPEND TO LIST(<>Lst_buffer;$Txt_buffer;$Lon_i)
						//SET LIST ITEM PARAMETER(<>Lst_buffer;$Lon_i;"value";$Txt_buffer)
						// End if
						
						If ($Lon_x>0)  // Label:value
							
							APPEND TO LIST:C376($Ptr_list->; Substring:C12($Txt_buffer; 1; $Lon_x-1); $Lon_i)
							SET LIST ITEM PARAMETER:C986($Ptr_list->; $Lon_i; "value"; Substring:C12($Txt_buffer; $Lon_x+1))
							
						Else   // Label is value
							
							APPEND TO LIST:C376($Ptr_list->; $Txt_buffer; $Lon_i)
							SET LIST ITEM PARAMETER:C986($Ptr_list->; $Lon_i; "value"; $Txt_buffer)
							
						End if 
					End for 
				End if 
				
				FORM GOTO PAGE:C247(2)
				
				//…………………………………………
			Else 
				
				FORM GOTO PAGE:C247(1)
				
				//…………………………………………
		End case 
		
		SET TIMER:C645(-1)
		
		//______________________________________________________
	: ($Lon_formEvent=On Page Change:K2:54)
		
		$Lon_page:=FORM Get current page:C276
		
		Case of 
				
				//…………………………………………
			: ($Lon_page=1)
				
				GOTO OBJECT:C206(*; "txt.box")
				
				//…………………………………………
			: ($Lon_page=2)
				
				// If (Selected list items(<>Lst_buffer)<=0)|(Selected list items(<>Lst_buffer)>Count list items(<>Lst_buffer))
				// SELECT LIST ITEMS BY POSITION(<>Lst_buffer;1)
				// GOTO OBJECT(*;"list")
				// End if
				
				$Ptr_list:=OBJECT Get pointer:C1124(Object named:K67:5; "list")
				
				If (Selected list items:C379($Ptr_list->)<=0)\
					 | (Selected list items:C379($Ptr_list->)>Count list items:C380($Ptr_list->))
					
					SELECT LIST ITEMS BY POSITION:C381($Ptr_list->; 1)
					
					GOTO OBJECT:C206(*; "list")
					
				End if 
				
				//…………………………………………
		End case 
		
		//______________________________________________________
	: ($Lon_formEvent=On Unload:K2:2)
		
		// CLEAR LIST(<>Lst_buffer;*)
		CLEAR LIST:C377((OBJECT Get pointer:C1124(Object named:K67:5; "list"))->; *)
		
		//______________________________________________________
	: ($Lon_formEvent=On Validate:K2:3)
		
		$Lon_page:=FORM Get current page:C276
		
		Case of 
				
				//…………………………………………
				//: ($Lon_page=1)  //textbox
				// DOM SET XML ELEMENT VALUE(DOM Create XML element(<>Dom_parameters;"parameter";\
					"id";"result");\
					(OBJECT Get pointer(Object named;"txt.box"))->)
				
				//…………………………………………
			: ($Lon_page=2)  // table / field / list
				
				//GET LIST ITEM PARAMETER(<>Lst_buffer;*;"value";$Txt_buffer)
				// DOM SET XML ELEMENT VALUE(DOM Create XML element(<>Dom_parameters;"parameter";\
					"id";"result");\
					$Txt_buffer)
				
				GET LIST ITEM PARAMETER:C985(*; "list"; *; "value"; $Txt_buffer)
				Form:C1466.result:=$Txt_buffer
				
				//…………………………………………
		End case 
		
		//______________________________________________________
	: ($Lon_formEvent=On Timer:K2:25)
		
		SET TIMER:C645(0)
		
		//______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215; "Form event activated unnecessarily")
		
		//______________________________________________________
End case 