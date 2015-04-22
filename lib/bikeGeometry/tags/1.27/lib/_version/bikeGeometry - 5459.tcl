 ##+##########################################################################
 #
 # package: bikeGeometry    ->    bikeGeometry.tcl
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
 #    namespace:  bikeGeometry::frame_geometry_custom
 # ---------------------------------------------------------------------------
 #
 #

 # 0.18 http://sourceforge.net/p/rattlecad/tickets/2/
 # 
 # 0.59 add Rendering/Fender
 # 0.60 add Rendering/Carrier
 # 0.61 add reynoldsFEA ... export csv for Reynolds' FEA Solver
 # 0.62 add tubeDiameter ... to reynoldsFEA
 # 0.63 extend /Result/Tube with TubeProfile-Definition
 #        switch Result(Tubes/ChainStay/Direction) 
 # 0.64 unique definitions of shapes and positions with ","
 # 0.65 debug bikeGeometry::get_FenderRear 
 #        because of modified ChainStay-direction in 0.64
 # 0.66 fill Result/Length/...Wheel/Diameter bikeGeometry::fill_resultValues 
 # 0.67 fill Result/Tubes/ForkBlade/... bikeGeometry::get_Fork / get_ForkBlade
 # 0.68 debug seatpost-rendering
 # 0.69 refactor replace get_basePoints by 
 #          get_RearWheel, get_FrontWheel, get_GeometryRear
 #          get_GeometryCenter, get_GeometryFront, get_BoundingBox
 # 0.70 search an error in tubemiter, do some optimisation
 # 0.71 cleanup bikeGeometry from $project::... references
 # 0.72 cleanup from refactoring comments in 0.71
 # 0.73 references to the namespace "project::" summarized in get_from_project and set_to_project
 # 0.74 define procedures with full qualified names
 #          split procedure bikeGeometry::get_Object into 
 #                       get_Position, get_Polygon & get_Direction
 # 0.75 transfer fork-config from rattleCAD to bikeGeometry 
 #          remove bikeGeometry::set_forkConfig
 #          remove project::add_forkSetting
 #          debug  bikeGeometry::get_Fork
 # 1.05 ...
 # 1.06 move components from rattleCAD package to bikeGeometry package
 #          add proc bikeGeometry::get_ComponentDir
 # 1.07 get listBoxValues from bikeGeometry
 #          add proc bikeGeometry::get_ComponentDirectories
 #          add proc bikeGeometry::get_ListBoxValues
 # 1.08 namespace export 
 #          bikeGeometry::get_Component
 #          bikeGeometry::get_ComponentDir
 #          bikeGeometry::get_ComponentDirectories
 #          bikeGeometry::get_ListBoxValues
 # 1.09 namespace export 
 #          bikeGeometry::get_Option ... Rendering() values
 #          bikeGeometry::get_Scalar ... atomic values
 # 1.10 add Rendering(RearDropoutOrient) 
 #          as $project::Lugs(RearDropOut/Direction) 
 #              prev. RearDropOut(Direction)
 #      add RearDropout(Direction) 
 #          in bikeGeometry::get_ChainStay
 # 1.11 rename get_Option  to get_Config 
 #          add get_TubeMiter
 # 1.12 rename get_* procedure in lib_bikeGeometry_Ext.tcl
 #          fork handling implement: bikeGeometry::trace_ForkConfig
 # 1.13 remove and rename procedures 
 #          bikeGeometry::get_Value       ->  bikeGeometry::get_Value_expired
 #          bikeGeometry::get_Object      ->  bikeGeometry::get_Object_expired
 #          bikeGeometry::get_toRefactor  ->  bikeGeometry::get_CenterLine
 # 1.14 refactor
 #          insert bikeGeometry::check_mathValue
 #          rename Result(Angle/...)
 # 1.15 refactor
 #          update set_Value and set_ResultParameter  ->  lib_bikeGeometryResult.tcl
 #          rename bikeGeometry::set_base_Parameters  ->  bikeGeometry::update_Parameter
 #          move   bikeGeometry::get_from_project     ->  bikeGeometry::set_newProject 
 #          remove array _updateValue()
 #          remove set_Value from proc set_ResultParameter 
 # 1.16 refactor
 #          rename lib_bikeGeometryBase.tcl           ->  lib_bikeGeometry.tcl
 #          sumup in array Geometry()
 #          name alle x/y dimensions with ..._x and ..._y
 # 1.20 refactor
 #          insert namespace bikeGeometry::geometry  by lib_geometry.tcl
 #          ... remove FrameTubes(ChainStay/Profile/width_03) 
 #              for    FrameTubes(ChainStay/WidthBB) 
 #          update  bikeGeometry::get_projectDOM
 #              ... contains all variables for update
 # 1.21 refactor
 #           add bikeGeometry::update_Project to setter
 #           update array - Structure, getter, setter, get_ProjectDict
 #
 # 1.22 refactor
 #          debug customFork ... in virgin state
 #
 # 1.23 debug bikeGeometry::set_Result_...
 #          Geometry(RearRim_Diameter)
 #          Geometry(RearTyre_Height)
 #
 # 1.24 refactor
 #          Position() ...
 # 
 # 1.xx refactor
 #          split project completely from bikeGeometry
 #          update   get_from_project
 #              and  set_to_project
 #
  
    package require tdom
        #
    package provide bikeGeometry 1.24
        #
    package require vectormath
        #
    namespace eval bikeGeometry {
        
            # --------------------------------------------
                # Export as global command
            variable packageHomeDir [file normalize [file join [pwd] [file dirname [info script]]] ]
            
            
            #-------------------------------------------------------------------------
                #  definitions of template parameter
            variable initDOM    $project::initDOM
            variable projectDOM
            variable returnDict; set returnDict [dict create rattleCAD {}]
                #
        
        
            #-------------------------------------------------------------------------
                #  current Project Values
            variable Project         ; array set Project         {}
            variable Geometry        ; array set Geometry        {}
            variable Reference       ; array set Reference       {}
            variable Component       ; array set Component       {}
            variable Config          ; array set Config          {}
            variable ListValue       ; array set ListValue       {}
            variable Result          ; array set Result          {}
            
            variable BottleCage      ; array set BottleCage      {}
            variable BottomBracket   ; array set BottomBracket   {}
            variable Fork            ; array set Fork            {}
            variable FrontDerailleur ; array set FrontDerailleur {}
            variable FrontWheel      ; array set FrontWheel      {}
            variable HandleBar       ; array set HandleBar       {}
            variable HeadSet         ; array set HeadSet         {}
            variable RearDerailleur  ; array set RearDerailleur  {}
            variable RearDropout     ; array set RearDropout     {}
            variable RearWheel       ; array set RearWheel       {}
            variable Saddle          ; array set Saddle          {}
            variable SeatPost        ; array set SeatPost        {}
            variable Stem            ; array set Stem            {}
            
            variable LegClearance    ; array set LegClearance    {}
            
            variable HeadTube        ; array set HeadTube        {}
            variable SeatTube        ; array set SeatTube        {}
            variable DownTube        ; array set DownTube        {}
            variable TopTube         ; array set TopTube         {}
            variable ChainStay       ; array set ChainStay       {}
            variable SeatStay        ; array set SeatStay        {}
            variable Steerer         ; array set Steerer         {}
            variable ForkBlade       ; array set ForkBlade       {}
            variable Lugs            ; array set Lugs            {}
            
            
            variable TubeMiter       ; array set TubeMiter       {}
            variable FrameJig        ; array set FrameJig        {}
            variable RearMockup      ; array set RearMockup      {}
            variable BoundingBox     ; array set BoundingBox     {}
            
            
            variable myFork          ; array set myFork          {}

            variable DEBUG_Geometry  ; array set DEBUG_Geometry  {}



            #-------------------------------------------------------------------------
                #  update loop and delay; store last value
            variable customFork      ; array set customFork { lastConfig    {} }
            
            #-------------------------------------------------------------------------
                #  update loop and delay; store last value
            # variable _updateValue   ; array set _updateValue    {}

            #-------------------------------------------------------------------------
                #  store createEdit-widgets position
            variable _drag

            #-------------------------------------------------------------------------
                #  dataprovider of create_selectbox
            variable _listBoxValues
            
            #-------------------------------------------------------------------------
                #  export procedures
            namespace export set_newProject
            namespace export get_projectDOM
            namespace export get_projectDICT
                #
            namespace export import_ProjectSubset
                #
            namespace export get_Value
                #
            namespace export get_Component
            namespace export get_Config
            namespace export get_ListValue
            namespace export get_Scalar
                #
            namespace export set_Component
            namespace export set_Config
            namespace export set_ListValue
            namespace export set_Scalar
                #
            namespace export get_Object
            namespace export get_Polygon
            namespace export get_Position
            namespace export get_Direction
            namespace export get_BoundingBox
            namespace export get_TubeMiter
            namespace export get_CenterLine
                #
            namespace export get_ComponentDir 
            namespace export get_ComponentDirectories
            namespace export get_ListBoxValues 
                #
            namespace export get_DebugGeometry
            namespace export get_ReynoldsFEAContent
                #
            namespace export coords_xy_index
                #
            namespace export set_Value
            namespace export set_resultParameter
                #
            # puts " Hallo!  ... [info command [namespace current]::*]" 
    }
        
        
    #-------------------------------------------------------------------------
        #  load newProject
        #
        #  ... loads a new project given by a XML-Project as rootNode
        #
    proc bikeGeometry::set_newProject {_projectDOM} {

            # --- report Fork Settings ------------------
                #                  
            set _forkDOM   [$project::initDOM selectNode Fork/_bikeGeometry_default_]  
            if {$_forkDOM != {}} {
                puts ""
                puts "        -- <W> ----------------------------------------------------"
                puts "           <W> bikeGeometry:"
                puts "           <W>       ...  using default Fork Settings"
                puts "           <W>         see -> \$bikeGeometry::initDOM /root/Fork"
                puts "           <W>"
                puts "" 
            }      
    
                     
            # --- set the Geometry DOM Object -----------
                #
            set project::projectDOM $_projectDOM
              
                
            # --- update the project to current level ---
                #  ... and get the required post updates
                #
            set postUpdate [project::update_Project]
        
        
            # --- make the current DOM Object alive ----
                #
            project::dom_2_runTime
        
                  # 
                  # puts "     -- 004 --------"
                  # puts [$project::projectDOM asXML]
                  # #exit
                
            # --- get all values from ::project ----
                #
            get_from_project
            
            
            # --- compute geometry ----------------------
                #
            bikeGeometry::update_Project
              
                
            # --- do required post updates --------------
                #
            foreach key [dict keys $postUpdate] {
                      # puts " -> $key"
                    set valueDict   [dict get $postUpdate $key]
                    foreach valueKey [dict keys $valueDict] {
                        puts "\n      -------------------------------"
                        set newValue [dict get $valueDict $valueKey]
                        puts "          postUpdate:   $key - $valueKey -> $newValue"
                        bikeGeometry::set_Value $key/$valueKey $newValue update
                    }
                        # project::pdict $valueDict
            }
            project::runTime_2_dom
    }

    #-------------------------------------------------------------------------
       #  import a subset of a project	
	proc bikeGeometry::import_ProjectSubset {nodeRoot} {
			project::import_ProjectSubset $nodeRoot
	}

    #-------------------------------------------------------------------------
        #  get current projectDOM as DOM Object
    proc bikeGeometry::get_projectDOM {} {
            return $project::projectDOM
    }

    #-------------------------------------------------------------------------
        #  get current projectDOM as Dictionary
    proc bikeGeometry::get_projectDICT {} {
            #   return $project::projectDICT
        set projDict   [dict create Component {}  Config {}  ListValue {}  Scalar {} ]
            #
            #
            #
        dict set projDict   Component   CrankSet                            $::bikeGeometry::Component(CrankSet)                            ;#[bikeGeometry::get_Component        CrankSet                          ]                ;# set _lastValue(Component/CrankSet/File)                                 
        dict set projDict   Component   ForkCrown                           $::bikeGeometry::Component(ForkCrown)                           ;#[bikeGeometry::get_Component        Fork CrownFile                    ]                ;# set _lastValue(Component/Fork/Crown/File)                               
        dict set projDict   Component   ForkDropout                         $::bikeGeometry::Component(ForkDropout)                         ;#[bikeGeometry::get_Component        Fork DropOutFile                  ]                ;# set _lastValue(Component/Fork/DropOut/File)                             
        dict set projDict   Component   FrontBrake                          $::bikeGeometry::Component(FrontBrake)                          ;#[bikeGeometry::get_Component        FrontBrake                        ]                ;# set _lastValue(Component/Brake/Front/File)                              
        dict set projDict   Component   FrontCarrier                        $::bikeGeometry::Component(FrontCarrier)                        ;#[bikeGeometry::get_Component        FrontCarrier                      ]                ;# set _lastValue(Component/Carrier/Front/File)                            
        dict set projDict   Component   FrontDerailleur                     $::bikeGeometry::Component(FrontDerailleur)                     ;#[bikeGeometry::get_Component        FrontDerailleur                   ]                ;# set _lastValue(Component/Derailleur/Front/File)                         
        dict set projDict   Component   HandleBar                           $::bikeGeometry::Component(HandleBar)                           ;#[bikeGeometry::get_Component        HandleBar                         ]                ;# set _lastValue(Component/HandleBar/File)                                
        dict set projDict   Component   Logo                                $::bikeGeometry::Component(Logo)                                ;#[bikeGeometry::get_Component        Logo                              ]                ;# set _lastValue(Component/Logo/File)                                     
        dict set projDict   Component   RearBrake                           $::bikeGeometry::Component(RearBrake)                           ;#[bikeGeometry::get_Component        RearBrake                         ]                ;# set _lastValue(Component/Brake/Rear/File)                               
        dict set projDict   Component   RearCarrier                         $::bikeGeometry::Component(RearCarrier)                         ;#[bikeGeometry::get_Component        RearCarrier                       ]                ;# set _lastValue(Component/Carrier/Rear/File)                             
        dict set projDict   Component   RearDerailleur                      $::bikeGeometry::Component(RearDerailleur)                      ;#[bikeGeometry::get_Component        RearDerailleur                    ]                ;# set _lastValue(Component/Derailleur/Rear/File)                          
        dict set projDict   Component   RearDropout                         $::bikeGeometry::Component(RearDropout)                         ;#[bikeGeometry::get_Component        RearDropout File                  ]                ;# set _lastValue(Lugs/RearDropOut/File)                                   
        dict set projDict   Component   RearHub                             $::bikeGeometry::Component(RearHub)
        dict set projDict   Component   Saddle                              $::bikeGeometry::Component(Saddle)                              ;#[bikeGeometry::get_Component        Saddle                            ]                ;# set _lastValue(Component/Saddle/File)                                   
        dict set projDict   Component   BottleCage_DownTube                 $::bikeGeometry::Component(BottleCage_DownTube)                                
        dict set projDict   Component   BottleCage_DownTube_Lower           $::bikeGeometry::Component(BottleCage_DownTube_Lower)                          
        dict set projDict   Component   BottleCage_SeatTube                 $::bikeGeometry::Component(BottleCage_SeatTube)                                
            #                           
        dict set projDict   Config      BottleCage_DownTube                 $::bikeGeometry::Config(BottleCage_DownTube)                    ;#[bikeGeometry::get_Config           BottleCage_DT                     ]                ;# set _lastValue(Rendering/BottleCage/DownTube)                           
        dict set projDict   Config      BottleCage_DownTube_Lower           $::bikeGeometry::Config(BottleCage_DownTube_Lower)              ;#[bikeGeometry::get_Config           BottleCage_DT_L                   ]                ;# set _lastValue(Rendering/BottleCage/DownTube_Lower)                     
        dict set projDict   Config      BottleCage_SeatTube                 $::bikeGeometry::Config(BottleCage_SeatTube)                    ;#[bikeGeometry::get_Config           BottleCage_ST                     ]                ;# set _lastValue(Rendering/BottleCage/SeatTube)                           
        dict set projDict   Config      ChainStay                           $::bikeGeometry::Config(ChainStay)                              ;#[bikeGeometry::get_Config           ChainStay                         ]                ;# set _lastValue(Rendering/ChainStay)                                     
        dict set projDict   Config      Fork                                $::bikeGeometry::Config(Fork)                                   ;#[bikeGeometry::get_Config           Fork                              ]                ;# set _lastValue(Rendering/Fork)                                          
        dict set projDict   Config      ForkBlade                           $::bikeGeometry::Config(ForkBlade)                              ;#[bikeGeometry::get_Config           ForkBlade                         ]                ;# set _lastValue(Rendering/ForkBlade)                                     
        dict set projDict   Config      ForkDropout                         $::bikeGeometry::Config(ForkDropout)                            ;#[bikeGeometry::get_Config           ForkDropout                       ]                ;# set _lastValue(Rendering/ForkDropOut)                                   
        dict set projDict   Config      FrontBrake                          $::bikeGeometry::Config(FrontBrake)                             ;#[bikeGeometry::get_Config           FrontBrake                        ]                ;# set _lastValue(Rendering/Brake/Front)                                   
        dict set projDict   Config      FrontFender                         $::bikeGeometry::Config(FrontFender)                            ;#[bikeGeometry::get_Config           FrontFender                       ]                ;# set _lastValue(Rendering/Fender/Front)                                  
        dict set projDict   Config      RearBrake                           $::bikeGeometry::Config(RearBrake)                              ;#[bikeGeometry::get_Config           RearBrake                         ]                ;# set _lastValue(Rendering/Brake/Rear)                                    
        dict set projDict   Config      RearDropout                         $::bikeGeometry::Config(RearDropout)                            ;#[bikeGeometry::get_Config           RearDropout                       ]                ;# set _lastValue(Rendering/RearDropOut)                                   
        dict set projDict   Config      RearDropoutOrient                   $::bikeGeometry::Config(RearDropoutOrient)                      ;#[bikeGeometry::get_Config           RearDropoutOrient                 ]                ;# set _lastValue(Lugs/RearDropOut/Direction)                              
        dict set projDict   Config      RearFender                          $::bikeGeometry::Config(RearFender)                             ;#[bikeGeometry::get_Config           RearFender                        ]                ;# set _lastValue(Rendering/Fender/Rear)                                   
            #                           
        dict set projDict   ListValue   CrankSetChainRings                  $::bikeGeometry::ListValue(CrankSetChainRings)                  ;#[bikeGeometry::get_Scalar           CrankSet ChainRings               ]                ;# set _lastValue(Component/CrankSet/ChainRings)                           
            #           
        dict set projDict   Scalar      BottleCage DownTube                 $::bikeGeometry::BottleCage(DownTube)                           ;#[bikeGeometry::get_Scalar           BottleCage DownTube               ]                ;# set _lastValue(Component/BottleCage/DownTube/OffsetBB)                  
        dict set projDict   Scalar      BottleCage DownTube_Lower           $::bikeGeometry::BottleCage(DownTube_Lower)                     ;#[bikeGeometry::get_Scalar           BottleCage DownTube_Lower         ]                ;# set _lastValue(Component/BottleCage/DownTube_Lower/OffsetBB)            
        dict set projDict   Scalar      BottleCage SeatTube                 $::bikeGeometry::BottleCage(SeatTube)                           ;#[bikeGeometry::get_Scalar           BottleCage SeatTube               ]                ;# set _lastValue(Component/BottleCage/SeatTube/OffsetBB)                  
        dict set projDict   Scalar      BottomBracket InsideDiameter        $::bikeGeometry::BottomBracket(InsideDiameter)                  ;#[bikeGeometry::get_Scalar           BottomBracket InsideDiameter      ]                ;# set _lastValue(Lugs/BottomBracket/Diameter/inside)                      
        dict set projDict   Scalar      BottomBracket OffsetCS_TopView      $::bikeGeometry::BottomBracket(OffsetCS_TopView)                ;#[bikeGeometry::get_Scalar           BottomBracket OffsetCS_TopView    ]                ;# set _lastValue(Lugs/BottomBracket/ChainStay/Offset_TopView)             
        dict set projDict   Scalar      BottomBracket OutsideDiameter       $::bikeGeometry::BottomBracket(OutsideDiameter)                 ;#[bikeGeometry::get_Scalar           BottomBracket OutsideDiameter     ]                ;# set _lastValue(Lugs/BottomBracket/Diameter/outside)                     
        dict set projDict   Scalar      BottomBracket Width                 $::bikeGeometry::BottomBracket(Width)                           ;#[bikeGeometry::get_Scalar           BottomBracket Width               ]                ;# set _lastValue(Lugs/BottomBracket/Width)                                
            #            
        dict set projDict   Scalar      ChainStay DiameterSS                $::bikeGeometry::ChainStay(DiameterSS)                          ;#[bikeGeometry::get_Scalar           ChainStay DiameterSS              ]                ;# set _lastValue(FrameTubes/ChainStay/DiameterSS)                         
        dict set projDict   Scalar      ChainStay Height                    $::bikeGeometry::ChainStay(Height)                              ;#[bikeGeometry::get_Scalar           ChainStay Height                  ]                ;# set _lastValue(FrameTubes/ChainStay/Height)                             
        dict set projDict   Scalar      ChainStay HeigthBB                  $::bikeGeometry::ChainStay(HeigthBB)                            ;#[bikeGeometry::get_Scalar           ChainStay HeigthBB                ]                ;# set _lastValue(FrameTubes/ChainStay/HeightBB)                           
        dict set projDict   Scalar      ChainStay TaperLength               $::bikeGeometry::ChainStay(TaperLength)                         ;#[bikeGeometry::get_Scalar           ChainStay TaperLength             ]                ;# set _lastValue(FrameTubes/ChainStay/TaperLength)                        
        dict set projDict   Scalar      ChainStay WidthBB                   $::bikeGeometry::ChainStay(WidthBB)                             ;#[bikeGeometry::get_Scalar           ChainStay WidthBB                 ]                ;# set _lastValue(FrameTubes/ChainStay/TaperLength)                        
        dict set projDict   Scalar      ChainStay completeLength            $::bikeGeometry::ChainStay(completeLength)                      ;#[bikeGeometry::get_Scalar           ChainStay completeLength          ]                ;# set _lastValue(FrameTubes/ChainStay/Profile/completeLength)             
        dict set projDict   Scalar      ChainStay cuttingLeft               $::bikeGeometry::ChainStay(cuttingLeft)                         ;#[bikeGeometry::get_Scalar           ChainStay cuttingLeft             ]                ;# set _lastValue(FrameTubes/ChainStay/Profile/cuttingLeft)                
        dict set projDict   Scalar      ChainStay cuttingLength             $::bikeGeometry::ChainStay(cuttingLength)                       ;#[bikeGeometry::get_Scalar           ChainStay cuttingLength           ]                ;# set _lastValue(FrameTubes/ChainStay/Profile/cuttingLength)              
        dict set projDict   Scalar      ChainStay profile_x01               $::bikeGeometry::ChainStay(profile_x01)                         ;#[bikeGeometry::get_Scalar           ChainStay profile_x01             ]                ;# set _lastValue(FrameTubes/ChainStay/Profile/length_01)                  
        dict set projDict   Scalar      ChainStay profile_x02               $::bikeGeometry::ChainStay(profile_x02)                         ;#[bikeGeometry::get_Scalar           ChainStay profile_x02             ]                ;# set _lastValue(FrameTubes/ChainStay/Profile/length_02)                  
        dict set projDict   Scalar      ChainStay profile_x03               $::bikeGeometry::ChainStay(profile_x03)                         ;#[bikeGeometry::get_Scalar           ChainStay profile_x03             ]                ;# set _lastValue(FrameTubes/ChainStay/Profile/length_03)                  
        dict set projDict   Scalar      ChainStay profile_y00               $::bikeGeometry::ChainStay(profile_y00)                         ;#[bikeGeometry::get_Scalar           ChainStay profile_y00             ]                ;# set _lastValue(FrameTubes/ChainStay/Profile/width_00)                   
        dict set projDict   Scalar      ChainStay profile_y01               $::bikeGeometry::ChainStay(profile_y01)                         ;#[bikeGeometry::get_Scalar           ChainStay profile_y01             ]                ;# set _lastValue(FrameTubes/ChainStay/Profile/width_01)                   
        dict set projDict   Scalar      ChainStay profile_y02               $::bikeGeometry::ChainStay(profile_y02)                         ;#[bikeGeometry::get_Scalar           ChainStay profile_y02             ]                ;# set _lastValue(FrameTubes/ChainStay/Profile/width_02)                   
        dict set projDict   Scalar      ChainStay segmentAngle_01           $::bikeGeometry::ChainStay(segmentAngle_01)                     ;#[bikeGeometry::get_Scalar           ChainStay segmentAngle_01         ]                ;# set _lastValue(FrameTubes/ChainStay/CenterLine/angle_01)                
        dict set projDict   Scalar      ChainStay segmentAngle_02           $::bikeGeometry::ChainStay(segmentAngle_02)                     ;#[bikeGeometry::get_Scalar           ChainStay segmentAngle_02         ]                ;# set _lastValue(FrameTubes/ChainStay/CenterLine/angle_02)                
        dict set projDict   Scalar      ChainStay segmentAngle_03           $::bikeGeometry::ChainStay(segmentAngle_03)                     ;#[bikeGeometry::get_Scalar           ChainStay segmentAngle_03         ]                ;# set _lastValue(FrameTubes/ChainStay/CenterLine/angle_03)                
        dict set projDict   Scalar      ChainStay segmentAngle_04           $::bikeGeometry::ChainStay(segmentAngle_04)                     ;#[bikeGeometry::get_Scalar           ChainStay segmentAngle_04         ]                ;# set _lastValue(FrameTubes/ChainStay/CenterLine/angle_04)                
        dict set projDict   Scalar      ChainStay segmentLength_01          $::bikeGeometry::ChainStay(segmentLength_01)                    ;#[bikeGeometry::get_Scalar           ChainStay segmentLength_01        ]                ;# set _lastValue(FrameTubes/ChainStay/CenterLine/length_01)               
        dict set projDict   Scalar      ChainStay segmentLength_02          $::bikeGeometry::ChainStay(segmentLength_02)                    ;#[bikeGeometry::get_Scalar           ChainStay segmentLength_02        ]                ;# set _lastValue(FrameTubes/ChainStay/CenterLine/length_02)               
        dict set projDict   Scalar      ChainStay segmentLength_03          $::bikeGeometry::ChainStay(segmentLength_03)                    ;#[bikeGeometry::get_Scalar           ChainStay segmentLength_03        ]                ;# set _lastValue(FrameTubes/ChainStay/CenterLine/length_03)               
        dict set projDict   Scalar      ChainStay segmentLength_04          $::bikeGeometry::ChainStay(segmentLength_04)                    ;#[bikeGeometry::get_Scalar           ChainStay segmentLength_04        ]                ;# set _lastValue(FrameTubes/ChainStay/CenterLine/length_04)               
        dict set projDict   Scalar      ChainStay segmentRadius_01          $::bikeGeometry::ChainStay(segmentRadius_01)                    ;#[bikeGeometry::get_Scalar           ChainStay segmentRadius_01        ]                ;# set _lastValue(FrameTubes/ChainStay/CenterLine/radius_01)               
        dict set projDict   Scalar      ChainStay segmentRadius_02          $::bikeGeometry::ChainStay(segmentRadius_02)                    ;#[bikeGeometry::get_Scalar           ChainStay segmentRadius_02        ]                ;# set _lastValue(FrameTubes/ChainStay/CenterLine/radius_02)               
        dict set projDict   Scalar      ChainStay segmentRadius_03          $::bikeGeometry::ChainStay(segmentRadius_03)                    ;#[bikeGeometry::get_Scalar           ChainStay segmentRadius_03        ]                ;# set _lastValue(FrameTubes/ChainStay/CenterLine/radius_03)               
        dict set projDict   Scalar      ChainStay segmentRadius_04          $::bikeGeometry::ChainStay(segmentRadius_04)                    ;#[bikeGeometry::get_Scalar           ChainStay segmentRadius_04        ]                ;# set _lastValue(FrameTubes/ChainStay/CenterLine/radius_04)               
            #            
        dict set projDict   Scalar      CrankSet ArmWidth                   $::bikeGeometry::CrankSet(ArmWidth)                             ;#[bikeGeometry::get_Scalar           CrankSet ArmWidth                 ]                ;# set _lastValue(Component/CrankSet/ArmWidth)                             
        dict set projDict   Scalar      CrankSet ChainLine                  $::bikeGeometry::CrankSet(ChainLine)                            ;#[bikeGeometry::get_Scalar           CrankSet ChainLine                ]                ;# set _lastValue(Component/CrankSet/ChainLine)                            
        dict set projDict   Scalar      CrankSet Length                     $::bikeGeometry::CrankSet(Length)                               ;#[bikeGeometry::get_Scalar           CrankSet Length                   ]                ;# set _lastValue(Component/CrankSet/Length)                               
        dict set projDict   Scalar      CrankSet PedalEye                   $::bikeGeometry::CrankSet(PedalEye)                             ;#[bikeGeometry::get_Scalar           CrankSet PedalEye                 ]                ;# set _lastValue(Component/CrankSet/PedalEye)                             
        dict set projDict   Scalar      CrankSet Q-Factor                   $::bikeGeometry::CrankSet(Q-Factor)                             ;#[bikeGeometry::get_Scalar           CrankSet Q-Factor                 ]                ;# set _lastValue(Component/CrankSet/Q-Factor)                             
        dict set projDict   Scalar      DownTube DiameterBB                 $::bikeGeometry::DownTube(DiameterBB)                           ;#[bikeGeometry::get_Scalar           DownTube DiameterBB               ]                ;# set _lastValue(FrameTubes/DownTube/DiameterBB)                          
        dict set projDict   Scalar      DownTube DiameterHT                 $::bikeGeometry::DownTube(DiameterHT)                           ;#[bikeGeometry::get_Scalar           DownTube DiameterHT               ]                ;# set _lastValue(FrameTubes/DownTube/DiameterHT)                          
        dict set projDict   Scalar      DownTube OffsetBB                   $::bikeGeometry::DownTube(OffsetBB)                             ;#[bikeGeometry::get_Scalar           DownTube OffsetBB                 ]                ;# set _lastValue(Custom/DownTube/OffsetBB)                                
        dict set projDict   Scalar      DownTube OffsetHT                   $::bikeGeometry::DownTube(OffsetHT)                             ;#[bikeGeometry::get_Scalar           DownTube OffsetHT                 ]                ;# set _lastValue(Custom/DownTube/OffsetHT)                                
        dict set projDict   Scalar      DownTube TaperLength                $::bikeGeometry::DownTube(TaperLength)                          ;#[bikeGeometry::get_Scalar           DownTube TaperLength              ]                ;# set _lastValue(FrameTubes/DownTube/TaperLength)                         
            #            
        dict set projDict   Scalar      Fork BladeBendRadius                $::bikeGeometry::Fork(BladeBendRadius)                          ;#[bikeGeometry::get_Scalar           Fork BladeBendRadius              ]                ;# set _lastValue(Component/Fork/Blade/BendRadius)                         
        dict set projDict   Scalar      Fork BladeDiameterDO                $::bikeGeometry::Fork(BladeDiameterDO)                          ;#[bikeGeometry::get_Scalar           Fork BladeDiameterDO              ]                ;# set _lastValue(Component/Fork/Blade/DiameterDO)                         
        dict set projDict   Scalar      Fork BladeEndLength                 $::bikeGeometry::Fork(BladeEndLength)                           ;#[bikeGeometry::get_Scalar           Fork BladeEndLength               ]                ;# set _lastValue(Component/Fork/Blade/EndLength)                          
        dict set projDict   Scalar      Fork BladeOffsetCrown               $::bikeGeometry::Fork(BladeOffsetCrown)                         ;#[bikeGeometry::get_Scalar           Fork BladeOffsetCrown             ]                ;# set _lastValue(Component/Fork/Crown/Blade/Offset)                       
        dict set projDict   Scalar      Fork BladeOffsetCrownPerp           $::bikeGeometry::Fork(BladeOffsetCrownPerp)                     ;#[bikeGeometry::get_Scalar           Fork BladeOffsetCrownPerp         ]                ;# set _lastValue(Component/Fork/Crown/Blade/OffsetPerp)                   
        dict set projDict   Scalar      Fork BladeOffsetDO                  $::bikeGeometry::Fork(BladeOffsetDO)                            ;#[bikeGeometry::get_Scalar           Fork BladeOffsetDO                ]                ;# set _lastValue(Component/Fork/DropOut/Offset)                           
        dict set projDict   Scalar      Fork BladeOffsetDOPerp              $::bikeGeometry::Fork(BladeOffsetDOPerp)                        ;#[bikeGeometry::get_Scalar           Fork BladeOffsetDOPerp            ]                ;# set _lastValue(Component/Fork/DropOut/OffsetPerp)                       
        dict set projDict   Scalar      Fork BladeTaperLength               $::bikeGeometry::Fork(BladeTaperLength)                         ;#[bikeGeometry::get_Scalar           Fork BladeTaperLength             ]                ;# set _lastValue(Component/Fork/Blade/TaperLength)                        
        dict set projDict   Scalar      Fork BladeWidth                     $::bikeGeometry::Fork(BladeWidth)                               ;#[bikeGeometry::get_Scalar           Fork BladeWidth                   ]                ;# set _lastValue(Component/Fork/Blade/Width)                              
        dict set projDict   Scalar      Fork CrownAngleBrake                $::bikeGeometry::Fork(CrownAngleBrake)                          ;#[bikeGeometry::get_Scalar           Fork BrakeAngle                   ]                ;# set _lastValue(Component/Fork/Crown/Brake/Angle)                        
        dict set projDict   Scalar      Fork CrownOffsetBrake               $::bikeGeometry::Fork(CrownOffsetBrake)                         ;#[bikeGeometry::get_Scalar           Fork BrakeOffset                  ]                ;# set _lastValue(Component/Fork/Crown/Brake/Offset)                       
            # dict set projDict   Scalar      Fork BrakeAngle               $::bikeGeometry::Fork(BrakeAngle)                               ;#[bikeGeometry::get_Scalar           Fork BrakeAngle                   ]                ;# set _lastValue(Component/Fork/Crown/Brake/Angle)                        
            # dict set projDict   Scalar      Fork BrakeOffset              $::bikeGeometry::Fork(BrakeOffset)                              ;#[bikeGeometry::get_Scalar           Fork BrakeOffset                  ]                ;# set _lastValue(Component/Fork/Crown/Brake/Offset)                       
        dict set projDict   Scalar      Fork BladeBrakeOffset               $::bikeGeometry::Fork(BladeBrakeOffset)                         ;
            #            
        dict set projDict   Scalar      FrontBrake LeverLength              $::bikeGeometry::FrontBrake(LeverLength)                        ;#[bikeGeometry::get_Scalar           FrontBrake LeverLength            ]                ;# set _lastValue(Component/Brake/Front/LeverLength)                       
        dict set projDict   Scalar      FrontBrake Offset                   $::bikeGeometry::FrontBrake(Offset)                             ;#[bikeGeometry::get_Scalar           FrontBrake Offset                 ]                ;# set _lastValue(Component/Brake/Front/Offset)                            
        dict set projDict   Scalar      FrontCarrier x                      $::bikeGeometry::FrontCarrier(x)                                ;#[bikeGeometry::get_Scalar           FrontCarrier x                    ]                ;# set _lastValue(Component/Carrier/Front/x)                               
        dict set projDict   Scalar      FrontCarrier y                      $::bikeGeometry::FrontCarrier(y)                                ;#[bikeGeometry::get_Scalar           FrontCarrier y                    ]                ;# set _lastValue(Component/Carrier/Front/y)                               
        dict set projDict   Scalar      FrontDerailleur Distance            $::bikeGeometry::FrontDerailleur(Distance)                      ;#[bikeGeometry::get_Scalar           FrontDerailleur Distance          ]                ;# set _lastValue(Component/Derailleur/Front/Distance)                     
        dict set projDict   Scalar      FrontDerailleur Offset              $::bikeGeometry::FrontDerailleur(Offset)                        ;#[bikeGeometry::get_Scalar           FrontDerailleur Offset            ]                ;# set _lastValue(Component/Derailleur/Front/Offset)                       
        dict set projDict   Scalar      FrontFender Height                  $::bikeGeometry::FrontFender(Height)                            ;#[bikeGeometry::get_Scalar           FrontFender Height                ]                ;# set _lastValue(Component/Fender/Front/Height)                           
        dict set projDict   Scalar      FrontFender OffsetAngle             $::bikeGeometry::FrontFender(OffsetAngle)                       ;#[bikeGeometry::get_Scalar           FrontFender OffsetAngle           ]                ;# set _lastValue(Component/Fender/Front/OffsetAngle)                      
        dict set projDict   Scalar      FrontFender OffsetAngleFront        $::bikeGeometry::FrontFender(OffsetAngleFront)                  ;#[bikeGeometry::get_Scalar           FrontFender OffsetAngleFront      ]                ;# set _lastValue(Component/Fender/Front/OffsetAngleFront)                 
        dict set projDict   Scalar      FrontFender Radius                  $::bikeGeometry::FrontFender(Radius)                            ;#[bikeGeometry::get_Scalar           FrontFender Radius                ]                ;# set _lastValue(Component/Fender/Front/Radius)                           
        dict set projDict   Scalar      FrontWheel RimHeight                $::bikeGeometry::FrontWheel(RimHeight)                          ;#[bikeGeometry::get_Scalar           FrontWheel RimHeight              ]                ;# set _lastValue(Component/Wheel/Front/RimHeight)                         
            #            
        dict set projDict   Scalar      Geometry BottomBracket_Depth        $::bikeGeometry::Geometry(BottomBracket_Depth)                  ;#[bikeGeometry::get_Scalar           Geometry BottomBracket_Depth      ]                ;# set _lastValue(Custom/BottomBracket/Depth)                              
        dict set projDict   Scalar      Geometry BottomBracket_Height       $::bikeGeometry::Geometry(BottomBracket_Height)                 ;#[bikeGeometry::get_Scalar           Geometry BottomBracket_Height     ]                ;# set _lastValue(Result/Length/BottomBracket/Height)                      
        dict set projDict   Scalar      Geometry ChainStay_Length           $::bikeGeometry::Geometry(ChainStay_Length)                     ;#[bikeGeometry::get_Scalar           Geometry ChainStay_Length         ]                ;# set _lastValue(Custom/WheelPosition/Rear)                               
        dict set projDict   Scalar      Geometry FrontRim_Diameter          $::bikeGeometry::Geometry(FrontRim_Diameter)                    ;#[bikeGeometry::get_Scalar           FrontWheel RimDiameter            ]                ;# set _lastValue(Component/Wheel/Front/RimDiameter)                       
        dict set projDict   Scalar      Geometry FrontTyre_Height           $::bikeGeometry::Geometry(FrontTyre_Height)                     ;#[bikeGeometry::get_Scalar           FrontWheel TyreHeight             ]                ;# set _lastValue(Component/Wheel/Front/TyreHeight)                        
        dict set projDict   Scalar      Geometry FrontWheel_Radius          $::bikeGeometry::Geometry(FrontWheel_Radius)                    ;#[bikeGeometry::get_Scalar           Geometry FrontWheel_Radius        ]                ;# set _lastValue(Result/Length/FrontWheel/Radius)                         
        dict set projDict   Scalar      Geometry FrontWheel_x               $::bikeGeometry::Geometry(FrontWheel_x)                         ;#[bikeGeometry::get_Scalar           Geometry FrontWheel_x             ]                ;# set _lastValue(Result/Length/FrontWheel/horizontal)                     
        dict set projDict   Scalar      Geometry FrontWheel_xy              $::bikeGeometry::Geometry(FrontWheel_xy)                        ;#[bikeGeometry::get_Scalar           Geometry FrontWheel_xy            ]                ;# set _lastValue(Result/Length/FrontWheel/diagonal)                       
        dict set projDict   Scalar      Geometry HandleBar_Distance         $::bikeGeometry::Geometry(HandleBar_Distance)                   ;#[bikeGeometry::get_Scalar           Geometry HandleBar_Distance       ]                ;# set _lastValue(Personal/HandleBar_Distance)                             
        dict set projDict   Scalar      Geometry HandleBar_Height           $::bikeGeometry::Geometry(HandleBar_Height)                     ;#[bikeGeometry::get_Scalar           Geometry HandleBar_Height         ]                ;# set _lastValue(Personal/HandleBar_Height)                               
        dict set projDict   Scalar      Geometry HeadTube_Angle             $::bikeGeometry::Geometry(HeadTube_Angle)                       ;#[bikeGeometry::get_Scalar           Geometry HeadTube_Angle           ]                ;# set _lastValue(Custom/HeadTube/Angle)                                   
        dict set projDict   Scalar      Geometry Inseam_Length              $::bikeGeometry::Geometry(Inseam_Length)                        ;#[bikeGeometry::get_Scalar           Geometry Inseam_Length            ]                ;# set _lastValue(Personal/InnerLeg_Length)                                
        dict set projDict   Scalar      Geometry Reach_Length               $::bikeGeometry::Geometry(Reach_Length)                         ;#[bikeGeometry::get_Scalar           Geometry ReachLengthResult        ]                ;# set _lastValue(Result/Length/HeadTube/ReachLength)                      
        dict set projDict   Scalar      Geometry RearRim_Diameter           $::bikeGeometry::Geometry(RearRim_Diameter)                     ;#[bikeGeometry::get_Scalar           RearWheel RimDiameter             ]                ;# set _lastValue(Component/Wheel/Rear/RimDiameter)                        
        dict set projDict   Scalar      Geometry RearTyre_Height            $::bikeGeometry::Geometry(RearTyre_Height)                      ;#[bikeGeometry::get_Scalar           RearWheel TyreHeight              ]                ;# set _lastValue(Component/Wheel/Rear/TyreHeight)                         
        dict set projDict   Scalar      Geometry RearWheel_Radius           $::bikeGeometry::Geometry(RearWheel_Radius)                     ;#[bikeGeometry::get_Scalar           Geometry RearWheel_Radius         ]                ;# set _lastValue(Result/Length/RearWheel/Radius)                          
        dict set projDict   Scalar      Geometry RearWheel_x                $::bikeGeometry::Geometry(RearWheel_x)                          ;#[bikeGeometry::get_Scalar           Geometry RearWheel_x              ]                ;# set _lastValue(Result/Length/RearWheel/horizontal)                      
        dict set projDict   Scalar      Geometry SaddleNose_BB_x            $::bikeGeometry::Geometry(SaddleNose_BB_x)                      ;#[bikeGeometry::get_Scalar           Geometry SaddleNose_BB_x          ]                ;# set _lastValue(Result/Length/Saddle/Offset_BB_Nose)                     
        dict set projDict   Scalar      Geometry SaddleNose_HB              $::bikeGeometry::Geometry(SaddleNose_HB)                        ;#[bikeGeometry::get_Scalar           Geometry SaddleNose_HB            ]                ;# set _lastValue(Result/Length/Personal/SaddleNose_HB)                    
        dict set projDict   Scalar      Geometry Saddle_BB                  $::bikeGeometry::Geometry(Saddle_BB)                            ;#[bikeGeometry::get_Scalar           Geometry Saddle_BB                ]                ;# set _lastValue(Result/Length/Saddle/SeatTube_BB)                        
        dict set projDict   Scalar      Geometry Saddle_Distance            $::bikeGeometry::Geometry(Saddle_Distance)                      ;#[bikeGeometry::get_Scalar           Geometry Saddle_Distance          ]                ;# set _lastValue(Personal/Saddle_Distance)                                
        dict set projDict   Scalar      Geometry Saddle_HB_y                $::bikeGeometry::Geometry(Saddle_HB_y)                          ;#[bikeGeometry::get_Scalar           Geometry Saddle_HB_y              ]                ;# set _lastValue(Result/Length/Saddle/Offset_HB)                          
        dict set projDict   Scalar      Geometry Saddle_Height              $::bikeGeometry::Geometry(Saddle_Height)                        ;#[bikeGeometry::get_Scalar           Geometry Saddle_Height              ]                ;# set _lastValue(Result/Length/Saddle/Offset_HB)                          
        dict set projDict   Scalar      Geometry Saddle_Offset_BB_ST        $::bikeGeometry::Geometry(Saddle_Offset_BB_ST)                  ;#[bikeGeometry::get_Scalar           Geometry Saddle_Offset_BB_ST      ]                ;# set _lastValue(Result/Length/Saddle/Offset_BB_ST)                       
        dict set projDict   Scalar      Geometry SeatTube_Virtual           $::bikeGeometry::Geometry(SeatTube_Virtual)                     ;#[bikeGeometry::get_Scalar           Geometry SeatTubeVirtual          ]                ;# set _lastValue(Result/Length/SeatTube/VirtualLength)                    
        dict set projDict   Scalar      Geometry Stack_Height               $::bikeGeometry::Geometry(Stack_Height)                         ;#[bikeGeometry::get_Scalar           Geometry StackHeightResult        ]                ;# set _lastValue(Result/Length/HeadTube/StackHeight)                      
        dict set projDict   Scalar      Geometry Stem_Angle                 $::bikeGeometry::Geometry(Stem_Angle)                           ;#[bikeGeometry::get_Scalar           Geometry Stem_Angle               ]                ;# set _lastValue(Component/Stem/Angle)                                    
        dict set projDict   Scalar      Geometry Stem_Length                $::bikeGeometry::Geometry(Stem_Length)                          ;#[bikeGeometry::get_Scalar           Geometry Stem_Length              ]                ;# set _lastValue(Component/Stem/Length)                                   
        dict set projDict   Scalar      Geometry TopTube_Virtual            $::bikeGeometry::Geometry(TopTube_Virtual)                      ;#[bikeGeometry::get_Scalar           Geometry TopTubeVirtual           ]                ;# set _lastValue(Result/Length/TopTube/VirtualLength)                     
        dict set projDict   Scalar      Geometry TopTube_Angle              $::bikeGeometry::Geometry(TopTube_Angle)                        ;#[bikeGeometry::get_Scalar           Geometry TopTube_Angle            ]                ;# set _lastValue(Custom/TopTube/Angle)                                    
        dict set projDict   Scalar      Geometry SeatTube_Angle             $::bikeGeometry::Geometry(SeatTube_Angle)                       ;#[bikeGeometry::get_Scalar           SeatTube Angle                    ]                ;# set _lastValue(Result/Angle/SeatTube/Direction)                         
        dict set projDict   Scalar      Geometry Fork_Height                $::bikeGeometry::Geometry(Fork_Height)                          ;#[bikeGeometry::get_Scalar           Fork Height                       ]                ;# set _lastValue(Component/Fork/Height)                                   
        dict set projDict   Scalar      Geometry Fork_Rake                  $::bikeGeometry::Geometry(Fork_Rake)                            ;#[bikeGeometry::get_Scalar           Fork Rake                         ]                ;# set _lastValue(Component/Fork/Rake)                                     
            #            
        dict set projDict   Scalar      Geometry HeadLugTop_Angle           $::bikeGeometry::Geometry(HeadLugTop_Angle)                     ;#[bikeGeometry::get_Scalar           Result Angle_HeadTubeTopTube      ]                ;# set _lastValue(Result/Angle/HeadTube/TopTube)                           
            #
        dict set projDict   Scalar      HandleBar PivotAngle                $::bikeGeometry::HandleBar(PivotAngle)                          ;#[bikeGeometry::get_Scalar           HandleBar PivotAngle              ]                ;# set _lastValue(Component/HandleBar/PivotAngle)                          
        dict set projDict   Scalar      HeadSet Diameter                    $::bikeGeometry::HeadSet(Diameter)                              ;#[bikeGeometry::get_Scalar           HeadSet Diameter                  ]                ;# set _lastValue(Component/HeadSet/Diameter)                              
        dict set projDict   Scalar      HeadSet Height_Bottom               $::bikeGeometry::HeadSet(Height_Bottom)                         ;#[bikeGeometry::get_Scalar           HeadSet Height_Bottom             ]                ;# set _lastValue(Component/HeadSet/Height/Bottom)                         
        dict set projDict   Scalar      HeadSet Height_Top                  $::bikeGeometry::HeadSet(Height_Top)                            ;#[bikeGeometry::get_Scalar           HeadSet Height_Top                ]                ;# set _lastValue(Component/HeadSet/Height/Top)                            
        dict set projDict   Scalar      HeadTube Diameter                   $::bikeGeometry::HeadTube(Diameter)                             ;#[bikeGeometry::get_Scalar           HeadTube Diameter                 ]                ;# set _lastValue(FrameTubes/HeadTube/Diameter)                            
        dict set projDict   Scalar      HeadTube Length                     $::bikeGeometry::HeadTube(Length)                               ;#[bikeGeometry::get_Scalar           HeadTube Length                   ]                ;# set _lastValue(FrameTubes/HeadTube/Length)                              
            #            
        dict set projDict   Scalar      Lugs BottomBracket_ChainStay_Angle      $::bikeGeometry::Lugs(BottomBracket_ChainStay_Angle)        ;#[bikeGeometry::get_Scalar           Lugs BottomBracket_ChainStay_Angle        ]        ;# set _lastValue(Lugs/BottomBracket/ChainStay/Angle/value)                
        dict set projDict   Scalar      Lugs BottomBracket_ChainStay_Tolerance  $::bikeGeometry::Lugs(BottomBracket_ChainStay_Tolerance)    ;#[bikeGeometry::get_Scalar           Lugs BottomBracket_ChainStay_Tolerance    ]        ;# set _lastValue(Lugs/BottomBracket/ChainStay/Angle/plus_minus)           
        dict set projDict   Scalar      Lugs BottomBracket_DownTube_Angle       $::bikeGeometry::Lugs(BottomBracket_DownTube_Angle)         ;#[bikeGeometry::get_Scalar           Lugs BottomBracket_DownTube_Angle         ]        ;# set _lastValue(Lugs/BottomBracket/DownTube/Angle/value)                 
        dict set projDict   Scalar      Lugs BottomBracket_DownTube_Tolerance   $::bikeGeometry::Lugs(BottomBracket_DownTube_Tolerance)     ;#[bikeGeometry::get_Scalar           Lugs BottomBracket_DownTube_Tolerance     ]        ;# set _lastValue(Lugs/BottomBracket/DownTube/Angle/plus_minus)            
        dict set projDict   Scalar      Lugs HeadLug_Bottom_Angle               $::bikeGeometry::Lugs(HeadLug_Bottom_Angle)                 ;#[bikeGeometry::get_Scalar           Lugs HeadLug_Bottom_Angle         ]                ;# set _lastValue(Lugs/HeadTube/DownTube/Angle/value)                      
        dict set projDict   Scalar      Lugs HeadLug_Bottom_Tolerance           $::bikeGeometry::Lugs(HeadLug_Bottom_Tolerance)             ;#[bikeGeometry::get_Scalar           Lugs HeadLug_Bottom_Tolerance     ]                ;# set _lastValue(Lugs/HeadTube/DownTube/Angle/plus_minus)                 
        dict set projDict   Scalar      Lugs HeadLug_Top_Angle                  $::bikeGeometry::Lugs(HeadLug_Top_Angle)                    ;#[bikeGeometry::get_Scalar           Lugs HeadLug_Top_Angle            ]                ;# set _lastValue(Lugs/HeadTube/TopTube/Angle/value)                       
        dict set projDict   Scalar      Lugs HeadLug_Top_Tolerance              $::bikeGeometry::Lugs(HeadLug_Top_Tolerance)                ;#[bikeGeometry::get_Scalar           Lugs HeadLug_Top_Tolerance        ]                ;# set _lastValue(Lugs/HeadTube/TopTube/Angle/plus_minus)                  
        dict set projDict   Scalar      Lugs RearDropOut_Angle                  $::bikeGeometry::Lugs(RearDropOut_Angle)                    ;#[bikeGeometry::get_Scalar           Lugs RearDropOut_Angle            ]                ;# set _lastValue(Lugs/RearDropOut/Angle/value)                            
        dict set projDict   Scalar      Lugs RearDropOut_Tolerance              $::bikeGeometry::Lugs(RearDropOut_Tolerance)                ;#[bikeGeometry::get_Scalar           Lugs RearDropOut_Tolerance        ]                ;# set _lastValue(Lugs/RearDropOut/Angle/plus_minus)                       
        dict set projDict   Scalar      Lugs SeatLug_SeatStay_Angle             $::bikeGeometry::Lugs(SeatLug_SeatStay_Angle)               ;#[bikeGeometry::get_Scalar           Lugs SeatLug_SeatStay_Angle       ]                ;# set _lastValue(Lugs/SeatTube/SeatStay/Angle/value)                      
        dict set projDict   Scalar      Lugs SeatLug_SeatStay_Tolerance         $::bikeGeometry::Lugs(SeatLug_SeatStay_Tolerance)           ;#[bikeGeometry::get_Scalar           Lugs SeatLug_SeatStay_Tolerance   ]                ;# set _lastValue(Lugs/SeatTube/SeatStay/Angle/plus_minus)                 
        dict set projDict   Scalar      Lugs SeatLug_TopTube_Angle              $::bikeGeometry::Lugs(SeatLug_TopTube_Angle)                ;#[bikeGeometry::get_Scalar           Lugs SeatLug_TopTube_Angle        ]                ;# set _lastValue(Lugs/SeatTube/TopTube/Angle/value)                       
        dict set projDict   Scalar      Lugs SeatLug_TopTube_Tolerance          $::bikeGeometry::Lugs(SeatLug_TopTube_Tolerance)            ;#[bikeGeometry::get_Scalar           Lugs SeatLug_TopTube_Tolerance    ]                ;# set _lastValue(Lugs/SeatTube/TopTube/Angle/plus_minus)                  
            #            
        dict set projDict   Scalar      RearBrake   LeverLength                 $::bikeGeometry::RearBrake(LeverLength)                     ;#[bikeGeometry::get_Scalar           RearBrake LeverLength             ]                ;# set _lastValue(Component/Brake/Rear/LeverLength)                        
        dict set projDict   Scalar      RearBrake   Offset                      $::bikeGeometry::RearBrake(Offset)                          ;#[bikeGeometry::get_Scalar           RearBrake Offset                  ]                ;# set _lastValue(Component/Brake/Rear/Offset)                             
        dict set projDict   Scalar      RearCarrier x                           $::bikeGeometry::RearCarrier(x)                             ;#[bikeGeometry::get_Scalar           RearCarrier x                     ]                ;# set _lastValue(Component/Carrier/Rear/x)                                
        dict set projDict   Scalar      RearCarrier y                           $::bikeGeometry::RearCarrier(y)                             ;#[bikeGeometry::get_Scalar           RearCarrier y                     ]                ;# set _lastValue(Component/Carrier/Rear/y)                                
        dict set projDict   Scalar      RearDerailleur Pulley_teeth             $::bikeGeometry::RearDerailleur(Pulley_teeth)               ;#[bikeGeometry::get_Scalar           RearDerailleur Pulley_teeth       ]                ;# set _lastValue(Component/Derailleur/Rear/Pulley/teeth)                  
        dict set projDict   Scalar      RearDerailleur Pulley_x                 $::bikeGeometry::RearDerailleur(Pulley_x)                   ;#[bikeGeometry::get_Scalar           RearDerailleur Pulley_x           ]                ;# set _lastValue(Component/Derailleur/Rear/Pulley/x)                      
        dict set projDict   Scalar      RearDerailleur Pulley_y                 $::bikeGeometry::RearDerailleur(Pulley_y)                   ;#[bikeGeometry::get_Scalar           RearDerailleur Pulley_y           ]                ;# set _lastValue(Component/Derailleur/Rear/Pulley/y)                      
            #            
        dict set projDict   Scalar      RearDropout Derailleur_x                $::bikeGeometry::RearDropout(Derailleur_x)                  ;#[bikeGeometry::get_Scalar           RearDropout Derailleur_x          ]                ;# set _lastValue(Lugs/RearDropOut/Derailleur/x)                           
        dict set projDict   Scalar      RearDropout Derailleur_y                $::bikeGeometry::RearDropout(Derailleur_y)                  ;#[bikeGeometry::get_Scalar           RearDropout Derailleur_y          ]                ;# set _lastValue(Lugs/RearDropOut/Derailleur/y)                           
        dict set projDict   Scalar      RearDropout OffsetCS                    $::bikeGeometry::RearDropout(OffsetCS)                      ;#[bikeGeometry::get_Scalar           RearDropout OffsetCS              ]                ;# set _lastValue(Lugs/RearDropOut/ChainStay/Offset)                       
        dict set projDict   Scalar      RearDropout OffsetCSPerp                $::bikeGeometry::RearDropout(OffsetCSPerp)                  ;#[bikeGeometry::get_Scalar           RearDropout OffsetCSPerp          ]                ;# set _lastValue(Lugs/RearDropOut/ChainStay/OffsetPerp)                   
        dict set projDict   Scalar      RearDropout OffsetCS_TopView            $::bikeGeometry::RearDropout(OffsetCS_TopView)              ;#[bikeGeometry::get_Scalar           RearDropout OffsetCS_TopView      ]                ;# set _lastValue(Lugs/RearDropOut/ChainStay/Offset_TopView)               
        dict set projDict   Scalar      RearDropout OffsetSS                    $::bikeGeometry::RearDropout(OffsetSS)                      ;#[bikeGeometry::get_Scalar           RearDropout OffsetSS              ]                ;# set _lastValue(Lugs/RearDropOut/SeatStay/Offset)                        
        dict set projDict   Scalar      RearDropout OffsetSSPerp                $::bikeGeometry::RearDropout(OffsetSSPerp)                  ;#[bikeGeometry::get_Scalar           RearDropout OffsetSSPerp          ]                ;# set _lastValue(Lugs/RearDropOut/SeatStay/OffsetPerp)                    
        dict set projDict   Scalar      RearDropout RotationOffset              $::bikeGeometry::RearDropout(RotationOffset)                ;#[bikeGeometry::get_Scalar           RearDropout RotationOffset        ]                ;# set _lastValue(Lugs/RearDropOut/RotationOffset)                         
            #            
        dict set projDict   Scalar      RearFender  Height                      $::bikeGeometry::RearFender(Height)                         ;#[bikeGeometry::get_Scalar           RearFender Height                 ]                ;# set _lastValue(Component/Fender/Rear/Height)                            
        dict set projDict   Scalar      RearFender  OffsetAngle                 $::bikeGeometry::RearFender(OffsetAngle)                    ;#[bikeGeometry::get_Scalar           RearFender OffsetAngle            ]                ;# set _lastValue(Component/Fender/Rear/OffsetAngle)                       
        dict set projDict   Scalar      RearFender  Radius                      $::bikeGeometry::RearFender(Radius)                         ;#[bikeGeometry::get_Scalar           RearFender Radius                 ]                ;# set _lastValue(Component/Fender/Rear/Radius)                            
        dict set projDict   Scalar      RearMockup  CassetteClearance           $::bikeGeometry::RearMockup(CassetteClearance)              ;#[bikeGeometry::get_Scalar           RearMockup CassetteClearance      ]                ;# set _lastValue(Rendering/RearMockup/CassetteClearance)                  
        dict set projDict   Scalar      RearMockup  ChainWheelClearance         $::bikeGeometry::RearMockup(ChainWheelClearance)            ;#[bikeGeometry::get_Scalar           RearMockup ChainWheelClearance    ]                ;# set _lastValue(Rendering/RearMockup/ChainWheelClearance)                
        dict set projDict   Scalar      RearMockup  CrankClearance              $::bikeGeometry::RearMockup(CrankClearance)                 ;#[bikeGeometry::get_Scalar           RearMockup CrankClearance         ]                ;# set _lastValue(Rendering/RearMockup/CrankClearance)                     
        dict set projDict   Scalar      RearMockup  DiscClearance               $::bikeGeometry::RearMockup(DiscClearance)                  ;#[bikeGeometry::get_Scalar           RearMockup DiscClearance          ]                ;# set _lastValue(Rendering/RearMockup/DiscClearance)                      
        dict set projDict   Scalar      RearMockup  DiscDiameter                $::bikeGeometry::RearMockup(DiscDiameter)                   ;#[bikeGeometry::get_Scalar           RearMockup DiscDiameter           ]                ;# set _lastValue(Rendering/RearMockup/DiscDiameter)                       
        dict set projDict   Scalar      RearMockup  DiscOffset                  $::bikeGeometry::RearMockup(DiscOffset)                     ;#[bikeGeometry::get_Scalar           RearMockup DiscOffset             ]                ;# set _lastValue(Rendering/RearMockup/DiscOffset)                         
        dict set projDict   Scalar      RearMockup  DiscWidth                   $::bikeGeometry::RearMockup(DiscWidth)                      ;#[bikeGeometry::get_Scalar           RearMockup DiscWidth              ]                ;# set _lastValue(Rendering/RearMockup/DiscWidth)                          
        dict set projDict   Scalar      RearMockup  TyreClearance               $::bikeGeometry::RearMockup(TyreClearance)                  ;#[bikeGeometry::get_Scalar           RearMockup TyreClearance          ]                ;# set _lastValue(Rendering/RearMockup/TyreClearance)                      
            #            
        dict set projDict   Scalar      RearWheel   FirstSprocket               $::bikeGeometry::RearWheel(FirstSprocket)                   ;#[bikeGeometry::get_Scalar           RearWheel FirstSprocket           ]                ;# set _lastValue(Component/Wheel/Rear/FirstSprocket)                      
        dict set projDict   Scalar      RearWheel   HubWidth                    $::bikeGeometry::RearWheel(HubWidth)                        ;#[bikeGeometry::get_Scalar           RearWheel HubWidth                ]                ;# set _lastValue(Component/Wheel/Rear/HubWidth)                           
        dict set projDict   Scalar      RearWheel   RimHeight                   $::bikeGeometry::RearWheel(RimHeight)                       ;#[bikeGeometry::get_Scalar           RearWheel RimHeight               ]                ;# set _lastValue(Component/Wheel/Rear/RimHeight)                          
        dict set projDict   Scalar      RearWheel   TyreShoulder                $::bikeGeometry::RearWheel(TyreShoulder)                    ;#[bikeGeometry::get_Scalar           RearWheel TyreShoulder            ]                ;# set _lastValue(Result/Length/RearWheel/TyreShoulder)                    
        dict set projDict   Scalar      RearWheel   TyreWidth                   $::bikeGeometry::RearWheel(TyreWidth)                       ;#[bikeGeometry::get_Scalar           RearWheel TyreWidth               ]                ;# set _lastValue(Component/Wheel/Rear/TyreWidth)                          
        dict set projDict   Scalar      RearWheel   TyreWidthRadius             $::bikeGeometry::RearWheel(TyreWidthRadius)                 ;#[bikeGeometry::get_Scalar           RearWheel TyreWidthRadius         ]                ;# set _lastValue(Component/Wheel/Rear/TyreWidthRadius)                    
            #            
        dict set projDict   Scalar      Reference   HandleBar_Distance          $::bikeGeometry::Reference(HandleBar_Distance)              ;#[bikeGeometry::get_Scalar           Reference HandleBar_Distance      ]                ;# set _lastValue(Reference/HandleBar_Distance)                            
        dict set projDict   Scalar      Reference   HandleBar_Height            $::bikeGeometry::Reference(HandleBar_Height)                ;#[bikeGeometry::get_Scalar           Reference HandleBar_Height        ]                ;# set _lastValue(Reference/HandleBar_Height)                              
        dict set projDict   Scalar      Reference   SaddleNose_Distance         $::bikeGeometry::Reference(SaddleNose_Distance)             ;#[bikeGeometry::get_Scalar           Reference SaddleNose_Distance     ]                ;# set _lastValue(Reference/SaddleNose_Distance)                           
        dict set projDict   Scalar      Reference   SaddleNose_HB               $::bikeGeometry::Reference(SaddleNose_HB)                   ;#[bikeGeometry::get_Scalar           Reference SaddleNose_HB           ]                ;# set _lastValue(Result/Length/Reference/SaddleNose_HB)                   
        dict set projDict   Scalar      Reference   SaddleNose_HB_y             $::bikeGeometry::Reference(SaddleNose_HB_y)                 ;#[bikeGeometry::get_Scalar           Reference SaddleNose_HB_y         ]                ;# set _lastValue(Result/Length/Reference/Heigth_SN_HB)                    
        dict set projDict   Scalar      Reference   SaddleNose_Height           $::bikeGeometry::Reference(SaddleNose_Height)               ;#[bikeGeometry::get_Scalar           Reference SaddleNose_Height       ]                ;# set _lastValue(Reference/SaddleNose_Height)                             
            #            
        dict set projDict   Scalar      Saddle      Height                      $::bikeGeometry::Saddle(Height)                             ;#[bikeGeometry::get_Scalar           Saddle Height                     ]                ;# set _lastValue(Personal/Saddle_Height)                                  
        dict set projDict   Scalar      Saddle      NoseLength                  $::bikeGeometry::Saddle(NoseLength)                         ;#[bikeGeometry::get_Scalar           Saddle NoseLength                 ]                ;# set _lastValue(Component/Saddle/LengthNose)     
        dict set projDict   Scalar      Saddle      Offset_x                    $::bikeGeometry::Saddle(Offset_x)                           ;#[bikeGeometry::get_Scalar           Saddle Offset_x                   ]                ;# set _lastValue(Rendering/Saddle/Offset_X)                               
        dict set projDict   Scalar      Saddle      Offset_y                    $::bikeGeometry::Saddle(Offset_y)                           ;#[bikeGeometry::get_Scalar           Saddle Offset_y                   ]                ;# set _lastValue(Rendering/Saddle/Offset_Y)                                                     
            #            
        dict set projDict   Scalar      SeatPost    Diameter                    $::bikeGeometry::SeatPost(Diameter)                         ;#[bikeGeometry::get_Scalar           SeatPost Diameter                 ]                ;# set _lastValue(Component/SeatPost/Diameter)                             
        dict set projDict   Scalar      SeatPost    PivotOffset                 $::bikeGeometry::SeatPost(PivotOffset)                      ;#[bikeGeometry::get_Scalar           SeatPost PivotOffset              ]                ;# set _lastValue(Component/SeatPost/PivotOffset)                          
        dict set projDict   Scalar      SeatPost    Setback                     $::bikeGeometry::SeatPost(Setback)                          ;#[bikeGeometry::get_Scalar           SeatPost Setback                  ]                ;# set _lastValue(Component/SeatPost/Setback)                              
        dict set projDict   Scalar      SeatStay    DiameterCS                  $::bikeGeometry::SeatStay(DiameterCS)                       ;#[bikeGeometry::get_Scalar           SeatStay DiameterCS               ]                ;# set _lastValue(FrameTubes/SeatStay/DiameterCS)                          
        dict set projDict   Scalar      SeatStay    DiameterST                  $::bikeGeometry::SeatStay(DiameterST)                       ;#[bikeGeometry::get_Scalar           SeatStay DiameterST               ]                ;# set _lastValue(FrameTubes/SeatStay/DiameterST)                          
        dict set projDict   Scalar      SeatStay    OffsetTT                    $::bikeGeometry::SeatStay(OffsetTT)                         ;#[bikeGeometry::get_Scalar           SeatStay OffsetTT                 ]                ;# set _lastValue(Custom/SeatStay/OffsetTT)                                
        dict set projDict   Scalar      SeatStay    SeatTubeMiterDiameter       $::bikeGeometry::SeatStay(SeatTubeMiterDiameter)            ;#[bikeGeometry::get_Scalar           SeatStay SeatTubeMiterDiameter    ]                ;# set _lastValue(Lugs/SeatTube/SeatStay/MiterDiameter)                    
        dict set projDict   Scalar      SeatStay    TaperLength                 $::bikeGeometry::SeatStay(TaperLength)                      ;#[bikeGeometry::get_Scalar           SeatStay TaperLength              ]                ;# set _lastValue(FrameTubes/SeatStay/TaperLength)                         
            #            
        dict set projDict   Scalar      SeatTube    DiameterBB                  $::bikeGeometry::SeatTube(DiameterBB)                       ;#[bikeGeometry::get_Scalar           SeatTube DiameterBB               ]                ;# set _lastValue(FrameTubes/SeatTube/DiameterBB)                          
        dict set projDict   Scalar      SeatTube    DiameterTT                  $::bikeGeometry::SeatTube(DiameterTT)                       ;#[bikeGeometry::get_Scalar           SeatTube DiameterTT               ]                ;# set _lastValue(FrameTubes/SeatTube/DiameterTT)                          
        dict set projDict   Scalar      SeatTube    Extension                   $::bikeGeometry::SeatTube(Extension)                        ;#[bikeGeometry::get_Scalar           SeatTube Extension                ]                ;# set _lastValue(Custom/SeatTube/Extension)                               
        dict set projDict   Scalar      SeatTube    OffsetBB                    $::bikeGeometry::SeatTube(OffsetBB)                         ;#[bikeGeometry::get_Scalar           SeatTube OffsetBB                 ]                ;# set _lastValue(Custom/SeatTube/OffsetBB)                                
        dict set projDict   Scalar      SeatTube    TaperLength                 $::bikeGeometry::SeatTube(TaperLength)                      ;#[bikeGeometry::get_Scalar           SeatTube TaperLength              ]                ;# set _lastValue(FrameTubes/SeatTube/TaperLength) 
            #            
        dict set projDict   Scalar      TopTube     DiameterHT                  $::bikeGeometry::TopTube(DiameterHT)                        ;#[bikeGeometry::get_Scalar           TopTube  DiameterHT               ]                ;# set _lastValue(FrameTubes/TopTube/DiameterHT)                           
        dict set projDict   Scalar      TopTube     DiameterST                  $::bikeGeometry::TopTube(DiameterST)                        ;#[bikeGeometry::get_Scalar           TopTube DiameterST                ]                ;# set _lastValue(Custom/TopTube/PivotPosition)                                        
        dict set projDict   Scalar      TopTube     OffsetHT                    $::bikeGeometry::TopTube(OffsetHT)                          ;#[bikeGeometry::get_Scalar           TopTube TaperLength               ] 
        dict set projDict   Scalar      TopTube     PivotPosition               $::bikeGeometry::TopTube(PivotPosition)                     ;#[bikeGeometry::get_Scalar           TopTube OffsetHT                  ] 
        dict set projDict   Scalar      TopTube     TaperLength                 $::bikeGeometry::TopTube(TaperLength)                       ;#[bikeGeometry::get_Scalar           TopTube PivotPosition             ]             
            #
        return $projDict   
            #
            #
            #
        project::pdict $projDict  4
            #
            # return
            #
            # puts "\n"
            # parray Component
            # puts ""
            # parray Config
            # puts ""
            # parray ListValue
            # puts ""
            # parray MathValue
            #
            #
        foreach arrayNameComplete {Component Config ListValue MathValue} {
                # puts "      -> $arrayNameComplete"
            foreach key [lsort [array names $arrayNameComplete]] {
                    # -> get value
                set value       [lindex [array get $arrayNameComplete $key] 1]
                set arrayName   [lindex [split $arrayNameComplete ::] end]
                set dictPath    [split [string trim $arrayName/$key "/"] /]
                    # puts "       -> $dictPath"
                dict set projDict $dictPath ${value}    
                    #
            }
        }
            #
        puts "  --- "
            #
            #
            #
        project::pdict $projDict  4
            #
        return $projDict
            #
        
    }

        #
        #
    proc bikeGeometry::set_Scalar {object key value} {
        puts "              <I> bikeGeometry::set_Scalar ... $object $key -> $value"
            #
            # -- check for existing parameter $object($key)
        if {[catch {array get [namespace current]::$object $key} eID]} {
            puts "\n              <W> bikeGeometry::set_Scalar ... \$key not accepted! ... $key / $value\n"
            return {}
        }
            #
            # -- check for values are mathematical values
        set newValue [bikeGeometry::check_mathValue $value] 
        if {$newValue == {}} {
            puts "\n              <W> bikeGeometry::set_Scalar ... \$value not accepted! ... $value"
            return {}
        }
            #
            # -- catch parameters that does not directly influence the model
        switch -exact $object {
            Geometry {
                    switch -exact $key {
                        {BottomBracket_Height}      {   bikeGeometry::set_Result_BottomBracketHeight    $newValue; return [get_Scalar $object $key] }
                        {FrontWhee_Radius}          {   bikeGeometry::set_Result_FrontWheelRadius       $newValue; return [get_Scalar $object $key] }
                        {FrontWheel_xy}             {   bikeGeometry::set_Result_FrontWheeldiagonal     $newValue; return [get_Scalar $object $key] }
                        {FrontWheel_x}              {   bikeGeometry::set_Result_FrontWheelhorizontal   $newValue; return [get_Scalar $object $key] }
                        {HeadLugTop_Angle}          {   bikeGeometry::set_Result_HeadTube_TopTubeAngle  $newValue; return [get_Scalar $object $key] }
                        {Reach_Length}              {   bikeGeometry::set_Result_HeadTubeReachLength    $newValue; return [get_Scalar $object $key] }
                        {RearWheel_Radius}          {   bikeGeometry::set_Result_RearWheelRadius        $newValue; return [get_Scalar $object $key] }
                        {RearWheel_x}               {   bikeGeometry::set_Result_RearWheelhorizontal    $newValue; return [get_Scalar $object $key] }
                        {SaddleNose_BB_x}           {   bikeGeometry::set_Result_SaddleOffset_BB_Nose   $newValue; return [get_Scalar $object $key] }
                        {SaddleNose_HB}             {   bikeGeometry::set_Result_PersonalSaddleNose_HB  $newValue; return [get_Scalar $object $key] }
                        {Saddle_BB}                 {   bikeGeometry::set_Result_SaddleSeatTube_BB      $newValue; return [get_Scalar $object $key] }
                        {Saddle_HB_y}               {   bikeGeometry::set_Result_SaddleOffset_HB        $newValue; return [get_Scalar $object $key] }
                        {Saddle_Offset_BB_ST}       {   bikeGeometry::set_Result_SaddleOffset_BB_ST     $newValue; return [get_Scalar $object $key] }
                        {SeatTube_Angle}            {   bikeGeometry::set_Result_SeatTubeDirection      $newValue; return [get_Scalar $object $key] }
                        {SeatTube_Virtual}          {   bikeGeometry::set_Result_SeatTubeVirtualLength  $newValue; return [get_Scalar $object $key] }
                        {Stack_Height}              {   bikeGeometry::set_Result_HeadTubeStackHeight    $newValue; return [get_Scalar $object $key] }
                        {TopTube_Virtual}           {   bikeGeometry::set_Result_TopTubeVirtualLength   $newValue; return [get_Scalar $object $key] }
                        
                        default {}
                    }
                }
            RearWheel {
                    switch -exact $key {
                        {TyreShoulder}              {   bikeGeometry::set_Result_RearWheelTyreShoulder  $newValue; return [get_Scalar $object $key] }
                        
                        default {}              
                    }
                }
            Reference {
                    switch -exact $key {
                        {SaddleNose_HB}             {   bikeGeometry::set_Result_ReferenceSaddleNose_HB $newValue; return [get_Scalar $object $key] }
                        {SaddleNose_HB_y}           {   bikeGeometry::set_Result_ReferenceHeigth_SN_HB  $newValue; return [get_Scalar $object $key] }

                        default {}              
                    }
                }
            default {}
        }
            #
            # -- set value to parameter
        array set [namespace current]::$object [list $key $newValue]
        bikeGeometry::update_Project
            #
        set scalarValue [bikeGeometry::get_Scalar $object $key ]
        puts "              <I> bikeGeometry::set_Scalar ... $object $key -> $scalarValue"
            #
        return $scalarValue
            #
    }
        #
    proc bikeGeometry::set_ListValue {key value} { 
            # -- check for existing parameter $Config($key)
        if {[catch {array get [namespace current]::set_ListValue $key} eID]} {
            puts "\n              <W> bikeGeometry::set_ListValue ... \$key not accepted! ... $key / $value\n"
            return {}
        }
            # -- set value to parameter
        set [namespace current]::ListValue($key) $value
        bikeGeometry::update_Project
            #
        set listValue  [lindex [array get [namespace current]::ListValue $key] 1]
        puts "              <I> bikeGeometry::set_ListValue ... $key -> $listValue"
            #
        return $listValue    
    }    
        #
    proc bikeGeometry::set_Component {key value} {
            # -- check for existing parameter $Config($key)
        if {[catch {array get [namespace current]::Config $key} eID]} {
            puts "\n              <W> bikeGeometry::set_Component ... \$key not accepted! ... $key / $value\n"
            return {}
        }
            # -- set value to parameter
        set [namespace current]::Component($key) $value
        bikeGeometry::update_Project
            #
        set componentValue  [bikeGeometry::get_Component $key]
        puts "              <I> bikeGeometry::set_Component ... $key -> $componentValue"
            #
        return $componentValue
            #
    }
        #
    proc bikeGeometry::set_Config {key value} {
            # -- check for existing parameter $Config($key)
        if {[catch {array get [namespace current]::Config $key} eID]} {
            puts "\n              <W> bikeGeometry::set_Config ... \$key not accepted! ... $key / $value\n"
            return {}
        }
            # -- set value to parameter
        set [namespace current]::Config($key) $value
        bikeGeometry::update_Project
            #
        set configValue [bikeGeometry::get_Config $key]
        puts "              <I> bikeGeometry::set_Config ... $key -> $configValue"
            #
        return $configValue
            #
    }  
        #
        #
    proc bikeGeometry::get_Scalar {object key} {
        set scalarValue [lindex [array get [namespace current]::$object $key] 1]
        return $scalarValue    
    }
        #
    proc bikeGeometry::get_ListValue {key} { 
        set listValue   [lindex [array get [namespace current]::ListValue $key] 1]
        return $listValue    
    }    
        #
    proc bikeGeometry::get_Component {key} {
        set compFile    [lindex [array get [namespace current]::Component $key] 1]
        return $compFile
    } 
        #
    proc bikeGeometry::get_Config {key} {
        set configValue [lindex [array get [namespace current]::Config $key] 1]
        return $configValue
    }  
        #
        #
    proc bikeGeometry::get_Polygon {key {centerPoint {0 0}}} {
        set polygon     [lindex [array get [namespace current]::Polygon $key] 1]
        return [ vectormath::addVectorPointList  $centerPoint  $polygon]
    }
        #
    proc bikeGeometry::get_Position {key {centerPoint {0 0}}} {
                #
            variable Position
                #
            variable BottomBracket
            variable ChainStay
            variable DownTube
            variable Fork
            variable FrontBrake
            variable FrontCarrier
            variable FrontDerailleur
            variable FrontWheel
            variable Geometry
            variable HandleBar
            variable HeadTube
            variable Lugs
            variable RearBrake
            variable RearCarrier
            variable RearDropout
            variable RearWheel
            variable Saddle
            variable SeatPost
            variable SeatStay
            variable SeatTube
            variable Steerer
            variable TopTube
                #
            variable DEBUG_Geometry
                #
            variable Reference
                #
            set returnValue {}
            set position    {}
                #
            switch -glob $key {
                
                BottomBracket                       {set position {0 0}                     }
                BottomBracket_Ground                {set position $Position(BottomBracket_Ground)}
                FrontBrake_Shoe                     {set position $Position(FrontBrake_Shoe)         }
                FrontBrake_Help                     {set position $Position(FrontBrake_Help)         }
                FrontBrake_Definition               {set position $Position(FrontBrake_Definition)   }
                FrontBrake_Mount                    {set position $Position(FrontBrake_Mount)        }
                RearBrake_Shoe                      {set position $Position(RearBrake_Shoe)          }
                RearBrake_Help                      {set position $Position(RearBrake_Help)          }
                RearBrake_Definition                {set position $Position(RearBrake_Definition)    }
                RearBrake_Mount                     {set position $Position(RearBrake_Mount)         }
                 
                CarrierMount_Front                  {set position $Position(CarrierMount_Front)      }
                CarrierMount_Rear                   {set position $Position(CarrierMount_Rear)       }
                DerailleurMount_Front               {set position $Position(DerailleurMount_Front)   }
                FrontWheel                          {set position $Position(FrontWheel)     }          
                HandleBar                           {set position $Position(HandleBar)      }
                LegClearance                        {set position $Position(LegClearance)   }
                RearWheel                           {set position $Position(RearWheel)      }
                Reference_HB                        {set position $Position(Reference_HB)     }
                Reference_SN                        {set position $Position(Reference_HB)    }
                Saddle                              {set position $Position(Saddle)         }
                SaddleNose                          {set position $Position(SaddleNose)             }
                SaddleProposal                      {set position $Position(SaddleProposal)         }
                SeatPost_Pivot                      {set position $Position(SeatPost_Pivot)  }
                SeatPost_Saddle                     {set position $Position(SeatPost_Saddle)         }
                SeatPost_SeatTube                   {set position $Position(SeatPost_SeatTube)       }
                SeatTube_Ground                     {set position $Position(SeatTube_Ground)         }
                SeatTube_Saddle                     {set position $Position(SeatTube_Saddle) }
                SeatTube_VirtualTopTube             {set position $Position(SeatTube_VirtualTopTube) }
                Steerer_Ground                      {set position $Position(Steerer_Ground)          }
                        
                RearDerailleur                      {set position $RearDropout(DerailleurPosition)      }
        
                RearDropout                         {set position $Position(RearDropout)                }
                FrontDropout                        {set position $Position(FrontWheel)                 }
                ForkCrown                           {set position $Steerer(Fork)                        }
                                                                                                        
                ChainStay_SeatStay_IS               {set position $ChainStay(SeatStay_IS)               }
                DownTube_BottleCageBase             {set position $DownTube(BottleCage_Base)            }        
                DownTube_BottleCageOffset           {set position $DownTube(BottleCage_Offset)          }
                DownTube_Lower_BottleCageBase       {set position $DownTube(BottleCage_Lower_Base)      }   
                DownTube_Lower_BottleCageOffset     {set position $DownTube(BottleCage_Lower_Offset)    }   
                DownTube_End                        {set position $DownTube(HeadTube)                   }
                DownTube_Start                      {set position $DownTube(BottomBracket)              }
                HeadTube_End                        {set position $HeadTube(Stem)                       }
                HeadTube_Start                      {set position $HeadTube(Fork)                       }
                SeatStay_End                        {set position $SeatStay(SeatTube)                   }
                SeatStay_Start                      {set position $SeatStay(RearWheel)                  }
                SeatTube_BottleCageBase             {set position $SeatTube(BottleCage_Base)            }
                SeatTube_BottleCageOffset           {set position $SeatTube(BottleCage_Offset)          }
                SeatTube_End                        {set position $SeatTube(TopTube)                    }
                SeatTube_Start                      {set position $SeatTube(BottomBracket)              }
                Steerer_End                         {set position $Steerer(Stem)                        }
                Steerer_Start                       {set position $Steerer(Fork)                        }
                TopTube_End                         {set position $TopTube(HeadTube)                    }
                TopTube_Start                       {set position $TopTube(SeatTube)                    } 
                                                                                                       
                ChainStay_RearMockup                {set position $ChainStay(RearMockupStart)           }

                default { puts "   <E> ... bikeGeometry::get_Position \$key $key"
                            # set branch "Tubes/$object"
                        }                        
                        
            }
                #
                #   SummarySize                         {set position $Geometry(SummarySize)    }
                #
                #
                # puts "    ... $branch"
                #
            return [ vectormath::addVector  $centerPoint  $position] 
                #
    }
        #
    proc bikeGeometry::get_Direction {key {type {polar}}} {
                #
            variable Fork
            variable ChainStay
            variable DownTube
            variable HeadTube
            variable SeatStay
            variable SeatTube
            variable Steerer
            variable TopTube
            variable RearDropout
                #
            set returnValue {}
            set direction   {}
                #
            set branch      {}
            # puts " -> $key $type -> ..." 
                #
                # IMPORTANT: ... set direction {0 0} ... these values are not updated from bikeGeometry !!! 2014 11 01
                #
            switch -glob $key {
                RearDropout         {set direction $RearDropout(Direction)  }
                ForkDropout         {set direction $Fork(DropoutDirection)  }
                ForkCrown           {set direction $Fork(CrownDirection)    }       
                
                ChainStay           {set direction $ChainStay(Direction)    }
                DownTube            {set direction $DownTube(Direction)     }
                HeadTube            {set direction $HeadTube(Direction)     }
                SeatStay            {set direction $SeatStay(Direction)     }
                SeatTube            {set direction $SeatTube(Direction)     }
                Steerer             {set direction $Steerer(Direction)      }
                TopTube             {set direction $TopTube(Direction)      }
                
                
                default { puts "   <E> ... bikeGeometry::get_Direction \$key $key"
                        # set branch "Tubes/$key/Direction/polar"
                    }
            }
                #
            #puts " -> $key $type -> $direction"
                #
            if {$direction == {}} {  
                puts "    <W> ... get_Direction $branch"
                return -1
            }
                #
            switch -exact $type {
                degree  {   return [vectormath::angle {1 0} {0 0} $direction] }
                rad    -
                polar  -
                default {   return $direction}
            }
    }
        #
    proc bikeGeometry::get_BoundingBox {key} {
        set boundingBox [lindex [array get [namespace current]::BoundingBox $key] 1]
        return $boundingBox
    }
        #
    proc bikeGeometry::get_TubeMiter {key} {
        set tubeMiter   [lindex [array get [namespace current]::TubeMiter $key] 1]
        return $tubeMiter
    }
        
        #
    proc bikeGeometry::get_CenterLine {key} {
        set centerLine  [lindex [array get [namespace current]::CenterLine $key] 1]
        return $centerLine
    }
        #
        #
    proc bikeGeometry::get_ComponentDir {} {
            #
        variable packageHomeDir
            #
        set componentDir [file join $packageHomeDir  .. etc  components]
            #
        return $componentDir
            #
    }
        #
    proc bikeGeometry::get_ComponentDirectories {} {
            #
        variable initDOM
            #
        set dirList {} 
            #
        set locationNode    [$initDOM selectNodes /root/Options/ComponentLocation]
            #
        foreach childNode [$locationNode childNodes ] {
            if {[$childNode nodeType] == {ELEMENT_NODE}} {
                set keyString  [$childNode getAttribute key {}]
                set dirString  [$childNode getAttribute dir {}]
                lappend dirList [list $keyString $dirString]
            }
        }            
            #
        return $dirList
            #
    }
    
        #
    proc bikeGeometry::get_ListBoxValues {} {    
            #
        variable initDOM
            #
        dict create dict_ListBoxValues {} 
            # variable valueRegistry
            # array set valueRegistry      {}
            #
        set optionNode    [$initDOM selectNodes /root/Options]
        foreach childNode [$optionNode childNodes ] {
            if {[$childNode nodeType] == {ELEMENT_NODE}} {
                    # puts "    init_ListBoxValues -> $childNode"
                set childNode_Name [$childNode nodeName]
                    # puts "    init_ListBoxValues -> $childNode_Name"
                    #
                    # set valueRegistry($childNode_Name) {}
                set nodeList {}
                    #
                foreach child_childNode [$childNode childNodes ] {
                    if {[$child_childNode nodeType] == {ELEMENT_NODE}} {
                          # puts "    ->$childNode_Name<"
                        switch -exact -- $childNode_Name {
                            {Rim} {
                                      # puts "    init_ListBoxValues (Rim) ->   $childNode_Name -> [$child_childNode nodeName]"
                                    set value_01 [$child_childNode getAttribute inch     {}]
                                    set value_02 [$child_childNode getAttribute metric   {}]
                                    set value_03 [$child_childNode getAttribute standard {}]
                                    if {$value_01 == {}} {
                                        set value {-----------------}
                                    } else {
                                        set value [format "%s ; %s %s" $value_02 $value_01 $value_03]
                                          # puts "   -> $value   <-> $value_02 $value_01 $value_03"
                                    }
                                        # lappend valueRegistry($childNode_Name)  $value
                                    lappend nodeList                        $value
                                }
                            {ComponentLocation} {}
                            default {
                                        # puts "    init_ListBoxValues (default) -> $childNode_Name -> [$child_childNode nodeName]"
                                    if {[string index [$child_childNode nodeName] 0 ] == {_}} continue
                                        # lappend valueRegistry($childNode_Name)  [$child_childNode nodeName]
                                    lappend nodeList                        [$child_childNode nodeName]
                                }
                        }
                    }
                }
                dict append dict_ListBoxValues $childNode_Name $nodeList
                
            }
        }
            #
            # puts "---"  
            #
        set forkNode    [$initDOM selectNodes /root/Fork]
        set childNode_Name   [$forkNode nodeName]
            # set valueRegistry($childNode_Name) {}
        set nodeList {}
        foreach child_childNode [$forkNode childNodes ] {
            if {[$childNode nodeType] == {ELEMENT_NODE}} {            
                            # puts "    init_ListBoxValues -> $childNode_Name -> [$child_childNode nodeName]"
                        if {[string index [$child_childNode nodeName] 0 ] == {_}} continue
                            # lappend valueRegistry($childNode_Name)  [$child_childNode nodeName]
                        lappend nodeList                        [$child_childNode nodeName]
            }
        }
        dict append dict_ListBoxValues $childNode_Name $nodeList        
            #
          
            # 
            # exit          
            # parray valueRegistry
            # project::pdict $dict_ListBoxValues
            # exit
            #
        return $dict_ListBoxValues
            #
    }    
        #
        #
    proc bikeGeometry::get_DebugGeometry {} {
        # http://stackoverflow.com/questions/9676651/converting-a-list-to-an-array
        set dict_Geometry [array get ::bikeGeometry::DEBUG_Geometry]
        return $dict_Geometry
    }
        #
    proc bikeGeometry::get_ReynoldsFEAContent {} {
        return [::bikeGeometry::lib_reynoldsFEA::get_Content]    
    }
    
    #-------------------------------------------------------------------------
        #  sets and format Value
        #
    proc bikeGeometry::set_Value_remove {xpath value {mode {update}}} {
     
            puts "  <I> bikeGeometry::set_Value $xpath $value $mode"             
            # xpath: e.g.:Custom/BottomBracket/Depth
              
              # puts ""
              # puts "   -------------------------------"
              # puts "    set_Value"
              # puts "       xpath:           $xpath"
              # puts "       value:           $value"
              # puts "       mode:            $mode"
         
            foreach {_array _name path} [project::unifyKey $xpath] break
                # puts "     ... $_array  $_name"
         
         
            # --- handle xpath values ---
                # puts "  ... mode: $mode"
                
                # --- exception on mode == force ---
                # 
            switch -exact $mode {
                {format} { 
                            # -- currently check why ... 20141126
                        # tk_messageBox -message "bikeGeometry::set_Value - format - $xpath $value"
                    }
                {force} { 
                            # -- currently check why ... 20141126
                        # tk_messageBox -message "bikeGeometry::set_Value - force - $xpath $value"
                        eval set [format "project::%s(%s)" $_array $_name] $value
                        bikeGeometry::update_Project
                        return $value
                    }
                default {}
            }
                # --- exception for Result - Values ---
                #   ... loop over set_resultParameter
                #    if there is a Result to set
                #             
                #   puts "  ... setValue: $xpath"
            switch -glob $_array {
                {Result} {
                        set newValue [check_mathValue $value]
                            # set newValue [ string map {, .} $value]
                            # puts "\n  ... setValue: ... Result/..."
                        set_resultParameter $_array $_name $newValue
                        return $newValue
                    }
                {Rendering} {
                        # tk_messageBox -message "bikeGeometry::set_Value Rendering $xpath $value"
                    }
                default {}
            }
            
                # --- all the exceptions done ---
                #   on int list values like defined
                #   puts "<D> $xpath"
            switch -exact $xpath {
                {Component/Wheel/Rear/RimDiameter} -
                {Component/Wheel/Front/RimDiameter} -
                {Lugs/RearDropOut/Direction} -
                {Component/CrankSet/ChainRings} -
                {Component/Wheel/Rear/FirstSprocket} {
                            # set newValue [ string map {, .} $value]
                        set newValue [check_mathValue $value]    
                            # puts " <D> $newValue"
                        project::setValue [format "%s(%s)" $_array $_name] value $newValue
                        bikeGeometry::get_from_project
                        bikeGeometry::update_Project  
                        return $newValue
                    }
                default {}
            }
                #
                # --- update or return on errorID
            set checkValue {mathValue}
            set newValue    $value
                #
            if {[file dirname $xpath] == {Rendering}} {
                set checkValue {}
                    # puts "               ... [file dirname $xpath] "
            }
            if {[file tail $xpath]    == {File}     } {
                set checkValue {}
                    # puts "               ... [file tail    $xpath] "
            }
            if {[lindex [split $xpath /] 0] == {Rendering}} {
                set checkValue {}
                  # puts "   ... Rendering: $xpath "
            }
                #
                # --- update or return on errorID
            if {$checkValue == {mathValue} } {
                set newValue [check_mathValue $value]
                if {$newValue == {}} {
                    return {}
                }
            }

    
            # --------------------------------------
                #  at least update Geometry
                #   ... if not left earlier
                #
            # puts "    <I> bikeGeometry::set_Value  ... $newValue"
                #
            project::setValue [format "%s(%s)" $_array $_name] value $newValue
            bikeGeometry::get_from_project
			bikeGeometry::update_Project
                # puts "" 
                # puts "    setValue:  $argv\n" 
                # puts "                [format "%s(%s)" $_array $_name] vs $xpath "
            parray ::bikeGeometry::Config
                #
            return $newValue
    }

    #-------------------------------------------------------------------------
       #  check mathValue
    proc bikeGeometry::check_mathValue {value} {
                #
            puts "                  <1> bikeGeometry::check_mathValue $value"    
                # --- set new Value
            set newValue [ string map {, .} $value]
                # --- check Value --- ";" ... like in APPL_RimList
            if {[llength [split $newValue  ]] > 1} return {}
            if {[llength [split $newValue ;]] > 1} return {}
                #
            if { [catch { set newValue [expr 1.0 * $newValue] } errorID] } {
                puts "\n                <E> bikeGeometry::check_mathValue"
                foreach line [split ${errorID} \n] {
                    puts "           $line"
                }
                puts ""
                return {}
            }
                #
                #
            set newValue [format "%.3f" $newValue]
                #
            puts "                  <2> bikeGeometry::check_mathValue $value  ->  $newValue"
                #
            return $newValue
                #
    }
    #-------------------------------------------------------------------------
       #  trace/update Project
    proc bikeGeometry::trace_Project {varname key operation} {
            if {$key != ""} {
        	    set varname ${varname}($key)
        	}
            upvar $varname var
            # value is 889 (operation w)
            # value is 889 (operation r)
            puts "trace_Prototype: (operation: $operation) $varname is $var "
    }
    #-------------------------------------------------------------------------
        #  add vector to list of coordinates
    proc bikeGeometry::coords_flip_y {coordlist} {
            set returnList {}
            foreach {x y} $coordlist {
                set new_y [expr -$y]
                set returnList [lappend returnList $x $new_y]
            }
            return $returnList
    }

    #-------------------------------------------------------------------------
        #  get xy in a flat list of coordinates, start with    0, 1, 2, 3, ...
    proc bikeGeometry::coords_xy_index {coordlist index} {
            switch $index {
                {end} {
                      set index_y [expr [llength $coordlist] -1]
                      set index_x [expr [llength $coordlist] -2]
                    } 
                {end-1} {
                      set index_y [expr [llength $coordlist] -3]
                      set index_x [expr [llength $coordlist] -4]
                    }
                default {
                      set index_x [ expr 2 * $index ]
                      set index_y [ expr $index_x + 1 ]
                      if {$index_y > [llength $coordlist]} { return {0 0} }
                    }
            }
            return [list [lindex $coordlist $index_x] [lindex $coordlist $index_y] ]
    }
    
    #-------------------------------------------------------------------------
        # see  http://wiki.tcl.tk/440
        #
    proc bikeGeometry::flatten_nestedList { args } {
            if {[llength $args] == 0 } { return ""}
            set flatList {}
            foreach e [eval concat $args] {
                foreach ee $e { lappend flatList $ee }
            }
                # tk_messageBox -message "flatten_nestedList:\n    $args  -/- [llength $args] \n $flatList  -/- [llength $flatList]"
            return $flatList
    }     
    proc bikeGeometry::set_dictValue {dictPath dictValue args} {
            variable returnDict
                #
            puts "  ... set_dictValue"
            puts "      ... $dictPath  "
            #set command [format "dict set $returnDict %s \{%s\}"   $dictPath ${dictValue}]
			# set command [format "dict set projectDICT %s \{%s\}"   $dictPath ${dictValue}]
			    # puts "            ........ set value: $command"
			#{*}$command
            
            dict set returnDict $dictPath ${dictValue}
			    # dict set projectDICT Runtime ChainStay CenterLine angle_01 {-8.000}
			# return $dictionary
    }

    proc bikeGeometry::get_dictValue {dictPath dictKey} {
            variable returnDict
              #
            set value "___undefined___"
           
            if { [catch {set value [dict get $returnDict {*}$dictPath $dictKey]} fid]} {
                puts "  <E> ... $fid"
                # exit
            } 
            return $value

    }

