// ----------------------------------------------------
// Form method : keepIt
// Created 30/04/10 by Vincent de Lachaux
// ----------------------------------------------------
// Modified #21-9-2018 by Vincent de Lachaux
// Modernization
// ----------------------------------------------------
// Declarations
C_LONGINT:C283($Lon_fontSize)
C_TEXT:C284($Txt_action)
C_OBJECT:C1216($Obj_form)

// ----------------------------------------------------
// Initialisations
If (Form:C1466.definition=Null:C1517)
	
	// Form definition
	Form:C1466.definition:=New object:C1471(\
		"list"; "snippetList"; \
		"name"; "name"; \
		"code"; "text"; \
		"zoom"; "zoom"; \
		"splitter"; "vSplitter"; \
		"separator"; "separator"; \
		"edit"; 2; \
		"copy"; 4; \
		"copy"; 5; \
		"paste"; 6; \
		"clear"; 7; \
		"selectAll"; 8)
	
	// Methods
	Form:C1466.save:=Formula:C1597(TEXT TO DOCUMENT:C1237(This:C1470.current.nativePath; This:C1470.current.code))
	Form:C1466.ask:=Formula:C1597(keepit_ask)
	Form:C1466.parameters:=Formula:C1597(keepit_session)
	Form:C1466.list:=Formula:C1597(keepit(New object:C1471("do"; "list")).data)
	
End if 

$Obj_form:=Form:C1466.definition
$Obj_form.event:=Form event code:C388
$Obj_form.focus:=OBJECT Get name:C1087(Object with focus:K67:3)

// ----------------------------------------------------
Case of 
		
		//______________________________________________________
	: ($Obj_form.event=On Load:K2:1)
		
		// #TURN_AROUND
		OBJECT SET SCROLLBAR:C843(*; $Obj_form.list; 0; 2)
		
		Form:C1466.snippets:=Form:C1466.list()
		
		// Font size {
		$Lon_fontSize:=Num:C11(Form:C1466.parameters(New object:C1471(\
			"key"; "fontSize")).value)
		
		If ($Lon_fontSize#0)
			
			OBJECT SET FONT SIZE:C165(*; $Obj_form.code; $Lon_fontSize)
			
		Else 
			
			$Lon_fontSize:=OBJECT Get font size:C1070(*; $Obj_form.code)
			
		End if 
		
		(OBJECT Get pointer:C1124(Object named:K67:5; $Obj_form.zoom))->:=$Lon_fontSize
		//}
		
		GOTO OBJECT:C206(*; $Obj_form.list)
		
		SET TIMER:C645(-1)
		
		//______________________________________________________
	: ($Obj_form.event=On Unload:K2:2)
		
		// Save font size
		Form:C1466.parameters(New object:C1471(\
			"set"; True:C214; \
			"key"; "fontSize"; \
			"value"; (OBJECT Get pointer:C1124(Object named:K67:5; "zoom"))->))
		
		//______________________________________________________
	: ($Obj_form.event=On Activate:K2:9)
		
		// Update list
		// Form.snippets:=Form.list()
		
		//______________________________________________________
	: ($Obj_form.event=On Menu Selected:K2:14)
		
		$Txt_action:=Get selected menu item parameter:C1005
		
		Case of 
				
				//………………………………………………………………………………………………………………………………………
			: ($Txt_action="close")
				
				GOTO OBJECT:C206(*; "")
				CANCEL:C270
				
				//………………………………………………………………………………………………………………………………………
			: ($Txt_action="save")
				
				Form:C1466.save()
				
				//………………………………………………………………………………………………………………………………………
		End case 
		
		//______________________________________________________
	: ($Obj_form.event=On Timer:K2:25)
		
		SET TIMER:C645(0)
		
		Case of 
				
				//………………………………………………………………………………………………………………………………………
			: ($Obj_form.focus=$Obj_form.list)
				
				// Install special copy and paste {
				SET MENU ITEM PROPERTY:C973($Obj_form.edit; $Obj_form.copy; Associated standard action name:K28:8; ak none:K76:35)
				SET MENU ITEM METHOD:C982($Obj_form.edit; $Obj_form.copy; "menu_COPY")
				
				SET MENU ITEM PROPERTY:C973($Obj_form.edit; $Obj_form.paste; Associated standard action name:K28:8; ak none:K76:35)
				SET MENU ITEM METHOD:C982($Obj_form.edit; $Obj_form.paste; "menu_PAST")
				DISABLE MENU ITEM:C150(2; $Obj_form.paste)
				//}
				
				SET MENU ITEM PROPERTY:C973($Obj_form.edit; $Obj_form.selectAll; Associated standard action name:K28:8; ak none:K76:35)
				DISABLE MENU ITEM:C150($Obj_form.edit; $Obj_form.selectAll)
				
				If (Form:C1466.current#Null:C1517)
					
					ENABLE MENU ITEM:C149($Obj_form.edit; $Obj_form.copy)
					ENABLE MENU ITEM:C149($Obj_form.edit; $Obj_form.clear)
					
				Else 
					
					DISABLE MENU ITEM:C150($Obj_form.edit; $Obj_form.copy)
					DISABLE MENU ITEM:C150($Obj_form.edit; $Obj_form.clear)
					
				End if 
				
				//………………………………………………………………………………………………………………………………………
			: ($Obj_form.focus=$Obj_form.code)
				
				// Restore standard copy and paste
				SET MENU ITEM PROPERTY:C973($Obj_form.edit; $Obj_form.copy; Associated standard action name:K28:8; ak copy:K76:54)
				SET MENU ITEM METHOD:C982($Obj_form.edit; $Obj_form.copy; "")
				
				SET MENU ITEM PROPERTY:C973($Obj_form.edit; $Obj_form.paste; Associated standard action name:K28:8; ak paste:K76:55)
				SET MENU ITEM METHOD:C982($Obj_form.edit; $Obj_form.paste; "")
				
				SET MENU ITEM PROPERTY:C973($Obj_form.edit; $Obj_form.selectAll; Associated standard action name:K28:8; ak select all:K76:57)
				ENABLE MENU ITEM:C149($Obj_form.edit; $Obj_form.selectAll)
				
				//………………………………………………………………………………………………………………………………………
		End case 
		
		If (Form:C1466.current#Null:C1517)
			
			OBJECT SET ENABLED:C1123(*; "header.button.@"; True:C214)
			OBJECT SET VISIBLE:C603(*; $Obj_form.code; True:C214)
			
		Else 
			
			OBJECT SET ENABLED:C1123(*; "header.button.@"; False:C215)
			OBJECT SET VISIBLE:C603(*; $Obj_form.code; False:C215)
			
		End if 
		
		//______________________________________________________
End case 