// ----------------------------------------------------
// Object method : keepIt.tags - (4DPop KeepIt)
// Created 21/09/12 by Vincent de Lachaux
// ----------------------------------------------------
// Declarations
C_BLOB:C604($Blb_data)
C_LONGINT:C283($Lon_bottom; $Lon_end; $Lon_height; $Lon_i; $Lon_left; $Lon_right)
C_LONGINT:C283($Lon_start; $Lon_top; $Lon_width; $Lon_x; $Win_hdl)
C_TEXT:C284($Mnu_sub; $Mnu_tag; $Txt_buffer; $Txt_path; $Txt_tag)
C_OBJECT:C1216($Obj_form; $Obj_params; $Obj_snippet; $Obj_tags)

// ----------------------------------------------------
// Initialisations
$Obj_form:=Form:C1466.definition
$Obj_form.event:=Form event code:C388
$Obj_form.current:=OBJECT Get name:C1087(Object current:K67:2)

// ----------------------------------------------------
Case of 
		
		//______________________________________________________
	: ($Obj_form.event=On Mouse Enter:K2:33)
		
		If (OBJECT Get enabled:C1079(*; $Obj_form.current))
			
			OBJECT SET FONT STYLE:C166(*; $Obj_form.current; Bold:K14:2)
			
		End if 
		
		//______________________________________________________
	: ($Obj_form.event=On Mouse Leave:K2:34)
		
		OBJECT SET FONT STYLE:C166(*; $Obj_form.current; Plain:K14:1)
		
		//______________________________________________________
	: ($Obj_form.event=On Clicked:K2:4)\
		 | ($Obj_form.event=On Alternative Click:K2:36)
		
		$Mnu_tag:=Create menu:C408
		
		For each ($Obj_tags; JSON Parse:C1218(Document to text:C1236(Get 4D folder:C485(Current resources folder:K5:16)+"editor.json")).tags)
			
			Case of 
					
					//______________________________________________________
				: ($Obj_tags.tag="<method></method>")
					
					$Mnu_sub:=Create menu:C408
					APPEND MENU ITEM:C411($Mnu_tag; ":xliff:"+$Obj_tags.label; $Mnu_sub)
					RELEASE MENU:C978($Mnu_sub)
					
					ARRAY TEXT:C222($tTxt_methods; 0x0000)
					METHOD GET NAMES:C1166($tTxt_methods; *)
					
					For ($Lon_i; 1; Size of array:C274($tTxt_methods); 1)
						
						$Txt_buffer:=$tTxt_methods{$Lon_i}
						
						If (METHOD Get attribute:C1169(METHOD Get path:C1164(Path project method:K72:1; $Txt_buffer; *); Attribute shared:K72:10; *))
							
							APPEND MENU ITEM:C411($Mnu_sub; $Txt_buffer)
							SET MENU ITEM PARAMETER:C1004($Mnu_sub; -1; Replace string:C233($Obj_tags.tag; "><"; ">"+$Txt_buffer+"<"))
							
						End if 
					End for 
					
					//______________________________________________________
				: ($Obj_tags.tag="<keepit name=\"\"/>")
					
					$Mnu_sub:=Create menu:C408
					APPEND MENU ITEM:C411($Mnu_tag; ":xliff:"+$Obj_tags.label; $Mnu_sub)
					RELEASE MENU:C978($Mnu_sub)
					
					For each ($Obj_snippet; Form:C1466.snippets)
						
						If ($Obj_snippet.path#Form:C1466.current.path)
							
							$Txt_buffer:=$Obj_snippet.name
							
							$Lon_x:=Position:C15("_"; $Txt_buffer)
							
							If ($Lon_x>0)
								
								$Txt_buffer:=Substring:C12($Txt_buffer; 1; $Lon_x-1)
								
							End if 
							
							APPEND MENU ITEM:C411($Mnu_sub; $Txt_buffer)
							SET MENU ITEM PARAMETER:C1004($Mnu_sub; -1; Replace string:C233($Obj_tags.tag; "\"\""; "\""+$Txt_buffer+"\""))
							
						End if 
					End for each 
					
					//______________________________________________________
				Else 
					
					If ($Obj_tags.label="-")
						
						APPEND MENU ITEM:C411($Mnu_tag; "-")
						
					Else 
						
						APPEND MENU ITEM:C411($Mnu_tag; ":xliff:"+$Obj_tags.label)
						SET MENU ITEM PARAMETER:C1004($Mnu_tag; -1; $Obj_tags.tag)
						
					End if 
					
					//______________________________________________________
			End case 
		End for each 
		
		$Txt_tag:=Dynamic pop up menu:C1006($Mnu_tag)
		RELEASE MENU:C978($Mnu_tag)
		
		If (Length:C16($Txt_tag)>0)
			
			GET HIGHLIGHT:C209(*; $Obj_form.code; $Lon_start; $Lon_end)
			
			Case of 
					
					//…………………………………………………………………………………
				: ($Txt_tag="<method>\"\"</method>")
					
					$Txt_buffer:=Substring:C12(Form:C1466.current.code; $Lon_start; $Lon_end-$Lon_start)
					$Txt_tag:=Replace string:C233($Txt_tag; "\"\""; $Txt_buffer)
					
					//…………………………………………………………………………………
				: ($Txt_tag="<keepit name=\"\"/>")
					
					ARRAY TEXT:C222($tTxt_signatures4D; 0x0000)
					ARRAY TEXT:C222($tTxt_typesNatifs; 0x0000)
					
					GET PASTEBOARD DATA TYPE:C958($tTxt_signatures4D; $tTxt_typesNatifs)
					
					If (Find in array:C230($tTxt_typesNatifs; "private.keepit.item")>0)
						
						GET PASTEBOARD DATA:C401("private.keepit.item"; $Blb_data)
						$Txt_buffer:=BLOB to text:C555($Blb_data; UTF8 text without length:K22:17)
						
						$Txt_tag:=$Txt_buffer
						
					End if 
					
					//…………………………………………………………………………………
				: ($Txt_tag="<ask @/>")
					
					If (Is macOS:C1572)
						
						$Win_hdl:=Open form window:C675("ask_template"; Sheet window:K34:15)
						
					Else 
						
						FORM GET PROPERTIES:C674("ask_template"; $Lon_width; $Lon_height)
						GET WINDOW RECT:C443($Lon_left; $Lon_top; $Lon_right; $Lon_bottom; Current form window:C827)
						$Lon_left:=($Lon_left+(($Lon_right-$Lon_left)/2))-($Lon_width/2)
						$Lon_top:=($Lon_top+40)
						$Lon_right:=$Lon_left+$Lon_width
						$Lon_bottom:=$Lon_top+$Lon_height
						
						$Win_hdl:=Open window:C153($Lon_left; $Lon_top; $Lon_right; $Lon_bottom; Pop up window:K34:14)
						
					End if 
					
					$Obj_params:=New object:C1471
					
					DIALOG:C40("ask_template"; $Obj_params)
					CLOSE WINDOW:C154
					
					$Txt_tag:=$Obj_params.tag*Num:C11(OK=1)
					
					//______________________________________________________
				: ($Txt_tag="<file @/>")
					
					$Txt_buffer:=Select document:C905(Get 4D folder:C485(Current resources folder:K5:16; *); "public.text;.txt"; ""; Use sheet window:K24:11+Package open:K24:8)
					
					If (OK=1)
						
						$Txt_path:=Convert path system to POSIX:C1106(DOCUMENT)
						$Txt_buffer:=Convert path system to POSIX:C1106(Get 4D folder:C485(Current resources folder:K5:16; *))
						
						If (Position:C15($Txt_buffer; $Txt_path)=1)
							
							$Txt_path:=Replace string:C233($Txt_path; $Txt_buffer; "#"; 1)
							
						Else 
							
							$Txt_buffer:=Convert path system to POSIX:C1106(Get 4D folder:C485(Current resources folder:K5:16))
							
							If (Position:C15($Txt_buffer; $Txt_path)=1)
								
								$Txt_path:=Replace string:C233($Txt_path; $Txt_buffer; "/"; 1)
								
							Else 
								
								// #TO_
								$Txt_path:="file://"+$Txt_path
								
							End if 
						End if 
						
						$Txt_tag:=Replace string:C233($Txt_tag; "\"\""; "\""+$Txt_path+"\"")
						
					Else 
						
						CLEAR VARIABLE:C89($Txt_tag)
						
					End if 
					
					//…………………………………………………………………………………
				: ($Txt_tag="<iteration count=@/>")
					
					$Txt_buffer:=Form:C1466.ask(Get localized string:C991("numberOfIterations"); "integer")
					
					If (Length:C16($Txt_buffer)>0)
						
						$Txt_tag:=Replace string:C233($Txt_tag; "%"; $Txt_buffer; 1)
						
					End if 
					
					//…………………………………………………………………………………
				: ($Txt_tag="<method-attribute @/>")
					
					For ($Lon_i; 1; 8; 1)
						
						If ($Lon_i#6)
							
							$Txt_buffer:=Choose:C955($Lon_i=1; "{"; $Txt_buffer+";")
							
							$Txt_buffer:=$Txt_buffer+Get localized string:C991("methodAttribute_"+String:C10($Lon_i))+":"+String:C10($Lon_i)
							
						End if 
					End for 
					
					$Txt_buffer:=$Txt_buffer+"}"
					
					$Txt_buffer:=Form:C1466.ask(Get localized string:C991("attributeToSet"); $Txt_buffer)
					
					If (Length:C16($Txt_buffer)>0)
						
						$Txt_tag:=Replace string:C233($Txt_tag; "%"; $Txt_buffer; 1)
						
					End if 
					
					//…………………………………………………………………………………
			End case 
			
			If (Length:C16($Txt_tag)>0)
				
				Form:C1466.current.code:=Substring:C12(Form:C1466.current.code; 1; $Lon_start-1)+$Txt_tag+Substring:C12(Form:C1466.current.code; $Lon_end; Length:C16(Form:C1466.current.code))
				
				Form:C1466.save()
				
				Form:C1466.current:=Form:C1466.current
				
				$Lon_x:=Position:C15("\"\""; $Txt_tag)
				
				If ($Lon_x>0)
					
					HIGHLIGHT TEXT:C210(*; $Obj_form.code; $Lon_start+$Lon_x; $Lon_start+$Lon_x)
					
				Else 
					
					HIGHLIGHT TEXT:C210(*; $Obj_form.code; $Lon_start+Length:C16($Txt_tag); $Lon_start+Length:C16($Txt_tag))
					
				End if 
			End if 
		End if 
		
		//______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215; "Unnecessarily activated form event")
		
		//______________________________________________________
End case 