//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : keepit
// Database: 4DPop KeepIt
// ID[EE860B1FF06F41D8811EA74BC228007B]
// Created #14-9-2018 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
//
// ----------------------------------------------------
// Declarations
C_OBJECT:C1216($0)
C_OBJECT:C1216($1)

C_BOOLEAN:C305($Boo_copy; $Boo_shortcut; $Boo_startCondition; $Boo_test; $Boo_value)
C_LONGINT:C283($Lon_; $Lon_count; $Lon_counter; $Lon_error; $Lon_i; $Lon_ii)
C_LONGINT:C283($Lon_index; $Lon_length; $Lon_methodType; $Lon_parameters; $Lon_start; $Lon_type)
C_LONGINT:C283($Lon_x; $Win_hdl)
C_POINTER:C301($Ptr_table; $Ptr_var)
C_TEXT:C284($File_resources; $File_target; $Mnu_main; $Txt_buffer; $Txt_choice; $Txt_code)
C_TEXT:C284($Txt_codeLang; $Txt_currentLang; $Txt_encoding; $Txt_form; $Txt_format; $Txt_formula)
C_TEXT:C284($Txt_line; $Txt_method; $Txt_methodPath; $Txt_modifier; $Txt_name; $Txt_object)
C_TEXT:C284($Txt_pattern; $Txt_question; $Txt_shortcut; $Txt_table; $Txt_type; $Txt_url)
C_TEXT:C284($Txt_value; $Txt_varName)
C_OBJECT:C1216($Obj_attribute; $Obj_controlFlow; $Obj_data; $Obj_folder; $Obj_in; $Obj_out)
C_OBJECT:C1216($Obj_snippet; $Obj_snippets)
C_COLLECTION:C1488($Col_code; $Col_lines; $Col_snippets)

ARRAY LONGINT:C221($tWin_; 0)
ARRAY TEXT:C222($tTxt_buffer; 0)
ARRAY TEXT:C222($tTxt_parameters; 0)

If (False:C215)
	C_OBJECT:C1216(_o_keepit; $0)
	C_OBJECT:C1216(_o_keepit; $1)
End if 

ARRAY TEXT:C222($tTxt_segments; 0x0000; 0x0000)

// ----------------------------------------------------
// Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1; "Missing parameter"))
	
	// Required parameters
	$Obj_in:=$1
	
	// Default values
	
	// Optional parameters
	If ($Lon_parameters>=2)
		
		// <NONE>
		
	End if 
	
	$Obj_out:=New object:C1471(\
		"success"; False:C215)
	
Else 
	
	ABORT:C156
	
End if 

// ----------------------------------------------------
Case of 
		
		//______________________________________________________
	: (String:C10($Obj_in.do)="")
		
		TRACE:C157
		
		//______________________________________________________
	: ($Obj_in.do="list")
		
		// Get current database snippets {
		$Obj_folder:=doc_Folder(Get 4D folder:C485(Database folder:K5:14; *)+"KEEPIT"+Folder separator:K24:12)
		
		If ($Obj_folder.exist)
			
			$Obj_out.success:=True:C214
			
			$Col_snippets:=$Obj_folder.files
			
			// Remove invisible files
			$Col_snippets:=$Col_snippets.query("name != .@")
			
			If (Bool:C1537($Obj_in.filtered))
				
				$Col_snippets:=$Col_snippets.query("name != _@")
				
			End if 
			
			$Col_snippets:=$Col_snippets.orderBy("name")
			
			If (Bool:C1537($Obj_in.withSeparator))
				
				// Add a seperator line
				$Col_snippets.push(New object:C1471(\
					"name"; "-"))
				
			End if 
			
		Else 
			
			$Col_snippets:=New collection:C1472
			
		End if 
		//}
		
		// Get the shared snippets {
		$Obj_folder:=doc_Folder(_o_keepit_folder)
		
		If ($Obj_folder.exist)
			
			$Obj_out.success:=True:C214
			
			$Obj_folder.files:=$Obj_folder.files.query("name != .@")
			
			If (Bool:C1537($Obj_in.filtered))
				
				$Obj_folder.files:=$Obj_folder.files.query("name != _@")
				
			End if 
			
			$Obj_folder.files:=$Obj_folder.files.orderBy("name")
			
			$Col_snippets:=$Col_snippets.combine($Obj_folder.files)
			
		End if 
		//}
		
		$Obj_out.data:=$Col_snippets
		
		//______________________________________________________
	: ($Obj_in.do="menu")
		
		$Mnu_main:=Create menu:C408
		
		$Obj_snippets:=_o_keepit(New object:C1471(\
			"do"; "list"; \
			"filtered"; True:C214; \
			"withSeparator"; True:C214))
		
		If ($Obj_snippets.success)
			
			For each ($Obj_snippet; $Obj_snippets.data)
				
				$Txt_name:=$Obj_snippet.name
				
				If ($Txt_name="-")  // Separator line
					
					APPEND MENU ITEM:C411($Mnu_main; $Txt_name)
					
				Else 
					
					$Lon_length:=Length:C16($Txt_name)
					
					$Boo_shortcut:=($Txt_name[[$Lon_length-1]]="_")
					
					If ($Boo_shortcut)
						
						$Txt_shortcut:=$Txt_name[[$Lon_length]]
						$Txt_name:=Delete string:C232($Txt_name; $Lon_length-1; 2)
						
					End if 
					
					APPEND MENU ITEM:C411($Mnu_main; $Txt_name)
					SET MENU ITEM PARAMETER:C1004($Mnu_main; -1; $Obj_snippet.name)
					
					If ($Boo_shortcut)
						
						SET MENU ITEM SHORTCUT:C423($Mnu_main; -1; $Txt_shortcut; 0 ?+ Command key bit:K16:2)
						
					End if 
				End if 
			End for each 
		End if 
		
		$Txt_choice:=Dynamic pop up menu:C1006($Mnu_main; String:C10(keepit_session(New object:C1471("key"; "last")).value))
		RELEASE MENU:C978($Mnu_main)
		
		If (Length:C16($Txt_choice)>0)
			
			$Lon_index:=$Obj_snippets.data.extract("name").indexOf($Txt_choice)
			
			// Keep last used
			keepit_session(New object:C1471(\
				"set"; True:C214; \
				"key"; "last"; \
				"value"; $Txt_choice))
			
			// Put the result in the method editor
			$Txt_code:=_o_keepit(New object:C1471("do"; "processing"; "code"; Document to text:C1236($Obj_snippets.data[$Lon_index].nativePath))).code
			
			SET MACRO PARAMETER:C998(Highlighted method text:K5:18; $Txt_code)
			
		End if 
		
		//______________________________________________________
	: ($Obj_in.do="processing")
		
		PROCESS PROPERTIES:C336(Current process:C322; $Txt_name; $Lon_; $Lon_)
		
		$Boo_copy:=($Txt_name="$4DPop KeepIt") & (Form event code:C388#On Begin Drag Over:K2:44)
		
		$Obj_out.code:=$Obj_in.code
		
		$Obj_out.code:=_o_keepit(New object:C1471("do"; "<file/>"; "code"; $Obj_out.code)).code
		$Obj_out.code:=_o_keepit(New object:C1471("do"; "<clipboard/>"; "code"; $Obj_out.code)).code
		$Obj_out.code:=_o_keepit(New object:C1471("do"; "<var/>"; "code"; $Obj_out.code)).code
		$Obj_out.code:=_o_keepit(New object:C1471("do"; "<keepit/>"; "code"; $Obj_out.code)).code
		$Obj_out.code:=_o_keepit(New object:C1471("do"; "<date/>"; "code"; $Obj_out.code)).code
		$Obj_out.code:=_o_keepit(New object:C1471("do"; "<time/>"; "code"; $Obj_out.code)).code
		$Obj_out.code:=_o_keepit(New object:C1471("do"; "<method_name/>"; "code"; $Obj_out.code)).code
		$Obj_out.code:=_o_keepit(New object:C1471("do"; "<method_path/>"; "code"; $Obj_out.code)).code
		$Obj_out.code:=_o_keepit(New object:C1471("do"; "<method_type/>"; "code"; $Obj_out.code)).code
		$Obj_out.code:=_o_keepit(New object:C1471("do"; "<database_name/>"; "code"; $Obj_out.code)).code
		$Obj_out.code:=_o_keepit(New object:C1471("do"; "<uid/>"; "code"; $Obj_out.code)).code
		$Obj_out.code:=_o_keepit(New object:C1471("do"; "<selection/>"; "code"; $Obj_out.code)).code
		$Obj_out.code:=_o_keepit(New object:C1471("do"; "<method/>"; "code"; $Obj_out.code)).code
		$Obj_out.code:=_o_keepit(New object:C1471("do"; "<method-attribute/>"; "code"; $Obj_out.code)).code
		
		$Obj_out.code:=_o_keepit(New object:C1471("do"; "<ask/>"; "code"; $Obj_out.code)).code
		
		// Detokenization {
		If (Length:C16($Obj_out.code)>0)
			
			$Col_code:=Split string:C1554($Obj_out.code; "\r")
			
			If ($Col_code[0]="%attributes = @")
				
				$Obj_out.code:=_o_keepit(New object:C1471("do"; "localization"; "code"; $Obj_out.code)).code
				
			Else 
				
				// [COMPATIBILITY]
				$Txt_code:=$Obj_out.code
				
				_o_tag_keyword(->$Txt_code)
				
				If (Position:C15("<command number="; $Txt_code)>0)
					
					_o_tag_command(->$Txt_code)
					
				End if 
				
				If (Position:C15("<constant "; $Txt_code)>0)
					
					_o_tag_constant(->$Txt_code)
					
				End if 
				
				$Obj_out.code:=$Txt_code
				
			End if 
		End if 
		//}
		
		$Obj_out.code:=Replace string:C233($Obj_out.code; "<user_4D/>"; Current user:C182)
		$Obj_out.code:=Replace string:C233($Obj_out.code; "<user_os/>"; Current system user:C484)
		
		// Treat loops  & conditions
		$Obj_out.code:=_o_keepit(New object:C1471("do"; "loops & conditions"; "code"; $Obj_out.code)).code
		
		$Obj_out.code:=_o_keepit(New object:C1471("do"; "cleanup"; "code"; $Obj_out.code)).code
		
		//______________________________________________________
	: ($Obj_in.do="new")
		
		$Txt_code:=String:C10($Obj_in.code)  // Get the passed code, if exist
		
		If (Length:C16($Txt_code)=0)
			
			GET MACRO PARAMETER:C997(Highlighted method text:K5:18; $Txt_code)
			
		End if 
		
		If (Length:C16($Txt_code)>0)
			
			$Txt_name:=String:C10($Obj_in.name)  // Get the passed name, if exist
			
			// Ask for the snippet name
			$Txt_name:=Request:C163(Get localized string:C991("namingThisNewItem"); Choose:C955(Length:C16($Txt_name); Get localized string:C991("newItem"); $Txt_name))
			
			If (Bool:C1537(OK))\
				 & (Length:C16($Txt_name)>0)
				
				$File_target:=Object to path:C1548(New object:C1471(\
					"name"; $Txt_name; \
					"parentFolder"; _o_keepit_folder; \
					"extension"; ".txt"))
				
				If (Test path name:C476($File_target)=Is a document:K24:1)
					
					CONFIRM:C162(Replace string:C233(Get localized string:C991("anItemAlreadyExist"); "{name}"; $Txt_name); Get localized string:C991("replace"))
					
				End if 
				
				If (Bool:C1537(OK))
					
					TEXT TO DOCUMENT:C1237($File_target; $Txt_code)
					
					WINDOW LIST:C442($tWin_)
					
					// Update editor if any
					For ($Lon_i; 1; Size of array:C274($tWin_); 1)
						
						If (Get window title:C450($tWin_{$Lon_i})="4DPop KeepIt")
							
							CALL FORM:C1391($tWin_{$Lon_i}; "keepit"; New object:C1471(\
								"do"; "updateList"))
							
							$Lon_i:=MAXLONG:K35:2-1
							
						End if 
					End for 
				End if 
			End if 
			
		Else 
			
			ALERT:C41(Get localized string:C991("MainselectionIsEmpty!"))
			
		End if 
		
		//______________________________________________________
	: ($Obj_in.do="updateList")
		
		Form:C1466.snippets:=Form:C1466.list()
		
		//______________________________________________________
	: ($Obj_in.do="<ask/>")
		
		$Txt_code:=$Obj_in.code
		
		$Txt_pattern:="<ask (?:message=\"([^\"]*)\")+(?: type=\"([^\"]*)\")?/>"
		
		If (Rgx_ExtractText($Txt_pattern; $Txt_code; ""; ->$tTxt_segments)=0)
			
			For ($Lon_i; 1; Size of array:C274($tTxt_segments); 1)
				
				$Txt_question:=$tTxt_segments{$Lon_i}{1}
				
				If ($Txt_question="\\@")  // \\digit - back reference operator
					
					// Digit must be 1 or greater.
					// \1 matches the answer to the first ask, \2 the second etc.
					$Txt_question:=Substring:C12($Txt_question; 2)
					
					// #16-5-2014
					// Manage \x+ & \x- to increment/decrement the back referenced answer
					If (Rgx_MatchText("^[^+-]*([+-])*"; $Txt_question; ->$tTxt_buffer)=0)
						
						If (Size of array:C274($tTxt_buffer)=1)
							
							$Txt_modifier:=$tTxt_buffer{1}
							
						End if 
					End if 
					
					$Lon_index:=Num:C11($Txt_question)
					
					If ($Lon_index>0)\
						 & ($Lon_index<=Size of array:C274($tTxt_parameters))
						
						$Txt_buffer:=$tTxt_parameters{$Lon_index}
						
						Case of 
								
								//______________________________________________________
							: ($Txt_modifier="+")
								
								$Txt_buffer:=String:C10(Num:C11($Txt_buffer)+1)
								
								//______________________________________________________
							: ($Txt_modifier="-")
								
								$Txt_buffer:=String:C10(Num:C11($Txt_buffer)-1)
								
								//______________________________________________________
						End case 
						
					Else 
						
						$Txt_buffer:="<ERROR "+$Txt_buffer+" >"
						
					End if 
					
					$Txt_code:=Replace string:C233($Txt_code; $tTxt_segments{$Lon_i}{0}; $Txt_buffer; 1)
					
				Else 
					
					If (Size of array:C274($tTxt_segments{$Lon_i})>=2)
						
						$Txt_type:=$tTxt_segments{$Lon_i}{2}
						
					End if 
					
					$Obj_data:=New object:C1471(\
						"question"; $Txt_question; \
						"type"; $Txt_type+("text"*Num:C11(Length:C16($Txt_type)=0)))  // Default is text
					
					$Win_hdl:=Open form window:C675("ASK"; Movable form dialog box:K39:8; Horizontally centered:K39:1; Vertically centered:K39:4)
					DIALOG:C40("ASK"; $Obj_data)
					CLOSE WINDOW:C154
					
					If (OK=1)
						
						Case of 
								
								//______________________________________________________
							: ($Obj_data.type="text")
								
								$Txt_buffer:=String:C10($Obj_data.result)
								
								//______________________________________________________
							: ($Obj_data.type="integer")\
								 | ($Obj_data.type="real")
								
								$Txt_buffer:=String:C10(Num:C11($Obj_data.result))
								
								//______________________________________________________
							Else 
								
								$Txt_buffer:=String:C10($Obj_data.result)
								
								//______________________________________________________
						End case 
						
						// Replace element with the answer
						$Txt_code:=Replace string:C233($Txt_code; $tTxt_segments{$Lon_i}{0}; $Txt_buffer; 1)
						
						// Keep the answer
						APPEND TO ARRAY:C911($tTxt_parameters; $Txt_buffer)
						
					End if 
				End if 
			End for 
		End if 
		
		$Obj_out.code:=$Txt_code
		
		//______________________________________________________
	: ($Obj_in.do="<method/>")
		
		$Txt_code:=$Obj_in.code
		
		$Txt_pattern:="<method>(.*?)</method>"
		
		If (Rgx_ExtractText($Txt_pattern; $Txt_code; ""; ->$tTxt_segments)=0)
			
			For ($Lon_i; 1; Size of array:C274($tTxt_segments); 1)
				
				$Txt_buffer:=_o_keepit_method($tTxt_segments{$Lon_i}{1})
				
				$Txt_code:=Replace string:C233($Txt_code; $tTxt_segments{$Lon_i}{0}; $Txt_buffer)
				
			End for 
		End if 
		
		$Obj_out.code:=$Txt_code
		
		//______________________________________________________
	: ($Obj_in.do="<method-attribute/>")
		
		$Txt_code:=$Obj_in.code
		
		If (Position:C15("<method-attribute"; $Txt_code)>0)
			
			$Txt_methodPath:=Split string:C1554(_o_methodGetName; ":"; sk trim spaces:K86:2)[1]
			
			ON ERR CALL:C155("noError")
			
			While (Rgx_ExtractText("(?m-si)(<method-attribute type=\"*(\\d+)\"*(?: value=\"([^\"]+)\")\\s*/>)"; $Txt_code; ""; ->$tTxt_segments)=0)
				
				$Txt_code:=Replace string:C233($Txt_code; $tTxt_segments{1}{1}; "")
				
				$Boo_value:=True:C214  // Default is true
				
				// Get the value if any
				If (Size of array:C274($tTxt_segments{1})>=3)
					
					$Boo_value:=($tTxt_segments{1}{3}="true")
					
				End if 
				
				METHOD SET ATTRIBUTE:C1192($Txt_methodPath; Num:C11($tTxt_segments{1}{2}); $Boo_value; *)
				
			End while 
			
			ON ERR CALL:C155("")
			
		End if 
		
		$Obj_out.code:=$Txt_code
		
		//______________________________________________________
	: ($Obj_in.do="<selection/>")
		
		$Txt_code:=$Obj_in.code
		
		If (Position:C15($Obj_in.do; $Txt_code)>0)
			
			GET MACRO PARAMETER:C997(Highlighted method text:K5:18; $Txt_buffer)
			$Txt_code:=Replace string:C233($Txt_code; $Obj_in.do; $Txt_buffer)
			
		End if 
		
		$Obj_out.code:=$Txt_code
		
		//______________________________________________________
	: ($Obj_in.do="<uid/>")
		
		$Txt_code:=$Obj_in.code
		
		If (Position:C15($Obj_in.do; $Txt_code)>0)
			
			$Txt_buffer:=Generate UUID:C1066
			$Txt_code:=Replace string:C233($Txt_code; $Obj_in.do; $Txt_buffer)
			
		End if 
		
		$Obj_out.code:=$Txt_code
		
		//______________________________________________________
	: ($Obj_in.do="<database_name/>")
		
		$Txt_code:=$Obj_in.code
		
		If (Position:C15($Obj_in.do; $Txt_code)>0)
			
			$Txt_code:=Replace string:C233($Txt_code; $Obj_in.do; Path to object:C1547(Structure file:C489(*)).name)
			
		End if 
		
		$Obj_out.code:=$Txt_code
		
		//______________________________________________________
	: ($Obj_in.do="<method_type/>")
		
		$Txt_code:=$Obj_in.code
		
		If (Position:C15($Obj_in.do; $Txt_code)>0)
			
			$Txt_buffer:=_o_methodGetName
			
			$Lon_x:=Position:C15(":"; $Txt_buffer)
			
			Case of 
					
					//…………………………………………………………………………………
				: (Position:C15(Get localized string:C991("w_formMethod"); $Txt_buffer)=1)
					
					$Txt_buffer:=Delete string:C232($Txt_buffer; 1; $Lon_x+1)
					
					$Lon_methodType:=Choose:C955(Position:C15("["; $Txt_buffer)=1; Path table form:K72:5; Path project form:K72:3)
					
					//…………………………………………………………………………………
				: (Position:C15(Get localized string:C991("w_triggerMethod"); $Txt_buffer)=1)
					
					$Lon_methodType:=Path trigger:K72:4
					
					//…………………………………………………………………………………
				: (Position:C15(Get localized string:C991("w_method"); $Txt_buffer)=1)
					
					$Lon_methodType:=Path project method:K72:1
					
					//…………………………………………………………………………………
				: (Position:C15(Get localized string:C991("w_objectMethod"); $Txt_buffer)=1)
					
					$Txt_buffer:=Delete string:C232($Txt_buffer; 1; $Lon_x+1)
					
					If (Position:C15("["; $Txt_buffer)=1)
						
						$Lon_methodType:=Path table form:K72:5
						
						$Lon_x:=Position:C15("]"; $Txt_buffer)
						
						$Txt_table:=Substring:C12($Txt_buffer; 1; $Lon_x)
						$Txt_buffer:=Substring:C12($Txt_buffer; $Lon_x+2)  // +2 because there is a point after the table name
						
					Else 
						
						$Lon_methodType:=Path project form:K72:3
						
					End if 
					
					$Lon_x:=Position:C15("."; $Txt_buffer)
					
					If ($Lon_x>0)
						
						$Txt_object:=Substring:C12($Txt_buffer; $Lon_x+1)
						
						If (Length:C16($Txt_object)>0)
							
							$Lon_methodType:=8858
							
						End if 
					End if 
					
					//…………………………………………………………………………………
				: ($Txt_buffer=Get localized string:C991("Database_onStartup"))\
					 | ($Txt_buffer=Get localized string:C991("Database_onExit"))\
					 | ($Txt_buffer=Get localized string:C991("Database_onDrop"))\
					 | ($Txt_buffer=Get localized string:C991("Database_onBackupStartup"))\
					 | ($Txt_buffer=Get localized string:C991("Database_onBackupShutdown"))\
					 | ($Txt_buffer=Get localized string:C991("Database_onWebConnection"))\
					 | ($Txt_buffer=Get localized string:C991("Database_onWebAuthentication"))\
					 | ($Txt_buffer=Get localized string:C991("Database_onWebSessionSuspend"))\
					 | ($Txt_buffer=Get localized string:C991("Database_onServerStartup"))\
					 | ($Txt_buffer=Get localized string:C991("Database_onServerShutdown"))\
					 | ($Txt_buffer=Get localized string:C991("Database_onServerOpenConnection"))\
					 | ($Txt_buffer=Get localized string:C991("Database_onServerCloseConnection"))\
					 | ($Txt_buffer=Get localized string:C991("Database_onSystemEvent"))\
					 | ($Txt_buffer=Get localized string:C991("Database_onSqlAuthentication"))
					
					$Lon_methodType:=Path database method:K72:2
					
					//…………………………………………………………………………………
			End case 
			
			$Txt_code:=Replace string:C233($Txt_code; $Obj_in.do; String:C10($Lon_methodType; "###"))
			
		End if 
		
		$Obj_out.code:=$Txt_code
		
		//______________________________________________________
	: ($Obj_in.do="<method_path/>")
		
		$Txt_code:=$Obj_in.code
		
		If (Position:C15($Obj_in.do; $Txt_code)>0)
			
			$Txt_buffer:=_o_methodGetName
			
			$Lon_x:=Position:C15(":"; $Txt_buffer)
			
			Case of 
					
					//…………………………………………………………………………………
				: (Position:C15(Get localized string:C991("w_formMethod"); $Txt_buffer)=1)
					
					$Txt_buffer:=Delete string:C232($Txt_buffer; 1; $Lon_x+1)
					
					If (Position:C15("["; $Txt_buffer)=1)
						
						$Lon_methodType:=Path table form:K72:5
						
						$Lon_x:=Position:C15("]"; $Txt_buffer)
						
						$Txt_table:=Substring:C12($Txt_buffer; 1; $Lon_x)
						$Txt_buffer:=Substring:C12($Txt_buffer; $Lon_x+1)
						
					Else 
						
						$Lon_methodType:=Path project form:K72:3
						
					End if 
					
					$Txt_form:=$Txt_buffer
					
					//…………………………………………………………………………………
				: (Position:C15(Get localized string:C991("w_triggerMethod"); $Txt_buffer)=1)
					
					$Lon_methodType:=Path trigger:K72:4
					
					$Txt_table:=Delete string:C232($Txt_buffer; 1; $Lon_x+1)
					
					//…………………………………………………………………………………
				: (Position:C15(Get localized string:C991("w_method"); $Txt_buffer)=1)
					
					$Lon_methodType:=Path project method:K72:1
					
					$Txt_method:=Delete string:C232($Txt_buffer; 1; $Lon_x+1)
					
					//…………………………………………………………………………………
				: (Position:C15(Get localized string:C991("w_objectMethod"); $Txt_buffer)=1)
					
					$Txt_buffer:=Delete string:C232($Txt_buffer; 1; $Lon_x+1)
					
					If (Position:C15("["; $Txt_buffer)=1)
						
						$Lon_methodType:=Path table form:K72:5
						
						$Lon_x:=Position:C15("]"; $Txt_buffer)
						
						$Txt_table:=Substring:C12($Txt_buffer; 1; $Lon_x)
						$Txt_buffer:=Substring:C12($Txt_buffer; $Lon_x+2)  // +2 because there is a point after the table name
						
					Else 
						
						$Lon_methodType:=Path project form:K72:3
						
					End if 
					
					$Lon_x:=Position:C15("."; $Txt_buffer)
					
					$Txt_form:=Substring:C12($Txt_buffer; 1; $Lon_x-1)
					$Txt_object:=Substring:C12($Txt_buffer; $Lon_x+1)
					
					//…………………………………………………………………………………
				: ($Txt_buffer=Get localized string:C991("Database_onStartup"))
					
					$Lon_methodType:=Path database method:K72:2
					$Txt_method:="onStartup"
					
					//…………………………………………………………………………………
				: ($Txt_buffer=Get localized string:C991("Database_onExit"))
					
					$Lon_methodType:=Path database method:K72:2
					$Txt_method:="onExit"
					
					//…………………………………………………………………………………
				: ($Txt_buffer=Get localized string:C991("Database_onDrop"))
					
					$Lon_methodType:=Path database method:K72:2
					$Txt_method:="onDrop"
					
					//…………………………………………………………………………………
				: ($Txt_buffer=Get localized string:C991("Database_onBackupStartup"))
					
					$Lon_methodType:=Path database method:K72:2
					$Txt_method:="onBackupStartup"
					
					//…………………………………………………………………………………
				: ($Txt_buffer=Get localized string:C991("Database_onBackupShutdown"))
					
					$Lon_methodType:=Path database method:K72:2
					$Txt_method:="onBackupShutdown"
					
					//…………………………………………………………………………………
				: ($Txt_buffer=Get localized string:C991("Database_onWebConnection"))
					
					$Lon_methodType:=Path database method:K72:2
					$Txt_method:="onWebConnection"
					
					//…………………………………………………………………………………
				: ($Txt_buffer=Get localized string:C991("Database_onWebAuthentication"))
					
					$Lon_methodType:=Path database method:K72:2
					$Txt_method:="onWebAuthentication"
					
					//…………………………………………………………………………………
				: ($Txt_buffer=Get localized string:C991("Database_onWebSessionSuspend"))
					
					$Lon_methodType:=Path database method:K72:2
					$Txt_method:="onWebSessionSuspend"
					
					//…………………………………………………………………………………
				: ($Txt_buffer=Get localized string:C991("Database_onServerStartup"))
					
					$Lon_methodType:=Path database method:K72:2
					$Txt_method:="onServerStartup"
					
					//…………………………………………………………………………………
				: ($Txt_buffer=Get localized string:C991("Database_onServerShutdown"))
					
					$Lon_methodType:=Path database method:K72:2
					$Txt_method:="onServerShutdown"
					
					//…………………………………………………………………………………
				: ($Txt_buffer=Get localized string:C991("Database_onServerOpenConnection"))
					
					$Lon_methodType:=Path database method:K72:2
					$Txt_method:="onServerOpenConnection"
					
					//…………………………………………………………………………………
				: ($Txt_buffer=Get localized string:C991("Database_onServerCloseConnection"))
					
					$Lon_methodType:=Path database method:K72:2
					$Txt_method:="onServerCloseConnection"
					
					//…………………………………………………………………………………
				: ($Txt_buffer=Get localized string:C991("Database_onSystemEvent"))
					
					$Lon_methodType:=Path database method:K72:2
					$Txt_method:="onSystemEvent"
					
					//…………………………………………………………………………………
				: ($Txt_buffer=Get localized string:C991("Database_onSqlAuthentication"))
					
					$Lon_methodType:=Path database method:K72:2
					$Txt_method:="onSqlAuthentication"
					
					//…………………………………………………………………………………
			End case 
			
			Case of 
					
					//…………………………………………………………………………………
				: ($Lon_methodType=Path project method:K72:1)\
					 | ($Lon_methodType=Path database method:K72:2)
					
					$Txt_methodPath:=METHOD Get path:C1164($Lon_methodType; $Txt_method; *)
					
					//…………………………………………………………………………………
				: ($Lon_methodType=Path project form:K72:3)
					
					$Txt_methodPath:=Choose:C955(Length:C16($Txt_object)>0; METHOD Get path:C1164($Lon_methodType; $Txt_form; $Txt_object; *); METHOD Get path:C1164($Lon_methodType; $Txt_form; *))
					
					//…………………………………………………………………………………
				: ($Lon_methodType=Path table form:K72:5)
					
					$Ptr_table:=ptrTable($Txt_table)
					$Txt_methodPath:=Choose:C955(Length:C16($Txt_object)>0; \
						METHOD Get path:C1164($Lon_methodType; $Ptr_table->; $Txt_form; $Txt_object; *); \
						METHOD Get path:C1164($Lon_methodType; $Ptr_table->; $Txt_form; *))
					
					//…………………………………………………………………………………
				: ($Lon_methodType=Path trigger:K72:4)
					
					$Txt_methodPath:=METHOD Get path:C1164($Lon_methodType; ptrTable($Txt_table)->; *)
					
					//…………………………………………………………………………………
			End case 
			
			$Txt_code:=Replace string:C233($Txt_code; $Obj_in.do; $Txt_methodPath)
			
		End if 
		
		$Obj_out.code:=$Txt_code
		
		//______________________________________________________
	: ($Obj_in.do="<method_name/>")
		
		$Txt_code:=$Obj_in.code
		
		If (Position:C15($Obj_in.do; $Txt_code)>0)
			
			$Txt_buffer:=_o_methodGetName
			
			$Txt_code:=Replace string:C233($Txt_code; $Obj_in.do; Delete string:C232($Txt_buffer; 1; Position:C15(":"; $Txt_buffer)+1))
			
		End if 
		
		$Obj_out.code:=$Txt_code
		
		//______________________________________________________
	: ($Obj_in.do="<time/>")
		
		$Txt_code:=$Obj_in.code
		
		$Txt_pattern:="<time(?: format=\"([^\"]*)\")?/>"
		
		If (Rgx_ExtractText($Txt_pattern; $Txt_code; ""; ->$tTxt_segments)=0)
			
			For ($Lon_i; 1; Size of array:C274($tTxt_segments); 1)
				
				// Get the encoding if any
				If (Size of array:C274($tTxt_segments{$Lon_i})>=1)
					
					$Txt_format:=$tTxt_segments{$Lon_i}{1}
					
					If (Length:C16($Txt_format)>0)
						
						$Txt_buffer:=String:C10(Current time:C178; Num:C11($Txt_format))
						
					Else 
						
						// Default format
						$Txt_buffer:=String:C10(Current time:C178)
						
					End if 
				End if 
				
				$Txt_code:=Replace string:C233($Txt_code; $tTxt_segments{$Lon_i}{0}; $Txt_buffer; 1)
				
			End for 
		End if 
		
		$Obj_out.code:=$Txt_code
		
		//______________________________________________________
	: ($Obj_in.do="<date/>")
		
		$Txt_code:=$Obj_in.code
		
		$Txt_pattern:="<date(?: format=\"([^\"]*)\")?/>"
		
		If (Rgx_ExtractText($Txt_pattern; $Txt_code; ""; ->$tTxt_segments)=0)
			
			For ($Lon_i; 1; Size of array:C274($tTxt_segments); 1)
				
				// Get the encoding if any
				If (Size of array:C274($tTxt_segments{$Lon_i})>=1)
					
					$Txt_format:=$tTxt_segments{$Lon_i}{1}
					
					If (Num:C11($Txt_format)>0)
						
						$Txt_buffer:=String:C10(Current date:C33; Num:C11($Txt_format))
						
					Else 
						
						Repeat 
							
							Case of 
									
									//______________________________________________________
								: ($Txt_format="y@")
									
									$Txt_buffer:=$Txt_buffer+String:C10(Year of:C25(Current date:C33))
									$Txt_format:=Substring:C12($Txt_format; 2)
									
									//______________________________________________________
								: ($Txt_format="m@")
									
									$Txt_buffer:=$Txt_buffer+String:C10(Month of:C24(Current date:C33))
									$Txt_format:=Substring:C12($Txt_format; 2)
									
									//______________________________________________________
								: ($Txt_format="d@")
									
									$Txt_buffer:=$Txt_buffer+String:C10(Day of:C23(Current date:C33))
									$Txt_format:=Substring:C12($Txt_format; 2)
									
									//______________________________________________________
								Else 
									
									CLEAR VARIABLE:C89($Txt_format)
									
									//______________________________________________________
							End case 
							
							If (Length:C16($Txt_format)>0)
								
								If (Position:C15($Txt_format[[1]]; "yma")=0)
									
									$Txt_buffer:=$Txt_buffer+$Txt_format[[1]]
									$Txt_format:=Substring:C12($Txt_format; 2)
									
								End if 
							End if 
						Until (Length:C16($Txt_format)=0)
						
						If (Length:C16($Txt_buffer)=0)
							
							$Txt_buffer:=String:C10(Current date:C33)
							
						End if 
					End if 
				End if 
				
				$Txt_code:=Replace string:C233($Txt_code; $tTxt_segments{$Lon_i}{0}; $Txt_buffer; 1)
				
			End for 
		End if 
		
		$Obj_out.code:=$Txt_code
		
		//______________________________________________________
	: ($Obj_in.do="<keepit/>")
		
		$Txt_code:=$Obj_in.code
		
		$Obj_snippets:=_o_keepit(New object:C1471(\
			"do"; "list"))
		
		If ($Obj_snippets.success)
			
			$Txt_pattern:="<keepit name=\"([^\"]*)\"/>"
			
			If (Rgx_ExtractText($Txt_pattern; $Txt_code; ""; ->$tTxt_segments)=0)
				
				For ($Lon_i; 1; Size of array:C274($tTxt_segments); 1)
					
					$Col_snippets:=$Obj_snippets.data.query("name = :1"; $tTxt_segments{$Lon_i}{1})
					
					If ($Col_snippets.length>0)
						
						$Txt_buffer:=_o_keepit(New object:C1471("do"; "processing"; "code"; Document to text:C1236($Col_snippets[0].nativePath))).code
						
						$Txt_code:=Replace string:C233($Txt_code; $tTxt_segments{$Lon_i}{0}; $Txt_buffer; 1)
						
					Else 
						
						// Put name as tag
						$Txt_code:=Replace string:C233($Txt_code; $tTxt_segments{$Lon_i}{0}; "<"+$tTxt_segments{$Lon_i}{1}+">"; 1)
						
					End if 
				End for 
			End if 
		End if 
		
		$Obj_out.code:=$Txt_code
		
		//______________________________________________________
	: ($Obj_in.do="<var/>")
		
		$Txt_code:=$Obj_in.code
		
		$Txt_pattern:="<var (?:name=\"([^\"]*)\")+(?: type=\"([^\"]*)\")?/>"
		
		If (Rgx_ExtractText($Txt_pattern; $Txt_code; ""; ->$tTxt_segments)=0)
			
			For ($Lon_i; 1; Size of array:C274($tTxt_segments); 1)
				
				$Txt_varName:=$tTxt_segments{$Lon_i}{1}
				
				// Get the value {
				CLEAR VARIABLE:C89($Txt_value)
				$Ptr_var:=Get pointer:C304($Txt_varName)
				
				If (Not:C34(Is nil pointer:C315($Ptr_var)))
					
					$Lon_type:=Type:C295($Ptr_var->)
					
					Case of 
							
							//______________________________________________________
						: ($Lon_type=Is undefined:K8:13)
							
							ALERT:C41($Txt_varName+": Undefined!")
							
							//______________________________________________________
						: ($Lon_type=Is text:K8:3)\
							 | ($Lon_type=Is string var:K8:2)
							
							$Txt_value:=$Ptr_var->
							
							//______________________________________________________
						: ($Lon_type=Is integer:K8:5)\
							 | ($Lon_type=Is longint:K8:6)\
							 | ($Lon_type=Is integer 64 bits:K8:25)\
							 | ($Lon_type=Is real:K8:4)
							
							$Txt_value:=String:C10($Ptr_var->)
							
							//______________________________________________________
						: ($Lon_type=Is date:K8:7)
							
							$Txt_value:=String:C10($Ptr_var->)
							
							//______________________________________________________
						: ($Lon_type=Is time:K8:8)
							
							$Txt_value:=String:C10($Ptr_var->)
							
							//______________________________________________________
						Else 
							
							ALERT:C41($Txt_varName+": non valid!")
							
							//______________________________________________________
					End case 
				End if 
				//}
				
				If (Length:C16($Txt_value)>0)
					
					// Replace element with the value
					$Txt_code:=Replace string:C233($Txt_code; $tTxt_segments{$Lon_i}{0}; $Txt_value; 1)
					
				End if 
			End for 
		End if 
		
		$Obj_out.code:=$Txt_code
		
		//______________________________________________________
	: ($Obj_in.do="<clipboard/>")
		
		$Txt_code:=$Obj_in.code
		
		If (Position:C15($Obj_in.do; $Txt_code)>0)
			
			$Txt_buffer:=Get text from pasteboard:C524
			$Txt_code:=Replace string:C233($Txt_code; $Obj_in.do; $Txt_buffer)
			
		End if 
		
		$Obj_out.code:=$Txt_code
		
		//______________________________________________________
	: ($Obj_in.do="<file/>")
		
		$Txt_code:=$Obj_in.code
		
		$Txt_pattern:="<file (?:url=\"([^\"]*)\")+(?: encoding=\"([^\"]*)\")?/>"
		
		If (Rgx_ExtractText($Txt_pattern; $Txt_code; ""; ->$tTxt_segments)=0)
			
			For ($Lon_i; 1; Size of array:C274($tTxt_segments); 1)
				
				$Txt_url:=$tTxt_segments{$Lon_i}{1}
				
				// Get the encoding if any
				If (Size of array:C274($tTxt_segments{$Lon_i})>=2)
					
					$Txt_encoding:=$tTxt_segments{$Lon_i}{2}
					
				End if 
				
				$Txt_buffer:=_o_keepit_get_file($Txt_url; $Txt_encoding)
				$Txt_buffer:=$Txt_buffer+("•keepit ERROR•"*Num:C11(Length:C16($Txt_buffer)=0))
				
				$Txt_code:=Replace string:C233($Txt_code; $tTxt_segments{$Lon_i}{0}; $Txt_buffer; 1)
				
			End for 
		End if 
		
		$Obj_out.code:=$Txt_code
		
		//______________________________________________________
	: ($Obj_in.do="localization")
		
		$Txt_code:=$Obj_in.code
		
		$Col_code:=Split string:C1554($Txt_code; "\r")
		
		ARRAY TEXT:C222($tTxt_source; 0x0000)
		ARRAY TEXT:C222($tTxt_target; 0x0000)
		
		$Txt_currentLang:=Choose:C955(Command name:C538(41)="ALERT"; "us"; "fr")
		$Txt_codeLang:=JSON Parse:C1218(Delete string:C232($Col_code[0]; 1; 14)).lang
		
		// Remove the attribute line and restore the code as text
		$Txt_code:=$Col_code.remove(0).join("\r")
		
		If ($Txt_currentLang=$Txt_codeLang)
			
			// NOTHING MORE TO DO
			
		Else 
			
			// Replace the control flow keywords with those of the current language
			$File_resources:=Get 4D folder:C485(Current resources folder:K5:16)+"controlFlow.json"
			
			If (Asserted:C1132(Test path name:C476($File_resources)=Is a document:K24:1; "missing file: "+$File_resources))
				
				$Obj_controlFlow:=JSON Parse:C1218(Document to text:C1236($File_resources))
				
				If ($Txt_currentLang="us")
					
					COLLECTION TO ARRAY:C1562($Obj_controlFlow.fr; $tTxt_source)
					COLLECTION TO ARRAY:C1562($Obj_controlFlow.intl; $tTxt_target)
					
				Else 
					
					COLLECTION TO ARRAY:C1562($Obj_controlFlow.intl; $tTxt_source)
					COLLECTION TO ARRAY:C1562($Obj_controlFlow.fr; $tTxt_target)
					
				End if 
				
				For ($Lon_i; 1; Size of array:C274($tTxt_source); 1)
					
					Rgx_SubstituteText("(?m-si)\\b("+$tTxt_source{$Lon_i}+")\\b"; $tTxt_target{$Lon_i}; ->$Txt_code)
					
				End for 
			End if 
		End if 
		
		$Obj_out.code:=$Txt_code
		
		//______________________________________________________
	: ($Obj_in.do="tokenize")
		
		If (Length:C16(String:C10($Obj_in.code))>0)
			
			$Col_lines:=Split string:C1554($Obj_in.code; "\r")
			
			If ($Col_lines[0]#"%attributes@")
				
				// Add the language attribute
				$Obj_attribute:=New object:C1471
				$Obj_attribute.lang:=Choose:C955(Command name:C538(41)="ALERT"; "us"; "fr")
				
				$Txt_code:="%attributes = "+JSON Stringify:C1217($Obj_attribute)
				
			Else 
				
				// Update the language attribute
				$Obj_attribute:=JSON Parse:C1218(Delete string:C232($Col_lines[0]; 1; 14))
				$Obj_attribute.lang:=Choose:C955(Command name:C538(41)="ALERT"; "us"; "fr")
				
				$Txt_code:="%attributes = "+JSON Stringify:C1217($Obj_attribute)
				
				$Lon_start:=1
				
			End if 
			
			For each ($Txt_line; $Col_lines; $Lon_start)
				
				$Txt_code:=$Txt_code+"\r"+Parse formula:C1576($Txt_line; Formula out with tokens:K88:3)
				
			End for each 
		End if 
		
		$Obj_out.code:=$Txt_code
		
		//______________________________________________________
	: ($Obj_in.do="indent")
		
		$Obj_out.code:=keepit_indent($Obj_in.code)
		
		//______________________________________________________
	: ($Obj_in.do="loops & conditions")
		
		$Txt_code:=$Obj_in.code
		
		ARRAY TEXT:C222($tTxt_lines; 0x0000)
		
		$Lon_error:=Rgx_SplitText("\\r\\n|\\r|\\n"; $Txt_code; ->$tTxt_lines; 0 ?+ 11)
		$Lon_count:=Size of array:C274($tTxt_lines)
		
		CLEAR VARIABLE:C89($Txt_code)
		
		For ($Lon_i; 1; $Lon_count; 1)
			
			$Txt_buffer:=$tTxt_lines{$Lon_i}
			
			Case of 
					
					//______________________________________________________
				: (Rgx_MatchText("^<iteration [^/]*/>.*"; $Txt_buffer)=0)  // <iteration/>
					
					ARRAY TEXT:C222($tTxt_extracted; 0x0000; 0x0000)
					
					If (Rgx_ExtractText("(<iteration(?: count=\"(\\d*)\")?/>)"; $Txt_buffer; ""; ->$tTxt_extracted)=0)
						
						$Lon_counter:=Num:C11($tTxt_extracted{1}{2})
						$Txt_buffer:=Replace string:C233($Txt_buffer; $tTxt_extracted{1}{1}; "")
						
					End if 
					
					CLEAR VARIABLE:C89($tTxt_lines{$Lon_i})
					
					For ($Lon_ii; 1; $Lon_counter; 1)
						
						$tTxt_lines{$Lon_i}:=$tTxt_lines{$Lon_i}+Replace string:C233($Txt_buffer; "<iteration/>"; String:C10($Lon_ii))+Choose:C955($Lon_ii<$Lon_counter; "\r"; "")
						
					End for 
					
					//______________________________________________________
				: (Rgx_MatchText("^#_ENDIF"; $Txt_buffer)=0)  // ENDIF
					
					$Boo_startCondition:=False:C215
					
					$tTxt_lines{$Lon_i}:="/*"+$tTxt_lines{$Lon_i}+"*/"
					
					//______________________________________________________
				: (Rgx_MatchText("^#_ELSE"; $Txt_buffer)=0)  // ELSE
					
					If (Num:C11(Application version:C493)>=1730)  // 17R3+
						
						$Boo_test:=Not:C34($Boo_test)
						
					Else 
						
						// Boo_test:=Not(Boo_test)
						
					End if 
					
					$tTxt_lines{$Lon_i}:="/*"+$tTxt_lines{$Lon_i}+"*/"
					
					//______________________________________________________
				: (Rgx_MatchText("^#_IF"; $Txt_buffer)=0)  // IF
					
					$Boo_startCondition:=True:C214
					
					$Txt_formula:="("+Replace string:C233($Txt_buffer; "#_IF "; "")+")"
					
					$Boo_test:=New object:C1471(\
						"eval"; Formula from string:C1601($Txt_formula)).eval()
					
					$tTxt_lines{$Lon_i}:="/*"+$tTxt_lines{$Lon_i}+"*/"
					
					//______________________________________________________
				: ($Boo_startCondition)
					
					If (Not:C34($Boo_test))
						
						$tTxt_lines{$Lon_i}:="/*"+$tTxt_lines{$Lon_i}+"*/"
						
					End if 
					
					//______________________________________________________
				Else 
					
					//______________________________________________________
			End case 
			
			$Txt_code:=$Txt_code+$tTxt_lines{$Lon_i}+Choose:C955($Lon_i<$Lon_count; "\r"; "")
			
		End for 
		
		$Obj_out.code:=$Txt_code
		
		//______________________________________________________
	: ($Obj_in.do="cleanup")
		
		$Txt_code:=$Obj_in.code
		
		PROCESS PROPERTIES:C336(Current process:C322; $Txt_name; $Lon_; $Lon_)
		
		// Remove keepit comments
		$Lon_error:=Rgx_SubstituteText("(/\\*[^\\*]*\\*/\\r?)"; ""; ->$Txt_code)
		
		// Ignore caret & selection if it's not a macro call
		If (Not:C34(($Txt_name="Macro_Call")))
			
			$Txt_code:=Replace string:C233($Txt_code; "<"+"caret"+"/>"; "")
			$Txt_code:=Replace string:C233($Txt_code; "<"+"selection"+"/>"; "")
			
		End if 
		
		$Obj_out.code:=$Txt_code
		
		//______________________________________________________
	Else 
		
		//______________________________________________________
End case 

// ----------------------------------------------------
// Return
$0:=$Obj_out

// ----------------------------------------------------
// End