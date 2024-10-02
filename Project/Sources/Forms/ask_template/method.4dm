_O_C_POINTER:C301($Ptr_pop)

ARRAY TEXT:C222($tTxt_type; 0x0000)

APPEND TO ARRAY:C911($tTxt_type; Localized string:C991("Typ_text"))
APPEND TO ARRAY:C911($tTxt_type; Localized string:C991("Typ_integer"))
APPEND TO ARRAY:C911($tTxt_type; Localized string:C991("Typ_real"))
APPEND TO ARRAY:C911($tTxt_type; "-")
APPEND TO ARRAY:C911($tTxt_type; Localized string:C991("Typ_table"))
APPEND TO ARRAY:C911($tTxt_type; Localized string:C991("Typ_champ"))
APPEND TO ARRAY:C911($tTxt_type; Localized string:C991("Typ_user"))
APPEND TO ARRAY:C911($tTxt_type; Localized string:C991("Typ_group"))
APPEND TO ARRAY:C911($tTxt_type; Localized string:C991("Typ_choiceList"))
APPEND TO ARRAY:C911($tTxt_type; "-")
APPEND TO ARRAY:C911($tTxt_type; Localized string:C991("Typ_previousAnswer"))

$tTxt_type:=1

$Ptr_pop:=OBJECT Get pointer:C1124(Object named:K67:5; "type")

//%W-518.1
COPY ARRAY:C226($tTxt_type; $Ptr_pop->)
//%W+518.1