// ----------------------------------------------------
// Object method : KEEPIT.List Box - (4DPop KeepIt)
// ID[056303A802924609ADBCC8288666C163]
// Created #5-7-2018 by Vincent de Lachaux
// ----------------------------------------------------
// Declarations
C_LONGINT:C283($Lon_; $Lon_x; $Lon_y)
C_TEXT:C284($Mnu_choice; $Mnu_main; $Txt_buffer; $Txt_path; $Txt_tips)
C_OBJECT:C1216($Obj_form; $Obj_infos; $Obj_path)
C_COLLECTION:C1488($Col_code)

// ----------------------------------------------------
// Initialisations
$Obj_form:=Form:C1466.definition
$Obj_form.event:=Form event code:C388
$Obj_form.current:=OBJECT Get name:C1087(Object current:K67:2)

// ----------------------------------------------------
Case of 
		
		//______________________________________________________
	: ($Obj_form.event=On Selection Change:K2:29)
		
		OBJECT SET SCROLLBAR:C843(*; $Obj_form.code; False:C215; False:C215)
		
		If (Form:C1466.selected.length>0)
			
			Form:C1466.current.code:=Document to text:C1236(Form:C1466.selected[0].nativePath)
			
		End if 
		
		OBJECT SET SCROLLBAR:C843(*; $Obj_form.code; True:C214; True:C214)
		
		SET TIMER:C645(-1)  // Update UI
		
		//______________________________________________________
	: ($Obj_form.event=On Double Clicked:K2:5)
		
		OBJECT SET ENTERABLE:C238(*; "name"; True:C214)
		EDIT ITEM:C870(*; "name"; Form:C1466.index)
		
		//______________________________________________________
	: ($Obj_form.event=On Clicked:K2:4)
		
		If (Contextual click:C713)
			
			If (Form:C1466.current#Null:C1517)
				
				$Mnu_main:=Create menu:C408
				
				APPEND MENU ITEM:C411($Mnu_main; ":xliff:tokenize")
				SET MENU ITEM PARAMETER:C1004($Mnu_main; -1; "tokenize")
				
				APPEND MENU ITEM:C411($Mnu_main; ":xliff:indent")
				SET MENU ITEM PARAMETER:C1004($Mnu_main; -1; "indent")
				
				APPEND MENU ITEM:C411($Mnu_main; "-")
				
				APPEND MENU ITEM:C411($Mnu_main; ":xliff:CommonMenuItemClear")
				SET MENU ITEM PARAMETER:C1004($Mnu_main; -1; "delete")
				
				APPEND MENU ITEM:C411($Mnu_main; "-")
				
				APPEND MENU ITEM:C411($Mnu_main; ":xliff:CommonMenuItemCopy")
				SET MENU ITEM PARAMETER:C1004($Mnu_main; -1; "copy")
				
				APPEND MENU ITEM:C411($Mnu_main; "-")
				
				APPEND MENU ITEM:C411($Mnu_main; ":xliff:ShowOnDisk")
				SET MENU ITEM PARAMETER:C1004($Mnu_main; -1; "reveal")
				
			End if 
			
			$Mnu_choice:=Dynamic pop up menu:C1006($Mnu_main; "")
			RELEASE MENU:C978($Mnu_main)
			
			Case of 
					
					//…………………………………………………………………………
				: (Length:C16($Mnu_choice)=0)
					
					//…………………………………………………………………………
				: ($Mnu_choice="delete")
					
					CONFIRM:C162(Get localized string:C991("areYouSureYouWantToDeleteThisItem"))
					
					If (Bool:C1537(OK))
						
						DELETE DOCUMENT:C159(Form:C1466.current.nativePath)
						
					End if 
					
					Form:C1466.snippets:=Form:C1466.list()
					
					//…………………………………………………………………………
				: ($Mnu_choice="rename")
					
					OBJECT SET ENTERABLE:C238(*; "name"; True:C214)
					Form:C1466.old:=Form:C1466.current
					EDIT ITEM:C870(*; "name"; Form:C1466.index)
					
					//…………………………………………………………………………
				: ($Mnu_choice="tokenize")
					
					Form:C1466.current.code:=keepit(New object:C1471("do"; "tokenize"; "code"; Form:C1466.current.code)).code
					Form:C1466.save()
					
					SET TIMER:C645(-1)
					
					//…………………………………………………………………………
				: ($Mnu_choice="indent")
					
					Form:C1466.current.code:=keepit(New object:C1471("do"; "indent"; "code"; Form:C1466.current.code)).code
					Form:C1466.save()
					
					SET TIMER:C645(-1)
					
					//…………………………………………………………………………
				: ($Mnu_choice="reveal")
					
					SHOW ON DISK:C922(Form:C1466.current.nativePath)
					
					//…………………………………………………………………………
				: ($Mnu_choice="copy")
					
					menu_COPY
					
					//…………………………………………………………………………
				Else 
					
					TRACE:C157
					
					//…………………………………………………………………………
			End case 
		End if 
		
		//______________________________________________________
	: ($Obj_form.event=On Before Data Entry:K2:39)
		
		// Allow standard copy and paste
		SET MENU ITEM PROPERTY:C973(2; $Obj_form.copy; Associated standard action name:K28:8; ak copy:K76:54)
		SET MENU ITEM METHOD:C982(2; $Obj_form.copy; "")
		
		SET MENU ITEM PROPERTY:C973(2; $Obj_form.paste; Associated standard action name:K28:8; ak paste:K76:55)
		SET MENU ITEM METHOD:C982(2; $Obj_form.paste; "")
		
		//______________________________________________________
	: ($Obj_form.event=On Mouse Move:K2:35)
		
		// Display tips
		If (Parse formula:C1576(":C1569")#":C1569")
			
			GET MOUSE:C468($Lon_x; $Lon_y; $Lon_)
			EXECUTE FORMULA:C63("$Obj_infos:=:C1569(*; $Obj_form.current; $Lon_x; $Lon_y)")
			
			If ($Obj_infos.element#Null:C1517)
				
				$Txt_tips:=String:C10($Obj_infos.element.code)
				
				ARRAY TEXT:C222($tTxt_extracted; 0x0000)
				
				If (Rgx_ExtractText("/\\*([^\\*]*)\\*/"; $Txt_tips; "1"; ->$tTxt_extracted)=0)
					
					// First comment as tip
					$Txt_tips:=$tTxt_extracted{1}
					
				Else 
					
					// Display the item's content without the attribute line
					$Col_code:=Split string:C1554($Txt_tips; "\r")
					
					If ($Col_code.length>0)
						
						If ($Col_code[0]="%attributes = @")
							
							$Txt_tips:=$Col_code.remove(0).join("\r")
							
						End if 
					End if 
				End if 
			End if 
		End if 
		
		OBJECT SET HELP TIP:C1181(*; $Obj_form.current; $Txt_tips)
		
		//______________________________________________________
	: ($Obj_form.event=On Mouse Leave:K2:34)
		
		OBJECT SET HELP TIP:C1181(*; $Obj_form.current; "")
		
		//______________________________________________________
	: ($Obj_form.event=On Begin Drag Over:K2:44)
		
		If (Form:C1466.current#Null:C1517)
			
			If (Macintosh option down:C545 | Windows Alt down:C563)
				
				// Export as a file
				$Txt_buffer:=Form:C1466.current.name
				
				$Lon_x:=Position:C15("/"; $Txt_buffer)
				
				If ($Lon_x>0)
					
					$Txt_buffer:=Substring:C12($Txt_buffer; 1; $Lon_x-1)
					
				End if 
				
				$Txt_path:=Temporary folder:C486+$Txt_buffer+".txt"
				
				TEXT TO DOCUMENT:C1237($Txt_path; Form:C1466.current.code)
				SET FILE TO PASTEBOARD:C975($Txt_path)
				
			Else 
				
				// Put as text in the pasteboard
				SET TEXT TO PASTEBOARD:C523(keepit(New object:C1471(\
					"do"; "processing"; \
					"code"; Form:C1466.current.code)).code)
				
			End if 
		End if 
		
		//______________________________________________________
	: ($Obj_form.event=On Losing Focus:K2:8)
		
		OBJECT SET ENTERABLE:C238(*; "name"; False:C215)
		
		If (Form:C1466.selected.length>0)
			
			$Obj_path:=Path to object:C1547(Form:C1466.current.nativePath)
			
			If ($Obj_path.name#Form:C1466.selected[0].name)
				
				$Obj_path.name:=Form:C1466.selected[0].name
				
				DELETE DOCUMENT:C159(Form:C1466.current.nativePath)
				
				Form:C1466.current.nativePath:=Object to path:C1548($Obj_path)
				Form:C1466.save()
				
			End if 
		End if 
		
		SET TIMER:C645(-1)
		
		//______________________________________________________
	: ($Obj_form.event=On Delete Action:K2:56)
		
		CONFIRM:C162(Get localized string:C991("areYouSureYouWantToDeleteThisItem"))
		
		If (Bool:C1537(OK))
			
			DELETE DOCUMENT:C159(Form:C1466.current.nativePath)
			
		End if 
		
		Form:C1466.snippets:=Form:C1466.list()
		
		//______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215; "Form event activated unnecessarily ("+String:C10($Obj_form.event)+")")
		
		//______________________________________________________
End case 