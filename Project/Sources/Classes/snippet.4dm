Class constructor
	
	This:C1470.userSnippets:=This:C1470.getFolder(Folder:C1567(fk database folder:K87:14; *))
	This:C1470.sharedSnippets:=This:C1470.getFolder(Folder:C1567(fk user preferences folder:K87:10))
	
	If (Storage:C1525.keepitSession=Null:C1517)
		
		Use (Storage:C1525)
			
			Storage:C1525.keepitSession:=New shared object:C1526
			
		End use 
	End if 
	
	This:C1470.tags:={\
		file: "<file/>"; \
		clipboard: "<clipboard/>"; \
		var: "<var/>"; \
		keepit: "<keepit/>"; \
		date: "<date/>"; \
		time: "<time/>"; \
		methodName: "<method_name/>"; \
		methodPath: "<method_path/>"; \
		methodType: "<method_type/>"; \
		databaseName: "<database_name/>"; \
		uid: "<uid/>"; \
		selection: "<selection/>"; \
		method: "<method/>"; \
		methodAttribute: "<method-attribute/>"; \
		ask: "<ask/>"; \
		user4D: "<user_4D/>"; \
		userOS: "<user_os/>"\
		}
	
	This:C1470.data:=JSON Parse:C1218(File:C1566("/RESOURCES/desc.json").getText())
	
	var $key : Text
	var $i : Integer
	var $o : Object
	var $c : Collection
	
	For each ($key; This:C1470.data)
		
		$o:=This:C1470.data[$key]
		
		If ($key="databaseMethod")
			
			For ($i; 0; $o.methods.length-1; 1)
				
				$o.methods[$i]:=This:C1470._localized(Delete string:C232($o.methods[$i]; 1; 1))
				
			End for 
			
			continue
			
		End if 
		
		If ($o.name=".@")
			
			$o.name:=Delete string:C232($o.name; 1; 1)
			$c:=Split string:C1554($o.name; ";")
			$o.name:=This:C1470._localized($c.length=2 ? ($c[0]+","+$c[1]) : $o.name)
			
			continue
			
		End if 
		
		$o.name:=Get localized string:C991($key)
		
	End for each 
	
	This:C1470.resources:=JSON Parse:C1218(File:C1566("/RESOURCES/controlFlow.json").getText())
	This:C1470.language:=Command name:C538(41)="ALERT" ? "us" : "fr"
	
	// === === === === === === === === === === === === === === === === === === === === === 
Function doMenu()
	
	var $name; $shortcut : Text
	var $length : Integer
	var $file : 4D:C1709.File
	var $menu : cs:C1710.menu
	
	$menu:=cs:C1710.menu.new()
	
	For each ($file; This:C1470.list(True:C214))
		
		$name:=$file.name
		
		If ($name[[1]]="-")
			
			$menu.line()
			continue
			
		End if 
		
		$length:=Length:C16($name)
		
		If ($name[[$length-1]]="_")  // With shortcut
			
			$shortcut:=$name[[$length]]
			$name:=Delete string:C232($name; $length-1; 2)
			
			$menu.append($name; $file.name).shortcut($shortcut).setData("file"; $file)
			
		Else 
			
			$menu.append($name; $file.name).setData("file"; $file)
			
		End if 
		
	End for each 
	
	If (Not:C34($menu.popup(String:C10(Storage:C1525.keepitSession.last)).selected))
		
		return 
		
	End if 
	
	Use (Storage:C1525.keepitSession)
		
		Storage:C1525.keepitSession.last:=$menu.choice
		
	End use 
	
	SET MACRO PARAMETER:C998(Highlighted method text:K5:18; This:C1470.processing($menu.getData("file"; $menu.choice)))
	
	// === === === === === === === === === === === === === === === === === === === === === 
Function processing($file : 4D:C1709.File) : Text
	
	var $code : Text
	
	$code:=$file.getText()
	$code:=This:C1470._file($code)
	$code:=This:C1470._clipboard($code)
	$code:=This:C1470._var($code)
	$code:=This:C1470._keepit($code)
	$code:=This:C1470._date($code)
	$code:=This:C1470._time($code)
	$code:=This:C1470._methodName($code)
	$code:=This:C1470._methodPath($code)
	$code:=This:C1470._methodType($code)
	$code:=This:C1470._databaseName($code)
	$code:=This:C1470._uid($code)
	$code:=This:C1470._selection($code)
	$code:=This:C1470._method($code)
	$code:=This:C1470._methodAttributes($code)
	$code:=This:C1470._ask($code)
	
	If (Length:C16($code)>0)\
		 && (Split string:C1554($code; "\r").first()="%attributes = @")
		
		$code:=This:C1470._localize($code)
		
	End if 
	
	$code:=Replace string:C233($code; This:C1470.tags.user4D; Current user:C182)
	$code:=Replace string:C233($code; This:C1470.tags.userOS; Current system user:C484)
	
	$code:=This:C1470._loopsAndConditions($code)
	$code:=This:C1470._cleanup($code)
	
	return $code
	
	// === === === === === === === === === === === === === === === === === === === === === 
Function list($filtered : Boolean) : Collection
	
	return This:C1470.getSnippets(This:C1470.userSnippets; $filtered).push({name: "-"})\
		.combine(This:C1470.getSnippets(This:C1470.sharedSnippets; $filtered))
	
	// === === === === === === === === === === === === === === === === === === === === === 
Function getSnippets($folder : 4D:C1709.Folder; $filtered : Boolean) : Collection
	
	var $c : Collection
	
	$c:=[]
	
	If ($folder.exists)
		
		$c:=$folder.files(fk ignore invisible:K87:22)
		
		If ($filtered)
			
			$c:=$c.query("name != _@")
			
		End if 
	End if 
	
	return $c.orderBy("name")
	
	// === === === === === === === === === === === === === === === === === === === === === 
Function getFolder($parent : 4D:C1709.Folder) : 4D:C1709.Folder
	
	var $o : Object
	
	$o:=$parent.folder("KEEPIT")
	
	If (Not:C34($o.exists))
		
		// Look for an alias
		$o:=$parent.file("KEEPIT")
		
		If ($o.exists)
			
			$o:=$o.original
			
		End if 
	End if 
	
	return $o
	
	// === === === === === === === === === === === === === === === === === === === === === 
Function getMethodName() : Text
	
	var $buffer : Text
	var $pos : Integer
	
	PROCESS PROPERTIES:C336(Current process:C322; $buffer; $dummy; $dummy)
	
	$buffer:=$buffer="Macro_Call"\
		 ? Get window title:C450(Frontmost window:C447)\
		 : Get window title:C450(Next window:C448(Current form window:C827))
	
	// Delete database name as prefix if any
	$pos:=Position:C15(" - "; $buffer)
	
	If ($pos>0)
		
		$buffer:=Delete string:C232($buffer; 1; $pos+3)
		
	End if 
	
	return $buffer
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** 
Function _cleanup($code : Text) : Text
	
	var $name : Text
	var $dummy; $error : Integer
	
	PROCESS PROPERTIES:C336(Current process:C322; $name; $dummy; $dummy)
	
	// Remove keepit comments
	$error:=Rgx_SubstituteText("(/\\*[^\\*]*\\*/\\r?)"; ""; ->$code)
	
	// Ignore caret & selection if it's not a macro call
	If (Not:C34(($name="Macro_Call")))
		
		$code:=Replace string:C233($code; "<"+"caret"+"/>"; "")
		$code:=Replace string:C233($code; "<"+"selection"+"/>"; "")
		
	End if 
	
	return $code
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** 
Function _loopsAndConditions($code : Text) : Text
	
	var $line : Text
	var $isTest : Boolean
	var $counter; $i; $j : Integer
	var $isCondition
	var $c : Collection
	
	$c:=Split string:C1554($code; "\r"; sk trim spaces:K86:2)
	
	For each ($line; $c)
		
		Case of 
				
				//______________________________________________________
			: (Rgx_MatchText("^<iteration [^/]*/>.*"; $line)=0)  // <iteration/>
				
				ARRAY TEXT:C222($segments; 0x0000; 0x0000)
				
				If (Rgx_ExtractText("(<iteration(?: count=\"(\\d*)\")?/>)"; $line; ""; ->$segments)=0)
					
					$counter:=Num:C11($segments{1}{2})
					$line:=Replace string:C233($line; $segments{1}{1}; "")
					
				End if 
				
				$c[$i]:=""
				
				For ($j; 1; $counter; 1)
					
					$c[$i]+=Replace string:C233($line; "<iteration/>"; String:C10($j))+Choose:C955($j<$counter; "\r"; "")
					
				End for 
				
				//______________________________________________________
			: (Rgx_MatchText("^#_ENDIF"; $line)=0)  // ENDIF
				
				$isCondition:=False:C215
				
				$c[$i]:="/*"+$c[$i]+"*/"
				
				//______________________________________________________
			: (Rgx_MatchText("^#_ELSE"; $line)=0)  // ELSE
				
				$isTest:=Not:C34($isTest)
				
				$c[$i]:="/*"+$c[$i]+"*/"
				
				//______________________________________________________
			: (Rgx_MatchText("^#_IF"; $line)=0)  // IF
				
				$isCondition:=True:C214
				
				$isTest:={\
					eval: Formula from string:C1601("("+Replace string:C233($line; "#_IF "; "")+")")\
					}.eval()
				
				$c[$i]:="/*"+$c[$i]+"*/"
				
				//______________________________________________________
			: ($isCondition)
				
				If (Not:C34($isTest))
					
					$c[$i]:="/*"+$c[$i]+"*/"
					
				End if 
				
				//______________________________________________________
		End case 
		
		$i+=1
		
	End for each 
	
	return $c.join("\r")
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** 
Function _localize($code : Text) : Text
	
	var $lang : Text
	var $i : Integer
	var $c : Collection
	
	ARRAY TEXT:C222($src; 0)
	ARRAY TEXT:C222($tgt; 0)
	
	$c:=Split string:C1554($code; "\n")
	
	$lang:=JSON Parse:C1218(Delete string:C232($c[0]; 1; 14)).lang
	
	// Remove the attribute line and restore the code as text
	$code:=$c.remove(0).join("\r")
	
	If ($lang=This:C1470.language)
		
		// NOTHING MORE TO DO
		return $code
		
	Else 
		
		// Replace the control flow keywords with those of the current language
		If (This:C1470.language="us")
			
			COLLECTION TO ARRAY:C1562(This:C1470.resources.fr; $src)
			COLLECTION TO ARRAY:C1562(This:C1470.resources.intl; $tgt)
			
		Else 
			
			COLLECTION TO ARRAY:C1562(This:C1470.resources.intl; $src)
			COLLECTION TO ARRAY:C1562(This:C1470.resources.fr; $tgt)
			
		End if 
		
		For ($i; 1; Size of array:C274($src); 1)
			
			Rgx_SubstituteText("(?m-si)\\b("+$src{$i}+")\\b"; $tgt{$i}; ->$code)
			
		End for 
	End if 
	
	return $code
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** 
Function _ask($code : Text) : Text
	
	var $buffer; $modifier; $pattern; $request; $type : Text
	var $i; $indx; $winRef : Integer
	var $data : Object
	
	ARRAY TEXT:C222($modifiers; 0)
	ARRAY TEXT:C222($parameters; 0)
	ARRAY TEXT:C222($segments; 0; 0)
	
	$pattern:="<ask (?:message=\"([^\"]*)\")+(?: type=\"([^\"]*)\")?/>"
	
	If (Rgx_ExtractText($pattern; $code; ""; ->$segments)=0)
		
		For ($i; 1; Size of array:C274($segments); 1)
			
			$request:=$segments{$i}{1}
			
			If ($request="\\@")  // \\digit - back reference operator
				
				// Digit must be 1 or greater.
				// \1 matches the answer to the first ask, \2 the second etc.
				$request:=Substring:C12($request; 2)
				
				// #16-5-2014
				// Manage \x+ & \x- to increment/decrement the back referenced answer
				If (Rgx_MatchText("^[^+-]*([+-])*"; $request; ->$modifiers)=0)
					
					If (Size of array:C274($modifiers)=1)
						
						$modifier:=$modifiers{1}
						
					End if 
				End if 
				
				$indx:=Num:C11($request)
				
				If ($indx>0)\
					 & ($indx<=Size of array:C274($parameters))
					
					$buffer:=$parameters{$indx}
					
					Case of 
							
							//______________________________________________________
						: ($modifier="+")
							
							$buffer:=String:C10(Num:C11($buffer)+1)
							
							//______________________________________________________
						: ($modifier="-")
							
							$buffer:=String:C10(Num:C11($buffer)-1)
							
							//______________________________________________________
					End case 
					
				Else 
					
					$buffer:="<ERROR "+$buffer+" >"
					
				End if 
				
				$code:=Replace string:C233($code; $segments{$i}{0}; $buffer; 1)
				
			Else 
				
				If (Size of array:C274($segments{$i})>=2)
					
					$type:=$segments{$i}{2}
					
				End if 
				
				$data:={\
					question: $request; \
					type: $type+("text"*Num:C11(Length:C16($type)=0))\
					}
				
				$winRef:=Open form window:C675("ASK"; Movable form dialog box:K39:8; Horizontally centered:K39:1; Vertically centered:K39:4)
				DIALOG:C40("ASK"; $data)
				CLOSE WINDOW:C154
				
				If (OK=1)
					
					Case of 
							
							//______________________________________________________
						: ($data.type="text")
							
							$buffer:=String:C10($data.result)
							
							//______________________________________________________
						: ($data.type="integer")\
							 | ($data.type="real")
							
							$buffer:=String:C10(Num:C11($data.result))
							
							//______________________________________________________
						Else 
							
							$buffer:=String:C10($data.result)
							
							//______________________________________________________
					End case 
					
					// Replace element with the answer
					$code:=Replace string:C233($code; $segments{$i}{0}; $buffer; 1)
					
					// Keep the answer
					APPEND TO ARRAY:C911($parameters; $buffer)
					
				End if 
			End if 
		End for 
	End if 
	
	return $code
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** 
Function _method($code : Text) : Text
	
	var $buffer; $pattern : Text
	var $i : Integer
	
	ARRAY TEXT:C222($segments; 0; 0)
	
	$pattern:="<method>(.*?)</method>"
	
	If (Rgx_ExtractText($pattern; $code; ""; ->$segments)=0)
		
		For ($i; 1; Size of array:C274($segments); 1)
			
			$buffer:=_o_keepit_method($segments{$i}{1})
			
			$code:=Replace string:C233($code; $segments{$i}{0}; $buffer)
			
		End for 
	End if 
	
	return $code
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** 
Function _methodAttributes($code : Text) : Text
	
	var $methodPath : Text
	var $enabled : Boolean
	
	ARRAY TEXT:C222($segments; 0; 0)
	
	If (Position:C15(This:C1470.tags.methodAttribute; $code)>0)
		
		$methodPath:=Split string:C1554(This:C1470.getMethodName(); ":"; sk trim spaces:K86:2)[1]
		
		ON ERR CALL:C155("noError")
		
		While (Rgx_ExtractText("(?m-si)(<method-attribute type=\"*(\\d+)\"*(?: value=\"([^\"]+)\")\\s*/>)"; $code; ""; ->$segments)=0)
			
			$code:=Replace string:C233($code; $segments{1}{1}; "")
			
			$enabled:=True:C214  // Default is true
			
			// Get the value if any
			If (Size of array:C274($segments{1})>=3)
				
				$enabled:=($segments{1}{3}="true")
				
			End if 
			
			METHOD SET ATTRIBUTE:C1192($methodPath; Num:C11($segments{1}{2}); $enabled; *)
			
		End while 
		
		ON ERR CALL:C155("")
		
	End if 
	
	return $code
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** 
Function _selection($code : Text) : Text
	
	var $buffer : Text
	
	If (Position:C15(This:C1470.tags.selection; $code)>0)
		
		GET MACRO PARAMETER:C997(Highlighted method text:K5:18; $buffer)
		$code:=Replace string:C233($code; This:C1470.tags.selection; $buffer)
		
	End if 
	
	return $code
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** 
Function _uid($code : Text) : Text
	
	If (Position:C15(This:C1470.tags.uid; $code)>0)
		
		$code:=Replace string:C233($code; This:C1470.tags.uid; Generate UUID:C1066)
		
	End if 
	
	return $code
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** 
Function _databaseName($code : Text) : Text
	
	If (Position:C15(This:C1470.tags.databaseName; $code)>0)
		
		$code:=Replace string:C233($code; This:C1470.tags.databaseName; File:C1566(Structure file:C489(*); fk platform path:K87:2).name)
		
	End if 
	
	return $code
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** 
Function _methodType($code : Text) : Text
	
	var $buffer : Text
	var $pos; $type : Integer
	
	If (Position:C15(This:C1470.tags.methodType; $code)>0)
		
		$buffer:=This:C1470.getMethodName()
		$pos:=Position:C15(":"; $buffer)
		
		Case of 
				
				//…………………………………………………………………………………
			: (Position:C15(This:C1470.data.formMethod; $buffer)=1)
				
				$buffer:=Delete string:C232($buffer; 1; $pos+1)
				
				$type:=Choose:C955(Position:C15("["; $buffer)=1; Path table form:K72:5; Path project form:K72:3)
				
				//…………………………………………………………………………………
			: (Position:C15(This:C1470.data.trigger; $buffer)=1)
				
				$type:=Path trigger:K72:4
				
				//…………………………………………………………………………………
			: (Position:C15(This:C1470.data.method; $buffer)=1)
				
				$type:=Path project method:K72:1
				
				//…………………………………………………………………………………
			: (Position:C15(This:C1470.data.objectMethod; $buffer)=1)
				
				$buffer:=Delete string:C232($buffer; 1; $pos+1)
				
				If (Position:C15("["; $buffer)=1)
					
					$type:=Path table form:K72:5
					
					$pos:=Position:C15("]"; $buffer)
					$buffer:=Substring:C12($buffer; $pos+2)  // +2 because there is a point after the table name
					
				Else 
					
					$type:=Path project form:K72:3
					
				End if 
				
				$pos:=Position:C15("."; $buffer)
				
				If ($pos>0)\
					 && (Length:C16(Substring:C12($buffer; $pos+1))>0)
					
					$type:=8858
					
				End if 
				
				//…………………………………………………………………………………
			: (This:C1470.data.databaseMethod.indexOf($buffer)#-1)
				
				$type:=Path database method:K72:2
				
				//…………………………………………………………………………………
		End case 
		
		$code:=Replace string:C233($code; This:C1470.tags.methodType; String:C10($type; "###"))
		
	End if 
	
	return $code
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** 
Function _methodPath($code : Text) : Text
	
	var $buffer; $form; $method; $object; $table : Text
	var $pos; $type : Integer
	
	If (Position:C15(This:C1470.tags.methodPath; $code)>0)
		
		$buffer:=This:C1470.getMethodName()
		$pos:=Position:C15(":"; $buffer)
		
		Case of 
				
				//…………………………………………………………………………………
			: (Position:C15(This:C1470.data.formMethod; $buffer)=1)
				
				$buffer:=Delete string:C232($buffer; 1; $pos+1)
				
				If (Position:C15("["; $buffer)=1)
					
					$type:=Path table form:K72:5
					$pos:=Position:C15("]"; $buffer)
					$table:=Substring:C12($buffer; 1; $pos)
					$buffer:=Substring:C12($buffer; $pos+1)
					
				Else 
					
					$type:=Path project form:K72:3
					
				End if 
				
				$form:=$buffer
				
				//…………………………………………………………………………………
			: (Position:C15(This:C1470.data.trigger; $buffer)=1)
				
				$type:=Path trigger:K72:4
				$table:=Delete string:C232($buffer; 1; $pos+1)
				
				//…………………………………………………………………………………
			: (Position:C15(This:C1470.data.method; $buffer)=1)
				
				$type:=Path project method:K72:1
				$method:=Delete string:C232($buffer; 1; $pos+1)
				
				//…………………………………………………………………………………
			: (Position:C15(This:C1470.data.class; $buffer)=1)
				
				$type:=Path class:K72:19
				$method:=Delete string:C232($buffer; 1; $pos+1)
				
				//…………………………………………………………………………………
			: (Position:C15(This:C1470.data.objectMethod; $buffer)=1)
				
				$buffer:=Delete string:C232($buffer; 1; $pos+1)
				
				If (Position:C15("["; $buffer)=1)
					
					$type:=Path table form:K72:5
					$pos:=Position:C15("]"; $buffer)
					$table:=Substring:C12($buffer; 1; $pos)
					$buffer:=Substring:C12($buffer; $pos+2)  // +2 because there is a point after the table name
					
				Else 
					
					$type:=Path project form:K72:3
					
				End if 
				
				$pos:=Position:C15("."; $buffer)
				$form:=Substring:C12($buffer; 1; $pos-1)
				$object:=Substring:C12($buffer; $pos+1)
				
				//…………………………………………………………………………………
			: ($buffer=This:C1470.data.databaseMethod[0])
				
				$type:=Path database method:K72:2
				$method:="onStartup"
				
				//…………………………………………………………………………………
			: ($buffer=This:C1470.data.databaseMethod[1])
				
				$type:=Path database method:K72:2
				$method:="onServerStartup"
				
				//…………………………………………………………………………………
			: ($buffer=This:C1470.data.databaseMethod[2])
				
				$type:=Path database method:K72:2
				$method:="onExit"
				//…………………………………………………………………………………
			: ($buffer=This:C1470.data.databaseMethod[3])
				
				$type:=Path database method:K72:2
				$method:="onServerShutdown"
				
				//…………………………………………………………………………………
			: ($buffer=This:C1470.data.databaseMethod[4])
				
				$type:=Path database method:K72:2
				$method:="onServerOpenConnection"
				
				//…………………………………………………………………………………
			: ($buffer=This:C1470.data.databaseMethod[5])
				
				$type:=Path database method:K72:2
				$method:="onWebConnection"
				
				//…………………………………………………………………………………
			: ($buffer=This:C1470.data.databaseMethod[6])
				
				$type:=Path database method:K72:2
				$method:="onServerCloseConnection"
				
				//…………………………………………………………………………………
			: ($buffer=This:C1470.data.databaseMethod[7])
				
				$type:=Path database method:K72:2
				$method:="onWebAuthentication"
				
				//…………………………………………………………………………………
			: ($buffer=This:C1470.data.databaseMethod[8])
				
				$type:=Path database method:K72:2
				$method:="onBackupStartup"
				//…………………………………………………………………………………
			: ($buffer=This:C1470.data.databaseMethod[9])
				
				$type:=Path database method:K72:2
				$method:="onBackupShutdown"
				
				//…………………………………………………………………………………
			: ($buffer=This:C1470.data.databaseMethod[10])
				
				$type:=Path database method:K72:2
				$method:="onDrop"
				
				//…………………………………………………………………………………
			: ($buffer=This:C1470.data.databaseMethod[11])
				
				$type:=Path database method:K72:2
				$method:="onSqlAuthentication"
				
				//…………………………………………………………………………………
			: ($buffer=This:C1470.data.databaseMethod[12])
				
				$type:=Path database method:K72:2
				$method:="onWebSessionSuspend"
				
				//…………………………………………………………………………………
			: ($buffer=This:C1470.data.databaseMethod[13])
				
				$type:=Path database method:K72:2
				$method:="onSystemEvent"
				
				//…………………………………………………………………………………
		End case 
		
		Case of 
				
				//…………………………………………………………………………………
			: ($type=Path project method:K72:1)\
				 | ($type=Path database method:K72:2)
				
				$buffer:=METHOD Get path:C1164($type; $method; *)
				
				//…………………………………………………………………………………
			: ($type=Path project form:K72:3)
				
				$buffer:=Choose:C955(Length:C16($object)>0; METHOD Get path:C1164($type; $form; $object; *); METHOD Get path:C1164($type; $form; *))
				
				//…………………………………………………………………………………
			: ($type=Path table form:K72:5)
				
				$buffer:=Length:C16($object)>0\
					 ? METHOD Get path:C1164($type; (This:C1470._tablePtr($table))->; $form; $object; *)\
					 : METHOD Get path:C1164($type; (This:C1470._tablePtr($table))->; $form; *)
				
				//…………………………………………………………………………………
			: ($type=Path trigger:K72:4)
				
				$buffer:=METHOD Get path:C1164($type; This:C1470._tablePtr($table)->; *)
				
				//…………………………………………………………………………………
		End case 
		
		$code:=Replace string:C233($code; This:C1470.tags.methodPath; $buffer)
		
	End if 
	
	return $code
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** 
Function _methodName($code : Text) : Text
	
	var $buffer : Text
	
	If (Position:C15(This:C1470.tags.methodName; $code)>0)
		
		$buffer:=This:C1470.getMethodName()
		$code:=Replace string:C233($code; This:C1470.tags.methodName; Delete string:C232($buffer; 1; Position:C15(":"; $buffer)+1))
		
	End if 
	
	return $code
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***  
Function _time($code : Text) : Text
	
	var $buffer; $format; $pattern : Text
	var $i : Integer
	
	ARRAY TEXT:C222($segments; 0; 0)
	
	$pattern:="<time(?: format=\"([^\"]*)\")?/>"
	
	If (Rgx_ExtractText($pattern; $code; ""; ->$segments)=0)
		
		For ($i; 1; Size of array:C274($segments); 1)
			
			// Get the encoding if any
			If (Size of array:C274($segments{$i})>=1)
				
				$format:=$segments{$i}{1}
				
				If (Length:C16($format)>0)
					
					$buffer:=String:C10(Current time:C178; Num:C11($format))
					
				Else 
					
					// Default format
					$buffer:=String:C10(Current time:C178)
					
				End if 
			End if 
			
			$code:=Replace string:C233($code; $segments{$i}{0}; $buffer; 1)
			
		End for 
	End if 
	
	return $code
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** 
Function _date($code : Text) : Text
	
	var $buffer; $format; $pattern : Text
	var $i : Integer
	
	ARRAY TEXT:C222($segments; 0; 0)
	
	$pattern:="<date(?: format=\"([^\"]*)\")?/>"
	
	If (Rgx_ExtractText($pattern; $code; ""; ->$segments)=0)
		
		For ($i; 1; Size of array:C274($segments); 1)
			
			// Get the encoding if any
			If (Size of array:C274($segments{$i})>=1)
				
				$format:=$segments{$i}{1}
				
				If (Num:C11($format)>0)
					
					$buffer:=String:C10(Current date:C33; Num:C11($format))
					
				Else 
					
					Repeat 
						
						Case of 
								
								//______________________________________________________
							: ($format="y@")
								
								$buffer:=$buffer+String:C10(Year of:C25(Current date:C33))
								$format:=Substring:C12($format; 2)
								
								//______________________________________________________
							: ($format="m@")
								
								$buffer:=$buffer+String:C10(Month of:C24(Current date:C33))
								$format:=Substring:C12($format; 2)
								
								//______________________________________________________
							: ($format="d@")
								
								$buffer:=$buffer+String:C10(Day of:C23(Current date:C33))
								$format:=Substring:C12($format; 2)
								
								//______________________________________________________
							Else 
								
								CLEAR VARIABLE:C89($format)
								
								//______________________________________________________
						End case 
						
						If (Length:C16($format)>0)
							
							If (Position:C15($format[[1]]; "yma")=0)
								
								$buffer:=$buffer+$format[[1]]
								$format:=Substring:C12($format; 2)
								
							End if 
						End if 
					Until (Length:C16($format)=0)
					
					If (Length:C16($buffer)=0)
						
						$buffer:=String:C10(Current date:C33)
						
					End if 
				End if 
			End if 
			
			$code:=Replace string:C233($code; $segments{$i}{0}; $buffer; 1)
			
		End for 
	End if 
	
	return $code
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** 
Function _keepit($code : Text) : Text
	
	var $pattern : Text
	var $i : Integer
	var $o : Object
	var $c : Collection
	
	ARRAY TEXT:C222($segments; 0; 0)
	
	$c:=This:C1470.list()
	
	$pattern:="<keepit name=\"([^\"]*)\"/>"
	
	If (Rgx_ExtractText($pattern; $code; ""; ->$segments)=0)
		
		For ($i; 1; Size of array:C274($segments); 1)
			
			$o:=$c.query("name = :1"; $segments{$i}{1}).pop()
			
			If ($o#Null:C1517)
				
				$code:=Replace string:C233($code; $segments{$i}{0}; This:C1470.processing($o); 1)
				
			Else 
				
				// Put name as tag
				$code:=Replace string:C233($code; $segments{$i}{0}; "<"+$segments{$i}{1}+">"; 1)
				
			End if 
		End for 
	End if 
	
	return $code
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** 
Function _var($code : Text) : Text
	
	var $buffer; $pattern; $varName : Text
	var $i; $type : Integer
	var $ptr : Pointer
	
	ARRAY TEXT:C222($segments; 0; 0)
	
	$pattern:="<var (?:name=\"([^\"]*)\")+(?: type=\"([^\"]*)\")?/>"
	
	If (Rgx_ExtractText($pattern; $code; ""; ->$segments)=0)
		
		For ($i; 1; Size of array:C274($segments); 1)
			
			$varName:=$segments{$i}{1}
			
			// Get the value
			CLEAR VARIABLE:C89($buffer)
			$ptr:=Get pointer:C304($varName)
			
			If (Not:C34(Is nil pointer:C315($ptr)))
				
				$type:=Type:C295($ptr->)
				
				Case of 
						
						//______________________________________________________
					: ($type=Is undefined:K8:13)
						
						ALERT:C41($varName+": Undefined!")
						
						//______________________________________________________
					: ($type=Is text:K8:3)\
						 || ($type=Is string var:K8:2)
						
						$buffer:=$ptr->
						
						//______________________________________________________
					: ($type=Is integer:K8:5)\
						 || ($type=Is longint:K8:6)\
						 || ($type=Is integer 64 bits:K8:25)\
						 || ($type=Is real:K8:4)
						
						$buffer:=String:C10($ptr->)
						
						//______________________________________________________
					: ($type=Is date:K8:7)\
						 || ($type=Is time:K8:8)
						
						$buffer:=String:C10($ptr->)
						
						//______________________________________________________
					Else 
						
						ALERT:C41($varName+": non valid!")
						
						//______________________________________________________
				End case 
			End if 
			
			If (Length:C16($buffer)>0)
				
				// Replace element with the value
				$code:=Replace string:C233($code; $segments{$i}{0}; $buffer; 1)
				
			End if 
		End for 
	End if 
	
	return $code
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** 
Function _clipboard($code : Text) : Text
	
	var $buffer : Text
	
	If (Position:C15(This:C1470.tags.clipboard; $code)>0)
		
		$buffer:=Get text from pasteboard:C524
		$code:=Replace string:C233($code; This:C1470.tags.clipboard; $buffer)
		
	End if 
	
	return $code
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** 
Function _file($code : Text) : Text
	
	var $buffer; $encoding; $pattern; $url : Text
	var $i : Integer
	
	ARRAY TEXT:C222($segments; 0; 0)
	
	$pattern:="<file (?:url=\"([^\"]*)\")+(?: encoding=\"([^\"]*)\")?/>"
	
	If (Rgx_ExtractText($pattern; $code; ""; ->$segments)=0)
		
		For ($i; 1; Size of array:C274($segments); 1)
			
			$url:=$segments{$i}{1}
			
			// Get the encoding if any
			If (Size of array:C274($segments{$i})>=2)
				
				$encoding:=$segments{$i}{2}
				
			End if 
			
			$buffer:=_o_keepit_get_file($url; $encoding)
			$buffer:=$buffer+("•keepit ERROR•"*Num:C11(Length:C16($buffer)=0))
			
			$code:=Replace string:C233($code; $segments{$i}{0}; $buffer; 1)
			
		End for 
	End if 
	
	return $code
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** 
Function _localized($name : Text) : Text
	
	return String:C10(Formula from string:C1601(":C1578(\""+$name+"\")").call())
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** 
Function _tablePtr($name : Text) : Pointer
	
	var $i : Integer
	var $ptr : Pointer
	
	$name:=Replace string:C233($name; "["; "")
	$name:=Replace string:C233($name; "]"; "")
	
	For ($i; 1; Get last table number:C254)
		
		If (Is table number valid:C999($i))
			
			If (Table name:C256($i)=$name)
				
				$ptr:=Table:C252($i)
				
				break
				
			End if 
		End if 
	End for 
	
	return $ptr
	