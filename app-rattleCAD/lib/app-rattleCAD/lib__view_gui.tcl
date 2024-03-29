 ##+##########################################################################
 #
 # package: rattleCAD    ->    lib_gui.tcl
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
 #    namespace:  rattleCAD::lib_gui
 # ---------------------------------------------------------------------------
 #
 # 
 
 
 namespace eval rattleCAD::view::gui {

    variable    canvasGeometry ;   array    set canvasGeometry {}
    variable    notebookCanvas ;   array    set notebookCanvas {}
    variable    iconArray      ;   array    set iconArray      {}
    
    variable    canvasUpdate   ;   array    set canvasUpdate   {}
    variable    checkAngles    ;            set checkAngles    off
    
    variable    noteBook_top
    
    variable    stageFormat             A4
    variable    stageScale              1.00

    variable    external_canvasCAD  ;   array    set external_canvasCAD {}
    variable    rattleCAD_AddOn     ;   array    set rattleCAD_AddOn {}
             
    
    variable    frame_configMethod      {OutsideIn}
    variable    show_secondaryDimension 1
    variable    show_resultDimension    1
    variable    show_summaryDimension   1
    
    variable    toggleFullScreenWidgets {}
 }


                            
    #-------------------------------------------------------------------------
       #  create MainFrame with Menue  
       #
    proc rattleCAD::view::gui::create_MainFrame {} {        
            #
        variable    rattleCAD_AddOn
            #
            #
        set mainframe_Menue {
            "&File"   all file 0 {
                {command "&New"             {}  "New Project File"      {Ctrl n}        -command { rattleCAD::model::file::newProject_xml } }
                {command "&Open"            {}  "0pen Project File"     {Ctrl o}        -command { rattleCAD::model::file::openProject_xml } }
                {command "&Save"            {}  "Save Project File"     {Ctrl s}        -command { rattleCAD::model::file::saveProject_xml } }
                {command "Save &As ..."     {}  "Save Project File As"  {CtrlAlt s}     -command { rattleCAD::model::file::saveProject_xml saveAs} }
                            
                {separator}         
                            
                {command "Undo"             {}  "Undo"                  {Ctrl z}        -command { rattleCAD::control::changeList::previous} }
                {command "Redo"             {}  "Redo"                  {Ctrl y}        -command { rattleCAD::control::changeList::next} }
                            
                {separator}         
                            
                {command "&Copy Reference"  {}  "Copy Reference"        {Ctrl r}        -command { rattleCAD::view::gui::notebook_switchTab  cv_Custom02} }
                            
                {separator}         
                            
                {command "Impo&rt"          {}  "import Parameter"      {Ctrl i}        -command { rattleCAD::model::file::openProject_Subset_xml } }
                {command "&Rendering"       {}  "Rendering Settings"    {}              -command { rattleCAD::view::gui::change_Rendering } }
                                    
                {separator}         
                                    
                {command "&Config Panel"    {}  "open Config Panel"     {Ctrl m}        -command { rattleCAD::configPanel::create } }
                            
                {separator}         
                            
                {command "&SVG-Component"   {}  "open simplify_SVG"     {}              -command { rattleCAD::control::tool::start_simplifySVG } }
                {command "&SVG-ChainWheel"  {}  "open chainWheel_SVG"   {}              -command { rattleCAD::control::tool::start_chainWheelSVG } }
                                            
                {separator}         
                                    
                {command "&Update"          {}  "update Configuration"  {Ctrl u}        -command { rattleCAD::view::updateView force } }
    
                {separator}         
                                    
                {command "E&xit"            {}  "Exit rattle_CAD"       {Ctrl x}        -command { rattleCAD::view::gui::exit_rattleCAD } }
            }           
            "Export"   all info 0 {         
                {command "&Export PDF"      {}  "Export PDF-Report"     {Ctrl p}        -command { rattleCAD::view::gui::export_Project      pdf} }
                {command "&Export HTML"     {}  "Export HTML-Report"    {Ctrl t}        -command { rattleCAD::view::gui::export_Project      html} }
                {command "&Export SVG"      {}  "Export to SVG"         {}              -command { rattleCAD::view::gui::notebook_exportSVG  $APPL_Config(EXPORT_Dir) } }
                {command "&Export DXF"      {}  "Export to DXF"         {}              -command { rattleCAD::view::gui::notebook_exportDXF  $APPL_Config(EXPORT_Dir) } }
                {command "&Export PS"       {}  "Export to PostScript"  {}              -command { rattleCAD::view::gui::notebook_exportPS   $APPL_Config(EXPORT_Dir) } }
                
                {separator}
                        
                {command "rattleCAD AddOn"  {}  "additional rattleCAD Features" {Alt a} -command { rattleCAD::control::start_AddOn } }
            }
            "Demo"   all info 0 {
                {command "Samples"          {}  "Example Projects"      {}              -command { rattleCAD::test::runDemo loopSamples } }
                {command "rattleCAD Method" {}  "HandleBar and Saddle"  {CtrlAlt r}     -command { rattleCAD::test::runDemo method_rattleCAD_HandleBarandSaddle } }
                {command "classic Method"   {}  "Seat- and TopTube"     {}              -command { rattleCAD::test::runDemo method_classic_SeatandTopTube } }
                {command "Demo"             {}  "rattleCAD Demo"        {}              -command { rattleCAD::test::runDemo demo_01 } }
                {command "Stop Demo"        {}  "Stop running Demo"     {Ctrl b}        -command { rattleCAD::test::stopDemo} }
                {separator}         
                {command "Integration Test" {}  "Integration Test"      {CtrlAlt i}     -command { rattleCAD::test:::runDemo integrationTest_00} }
                {separator}         
                {command "Debug Special"    {}  "Debug Special"         {}              -command { rattleCAD::test:::runDemo integrationTest_special} }
                {separator}         
                {command "Intro-Image"      {}  "Show Intro Window"     {}              -command { create_intro .intro } }
            }   
            "Info"   all info 0 {   
                {command "&Info"            {}  "Information"           {Ctrl w}        -command { rattleCAD::infoPanel::create  .v_info 0} }
                {command "&Help"            {}  "Help"                  {Ctrl h}        -command { rattleCAD::infoPanel::create  .v_info 1} }
                {command "ChangeLog"        {}  "ChangeLog"             {}              -command { rattleCAD::infoPanel::create  .v_info 7} }
                {separator} 
                {command "rattleCAD WebSite"      {}  "about rattleCAD"       {}        -command { rattleCAD::model::file::open_URL {http://rattlecad.sourceforge.net/index.html}    } }
                {command "rattleCAD Features"     {}  "rattleCAD Features"    {}        -command { rattleCAD::model::file::open_URL {http://rattlecad.sourceforge.net/features.html} } }
                {command "project @ sourceforge"  {}  "sourceforge.net"       {}        -command { rattleCAD::model::file::open_URL {http://sourceforge.net/projects/rattlecad}      } }
            }
            " ... contribute"   all info 0 {   
                {command "... to the rattleCAD Project" {} "like and donate"  {}        -command { rattleCAD::model::file::open_URL {http://rattlecad.sourceforge.net/donate.html}   } }
            }
        }
        
        return [MainFrame .mainframe  -menu $mainframe_Menue ]
        
            # removed 20150818
            # {command "show Console"   {}  "show log Consolge" {}              -command { rattleCAD::view::gui::show_Console } }
                
    }


    #-------------------------------------------------------------------------
        #  create MainFrame with Menue  
        #
    proc rattleCAD::view::gui::create_ButtonBar {tb_frame } {    
                #
            variable iconArray
                #
            variable rattleCAD_AddOn    
                #
            variable toggleFullScreenWidgets
                #
                #append_rattleCAD_AddOn $tb_frame.rattleCAD_AddOn
            # $tb_frame configure -fg black    
                #
                
                #
                #   ----------------------------------------
                #
            set toolBar_left  [frame $tb_frame.left]
                #
            pack    $toolBar_left   -side left  -fill y
                #
                #
            ttk::button    $toolBar_left.open      -image  $iconArray(open)          -command { rattleCAD::model::file::openProject_xml }  
            ttk::button    $toolBar_left.save      -image  $iconArray(save)          -command { rattleCAD::model::file::saveProject_xml } 
            
            set rattleCAD_AddOn(ButtonFrame)    [frame     $toolBar_left.rattleCAD_AddOn]
            
            ttk::button    $toolBar_left.backward  -image  $iconArray(backward)      -command { rattleCAD::control::changeList::previous }          
            ttk::button    $toolBar_left.forward   -image  $iconArray(forward)       -command { rattleCAD::control::changeList::next }          
            
            ttk::button    $toolBar_left.render    -image  $iconArray(update)        -command { rattleCAD::view::updateView force}  
            ttk::button    $toolBar_left.clear     -image  $iconArray(clear)         -command { rattleCAD::view::gui::notebook_cleanCanvas} 
              
            ttk::button    $toolBar_left.set_rd    -image  $iconArray(reset_r)       -command { rattleCAD::view::gui::load_Template  Road }  
            ttk::button    $toolBar_left.set_mb    -image  $iconArray(reset_o)       -command { rattleCAD::view::gui::load_Template  MTB  }  
            
            ttk::button    $toolBar_left.print_htm -image  $iconArray(print_html)    -command { rattleCAD::view::gui::export_Project      html }          
            ttk::button    $toolBar_left.print_pdf -image  $iconArray(print_pdf)     -command { rattleCAD::view::gui::export_Project      pdf }          

            ttk::button    $toolBar_left.print_ps  -image  $iconArray(print_ps)      -command { rattleCAD::view::gui::notebook_exportPS   $APPL_Config(EXPORT_Dir) }          
            ttk::button    $toolBar_left.print_dxf -image  $iconArray(print_dxf)     -command { rattleCAD::view::gui::notebook_exportDXF  $APPL_Config(EXPORT_Dir) }          
            ttk::button    $toolBar_left.print_svg -image  $iconArray(print_svg)     -command { rattleCAD::view::gui::notebook_exportSVG  $APPL_Config(EXPORT_Dir) }          
            
            label   $toolBar_left.sp0      -text   " "
            label   $toolBar_left.sp1      -text   " "
            label   $toolBar_left.sp2      -text   " "
            label   $toolBar_left.sp3      -text   " "
            label   $toolBar_left.sp4      -text   " "
            label   $toolBar_left.sp5      -text   "      "            
                #
                #
            pack    $toolBar_left.open      $toolBar_left.save      $toolBar_left.sp0  \
                    $toolBar_left.rattleCAD_AddOn \
                    $toolBar_left.backward  $toolBar_left.forward   $toolBar_left.sp1  \
                    $toolBar_left.render    $toolBar_left.clear     $toolBar_left.sp2  \
                    $toolBar_left.set_rd    $toolBar_left.set_mb    $toolBar_left.sp3  \
                    $toolBar_left.print_htm $toolBar_left.print_pdf $toolBar_left.sp4  \
                    $toolBar_left.print_ps  $toolBar_left.print_dxf $toolBar_left.print_svg $toolBar_left.sp5 \
                -side left -fill y
                       
                # ---------------------------------------------
                # bind tooltips
                # 
                # rattleCAD::view::setTooltip $widget "Hello World!"    
            rattleCAD::view::setTooltip    $toolBar_left.open       "open ..."               
            rattleCAD::view::setTooltip    $toolBar_left.save       "save ..."               
                #
            rattleCAD::view::setTooltip    $toolBar_left.backward   "... backward"           
            rattleCAD::view::setTooltip    $toolBar_left.forward    "forward ..."            
                #
            rattleCAD::view::setTooltip    $toolBar_left.render     "update Canvas..."       
            rattleCAD::view::setTooltip    $toolBar_left.clear      "clear Canvas..."        
                #
            rattleCAD::view::setTooltip    $toolBar_left.set_rd     "a roadbike Template"    
            rattleCAD::view::setTooltip    $toolBar_left.set_mb     "a offroad Template"     
                #
            rattleCAD::view::setTooltip    $toolBar_left.print_htm  "export HTML"            
            rattleCAD::view::setTooltip    $toolBar_left.print_pdf  "export PDF"             
                #
            rattleCAD::view::setTooltip    $toolBar_left.print_ps   "print Postscript"       
            rattleCAD::view::setTooltip    $toolBar_left.print_dxf  "print DXF"              
            rattleCAD::view::setTooltip    $toolBar_left.print_svg  "print SVG"


            
                #
                #   ----------------------------------------
                #
            set toolBar_right [frame $tb_frame.right]
                #
            pack    $toolBar_right  -side right -fill y
                #
                #
            ttk::button    $toolBar_right.scale_p   -image  $iconArray(scale_p)       -command { rattleCAD::view::gui::notebook_scaleCanvas  [expr 3.0/2] }  
            ttk::button    $toolBar_right.scale_m   -image  $iconArray(scale_m)       -command { rattleCAD::view::gui::notebook_scaleCanvas  [expr 2.0/3] }  
            ttk::button    $toolBar_right.resize    -image  $iconArray(resize)        -command { rattleCAD::view::gui::notebook_refitCanvas }  
            
            ttk::button    $toolBar_right.cfg       -image  $iconArray(cfg_panel)     -command { rattleCAD::configPanel::create } 
            
            ttk::button    $toolBar_right.donate    -image  $iconArray(donate)        -command { rattleCAD::model::file::open_URL {http://rattlecad.sourceforge.net/donate.html}   } 
            
            ttk::button    $toolBar_right.exit      -image  $iconArray(exit)          -command { rattleCAD::view::gui::exit_rattleCAD }
                #
            label   $toolBar_right.sp6  -text   " "
            label   $toolBar_right.sp7  -text   " "
			label   $toolBar_right.sp8  -text   " "
                #
                #    
            grid    $toolBar_right.cfg      $toolBar_right.sp6 \
                    $toolBar_right.scale_m  $toolBar_right.scale_p  $toolBar_right.resize   $toolBar_right.sp8  \
                    $toolBar_right.exit \
                -sticky w 
                
                # ---------------------------------------------
                # bind tooltips
                # 
            rattleCAD::view::setTooltip $toolBar_right.scale_p  "scale plus"             
            rattleCAD::view::setTooltip $toolBar_right.scale_m  "scale minus"            
            rattleCAD::view::setTooltip $toolBar_right.resize   "resize"                 
                #
            rattleCAD::view::setTooltip $toolBar_right.cfg      "open config Panel"      
                #
            rattleCAD::view::setTooltip $toolBar_right.donate   "donate to rattleCAD"    
                #
                
                #
                # ---------------------------------------------
                # bind resize
                # 
            lappend toggleFullScreenWidgets  $toolBar_right.exit $toolBar_right.sp8
            bind $toolBar_right.resize  <Double-1>              {rattleCAD::view::gui::toggle_Fullscreen}
                #
                # ---------------------------------------------
                # hide EXIT per default
                # 
            foreach widget $toggleFullScreenWidgets {
                grid remove $widget
            }
    }


    #-------------------------------------------------------------------------
        #  check existance of package rattleCAD_Xtnd   
        #
    proc rattleCAD::view::gui::append_rattleCAD_AddOn {} {
                #
            variable rattleCAD_AddOn   
            variable iconArray
                #
            if {[namespace ensemble exists ::rattleCAD_AddOn]} {
                    #
                label   $rattleCAD_AddOn(ButtonFrame).sp0   -text   " "
                ttk::button  $rattleCAD_AddOn(ButtonFrame).addOn -image  $iconArray(addon)   -command {rattleCAD::control::start_AddOn}   
                rattleCAD::view::setTooltip    $rattleCAD_AddOn(ButtonFrame).addOn "rattleCAD AddOn"              
                    #
                pack    $rattleCAD_AddOn(ButtonFrame).sp0 -side right
                pack    $rattleCAD_AddOn(ButtonFrame).addOn -fill y -expand yes -side right
                    # Button  $rattleCAD_AddOn(ButtonFrame).addOn -image  $iconArray(addon)   -helptext "rattleCAD AddOn" -command {rattleCAD::control::start_AddOn}   
                    # Button  $rattleCAD_AddOn(ButtonFrame).addOn -text AddOn      -helptext "rattleCAD AddOn" -command {rattleCAD::control::start_AddOn}   
                                
            } else {
                puts "\n\n"
                puts "       <I>"
                puts "       <I> ... libraries not found for package ::append_rattleCAD_AddOn"
                puts "       <I>"
                puts "\n\n"
            }
                #
            return
                #
                #    {command "&Export openSCAD" {}  "Export to openSCAD"    {Ctrl O}      -command { rattleCAD::view::gui::export_openSCAD } }
                #    {command "&Export Reynolds FEA" {} "Export Reynolds FEA" {Ctrl f}     -command { rattleCAD::view::gui::export_reynoldsFEA  1.0} }
                #
    }


    #-------------------------------------------------------------------------
        #  register notebookCanvas in notebook - Tabs   
        #
    proc rattleCAD::view::gui::create_Notebook {frame} {
            variable canvasGeometry
            variable canvasUpdate
            variable noteBook_top
            
                # ---     initialize canvasUpdate
            set canvasUpdate(recompute)    0
            
                # ---     create ttk::notebook
            set noteBook_top     [ ttk::notebook $frame.nb -width $canvasGeometry(width)    -height $canvasGeometry(height) ]                
                pack $noteBook_top -expand yes  -fill both  
            
                # ---     create and register any canvasCAD - canvas in rattleCAD::view::gui::notebookCanvas
            rattleCAD::view::gui::create_canvasCAD  $noteBook_top  cv_Custom02  "  Copy Reference "      A4  0.2  25  -bd 2  -bg white  -relief sunken
            rattleCAD::view::gui::create_canvasCAD  $noteBook_top  cv_Custom00  "  BaseGeometry   "      A4  0.2  25  -bd 2  -bg white  -relief sunken
          # rattleCAD::view::gui::create_canvasCAD  $noteBook_top  cv_Custom01  "  BaseGeometry-Lug"     A4  0.2  25  -bd 2  -bg white  -relief sunken
            rattleCAD::view::gui::create_canvasCAD  $noteBook_top  cv_Custom10  "  Frame Details  "      A4  0.2  25  -bd 2  -bg white  -relief sunken
            rattleCAD::view::gui::create_canvasCAD  $noteBook_top  cv_Custom20  "  ChainStay Details  "  A2  1.0  25  -bd 2  -bg white  -relief sunken
            rattleCAD::view::gui::create_canvasCAD  $noteBook_top  cv_Custom30  "  Summary   "           A4  0.2  25  -bd 2  -bg white  -relief sunken
            rattleCAD::view::gui::create_canvasCAD  $noteBook_top  cv_Custom40  "  Frame Drafting  "     A4  0.2  25  -bd 2  -bg white  -relief sunken
            rattleCAD::view::gui::create_canvasCAD  $noteBook_top  cv_Custom50  "  Mockup  "             A4  0.2  25  -bd 2  -bg white  -relief sunken
            rattleCAD::view::gui::create_canvasCAD  $noteBook_top  cv_Custom60  "  Tube Miter  "         A3  1.0  25  -bd 2  -bg white  -relief sunken
            rattleCAD::view::gui::create_canvasCAD  $noteBook_top  cv_Custom70  "  Frame - Jig  "        A4  0.2  25  -bd 2  -bg white  -relief sunken
            
            $noteBook_top add   [frame $noteBook_top.components]     -text "... Components" 
            $noteBook_top add   [frame $noteBook_top.report]         -text "... info" 
            
            $noteBook_top hide  0 ; # hide per default: cv_Custom02  "  Copy Concept   "
            
                # ---     modify dimension precision in Frame Drafting ; updates current and default precision
            #rattleCAD::view::gui::cv_Custom40 setPrecision 2 force
                
                
                # ---     fill with Report Widgets
            rattleCAD::cfg_report::createReport     $noteBook_top.report
                # ---     fill with Library Widgets
            rattleCAD::comp_library::createLibrary $noteBook_top.components
            rattleCAD::comp_library::update_compList


                # ---     bind event to update Tab on selection
            bind $noteBook_top <<NotebookTabChanged>> {rattleCAD::view::updateView}
              # bind $noteBook_top <<NotebookTabChanged>> {rattleCAD::view::gui::notebook_updateCanvas}

                # ---     bind event Control-Tab and Shift-Control-Tab
            ttk::notebook::enableTraversal $noteBook_top

                # ---     select and update following Tab
            # $noteBook_top select $noteBook_top.cv_Custom30
            # $noteBook_top select $noteBook_top.cv_Custom00
            # $noteBook_top select $noteBook_top.cv_Custom20
            
            $noteBook_top select $noteBook_top.cv_Custom30
            
                # ---     return
            return $noteBook_top
    }


    #-------------------------------------------------------------------------
        #  register notebookCanvas in notebook - Tabs   
        #
    proc rattleCAD::view::gui::create_canvasCAD {notebook varname title stageFormat stageScale stageBorder args} {
            # rattleCAD::view::gui::create_canvasCAD  $noteBook_top  cv_Custom30  "Dimension Summary"  A4  0.2 -bd 2  -bg white  -relief sunken
        variable canvasGeometry
        variable notebookCanvas
        
        set notebookCanvas($varname)   $notebook.$varname.cvCAD
            # puts "    ... create_canvasCAD: $notebookCanvas($varname)"
            
            # ---     add frame containing canvasCAD
        $notebook add [ frame $notebook.$varname ] -text $title 
        
            # ---     add canvasCAD to frame and select notebook tab before to update 
            #          the tabs geometry
        $notebook select $notebook.$varname  
            # puts "  canvasCAD::newCanvas $varname  $notebookCanvas($varname) \"$title\" $canvasGeometry(width) $canvasGeometry(height)  $stageFormat $stageScale $stageBorder $args"
        eval canvasCAD::newCanvas $varname  $notebookCanvas($varname) \"$title\" $canvasGeometry(width) $canvasGeometry(height)  $stageFormat $stageScale $stageBorder $args
            # puts "canvasCAD::newCanvas $varname  $notebookCanvas($varname) \"$title\" $canvasGeometry(width) $canvasGeometry(height)  $stageFormat $stageScale $stageBorder $args"
    }


    #-------------------------------------------------------------------------
        #  exit application   
        #
    proc rattleCAD::view::gui::exit_rattleCAD {{type {yesnocancel}} {exitMode {}}} {   
                
            set changeIndex [rattleCAD::control::changeList::get_changeIndex]
                
                puts "\n"
                puts "  ====== e x i t   r a t t l e C A D =============="
                puts ""
                puts "         ... file:       [rattleCAD::control::getSession  projectFile]"
			    puts "           ... saved:    [rattleCAD::control::getSession  projectSave]"
                puts "           ... modified: $changeIndex"
                puts "                     ... $rattleCAD::control::model_Update"
                puts ""
                puts "        ... type:        $type"
                puts "        ... exitMode:    $exitMode"

          
            if { $changeIndex > 0 } {
                
                puts " ......... save File before exit"
                puts "        project save:   [rattleCAD::control::getSession  projectSave]"
                puts "        project change: $rattleCAD::control::model_Update"

                set decission [tk_messageBox  -type $type \
                                              -icon warning \
                                              -title   "exit rattleCAD" \
                                              -message "Save current Project before EXIT"]
                puts "        ... save Project: $decission\n"
                puts "\n"
                
                switch  -exact -- $decission {
                    {yes}     { 
                                # even if saved or not, because of handling of bind of <Destroy>
                                puts "        ... save current project\n"
                                rattleCAD::model::file::saveProject_xml }
                    {no}      {
                                # even if saved or not, because of handling of bind of <Destroy>
                                puts "        ... exit rattleCAD withoud saving current project\n"
								rattleCAD::control::setSession  projectSave  [clock milliseconds]
                                  # set ::APPL_Config(PROJECT_Save) [clock milliseconds] 
                              }
                    {cancel}  {
                                # leef this control - go back to rattleCAD
                                puts "        ... exit rattleCAD canceled\n"
                                return
                              }
                    default   {}
                }
                
                puts "\n"
                puts "        ... check file save by date\n\n"
                puts "  ====== e x i t   r a t t l e C A D ============== END ==\n\n"
                # exit
                
            } else {
            
                puts "\n"
                puts "        ... save current project not required\n\n"
                puts "  ====== e x i t   r a t t l e C A D ============== END ==\n\n"
                # exit
                
            }
            close $::APPL_Config(LogFile)
            exit
            
    }


    #-------------------------------------------------------------------------
        #  exit application   
        #
    proc rattleCAD::view::gui::toggle_Fullscreen {} {   
                
            variable toggleFullScreenWidgets
            
            set changeIndex [rattleCAD::control::changeList::get_changeIndex]
                
            puts "\n"
            puts "  ====== fullscreen   r a t t l e C A D ==========="
            puts ""

                # puts "     ... wm maxsize: [wm maxsize .]"
            update
                # set x [winfo screenwidth  .]
                # set y [winfo screenheight .]
                # puts "     ... $x / $y"
            
            set currentState [wm attribute . -fullscreen]
            puts "     ... \$currentState: $currentState"
                #
            if {$currentState == 0} {
                wm attribute . -fullscreen 1
                foreach widget $toggleFullScreenWidgets {
                    grid $widget
                }
            } else {
                wm attribute . -fullscreen 0
                foreach widget $toggleFullScreenWidgets {
                    grid remove $widget
                }
            }
                #
            puts "\n"
            rattleCAD::view::gui::notebook_refitCanvas
                #
            puts "\n"
                #
            return
                #
    }


    #-------------------------------------------------------------------------
        #  show Console   
        #
    proc rattleCAD::view::gui::show_Console {} {   
        if {[catch { console show } eID]} {
            puts ""
            puts "      <E> rattleCAD::view::gui::show_Console"
            puts ""
            puts "            ... $eID"
            puts ""
        }
    }


    #-------------------------------------------------------------------------
        #  get current canvasCAD   
        #
    proc rattleCAD::view::gui::current_canvasCAD {} {
            variable noteBook_top        
            set current_cv [$noteBook_top select]
                # puts "        current canvasCAD: $current_cv"
            set varName "rattleCAD::view::gui::[lindex [split $current_cv .] end]"
                # puts "        -> $varName"
            return $varName
    }
    #-------------------------------------------------------------------------
        #  select specific canvasCAD tab   
        #
    proc rattleCAD::view::gui::select_canvasCAD {cv} {
            variable noteBook_top        
            
                puts " ... <D>  select_canvasCAD $cv"
            
            set cvID    [format "rattleCAD::view::gui::%s" $cv]
            set cvPath  [$cvID getNodeAttr Canvas path]
            set noteBook   [winfo parent [winfo parent $cvPath]] 
                 puts "         $noteBook"
                 puts "            exists: [winfo exists [winfo parent $cvPath]]"
            if {[winfo exists $cvPath]} {
                $noteBook select  [winfo parent $cvPath]   
                return [$noteBook select]
            } else {
                puts ""
                puts "         ... <E> select_canvasCAD:"
                puts "               $cv / $cvID  ... does not exist\n"
                return {}
            }
    }
    #-------------------------------------------------------------------------
        #  fill canvasCAD   
        #
    proc rattleCAD::view::gui::fill_canvasCAD {{varName {}}} {
            variable noteBook_top
            
            puts "         -------------------------------"
            puts "          rattleCAD::view::gui::fill_canvasCAD"
            puts "             varName:         $varName"
            if {$varName == {}} {
                set current_cv [$noteBook_top select]
                puts "        current canvasCAD: $current_cv"
                set varName [lindex [split $current_cv .] end]
                puts "        -> $varName"
                # return
            }
            
            switch -exact -- $varName {
                cv_Custom00 -
                cv_Custom01 -
                cv_Custom02 -
                cv_Custom10 -
                cv_Custom20 -
                cv_Custom30 -
                cv_Custom40 -
                cv_Custom50 -
                cv_Custom60 -
                cv_Custom70 {
                        $noteBook_top select $noteBook_top.$varName
                        rattleCAD::cv_custom::updateView     rattleCAD::view::gui::$varName 
                        # rattleCAD::view::gui::notebook_refitCanvas
                    }
                cv_Component {
                        ::update
                        rattleCAD::view::gui::notebook_refitCanvas
                        rattleCAD::comp_library::updateCanvas
                    }
                __cv_Library {
                        # ::update
                        # rattleCAD::view::gui::notebook_refitCanvas
                        # rattleCAD::configPanel::updateCanvas
						puts " \n\n <D> in fill_canvasCAD:   __cv_Library  \n please give a response to the developers \n"
						tk_messageBox -message " in fill_canvasCAD:   __cv_Library  \n please give a response to the developers"
                    }
                
            }
    }


    #-------------------------------------------------------------------------
       #  get notebook window    
       #
    proc rattleCAD::view::gui::notebook_getWidget {varName} {
            variable notebookCanvas
            
            foreach index [array names notebookCanvas] {
                if {$index == $varName} {
                      # puts "$index $varName -> $notebookCanvas($index) "
                    return $notebookCanvas($index)
                }
            }
    }
    #-------------------------------------------------------------------------
        #  get notebook id    
        #
    proc rattleCAD::view::gui::notebook_getTabInfo {varName} {
             variable noteBook_top       
               # puts "\n --------"
               # puts "[$noteBook_top tabs]"
             set i 0
             foreach index [$noteBook_top tabs] {
                 set tabWidget "$noteBook_top.$varName"
                 if {$index == $tabWidget} {
                     # puts "$index $varName -> $tabWidget"
                     return [list $i $index]
                 }
                 incr i
             }
             return {}
     }
    
    
    #-------------------------------------------------------------------------
       #  get notebook window    
       #
    proc rattleCAD::view::gui::notebook_getVarName {tabID} {
                # tabID:      [$noteBook_top select]
                #            .mainframe.frame.f2.nb.cv_Custom30
            variable notebookCanvas
            variable external_canvasCAD

                # -- rattleCAD::view::gui::notebookCanvas
            set cvID $tabID.cvCAD
            foreach varName [array names notebookCanvas] {
                    # puts "          -> $varName $notebookCanvas($varName) "
                if {$notebookCanvas($varName) == $cvID} {
                    return [namespace current]::$varName
                }
            }
                # -- rattleCAD::view::gui::external_canvasCAD
            foreach varName [array names external_canvasCAD] {
                     puts "          -> equal?: $varName  -> $external_canvasCAD($varName) "
                     puts "                 vs. $tabID   "
                if {$varName == $tabID} {
                    return $external_canvasCAD($varName)
                }
            }
    }


    #-------------------------------------------------------------------------
       #  register external canvasCAD-Widgets
       #
    proc rattleCAD::view::gui::register_external_canvasCAD {tabID cvID} {
            variable external_canvasCAD
            set external_canvasCAD($tabID) $cvID    
            puts "\n            register_external_canvasCAD: $tabID $external_canvasCAD($tabID)"
            puts   "                                         [$cvID getNodeAttr Canvas path]"
     }


    #-------------------------------------------------------------------------
       #  scale canvasCAD in current notebook-Tab  
       #
    proc rattleCAD::view::gui::notebook_scaleCanvas {value} {
            variable noteBook_top

            set currentTab [$noteBook_top select]
            set varName    [notebook_getVarName $currentTab]
                # puts "   varName: $varName"
            if { $varName == {} } {
                    puts "   notebook_scaleCanvas::varName: $varName"
                    return
            }
            set curScale  [ eval $varName getNodeAttr Canvas scale ]
            set newScale  [ format "%.4f" [ expr $value * $curScale * 1.0 ] ]
              # puts "   $curScale"
              # tk_messageBox -message "curScale: $curScale  /  newScale  $newScale "
            $varName scaleToCenter $newScale
    }


    #-------------------------------------------------------------------------
       #  refit notebookCanvas in current notebook-Tab  
       #
    proc rattleCAD::view::gui::notebook_refitCanvas {} {
            variable noteBook_top

                #
            update
                #
            set currentTab [$noteBook_top select]
            set varName    [notebook_getVarName $currentTab]
                puts "       ... notebook_refitCanvas: \$varName $varName"
            if { $varName == {} } {
                puts "       ... notebook_refitCanvas: \$varName: $varName ... undefined"
                return
            }
              # tk_messageBox -message "currentTab: $currentTab   /  varName  $varName"
            $varName refitStage
              #
            
              # remove position value in $rattleCAD::cv_custom::Position -> do a recenter
            rattleCAD::cv_custom::unset_Position
              #
              
              #
            rattleCAD::cv_custom::updateView     [string trimleft $varName "::"]
              #
              
            return

    }


    #-------------------------------------------------------------------------
       #  clean canvasCAD in current notebook-Tab  
       #
    proc rattleCAD::view::gui::notebook_cleanCanvas {} {
            variable noteBook_top

            set currentTab [$noteBook_top select]
            set varName    [notebook_getVarName $currentTab]
            if { $varName == {} } {
                puts "   notebook_cleanCanvas::varName: $varName"
                return
            }
            $varName clean_StageContent
    }
    
    
    #-------------------------------------------------------------------------
        #  switch notebook-Tab  
        #
    proc rattleCAD::view::gui::notebook_switchTab {cvTab} {
        variable noteBook_top
          # puts ""
          # puts " ---------------"
          # puts " notebook_switchTab"
        set tabInfo [notebook_getTabInfo $cvTab]
        set tabID       [lindex $tabInfo 0]
        set tabWidget   [lindex $tabInfo 1]
        set tabState   [$noteBook_top tab  $tabID -state]
        
        if {$tabState == {hidden}} {
            $noteBook_top add    $tabWidget
            $noteBook_top select $tabID
        } else {
            $noteBook_top hide   $tabID
        }
        return
    }





  
    #-------------------------------------------------------------------------
       #  export canvasCAD from every notebook-Tab
       #
    proc rattleCAD::view::gui::export_Project { {type {html}}} {
            variable noteBook_top
            variable notebookCanvas     
            
                 # --- get currentTab
            set currentTab     [$noteBook_top select]
            set cv_Name        [notebook_getVarName $currentTab]           
              # set cv_ID          [lindex [string map {:: { }} $cv_Name] 1]
              # set cv_ID          [lindex [string map {:: { }} $cv_Name] 2] ... 3.4.01.40
            set cv_ID          [lindex [string map {:: { }} $cv_Name] 3]
              # tk_messageBox -message " export_Project: $cv_Name / $cv_ID"
            puts "\n\n"
                  # puts "   export_Project::cv_Name: $cv_Name $cv_ID"
                  # tk_messageBox -message  "   notebook_exportSVG::cv_Name: $cv_Name"    
            switch -exact $type {
                html {   set exportDir  $::APPL_Config(EXPORT_HTML) }
                pdf  {   set exportDir  $::APPL_Config(EXPORT_PDF)}
                default {}
            }
                
                
                # --- export content to HTML
            puts "\n\n  ====== e x p o r t  P R O J E C T ===============\n"                         
            puts "      export project to -> $type \n"
            puts "      export_Project   $currentTab / $cv_Name / $cv_ID"
            puts "             currentTab-Parent  [winfo parent $currentTab]  "
            puts "             currentTab-Parent  [winfo name   $currentTab]  "
            puts "             canvasCAD Object   $cv_Name  "
            puts ""
            
                # --- cleanup export directory
            if { [catch {set contents [glob -directory $exportDir *]} fid] } {
                set contents {}
            }
    
                  # puts "Directory contents are:"
            puts ""
            foreach item $contents {
                puts "             ... cleanup $item"
                catch {file delete -force $item}
            }
            puts "\n"            
            
                # --- prepare export directory
            switch -exact $type {
                html {
                        set indexHTML [file join $::APPL_Config(EXPORT_HTML) index.html]
                        file copy -force [file join $::APPL_Config(CONFIG_Dir) html/index.html]     $::APPL_Config(EXPORT_HTML)
                        file copy -force [file join $::APPL_Config(CONFIG_Dir) html/style.css]      $::APPL_Config(EXPORT_HTML)
                        file copy -force [file join $::APPL_Config(CONFIG_Dir) html/rattleCAD.ico]  $::APPL_Config(EXPORT_HTML)
                              
                            # --- get project file 
                        if {[file exists [rattleCAD::control::getSession  projectFile]] == 1} {
                              # file exists
                            puts "             ... [rattleCAD::control::getSession  projectFile]"
							set sourceFile  [rattleCAD::control::getSession  projectFile]
                        } else {
                              # file does not exists
                            puts "             ... $::APPL_Config(TemplateInit)"
                            set sourceFile  $::APPL_Config(TemplateInit)
                        } 

                        catch {file copy -force $sourceFile [file join $::APPL_Config(EXPORT_HTML) project.xml]}
                        
                            # --- loop through content
                              # puts "[lsort [array names notebookCanvas]]"
                        foreach cadCanv [lsort [array names notebookCanvas]] {
                            if {$cadCanv == {cv_Custom02}} {continue}
                                # tk_messageBox -message "   -> $cadCanv"
                                # puts "  <D> -> $cadCanv"
                                #  parray notebookCanvas
                            select_canvasCAD $cadCanv
                            update
                            notebook_exportSVG $exportDir noOpen
                        }
                        select_canvasCAD $cv_ID 

                            # --- open index.html
                        puts "    ------------------------------------------------"
                        puts "      ... open $indexHTML "
                        
                        rattleCAD::model::file::open_localFile $indexHTML
                    }
                
                pdf {
                        foreach cadCanv [lsort [array names notebookCanvas]] {
                            if {$cadCanv == {cv_Custom02}} {continue}
                              # puts "   -> $cadCanv"
                            select_canvasCAD $cadCanv
                            set w            [$cadCanv getNodeAttr    Canvas    path]            
                              # puts "   ->    $w"
                            update
                            $w lower {__NB_Button__}        all
                            $w lower {__cvEdit__}           all
                            $w lower {__Select__SubMenue__} all
                            update
                            notebook_exportPS $exportDir noOpen
                            $w raise {__NB_Button__}        all
                            $w raise {__cvEdit__}           all
                            $w raise {__Select__SubMenue__} all
                            update
                        }
                            #
                        rattleCAD::tubeMiter::exportPS_Areas
                            #
                        rattleCAD::model::file::create_summaryPDF $exportDir
                    }

                default {}
            }

            $noteBook_top select $currentTab
        
            return

    }


    #-------------------------------------------------------------------------
       #  export canvasCAD from current notebook-Tab as PostScript 
       #
    proc rattleCAD::view::gui::notebook_exportPS {printDir {postEvent {open}}} {
            variable noteBook_top

                # --- get currentTab
            set currentTab     [ $noteBook_top select ]
            set cv_Name        [ notebook_getVarName $currentTab]
            if { $cv_Name == {} } {
                    puts "   notebook_exportPS::cv_Name: $cv_Name"
                    return
            }

                # --- get stageScale
            set stageScale    [ $cv_Name  getNodeAttr  Stage    scale ]    
            set scaleFactor   [ expr round([ expr 1 / $stageScale ]) ]
                
                # --- get stageHeight
            set stageHeight   [ $cv_Name  getNodeAttr  Stage    height ]    

                # --- set timeStamp
            set timeString    [ format "timestamp: %s" [ clock format [clock seconds] -format {%Y.%m.%d %H:%M} ] ]
            set textPos       [ vectormath::scalePointList {0 0} [list 10 [expr $stageHeight - 10]] $scaleFactor ]
            set timeStamp     [ $cv_Name create draftText $textPos  -text $timeString -size 2.5 -anchor sw ]

                # --- set exportFile
            set stageTitle    [ $cv_Name  getNodeAttr  Stage  title ]
            set fileName      [ winfo name   $currentTab]___[ string map {{ } {_}} [ string trim $stageTitle ] ]
            set exportFile    [ file join $printDir ${fileName}.ps ]
            set exportFile    [ file normalize $exportFile]
                # set exportFile [ file join $printDir [winfo name   $currentTab].svg ]

                # --- export content to File
            puts "    ------------------------------------------------"
            puts "      export PS - Content to    $exportFile \n"
            puts "         notebook_exportPS      $currentTab "
            puts "             currentTab-Parent  [winfo name   $currentTab]  "
            puts "             currentTab-Parent  [winfo parent $currentTab]  "
            puts "             canvasCAD Object   [$cv_Name getNodeAttr    Canvas    path]"
            puts "                          ...   $cv_Name"
            
                # $cv_Name print $exportFile
            set exportFile [$cv_Name print $exportFile]
                
                # --- delete timeStamp
            catch [ $cv_Name delete $timeStamp ]

            if {$postEvent == {open}} {
                puts "\n"
                puts "    ------------------------------------------------"
                puts ""
                puts "      ... open $exportFile "
                
                rattleCAD::model::file::openFile_byExtension $exportFile 
            }
            puts "    ------------------------------------------------"
            puts "      ... open $exportFile "
                          
    }


    #-------------------------------------------------------------------------
       #  export canvasCAD from current notebook-Tab as Standard Vector Graphic
       #
    proc rattleCAD::view::gui::notebook_exportSVG {printDir {postEvent {open}}} {
            variable noteBook_top

                # --- get currentTab
            set currentTab     [ $noteBook_top select ]
            set cv_Name        [ notebook_getVarName $currentTab]
            if { $cv_Name == {} } {
                puts "   notebook_exportSVG::cv_Name: $cv_Name"
                return
            }
            
                # --- set exportFile
            set stageTitle    [ $cv_Name  getNodeAttr  Stage  title ]
            set fileName     [ winfo name   $currentTab]___[ string map {{ } {_}} [ string trim $stageTitle ] ]
            set exportFile    [ file join $printDir ${fileName}.svg ]
                # set exportFile [ file join $printDir [winfo name   $currentTab].svg ]

                # --- export content to File
            puts "    ------------------------------------------------"
            puts "      export SVG - Content to    $exportFile \n"
            puts "         notebook_exportSVG     $currentTab "
            puts "             currentTab-Parent  [winfo name   $currentTab]  "
            puts "             currentTab-Parent  [winfo parent $currentTab]  "
            puts "             canvasCAD Object   [$cv_Name getNodeAttr    Canvas    path]"
            puts "                          ...   $cv_Name"
            
            set exportFile [$cv_Name exportSVG $exportFile]
            
            if {$postEvent == {open}} {
                puts "\n"
                puts "    ------------------------------------------------"
                puts ""
                puts "      ... open $exportFile "
                
                rattleCAD::model::file::open_localFile $exportFile
            }
            
                # rattleCAD::model::file::openFile_byExtension $exportFile
                # rattleCAD::model::file::openFile_byExtension $exportFile .htm
    }


    #-------------------------------------------------------------------------
       #  export canvasCAD from current notebook-Tab as SVG Graphic
       #
    proc rattleCAD::view::gui::notebook_exportDXF {printDir {postEvent {open}}} {
            variable noteBook_top

                # --- get currentTab
            set currentTab     [ $noteBook_top select ]
            set cv_Name        [ notebook_getVarName $currentTab]
            if { $cv_Name == {} } {
                    puts "   notebook_exportDXF::cv_Name: $cv_Name"
                    return
            }
            
                # --- set exportFile
            set stageTitle    [ $cv_Name  getNodeAttr  Stage  title ]
            set fileName      [ winfo name   $currentTab]___[ string map {{ } {_}} [ string trim $stageTitle ] ]
            set exportFile    [ file join $printDir ${fileName}.dxf ]

                # --- export content to File
            puts "    ------------------------------------------------"
            puts "      export DXF - Content to    $exportFile \n"
            puts "         notebook_exportDXF     $currentTab "
            puts "             currentTab-Parent  [winfo name   $currentTab]  "
            puts "             currentTab-Parent  [winfo parent $currentTab]  "
            puts "             canvasCAD Object   [$cv_Name getNodeAttr    Canvas    path]"
            puts "                          ...   $cv_Name"
            
            set exportFile [$cv_Name exportDXF $exportFile]
            
            if {$postEvent == {open}} {
                puts "\n"
                puts "    ------------------------------------------------"
                puts ""
                puts "      ... open $exportFile "
                
                rattleCAD::model::file::open_localFile $exportFile
            }            
              # rattleCAD::model::file::open_localFile $exportFile
              # rattleCAD::model::file::openFile_byExtension $exportFile .dxf
    }


    #-------------------------------------------------------------------------
       #  create a Button inside a canvas of notebookCanvas
       #
    proc rattleCAD::view::gui::notebook_createButton {nb_Canvas cv_ButtonContent} {
            
            puts ""
            puts "         -------------------------------"
            puts "          rattleCAD::view::gui::notebook_createButton"
            puts "             cv_ButtonContent:   $cv_ButtonContent"
            set cv_Name [lindex [split $nb_Canvas :] end]
            set cv      [rattleCAD::view::gui::notebook_getWidget  $cv_Name]
            
            catch { destroy $cv.buttonFrame }
            frame   $cv.buttonFrame            
                # button  $cv.buttonFrame.bt -text test
                #
            set idx 0
            set x_Position  4
            set y_Position  4
                #
            puts "  <I> $nb_Canvas"
                #
            switch -exact $cv_ButtonContent {
                    change_Rendering {
                                # -- create a Button to set Rendering: BottleCage, Fork, ...
                                $nb_Canvas configCorner [format {rattleCAD::view::gui::change_Rendering %s %s %s} $cv $x_Position $y_Position ]
                            } 
                    check_TubingAngles {
                                # -- create a Button to execute tubing_checkAngles
                                $nb_Canvas configCorner [format {rattleCAD::view::gui::tubing_checkAngles %s} $cv]                   
                            }
                    default {
                                $nb_Canvas configCorner [format {rattleCAD::view::gui::notebook_ButtonEvent %s %s} $cv $cv_ButtonContent ]
                        }
            }
            
                #
            return
            
    }            


    proc rattleCAD::view::gui::notebook_ButtonEvent {cv contentList} {
                #
            set x_Position  4
            set y_Position  4
                #
            puts "\n      \$cv     $cv"
                #
            set contentFrame [notebook_createConfigContainer $cv $x_Position $y_Position ]
                #
            if {$contentFrame == {}} { return }
                #
            puts "\n      \$contentFrame  $contentFrame"
            puts "\n      \$cv  $cv"
            puts "\n      \$contentList  $contentList"
                #
            foreach addConfig [split $contentList ,] {
                lappend thisContent $addConfig 
                lappend thisContent separator 
            }
            
            set id 0
            foreach addConfig [lrange $thisContent 0 end-1] {
                incr id
                switch -exact $addConfig {
                        separator {                 add_ConfigSeparator     $contentFrame $id}
                        configMode_Frame {          add_ConfigFrameMode     $contentFrame }
                        configMode_BaseDimension {  add_ConfigBaseDimension $contentFrame }
                        configMode_ChainStay {      add_ConfigChainStay     $contentFrame }
                        configMode_FrameJig {       add_ConfigFrameJig      $contentFrame }
                        change_FormatScale {        add_ConfigFormatScale   $contentFrame }
                        pageConfig_Scale {          add_ConfigScale         $contentFrame }
                        pageConfig_Format {         add_ConfigFormat        $contentFrame }
                        default {}
                }
            }
    } 


    proc rattleCAD::view::gui::notebook_createConfigContainer {cv x y {title {Config}}} {
                #
            puts "\n      \$cv     $cv"
                #
            set cv_Name [lindex [split $cv .] end-1]
                #
            puts "\n      \$cv_Name     $cv_Name"
                #
            if {[ $cv find withtag __Select__SubMenue__ ] != {} } {
                    $cv delete     __Select__SubMenue__
                    $cv dtag       __Select__SubMenue__
                    destroy        .f_subMenue_$cv_Name
                    #tk_messageBox -message "delete Container"        
                    return {}
            } else {
                    if {[catch { set baseFrame [frame .f_subMenue_$cv_Name  -relief raised -border 1]} eID]} {
                        return {}
                    } else {
                            $cv create window $x $y \
                                    -window $baseFrame \
                                    -anchor nw \
                                    -tags __Select__SubMenue__
                            frame   $baseFrame.select 
                            pack    $baseFrame.select       
                            frame   $baseFrame.select.lf       
                            pack    $baseFrame.select.lf       -padx 2 -pady 2 -fill x
                            label   $baseFrame.select.lf.label -text $title -fg white -bg gray60 -justify left
                            pack    $baseFrame.select.lf.label -fill x
                                #
                            set newFont [format {%s bold}  [$baseFrame.select.lf.label cget -font]]
                            $baseFrame.select.lf.label configure   -font $newFont
                                #
                            bind $baseFrame.select.lf.label  <Button-1>    [list destroy $baseFrame]
                                #
                            set contentFrame    [frame $baseFrame.select.content -relief flat -bd 2 ]
                            pack $contentFrame  -fill x -expand yes
                                    #
                            #tk_messageBox -message "new Container"        
                                    #
                            return $contentFrame 
                    }
                    
                    #tk_messageBox -message "not successfull"        
                    
            }      
    } 


    proc rattleCAD::view::gui::add_ConfigSeparator {w index} {
                #
            variable frame_configMethod
            variable show_summaryDimension
                #
            set frameName [format {%s.sep_%s} $w $index]
            set frameName [format {sep_%s} $index]
            set contentFrame [frame $w.$frameName]
            pack $contentFrame -fill x
                #
            ttk::separator $contentFrame.seperator
            #grid config $contentFrame.seperator   -column 0 -row  1 -sticky "nsew"
            pack $contentFrame.seperator -fill x
                #
            return
                #
    }
  
    proc rattleCAD::view::gui::pushedButtonState mode {
        
            #
            #  not implemented yet
            #
        
        if {$mode != {}} {
            switch -exact $mode {
                    {OutsideIn}  -
                    {StackReach} -
                    {Lugs}       -
                    {Classic}   { 
                                set rattleCAD::control::frame_configMode $mode
                                rattleCAD::control::set_frameConfigMode
                            }
                    default return
            }
        }
        
        foreach button [list $contentFrame.hybrid   ] {
            $button configure -relief raised
        }
        switch -exact $mode {
                {OutsideIn}  { $contentFrame.hybrid     configure -relief sunken }
                {StackReach} { $contentFrame.stackreach configure -relief sunken}
                {Lugs}       { $contentFrame.classic    configure -relief sunken}
                {Classic}    { $contentFrame.lugs       configure -relief sunken}
                default {}
        }
        
        
        return
        
        puts $colour
        set label [.$colour cget -text]
        foreach c $::colours {
            .$c configure -relief [expr {$c eq $label ? "sunken" : "raised"}]
        }
    }
    
    
    
    #-------------------------------------------------------------------------
       #  update Personal Geometry with parameters of Reference Geometry 
       #
    proc rattleCAD::view::gui::tubing_checkAngles {cv {type {default}}} {
            rattleCAD::view::check_TubingAngles
    }


    #-------------------------------------------------------------------------
       #  create menue to switch frame configuration mode 
       #
    proc rattleCAD::view::gui::add_ConfigFrameMode {w {type {default}}} {
                #
            variable frame_configMethod
            variable show_summaryDimension
                #                #
            set contentFrame [frame $w.frameMode]
            pack $contentFrame -fill x 
                    #
            #ttk::separator $contentFrame.seperator_1
            label       $contentFrame.label      -text "Frame Config:"      
            #ttk::separator $contentFrame.seperator_1
                # button $contentFrame.hybrid       -text "Outside-In"        -command {rattleCAD::view::gui::pushedButtonState OutsideIn }
                # button $contentFrame.stackreach   -text "Stack & Reach"     -command {rattleCAD::view::gui::pushedButtonState StackReach}
                # button $contentFrame.classic      -text "Classic"           -command {rattleCAD::view::gui::pushedButtonState Classic   }
                # button $contentFrame.lugs         -text "Lug Angles"        -command {rattleCAD::view::gui::pushedButtonState Lugs      }
            radiobutton $contentFrame.hybrid       -text "Outside-In"        -value {OutsideIn}     -variable rattleCAD::control::frame_configMode  -command {rattleCAD::control::set_frameConfigMode}
            radiobutton $contentFrame.stackreach   -text "Stack & Reach"     -value {StackReach}    -variable rattleCAD::control::frame_configMode  -command {rattleCAD::control::set_frameConfigMode}
            radiobutton $contentFrame.classic      -text "Classic"           -value {Classic}       -variable rattleCAD::control::frame_configMode  -command {rattleCAD::control::set_frameConfigMode}
            radiobutton $contentFrame.lugs         -text "Lug Angles"        -value {Lugs}          -variable rattleCAD::control::frame_configMode  -command {rattleCAD::control::set_frameConfigMode}
                #
            #grid config $contentFrame.seperator_1   -column 0 -row  1 -sticky "nsew"
            grid config $contentFrame.label         -column 0 -row  0 -sticky "w"
            #grid config $contentFrame.seperator_2   -column 0 -row  1 -sticky "nsew"
            grid config $contentFrame.hybrid        -column 0 -row  2 -sticky "w"
            grid config $contentFrame.stackreach    -column 0 -row  3 -sticky "w"
            grid config $contentFrame.classic       -column 0 -row  4 -sticky "w"
            grid config $contentFrame.lugs          -column 0 -row  5 -sticky "w"
                #                #
            set newFont [format {%s bold}  [$contentFrame.label cget -font]]
            $contentFrame.label configure   -font $newFont
                #
            return
                #
    }
    #-------------------------------------------------------------------------
       #  create menue to show dimension in BaseConfig
       #
    proc rattleCAD::view::gui::add_ConfigBaseDimension {w {type {default}}} {
                #
            variable frame_configMethod
            variable show_summaryDimension
                #                #
            set contentFrame [frame $w.baseDim]
            pack $contentFrame -fill x 
                    #
            #ttk::separator $contentFrame.seperator  
            label       $contentFrame.label        -text "Show Dimension:"      
            checkbutton $contentFrame.dimSec       -text "Secondary"         -variable rattleCAD::view::gui::show_secondaryDimension                -command {rattleCAD::view::updateView force}
            checkbutton $contentFrame.dimRes       -text "Result"            -variable rattleCAD::view::gui::show_resultDimension                   -command {rattleCAD::view::updateView force}
            checkbutton $contentFrame.dimSum       -text "Summary"           -variable rattleCAD::view::gui::show_summaryDimension                  -command {rattleCAD::view::updateView force}
                #
            #grid config $contentFrame.seperator    -column 0 -row  1 -sticky "nsew"
            grid config $contentFrame.label        -column 0 -row  2 -sticky "w"
            grid config $contentFrame.dimSec       -column 0 -row  3 -sticky "w"
            grid config $contentFrame.dimRes       -column 0 -row  4 -sticky "w"
            grid config $contentFrame.dimSum       -column 0 -row  5 -sticky "w"
                #
            $contentFrame.dimSec    configure  -activebackground $rattleCAD::cv_custom::DraftingColour(secondary)   -activeforeground white
            $contentFrame.dimRes    configure  -activebackground $rattleCAD::cv_custom::DraftingColour(result)      -activeforeground white
            $contentFrame.dimSum    configure  -activebackground $rattleCAD::cv_custom::DraftingColour(background)  -activeforeground white
                #
            set newFont [format {%s bold}  [$contentFrame.label cget -font]]
            $contentFrame.label configure   -font $newFont
                #
            return
                #
    }
    #-------------------------------------------------------------------------
       #  create menue to switch ChainStayMode
       #
    proc rattleCAD::view::gui::add_ConfigChainStay {w {type {default}}} {
                #
            set rattleCAD::control::frame_chainStayType [rattleCAD::model::get_Config ChainStay]
                
                #
            set contentFrame [frame $w.chainStay]
            pack $contentFrame -fill x 
                    #
            #ttk::separator $contentFrame.seperator  
            label       $contentFrame.label     -text "ChainStay Type:"      
            radiobutton $contentFrame.straight  -text "straight"         -value {straight}   -variable rattleCAD::control::frame_chainStayType   -command {rattleCAD::control::set_chainStayType} 
            radiobutton $contentFrame.bent      -text "bent"             -value {bent}       -variable rattleCAD::control::frame_chainStayType   -command {rattleCAD::control::set_chainStayType} 
            radiobutton $contentFrame.hide      -text "hide"             -value {off}        -variable rattleCAD::control::frame_chainStayType   -command {rattleCAD::control::set_chainStayType} 
                #
            #grid config $contentFrame.seperator    -column 0 -row  1 -sticky "nsew"
            grid config $contentFrame.label     -column 0 -row  2 -sticky "w"
            grid config $contentFrame.straight  -column 0 -row  3 -sticky "w"
            grid config $contentFrame.bent      -column 0 -row  4 -sticky "w"
            grid config $contentFrame.hide      -column 0 -row  5 -sticky "w"
                #
            set newFont [format {%s bold}  [$contentFrame.label cget -font]]
            $contentFrame.label configure   -font $newFont
                #
            return
                #
    }
    #-------------------------------------------------------------------------
       #  create menue to change size of Stage 
       #
    proc rattleCAD::view::gui::add_ConfigFormat {w {header {default}}}  {
                #
                #
            variable noteBook_top
                #
                #
                # --- get stageScale
            set currentTab [$noteBook_top select]
            set cv_Name    [notebook_getVarName $currentTab]
                # puts "  -- > $cv_Name < --"
            set rattleCAD::view::gui::stageFormat  [$cv_Name getNodeAttr Stage format]
                # puts "  -- > $rattleCAD::view::gui::stageScale < --"
                #
            set contentFrame [frame $w.pageFormat]
            pack $contentFrame -fill x 
                #
            # ttk::separator $contentFrame.seperator
                #
            label       $contentFrame.label     -text "DIN Format:"      
                #
            radiobutton $contentFrame.a4 -text A4 -value A4    -variable rattleCAD::view::gui::stageFormat  -command {rattleCAD::view::gui::notebook_formatCanvas}
            radiobutton $contentFrame.a3 -text A3 -value A3    -variable rattleCAD::view::gui::stageFormat  -command {rattleCAD::view::gui::notebook_formatCanvas}
            radiobutton $contentFrame.a2 -text A2 -value A2    -variable rattleCAD::view::gui::stageFormat  -command {rattleCAD::view::gui::notebook_formatCanvas}
            radiobutton $contentFrame.a1 -text A1 -value A1    -variable rattleCAD::view::gui::stageFormat  -command {rattleCAD::view::gui::notebook_formatCanvas}
            radiobutton $contentFrame.a0 -text A0 -value A0    -variable rattleCAD::view::gui::stageFormat  -command {rattleCAD::view::gui::notebook_formatCanvas}
                #
            # grid config $contentFrame.seperator -column 0 -row 0 -sticky "news"
            grid config $contentFrame.label     -column 0 -row 1 -sticky "w"
            grid config $contentFrame.a4        -column 0 -row 2 -sticky "w"
            grid config $contentFrame.a3        -column 0 -row 3 -sticky "w"
            grid config $contentFrame.a2        -column 0 -row 4 -sticky "w"
            grid config $contentFrame.a1        -column 0 -row 5 -sticky "w"
            grid config $contentFrame.a0        -column 0 -row 6 -sticky "w"
                #
            set newFont [format {%s bold}  [$contentFrame.label cget -font]]
            $contentFrame.label configure   -font $newFont
                #
                #
            set rbName [format "%s.%s" $contentFrame [string tolower $rattleCAD::view::gui::stageFormat]]
                # puts "  -> $contentFrame "
                # puts "  -> $rbName "
            catch {$rbName select}
                #
            if {$header == {noHeader}} {
                grid forget $contentFrame.label
            }    
                #
                #
            return    
                #          
    }
    #-------------------------------------------------------------------------
       #  create menue to change scale of Stage 
       #
    proc rattleCAD::view::gui::add_ConfigScale {w {header {default}}}  {
                #
            variable noteBook_top
                #
                #
                # --- get stageScale
            set currentTab [$noteBook_top select]
            set cv_Name    [notebook_getVarName $currentTab]
                # puts "  -- > $cv_Name < --"
            set rattleCAD::view::gui::stageScale  [format %.2f [$cv_Name  getNodeAttr  Stage    scale ]]
                # puts "  -- > $rattleCAD::view::gui::stageScale < --"
                #
            set contentFrame [frame $w.pageScale]
            pack $contentFrame -fill x 
                #
                # ttk::separator $contentFrame.seperator
                #
            label       $contentFrame.label     -text "Page Scale:"
                #
            radiobutton $contentFrame.s020 -text "1:5  "     -value 0.20 -anchor w     -variable rattleCAD::view::gui::stageScale -command {rattleCAD::view::gui::notebook_formatCanvas}
            radiobutton $contentFrame.s025 -text "1:4  "     -value 0.25 -anchor w     -variable rattleCAD::view::gui::stageScale -command {rattleCAD::view::gui::notebook_formatCanvas}
            radiobutton $contentFrame.s033 -text "1:3  "     -value 0.33 -anchor w     -variable rattleCAD::view::gui::stageScale -command {rattleCAD::view::gui::notebook_formatCanvas}
            radiobutton $contentFrame.s040 -text "1:2,5"     -value 0.40 -anchor w     -variable rattleCAD::view::gui::stageScale -command {rattleCAD::view::gui::notebook_formatCanvas}
            radiobutton $contentFrame.s050 -text "1:2  "     -value 0.50 -anchor w     -variable rattleCAD::view::gui::stageScale -command {rattleCAD::view::gui::notebook_formatCanvas}
            radiobutton $contentFrame.s100 -text "1:1  "     -value 1.00 -anchor w     -variable rattleCAD::view::gui::stageScale -command {rattleCAD::view::gui::notebook_formatCanvas}
                #
                # grid config $contentFrame.seperator -column 0 -row  1 -sticky "news"
            grid config $contentFrame.label     -column 0 -row  2 -sticky "w"
            grid config $contentFrame.s020      -column 0 -row  3 -sticky "w"
            grid config $contentFrame.s025      -column 0 -row  4 -sticky "w"
            grid config $contentFrame.s033      -column 0 -row  5 -sticky "w"
            grid config $contentFrame.s040      -column 0 -row  6 -sticky "w"
            grid config $contentFrame.s050      -column 0 -row  7 -sticky "w"
            grid config $contentFrame.s100      -column 0 -row  8 -sticky "w"
                #
            set newFont [format {%s bold}  [$contentFrame.label cget -font]]
            $contentFrame.label configure   -font $newFont
                #
            set rbName [format "%s.s%03i" $contentFrame [expr int(100*$rattleCAD::view::gui::stageScale)]]
                # puts "  -> $contentFrame "
                # puts "  -> $rbName "
            catch {$rbName select}
                #
            if {$header == {noHeader}} {
                grid forget $contentFrame.label
            }       
                #
                #
            return    
                #          
    }
    #-------------------------------------------------------------------------
       #  create menue to change change FrameJig Version 
       #
    proc rattleCAD::view::gui::add_ConfigFrameJig {w {type {default}}}  {
                #
            set contentFrame [frame $w.frameJig]
            pack $contentFrame -fill x 
                #
            set f_FrameJig    [frame $contentFrame.jigType ]
              # foreach jig $::APPL_Config(list_FrameJigTypes) {}
            foreach jig $rattleCAD::model::valueRegistry(FrameJigType) {
                radiobutton     $f_FrameJig.option_$jig \
                                        -text $jig \
                                        -value $jig  \
                                        -anchor w  \
                                        -variable ::APPL_Config(FrameJigType)  \
                                        -command {rattleCAD::view::gui::updateFrameJig}
                pack $f_FrameJig.option_$jig -fill x -expand yes -side top
            }
            pack $f_FrameJig -side left -fill x
         
    }


    #-------------------------------------------------------------------------
       #  update Personal Geometry with parameters of Reference Geometry 
       #
    proc rattleCAD::view::gui::geometry_reference2personal {} {
        
            set answer    [tk_messageBox -icon question -type okcancel -title "Reference to Personal" -default cancel\
                                        -message "Do you really wants to overwrite your \"Personal\" parameter \n with \"Reference\" settings" ]
                #tk_messageBox -message "$answer"    
                
            switch $answer {
                cancel    return                
                ok        { frame_geometry_reference::export_parameter_2_geometry_custom  $rattleCAD::control::currentDOM
                            # frame_geometry_reference::export_parameter_2_geometry_custom  $::APPL_Config(root_ProjectDOM)
                            rattleCAD::view::gui::fill_canvasCAD cv_Custom00 
                          }
            }
    }


    #-------------------------------------------------------------------------
       #  change Rendering Settings 
       #
    proc rattleCAD::view::gui::change_Rendering  {{cv {}} {x 5} {y 20} {type {}}}  {
                #
            set x 0
            set y 140
                #
            rattleCAD::view::edit::group_Rendering_Parameter    $x  $y  [rattleCAD::view::gui::current_canvasCAD]
                #
            return
   }


    #-------------------------------------------------------------------------
       #  change canvasCAD Format and Scale
       #
    proc rattleCAD::view::gui::notebook_formatCanvas {} {
            variable canvasUpdate
            variable noteBook_top

                # puts "\n=================="
                # puts "    stageFormat $stageFormat"
                # puts "    stageScale  $stageScale"
                # puts "=================="
                    
            set currentTab [$noteBook_top select]
            set varName    [notebook_getVarName $currentTab]

                # puts "   varName: $varName"
            if { $varName == {} } {
                    puts "   notebook_refitCanvas::varName: $varName"
                    return
            }
                            
              #
			$varName formatCanvas $rattleCAD::view::gui::stageFormat  $rattleCAD::view::gui::stageScale
              # 

			  #
            notebook_refitCanvas
            rattleCAD::view::updateView force
			  # 
    }

    
    #-------------------------------------------------------------------------
       #  change type of Frame Jig dimensioning
       #
    proc rattleCAD::view::gui::updateFrameJig {} {
            variable noteBook_top
            
            set currentTab [$noteBook_top select]
            set varName    [notebook_getVarName $currentTab]
            set cv_Name    [notebook_getWidget  $varName]
            puts "   ... \$varName $varName"
            puts "   ... \$cv_Name $cv_Name"   

            set canvasUpdate($varName) [ expr $rattleCAD::control::model_Update -1 ]
			  #
			  
			  #
            rattleCAD::view::updateView force
			  #
    }
    
    #-------------------------------------------------------------------------
       #  load Template from File
       #
    proc rattleCAD::view::gui::load_Template {type} {
            variable canvasUpdate
            variable noteBook_top

            rattleCAD::model::file::openTemplate_xml $type
              #
            switch -exact $type {
                Road { set ::APPL_Config(TemplateInit) $::APPL_Config(TemplateRoad_default) }
                MTB  { set ::APPL_Config(TemplateInit) $::APPL_Config(TemplateMTB_default) }
            }
              # puts "\n\  -> \$type:  $type"
              # puts "\n\  -> \$::APPL_Config(TemplateInit):  $::APPL_Config(TemplateInit)"
            return
    }


    proc rattleCAD::view::gui::global_kb_Binding {ab} {
            variable noteBook_top

            # puts "\n   -----> keyboard binding \n -------------"
            bind . <F1>     {rattleCAD::infoPanel::create  .v_info 1}
            bind . <F3>     {rattleCAD::view::gui::notebook_scaleCanvas  [expr 2.0/3]}
            bind . <F4>     {rattleCAD::view::gui::notebook_scaleCanvas  [expr 3.0/2]}
            bind . <F5>     {rattleCAD::view::gui::notebook_refitCanvas}
            bind . <F6>     {rattleCAD::view::updateView           force}
            
            bind . <Key-Up>     {rattleCAD::view::gui::move_Canvas    0  50 }
            bind . <Key-Down>   {rattleCAD::view::gui::move_Canvas    0 -50 }
            bind . <Key-Left>   {rattleCAD::view::gui::move_Canvas   50   0 }
            bind . <Key-Right>  {rattleCAD::view::gui::move_Canvas  -50   0 }
            
            bind . <MouseWheel>         {rattleCAD::view::gui::bind_MouseWheel updown    %D}  ;# move up/down
            bind . <Shift-MouseWheel>   {rattleCAD::view::gui::bind_MouseWheel leftright %D}  ;# move left/right
            bind . <Control-MouseWheel> {rattleCAD::view::gui::bind_MouseWheel scale     %D}  ;# scale
            
            # bind . <Key-Tab>    {rattleCAD::view::gui::notebook_nextTab}
            # bind . <Key-Tab>    {tk_messageBox -message "Keyboard Event: <Key-Tab>"}
            # bind . <F5>     { tk_messageBox -message "Keyboard Event: <F5>" }
    }
    #-------------------------------------------------------------------------
       #  dimension binding on canvas
       #
    proc rattleCAD::view::gui::dimension_CursorBinding {cv_Name tag procedureName {cursor {hand2}} } {
            $cv_Name bind $tag    <Enter>                   [list $cv_Name configure -cursor $cursor]
            $cv_Name bind $tag    <Leave>                   [list $cv_Name configure -cursor {}]
            $cv_Name bind $tag    <Double-ButtonPress-1>    [list rattleCAD::view::edit::$procedureName %x %y  $cv_Name ]
    }
    #-------------------------------------------------------------------------
       #  cursor binding on canvas objects
       #
    proc rattleCAD::view::gui::object_CursorBinding {cv_Name tag {cursor {hand2}} } {
            $cv_Name bind $tag    <Enter> [list $cv_Name configure -cursor $cursor]
            $cv_Name bind $tag    <Leave> [list $cv_Name configure -cursor {}]
    }
    #-------------------------------------------------------------------------
       #  move canvas content
       #
    proc rattleCAD::view::gui::move_Canvas {x y} {
            variable canvasUpdate
            variable noteBook_top

                # puts "\n=================="
                # puts "    stageFormat $stageFormat"
                # puts "    stageScale  $stageScale"
                # puts "=================="
                    
            set currentTab [$noteBook_top select]
            set varName    [notebook_getVarName $currentTab]

            catch {$varName moveCanvas $x $y}     
    }
    #-------------------------------------------------------------------------
       #  move canvas content
       #
    proc rattleCAD::view::gui::bind_MouseWheel {type value} {
            variable canvasUpdate
            variable noteBook_top

                # rattleCAD::view::createEdit
                #    creates window $cv.f_edit
                #    catch <MouseWheel> for $cv.f_edit
            set currentTab [$noteBook_top select]
            set varName    [notebook_getVarName $currentTab]
            
                # ----------------------------
                # exception for the report tab
                #    ... there is no canvas
                #
            switch -glob $currentTab {
                *\.report {
                        puts "  -- <E> -- $currentTab"
                        return
                    }
                default {}    
            } 
            
            
            set cv         [ $varName getNodeAttr Canvas path]
            if {[llength [ $cv gettags  __cvEdit__]] > 0 } {
                # puts "\n=================="
                # puts "    bind_MouseWheel: catched"
                return
            }
            
                puts "\n=================="
                puts "    bind_MouseWheel"
                puts "       type   $type"
                puts "       value  $value"
                
            switch -exact $type {
                updown { if {$value > 0} {set scale 1.0} else {set scale -1.0}
                            rattleCAD::view::gui::move_Canvas    0  [expr $scale * 40] 
                        }
                leftright {   if {$value > 0} {set scale 1.0} else {set scale -1.0}
                            rattleCAD::view::gui::move_Canvas    [expr $scale * 40]  0 
                        }
                scale {  if {$value > 0} {set scale 1.1} else {set scale 0.9}
                            rattleCAD::view::gui::notebook_scaleCanvas $scale
                        }
                default  {}
            }
                
            return     
    }

     #-------------------------------------------------------------------------
       #  modify standard widget bindings
       #
       #       http://wiki.tcl.tk/2944
    proc rattleCAD::view::gui::binding_copyClass {class newClass} {
        set bindingList [bind $class]
        #puts $bindingList

        foreach binding $bindingList {
          bind $newClass $binding [bind $class $binding]
        }
    }
    proc rattleCAD::view::gui::binding_removeAllBut {class bindList} {
        foreach binding $bindList {
          array set tmprab "<${binding}> 0"
        }

        foreach binding [bind $class] {
          if {[info exists tmprab($binding)]} {
            continue
          }
          bind $class $binding {}
        }
    }
    proc rattleCAD::view::gui::binding_removeOnly {class bindList} {
        foreach binding $bindList {
          array set tmprab "<${binding}> 0"
        }

        foreach binding [bind $class] {
          if {[info exists tmprab($binding)]} {
            bind $class $binding {}
          }
          continue
          # bind $class $binding {}
        }
    }
    proc rattleCAD::view::gui::binding_reportBindings {class} {
        puts "    reportBindings: $class"
        foreach binding [bind $class] {
            puts "           $binding"
        }
    }    

