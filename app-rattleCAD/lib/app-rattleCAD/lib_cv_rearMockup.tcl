 ##+##########################################################################
 #
 # package: rattleCAD    ->    lib_cv_custom.tcl
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
 #    namespace:  rattleCAD::cv_custom
 # ---------------------------------------------------------------------------
 #
 # 

      #
    variable  rattleCAD::cv_custom::ctrl_Points
    array set rattleCAD::cv_custom::ctrl_Points {}
      #
    variable  rattleCAD::cv_custom::sect_Points
    array set rattleCAD::cv_custom::sect_Points {}
      #
      
    proc rattleCAD::cv_custom::createRearMockup {cv_Name} {
            
            puts ""
            puts "   -------------------------------"
            puts "     rattleCAD::cv_custom::createLugRep"
            puts "       cv_Name:         $cv_Name"
             
                variable    stageScale

                variable    BottomBracket   
                variable    RearWheel
                
                array set   ChainStay       {}
                array set   Length          {}
                array set   Center          {}
                array set   ClearChainWheel {}             
                array set   ClearCassette   {}             
                
                array set   Colour          {}
                      set   Colour(primary)     darkred
                      set   Colour(secondary)   darkorange
                      set   Colour(third)       orange
                      set   Colour(result)      darkblue
                
            set Length(ChainStay)           [rattleCAD::model::get_Scalar Geometry ChainStay_Length]
            set Length(CrankSet)            [rattleCAD::model::get_Scalar CrankSet Length]
            set Length(PedalMount)          [expr 0.5 * [rattleCAD::model::get_Scalar CrankSet Q-Factor] ]
            set Length(PedalEye)            [rattleCAD::model::get_Scalar CrankSet PedalEye]
            set Length(CrankSet_ArmWidth)   [rattleCAD::model::get_Scalar CrankSet ArmWidth]
            set Length(ChainLine)           [rattleCAD::model::get_Scalar CrankSet ChainLine]
            set Length(ChainRingOffset)     [rattleCAD::model::get_Scalar CrankSet ChainRingOffset]

                 #   puts "     BottomBracket(Position) -> $BottomBracket(Position)"
                 #   puts "     RearWheel(Position)    -> $RearWheel(Position)"
                 #   puts "       -> $Length(ChainStay)"
                    
                 #   puts "     BottomBracket -> [rattleCAD__model__getValue Lugs/BottomBracket/Diameter/outside]"
                 #   puts "     BottomBracket -> [rattleCAD__model__getValue Lugs/BottomBracket/Diameter/inside]"
                 #   puts "     BottomBracket -> [rattleCAD__model__getValue Lugs/BottomBracket/Width]"
                 #   puts "     BottomBracket -> [rattleCAD__model__getValue Lugs/BottomBracket/ChainStay/Offset_TopView]"
                    
                 #   puts "     RimDiameter   -> [rattleCAD__model__getValue Component/Wheel/Rear/RimDiameter]"
                 #   puts "     RimHeight     -> [rattleCAD__model__getValue Component/Wheel/Rear/RimHeight]"
                 #   puts "     TyreHeight    -> [rattleCAD__model__getValue Component/Wheel/Rear/TyreHeight]"
                    
                 #   puts "     HubWidth      -> [rattleCAD__model__getValue Lugs/RearDropOut/HubWidth]"
                    
                 #   puts "     ChainStay     -> [rattleCAD__model__getValue Lugs/RearDropOut/ChainStay/Offset]" 
                 #   puts "     ChainStay     -> [rattleCAD__model__getValue Lugs/RearDropOut/ChainStay/Offset_TopView]" 
                 #   puts "     ChainStay     -> [rattleCAD__model__getValue FrameTubes/ChainStay/Width]" 
            
                 #   puts "  -> profile_x04   [rattleCAD__model__getValue FrameTubes/ChainStay/Profile/length_04] profile_x04   [rattleCAD__model__getValue FrameTubes/ChainStay/Profile/length_04]"
        
            set Length(00)              [ expr 0.5 * [rattleCAD::model::get_Scalar BottomBracket OutsideDiameter] ]
            set Length(01)              [ expr 0.5 * [rattleCAD::model::get_Scalar BottomBracket InsideDiameter] ]
            set Length(02)              [ expr 0.5 * [rattleCAD::model::get_Scalar BottomBracket Width] ]
            set Length(03)              [ expr $Length(02) - [rattleCAD::model::get_Scalar BottomBracket OffsetCS_TopView] ]
            set Length(04)              [ expr 0.5 * [rattleCAD::model::get_Scalar RearWheel HubWidth] ]
            set Length(05)              [ expr 0.5 * [rattleCAD::model::get_Scalar RearWheel HubWidth] + [rattleCAD::model::get_Scalar RearDropout OffsetCS_TopView]]
            set Length(06)              [ expr 0.5 * [rattleCAD::model::get_Scalar Geometry RearRim_Diameter] + [rattleCAD::model::get_Scalar Geometry RearTyre_Height] - [rattleCAD::model::get_Scalar RearWheel TyreWidthRadius]]

            
            set Center(BottomBracket)   {0 0}
            set Center(Dim_BBWidth_01)  [ list $Length(00) [expr -1.0 * $Length(02)] ]
            set Center(Dim_BBWidth_02)  [ list $Length(00) $Length(02) ]
            set Center(Dim_BBDiameter)  [ list [expr -1.0 * $Length(00)] $Length(02) ]
            set Center(Dim_BBDiam_01)   [ list $Length(01) $Length(02) ]
            set Center(Dim_BBDiam_02)   [ list [expr -1.0 * $Length(01)] $Length(02) ]
            set Center(RearHub)         [ list [expr -1 * $Length(ChainStay)] 0 ]
            set Center(Dim_RearHub_01)  [ list [expr -1 * $Length(ChainStay)] $Length(04) ]
            set Center(Dim_RearHub_02)  [ list [expr -1 * $Length(ChainStay)] [expr -1.0 * $Length(04)] ]
            set Center(CL_BB_01)        [ list 0 [expr -1.0 * $Length(04) -15] ]
            set Center(CL_BB_02)        [ list 0 [expr $Length(04) + 15] ]    
            set Center(CL_RearHub_01)   [ list [expr -1 * $Length(ChainStay)] [expr -1.0 * $Length(04) -15] ]
            set Center(CL_RearHub_02)   [ list [expr -1 * $Length(ChainStay)] [expr $Length(04) + 15] ]    
            set Center(DropOut)         [ list [expr -1 * $Length(ChainStay)] $Length(04) ]
            set Center(Tyre)            [ vectormath::addVector $Center(RearHub)    [ list [expr 0.5 * ([rattleCAD::model::get_Scalar Geometry RearRim_Diameter] + [rattleCAD::model::get_Scalar Geometry RearTyre_Height])] 0 ] ]
            set Center(Rim)             [ vectormath::addVector $Center(RearHub)    [ list [expr 0.5 *  [rattleCAD::model::get_Scalar Geometry RearRim_Diameter]] 0 ] ]
            set Center(TyreWidth)       [ vectormath::addVector $Center(RearHub)    [ list [rattleCAD::model::get_Scalar RearWheel TyreWidthRadius] 0 ] ]
            set Center(Dim_WheelRadius) [ vectormath::addVector $Center(Tyre)       [ list [expr 0.5 * [rattleCAD::model::get_Scalar Geometry RearTyre_Height]] 0 ] ]
            set Center(Dim_Tyre_01)     [ vectormath::addVector $Center(TyreWidth)  [ list 0 [expr  0.5 * [rattleCAD::model::get_Scalar RearWheel TyreWidth]] ] ]
            set Center(Dim_Tyre_02)     [ vectormath::addVector $Center(TyreWidth)  [ list 0 [expr -0.5 * [rattleCAD::model::get_Scalar RearWheel TyreWidth]] 0 ] ]
            
            
            set Center(ChainStay_DO)    [ vectormath::addVector $Center(RearHub) [ list [rattleCAD::model::get_Scalar RearDropout OffsetCS]  [ expr $Length(04) + [rattleCAD::model::get_Scalar RearDropout OffsetCS_TopView]] ] ]
            set ChainStay(00)           [ list [expr -1.0 * $Length(01)] $Length(03) ] 
            set Center(ChainStay_00)    [ vectormath::cathetusPoint $Center(ChainStay_DO) $ChainStay(00) [expr 0.5 * [rattleCAD::model::get_Scalar ChainStay WidthBB]] opposite ]
      
                #   puts "   -> Center(Tyre)  $Center(Tyre)"
            
            set ChainStay(91)           [ list [expr -1.0 * $Length(ChainStay)] [expr -1 * $Length(05)] ]   ;# dimension: ChainStay Center DO
            set ChainStay(92)           [ list [expr -1.0 * $Length(ChainStay)] [expr -1 * $Length(04)] ]   ;# dimension: Center DO
            set ChainStay(93)           [ list [expr -1.0 * $Length(01)] [expr -1 * $Length(03)] ]          ;# dimension: ChainStay outside BB
            set ChainStay(94)           [ list $Length(00)               [expr -1 * $Length(02)] ]          ;# dimension: Corner BB
            set ChainStay(95)           [ list [expr -1.0 * ($Length(ChainStay) - [rattleCAD::model::get_Scalar RearDropout OffsetCS])] [expr -1 * $Length(05)] ]   ;# dimension: Chainstay Center DO
            set ChainStay(96)           [ list [expr -1.0 * ($Length(ChainStay) - [rattleCAD::model::get_Scalar RearDropout OffsetCS])] [expr  1 * $Length(05)] ]   ;# dimension: Chainstay Center DO
                                        

                # -- create RearHub & CrankArm (position CrankArm on top at the end of procedure
            create_RearHub
            create_CrankArm
            
                # -- ChainStay Area      
            create_ClearArea

                # -- create DropOuts
            create_DropOut
            
                # -- create Tyre
            create_Tyre
            

               # -- create Bottom Bracket - Outer Shell
            set retValues [get_BottomBracket]
            set  BB_OutSide [lindex $retValues 0]
            set  BB_InSide  [lindex $retValues 1]
            $cv_Name create rectangle   $BB_OutSide   -outline blue     -fill $rattleCAD::view::colorSet(chainStay_1)  -width 1.0  -tags __Lug__
                                                                     #  -fill lightgray 

                # -- ChainStay Type
            switch [rattleCAD::model::get_Config ChainStay] {
                   {straight}   -
                   {bent}       -
                   {off}        {}
                   default      { puts "\n  <W> ... not defined in createRearMockup: [rattleCAD::model::get_Config ChainStay]\n"
                                  # return
                                }
            }
            
                # -- format Values
            proc format_XspaceY {xyList} {
                set spaceList {}
                foreach {xy} $xyList {
                    foreach {x y} [split $xy ,] break
                    lappend spaceList $x $y
                }
                return $spaceList
            }
            
            
            
                # -- ChainStay
            switch [rattleCAD::model::get_Config ChainStay] {
                   {straight}   -
                   {bent}     { set ChainStay(start)           [rattleCAD::model::get_Position ChainStay_RearMockup]
                                set ChainStay(polygon)         [rattleCAD::model::get_Polygon  ChainStay_RearMockup {0 0}]
                                set ChainStay(ctrLines)        [format_XspaceY [rattleCAD::model::get_CenterLine RearMockup_CtrLines]]
                                set ChainStay(centerLine)      [format_XspaceY [rattleCAD::model::get_CenterLine RearMockup]]
                                set ChainStay(centerLineUnCut) [format_XspaceY [rattleCAD::model::get_CenterLine RearMockup_UnCut]]
                                    # 
                                set ChainStay(centerLine)      [vectormath::addVectorPointList $ChainStay(start) $ChainStay(centerLine)]
                                set ChainStay(centerLineUnCut) [vectormath::addVectorPointList $ChainStay(start) $ChainStay(centerLineUnCut)]
                                set ChainStay(polygon)         [vectormath::addVectorPointList $ChainStay(start) $ChainStay(polygon)]
                                  # 

                                #
                                #
                                # puts "\n<I>     ... \$ChainStay(start) $ChainStay(start)\n"  
                                
                                  # puts "\n --> \$ChainStay(ctrLines) $ChainStay(ctrLines)"
                                set tube_CS_left    [ $cv_Name create polygon  $ChainStay(polygon)        -fill $rattleCAD::view::colorSet(chainStay) \
                                                                                                          -outline black  -tags __Tube__ ]
                                set tube_CS_CLine   [ $cv_Name create line     $ChainStay(centerLine)  -fill $rattleCAD::view::colorSet(chainStay_CL) \
                                                                                                          -tags __CenterLine__ ]
                                    set polygon_opposite {}
                                    foreach {x y}  $ChainStay(polygon) {
                                            lappend polygon_opposite $x [expr -1.0 * $y]
                                    }  
                                set tube_CS_right   [ $cv_Name create polygon     $polygon_opposite       -fill $rattleCAD::view::colorSet(chainStay) \
                                                                                                          -outline black  -tags {__Tube__} ]
                                  
                                rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $tube_CS_CLine      option_ChainStay
                                rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $tube_CS_left       option_ChainStay
                                rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $tube_CS_right      option_ChainStay
                                    #
                              }
                   default    { 
                                set ChainStay(polygon)      {} 
                                set ChainStay(centerLine)   {}
                              }
            }

               
               
               # -- finisch Bottom Bracket  - Inner Shell
            $cv_Name create rectangle   $BB_InSide   -outline $rattleCAD::view::colorSet(frameTube_OL) \
                                                     -fill $rattleCAD::view::colorSet(chainStay_2) \
                                                     -width 1.0  -tags __Lug__

               
               
               # -- create BrakeDisc
            set brakeDisc [create_BrakeDisc]
            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $brakeDisc       group_RearDiscBrake



               # -- create control Curves
            create_ControlCurves    



               # -- create tubeProfile Edit
               # -- create centerLine Edit    
            switch -exact [rattleCAD::model::get_Config ChainStay] {
                   {bent} { create_centerLine_Edit   $ChainStay(ctrLines) {0 85}
                            create_tubeProfile_Edit  {0 140}
                          }
                   default {create_tubeProfile_Edit  {0  90}
                          }
            }
   
                # -- centerlines
            $cv_Name create centerline     [ appUtil::flatten_nestedList $Center(CL_BB_01)         $Center(CL_BB_02) ] \
                                                                            -fill gray50       -width 0.25     -tags __CenterLine__
            $cv_Name create centerline     [ appUtil::flatten_nestedList $Center(CL_RearHub_01)    $Center(CL_RearHub_02) ] \
                                                                            -fill gray50       -width 0.25     -tags __CenterLine__         
            $cv_Name create centerline     [ appUtil::flatten_nestedList $Center(BottomBracket) $Center(RearHub)] \
                                                                            -fill gray50       -width 0.25     -tags __CenterLine__
           

                # -- mark positions of dimensions
            $cv_Name create circle      $ChainStay(96)          -radius 2   -outline red         -width 1.0        -tags __CenterLine__
            $cv_Name create circle      $ChainStay(95)          -radius 2   -outline red         -width 1.0        -tags __CenterLine__
            $cv_Name create circle      $ChainStay(93)          -radius 2   -outline red         -width 1.0        -tags __CenterLine__
            $cv_Name create circle      $Center(Dim_RearHub_01) -radius 2   -outline red         -width 1.0        -tags __CenterLine__
            $cv_Name create circle      $Center(Dim_RearHub_02) -radius 2   -outline red         -width 1.0        -tags __CenterLine__
            $cv_Name create circle      $Center(ChainLine)      -radius 1   -outline red         -width 1.0        -tags __CenterLine__
            
            $cv_Name create circle      $Center(BottomBracket)  -radius 3   -outline red         -width 1.0        -tags __CenterLine__
            $cv_Name create circle      $Center(RearHub)        -radius 3   -outline blue        -width 1.0        -tags __CenterLine__

                # -- dimensions
                #

                # -- Wheel radius
            set _dim_Wh_Radius          [ $cv_Name dimension  length      [ appUtil::flatten_nestedList   $Center(Dim_WheelRadius) $Center(CL_RearHub_01) ] \
                                                                    horizontal      [expr   45 * $stageScale]   [expr -80 * $stageScale]  \
                                                                    gray50 ]
            set _dim_Rim_Radius         [ $cv_Name dimension  length      [ appUtil::flatten_nestedList   $Center(Rim) $Center(CL_RearHub_01) ] \
                                                                    horizontal      [expr   35 * $stageScale]   [expr   0 * $stageScale]  \
                                                                    gray50 ]
            set _dim_Tyre_Height        [ $cv_Name dimension  length      [ appUtil::flatten_nestedList   $Center(Dim_WheelRadius) $Center(Rim) ] \
                                                                    horizontal      [expr   35 * $stageScale]   [expr   0 * $stageScale]  \
                                                                    gray50 ]                                                                                                              
            set _dim_Sprocket_CL        [ $cv_Name dimension  length      [ appUtil::flatten_nestedList   $Center(Dim_RearHub_02) $Center(SprocketClearance) ] \
                                                                    horizontal      [expr  -25 * $stageScale]   [expr  -5 * $stageScale]  \
                                                                    gray50 ]
            set _dim_Tyre_CL            [ $cv_Name dimension  length      [ appUtil::flatten_nestedList   $Center(Tyre) $Center(TyreClearance) ] \
                                                                    vertical        [expr   65 * $stageScale]   [expr  20 * $stageScale]  \
                                                                    gray50 ]
            set _dim_Tyre_CapHeight     [ $cv_Name dimension  length      [ appUtil::flatten_nestedList   $Center(Dim_WheelRadius) $Center(TyreWidth) ] \
                                                                    horizontal      [expr   25 * $stageScale]   [expr  20 * $stageScale]  \
                                                                    $Colour(result) ]                                                                                                              
            set _dim_Tyre_Width         [ $cv_Name dimension  length      [ appUtil::flatten_nestedList   $Center(Dim_Tyre_01) $Center(Dim_Tyre_02) ] \
                                                                    vertical        [expr   35 * $stageScale]   [expr   3 * $stageScale]  \
                                                                    $Colour(primary) ]  
            set _dim_Tyre_Radius        [ $cv_Name dimension  length      [ appUtil::flatten_nestedList   $Center(TyreWidth) $Center(CL_RearHub_01) ] \
                                                                    horizontal      [expr   25 * $stageScale]   [expr  50 * $stageScale]  \
                                                                    $Colour(primary) ]   
                    
            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_Tyre_CapHeight    single_Result_RearWheelTyreShoulder
            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_Tyre_Width        single_RearWheel_TyreWidth
            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_Tyre_Radius       single_RearWheel_TyreWidthRadius
                   
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              

                # -- ChainStay length
            set _dim_CS_Length             [ $cv_Name dimension  length      [ appUtil::flatten_nestedList   $Center(CL_RearHub_01) $Center(CL_BB_01) ] \
                                                                    horizontal        [expr  40 * $stageScale]   [expr 0 * $stageScale]  \
                                                                    $Colour(result) ] 
                    
            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_CS_Length         single_RearWheel_Distance
                    

                    
                # -- BottomBracket
            set _dim_BB_Diam_inside     [ $cv_Name dimension  length      [ appUtil::flatten_nestedList   $Center(Dim_BBDiam_01) $Center(Dim_BBDiam_02) ] \
                                                                    horizontal        [expr  20 * $stageScale]    [expr  35 * $stageScale]  \
                                                                    $Colour(primary) ] 
            set _dim_BB_Diam_outside    [ $cv_Name dimension  length      [ appUtil::flatten_nestedList   $Center(Dim_BBWidth_02) $Center(Dim_BBDiameter) ] \
                                                                    horizontal        [expr  35 * $stageScale]    [expr  35 * $stageScale]  \
                                                                    $Colour(primary) ] 
            set _dim_BB_Width           [ $cv_Name dimension  length      [ appUtil::flatten_nestedList   $Center(Dim_BBWidth_01) $Center(Dim_BBWidth_02) ] \
                                                                    vertical          [expr  35 * $stageScale]    [expr -10 * $stageScale]  \
                                                                    $Colour(primary) ] 
            set _dim_CS_BB_Offset       [ $cv_Name dimension  length      [ appUtil::flatten_nestedList   $ChainStay(93) $ChainStay(94) ] \
                                                                    vertical          [expr -60 * $stageScale]    [expr  15 * $stageScale]  \
                                                                    $Colour(primary) ] 
                    
            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_BB_Diam_inside    single_BottomBracket_InsideDiameter       
            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_BB_Diam_outside   single_BottomBracket_OutsideDiameter   
            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_BB_Width          single_BottomBracket_Width  
            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_CS_BB_Offset      single_BottomBracket_CS_Offset_TopView   
                    

                    
                # -- BrakeDisc
            set _dim_BrakeDisc_Dist_Hub [ $cv_Name dimension  length      [ appUtil::flatten_nestedList   $Center(p_brakeDisc_03) $Center(Dim_RearHub_01) ] \
                                                                    vertical        [expr   2 * $stageScale]    [expr  20 * $stageScale]  \
                                                                    $Colour(primary) ] 
            set _dim_BrakeDisc_Dist_DO  [ $cv_Name dimension  length      [ appUtil::flatten_nestedList   $Center(p_brakeDisc_01) $Center(Dim_RearHub_01) ] \
                                                                    vertical        [expr  15 * $stageScale]    [expr -20 * $stageScale]  \
                                                                    $Colour(result) ] 
            set _dim_BrakeDisc_Diameter [ $cv_Name dimension  length      [ appUtil::flatten_nestedList   $Center(CL_RearHub_02)  $Center(p_brakeDisc_01) ] \
                                                                    horizontal      [expr -10 * $stageScale]    0 \
                                                                    $Colour(primary) ] 
            
            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_BrakeDisc_Dist_Hub    single_RearHub_DiscOffset      
            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_BrakeDisc_Diameter    single_RearHub_DiscDiameter      



                # -- RearHub
            set _dim_Hub_Width          [ $cv_Name dimension  length      [ appUtil::flatten_nestedList   $Center(Dim_RearHub_01) $Center(Dim_RearHub_02) ] \
                                                                    vertical        [expr  40 * $stageScale]    [expr -10 * $stageScale]  \
                                                                    $Colour(primary) ] 
            set _dim_CS_DO_Distance     [ $cv_Name dimension  length      [ appUtil::flatten_nestedList   $Center(CL_RearHub_01) $ChainStay(95) ] \
                                                                    horizontal      [expr  25 * $stageScale]    0  \
                                                                    $Colour(primary) ] 
            set _dim_CS_DO_Offset       [ $cv_Name dimension  length      [ appUtil::flatten_nestedList   $ChainStay(92) $ChainStay(95) ] \
                                                                    vertical        [expr -45 * $stageScale]    [expr -30 * $stageScale]  \
                                                                    $Colour(primary) ] 
                    
            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_Hub_Width         single_RearHub_Width      
            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_CS_DO_Distance    single_RearDropOut_CS_Offset    
            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_CS_DO_Offset      single_RearDropOut_CS_OffsetTopView       


            
                # -- CrankSet
            set _dim_Crank_Length       [ $cv_Name dimension  length      [ appUtil::flatten_nestedList   $Center(Q_Factor) $Center(CL_BB_01) ] \
                                                                    horizontal        [expr   20 * $stageScale]    [expr -30 * $stageScale]  \
                                                                    $Colour(primary) ]
            set _dim_PedalEye           [ $cv_Name dimension  length      [ appUtil::flatten_nestedList   $Center(PedalEye) $Center(Q_Factor) ] \
                                                                    horizontal        [expr   20 * $stageScale]    [expr  20 * $stageScale]  \
                                                                    $Colour(primary) ]
            set _dim_Crank_Q_Factor     [ $cv_Name dimension  length      [ appUtil::flatten_nestedList   $Center(Dim_Q_Factor) $Center(PedalEye) ] \
                                                                    vertical        [expr   45 * $stageScale]    [expr  15 * $stageScale]  \
                                                                    $Colour(primary) ]
            set _dim_CrankArmWidth      [ $cv_Name dimension  length      [ appUtil::flatten_nestedList   $Center(CrankArm) $Center(PedalEye) ] \
                                                                    vertical        [expr   20 * $stageScale]    [expr -20 * $stageScale]  \
                                                                    $Colour(primary) ]
                                                                    
            set _dim_ChainLine          [ $cv_Name dimension  length      [ appUtil::flatten_nestedList   $Center(BottomBracket) $Center(ChainLine) ] \
                                                                    vertical        [expr  -90 * $stageScale]    [expr  0 * $stageScale]  \
                                                                    $Colour(primary) ]
                                                                    
                # -- create chainring offset dimension 
            if {[llength $Center(list_ChainRing)] > 1} {
                set pos_0 [lindex $Center(list_ChainRing) end-1]
                set pos_1 [lindex $Center(list_ChainRing) end]
                set _dim_ChainRingOffset [ $cv_Name dimension length      [ appUtil::flatten_nestedList   $pos_0 $pos_1 ] \
                                                                    vertical        [expr -100 * $stageScale]    [expr 10 * $stageScale]  \
                                                                    $Colour(primary) ]
                rattleCAD::view::gui::dimension_CursorBinding  $cv_Name $_dim_ChainRingOffset  single_CrankSet_ChainRingOffset       
            }

            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_Crank_Length      single_CrankSet_Length        
            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_PedalEye          single_CrankSet_PedalEye    
            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_Crank_Q_Factor    single_CrankSet_QFactor        
            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_CrankArmWidth     single_CrankSet_ArmWidth    
            rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $_dim_ChainLine         single_CrankSet_ChainLine


            if {$ChainStay(centerLine) != {}} {
                    #
                set pt_end  [lrange $ChainStay(centerLine) end-1 end]
                set pt_prev [lrange $ChainStay(centerLine) end-3 end-2]
                    #
                set pt_cnt  [vectormath::intersectPoint $pt_prev $pt_end {0 0} {0 1}]
                    #
                set pt_rf   [vectormath::addVector $pt_cnt {0 1}]
                    #
                puts "  ... \$pt_end    $pt_end"
                puts "  ... \$pt_prev   $pt_prev"
                puts "  ... \$pt_rf     $pt_rf"
                    #
                set _dim_CS_Angle           [ $cv_Name dimension  angle     [ appUtil::flatten_nestedList  $pt_cnt $pt_rf $pt_end] \
                                                                    [expr  35 * $stageScale]   -10  \
                                                                    $Colour(result) ]
                    #
                $cv_Name create circle      $pt_cnt  -radius 1   -outline $Colour(result)   -width 1.0  -tags __CenterLine__
                    #
            }

                # -- create CrankArm
            $cv_Name raise {__CrankArm__}
                #
                
                #
            return           
                #
    }

    proc rattleCAD::cv_custom::___create_ChainStay______tbd {} {            
                # -- ChainStay
            switch [rattleCAD::model::get_Config ChainStay] {
                   {straight}   -
                   {bent}     { set ChainStay(start)           [rattleCAD::model::get_Position ChainStay_RearMockup]
                                set ChainStay(polygon)         [rattleCAD::model::get_Polygon  ChainStay_RearMockup {0 0}]
                                set ChainStay(ctrLines)        [format_XspaceY [rattleCAD::model::get_CenterLine RearMockup_CtrLines]]
                                set ChainStay(centerLine)      [format_XspaceY [rattleCAD::model::get_CenterLine RearMockup]]
                                set ChainStay(centerLineUnCut) [format_XspaceY [rattleCAD::model::get_CenterLine RearMockup_UnCut]]
                                    # 
                                set ChainStay(centerLine)      [vectormath::addVectorPointList $ChainStay(start) $ChainStay(centerLine)]
                                set ChainStay(centerLineUnCut) [vectormath::addVectorPointList $ChainStay(start) $ChainStay(centerLineUnCut)]
                                set ChainStay(polygon)         [vectormath::addVectorPointList $ChainStay(start) $ChainStay(polygon)]
                                  #    
                                
                                puts "\n<D>   -> \$profile_xcl $profile_xcl \n"
                                puts "\n<D>   -> \$profile_xcl $profile_xcl \n"

                                
                                  # puts "\n --> \$ChainStay(ctrLines) $ChainStay(ctrLines)"
                                set tube_CS_left    [ $cv_Name create polygon  $ChainStay(polygon)        -fill $rattleCAD::view::colorSet(chainStay) \
                                                                                                          -outline black  -tags __Tube__ ]
                                set tube_CS_CLine   [ $cv_Name create line     $ChainStay(centerLine)  -fill $rattleCAD::view::colorSet(chainStay_CL) \
                                                                                                          -tags __CenterLine__ ]
                                    set polygon_opposite {}
                                    foreach {x y}  $ChainStay(polygon) {
                                            lappend polygon_opposite $x [expr -1.0 * $y]
                                    }  
                                set tube_CS_right   [ $cv_Name create polygon     $polygon_opposite       -fill $rattleCAD::view::colorSet(chainStay) \
                                                                                                          -outline black  -tags {__Tube__} ]
                                  
                                rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $tube_CS_CLine      option_ChainStay
                                rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $tube_CS_left       option_ChainStay
                                rattleCAD::view::gui::dimension_CursorBinding   $cv_Name    $tube_CS_right      option_ChainStay
                                    #
                              }
                   default    { 
                                set ChainStay(polygon)      {} 
                                set ChainStay(centerLine)   {}
                              }
            }
    
    }

    proc rattleCAD::cv_custom::create_Tyre {} {
            upvar  1 cv_Name        ext_cvName              
            upvar  1 Length         ext_Length
            upvar  1 Center         ext_Center
            upvar  1 ClearCassette  ext_ClearCassette
    
            # -- tyre Representation 
            set tyre_RadiusHeight $ext_Length(06)
            set tyre_RadiusWidth  [expr 0.5 * [rattleCAD::model::get_Scalar RearWheel TyreWidth]]
            set tyre_00    [vectormath::addVector $ext_Center(TyreWidth) [list $tyre_RadiusHeight [expr -1.0*$tyre_RadiusWidth] ]]
            set tyre_01    [vectormath::addVector $ext_Center(TyreWidth) [list [expr -1.0*$tyre_RadiusHeight] $tyre_RadiusWidth ]]
            set ovalMatrix   [appUtil::flatten_nestedList  $tyre_00 $tyre_01 ]                     
            
            set pt_01      [vectormath::addVector  $ext_Center(TyreWidth)  {-10 0}]
            set pt_02      [vectormath::addVector  $ext_Center(Rim)        {-8  0}]
            set tyre_03    [vectormath::addVector  $ext_Center(TyreWidth)   {0 -1} $tyre_RadiusWidth]
            set tyre_04    [vectormath::addVector  $pt_01                   {0 -1} $tyre_RadiusWidth]
            set tyre_05    [vectormath::addVector  $pt_02                   {0 -1} 9]
            set tyre_06    [vectormath::addVector  $pt_02                   {0  1} 9]
            set tyre_07    [vectormath::addVector  $pt_01                   {0  1} $tyre_RadiusWidth]
            set tyre_08    [vectormath::addVector  $ext_Center(TyreWidth)   {0  1} $tyre_RadiusWidth]
            set polygonMatrix  [appUtil::flatten_nestedList  $tyre_03 $tyre_04  $tyre_05 $tyre_06 $tyre_07 $tyre_08 ]
            
            set tyre_04    [vectormath::addVector  $ext_Center(TyreWidth)   {0 -1} $tyre_RadiusWidth]
            set tyre_05    [vectormath::addVector  $ext_Center(RearHub)     [list 30 [expr -1.0 * $tyre_RadiusWidth] ] ]
            set tyre_06    [vectormath::addVector  $ext_Center(RearHub)     {1 0}  35 ]
            set tyre_07    [vectormath::addVector  $ext_Center(RearHub)     [list -35 $tyre_RadiusWidth] ]
            set tyre_08    [vectormath::addVector  $ext_Center(TyreWidth)   {0 1} $tyre_RadiusWidth]
            set polygonMatrix  [appUtil::flatten_nestedList  $tyre_04  $tyre_05 $tyre_06 $tyre_07 $tyre_08 ]
            
            
                           $ext_cvName create oval      $ovalMatrix      -fill gray     -width 1.0  -tags {__Component__}
            set _tyreObj [ $ext_cvName create polygon   $polygonMatrix   -fill gray     -width 1.0  -tags {__Component__}]
            
                           $ext_cvName create ovalarc   $ovalMatrix      -outline black -width 1.0  -tags {__Component__} \
                                                                         -start 270     -extent 180       -style arc
                           $ext_cvName create line      $polygonMatrix   -fill black    -width 1.0  -tags {__Component__}
            
            rattleCAD::view::gui::dimension_CursorBinding   $ext_cvName     $_tyreObj   group_RearTyre_Parameter
            # rattleCAD::view::gui::object_CursorBinding     $ext_cvName    $_tyreObj
            # $ext_cvName bind    $_tyreObj       <Double-ButtonPress-1>  [list rattleCAD::view::createEdit  %x %y  $ext_cvName   { Component(Wheel/Rear/TyreWidthRadius) Component(Wheel/Rear/TyreWidth) Rendering(RearMockup/TyreClearance)}    {Rear Tyre Parameter}]
                                                                                                                                                                                                                                                        
    }    

    proc rattleCAD::cv_custom::create_RearHub {} {   
            upvar  1 cv_Name        ext_cvName              
            upvar  1 Length         ext_Length
            upvar  1 Center         ext_Center
            upvar  1 ClearCassette  ext_ClearCassette
            
                set length03                [ expr 0.5 *  18]
                set pointList               [ vectormath::addVectorPointList $ext_Center(RearHub) [list [expr -1*$length03] [expr -1*$ext_Length(04)] $length03 $ext_Length(04)] ]
            set hubRep          [ $ext_cvName create rectangle   $pointList            -outline $rattleCAD::view::colorSet(frameTube_OL) \
                                                                                       -width 1.0    -tags __CenterLine__ ]
                     
            
               # -- rear hub representation
            set RearHub(file)   [ rattleCAD::rendering::checkFileString {etc:hub/rattleCAD_rear.svg} ]
            set RearHub(object) [ $ext_cvName readSVG $RearHub(file) $ext_Center(RearHub)  0  __HubRear__ ]
                                  $ext_cvName addtag  __Decoration__ withtag $RearHub(object)
            
            
                # -- create first Sprocket of Cassete
            set sp_position     [ vectormath::addVector  $ext_Center(RearHub) {0 1} [ expr -1 * ($ext_Length(04) - 3) ] ]
            set sp_object       [ get_ChainWheel [rattleCAD::model::get_Scalar RearWheel FirstSprocket] 2 $sp_position ]
            set sp_polygon      [ lindex $sp_object 1 ]
            set sp_clearance    [ lindex $sp_object 2 ]
            set sprocketRep     [ $ext_cvName create polygon     $sp_polygon     -fill gray -outline black  -tags __Component__ ]
            
            set ext_ClearCassette(1)    $sp_clearance
            
            rattleCAD::view::gui::dimension_CursorBinding   $ext_cvName $hubRep         group_RearHub_Parameter
            # rattleCAD::view::gui::object_CursorBinding    $ext_cvName $hubRep
            # $ext_cvName bind    $hubRep         <Double-ButtonPress-1>  [list rattleCAD::view::createEdit  %x %y  $ext_cvName   { Component(Wheel/Rear/HubWidth)    text://Component(Wheel/Rear/FirstSprocket) }    {RearHub: }]                                                       
            
            rattleCAD::view::gui::dimension_CursorBinding   $ext_cvName $sprocketRep    single_RearHub_FirstSprocket
            # rattleCAD::view::gui::object_CursorBinding    $ext_cvName $sprocketRep
            # $ext_cvName bind    $sprocketRep    <Double-ButtonPress-1>  [list rattleCAD::view::createEdit  %x %y  $ext_cvName   { text://Component(Wheel/Rear/FirstSprocket) }  {RearHub: first Sprocket}]                                                       
            
            return
    }

    proc rattleCAD::cv_custom::create_DropOut {} {   
            upvar  1 cv_Name    ext_cvName              
            upvar  1 Length     ext_Length
            upvar  1 Center     ext_Center
			
			set offset_DropOut  [rattleCAD::model::get_Scalar  RearDropout OffsetCS]
            
                set x1                  [ expr [lindex $ext_Center(RearHub) 0] -10 ]
                set x2                  [ expr [lindex $ext_Center(RearHub) 0] +10 ]
                set y1                  $ext_Length(04)
                set y2                  [ expr $ext_Length(04) + 6 ]
                
                set pointList           [ list $x1 $y1 $x2 $y2 ]
            $ext_cvName create rectangle   $pointList            -outline $rattleCAD::view::colorSet(frameTube_OL) \
                                                                 -fill $rattleCAD::view::colorSet(chainStay_1)  \
                                                                 -width 1.0  -tags __Lug__
                set pointList           [ list $x1 [expr -1*$y1] $x2 [expr -1*$y2] ]
            $ext_cvName create rectangle   $pointList            -outline $rattleCAD::view::colorSet(frameTube_OL) \
                                                                 -fill $rattleCAD::view::colorSet(chainStay_1) \
                                                                 -width 1.0  -tags __Lug__
            
                set x1                  [ expr [lindex $ext_Center(RearHub) 0] -14 ]
                set x2                  [ expr [lindex $ext_Center(RearHub) 0] + $offset_DropOut + 10 ]
                set y1                  [ expr $ext_Length(04) + 1 ]
                set y2                  [ expr $ext_Length(04) + 5 ]
                set pointList           [ list $x1 $y1 $x2 $y2 ]
            $ext_cvName create rectangle   $pointList            -outline $rattleCAD::view::colorSet(frameTube_OL) \
                                                                 -fill $rattleCAD::view::colorSet(chainStay) \
                                                                 -width 1.0  -tags __Lug__
                set pointList           [ list $x1 [expr -1*$y1] $x2 [expr -1*$y2] ]
            $ext_cvName create rectangle   $pointList            -outline $rattleCAD::view::colorSet(frameTube_OL) \
                                                                 -fill $rattleCAD::view::colorSet(chainStay) \
                                                                 -width 1.0  -tags __Lug__
    }

    proc rattleCAD::cv_custom::create_BrakeDisc {} {
          upvar  1 cv_Name    ext_cvName              
          upvar  1 Length     ext_Length
          upvar  1 Center     ext_Center
          upvar  1 ChainStay  ext_ChainStay
            # puts "  -> create_BrakeDisc: \$ext_Length"
            # parray  ext_Length
            # puts "  -> create_BrakeDisc: \$ext_Center"
            # parray ext_Center
            # puts "  -> create_BrakeDisc: \$ext_ChainStay"
            # parray ext_ChainStay
          
          set pos_00 [list [expr -1 * $ext_Length(ChainStay)] $ext_Length(04)]
            # puts "  \$pos_00     $pos_00"
          
          set disc_Offset         [rattleCAD::model::get_Scalar RearMockup DiscOffset]
          set disc_Width          [rattleCAD::model::get_Scalar RearMockup DiscWidth]
          set disc_DiameterDisc   [rattleCAD::model::get_Scalar RearMockup DiscDiameter]
          set clearanceRadius     [rattleCAD::model::get_Scalar RearMockup DiscClearance]
          
          set pos_02  [vectormath::rotateLine $pos_00 $disc_Offset -90]
          set pos_01  [vectormath::rotateLine $pos_02 $disc_Width   90]
            # $ext_cvName create circle      $pos_00       -radius 2  -outline red         -width 1.0        -tags __CenterLine__
            # $ext_cvName create circle      $pos_01       -radius 2  -outline red         -width 1.0        -tags __CenterLine__
          
          set p_00    [vectormath::addVector $pos_01 {-37 0}]
          set p_01    [vectormath::addVector $pos_01 [list [expr 0.5 * $disc_DiameterDisc] 0]]
          set vct_00  [vectormath::parallel   $p_00 $p_01 $disc_Width]
          foreach {p_03 p_02}  $vct_00 break
          set pointList [list $p_00 $p_02]
          set p_04    [vectormath::addVector  $p_03 {7 0}]
          set p_05    [vectormath::addVector  $p_04 {0 0.7}]
          
            # puts "    \$pointList: $pointList"
          set pointList [appUtil::flatten_nestedList $p_00 $p_01 $p_02 $p_04 $p_05]
            
            # -- draw brake disc
          set object [$ext_cvName create polygon   $pointList -outline black     -fill gray  -width 1.0  -tags __Component__]
          #set object [$ext_cvName create rectangle   $pointList -outline black     -fill gray  -width 1.0  -tags __Component__]
            # -- draw clearance arc
          $ext_cvName create arc         $p_01      -radius $clearanceRadius -start 310  -extent 190 -style arc -outline red  -tags __CenterLine__

          set ext_Center(p_brakeDisc_01)  $p_01
          set ext_Center(p_brakeDisc_02)  $p_02
          set ext_Center(p_brakeDisc_03)  $p_04

          return $object
    }

    proc rattleCAD::cv_custom::create_CrankArm {} {
                #
            variable BottomBracket    
                #
            
            upvar  1 cv_Name            ext_cvName
            upvar  1 stageScale         ext_stageScale
            
            upvar  1 Length             ext_Length
            upvar  1 Center             ext_Center
            upvar  1 ChainStay          ext_ChainStay
            upvar  1 ClearChainWheel    ext_ClearChainWheel
            
            
                # -- help points
            set pt_00       [ list [expr -1.0 * $ext_Length(CrankSet)] [expr -1.0 * $ext_Length(PedalMount) + $ext_Length(CrankSet_ArmWidth) + 10] ]
            set pt_02       [ list [expr -1.0 * $ext_Length(CrankSet)] [expr -1.0 * $ext_Length(PedalMount)] ]
            set pt_01       [ list [expr -1.0 * $ext_Length(CrankSet)] [expr -1.0 * $ext_Length(PedalMount) + $ext_Length(CrankSet_ArmWidth)] ]
            set pt_03       [ list [expr -1.0 * $ext_Length(CrankSet)] [expr -1.0 * ($ext_Length(PedalMount) + 10)] ]
            
                # -- polygon points: pedal mount
            set pt_10       [ vectormath::addVector $pt_01 { 30.0 0} ]
            set pt_11       [ vectormath::addVector $pt_01 [list [expr -1.0 * $ext_Length(PedalEye)] 0] ]
            set pt_12       [ vectormath::addVector $pt_02 [list [expr -1.0 * $ext_Length(PedalEye)] 0] ]
            set pt_13       [ vectormath::addVector $pt_02 { 40.0 0} ]
            
                # -- polygon points: BottomBracket mount
            set pt_25       [ list -35 [expr -1.0 * ($ext_Length(02) + 15) ] ]
            set pt_24       [ list -19 [expr -1.0 * ($ext_Length(02) + 10) ] ]
            set pt_23       [ list -20 [expr -1.0 * ($ext_Length(02) +  5) ] ]
            set pt_22       [ list  20 [expr -1.0 * ($ext_Length(02) +  5) ] ]
            set pt_21       [ list  18 [expr -1.0 * ($ext_Length(02) + 30) ] ]
            set pt_20       [ list -30 [expr -1.0 * ($ext_Length(02) + 30) ] ]
            
                        # $ext_cvName create circle      $pt_00            -radius 2  -outline gray50     -width 1.0            -tags __CenterLine__   
            
                # -- create canvas Object
            set polygon         [ appUtil::flatten_nestedList   $pt_10  $pt_11  $pt_12  $pt_13 \
                                                                $pt_20  $pt_21  $pt_22  $pt_23  $pt_24  $pt_25] 
            puts $polygon

            set polygon         [ rattleCAD::model::get_Polygon CrankArm_xy  {0 0}]            
            #set polygon         [ rattleCAD::model::get_Polygon CrankArm_xy  $BottomBracket(Position)]            
            
            puts $polygon
                                                    
            
            set componentCrank  [ $ext_cvName create polygon         $polygon    -fill gray -outline black  -tags  {__Component__ __CrankArm__}]
            
            
            rattleCAD::view::gui::dimension_CursorBinding   $ext_cvName $componentCrank     group_Crankset_Parameter
            # rattleCAD::view::gui::object_CursorBinding    $ext_cvName $componentCrank
            # $ext_cvName bind    $componentCrank <Double-ButtonPress-1>  [list rattleCAD::view::createEdit  %x %y  $ext_cvName   { Component(CrankSet/ChainLine) Component(CrankSet/Q-Factor)    text://Component(CrankSet/ChainRings) } {Crankset:  Parameter}]
                                                
                # -- centerline of pedal axis
            $ext_cvName create centerline     [ appUtil::flatten_nestedList $pt_00 $pt_03 ] \
                                                                             -fill gray50       -width 0.25     -tags {__CenterLine__ __CrankArm__}


                # -- global points
            set ext_Center(Dim_Q_Factor)    [ list [expr -1.0 * $ext_Length(CrankSet)] 0 ]
            set ext_Center(Q_Factor)        $pt_02 
            set ext_Center(CrankArm)        $pt_11 
            set ext_Center(PedalEye)        $pt_12 
            set ext_Center(ChainLine)       [ list 0 [expr -1.0 * $ext_Length(ChainLine) ] ]
            set ext_Center(list_ChainRing)  {}


                # -- create chainwheels
            set chainLine           [rattleCAD::model::get_Scalar CrankSet ChainLine]
            set chainWheelDistance  [rattleCAD::model::get_Scalar CrankSet ChainRingOffset]
            #set chainWheelDistance  5
            set chainWheelWidth     2
            set list_ChainRings     [lsort [split [rattleCAD::model::get_ListValue CrankSetChainRings] -]]
                # puts "  <D> create_CrankArm: [llength $list_ChainRings]"
            
            switch [llength $list_ChainRings] {
                3   {   set chainWheelPos   [list 0 [expr -1 * ($chainLine -       $chainWheelDistance)]] }
                2   {   set chainWheelPos   [list 0 [expr -1 * ($chainLine - 0.5 * $chainWheelDistance)]] }
                1   {   set chainWheelPos   [list 0 [expr -1 * $chainLine]] }
                default {
                        set chainWheelPos   [list 0 [expr -1 * $chainLine]]
                        set list_ChainRings {}
                        tk_messageBox -message "max ChainWheel amount: 3\n      given Arguments: $list_ChainRings"
                    }
            }
            
            set cw_Clearance    {}
            set cw_index        0
            foreach teethCount $list_ChainRings {
                    set cw_object       [ get_ChainWheel $teethCount  $chainWheelWidth  $chainWheelPos ]
                    set cw_clearance    [ lindex $cw_object 0 ]
                    set cw_polygon      [ lindex $cw_object 1 ]
                    $ext_cvName create polygon     $cw_polygon     -fill gray -outline black  -tags {__Component__ __CrankArm__} 
                        #
                    lappend ext_Center(list_ChainRing) $chainWheelPos
                        # -- position of next chainwheel
                    set chainWheelPos   [ vectormath::addVector $chainWheelPos {0 -1} $chainWheelDistance ]
                        
                        # -- add position to ext_ClearChainWheel
                    incr cw_index
                    set ext_ClearChainWheel($cw_index)    $cw_clearance
            }
           
            return
    }

    proc rattleCAD::cv_custom::create_ClearArea {} {
            upvar  1 cv_Name    ext_cvName
            upvar  1 stageScale ext_stageScale
            
            upvar  1 Length             ext_Length
            upvar  1 Center             ext_Center
            upvar  1 ChainStay          ext_ChainStay
            upvar  1 ClearChainWheel    ext_ClearChainWheel
            upvar  1 ClearCassette      ext_ClearCassette

                # -- define ClearArea Polygon
                #
            set polygon     {}
                
                # -- Tyre clearance
                    set tyreHeight  $ext_Length(06)
                    set clearRadius [ expr  $tyreHeight + [rattleCAD::model::get_Scalar RearMockup TyreClearance] ]
                    set clearWidth  [ expr  0.5 * [rattleCAD::model::get_Scalar RearWheel TyreWidth]  + [rattleCAD::model::get_Scalar RearMockup TyreClearance] ]
                    set pt_99       [ vectormath::addVector  $ext_Center(TyreWidth)  {0 -1} $clearRadius ]
                    set pt_98       [ vectormath::addVector  $pt_99  {-70 0} ]
            lappend polygon     $pt_98  $pt_99
                    set angle 0
                    while {$angle <= 90} {
                        set pt_tmp  [ vectormath::rotatePoint  $ext_Center(TyreWidth) $pt_99 $angle]
                          # puts "             -> $ext_Center(Tyre)  /  $ext_Center(TyreWidth)"
                          # TyreWidth
                        lappend polygon     $pt_tmp
                        incr angle 10
                    }
                    # --- handling tyreWidth
                    set ratio       [expr $clearWidth / $clearRadius]
                    set newPolygon {}
                    foreach xy $polygon {
                        foreach {x y} $xy break
                        set y [expr $ratio*$y]
                        lappend newPolygon [list $x $y]
                    }
            set polygon $newPolygon
      
               
               
            set ext_Center(TyreClearance)  [ vectormath::addVector  $ext_Center(Tyre)  {0 -1} $clearWidth ]
            
                # -- BB clearance
                    set pt_01       [ list   [lindex $ext_ChainStay(00) 0] 0 ]
            lappend polygon     $pt_01
                    set pt_02       [ vectormath::mirrorPoint {0 0} {1 0} $ext_ChainStay(00) ] 
                        #[ list   [lindex $ext_ChainStay(00) 0] [expr -1 * [lindex $ext_ChainStay(00) 1]] ]     
            lappend polygon     $pt_02
                    
                # -- ChainWheel clearance
                    set name        [ lindex [array names ext_ClearChainWheel] 0 ]        
                    set pt_cw1      $ext_ClearChainWheel($name)
                    set pt_03       [ vectormath::cathetusPoint  $pt_02  $pt_cw1  [rattleCAD::model::get_Scalar RearMockup ChainWheelClearance] opposite ]
            lappend polygon     $pt_03
                    
                # -- # -- second & third ChainWheel
                    set pt_last $pt_cw1
                    foreach name [lrange [array names ext_ClearChainWheel] 1 end] {
                            set pt_tmp  $ext_ClearChainWheel($name)
                            set vct_tmp [ vectormath::parallel $pt_last $pt_tmp [rattleCAD::model::get_Scalar RearMockup ChainWheelClearance] ]
                            lappend polygon     [lindex $vct_tmp 0] [lindex $vct_tmp 1]
                            set pt_last $pt_tmp
                    }
            
                # -- CrankArm clearance
                    set delta       [ expr   [rattleCAD::model::get_Scalar RearMockup CrankClearance] - [rattleCAD::model::get_Scalar RearMockup ChainWheelClearance] ]
                    set pt_ca       [ vectormath::cathetusPoint  $pt_last  $ext_Center(CrankArm)  $delta opposite ]
                    set vct_tmp     [ vectormath::parallel $pt_last $pt_ca  [rattleCAD::model::get_Scalar RearMockup ChainWheelClearance] ]
            lappend polygon     [ lindex $vct_tmp 0 ] [ lindex $vct_tmp 1 ]
                    set clearRadius [rattleCAD::model::get_Scalar RearMockup CrankClearance]
                    set pt_st       [ vectormath::addVector  $ext_Center(CrankArm)  {0 1}  $clearRadius ]
                    set dirAngle    [ expr [vectormath::dirAngle   [lindex $vct_tmp 0] [lindex $vct_tmp 1]] -180 ]
                        # puts "     -> dirAngle $dirAngle"
                    set angle       0
                    while {$angle <= 90} {
                            if {$angle >= $dirAngle} {
                                set pt_tmp  [ vectormath::rotatePoint  $ext_Center(CrankArm) $pt_st $angle]
                                lappend polygon     $pt_tmp
                            }
                            incr angle 10
                    }
                    set pt_04       [ vectormath::addVector [lindex $polygon end] {0 -15} ]
            lappend polygon     $pt_04                  
            
                # -- Casette clearance
                    set pt_sp       [ vectormath::addVector  $ext_ClearCassette(1)  {  1   0}  [rattleCAD::model::get_Scalar RearMockup CassetteClearance] ]
                    
                    set pt_11       [ vectormath::addVector  $pt_sp                 {  0   2} ]
                    set pt_12       [ vectormath::addVector  $pt_11                 { 45  25} ]
                    
                    set pt_08       [ vectormath::addVector  $pt_sp                 {  0  -2} ]
                    set pt_07       [ list [lindex $ext_Center(ChainStay_DO) 0]  [ lindex $pt_08 1] ]
                    # set pt_07     [ vectormath::addVector  $pt_08                 {-20   0} ]
                    set pt_06       [ vectormath::addVector  $pt_07                 {  0 -20} ]
                    set pt_05       [ vectormath::addVector  $pt_06                 { 40   0} ]
            lappend polygon     $pt_05  $pt_06  $pt_07  $pt_08  $pt_11  $pt_12                     
                    set ext_Center(SprocketClearance)        $pt_sp 
            
            
                # -- create chainstay Area
                #
            set             polygon     [ appUtil::flatten_nestedList    $polygon ]
            
            set chainstayArea   [ $ext_cvName create polygon     $polygon     -fill $rattleCAD::view::colorSet(chainStayArea) -outline black  -tags __CenterLine__ ]

            rattleCAD::view::gui::dimension_CursorBinding   $ext_cvName    $chainstayArea   group_ChainStay_Area
            # rattleCAD::view::gui::object_CursorBinding    $ext_cvName $chainstayArea
            # $ext_cvName bind    $chainstayArea  <Double-ButtonPress-1>  [list rattleCAD::view::createEdit  %x %y  $ext_cvName   { list://Rendering(ChainStay@SELECT_ChainStay)  Rendering(RearMockup/TyreClearance) Rendering(RearMockup/ChainWheelClearance)   Rendering(RearMockup/CrankClearance)    Rendering(RearMockup/CassetteClearance) }   {ChainStay:  Area}]                    
            return
    }

    proc rattleCAD::cv_custom::create_ControlCurves {} {
            upvar  1 cv_Name    ext_cvName
            upvar  1 stageScale ext_stageScale
            
            upvar  1 Length             ext_Length
            upvar  1 Center             ext_Center
            upvar  1 ChainStay          ext_ChainStay
            upvar  1 ClearChainWheel    ext_ClearChainWheel
            upvar  1 ClearCassette      ext_ClearCassette

                
                # -- Tyre Clearance
            set radius_y      [expr  0.5 * [rattleCAD::model::get_Scalar RearWheel TyreWidth]  + [rattleCAD::model::get_Scalar RearMockup TyreClearance] ]
            set radius_x      [expr  $ext_Length(06)                                  + [rattleCAD::model::get_Scalar RearMockup TyreClearance] ]
            set tyre_00       [vectormath::addVector $ext_Center(TyreWidth) [list $radius_x [expr -1.0*$radius_y] ]]
            set tyre_01       [vectormath::addVector $ext_Center(TyreWidth) [list [expr -1.0*$radius_x] $radius_y ]]                     
            set clearMatrix   [appUtil::flatten_nestedList  $tyre_00 $tyre_01 ]
            
            $ext_cvName create ovalarc  $clearMatrix       -start 250  -extent 220 -style arc -outline red  -tags __CenterLine__
            
                # -- ChainWheel Clearance
            set radius  [rattleCAD::model::get_Scalar RearMockup ChainWheelClearance]
            foreach name [array names ext_ClearChainWheel] {
                    # puts "   --> $name  $ext_ClearChainWheel($name)"
                set position    $ext_ClearChainWheel($name)
                $ext_cvName create arc      $position  -radius $radius -start 30  -extent 180 -style arc -outline red  -tags __CenterLine__
            }
            
                # -- CrankArm Clearance
            set radius  [rattleCAD::model::get_Scalar RearMockup CrankClearance]
            set position    $ext_Center(CrankArm)
            $ext_cvName create arc      $position  -radius $radius  -start 30  -extent 180  -style arc  -outline red  -tags __CenterLine__
            
                # -- Casette clearance
            set radius  [rattleCAD::model::get_Scalar RearMockup CassetteClearance]
            set position    $ext_ClearCassette(1)
            $ext_cvName create arc  $position  -radius $radius  -start 280  -extent 80  -style arc  -outline red  -tags __CenterLine__
            $ext_cvName create arc  $position  -radius $radius  -start   0  -extent 80  -style arc  -outline red  -tags __CenterLine__
     
            return
    }

    proc rattleCAD::cv_custom::create_tubeProfile_Edit {offset} {
            #
        variable sect_Points
            #
        upvar  1 cv_Name    ext_cvName 
        upvar  1 stageScale ext_stageScale
            #
        upvar  1 Length     ext_Length
        upvar  1 Center     ext_Center
        upvar  1 ChainStay  ext_ChainStay
            #
        upvar  1 Colour     ext_Colour
            #
            # puts "  -> create_tubeProfile_Edit: \$ext_Length"
            # parray  ext_Length
            # puts "  -> create_tubeProfile_Edit: \$ext_Center"
            # parray ext_Center
            # puts "  -> create_tubeProfile_Edit: \$ext_ChainStay"
            # parray ext_ChainStay
            #
        set profile_y00   [rattleCAD::model::get_Scalar ChainStay profile_y00]
        set profile_x01   [rattleCAD::model::get_Scalar ChainStay profile_x01]
        set profile_y01   [rattleCAD::model::get_Scalar ChainStay profile_y01]
        set profile_x02   [rattleCAD::model::get_Scalar ChainStay profile_x02]
        set profile_y02   [rattleCAD::model::get_Scalar ChainStay profile_y02]
        set profile_x03   [rattleCAD::model::get_Scalar ChainStay profile_x03]
        set profile_y03   [rattleCAD::model::get_Scalar ChainStay WidthBB]
            # set profile_y03   [rattleCAD::model::get_Scalar ChainStay profile_y03]
        set profile_xcl   [rattleCAD::model::get_Scalar ChainStay completeLength]
            #
            # puts "$profile_y00"
            # puts "$profile_x01"
            # puts "$profile_y01"
            # puts "$profile_x02"
            # puts "$profile_y02"
            # puts "$profile_x03"
            # puts "\$profile_y03 $profile_y03"
            #
            #
        set cuttingLeft   [rattleCAD::model::get_Scalar ChainStay cuttingLeft]
        set cuttingLength [rattleCAD::model::get_Scalar ChainStay cuttingLength]   
            #
            # set p00  [list [expr -1 * $ext_Length(ChainStay)] 0]
        set p0    [vectormath::addVector $ext_Center(ChainStay_DO)  $offset]
        set p1    [vectormath::addVector  $p0  [list $profile_x01   0]]
        set p2    [vectormath::addVector  $p1  [list $profile_x02   0]]
        set p3    [vectormath::addVector  $p2  [list $profile_x03   0]]
        set p4    [vectormath::addVector  $p0  [list $profile_xcl   0]]
            # 
        set p_cutLeft  [vectormath::addVector  $p0         [list $cuttingLeft   0]]
        set p_cutRight [vectormath::addVector  $p_cutLeft  [list $cuttingLength 0]]
            #
            # puts " .. ChainStay - TubeProfile: [appUtil::flatten_nestedList $p0 $p1 $p2 $p3 $p4]"
        
        set p00 [vectormath::addVector $p0  [list 0 [expr  0.5 * $profile_y00]]]
            #
        set chainStayProfile_north [rattleCAD::model::get_Polygon ChainStay_xy]
        set chainStayProfile_south {} 
        foreach {x y} $chainStayProfile_north {
            set y [expr -1 * $y]
            lappend chainStayProfile_south [list $x $y]
        }
            #
        set chainStayProfile $chainStayProfile_north
            #
        foreach {xy} [lreverse $chainStayProfile_south] {
            foreach {x y} $xy break
            lappend chainStayProfile $x $y
        }
            #
        set chainStayProfile [vectormath::addVectorPointList $p0 $chainStayProfile]
            #
        $ext_cvName  create polygon \
                            $chainStayProfile    \
                            -fill $rattleCAD::view::colorSet(chainStay) \
                            -outline $rattleCAD::view::colorSet(frameTube_OL) \
                            -tags __CenterLine__
            #
        $ext_cvName  create   centerline \
                            [appUtil::flatten_nestedList $p0 $p4] \
                            -fill $rattleCAD::view::colorSet(chainStay_CL) \
                            -tags __CenterLine__   
            #
        set textPosition [vectormath::addVector $p0  [list -70 -2.5]]
        set item  [$ext_cvName create draftText $textPosition -text "ChainStay Profile" -size [expr 5*$ext_stageScale]]
        $ext_cvName    addtag __CenterLine__ withtag  $item
            #
            #
          # $ext_cvName create circle     $p0       -radius 2  -outline red         -width 1.0        -tags __CenterLine__
          # $ext_cvName create circle     $p1       -radius 2  -outline red         -width 1.0        -tags __CenterLine__
          # $ext_cvName create circle     $p2       -radius 2  -outline red         -width 1.0        -tags __CenterLine__
          # $ext_cvName create circle     $p3       -radius 2  -outline red         -width 1.0        -tags __CenterLine__
            #
            #
        set p01 [vectormath::addVector $p1  [list 0 [expr  0.5 * $profile_y01]]]
        set p02 [vectormath::addVector $p2  [list 0 [expr  0.5 * $profile_y02]]]
        set p03 [vectormath::addVector $p3  [list 0 [expr  0.5 * $profile_y03]]]
        set p04 [vectormath::addVector $p4  [list 0 [expr  0.5 * $profile_y03]]]
            #
        set p14 [vectormath::addVector $p4  [list 0 [expr -0.5 * $profile_y03]]]
        set p13 [vectormath::addVector $p3  [list 0 [expr -0.5 * $profile_y03]]]
        set p12 [vectormath::addVector $p2  [list 0 [expr -0.5 * $profile_y02]]]
        set p11 [vectormath::addVector $p1  [list 0 [expr -0.5 * $profile_y01]]]
        set p10 [vectormath::addVector $p0  [list 0 [expr -0.5 * $profile_y00]]]
            #
            #
        $ext_cvName create circle     $p00       -radius 1  -outline red         -width 1.0        -tags __CenterLine__
        $ext_cvName create circle     $p01       -radius 1  -outline red         -width 1.0        -tags __CenterLine__
        $ext_cvName create circle     $p02       -radius 1  -outline red         -width 1.0        -tags __CenterLine__
        $ext_cvName create circle     $p03       -radius 1  -outline red         -width 1.0        -tags __CenterLine__
        $ext_cvName create circle     $p10       -radius 1  -outline red         -width 1.0        -tags __CenterLine__
        $ext_cvName create circle     $p11       -radius 1  -outline red         -width 1.0        -tags __CenterLine__
        $ext_cvName create circle     $p12       -radius 1  -outline red         -width 1.0        -tags __CenterLine__
        $ext_cvName create circle     $p13       -radius 1  -outline red         -width 1.0        -tags __CenterLine__
            #
            # -- define display length
            # set sectArea_01 [rattleCAD::cv_custom::create_sectionField  $ext_cvName  $p_cutLeft   __dragObject__]                                    
            # set sectArea_02 [rattleCAD::cv_custom::create_sectionField  $ext_cvName  $p_cutRight  __dragObject__]                                    
            # set sectArea_01 [rattleCAD::cv_custom::create_sectionField  $ext_cvName  $p_cutLeft ]                                    
        set sectArea_02 [rattleCAD::cv_custom::create_sectionField  $ext_cvName  $p_cutRight]                                    
            #
            # $ext_cvName addtag   __dragObject_x__  withtag  $sectArea_01
            # $ext_cvName addtag   __dragObject_x__  withtag  $sectArea_02
            #
        set sect_Points(0)   $p0
        set sect_Points(1)   $p_cutLeft
        set sect_Points(2)   $p_cutRight
            #
            # canvasCAD::register_dragObjects   $ext_cvName    $sectArea_01   [namespace current]::move_sectPoints  1
            # canvasCAD::register_dragObjects   $ext_cvName    $sectArea_02   [namespace current]::move_sectPoints  2
            #
            # set tagList [$ext_cvName gettags $ctrlArea_99]
            # puts "\n -> $tagList  \n"

            # -- dimension
        set _dim_x0          [ $ext_cvName dimension  length      [ appUtil::flatten_nestedList   $p0 $p4 ] \
                                                                horizontal    [expr -38 * $ext_stageScale]   0 \
                                                                $ext_Colour(result) ]
        set _dim_x1          [ $ext_cvName dimension  length      [ appUtil::flatten_nestedList   $p0 $p1 ] \
                                                                horizontal    [expr -25 * $ext_stageScale]   0 \
                                                                $ext_Colour(result) ]
        set _dim_x2          [ $ext_cvName dimension  length      [ appUtil::flatten_nestedList   $p1 $p2 ] \
                                                                horizontal    [expr -25 * $ext_stageScale]   0 \
                                                                $ext_Colour(result) ]
        set _dim_x3          [ $ext_cvName dimension  length      [ appUtil::flatten_nestedList   $p2 $p3 ] \
                                                                horizontal    [expr -25 * $ext_stageScale]   0 \
                                                                $ext_Colour(result) ]
          
            # -- cutting Length
            # set _dim_c1      [ $ext_cvName dimension  length      [ appUtil::flatten_nestedList   $sect_Points(0) $sect_Points(1) ] \
                                                                horizontal    [expr -25 * $ext_stageScale]   0 \
                                                                $ext_Colour(result) ]
        set _dim_c2          [ $ext_cvName dimension  length      [ appUtil::flatten_nestedList   $sect_Points(1) $sect_Points(2) ] \
                                                                horizontal    [expr  25 * $ext_stageScale]   0 \
                                                                $ext_Colour(result) ]
          
            # --
        set _dim_w0          [ $ext_cvName dimension  length      [ appUtil::flatten_nestedList   $p00 $p10 ] \
                                                                vertical      [expr  15 * $ext_stageScale]    0 \
                                                                $ext_Colour(result) ]
        set _dim_w1          [ $ext_cvName dimension  length      [ appUtil::flatten_nestedList   $p01 $p11 ] \
                                                                vertical      [expr  15 * $ext_stageScale]    0 \
                                                                $ext_Colour(result) ]
        set _dim_w2          [ $ext_cvName dimension  length      [ appUtil::flatten_nestedList   $p02 $p12 ] \
                                                                vertical      [expr  15 * $ext_stageScale]    0 \
                                                                $ext_Colour(result) ]
        set _dim_w3          [ $ext_cvName dimension  length      [ appUtil::flatten_nestedList   $p03 $p13 ] \
                                                                vertical      [expr -15 * $ext_stageScale]    0 \
                                                                $ext_Colour(result) ]
            #
        $ext_cvName raise $sectArea_02
            #
          
            #
        rattleCAD::view::gui::dimension_CursorBinding   $ext_cvName     $_dim_x0     single_ChainStay_ProfileLengthComplete
        rattleCAD::view::gui::dimension_CursorBinding   $ext_cvName     $_dim_x1     single_ChainStay_ProfileLength_01
        rattleCAD::view::gui::dimension_CursorBinding   $ext_cvName     $_dim_x2     single_ChainStay_ProfileLength_02
        rattleCAD::view::gui::dimension_CursorBinding   $ext_cvName     $_dim_x3     single_ChainStay_ProfileLength_03
            #                                                           
        # rattleCAD::view::gui::dimension_CursorBinding   $ext_cvName     $_dim_c2     single_ChainStay_ProfileLengthCut
            #                                                           
        rattleCAD::view::gui::dimension_CursorBinding   $ext_cvName     $_dim_w0     single_ChainStay_ProfileWidth_00
        rattleCAD::view::gui::dimension_CursorBinding   $ext_cvName     $_dim_w1     single_ChainStay_ProfileWidth_01
        rattleCAD::view::gui::dimension_CursorBinding   $ext_cvName     $_dim_w2     single_ChainStay_ProfileWidth_02
        rattleCAD::view::gui::dimension_CursorBinding   $ext_cvName     $_dim_w3     single_ChainStay_ProfileWidth_03
            #
        return
            #
    }

    proc rattleCAD::cv_custom::create_centerLine_Edit {ctrLines offset} {
          variable ctrl_Points
          
          upvar  1 cv_Name    ext_cvName 
          upvar  1 stageScale ext_stageScale
          
          upvar  1 Length     ext_Length
          upvar  1 Center     ext_Center
          upvar  1 ChainStay  ext_ChainStay
          
          upvar  1 Colour     ext_Colour
          
            #puts "  -> create_centerLine_Edit: \$ext_Length"
            #parray  ext_Length
            #puts "  -> create_centerLine_Edit: \$ext_Center"
            #parray ext_Center
            #puts "  -> create_centerLine_Edit: \$ext_ChainStay"
            #parray ext_ChainStay
            

        set offset  [vectormath::addVector $ext_Center(ChainStay_DO)  $offset]
        
        set textPosition [vectormath::addVector $offset  [list -70 -2.5]]
        set item  [$ext_cvName create draftText $textPosition -text "ChainStay CenterLine" -size [expr 5*$ext_stageScale]]
        $ext_cvName    addtag __CenterLine__ withtag  $item


            # -- get control Line - Points
        set i 0
        foreach {x y} $ctrLines {
            set p$i [vectormath::addVector [list $x $y] $offset]
            incr i
            # puts "    -> $i"
        }
          # puts " .. ChainStay - Control Curve: [llength $ctrLines]"
          # puts " .. ChainStay - Control Curve: \n        -> p0: $p0 \n        -> p2: $p2 \n        -> p4: $p4 \n        -> p6: $p6 \n        -> p8: $p8"
          # puts " .. ChainStay - Control Curve: \n        -> p1: $p1 \n        -> p3: $p3 \n        -> p5: $p5 \n        -> p7: $p7 \n        -> p9: $p9"
                                     
        set ctrl_p0 $p0
        set ctrl_p1 [vectormath::intersectPoint $p0 $p1  $p2 $p3 center]
        set ctrl_p2 [vectormath::intersectPoint $p2 $p3  $p4 $p5 center]
        set ctrl_p3 [vectormath::intersectPoint $p4 $p5  $p6 $p7 center]
        set ctrl_p4 [vectormath::intersectPoint $p6 $p7  $p8 $p9 center]
        set ctrl_p5 $p9
        
        set ctrl_Points(0)  $p0  
        set ctrl_Points(1)  [vectormath::intersectPoint $p0 $p1  $p2 $p3 center]  
        set ctrl_Points(2)  [vectormath::intersectPoint $p2 $p3  $p4 $p5 center]  
        set ctrl_Points(3)  [vectormath::intersectPoint $p4 $p5  $p6 $p7 center]  
        set ctrl_Points(4)  [vectormath::intersectPoint $p6 $p7  $p8 $p9 center] 
        set ctrl_Points(5)  $p9 
        set ctrl_Points(6)  [vectormath::addVector $p9 {20 0}]
        
        set offset_dropOut [expr [rattleCAD::model::get_Scalar BottomBracket OffsetCS_TopView] + 0.5 * [rattleCAD::model::get_Scalar RearWheel HubWidth] ]
        
        set base_p0 [list [lindex $ctrl_p0 0] [expr [lindex $ctrl_p0 1] - $offset_dropOut]]
        # set base_p5 [list [lindex $ctrl_p5 0] [lindex $base_p0 1]]
        set base_p5 [list 0 [lindex $base_p0 1]]
        set base_p0 [vectormath::addVector $base_p0 {150 0}]
        set base_p5 [vectormath::addVector $base_p5 { 40 0}]
        # -- draw base line
        set base_Line   [$ext_cvName create centerline [appUtil::flatten_nestedList $base_p0 $base_p5]   -tags __CenterLine__   -fill gray50]

     
        
            # -- draw edit areas
        set ctrlArea_01 [$ext_cvName create circle       $ctrl_Points(1)    -radius  8.0  -outline orange    -fill gray   -width 1.0   -tags {__CenterLine__}]
        set ctrlArea_02 [$ext_cvName create circle       $ctrl_Points(2)    -radius  8.0  -outline orange    -fill gray   -width 1.0   -tags {__CenterLine__}]
        set ctrlArea_03 [$ext_cvName create circle       $ctrl_Points(3)    -radius  8.0  -outline orange    -fill gray   -width 1.0   -tags {__CenterLine__}]
        set ctrlArea_04 [$ext_cvName create circle       $ctrl_Points(4)    -radius  8.0  -outline orange    -fill gray   -width 1.0   -tags {__CenterLine__}]
            # set ctrlArea_05 [$ext_cvName create circle       $ctrl_Points(5)    -radius  8.0  -outline orange    -fill gray   -width 1.0   -tags {__CenterLine__}]
        
            # -- draw drag areas
        set ctrlArea_11 [rattleCAD::cv_custom::create_controlField  $ext_cvName  $ctrl_Points(0) $ctrl_Points(1) $ctrl_Points(2)  __dragObject__]                                    
        set ctrlArea_12 [rattleCAD::cv_custom::create_controlField  $ext_cvName  $ctrl_Points(1) $ctrl_Points(2) $ctrl_Points(3)  __dragObject__]                                    
        set ctrlArea_13 [rattleCAD::cv_custom::create_controlField  $ext_cvName  $ctrl_Points(2) $ctrl_Points(3) $ctrl_Points(4)  __dragObject__]                                    
        set ctrlArea_14 [rattleCAD::cv_custom::create_controlField  $ext_cvName  $ctrl_Points(3) $ctrl_Points(4) $ctrl_Points(5)  __dragObject__]                                    
        # set ctrlArea_15 [$ext_cvName create circle       $ctrl_Points(5)    -radius  8.0  -outline orange    -fill gray   -width 1.0   -tags {__CenterLine__ __dragObject__}]
            # set ctrlArea_15 [rattleCAD::cv_custom::create_controlField  $ext_cvName  $ctrl_Points(4) $ctrl_Points(5) $ctrl_Points(6)  __dragObject__]                                    
                                                                                                                                                
            # -- draw control Lines
        set _obj_line_01  [$ext_cvName  create   line [appUtil::flatten_nestedList $p0 $p1]   -tags __CenterLine__   -fill orange]
        set _obj_line_02  [$ext_cvName  create   line [appUtil::flatten_nestedList $p2 $p3]   -tags __CenterLine__   -fill orange]
        set _obj_line_03  [$ext_cvName  create   line [appUtil::flatten_nestedList $p4 $p5]   -tags __CenterLine__   -fill orange]
        set _obj_line_04  [$ext_cvName  create   line [appUtil::flatten_nestedList $p6 $p7]   -tags __CenterLine__   -fill orange]
        set _obj_line_05  [$ext_cvName  create   line [appUtil::flatten_nestedList $p8 $p9]   -tags __CenterLine__   -fill orange]

            # -- draw a circle on intersecting vectors
        $ext_cvName create circle     $ctrl_Points(1)    -radius 0.5   -outline orange    -fill lightgray   -width 1.0   -tags {__CenterLine__}
        $ext_cvName create circle     $ctrl_Points(2)    -radius 0.5   -outline orange    -fill lightgray   -width 1.0   -tags {__CenterLine__}
        $ext_cvName create circle     $ctrl_Points(3)    -radius 0.5   -outline orange    -fill lightgray   -width 1.0   -tags {__CenterLine__}
        $ext_cvName create circle     $ctrl_Points(4)    -radius 0.5   -outline orange    -fill lightgray   -width 1.0   -tags {__CenterLine__}
        $ext_cvName create circle     $ctrl_Points(5)    -radius 0.5   -outline orange    -fill lightgray   -width 1.0   -tags {__CenterLine__}
        
                                                                                                        
        
        set _dim_length_01          [ $ext_cvName dimension  length      [ appUtil::flatten_nestedList   $p0 $p1 ] \
                                            aligned    [expr -15 * $ext_stageScale]   0 \
                                            $ext_Colour(result) ]
        set _dim_length_02          [ $ext_cvName dimension  length      [ appUtil::flatten_nestedList   $p2 $p3 ] \
                                            aligned    [expr -15 * $ext_stageScale]   0 \
                                            $ext_Colour(result) ]
        set _dim_length_03          [ $ext_cvName dimension  length      [ appUtil::flatten_nestedList   $p4 $p5 ] \
                                            aligned    [expr -15 * $ext_stageScale]   0 \
                                            $ext_Colour(result) ]
        set _dim_length_04          [ $ext_cvName dimension  length      [ appUtil::flatten_nestedList   $p6 $p7 ] \
                                            aligned    [expr -15 * $ext_stageScale]   0 \
                                            $ext_Colour(result) ]
        # set _dim_length_05        [ $ext_cvName dimension  length      [ appUtil::flatten_nestedList   $p8 $p9 ] \
                                            aligned    [expr -15 * $ext_stageScale]   0 \
                                            $ext_Colour(result) ]
            #
        rattleCAD::view::gui::dimension_CursorBinding   $ext_cvName     $_dim_length_01     single_ChainStay_CenterlineLength_01
        rattleCAD::view::gui::dimension_CursorBinding   $ext_cvName     $_dim_length_02     single_ChainStay_CenterlineLength_02
        rattleCAD::view::gui::dimension_CursorBinding   $ext_cvName     $_dim_length_03     single_ChainStay_CenterlineLength_03
        rattleCAD::view::gui::dimension_CursorBinding   $ext_cvName     $_dim_length_04     single_ChainStay_CenterlineLength_04
            #
        rattleCAD::view::gui::dimension_CursorBinding   $ext_cvName     $_obj_line_01       single_ChainStay_CenterlineLength_01
        rattleCAD::view::gui::dimension_CursorBinding   $ext_cvName     $_obj_line_02       single_ChainStay_CenterlineLength_02
        rattleCAD::view::gui::dimension_CursorBinding   $ext_cvName     $_obj_line_03       single_ChainStay_CenterlineLength_03
        rattleCAD::view::gui::dimension_CursorBinding   $ext_cvName     $_obj_line_04       single_ChainStay_CenterlineLength_04
            #
        rattleCAD::view::gui::dimension_CursorBinding   $ext_cvName     $ctrlArea_01        group_ChainStay_Centerline_Bent01    
        rattleCAD::view::gui::dimension_CursorBinding   $ext_cvName     $ctrlArea_02        group_ChainStay_Centerline_Bent02
        rattleCAD::view::gui::dimension_CursorBinding   $ext_cvName     $ctrlArea_03        group_ChainStay_Centerline_Bent03
        rattleCAD::view::gui::dimension_CursorBinding   $ext_cvName     $ctrlArea_04        group_ChainStay_Centerline_Bent04
            #
            #
        rattleCAD::view::gui::object_CursorBinding     $ext_cvName    $ctrlArea_11
        rattleCAD::view::gui::object_CursorBinding     $ext_cvName    $ctrlArea_12
        rattleCAD::view::gui::object_CursorBinding     $ext_cvName    $ctrlArea_13
        rattleCAD::view::gui::object_CursorBinding     $ext_cvName    $ctrlArea_14
            #
        canvasCAD::register_dragObjects   $ext_cvName    $ctrlArea_11   [namespace current]::move_ctrlPoints  1
        canvasCAD::register_dragObjects   $ext_cvName    $ctrlArea_12   [namespace current]::move_ctrlPoints  2
        canvasCAD::register_dragObjects   $ext_cvName    $ctrlArea_13   [namespace current]::move_ctrlPoints  3
        canvasCAD::register_dragObjects   $ext_cvName    $ctrlArea_14   [namespace current]::move_ctrlPoints  4
            #
            #
        return 
            #          
    }

    proc rattleCAD::cv_custom::get_ChainWheel {z w position} {                    
            set cw_Diameter_TK  [ expr 12.7 / sin ($vectormath::CONST_PI/$z)  ]
            set cw_Diameter     [ expr $cw_Diameter_TK + 4 ]
            set cw_Width        $w
            
                # puts "   \$cw_Diameter_TK  $cw_Diameter_TK"
            
            set pt_01           [ list [ expr -0.5 * $cw_Diameter    ] [expr  0.5 * ($cw_Width - 0.5)] ]
            set pt_02           [ list [ expr -0.5 * $cw_Diameter_TK ] [expr  0.5 * $cw_Width] ]
            set pt_03           [ list [ expr  0.5 * $cw_Diameter_TK ] [expr  0.5 * $cw_Width] ]
            set pt_04           [ list [ expr  0.5 * $cw_Diameter    ] [expr  0.5 * ($cw_Width - 0.5)] ]
            
            set pt_05           [ list [ expr  0.5 * $cw_Diameter    ] [expr -0.5 * ($cw_Width - 0.5)] ]
            set pt_06           [ list [ expr  0.5 * $cw_Diameter_TK ] [expr -0.5 * $cw_Width] ]
            set pt_07           [ list [ expr -0.5 * $cw_Diameter_TK ] [expr -0.5 * $cw_Width] ]
            set pt_08           [ list [ expr -0.5 * $cw_Diameter    ] [expr -0.5 * ($cw_Width - 0.5)] ]
            
            # set position        [ list [lindex $position 0] [expr -1 * [lindex $position 1]] ]
            set pt_Clearance_l  [ vectormath::addVector [ list [ expr -0.5 * $cw_Diameter ] 0]  $position  ]
            set pt_Clearance_r  [ vectormath::addVector [ list [ expr  0.5 * $cw_Diameter ] 0]  $position  ]
            
            set polygon         [ appUtil::flatten_nestedList       [ list  $pt_01  $pt_02  $pt_03  $pt_04  \
                                                                            $pt_05  $pt_06  $pt_07  $pt_08 ] ]
            set polygon         [ vectormath::addVectorPointList    $position $polygon ]                                                            
            return [list $pt_Clearance_l $polygon $pt_Clearance_r]
    }

    proc rattleCAD::cv_custom::get_BottomBracket {} {   
            upvar  1 cv_Name    ext_cvName              
            upvar  1 Length     ext_Length
            upvar  1 Center     ext_Center
            
            set length03            [ expr 0.5 * [rattleCAD::model::get_Scalar BottomBracket OutsideDiameter] ]
            set length04            [ expr 0.5 * [rattleCAD::model::get_Scalar BottomBracket Width] ]
            
            set pointList_OutSide   [ list [expr -1*$length03] [expr -1*$length04] $length03 $length04 ]
            set pointList_InSide    [ list [expr -1*$ext_Length(01)] [expr -1*$ext_Length(02)] $ext_Length(01) $ext_Length(02) ]
            
            return [list $pointList_OutSide $pointList_InSide]
    }

    proc rattleCAD::cv_custom::create_controlField {cv_Name xy1 xy xy2 {tag {}}} {
            # upvar  1 cv_Name    ext_cvName
            set CONST_PI $vectormath::CONST_PI
            set r    8.0
            set h1  15
            set h2  20
            set b1  35
            set b2  05
            
                # -- get orientation of controlField
            set baseAngle   [vectormath::dirAngle $xy1 $xy] 
            set xy_orient   [vectormath::offsetOrientation $xy1 $xy $xy2]
            if {$xy_orient == 0} {set xy_orient 1}
            set xy_angle    [expr $xy_orient * (0 + [vectormath::angle    $xy1 $xy $xy2])]
                # puts "      \$baseAngle    $baseAngle"
                # puts "      \$xy_orient    $xy_orient"
                # puts "      \$xy_angle     $xy_angle"
            set orientAngle [expr 180 + $baseAngle + 0.5*$xy_angle]
            
                # -- get trapez-shape of controlField
            set x1   $h1
            set x2   [expr  $h1 + $h2]
            set y11  [expr +0.5 * $b1]
            set y12  [expr -0.5 * $b1]
            set y21  [expr +0.5 * $b2]
            set y22  [expr -0.5 * $b2]
            
                # -- get arc of controlField
            set arcCenter   [vectormath::intersectPoint [list $x1 $y11] [list $x2 $y21]  [list $x1 $y12] [list $x2 $y22] ]
            set arcAngle    [vectormath::angle          [list $x2 $y21] $arcCenter  [list $x2 $y22] ]
            
            set p           [list $x1 $y11]
            set arcPoints   $p
            set segmeents   8
            set i 0
            while {$i < $segmeents} {
                set p [vectormath::rotatePoint $arcCenter $p [expr $arcAngle/$segmeents]]
                lappend arcPoints $p
                incr i
                    # puts "    -> $i"
            }
            
                # -- position of controlField
            set coordList   $arcPoints
            set coordList   [appUtil::flatten_nestedList $coordList $x2 $y22  $x2 $y21]

            set coordList   [vectormath::addVectorPointList  $xy $coordList]
            set coordList   [vectormath::rotatePointList     $xy $coordList $orientAngle]
            set ctrlPolygon [$cv_Name create polygon     $coordList   -outline orange    -fill lightgray   -width 1.0   -tags [list __CenterLine__ $tag]]
            set returnObj   $ctrlPolygon
            
                # -- return controlField
            return $returnObj    
    }

    proc rattleCAD::cv_custom::move_ctrlPoints {id xy} {
            variable ctrl_Points
            puts "\n   -------------------------------"
            puts "    rattleCAD::cv_custom::move_ctrlPoints"
            puts "       id:              $id"
            puts "       xy:              $xy"
            puts "   -------------------------------"
            foreach key [lsort [array names ctrl_Points]] {
                puts "          $key           $ctrl_Points($key)"
            }                      
            puts "   -------------------------------"
            
            
            array set lastValues {}
                set lastValues(S01)     [vectormath::length   $ctrl_Points(0)  $ctrl_Points(1) ]
                set lastValues(S02)     [vectormath::length   $ctrl_Points(1)  $ctrl_Points(2) ]
                set lastValues(S03)     [vectormath::length   $ctrl_Points(2)  $ctrl_Points(3) ]
                set lastValues(S04)     [vectormath::length   $ctrl_Points(3)  $ctrl_Points(4) ]
                set lastValues(S05)     [vectormath::length   $ctrl_Points(4)  $ctrl_Points(5) ]
                
                set lastValues(A01)     [set ctrl_Points(1)]
                set lastValues(A02)     [set ctrl_Points(2)]
                set lastValues(A03)     [set ctrl_Points(3)]
                set lastValues(A04)     [set ctrl_Points(4)]
                
                set lastValues(P00)     [set ctrl_Points(0)]
                set lastValues(P01)     [set ctrl_Points(1)]
                set lastValues(P02)     [set ctrl_Points(2)]
                set lastValues(P03)     [set ctrl_Points(3)]
                set lastValues(P04)     [set ctrl_Points(4)]
                set lastValues(P05)     [set ctrl_Points(5)]

            
            foreach {x y} $xy break
            if {$id == 99} {
                  # -- this is the definition of ChainStay at the BottomBracket side
                  #   each drag on this point shall be in direction of the last segment
                  #   of the ChainStay and shall not influence the other definition points  
                  #   -> so get offstet in direction of last segment by "intersectPerp"              
                set lastLength [vectormath::length {0 0} $lastValues(P05)]
                set newLength  [vectormath::length {0 0} $xy]
                set refPos     [vectormath::addVector $ctrl_Points($id) [list $x [expr -1.0*$y]]]
                set newXY      [vectormath::intersectPerp $lastValues(P04) $lastValues(P05) $refPos]
                set ctrl_Points($id)     $newXY
                  # puts "    -> last pos 5:  $ctrl_Points(5)"
                  # puts "       -> lastLength:     $lastLength"
                  # puts "       -> newLength:      $newLength"
                  # puts "       -> \$newXY:        $newXY"
                  # puts "    ->  new  pos 5:  $ctrl_Points(5)"
                  # puts "\n-------------------\n\n\n\n"
            }  else {                
                  # ---
                    #set leftID         [expr $id - 1]
                    #set rightID        [expr $id + 1]
                    #set leftPos        [set ctrl_Points($leftID)]
                    #set rightPos       [set ctrl_Points($rightID)]
                      # ---
                    #set lastPos        [set ctrl_Points($id)]
                    #set lastOffset     [vectormath::distancePerp $leftPos $lastPos $rightPos]
                  # ---
                set myPos          [vectormath::addVector $ctrl_Points($id) [list $x [expr -1.0*$y]]]    
                    #set newOffset      [vectormath::distancePerp $leftPos $myPos $rightPos]
                    #set myRadius       [rattleCAD__model__getValue [format "FrameTubes/ChainStay/CenterLine/radius_0%i" $id]]
                    #set myAngle        [vectormath::angle $leftPos $myPos $rightPos]
                    #set myArcLength    [expr  $myRadius * ( 2 * $vectormath::CONST_PI * $myAngle / 360)]
                      # ---
                
                set ctrl_Points($id) $myPos

            }
    
            set S01_length      [vectormath::length   $ctrl_Points(0) $ctrl_Points(1) ]
            set S02_length      [vectormath::length   $ctrl_Points(1) $ctrl_Points(2) ]
            set S03_length      [vectormath::length   $ctrl_Points(2) $ctrl_Points(3) ]
            set S04_length      [vectormath::length   $ctrl_Points(3) $ctrl_Points(4) ]
            set S05_length      [vectormath::length   $ctrl_Points(4) $ctrl_Points(5) ]
                #            
            set S01_orient [vectormath::offsetOrientation $ctrl_Points(0) $ctrl_Points(1) $ctrl_Points(2)]
            set S02_orient [vectormath::offsetOrientation $ctrl_Points(1) $ctrl_Points(2) $ctrl_Points(3)]
            set S03_orient [vectormath::offsetOrientation $ctrl_Points(2) $ctrl_Points(3) $ctrl_Points(4)]
            set S04_orient [vectormath::offsetOrientation $ctrl_Points(3) $ctrl_Points(4) $ctrl_Points(5)]
                #
            set P01_angle  [expr $S01_orient * (-180 + [vectormath::angle    $ctrl_Points(0) $ctrl_Points(1) $ctrl_Points(2)])]
            set P02_angle  [expr $S02_orient * (-180 + [vectormath::angle    $ctrl_Points(1) $ctrl_Points(2) $ctrl_Points(3)])]
            set P03_angle  [expr $S03_orient * (-180 + [vectormath::angle    $ctrl_Points(2) $ctrl_Points(3) $ctrl_Points(4)])]
            set P04_angle  [expr $S04_orient * (-180 + [vectormath::angle    $ctrl_Points(3) $ctrl_Points(4) $ctrl_Points(5)])]
                #
            set S01_radius [rattleCAD::model::get_Scalar ChainStay segmentRadius_01]
            set S02_radius [rattleCAD::model::get_Scalar ChainStay segmentRadius_02]
            set S03_radius [rattleCAD::model::get_Scalar ChainStay segmentRadius_03]
            set S04_radius [rattleCAD::model::get_Scalar ChainStay segmentRadius_04]
                #
            proc update_ctrlPointValues {keyValueList} {
                set myList {}
                foreach {key value} $keyValueList { 
                        # puts "   -> $key $value"
                    set lastValue  $rattleCAD::view::_updateValue($key)
                    set lastValue  $rattleCAD::view::_updateValue($key)
                        # set lastValue  [rattleCAD::model::getValue $key ]
                        # puts "     ->   $lastValue"
                    set diffValue  [expr abs($lastValue - $value)]
                    if {$diffValue > 0.1} { 
                        puts "            ... update:  $key  $lastValue -> $value" 
                        lappend myList $key  $value
                    } else {
                        puts "            ... ignore:  $key  $lastValue -> $value"
                    }
                }
                rattleCAD::control::setValue $myList
            }
                #
                # -- check configuration of ChainStay CenterLine
            set dict_ChainStay [dict create \
                            segment_01  $S01_length \
                            segment_02  $S02_length \
                            segment_03  $S03_length \
                            segment_04  $S04_length \
                            segment_05  $S05_length \
                            angle_01    $P01_angle \
                            angle_02    $P02_angle \
                            angle_03    $P03_angle \
                            angle_04    $P04_angle \
                            radius_01   $S01_radius \
                            radius_02   $S02_radius \
                            radius_03   $S03_radius \
                            radius_04   $S04_radius \
            ]
                #
            if {! [rattleCAD::model::validate_ChainStayCenterLine $dict_ChainStay]} {
                    #
                #tk_messageBox -type ok -message "   ... this is not a valid configuration: check radius at bent!"
                    #
                    # -- current config does not fit to radius, segment length and angles
                    #      set the previous values as current
                set S01_length [rattleCAD::model::get_Scalar ChainStay segmentLength_01]
                set S02_length [rattleCAD::model::get_Scalar ChainStay segmentLength_02]
                set S03_length [rattleCAD::model::get_Scalar ChainStay segmentLength_03]
                set S04_length [rattleCAD::model::get_Scalar ChainStay segmentLength_04]
                    #
                set P01_angle  [rattleCAD::model::get_Scalar ChainStay segmentAngle_01]
                set P02_angle  [rattleCAD::model::get_Scalar ChainStay segmentAngle_02]
                set P03_angle  [rattleCAD::model::get_Scalar ChainStay segmentAngle_03]
                set P04_angle  [rattleCAD::model::get_Scalar ChainStay segmentAngle_04]
            }
                #
                #
            set keyValueList {}
                #
            lappend keyValueList Scalar/ChainStay/segmentLength_01      $S01_length
            lappend keyValueList Scalar/ChainStay/segmentLength_02      $S02_length
            lappend keyValueList Scalar/ChainStay/segmentLength_03      $S03_length
            lappend keyValueList Scalar/ChainStay/segmentLength_04      $S04_length
                #
            lappend keyValueList Scalar/ChainStay/segmentAngle_01       $P01_angle             
            lappend keyValueList Scalar/ChainStay/segmentAngle_02       $P02_angle
            lappend keyValueList Scalar/ChainStay/segmentAngle_03       $P03_angle
            lappend keyValueList Scalar/ChainStay/segmentAngle_04       $P04_angle           
                 #
            update_ctrlPointValues $keyValueList
                #
            puts "\n   -------------------------------"
            puts "       -> S01_length     [rattleCAD::model::get_Scalar ChainStay segmentLength_01]"
            puts "       -> S02_length     [rattleCAD::model::get_Scalar ChainStay segmentLength_02]"
            puts "       -> S03_length     [rattleCAD::model::get_Scalar ChainStay segmentLength_03]"
            puts "       -> S04_length     [rattleCAD::model::get_Scalar ChainStay segmentLength_04]"
            puts "       -> P01_angle      [rattleCAD::model::get_Scalar ChainStay segmentAngle_01]"
            puts "       -> P02_angle      [rattleCAD::model::get_Scalar ChainStay segmentAngle_02]"
            puts "       -> P03_angle      [rattleCAD::model::get_Scalar ChainStay segmentAngle_03]"
            puts "       -> P04_angle      [rattleCAD::model::get_Scalar ChainStay segmentAngle_04]"
            puts "       -> P01_radius     [rattleCAD::model::get_Scalar ChainStay segmentRadius_01]"
            puts "       -> P02_radius     [rattleCAD::model::get_Scalar ChainStay segmentRadius_02]"
            puts "       -> P03_radius     [rattleCAD::model::get_Scalar ChainStay segmentRadius_03]"
            puts "       -> P04_radius     [rattleCAD::model::get_Scalar ChainStay segmentRadius_04]"
            
                #set cv_Name     [rattleCAD::view::gui::current_canvasCAD]
                #rattleCAD::cv_custom::clean_StageContent   $cv_Name
            rattleCAD::cv_custom::updateView [rattleCAD::view::gui::current_canvasCAD]
                #
            return
                #
    }

    proc rattleCAD::cv_custom::create_sectionField {cv_Name xy {tag {}}} {
                #
            set width   8
            set height 18
                #
            foreach {x y} $xy break
                #
            set x0 [expr $x]
            set x1 [expr $x - 0.5 * $width]
            set x2 [expr $x + 0.5 * $width]
            set y0 [expr $y]
            set y1 [expr $y - 0.7 * $height]
            set y2 [expr $y - 1.0 * $height]
                # set coordList [appUtil::flatten_nestedList $x1 $y1  $x2 $y1  $x2 $y2  $x1 $y2]
            set coordList [appUtil::flatten_nestedList $x1 $y1  $x0 $y0  $x2 $y1  $x0 $y2]
                #
            set width   5
            set height 30
                #
            set x0 [expr $x]
            set x1 [expr $x + $width]
            set x2 [expr $x]
            set y0 [expr $y]
            set y1 [expr $y - 0.7 * $height]
            set y2 [expr $y - 1.0 * $height]
                #    
            set coordList [appUtil::flatten_nestedList $x0 $y0  $x1 $y1  $x2 $y2]
                #
            set ctrlPolygon [$cv_Name create polygon     $coordList   -outline red    -fill lightgray   -width 2.0   -tags [list __CenterLine__ $tag]]
            set returnObj   $ctrlPolygon
                #
                # -- return controlField
            return $returnObj    
                #
    }

    proc rattleCAD::cv_custom::move_sectPoints {id xy} {
            variable sect_Points
            variable ctrl_Points
            puts "\n   -------------------------------"
            puts "    rattleCAD::cv_custom::move_sectPoints"
            puts "       id:              $id"
            puts "       xy:              $xy"
            puts "   -------------------------------"
            foreach key [lsort [array names sect_Points]] {
                puts "          $key           $sect_Points($key)"
            }                      
            puts "   -------------------------------"
            
              #
            array set lastValues {}
                set lastValues(S01)     [vectormath::length   $sect_Points(0)  $sect_Points(1) ]
                set lastValues(S02)     [vectormath::length   $sect_Points(1)  $sect_Points(2) ]
                
                set lastValues(C00)     [set sect_Points(0)]
                set lastValues(C01)     [set sect_Points(1)]
                set lastValues(C02)     [set sect_Points(2)]
              # ---
                  
              #    
            foreach {x y} $xy break
              #
            set myPos           [vectormath::addVector $sect_Points($id) [list $x [expr -1.0*$y]]]
            set sect_Points($id) $myPos            
              # ---
            set cuttingLeft     [vectormath::length  $sect_Points(0) $sect_Points(1) ]
            set cuttingLength   [vectormath::length  $sect_Points(1) $sect_Points(2) ]
              #
              
              #
            proc update_sectPointValues {keyValueList} {
                set myList {}
                foreach {key value} $keyValueList { 
                    puts "<E> $key"
                    set lastValue  $rattleCAD::view::_updateValue($key)
                        # set lastValue  [rattleCAD::model::getValue $key ]
                    set diffValue  [expr abs($lastValue - $value)]
                    if {$diffValue > 0.1} { 
                        puts "            ... update:  $key  $lastValue -> $value" 
                        lappend myList $key  $value
                    } else {
                        puts "            ... ignore:  $key  $lastValue -> $value"
                    }
                }
                rattleCAD::control::setValue $myList
            }
              #
              
              #
            set keyValueList {}
              #
            lappend keyValueList Scalar/ChainStay/cuttingLeft       $cuttingLeft
            lappend keyValueList Scalar/ChainStay/cuttingLength     $cuttingLength
            # lappend keyValueList FrameTubes/ChainStay/Profile/cuttingLeft       $cuttingLeft
            # lappend keyValueList FrameTubes/ChainStay/Profile/cuttingLength     $cuttingLength
              #
            update_sectPointValues $keyValueList
              #
            
            puts "\n   -------------------------------"
            puts "       -> cuttingLeft    [rattleCAD::model::get_Scalar ChainStay cuttingLeft]"
            puts "       -> cuttingLength  [rattleCAD::model::get_Scalar ChainStay cuttingLength]"
            
              #set cv_Name     [rattleCAD::view::gui::current_canvasCAD]
              #rattleCAD::cv_custom::clean_StageContent   $cv_Name
            rattleCAD::cv_custom::updateView [rattleCAD::view::gui::current_canvasCAD]
            
            return
    }



