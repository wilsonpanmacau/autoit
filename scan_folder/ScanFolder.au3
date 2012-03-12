#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.6.1
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
; 20120306 �쪩 ���� scan folder �� ini ���榡

;[scan1]
;scandir=.\scan_path			; ���˪��ؿ��A .\���ܬO script�Ҧb����m�A���M�N�� d:\abc\scan_folder
;file_ext=txt				; ���˪����ɦW
;content_format=				; �|���ϥΡA�o�O�Ψ��ˬd���˨쪺���e���S���ŦX�w�q���榡
;omit_ext=bak;au3;ini  			; �|���ϥΡA�o�O�Ψӫ��w���B�z���榡�C
;action_path=.\action_path		; �����������ɩҫ��w����ƪ����|�A�N�O�ثe���˨쪺�ɮסC
;action=notepad.exe			; �����������ɪ��ɦW�A�̦n�a�ۧ��㪺���|
;move_path=.\move_path		; ���˨쪺�ɮ׳ƥ����ʪ����|
;netdrive=					; �p�G�O�ƨ������W���@�κϺо��A�Хܧ��㪺 mount ���ѼơC�Ҧp k:;\\192.168.3.45\downloading;administrator;987654321
;remote_pc_dir=\\192.168.1.32\c$\apps

; �٭n�A�ϥ� pstools �Ӷi�滷�� PC �{�����ҰʡC



#include<array.au3>
#include<file.au3>
dim $sec=@SEC
dim $min=@MIN
Dim $hour=@HOUR
Dim $day=@MDAY
Dim $month=@MON
DIM $year=@YEAR
dim $today=$year & $month & $day

$delay=1000*10
$section = IniReadSectionNames(@ScriptDir&"\scanfolder.ini")
If @error Then 
    MsgBox(4096, "", "Error occurred, probably no INI file.")
	Exit

EndIf

;_ArrayDisplay($section)
$parameter_try=IniReadSection(@ScriptDir&"\scanfolder.ini", $section[1])
;MsgBox(0,"parameter_length", $parameter_try[0][0])
dim $scan_parameter_array [$section[0]+1][ $parameter_try[0][0] +1] 




for $x=1 to $section[0]
	
	$var = IniReadSection(@ScriptDir&"\scanfolder.ini", $section[$x])
	;_ArrayDisplay($var)
	
	If @error Then 
		MsgBox(4096, "", "Error occurred, probably no INI file.")
	Else
		
		
		For $i = 1 To $var[0][0]
			;MsgBox(4096, "", "Key: " & $var[$i][0] & @CRLF & "Value: " & $var[$i][1])
			
				$scan_parameter_array[$x][$i]= _at_script_dir ( $var[$i][1] )
			
		Next
		;_ArrayDisplay($scan_parameter_array)
		;_scanfolder($var)
	EndIf
next

;_ArrayDisplay($scan_parameter_array)
;MsgBox(0,"scan_parameter length", UBound($scan_parameter_array) )
dim $sub_array[ $var[0][0] +1]
while 1 
	for $a=1 to UBound($scan_parameter_array)-1
		
		for $b=1 to $var[0][0]	
			;MsgBox(0,"$scan_parameter_array[$a][$b]: " & $a &" "& $b , $scan_parameter_array[$a][$b])
			$sub_array[$b]=$scan_parameter_array[$a][$b]
		Next
			;_ArrayDisplay($sub_array)
			_scanfolder ($sub_array)
	next	
	sleep($delay)
WEnd

Exit





Func _scanfolder ($ini_array)
	;_ArrayDisplay($ini_array)

	local  $scandir, $file_ext,$content_format,$omit_ext,$action_path,$action,$move_path,$netdrive, $remote_dir
	local $mount_info
	
	$scandir= $ini_array[1]  
	$file_ext=$ini_array[2]
	$content_format=$ini_array[3]   ; Not apply now
	$omit_ext=$ini_array[4]
	$action_path= $ini_array[5]
	$action=$ini_array[6]  			
	$move_path=  $ini_array[7]
	$netdrive=$ini_array[8]
	$remote_dir=$ini_array[9]
	;MsgBox(0,"Scan folder: " , "Scan folder: " & $scandir , 5)
	
	if $scandir='' then return
	if $netdrive<>"" then 
	$mount_info=StringSplit($netdrive,";")	
		if not FileExists($mount_info[1]) then DriveMapAdd($mount_info[1],$mount_info[2],0,$mount_info[3],$mount_info[4])
	EndIf
	
	;MsgBox(0,"Scan folder:", $scandir&"\*."&$file_ext & @CRLF & "Run : " & $action & " at " & $action_path, 5)
	if FileExists($scandir&"\*."&$file_ext) then 
		
		filecopy($scandir&"\*."&$file_ext, $action_path,9) 	
		sleep(1000)
		run ($action)
		_FileWriteLog(@ScriptDir&"\"&StringTrimRight(@ScriptName,4)&"_"&$year&$month&$day&".log"," �b "& $scandir &" �U�� " & $file_ext & " �ɮײ��ʨ� " & $action_path  )
		;Run(@ComSpec & " /c " & 'commandName', "", @SW_HIDE) 
		if  FileExists($scandir&"\*."&$file_ext) then FileMove($scandir&"\*."&$file_ext,$move_path,9)
		
	EndIf	



EndFunc


func _at_script_dir($path)
	local $script_dir=@ScriptDir
	if StringInStr ( $path,".\") then 
	
	$path=StringReplace($path, ".\" ,$script_dir& "\" )
	;MsgBox(0,"_at_script_dir()   func", $path)
	EndIf
	Return $path
EndFunc