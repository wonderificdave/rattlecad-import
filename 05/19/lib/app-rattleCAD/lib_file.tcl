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

 namespace eval lib_file {


    #-------------------------------------------------------------------------
        #  save File Type: xml
        #
    proc newProject_xml {} {
                # --- select File
            set types {
                    {{Project Files 3.x }       {.xml}  }
                }

                # set userDir        [check_user_dir rattleCAD]
            set fileName     [tk_getSaveFile -initialdir $::APPL_Env(USER_Dir) -initialfile {new_Project.xml} -filetypes $types]

            if {$fileName == {}} return
            if {! [string equal [file extension $fileName] {.xml}]} {
                set fileName [format "%s.%s" $fileName xml]
            }

                # -- read from domConfig
            set domConfig  [ lib_file::get_XMLContent     [file join $::APPL_Env(CONFIG_Dir) $::APPL_Env(TemplateRoad_default) ] ]
                    # 20111229 ...

                # --- set xml-File Attributes
            [ $domConfig selectNodes /root/Project/Name/text()              ]   nodeValue   [ file tail $fileName ]
            [ $domConfig selectNodes /root/Project/modified/text()          ]   nodeValue   [ clock format [clock seconds] -format {%Y.%m.%d %H:%M} ]
            [ $domConfig selectNodes /root/Project/rattleCADVersion/text()  ]   nodeValue   "$::APPL_Env(RELEASE_Version).$::APPL_Env(RELEASE_Revision)"

            # maybe new
                set project::Project(Name)              [ file tail $fileName ]
                set project::Project(modified)          [ clock format [clock seconds] -format {%Y.%m.%d %H:%M} ]
                set project::Project(rattleCADVersion)  "$::APPL_Env(RELEASE_Version).$::APPL_Env(RELEASE_Revision)"

                # -- open File for writing
            set fp [open $fileName w]
            puts $fp [$domConfig  asXML]
            close $fp
                puts "           ... write $fileName "
                puts "                   ... done"

                # -- read new File
            set ::APPL_Env(root_ProjectDOM) [lib_file::get_XMLContent $fileName show]
                #
            frame_geometry::set_base_Parameters $::APPL_Env(root_ProjectDOM)
                # -- window title --- ::APPL_CONFIG(PROJECT_Name) ----------
            set_window_title $fileName
                #
            lib_gui::notebook_updateCanvas
                #
            lib_gui::open_configPanel  refresh

    }


    #-------------------------------------------------------------------------
        #  open File Type: xml
        #
    proc openProject_xml { {windowTitle {}} {fileName {}} } {

            puts "\n\n  ====== o p e n   F I L E ========================\n"
            puts "         ... fileName:        $fileName"
            puts "         ... windowTitle:     $windowTitle"
            puts ""

            set types {
                    {{Project Files 3.x }       {.xml}  }
                }
                # set userDir       $::APPL_Env(USER_Dir)
                # puts "   openProject_xml - types      $types"
            if {$fileName == {}} {
                set fileName    [tk_getOpenFile -initialdir $::APPL_Env(USER_Dir) -filetypes $types]
            }

                # puts "   openProject_xml - fileName:   $fileName"
            if { [file readable $fileName ] } {
                    
                    set ::APPL_Env(root_ProjectDOM)    [lib_file::get_XMLContent $fileName show]
                    set rattleCAD_Version [[$::APPL_Env(root_ProjectDOM) selectNodes /root/Project/rattleCADVersion/text()] asXML]
                    
                    puts "\n"
                    puts "  ====== o p e n   F I L E ========================"
                    puts ""
                    puts "         ... file:       $fileName"
                    puts "         ... version:    $rattleCAD_Version"

                    set postUpdate [ project::update_Project ]


                    # set debugFile  [file join $::APPL_Env(USER_Dir) debug.xml]
                    # puts "   -> $debugFile"
                    # set fp [open $debugFile w]
                    # puts $fp [$::APPL_Env(root_ProjectDOM)  asXML]
                    # close $fp


                        #
                    frame_geometry::set_base_Parameters $::APPL_Env(root_ProjectDOM)
                        #
                    foreach key [dict keys $postUpdate] {
                              # puts " -> $key"
                            set valueDict   [dict get $postUpdate $key]
                            foreach valueKey [dict keys $valueDict] {
                                puts "\n      -------------------------------"
                                puts "          postUpdate:   $key - $valueKey [dict get $valueDict $valueKey]"
                                frame_geometry::set_projectValue $key/$valueKey [dict get $valueDict $valueKey] update
                            }
                                # project::pdict $valueDict
                    }
                        #
                    set ::APPL_Config(PROJECT_File) $fileName
                    set ::APPL_Config(PROJECT_Save) [clock milliseconds]


                        # -- window title --- ::APPL_CONFIG(PROJECT_Name) ----------
                    if {$windowTitle == {}} {
                        set_window_title $fileName
                    } else {
                        set_window_title $windowTitle
                    }
                        #
                    lib_gui::notebook_updateCanvas
                    
            }
                #
            lib_gui::open_configPanel  refresh
            
                #
            puts "\n"
            puts "    ------------------------"
            puts "    openProject_xml"   
            puts "            $::APPL_Config(PROJECT_File)"
            puts "            $::APPL_Config(PROJECT_Name)"
            puts "        ... done"             
            puts "\n  ====== o p e n  F I L E =========================\n\n"
    }


    #-------------------------------------------------------------------------
        #  open Template File Type: xml
        #
    proc openTemplate_xml {type} {
            puts "\n"
            puts "  ====== o p e n   T E M P L A T E ================"
            puts "         ... type:    $type"
            set template_file    [ getTemplateFile $type ]
            puts "         ... template_file:   $template_file"
            if { [file readable $template_file ] } {
                    set ::APPL_Env(root_ProjectDOM)     [lib_file::get_XMLContent $template_file show]
                        #
                    frame_geometry::set_base_Parameters $::APPL_Env(root_ProjectDOM)
                        #
                    set ::APPL_Config(PROJECT_Name)     "Template $type"
                    set ::APPL_Config(PROJECT_File)     "Template $type"  
                    set ::APPL_Config(PROJECT_File)     [expr 2 * [clock milliseconds]]                    
                        # puts " <D> -> \$::APPL_Config(PROJECT_Name)  $::APPL_Config(PROJECT_Name)"
                        # puts " <D> -> \$::APPL_Config(PROJECT_File)  $::APPL_Config(PROJECT_File)"
                        #
                    set_window_title $::APPL_Config(PROJECT_Name)
                        #
                    lib_gui::notebook_updateCanvas
            } else {
                tk_messageBox -message "... could not load template: $window_title"
            }

                #
            lib_gui::open_configPanel  refresh
    }


    #-------------------------------------------------------------------------
        #  save File Type: xml
        #
    proc saveProject_xml { {mode {save}} {type {Road}} } {

                # --- select File
            set types {
                    {{Project Files 3.x }       {.xml}  }
                }



            puts "\n\n  ====== s a v e  F I L E =========================\n"


                # set userDir       [check_user_dir rattleCAD]
            if  {$::APPL_Config(PROJECT_File) != {}} {
                set initialFile [file tail      $::APPL_Config(PROJECT_File)]
                set initialDir  [file dirname   $::APPL_Config(PROJECT_File)]
            } else {
                set initialFile "... empty"
                set initialDir  "... empty"
            }
                puts "       ... saveProject_xml - mode:            \"$mode\""
                puts "       ... saveProject_xml - USER_Dir:        \"$::APPL_Env(USER_Dir)\""
                puts "       ... saveProject_xml - PROJECT_Name:    \"$::APPL_Config(PROJECT_Name)\""
                puts "       ... saveProject_xml - ... initialFile:     \"$initialFile\""
                puts "       ... saveProject_xml - ... initialDir:      \"$initialDir\""

                # default - values

            switch -exact $mode {
                {save}          {   set windowTitle     $initialFile
                                    set requestTemplate {no}
                                    switch -exact $initialFile {
                                        {Template Road} {   set requestTemplate    {yes}
                                                            set initialFile        [format "%s%s.xml" $::APPL_Env(USER_InitString) Road]
                                                        }
                                        {Template MTB}  {   set requestTemplate    {yes}
                                                            set initialFile        [format "%s%s.xml" $::APPL_Env(USER_InitString) MTB ]
                                                        }
                                        default            {}
                                    }
                                    if {$requestTemplate == "yes"} {
                                        set retValue [tk_messageBox -title   "Save Project" -icon question \
                                                                    -message "Save Project as Template: $initialFile?" \
                                                                    -default cancel \
                                                                    -type    yesnocancel]
                                        puts "\n  $retValue\n"

                                        switch $retValue {
                                            yes     {   set ::APPL_Config(PROJECT_File) [file join $::APPL_Env(USER_Dir) $initialFile] 
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
                puts "       ... saveProject_xml - mode:            \"$mode\""
                puts "       ... saveProject_xml - ... initialFile: \"$initialFile\""


                # -- read from domConfig
                # set domConfig $::APPL_Env(root_ProjectDOM)

            switch $mode {
                {save}        {
                                # set fileName    [file join $::APPL_Env(USER_Dir) $initialFile]
                                set fileName    [file normalize $::APPL_Config(PROJECT_File)]
                            }
                {saveAs}    {
                                set fileName    [tk_getSaveFile -initialdir $::APPL_Env(USER_Dir) -initialfile $initialFile -filetypes $types]
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
                                set ::APPL_Config(PROJECT_File) [file normalize $fileName]
                                set ::APPL_Config(PROJECT_Name) [file tail      $fileName]
                                
                                    # --- set xml-File Attributes
                                set project::Project(Name)     [ file tail $fileName ]
                                    # [ $domConfig selectNodes /root/Project/Name/text()              ]     nodeValue     [ file tail $fileName ]


                                    # --- set window Title
                                set windowTitle    $fileName
                            }
                default     {    return}
            }

            # --- set xml-File Attributes
            set project::Project(modified)             [ clock format [clock seconds] -format {%Y.%m.%d %H:%M} ]
            set project::Project(rattleCADVersion)     "$::APPL_Env(RELEASE_Version).$::APPL_Env(RELEASE_Revision)"
                # [ $domConfig selectNodes /root/Project/modified/text()             ]     nodeValue     [ clock format [clock seconds] -format {%Y.%m.%d %H:%M} ]
                # [ $domConfig selectNodes /root/Project/rattleCADVersion/text()  ]     nodeValue     "$::APPL_Env(RELEASE_Version).$::APPL_Env(RELEASE_Revision)"

                # -- read from domConfig
            project::runTime_2_dom $::APPL_Env(root_ProjectDOM)
            set domConfig $::APPL_Env(root_ProjectDOM)


                # -- open File for writing
            if {[file exist $fileName]} {
                if {[file writable $fileName]} {
                    set fp [open $fileName w]
                    puts $fp [$domConfig  asXML]
                    close $fp
                    puts ""
                    puts "         ------------------------"
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
                    puts "         ------------------------"
                    puts "           ... write:"  
                    puts "                       $fileName "
                    puts "                   ... done"
            }


                #
                # set ::APPL_Env(root_ProjectDOM) $domConfig
                #
            frame_geometry::set_base_Parameters $::APPL_Env(root_ProjectDOM)
                #
            set ::APPL_Config(PROJECT_Save) [clock milliseconds]                                            
                # -- window title --- ::APPL_CONFIG(PROJECT_Name) ----------
            set_window_title $windowTitle
                #
            lib_gui::notebook_updateCanvas
            
                #
            puts "\n"
            puts "    ------------------------"
            puts "    saveProject_xml"     
            puts "            $::APPL_Config(PROJECT_File)"
            puts "        ... done"

            puts "\n  ====== s a v e  F I L E =========================\n\n"
    }


    #-------------------------------------------------------------------------
        #  open a File, containing just a subset of a Project-xml
        #
    proc openProject_Subset_xml {{fileName {}}} {
            set types {
                {{Project Files 3.x }       {.xml}  }
            }
            if {$fileName == {}} {
                set fileName    [tk_getOpenFile -title "Import" -initialdir $::APPL_Env(USER_Dir) -filetypes $types]
            } else {
                return
            }
            set root [lib_file::get_XMLContent $fileName]
            project::import_ProjectSubset $root
    }


    #-------------------------------------------------------------------------
        #  ... renamed from openFile_xml to get_XMLContent  2012.07.29
        #
    proc get_XMLContent {{file {}} {show {}}} {

            set types {
                    {{xml }       {.xml}  }
                }
            if {$file == {} } {
                set file [tk_getOpenFile -initialdir $::APPL_Env(USER_Dir) -filetypes $types]
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
                lib_cfg_report::fillTree "$root" root
            }

                #
                # -- return root  document
                #
            return $root
    }


    #-------------------------------------------------------------------------
       #  open web URL
       #
    proc open_URL {url} {
            puts ""
            puts "   -------------------------------"
            puts "    lib_file::open_URL"
            puts "            url:        $url"

            eval exec [auto_execok start] \"\" [list $url] &
    }


    #-------------------------------------------------------------------------
       #  open File by OS - Definition
       #
    proc open_localFile {fileName} {
            set fileName [file normalize $fileName]

            puts ""
            puts "   -------------------------------"
            puts "    lib_file::open_localFile"
            puts "       fileName:        $fileName"

            if {![file exists $fileName]} {
                    puts  "         --<E>----------------------------------------------------"
                    puts  "           <E> File : $fileName"
                    puts  "           <E>      ... does not exist localy! "
                    puts  "         --<E>----------------------------------------------------"
                    return
            }

            eval exec [auto_execok start] \"\" [list $fileName] &
    }


    #-------------------------------------------------------------------------
       #  open File by Extension
       #
    proc openFile_byExtension {fileName {altExtension {}}} {

            set fileExtension   [file extension $fileName]

            puts "\n"
             puts  "         openFile_byExtension:  $fileExtension ($altExtension)"
             puts  "       ---------------------------------------------"
            puts  "               fileName      $fileName"

            if {![file exists $fileName]} {
                    puts  "         --<E>----------------------------------------------------"
                    puts  "           <E> File : $fileName"
                    puts  "           <E>      ... does not exist! "
                    puts  "         --<E>----------------------------------------------------"
                    return
            }

                # -- handle on file extension
                #
            switch $altExtension {
                {.htm} -
                {.html} {   set fileExtension   $altExtension
                            set fileName        "file:///$fileName"
                        }
                default {}
            }

            set fileApplication     [get_Application $fileExtension]
            if {$fileApplication == {}} {
                    puts  "         --<E>----------------------------------------------------"
                    puts  "           <E> File : $fileName"
                    puts  "           <E>      ... could not ge any Application! "
                    puts  "         --<E>----------------------------------------------------"
                    return
            }
            puts  "               Filetype $fileExtension opens with:"
            puts  "                        >$fileApplication<\n"


                # ---------------------
                # replace %1 by fileName
            proc percSubst { cmdString pattern substString } {
                    # puts " --------------"
                    # puts "        \$cmdString    >$cmdString<"
                    # puts "        \$pattern      >$pattern<"
                    # puts "        \$substString  >$substString<"
                    # puts " --------------"
                    # puts " [ string map [ list $pattern $substString ] $cmdString ]"
                set cmdString    [ string map [ list $pattern $substString ] $cmdString ]
                return $cmdString
            }

                # ---------------------
                # Substitute the HTML filename into the
                # command for %1
            set commandString [ percSubst $fileApplication %1 $fileName ]
            if {$commandString == $fileApplication} {
                set commandString "$fileApplication  $fileName"
            }

                # ---------------------
                # Double up the backslashes for eval (below)
            puts "               ... $commandString "

                # ---------------------
                # Double up the backslashes for eval (below)
            regsub -all {\\} $commandString  {\\\\} commandString

                # ---------------------
                # Invoke the command
            eval exec $commandString &

                # ---------------------
                # done ...
            puts  ""
            puts  "                    ... done"
            return
    }


    #-------------------------------------------------------------------------
       #  get Application of File Extension
       #    http://wiki.tcl.tk/557
       #
    proc get_Application {fileExtension} {
            puts "\n"
            puts  "         get_Application: $fileExtension"
            puts  "       ---------------------------------------------"
            puts  "               tcl_version   [info tclversion]"
            puts  "               tcl_platform  $::tcl_platform(platform)"

            set appCmd {} ;# set as default

            switch $::tcl_platform(platform) {
                "windows" {
                        package require registry 1.1

                        set root HKEY_CLASSES_ROOT

                            # Get the application key for HTML files
                        set appKey [registry get $root\\$fileExtension ""]
                        puts  "               appKey  $appKey"

                            # Get the command for opening HTML files
                        if { [catch {     set appCmd [registry get $root\\$appKey\\shell\\open\\command ""]      } errMsg] } {
                                    puts  "         --<E>----------------------------------------------------"
                                    puts  "           <E> File Type: $fileExtension"
                                    puts  "           <E> could not find a registered COMMAND for this appKey"
                                    puts  "         --<E>----------------------------------------------------"
                                    return
                        }
                        puts  "               appCmd  $appCmd"

                }
            }

                # puts  "               appCmd:"
                # puts "                         $appCmd"

            return $appCmd

    }


    #-------------------------------------------------------------------------
        #  get user project directory
        #
    proc check_user_dir {checkDir} {

            # changed since 3.2.78.03

                # thanks to:  http://wiki.tcl.tk/3834
            if { [expr [string compare "$::tcl_platform(platform)" "windows" ] == 0] } {
                    package require registry 1.0
                    set homeDir_Request [registry get {HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders} {Personal}]
                    set homeDir {}
                    foreach dir [string trim [split $homeDir_Request \\]] {
                            set dirString [string trim $dir {%} ]
                            if {$dirString eq $dir} {
                                set homeDir [file join $homeDir $dir]
                            } else {
                                set homeDir [file join $homeDir $::env($dirString)]
                            }
                    }
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

            return $checkDir
    }


    #-------------------------------------------------------------------------
        #  ...
        #
    proc getTemplateFile {type} {

            set TemplateRoad    [file join $::APPL_Env(USER_Dir) [format "%s%s.xml" $::APPL_Env(USER_InitString) Road] ]
            set TemplateMTB     [file join $::APPL_Env(USER_Dir) [format "%s%s.xml" $::APPL_Env(USER_InitString) MTB ] ]

            switch -exact $type {
                    {Road} {    if {[file exists $TemplateRoad ]} {
                                    return $TemplateRoad
                                } else {
                                    return $::APPL_Env(TemplateRoad_default)
                                }
                            }
                    {MTB} {     if {[file exists $TemplateMTB ]} {
                                    return $TemplateMTB
                                } else {
                                    return $::APPL_Env(TemplateMTB_default)
                                }
                            }
                    default {   return {}
                            }
                }

    }


    #-------------------------------------------------------------------------
        # http://stackoverflow.com/questions/429386/tcl-recursively-search-subdirectories-to-source-all-tcl-files
        # 2010.10.15
    proc findFiles { basedir pattern } {
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
    proc get_componentAlternatives {key} {

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

            set userDir     [ file join $::APPL_Env(USER_Dir)   $directory ]
            set etcDir      [ file join $::APPL_Env(CONFIG_Dir) $directory ]
                        # puts "            user: $userDir"
                        # puts "            etc:  $etcDir"


            catch {
                foreach file [ glob -directory $userDir  *.svg ] {
                        # puts "     ... fileList: $file"
                    set fileString [ string map [list $::APPL_Env(USER_Dir)/components/ {user:} ] $file ]
                    set listAlternative   [ lappend listAlternative $fileString]
                }
            }
            foreach file [ glob -directory $etcDir  *.svg ] {
                        # puts "  ... fileList: $file"
                set fileString [ string map [list $::APPL_Env(CONFIG_Dir)/components/ {etc:} ] $file ]
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


}

