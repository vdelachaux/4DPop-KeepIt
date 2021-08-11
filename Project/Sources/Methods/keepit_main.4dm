//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : keepit.main
// ID[A456C8258FD1488F8004C59BE0F6201C]
// Created 30/04/10 by Vincent de Lachaux
// ----------------------------------------------------
// Description
// Main method to run the keepIt dialog
// ----------------------------------------------------
// Declarations
C_BOOLEAN:C305($0)
C_TEXT:C284($1)

C_LONGINT:C283($Lon_parameters; $Win_main)
C_TEXT:C284($File_; $Mnu_bar; $Mnu_edit; $Mnu_file; $Txt_code; $Txt_entryPoint)
C_TEXT:C284($Txt_name)

If (False:C215)
	C_BOOLEAN:C305(keepit_main; $0)
	C_TEXT:C284(keepit_main; $1)
End if 

// ----------------------------------------------------
// Initialisations
$Lon_parameters:=Count parameters:C259

// ----------------------------------------------------
If ($Lon_parameters>=1)
	
	$Txt_entryPoint:=$1
	
End if 

Case of 
		
		//===========================================================================
	: (Length:C16($Txt_entryPoint)=0)
		
		Case of 
				
				//_______________________________________________________________
			: (Method called on error:C704=Current method name:C684)
				
				//_______________________________________________________________
			Else 
				
				// This method must be executed in a new process
				BRING TO FRONT:C326(New process:C317(Current method name:C684; 0; "$4DPop KeepIt"; "_run"; *))
				
				//_______________________________________________________________
		End case 
		
		//===========================================================================
	: ($Txt_entryPoint="onDrop")
		
		$File_:=Get file from pasteboard:C976(1)
		
		If (OK=1)
			
			// Drag & drop of a file
			$Txt_code:=Document to text:C1236($File_)
			
			// Get the document name
			$Txt_name:=Path to object:C1547($File_).name
			
		Else 
			
			// Drag & drop of text
			$Txt_code:=Get text from pasteboard:C524
			
		End if 
		
		If (Bool:C1537(OK))
			
			keepit(New object:C1471(\
				"do"; "new"; \
				"code"; $Txt_code; \
				"name"; $Txt_name))
			
		End if 
		
		//===========================================================================================================
	: ($Txt_entryPoint="_run")
		
		// First launch of this method executed in a new process
		keepit_main("_declarations")
		
		keepit_main("_init")
		
		$Win_main:=Open form window:C675("KEEPIT"; Plain form window:K39:10; Horizontally centered:K39:1; Vertically centered:K39:4; *)
		
		DIALOG:C40("KEEPIT")
		CLOSE WINDOW:C154
		
		keepit_main("_deinit")
		
		//===========================================================================
	: ($Txt_entryPoint="_declarations")
		
		COMPILER_component
		
		keepit_update
		
		//===========================================================================
	: ($Txt_entryPoint="_init")
		
		// Install the menu bar
		$Mnu_file:=Create menu:C408
		
		APPEND MENU ITEM:C411($Mnu_file; ":xliff:CommonClose")
		SET MENU ITEM PARAMETER:C1004($Mnu_file; -1; "close")
		
		$Mnu_edit:=Create menu:C408
		
		APPEND MENU ITEM:C411($Mnu_edit; ":xliff:CommonMenuItemUndo")
		SET MENU ITEM PROPERTY:C973($Mnu_edit; -1; Associated standard action name:K28:8; ak undo:K76:51)
		SET MENU ITEM SHORTCUT:C423($Mnu_edit; -1; "Z"; Command key mask:K16:1)
		
		APPEND MENU ITEM:C411($Mnu_edit; ":xliff:CommonMenuRedo")
		SET MENU ITEM PROPERTY:C973($Mnu_edit; -1; Associated standard action name:K28:8; ak redo:K76:52)
		SET MENU ITEM SHORTCUT:C423($Mnu_edit; -1; "Z"; Shift key mask:K16:3)
		
		APPEND MENU ITEM:C411($Mnu_edit; "-")
		
		APPEND MENU ITEM:C411($Mnu_edit; ":xliff:CommonMenuItemCut")
		SET MENU ITEM PROPERTY:C973($Mnu_edit; -1; Associated standard action name:K28:8; ak cut:K76:53)
		SET MENU ITEM SHORTCUT:C423($Mnu_edit; -1; "X"; Command key mask:K16:1)
		
		APPEND MENU ITEM:C411($Mnu_edit; ":xliff:CommonMenuItemCopy")
		SET MENU ITEM PROPERTY:C973($Mnu_edit; -1; Associated standard action name:K28:8; ak copy:K76:54)
		SET MENU ITEM SHORTCUT:C423($Mnu_edit; -1; "C"; Command key mask:K16:1)
		
		APPEND MENU ITEM:C411($Mnu_edit; ":xliff:CommonMenuItemPaste")
		SET MENU ITEM PROPERTY:C973($Mnu_edit; -1; Associated standard action name:K28:8; ak paste:K76:55)
		SET MENU ITEM SHORTCUT:C423($Mnu_edit; -1; "V"; Command key mask:K16:1)
		
		APPEND MENU ITEM:C411($Mnu_edit; ":xliff:CommonMenuItemClear")
		SET MENU ITEM PROPERTY:C973($Mnu_edit; -1; Associated standard action name:K28:8; ak clear:K76:56)
		
		APPEND MENU ITEM:C411($Mnu_edit; ":xliff:CommonMenuItemSelectAll")
		SET MENU ITEM PROPERTY:C973($Mnu_edit; -1; Associated standard action name:K28:8; ak select all:K76:57)
		SET MENU ITEM SHORTCUT:C423($Mnu_edit; -1; "A"; Command key mask:K16:1)
		
		APPEND MENU ITEM:C411($Mnu_edit; "(-")
		
		APPEND MENU ITEM:C411($Mnu_edit; ":xliff:CommonMenuItemShowClipboard")
		SET MENU ITEM PROPERTY:C973($Mnu_edit; -1; Associated standard action name:K28:8; ak show clipboard:K76:58)
		
		$Mnu_bar:=Create menu:C408
		
		APPEND MENU ITEM:C411($Mnu_bar; ":xliff:CommonMenuFile"; $Mnu_file)
		RELEASE MENU:C978($Mnu_file)
		
		APPEND MENU ITEM:C411($Mnu_bar; ":xliff:CommonMenuEdit"; $Mnu_edit)
		RELEASE MENU:C978($Mnu_edit)
		
		SET MENU BAR:C67($Mnu_bar)
		RELEASE MENU:C978($Mnu_bar)
		
		//===========================================================================
	: ($Txt_entryPoint="_deinit")
		
		//
		
		//===========================================================================
	Else 
		
		TRACE:C157
		
		//===========================================================================
End case 