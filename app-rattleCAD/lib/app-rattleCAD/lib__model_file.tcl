 ##+##########################################################################
 #
 # package: rattleCAD   ->  lib_file.tcl
 #
 #   canvasCAD is software of Manfred ROSENBERGER
 #       based on tclTk, BWidgets and tdom on their
 #       own Licenses.
 #
 # Copyright (c) Manfred ROSENBERGER, 2010/10/24
 #
 # The author  hereby grant permission to use,  copy, modify, distribute,
 # and  license this  software  and its  documentation  for any  purpose,
 # provided that  existing copyright notices  are retained in  all copies
 # and that  this notice  is included verbatim  in any  distributions. No
 # written agreement, license, or royalty  fee is required for any of the
 # authorized uses.  Modifications to this software may be copyrighted by
 # their authors and need not  follow the licensing terms described here,
 # provided that the new terms are clearly indicated on the first page of
 # each file where they apply.
 #
 # IN NO  EVENT SHALL THE AUTHOR  OR DISTRIBUTORS BE LIABLE  TO ANY PARTY
 # FOR  DIRECT, INDIRECT, SPECIAL,  INCIDENTAL, OR  CONSEQUENTIAL DAMAGES
 # ARISING OUT  OF THE  USE OF THIS  SOFTWARE, ITS DOCUMENTATION,  OR ANY
 # DERIVATIVES  THEREOF, EVEN  IF THE  AUTHOR  HAVE BEEN  ADVISED OF  THE
 # POSSIBILITY OF SUCH DAMAGE.
 #
 # THE  AUTHOR  AND DISTRIBUTORS  SPECIFICALLY  DISCLAIM ANY  WARRANTIES,
 # INCLUDING,   BUT   NOT  LIMITED   TO,   THE   IMPLIED  WARRANTIES   OF
 # MERCHANTABILITY,    FITNESS   FOR    A    PARTICULAR   PURPOSE,    AND
 # NON-INFRINGEMENT.  THIS  SOFTWARE IS PROVIDED  ON AN "AS  IS" BASIS,
 # AND  THE  AUTHOR  AND  DISTRIBUTORS  HAVE  NO  OBLIGATION  TO  PROVIDE
 # MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS.
 #
 # ---------------------------------------------------------------------------
 #  namespace:  rattleCAD::lib_file
 # ---------------------------------------------------------------------------
 #
 #

 namespace eval rattleCAD::model::file {}


    #-------------------------------------------------------------------------
        #  save File Type: xml
        #
    proc rattleCAD::model::file::check_saveCurrentProject {} {
    
            set changeIndex [rattleCAD::control::changeList::get_changeIndex]
                
			puts "\n"
			puts "  ====== s a v e   c u r r e n t   P r o j e c t  ="
			puts ""
			puts "         ... file:       [rattleCAD::control::getSession  projectFile]"
			puts "           ... saved:    [rattleCAD::control::getSession  projectSave]"
			puts "           ... modified: $changeIndex"
			
          
            if { $changeIndex > 0 } {
                set retValue [tk_messageBox -title   "Save Project" -icon question \
                            -message "... save mofificatios in Project:  [rattleCAD::control::getSession projectFile] ?" \
                            -default cancel \
                            -type    yesnocancel]
                puts "\n           ... $retValue\n"
                
                switch $retValue {
                    yes     {   saveProject_xml save
                                return  {continue}
                            }
                    no      {   return  {continue}
                            }
                    cancel  {   return  {break}
                            }
                }
            } else {
                return 0
            }
    }
    
    
    #-------------------------------------------------------------------------
        #  save File Type: xml
        #
    proc rattleCAD::model::file::newProject_xml {} {
    
                
                # -- check current Project for modification
            if {[check_saveCurrentProject] == {break}} {
                return
            }            
    
    
                # -- select File
            set types {
                    {{Project Files 3.x }       {.xml}  }
                }
                

                # set userDir        [check_user_dir rattleCAD]
            set fileName     [tk_getSaveFile -initialdir $::APPL_Config(USER_Dir) -initialfile {new_Project.xml} -filetypes $types]

            if {$fileName == {}} return
            if {! [string equal [file extension $fileName] {.xml}]} {
                set fileName [format "%s.%s" $fileName xml]
            }

                # -- read from domConfig
            set domConfig  [ rattleCAD::model::file::get_XMLContent     [file join $::APPL_Config(CONFIG_Dir) $::APPL_Config(TemplateRoad_default) ] ]
                    # 20111229 ...

                # -- set xml-File Attributes
            rattleCAD::control::setSession  projectName          [file rootname [file tail $fileName]]
            rattleCAD::control::setSession  dateModified         [clock format [clock seconds] -format {%Y.%m.%d - %H:%M:%S}]

                # -- update domConfig
            set domConfig $rattleCAD::control::currentDOM 
                #
            [$domConfig selectNodes /root/Project/rattleCADVersion/text()]  nodeValue [rattleCAD::control::getSession  rattleCADVersion]
            [$domConfig selectNodes /root/Project/Name/text()]              nodeValue [rattleCAD::control::getSession  projectName]
            [$domConfig selectNodes /root/Project/modified/text()]          nodeValue [rattleCAD::control::getSession  dateModified]

			    # -- set project meta Information
			# rattleCAD::control::setValue  Project/Name              [ file tail $fileName ]
            # rattleCAD::control::setValue  Project/modified          [ clock format [clock seconds] -format {%Y.%m.%d %H:%M} ]
            # rattleCAD::control::setValue  Project/rattleCADVersion  "$::APPL_Config(RELEASE_Version).$::APPL_Config(RELEASE_Revision)"

                # -- open File for writing
            set fp [open $fileName w]
            puts $fp [$domConfig  asXML]
            close $fp
                puts "           ... write $fileName "
                puts "                   ... done"

                # -- read new File
            set projectDOM     [rattleCAD::model::file::get_XMLContent $fileName show]
                #
            rattleCAD::control::newProject $projectDOM
			    #
                                                
                # -- window title --- ::APPL_CONFIG(PROJECT_Name) ----------
            update_windowTitle          $fileName
            update_MainFrameStatus
                #
    }


    #-------------------------------------------------------------------------
        #  open File Type: xml
        #
    proc rattleCAD::model::file::openProject_xml { {fileName {}} {windowTitle {}} } {

                # --- check current Project for modification
            if {[check_saveCurrentProject] == {break}} {
                return
            }  
            
            
            puts "\n\n  ====== o p e n   F I L E ========================\n"
            puts "         ... fileName:        $fileName"
            puts "         ... windowTitle:     $windowTitle"
            puts ""

            set types {
                    {{Project Files 3.x }       {.xml}  }
                }

                # puts "   openProject_xml - types      $types"
            if {$fileName == {}} {
                set fileName    [tk_getOpenFile -initialdir $::APPL_Config(USER_Dir) -filetypes $types]
            }

                # puts "   openProject_xml - fileName:   $fileName"
            if { [file readable $fileName ] } {
                    
                    set projectDOM        [rattleCAD::model::file::get_XMLContent $fileName show]
                    set projectVersion    [[$projectDOM selectNodes /root/Project/rattleCADVersion/text()] asXML]
                    set projectName       [[$projectDOM selectNodes /root/Project/Name/text()]             asXML]
                    set projectModified   [[$projectDOM selectNodes /root/Project/modified/text()]         asXML]       
                    
                    
                    puts "\n"
                    puts "  ========= o p e n   F I L E ====================="
                    puts ""
                    puts "         ... file:       $fileName"
                    puts "         ... version:    $projectVersion"

                      #
					rattleCAD::control::newProject $projectDOM
                      #
					  
					rattleCAD::control::setSession  projectFile       [file normalize $fileName]
                    rattleCAD::control::setSession  projectName       [file rootname [file tail $fileName]]
                    rattleCAD::control::setSession  projectSave       [clock milliseconds]
                    rattleCAD::control::setSession  dateModified      ${projectModified}
					  #
                    rattleCAD::control::changeList::reset
                      #

                      # -- window title --- ::APPL_CONFIG(PROJECT_Name) ----------
                    if {$windowTitle == {}} {
                        update_windowTitle $fileName
                    } else {
                        update_windowTitle $windowTitle
                    }

            }

              # -- fill tree
            rattleCAD::cfg_report::fillTree $rattleCAD::control::currentDOM root
			  #

              # -- update MAinFrame Indicator  
            update_MainFrameStatus
			  #
            
              #
            puts "\n"
            puts "    ------------------------"
            puts "    openProject_xml"   
            puts "            [rattleCAD::control::getSession projectFile] "
            puts "            [rattleCAD::control::getSession projectName] "
            puts "        ... done"             
            puts "\n  ====== o p e n  F I L E =========================\n\n"
    }


    #-------------------------------------------------------------------------
        #  open Template File Type: xml
        #
    proc rattleCAD::model::file::openTemplate_xml {type} {
            
                # --- check current Project for modification
            if {[check_saveCurrentProject] == {break}} {
                return
            }  
            
            
            puts "\n"
            puts "  ====== o p e n   T E M P L A T E ================"
            puts "         ... type:    $type"
            set template_file    [ getTemplateFile $type ]
            puts "         ... template_file:   $template_file"
            
            # puts "\n   -> FrameTubes/ChainStay/CenterLine/angle_03:  [rattleCAD__model__getValue FrameTubes/ChainStay/CenterLine/angle_03]"
            # puts "\n   -> FrameTubes/ChainStay/CenterLine/angle_04:  [rattleCAD__model__getValue FrameTubes/ChainStay/CenterLine/angle_04]"
            # puts "\n   -> FrameTubes/ChainStay/CenterLine/radius_01: [rattleCAD__model__getValue FrameTubes/ChainStay/CenterLine/radius_01]"

            
            
            if { [file readable $template_file ] } {
                set projectDOM     [rattleCAD::model::file::get_XMLContent $template_file show]
                    #
                rattleCAD::control::newProject $projectDOM
				    #
                rattleCAD::control::setSession  projectFile       "Template $type"
                rattleCAD::control::setSession  projectName       "Template $type"
                rattleCAD::control::setSession  projectSave       [expr 2 * [clock milliseconds]]
                rattleCAD::control::setSession  dateModified      "template"
                    #
                rattleCAD::control::changeList::reset
                    #

                    #
                update_windowTitle       [rattleCAD::control::getSession projectName]
                update_MainFrameStatus
                    #
            } else {
                tk_messageBox -message "... could not load template: $window_title"
            }

            
                # -- fill tree
                #
            rattleCAD::cfg_report::fillTree $rattleCAD::control::currentDOM root
			    #
    }


    #-------------------------------------------------------------------------
        #  save File Type: xml
        #
    proc rattleCAD::model::file::saveProject_xml { {mode {save}} {type {Road}} } {

                # --- select File
            set types {
                    {{Project Files 3.x }       {.xml}  }
                }



            puts "\n\n  ====== s a v e  F I L E =========================\n"


                # set userDir       [check_user_dir rattleCAD]
            if  {[rattleCAD::control::getSession  projectFile] != {}} {
                set initialFile [file tail      [rattleCAD::control::getSession  projectFile]]
                set initialDir  [file dirname   [rattleCAD::control::getSession  projectFile]]
            } else {
                set initialFile "... empty"
                set initialDir  "... empty"
            }
                puts "       ... saveProject_xml - mode:            \"$mode\""
                puts "       ... saveProject_xml - USER_Dir:        \"$::APPL_Config(USER_Dir)\""
                puts "       ... saveProject_xml - PROJECT_File:    \"[rattleCAD::control::getSession  projectFile]\""
                puts "       ... saveProject_xml - PROJECT_Name:    \"[rattleCAD::control::getSession  projectName]\""
                puts "       ... saveProject_xml - ... initialFile:     \"$initialFile\""
                puts "       ... saveProject_xml - ... initialDir:      \"$initialDir\""

                # default - values

            switch -exact $mode {
                {save}          {   set windowTitle     $initialFile
                                    set requestTemplate {no}
                                    switch -exact $initialFile {
                                        {Template Road} {   set requestTemplate    {yes}
                                                            set initialFile        [format "%s%s.xml" $::APPL_Config(USER_InitString) Road]
                                                        }
                                        {Template MTB}  {   set requestTemplate    {yes}
                                                            set initialFile        [format "%s%s.xml" $::APPL_Config(USER_InitString) MTB ]
                                                        }
                                        default         {}
                                    }
                                    if {$requestTemplate == "yes"} {
                                        set retValue [tk_messageBox -title   "Save Project" -icon question \
                                                                    -message "Save Project as Template: $initialFile?" \
                                                                    -default cancel \
                                                                    -type    yesnocancel]
                                        puts "\n      $retValue\n"

                                        switch $retValue {
                                            yes     {   rattleCAD::control::setSession  projectFile [file join $::APPL_Config(USER_Dir) $initialFile ]
                                                    }
                                            no      {   set mode        saveAs
                                                        set initialFile {new_Project.xml}
                                                    }
                                            cancel  {   return }
                                        }

                                    }
                                }


                default            {
                                    switch -exact $initialFile {
                                        {Template Road} -
                                        {Template MTB}  {   set mode         saveAs
                                                            set initialFile {new_Project.xml}
                                                        }
                                        default         {}
                                    }
                                }
            }

                puts "       ---------------------------"
                puts "       ... saveProject_xml - mode:                \"$mode\""
                puts "       ... saveProject_xml - ... initialFile:     \"$initialFile\""


            switch $mode {
                {save}        {
								set fileName    [file normalize [rattleCAD::control::getSession  projectFile]]
                            }
                {saveAs}    {
                                set fileName    [tk_getSaveFile -initialdir $::APPL_Config(USER_Dir) -initialfile $initialFile -filetypes $types]
                                    puts "       ... saveProject_xml - fileName:        $fileName"
                                    # -- $fileName is not empty
                                if {$fileName == {} } return
                                    # -- $fileName has extension xml
                                        # puts " [file extension $fileName] "
                                if {! [string equal [file extension $fileName] {.xml}]} {
                                    set fileName [format "%s.%s" $fileName xml]
                                    puts "           ... new $fileName"
                                }

                                    # --- set runtime Attributes
                                rattleCAD::control::setSession  projectFile       [file normalize $fileName]
                                rattleCAD::control::setSession  projectName       [file rootname [file tail $fileName]]

                                    # --- set window Title
                                set windowTitle    $fileName
                            }
                default     {    return}
            }

			    # -- set project meta Information                
            rattleCAD::control::setSession  projectFile       [file normalize $fileName]
            rattleCAD::control::setSession  projectSave       [clock milliseconds]]
            rattleCAD::control::setSession  dateModified      [clock format [clock seconds] -format {%Y.%m.%d - %H:%M:%S}]
                    #
 
                # -- update domConfig
            set domConfig $rattleCAD::control::currentDOM 
                #
            [$domConfig selectNodes /root/Project/rattleCADVersion/text()]  nodeValue [rattleCAD::control::getSession  rattleCADVersion]
            [$domConfig selectNodes /root/Project/Name/text()]              nodeValue [rattleCAD::control::getSession  projectName]
            [$domConfig selectNodes /root/Project/modified/text()]          nodeValue [rattleCAD::control::getSession  dateModified]
                #
                
                #set domConfig  [ rattleCAD::model::file::get_XMLContent     [file join $::APPL_Config(CONFIG_Dir) $::APPL_Config(TemplateRoad_default) ] ]
                    # 20111229 ...

                # -- set xml-File Attributes
            #[ $domConfig selectNodes /root/Project/Name/text()              ]   nodeValue   [ file tail $fileName ]
            #[ $domConfig selectNodes /root/Project/modified/text()          ]   nodeValue   [ clock format [clock seconds] -format {%Y.%m.%d %H:%M} ]
            #[ $domConfig selectNodes /root/Project/rattleCADVersion/text()  ]   nodeValue   "$::APPL_Config(RELEASE_Version).$::APPL_Config(RELEASE_Revision)"

            puts ""
            puts "            -> [rattleCAD::control::getSession  rattleCADVersion]"
            puts "            -> [rattleCAD::control::getSession  projectName]"
            puts "            -> [rattleCAD::control::getSession  dateModified]"
            puts ""
                    
           
                # -- open File for writing
            if {[file exist $fileName]} {
                if {[file writable $fileName]} {
                    set fp [open $fileName w]
                    puts $fp [$domConfig  asXML]
                    close $fp
                    puts ""
                    puts "         -- update ----------------------"
                    puts "           ... write:"   
                    puts "                       $fileName"
                    puts "                   ... done"
                } else {
                tk_messageBox -icon error -message "File: \n   $fileName\n  ... not writeable!"
                saveProject_xml saveAs
                }
            } else {
                    set fp [open $fileName w]
                    puts $fp [$domConfig  asXML]
                    close $fp
                    puts ""
                    puts "         -- new--------------------------"
                    puts "           ... write:"  
                    puts "                       $fileName "
                    puts "                   ... done"
            }

                #
                # set ::APPL_Config(PROJECT_Save) [clock milliseconds]
            rattleCAD::control::setSession  projectSave       [clock milliseconds]
                #
				
                # -- window title --- ::APPL_CONFIG(PROJECT_Name) ----------
            update_windowTitle           $windowTitle
            update_MainFrameStatus
                #
            
                #
            puts "\n"
            puts "    ------------------------"
            puts "    saveProject_xml"     
            puts "            [rattleCAD::control::getSession  projectFile]"
            puts "        ... done"

            puts "\n  ====== s a v e  F I L E =========================\n\n"
    }


    #-------------------------------------------------------------------------
        #  open a File, containing just a subset of a Project-xml
        #
    proc rattleCAD::model::file::openProject_Subset_xml {{fileName {}}} {
                #
            set types {
                {{Project Files 3.x }       {.xml}  }
            }
                #
            if {$fileName == {}} {
                set fileName    [tk_getOpenFile -title "Import" -initialdir $::APPL_Config(USER_Dir) -filetypes $types]
            } else {
                return
            }
            
                #
			set content [rattleCAD::model::file::get_XMLContent $fileName]
            rattleCAD::control::importSubset $content
                # 
			
                #
            rattleCAD::control::changeList::reset
                #
            
                # -- fill tree
            rattleCAD::cfg_report::fillTree $rattleCAD::control::currentDOM root
                #

    }


    #-------------------------------------------------------------------------
        #  ... renamed from openFile_xml to get_XMLContent  2012.07.29
        #
    proc rattleCAD::model::file::get_XMLContent {{file {}} {show {}}} {

            set types {
                    {{xml }       {.xml}  }
                }
            if {$file == {} } {
                set file [tk_getOpenFile -initialdir $::APPL_Config(USER_Dir) -filetypes $types]
            }
                # -- $fileName is not empty
            if {$file == {} } return

            set fp [open $file]

            fconfigure    $fp -encoding utf-8
            set xml [read $fp]
            close         $fp

            set doc  [dom parse  $xml]
            set root [$doc documentElement]

                #
                # -- fill tree
                #
            if {$show != {}} {
                # rattleCAD::cfg_report::fillTree "$root" root
            }

                #
                # -- return root  document
                #
            return $root
    }


    #-------------------------------------------------------------------------
       #  open web URL
       #
    proc rattleCAD::model::file::open_URL {url {mimeType {}}} {
            osEnv::open_by_mimeType_DefaultApp  $url $mimeType
            return
    }


    #-------------------------------------------------------------------------
       #  open File by OS - Definition
       #
    proc rattleCAD::model::file::open_localFile {fileName} {
            osEnv::open_by_mimeType_DefaultApp  $fileName
            return
    }


    #-------------------------------------------------------------------------
       #  open File by Extension
       #
    proc rattleCAD::model::file::openFile_byExtension {fileName {altExtension {}}} {
            osEnv::open_by_mimeType_DefaultApp $fileName $altExtension          
            return
    }



    #-------------------------------------------------------------------------
        #  get user project directory
        #
    proc rattleCAD::model::file::check_user_dir {checkDir} {

            # changed since 3.2.78.03

                # thanks to:  http://wiki.tcl.tk/3834
            if { [expr [string compare "$::tcl_platform(platform)" "windows" ] == 0] } {
                    set homeDir_Request [registry get {HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders} {Personal}]
                    set stringMapping [list {%USERPROFILE%} $::env(USERPROFILE)]
                    set homeDir_Request [string map $stringMapping $homeDir_Request]
                      # puts "  ... -> \$homeDir_Request $homeDir_Request"
                    set homeDir [file normalize $homeDir_Request]
                      # puts "  ... -> \$homeDir $homeDir"
                      # tk_messageBox -message "  ... -> \$homeDir $homeDir"
                      # puts "  ... -> \$homeDir $homeDir"
            } else {
                    set homeDir $::env(HOME)
            }
                # and now the the directory to check for
            set checkDir [file join $homeDir $checkDir]

            if {[file exists $checkDir]} {
                if {[file isdirectory $checkDir]} {
                    set checkDir $checkDir
                        # puts  "         check_user_dir:  $checkDir"
                } else {
                    tk_messageBox -title   "Config ERROR" \
                                  -icon    error \
                                  -message "There is a file \n   ... $checkDir\n     should be ad directory\n\n  ... please remove file"
                    return
                }
            } else {
                file mkdir $checkDir
            }

            return [file normalize $checkDir]
    }


    #-------------------------------------------------------------------------
       #  summ up ps-Files and create pdf
       #
    proc rattleCAD::model::file::create_summaryPDF {exportDir {postEvent {open}}} {
                #
            puts "\n"
            puts  "    ------------------------------------------------"
            puts  "      create_summaryPDF: "
            puts  "         ... $exportDir"
            puts  ""
                #
            set ps_Dict     [collect_Data       $exportDir]
                #
            set pdf_files   [create_batchFile   $ps_Dict] 
                #
                #
            if {$postEvent == {open}} {
                puts "\n\n\n"
                puts "    ------------------------------------------------"
                foreach pdfFile $pdf_files {
                    puts "\n"
                    puts "      ... open $pdfFile"
                        # catch {rattleCAD::model::file::openFile_byExtension "$pdfFile"}
                    catch {osEnv::open_by_mimeType_DefaultApp "$pdfFile"}
                }
            }
            puts "    ------------------------------------------------"
            puts ""
                #
                #
            return 
    }

    proc rattleCAD::model::file::collect_Data {exportDir} {
                #
                #-------------------------------------------------------------------------
                # check ghostscript installation
                #
            set ghostScript [osEnv::get_Executable gs]   
                # puts "    -> \$ghostScript $ghostScript"
            if {$ghostScript == {}} {
                tk_messageBox -title "PDF Export" -message "Ghostscript Error:\n     ... could not initialize ghostScript installation" -icon warning
                return
            }  
                #
                #-------------------------------------------------------------------------
                # create dictionary
                #
            set ps_Dict   [dict create \
                                exportDir   $exportDir \
                                ghostScript $ghostScript \
                                fileFormat  {} ]
                #
                #-------------------------------------------------------------------------
                # get_file_Info
                #
            set psFiles [glob -directory $exportDir *.ps]
                #
            foreach psFile $psFiles {
                    # puts "\n ------------------------"
                puts "            ... $psFile"
                    # puts "         ... [file tail $psFile]"
                set fp [open $psFile r]
                set file_data [read $fp]
                close $fp
                    #
                    # Process data file
                set data [split $file_data "\n"]
                foreach line $data {
                    set searchString {%%BoundingBox: }
                    if {[string equal  -length [string length $searchString] $line $searchString] } {
                            # puts "   ... $searchString [string length $searchString]"
                            # puts "   ... $line"
                        set values [split [string range  $line [string length $searchString] end] ]
                            # puts "      -> $values"
                        foreach {y0 x0 y1 x1} $values break
                            # puts "        -> $x0 $y0"
                            # puts "        -> $x1 $y1"
                        set pageWidth     [expr $x1 - $x0]
                        set pageHeight    [expr $y1 - $y0]
                            # puts "        -> $pageWidth x $pageHeight"
                            # puts "\n"
                    }
                        #
                    if {[string equal  $line {%%EndComments}]} break
                        #
                }
                    # puts "  <I>  \$formatString $formatString"
                    #
                set   fd [open $psFile "r"]
                    #
                gets $fd psAttribute(first)    
                gets $fd psAttribute(second)    
                gets $fd psAttribute(third)   
                    # puts " <i> $getLine(first)"
                    # puts " <i> $getLine(second)"
                    # puts " <i> $getLine(third)"
                close $fd 
                    #
                set format [lindex [split $psAttribute(second)] end]
                set orient [lindex [split $psAttribute(third)]  end]
                    #
                set formatString [format "%s_%s" $format $orient]      
                    #        
                set keyName   [file rootname [file tail $psFile]]
                set attrList  [list x0 $x0 \
                                    y0 $y0 \
                                    x1 $x1 \
                                    y1 $y1 \
                                    pageWidth  $pageWidth \
                                    pageHeight $pageHeight \
                                    dinFormat  $format \
                                    orient     $orient]
                    #
                if {![dict exists $ps_Dict fileFormat $formatString]} {
                        # puts "   ... $formatString missing"
                    dict set ps_Dict fileFormat $formatString [dict create $keyName $attrList]
                } else {
                        # puts "   ... $formatString exists"
                    dict set ps_Dict fileFormat  $formatString $keyName $attrList
                }
            }
                #
            return $ps_Dict
                #
    }


    #-------------------------------------------------------------------------
       #  summ up ps-Files and create pdf
       #
    proc rattleCAD::model::file::create_batchFile {ps_Dict} { 
                # 
            set exportDir       [dict get $ps_Dict  exportDir] 
            set ghostScript     [dict get $ps_Dict  ghostScript] 
                #
            set pdf_fileList {}
                #
            foreach fileFormat [dict keys [dict get $ps_Dict fileFormat]] {
                puts "\n"
                puts "    ------------------------------------------------"
                puts "        ... $fileFormat"
                    #
                set fileString {}
                foreach fileKey [dict keys [dict get $ps_Dict fileFormat $fileFormat]] {
                    puts "         ... $fileKey"   
                    set inputFile   [file nativename [file join $exportDir $fileKey.ps]]
                    append fileString " " \"$inputFile\"
                }        
                    #
                    #
                foreach fileKey [dict keys [dict get $ps_Dict fileFormat $fileFormat]] {
                        # puts "         ... $fileKey"
                    set x0          [dict get $ps_Dict fileFormat $fileFormat $fileKey x0]
                    set y0          [dict get $ps_Dict fileFormat $fileFormat $fileKey y0]
                    set pageWidth   [dict get $ps_Dict fileFormat $fileFormat $fileKey pageWidth]
                    set pageHeight  [dict get $ps_Dict fileFormat $fileFormat $fileKey pageHeight]
                    set dinFormat   [dict get $ps_Dict fileFormat $fileFormat $fileKey dinFormat]
                    set orient      [dict get $ps_Dict fileFormat $fileFormat $fileKey orient]
                    set offSet_X    [expr int (-1 * $x0)]
                    set offSet_Y    [expr int (-1 * $y0)]
                        # puts "       ... \$pageWidth  $pageWidth"
                        # puts "       ... \$pageHeight $pageHeight"
                        # puts "       ... \$offSet_X   $offSet_X"
                        # puts "       ... \$offSet_Y   $offSet_Y"
                        # set pg_Offset   [format "<</PageOffset \[%i %i\]>> setpagedevice" $offSet_Y $offSet_X]
                }
                    #
                set fileName    [rattleCAD::control::getSession projectName]
                set fileName    [string map {{ } _ {.xml} {}} $fileName]
                set fileName    [format "%s_%s.pdf" $fileName $fileFormat]
                set outputFile  [file nativename [file join $exportDir $fileName]]
                    #
                    # -- create batch Files
                    #                
                set batchFileName   "summary_$fileFormat"
                set pg_PaperSize    [format "PAPERSIZE#%s" [string tolower $dinFormat]]
                set pg_Format       [format "%sx%s"  [expr 10 * $pageHeight] [expr 10 * $pageWidth]]
                switch $orient {
                    portrait { set pg_Orient true }
                    landscape -
                    default  { set pg_Orient false }
                }
                set pg_Format       [format "%sx%s"  [expr 10 * $pageHeight] [expr 10 * $pageWidth]]
                    #
                    #
                    # -- windows batch-file
                    #
                set batchFile   [file join $exportDir ${batchFileName}.bat]
                    #
                set fileId [open $batchFile "w"]
                puts $fileId "\"[file nativename $ghostScript]\" ^"
                puts $fileId " -sDEVICE=pdfwrite ^"
                puts $fileId " -s$pg_PaperSize ^"
                puts $fileId " -sOutputFile=\"$outputFile\" ^"
                    # puts $fileId " -c \"$pg_Offset\" ^"
                    # puts $fileId " -g$pg_Format ^"
                puts $fileId " -dNOPAUSE ^"
                    # puts $fileId " -dORIENT1=$pg_Orient ^"
                puts $fileId " -dBATCH ^"
					#
                    #
                foreach fileKey [dict keys [dict get $ps_Dict fileFormat $fileFormat]] {
                      # puts "         ... $fileKey"   
                    set inputFile   [file nativename [file join $exportDir $fileKey.ps]]
                      # append fileString " " \"$inputFile\"
                    puts $fileId "       \"$inputFile\" ^"
                      # puts -nonewline $fileId " -dBATCH $fileString "
                }
                close $fileId
                    #
                    #
                    # -- unix shell script
                    #
                set batchFile   [file join $exportDir ${batchFileName}.sh]
                    #
                set fileId [open $batchFile "w"]
                puts $fileId "\"[file nativename $ghostScript]\" \\"
                puts $fileId " -sDEVICE=pdfwrite \\"
                puts $fileId " -s$pg_PaperSize \\"
                puts $fileId " -sOutputFile=\"$outputFile\" \\"
                    # puts $fileId " -c \"$pg_Offset\" ^"
                    # puts $fileId " -g$pg_Format \\"
                puts $fileId " -dNOPAUSE \\"
                    # puts $fileId " -dORIENT1=$pg_Orient \\"
                puts $fileId " -dBATCH \\"
                    #
                    #
                foreach fileKey [dict keys [dict get $ps_Dict fileFormat $fileFormat]] {
                        # puts "         ... $fileKey"   
                    set inputFile   [file nativename [file join $exportDir $fileKey.ps]]
                        # append fileString " " \"$inputFile\"
                    puts $fileId "       \"$inputFile\" \\"
                        # puts -nonewline $fileId " -dBATCH $fileString "
                }
                close $fileId                
                    #
                    #
                switch  "$::tcl_platform(platform)" {
                    {windows} {
                            set batchFile   [file join $exportDir ${batchFileName}.bat]
                            if {[catch {exec $batchFile} fid]} {
                                tk_messageBox -title "rattleCAD - Warning" -icon warning \
                                      -message "could not create pdf-File\n  $outputFile\n\n ... maybe it is still opened by an application"  
                            } else {
                                 lappend pdf_fileList [file normalize $outputFile]
                            }
                        }
                    default {
                            set batchFile   [file join $exportDir ${batchFileName}.sh]
                            set shellCMD [osEnv::get_Executable sh]
                            if {[catch {exec $shellCMD $batchFile} fid]} {
                                tk_messageBox -title "rattleCAD - Warning" -icon warning \
                                      -message "could not create pdf-File\n  $outputFile\n\n ... maybe it is still opened by an application"  
                            } else {
                                 lappend pdf_fileList [file normalize $outputFile]
                            }
                        }
                }
            }        
                #
            return $pdf_fileList    
                #

    }

 
    #-------------------------------------------------------------------------
        #  ...
        #
    proc rattleCAD::model::file::getTemplateFile {type} {

            set TemplateRoad    [file join $::APPL_Config(USER_Dir) [format "%s%s.xml" $::APPL_Config(USER_InitString) Road] ]
            set TemplateMTB     [file join $::APPL_Config(USER_Dir) [format "%s%s.xml" $::APPL_Config(USER_InitString) MTB ] ]

            switch -exact $type {
                    {Road} {    if {[file exists $TemplateRoad ]} {
                                    return $TemplateRoad
                                } else {
                                    return $::APPL_Config(TemplateRoad_default)
                                }
                            }
                    {MTB} {     if {[file exists $TemplateMTB ]} {
                                    return $TemplateMTB
                                } else {
                                    return $::APPL_Config(TemplateMTB_default)
                                }
                            }
                    default {   return {}
                            }
                }

    }


    #-------------------------------------------------------------------------
        # http://stackoverflow.com/questions/429386/tcl-recursively-search-subdirectories-to-source-all-tcl-files
        # 2010.10.15
    proc rattleCAD::model::file::findFiles { basedir pattern } {
                    # Fix the directory name, this ensures the directory name is in the
                    # native format for the platform and contains a final directory seperator
            set basedir [string trimright [file join [file normalize $basedir] { }]]
            set fileList {}
                    # Look in the current directory for matching files, -type {f r}
                    # means ony readable normal files are looked at, -nocomplain stops
                    # an error being thrown if the returned list is empty
            foreach fileName [glob -nocomplain -type {f r} -path $basedir $pattern] {
                lappend fileList $fileName
            }
                    # Now look for any sub direcories in the current directory
            foreach dirName [glob -nocomplain -type {d  r} -path $basedir *] {
                        # Recusively call the routine on the sub directory and append any
                        # new files to the results
                set subDirList [findFiles $dirName $pattern]
                if { [llength $subDirList] > 0 } {
                    foreach subDirFile $subDirList {
                        lappend fileList $subDirFile
                    }
                }
            }
            return $fileList
    }


    #-------------------------------------------------------------------------
        # component alternatives
        #
    proc rattleCAD::model::file::get_componentAlternatives {key} {

            set directory    [lindex [array get ::APPL_CompLocation $key ] 1 ]
                        # puts "     ... directory  $directory"
            if {$directory == {}} {
                        # tk_messageBox -message "no directory"
                puts "    -- <E> -------------------------------"
                puts "         ... no directory configured for"
                puts "               $key"
                    # parray ::APPL_CompLocation
                puts "    -- <E> -------------------------------"
                return {}
            }

            set userDir     [file join $::APPL_Config(USER_Dir)         $directory ]
            set etcDir      [file normalize [file join $::APPL_Config(COMPONENT_Dir) .. $directory]]
                        # puts "            user: $userDir"
                        # puts "            etc:  $etcDir"


            
            catch {
                foreach file [ glob -directory $userDir  *.svg ] {
                        # puts "     ... fileList: $file"
                        # puts "                 : $::APPL_Config(USER_Dir)/"
                    set fileString [ string map [list $::APPL_Config(USER_Dir)/components/ {user:} ] $file ]
                        # puts "                 : $fileString"
                    set listAlternative   [ lappend listAlternative $fileString]
                }
            }
            foreach file [ glob -directory $etcDir  *.svg ] {
                        # puts "     ... fileList: $file"
                    set mapString [file normalize $::APPL_Config(COMPONENT_Dir)]
                        # puts "                 : $mapString/"
                    set fileString [ string map [list $mapString/ {etc:} ] $file ]
                        # puts "                 : $fileString"
                    set listAlternative   [ lappend listAlternative $fileString]
            }


                # ------------------------
                #     some components are not neccessary at all
            switch -exact $key {
                    Component(Derailleur/File)  {
                            set listAlternative [lappend listAlternative {etc:default_blank.svg} ]
                    }
            }


            return $listAlternative

    }




