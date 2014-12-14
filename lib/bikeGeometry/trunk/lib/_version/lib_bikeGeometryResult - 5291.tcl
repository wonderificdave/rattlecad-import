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


    #-------------------------------------------------------------------------
       #  handle modification on /root/Result/... values
    proc bikeGeometry::set_resultParameter {_array _name value} {
    
            # variable         _updateValue
        
              # puts ""
              # puts "   -------------------------------"
              # puts "    set_resultParameter"
              # puts "       _array:          $_array"
              # puts "       _name:           $_name"
              # puts "       value:           $value"
        
            # variable Geometry
            # variable Rendering
            # variable Reference
            # variable Result
                #
            # variable BottomBracket
            # variable HandleBar
            # variable Saddle
            # variable SeatPost
            # variable SeatTube
            # variable HeadTube
            # variable TopTube
            # variable RearWheel
            # variable FrontWheel
            # variable Fork
            # variable Stem
            
           
        
            set xpath "$_array/$_name"
              # puts "       xpath:           $xpath"
        
            switch -exact $_name {
        
                {Length/BottomBracket/Height}   {   bikeGeometry::set_Result_BottomBracketHeight    $_array $_name  $value; return
                            # puts "               ... [format "%s(%s)" $_array $_name] $xpath"
                            # puts "set_resultParameter   -> Length/BottomBracket/Height - check \$BottomBracket(height) $BottomBracket(height)"
                            # puts "set_resultParameter   -> Length/BottomBracket/Height - check \$BottomBracket(depth) $BottomBracket(depth)"
                        set oldValue                $BottomBracket(Height)
                        set newValue                $value
                            # set newValue                [set_Value $xpath  $value format]
                            # set _updateValue($xpath)    $newValue
                        set delta                   [expr $newValue - $oldValue]
                            # puts "   ... oldValue:   $oldValue"
                            # puts "   ... newValue:   $newValue"
                            # puts "   ...... delta:   $delta"
                            
                            # --- update value
                            #
                        set xpath                   Custom/BottomBracket/Depth
                        set oldValue                $BottomBracket(Depth)
                        set BottomBracket(Depth)    [expr $oldValue - $delta ]
                        set_Value                   $xpath     $BottomBracket(Depth)
                            # 2014-11-19
                            # set newValue                [expr $oldValue - $delta ]
                            # set_Value                   $xpath     $newValue
                        return
                    }
              
                {Angle/HeadTube/TopTube}        {   bikeGeometry::set_Result_HeadTube_TopTubeAngle  $_array $_name  $value; return
                            # puts "               ... [format "%s(%s)" $_array $_name] $xpath"
                        set newValue                $value
                            #
                            # set HeadTopTube_Angle       [set_Value $xpath  $value format]
                        set HeadTopTube_Angle       $newValue
                            # set _updateValue($xpath)    $HeadTopTube_Angle
                            # puts "          \$HeadTopTube_Angle  = $HeadTopTube_Angle"
                  
                            # --- update value
                            #
                        set TopTube(Angle)          [expr $HeadTopTube_Angle - $HeadTube(Angle)]
                        set xpath                   Custom/TopTube/Angle
                        set_Value                   $xpath     $TopTube(Angle)
                            # 2014-11-19
                            # set value                   [expr $HeadTopTube_Angle - $HeadTube(Angle)]
                            # set xpath                   Custom/TopTube/Angle
                            # set_Value                   $xpath     $value
                        return
                    }
              
                {Angle/SeatTube/Direction}      {   bikeGeometry::set_Result_SeatTubeDirection      $_array $_name  $value; return
                            # puts "\n"
                            # puts "  ... Angle/SeatTube/Direction comes here: $value"
                            # puts ""
                            # puts "set_resultParameter   -> Angle/SeatTube/Direction - check \$Geometry(SeatTube_Angle) $Geometry(SeatTube_Angle)"
                            # puts "set_resultParameter   -> Angle/SeatTube/Direction - check \$Saddle(Height) $Saddle(Height)"
                            # puts "set_resultParameter   -> Angle/SeatTube/Direction - check \$Saddle(SaddleHeight)  $Saddle(SaddleHeight) "
                            # puts "set_resultParameter   -> Angle/SeatTube/Direction - check \$SeatPost(Setback) $SeatPost(Setback)"
                            # puts "set_resultParameter   -> Angle/SeatTube/Direction - check \$SeatPost(PivotOffset) $SeatPost(PivotOffset)"
                        set oldValue        $Geometry(SeatTube_Angle)
                        set PS_SD_Heigth    $Saddle(Height)
                        set SD_Heigth       $Saddle(SaddleHeight) 
                        set SP_Setback      $SeatPost(Setback)
                        set SP_PivotOffset  $SeatPost(PivotOffset)
                            #
                        set length_Setback  [expr $SP_Setback * sin([vectormath::rad $value])]
                        set height_Setback  [expr $SP_Setback * cos([vectormath::rad $value])]
                            # puts "    -> value $value"
                            # puts "    -> oldValue $oldValue"
                            # puts "    -> SP_Setback $SP_Setback"
                            # puts "    -> length_Setback $length_Setback"
                            # puts "    -> height_Setback $height_Setback"
                        set ST_height       [expr $PS_SD_Heigth - $SD_Heigth - $SP_PivotOffset + $height_Setback]
                        set length_SeatTube [expr $ST_height / tan([vectormath::rad $value])]
                            # puts "    -> ST_height $ST_height"
                            # puts "    -> length_SeatTube $length_SeatTube"
                            #
                            
                            # --- update value
                            #
                        set value [expr $length_Setback + $length_SeatTube]
                        set xpath                   Personal/Saddle_Distance
                        set_Value                   $xpath     $value
                        return
                   }
              
                {Length/SeatTube/VirtualLength} {   bikeGeometry::set_Result_SeatTubeVirtualLength  $_array $_name  $value; return
                            # puts "  -> Length/SeatTube/VirtualLength"
                            # puts "               ... [format "%s(%s)" $_array $_name] $xpath"
              
                            # SeatTube Offset
                            #
                            # puts "set_resultParameter   -> Length/SeatTube/VirtualLength - check \$Geometry(SeatTubeVirtual) $Geometry(SeatTubeVirtual))"
                            # puts "set_resultParameter   -> Length/SeatTube/VirtualLength - check \$Geometry(SeatTube_Angle) $Geometry(SeatTube_Angle))"
                            # puts "set_resultParameter   -> Length/SeatTube/VirtualLength - check \$HeadTube(Angle) $HeadTube(Angle))"
                        set oldValue                $Geometry(SeatTubeVirtual)
                            # set oldValue                $Geometry(SeatTubeVirtual)
                        set newValue                $value
                            # set newValue                [set_Value $xpath  $value format]
                            # set _updateValue($xpath)    $newValue
                        set delta                   [expr $newValue - $oldValue]
                
                        set offsetSeatTube          [vectormath::rotateLine {0 0} $delta [expr 180 - $Geometry(SeatTube_Angle)]]
                        set offsetSeatTube_x        [lindex $offsetSeatTube 0]
                            # puts "   -> $offsetSeatTube"
                    
                            # HeadTube Offset - horizontal
                            #
                        set deltaHeadTube           [expr [lindex $offsetSeatTube 1] / sin($HeadTube(Angle) * $vectormath::CONST_PI / 180) ]
                        set offsetHeadTube_x        [expr [lindex $offsetSeatTube 1] / tan($HeadTube(Angle) * $vectormath::CONST_PI / 180) ]
              
                            # HeadTube Offset - horizontal & length
                            #
                        set xpath                   Personal/HandleBar_Distance
                        set newValue                [expr $HandleBar(Distance)    + $offsetHeadTube_x + $offsetSeatTube_x]
                        set_Value                   $xpath     $newValue
                            #
                        set xpath                   FrameTubes/HeadTube/Length
                        set newValue                [expr $HeadTube(Length)    + $deltaHeadTube]
                        set_Value                   $xpath     $newValue
                            #
                        # set_Value                   $xpath     $newValue
                            #
                        return
                }
              
                {Length/HeadTube/ReachLength}   {   bikeGeometry::set_Result_HeadTubeReachLength    $_array $_name  $value; return
                            # puts "set_resultParameter   -> Length/HeadTube/ReachLength - check \$Geometry(ReachLengthResult) $Geometry(ReachLengthResult)"
                            # puts "set_resultParameter   -> Length/HeadTube/ReachLength - check \$HandleBar(Distance) $HandleBar(Distance)"
                        set oldValue                $Geometry(ReachLengthResult)
                        set newValue                $value
                            # set newValue                [set_Value $xpath  $value format]
                            # set _updateValue($xpath)    $newValue
                        set delta                   [expr $newValue - $oldValue]
                            #
                        set xpath                   Personal/HandleBar_Distance
                        set oldValue                $HandleBar(Distance)
                        set newValue                [expr $HandleBar(Distance)    + $delta]
                        set_Value                   $xpath     $newValue
                        return
                }
              
                {Length/HeadTube/StackHeight}   {   bikeGeometry::set_Result_HeadTubeStackHeight    $_array $_name  $value; return
                            # puts "set_resultParameter   -> Length/HeadTube/StackHeight - check \$Geometry(StackHeightResult) $Geometry(StackHeightResult)"
                            # puts "set_resultParameter   -> Length/HeadTube/StackHeight - check \$HeadTube(Angle)   $HeadTube(Angle)"
                            # puts "set_resultParameter   -> Length/HeadTube/StackHeight - check \$HandleBar(Height) $HandleBar(Height)"
                        set oldValue                $Geometry(StackHeightResult)
                        set newValue                $value
                            # set newValue                [set_Value $xpath  $value format]
                            # set _updateValue($xpath)    $newValue
                        set delta                   [expr $newValue - $oldValue]
              
                        set deltaHeadTube           [expr $delta / sin($HeadTube(Angle) * $vectormath::CONST_PI / 180) ]
                        set offsetHeadTube_x        [expr $delta / tan($HeadTube(Angle) * $vectormath::CONST_PI / 180) ]
              
                            # puts "==================="
                            # puts "    delta             $delta"
                            # puts "    deltaHeadTube     $deltaHeadTube"
                            # puts "    offsetHeadTube_x  $offsetHeadTube_x"
                      
                            #
                            # project::remove_tracing ; #because of setting two parameters at once
                            #
                        set xpath                   Personal/HandleBar_Height
                        set oldValue                $HandleBar(Height)
                        set newValue                [expr $HandleBar(Height)    + $delta]
                        set_Value                   $xpath      $newValue
                            #
                            # project::add_tracing
                            #
                        set xpath                   FrameTubes/HeadTube/Length
                        set oldValue                $HeadTube(Length)
                        set newValue                [expr $HeadTube(Length) + $deltaHeadTube ]
                        set_Value                   $xpath     $newValue
                            #
                        return
                }
              
                {Length/TopTube/VirtualLength}  {   bikeGeometry::set_Result_TopTubeVirtualLength   $_array $_name  $value; return
                            # puts "  -> Length/TopTube/VirtualLength"
                            # puts "               ... [format "%s(%s)" $_array $_name] $xpath"
                            # puts "set_resultParameter   -> Length/TopTube/VirtualLength - check \$Geometry(TopTubeVirtual) $Geometry(TopTubeVirtual)"
                        set oldValue                $Geometry(TopTubeVirtual)
                            # set oldValue                $Geometry(TopTubeVirtual)
                        set newValue                $value
                            # set newValue                [set_Value $xpath  $value format]
                            # set _updateValue($xpath)    $newValue
                        set delta                   [expr $newValue - $oldValue]
                      
                            # --- set HandleBar(Distance)
                            #
                        set newValue                [ expr $HandleBar(Distance)    + $delta ]
                        set xpath                   Personal/HandleBar_Distance
                        set_Value $xpath            $newValue
                        return
                  }
              
                {Length/FrontWheel/horizontal}  {   bikeGeometry::set_Result_FrontWheelhorizontal   $_array $_name  $value; return
                            # puts "  -> Length/TopTube/VirtualLength"
                            # puts "               ... [format "%s(%s)" $_array $_name] $xpath"
                            # puts "set_resultParameter   -> Length/FrontWheel/horizontal - check \$Geometry(FrontWheel_x) $Geometry(FrontWheel_x)"
                        set oldValue                $Geometry(FrontWheel_x)
                        set newValue                $value
                            # set newValue                [set_Value $xpath  $value format]
                            # set _updateValue($xpath)    $newValue
                        set delta                   [expr $newValue - $oldValue]
                      
                            # --- set HandleBar(Distance)
                            #
                        set newValue                [ expr $HandleBar(Distance)    + $delta ]
                        set xpath                   Personal/HandleBar_Distance
                        set_Value $xpath            $newValue
                        return
                  }
              
                {Length/RearWheel/horizontal}   {   bikeGeometry::set_Result_RearWheelhorizontal    $_array $_name  $value; return
                            # puts "  -> Length/TopTube/VirtualLength"
                            # puts "               ... [format "%s(%s)" $_array $_name] $xpath"
                            # puts "set_resultParameter   -> Length/FrontWheel/horizontal - check \$Geometry(RearWheel_X) $Geometry(RearWheel_X)"
                            # puts "set_resultParameter   -> Length/FrontWheel/horizontal - check \$BottomBracket(depth)  $BottomBracket(depth)"
                        set newValue                $value
                            # set newValue                [set_Value $xpath  $value format]
                            # set _updateValue($xpath)    $newValue
                        set bbDepth                 $BottomBracket(Depth)
                      
                            # --- set HandleBar(Distance)
                            #
                        set newValue                [ expr { sqrt( $newValue * $newValue + $bbDepth * $bbDepth ) } ]
                        set Geometry(RearWheel_X)   $newValue
                        set xpath                   Custom/WheelPosition/Rear
                        set_Value                   $xpath     $Geometry(RearWheel_X)
                        return
                  }
              
                {Length/FrontWheel/diagonal}    {   bikeGeometry::set_Result_FrontWheeldiagonal     $_array $_name  $value; return
                            # puts "               ... [format "%s(%s)" $_array $_name] $xpath"
                            # puts "set_resultParameter   -> Length/FrontWheel/diagonal - check \$Geometry(FrontWheel_xy) $Geometry(FrontWheel_xy)"
                        set oldValue                $Geometry(FrontWheel_xy)
                        set newValue                $value
                            # set newValue                [set_Value $xpath  $value format]
                            # set _updateValue($xpath)    $newValue
                            # puts "                 <D> ... $oldValue $newValue"
              
                            # --- set HandleBar(Angle)
                            #
                        set vect_01     [ expr $Stem(Length) * cos($Stem(Angle) * $vectormath::CONST_PI / 180) ]
                        set vect_02     [ expr $vect_01 - $Fork(Rake) ]
                            #
                        set FW_Distance_X_tmp  [ expr { sqrt( $newValue * $newValue - $FrontWheel(Distance_Y) * $FrontWheel(Distance_Y) ) } ]
                        set FW_Position_tmp    [ list $FW_Distance_X_tmp $FrontWheel(Distance_Y)]
                            #
                        set help_03   [ vectormath::cathetusPoint    $HandleBar(Position)    $FW_Position_tmp    $vect_02  close ]
                        set vect_HT   [ vectormath::parallel      $help_03                  $FW_Position_tmp    $Fork(Rake) ]
                            # puts "                 <D> ... $vect_HT"
                            #
                        set help_01  [ lindex $vect_HT 0]
                        set help_02  [ lindex $vect_HT 1]
                        set help_03  [list -200 [ lindex $help_02 1] ]
                            #
                        set newValue                [vectormath::angle    $help_01 $help_02 $help_03 ]
                        set xpath                   Custom/HeadTube/Angle
                        set_Value                   $xpath     $newValue
                        return
                  }
              
                {Length/Saddle/Offset_HB}       {   bikeGeometry::set_Result_SaddleOffset_HB        $_array $_name  $value; return
                            # puts "               ... [format "%s(%s)" $_array $_name] $xpath"
                            # puts "set_resultParameter   -> Length/Saddle/Offset_HB - check \$Geometry(Saddle_HB_y) $Geometry(Saddle_HB_y)"
                        set oldValue                $Geometry(Saddle_HB_y)
                        set newValue                $value
                            # set newValue                [set_Value $xpath  $value format ]
                            # set _updateValue($xpath)    $newValue
                
                        set delta                   [expr $oldValue - $newValue ]
                            # puts "          $newValue - $oldValue = $delta"
                
                            # --- set HandleBar(Distance)
                            #
                        set newValue                [expr $HandleBar(Height)    + $delta ]
                        set xpath                   Personal/HandleBar_Height
                        set_Value                   $xpath     $newValue
                        return
                  }
              
                {Length/Saddle/Offset_BB_ST}    {   bikeGeometry::set_Result_SaddleOffset_BB_ST     $_array $_name  $value; return
                            # puts "               ... [format "%s(%s)" $_array $_name] $xpath"
                        set newValue                $value
                            # set newValue                [set_Value $xpath  $value format ]
                            # puts "set_resultParameter   -> Length/Saddle/Offset_BB_ST - check \$Saddle(SaddleHeight)  $Saddle(SaddleHeight) "
                        set height                  $Saddle(Height)
                        set angle                   [vectormath::dirAngle {0 0} [list $newValue $height] ]
                        set_resultParameter Result Angle/SeatTube/Direction $angle
                            # puts "   $newValue / $height -> $angle"
                        return
                  }
              
                {Length/Saddle/Offset_BB_Nose}  {   bikeGeometry::set_Result_SaddleOffset_BB_Nose   $_array $_name  $value; return
                            # puts "               ... [format "%s(%s)" $_array $_name] $xpath"
                            # puts "set_resultParameter   -> Length/Saddle/Offset_BB_Nose - check \$Geometry(SaddleNose_BB_X) $Geometry(SaddleNose_BB_X)"
                        set oldValue                $Geometry(SaddleNose_BB_X)
                        set newValue                $value
                            # set newValue                [set_Value $xpath  $value format ]
                        set delta                   [expr -1.0 * ($newValue - $oldValue) ]
                
                            
                            # --- set Component(Saddle/LengthNose)
                            #
                            # puts "set_resultParameter   -> Length/Saddle/Offset_BB_Nose - check \$Rendering(SaddleOffset_X) $Rendering(SaddleOffset_X)"
                        set newValue                [expr $Saddle(Offset_X) + $delta ]
                        set Saddle(Offset_X)        $newValue
                        set xpath                   Rendering/Saddle/Offset_X
                        set_Value                   $xpath     $Saddle(Offset_X)                        
                            #
                        return
                  }

                {Length/Saddle/SeatTube_BB}     {   bikeGeometry::set_Result_SaddleSeatTube_BB      $_array $_name  $value; return
                        set newValue                $value
                            # set newValue                [set_Value $xpath  $value format ]
                        set oldValue                $Geometry(Saddle_BB)
                        set angle_SeatTube          $Geometry(SeatTube_Angle)
                        set pos_SeatTube_old        $Geometry(SeatTubeSaddle)
                        set pos_Saddle_old          $Saddle(Position)
                            #
                        set pos_SeatTube_x          [expr $newValue * cos([vectormath::rad $angle_SeatTube])]
                        set pos_SeatTube_y          [expr $newValue * sin([vectormath::rad $angle_SeatTube])]
                            #
                        set delta_Saddle_ST         [expr [lindex $pos_Saddle_old 0] - [lindex $pos_SeatTube_old 0]]
                            #
                        set pos_Saddle_x            [expr $pos_SeatTube_x - $delta_Saddle_ST]
                        set pos_Saddle_y            $pos_SeatTube_y
                        
                        # puts "  -> \$pos_SeatTube_old     $pos_SeatTube_old"
                        # puts "  -> \$pos_Saddle_old       $pos_Saddle_old"
                        # puts "  -> \$delta_Saddle_ST      $delta_Saddle_ST"
                        # puts "  -> \$pos_Saddle_x     $pos_Saddle_x"
                        # puts "  -> \$pos_Saddle_y     $pos_Saddle_y"
    
                        set Saddle(Distance)  [format "%.3f" $pos_Saddle_x]
                        set Saddle(Height)    [format "%.3f" $pos_Saddle_y]
                        set xpath                   Personal/Saddle_Distance
                        set_Value                   $xpath     $Saddle(Distance) 
                            #
                        bikeGeometry::update_Parameter
                            #                    
                        set xpath                   Personal/Saddle_Height
                        set_Value                   $xpath     $Saddle(Height)
                            #
                        return                      
                  }
                
                {Length/Personal/SaddleNose_HB} {   bikeGeometry::set_Result_PersonalSaddleNose_HB  $_array $_name  $value; return
                            # puts "set_resultParameter   -> Length/Personal/SaddleNose_HB - check \$Geometry(SaddleNose_HB)  $Geometry(SaddleNose_HB)"
                            # puts "set_resultParameter   -> Length/Personal/SaddleNose_HB - check \$HandleBar(Distance)  $HandleBar(Distance)"
                        set oldValue                $Geometry(SaddleNose_HB)
                        set newValue                $value
                            # set newValue                [set_Value $xpath  $value format ]
                        set delta                   [expr ($newValue - $oldValue) ]
                            
                            # --- set Personal(HandleBar_Distance)
                            #
                        set newValue                [expr $HandleBar(Distance) + $delta ]
                        set xpath                   Personal/HandleBar_Distance
                        set_Value                   $xpath     $newValue
                            #
                        return 
                  }
                  
                {Length/RearWheel/Radius}       {   bikeGeometry::set_Result_RearWheelRadius        $_array $_name  $value; return
                            # puts "set_resultParameter   -> Length/RearWheel/Radius - check \$RearWheel(RimDiameter)  $RearWheel(RimDiameter)"
                            # puts "set_resultParameter   -> Length/RearWheel/Radius - check \$RearWheel(TyreHeight)   $RearWheel(TyreHeight)"
                        set rimDiameter       $RearWheel(RimDiameter)
                        set tyreHeight        $RearWheel(TyreHeight)
                        set newValue          [ expr $value - 0.5 * $rimDiameter]
                        set xpath             Component/Wheel/Rear/TyreHeight
                        set_Value             $xpath     $newValue
                            #
                        return                      
                  }
                {Length/RearWheel/TyreShoulder} {   bikeGeometry::set_Result_RearWheelTyreShoulder  $_array $_name  $value; return
                            # puts "set_resultParameter   -> Length/RearWheel/TyreShoulder - check \$RearWheel(Radius)  $RearWheel(Radius)"
                        set wheelRadius   $RearWheel(Radius)
                        set xpath         Component/Wheel/Rear/TyreWidthRadius
                        set newValue      [ expr $wheelRadius - abs($value)]
                        set_Value         $xpath     $newValue
                            #
                        return                      
                  }
                {Length/FrontWheel/Radius}      {   bikeGeometry::set_Result_FrontWheelRadius       $_array $_name  $value; return
                            # puts "set_resultParameter   -> Length/FrontWheel/Radius - check \$FrontWheel(RimDiameter)  $FrontWheel(RimDiameter)"
                            # puts "set_resultParameter   -> Length/FrontWheel/Radius - check \$FrontWheel(TyreHeight)   $FrontWheel(TyreHeight)"
                        set rimDiameter   $FrontWheel(RimDiameter)
                        set tyreHeight    $FrontWheel(TyreHeight)
                        set newValue      [ expr $value - 0.5 * $rimDiameter]
                        set xpath         Component/Wheel/Front/TyreHeight
                        set_Value         $xpath     $newValue
                            #
                        return                      
                  }
                  
                {Length/Reference/Heigth_SN_HB} {   bikeGeometry::set_Result_ReferenceHeigth_SN_HB  $_array $_name  $value; return
                            # puts "   -> $_name"
                            # puts "set_resultParameter   -> Length/Reference/Heigth_SN_HB - check \$Reference(SaddleNose_HB_y)   $Reference(SaddleNose_HB_y)"
                            # puts "set_resultParameter   -> Length/Reference/Heigth_SN_HB - check \$Reference(HandleBar_Height)  $Reference(HandleBar_Height)"
                            # puts "set_resultParameter   -> Length/Reference/Heigth_SN_HB - check \$Reference(HandleBar_Height)  $Reference(HandleBar_Height)"
                        set oldValue                $Reference(SaddleNose_HB_y)
                        set newValue                $value
                            # set newValue                [set_Value [format "%s(%s)" $_array $_name]  $value format ]
                        set deltaValue              [expr $newValue - $oldValue]
                        set xpath                   Reference/HandleBar_Height
                        set HandleBar_Height        $Reference(HandleBar_Height)                              
                        set HandleBar_Height        [expr $HandleBar_Height - $deltaValue]  
                        set_Value         $xpath    $HandleBar_Height
                            #
                        return
                  } 
 
                {Length/Reference/SaddleNose_HB} {  bikeGeometry::set_Result_ReferenceSaddleNose_HB $_array $_name  $value; return
                            # puts "set_resultParameter   -> Length/Reference/SaddleNose_HB - check \$Reference(SaddleNose_HB_y)  $Reference(SaddleNose_HB_y)"
                        set SaddleHeight            $Reference(SaddleNose_HB_y)
                        set newValue                $value
                            # set newValue                [set_Value [format "%s(%s)" $_array $_name]  $value format ]
                        set Distance_HB             [ expr { sqrt( $newValue * $newValue - $SaddleHeight * $SaddleHeight ) } ]
                        set xpath                   Reference/HandleBar_Distance
                        set_Value         $xpath    $Distance_HB
                            #
                        return
                  }
                  
      

                default {
                        puts "\n"
                        puts "     WARNING!"
                        puts "\n"
                        puts "        ... set_resultParameter:  "
                        puts "                 $xpath"
                        puts "            ... is not registered!"
                        puts "\n"
                        return
                  }
            }
    
    }

    
                # {Length/BottomBracket/Height} 
    proc bikeGeometry::set_Result_BottomBracketHeight   {_array _name value} {
                # puts "               ... [format "%s(%s)" $_array $_name] $xpath"
                # puts "set_resultParameter   -> Length/BottomBracket/Height - check \$BottomBracket(height) $BottomBracket(height)"
                # puts "set_resultParameter   -> Length/BottomBracket/Height - check \$BottomBracket(depth) $BottomBracket(depth)"
            set oldValue                $BottomBracket(Height)
            set newValue                $value
                # set newValue                [set_Value $xpath  $value format]
                # set _updateValue($xpath)    $newValue
            set delta                   [expr $newValue - $oldValue]
                # puts "   ... oldValue:   $oldValue"
                # puts "   ... newValue:   $newValue"
                # puts "   ...... delta:   $delta"
                
                # --- update value
                #
            set xpath                   Custom/BottomBracket/Depth
            set oldValue                $BottomBracket(Depth)
            set BottomBracket(Depth)    [expr $oldValue - $delta ]
            set_Value                   $xpath     $BottomBracket(Depth)
                # 2014-11-19
                # set newValue                [expr $oldValue - $delta ]
                # set_Value                   $xpath     $newValue
            return
    }
              
                # {Angle/HeadTube/TopTube} 
    proc bikeGeometry::set_Result_HeadTube_TopTubeAngle {_array _name value} {
                # puts "               ... [format "%s(%s)" $_array $_name] $xpath"
            set newValue                $value
                #
                # set HeadTopTube_Angle       [set_Value $xpath  $value format]
            set HeadTopTube_Angle       $newValue
                # set _updateValue($xpath)    $HeadTopTube_Angle
                # puts "          \$HeadTopTube_Angle  = $HeadTopTube_Angle"
      
                # --- update value
                #
            set TopTube(Angle)          [expr $HeadTopTube_Angle - $HeadTube(Angle)]
            set xpath                   Custom/TopTube/Angle
            set_Value                   $xpath     $TopTube(Angle)
                # 2014-11-19
                # set value                   [expr $HeadTopTube_Angle - $HeadTube(Angle)]
                # set xpath                   Custom/TopTube/Angle
                # set_Value                   $xpath     $value
            return
    }
              
                # {Angle/SeatTube/Direction} 
    proc bikeGeometry::set_Result_SeatTubeDirection     {_array _name value} {
                #
                # Angle/SeatTube/Direction
                # Geometry(SeatTube_Angle)
                #
            variable Geometry    
            variable Saddle    
            variable SeatPost    
                #
            puts "    <1> set_Result_SeatTubeDirection   ... check $Geometry(SeatTube_Angle)  ->  $value"
                #
                # puts "\n"
                # puts "  ... Angle/SeatTube/Direction comes here: $value"
                # puts ""
                # puts "set_resultParameter   -> Angle/SeatTube/Direction - check \$Geometry(SeatTube_Angle) $Geometry(SeatTube_Angle)"
                # puts "set_resultParameter   -> Angle/SeatTube/Direction - check \$Saddle(Height) $Saddle(Height)"
                # puts "set_resultParameter   -> Angle/SeatTube/Direction - check \$Saddle(SaddleHeight)  $Saddle(SaddleHeight) "
                # puts "set_resultParameter   -> Angle/SeatTube/Direction - check \$SeatPost(Setback) $SeatPost(Setback)"
                # puts "set_resultParameter   -> Angle/SeatTube/Direction - check \$SeatPost(PivotOffset) $SeatPost(PivotOffset)"
            # set oldValue        $Geometry(SeatTube_Angle)
            # set PS_SD_Heigth    $Saddle(Height)
            # set SD_Heigth       $Saddle(SaddleHeight) 
            # set SP_Setback      $SeatPost(Setback)
            # set SP_PivotOffset  $SeatPost(PivotOffset)
                #
            set length_Setback      [expr $SeatPost(Setback) * sin([vectormath::rad $value])]
            set height_Setback      [expr $SeatPost(Setback) * cos([vectormath::rad $value])]
                # puts "    -> value $value"
                # puts "    -> oldValue $oldValue"
                # puts "    -> SeatPost(Setback) $SeatPost(Setback)"
                # puts "    -> length_Setback $length_Setback"
                # puts "    -> height_Setback $height_Setback"
            set ST_height           [expr $Saddle(Height) - $Saddle(SaddleHeight) - $SeatPost(PivotOffset) + $height_Setback]
            set length_SeatTube     [expr $ST_height / tan([vectormath::rad $value])]
                # puts "    -> ST_height $ST_height"
                # puts "    -> length_SeatTube $length_SeatTube"
                #
                
                # --- update value
                #
            set Saddle(Distance)    [expr $length_Setback + $length_SeatTube]
                # set value [expr $length_Setback + $length_SeatTube]
                # set xpath                   Personal/Saddle_Distance
                # set_Value                   $xpath     $value
                #
            bikeGeometry::update_Parameter
                #
            puts "    <2> set_Result_SeatTubeDirection   ... check $Geometry(SeatTube_Angle)  ->  $value"
                #
            return $Geometry(SeatTube_Angle)
                #
    }
            # {Length/SeatTube/VirtualLength} 
    proc bikeGeometry::set_Result_SeatTubeVirtualLength {_array _name value} {
                # puts "  -> Length/SeatTube/VirtualLength"
                # puts "               ... [format "%s(%s)" $_array $_name] $xpath"

                # SeatTube Offset
                #
                # puts "set_resultParameter   -> Length/SeatTube/VirtualLength - check \$Geometry(SeatTubeVirtual) $Geometry(SeatTubeVirtual))"
                # puts "set_resultParameter   -> Length/SeatTube/VirtualLength - check \$Geometry(SeatTube_Angle) $Geometry(SeatTube_Angle))"
                # puts "set_resultParameter   -> Length/SeatTube/VirtualLength - check \$HeadTube(Angle) $HeadTube(Angle))"
            set oldValue                $Geometry(SeatTubeVirtual)
                # set oldValue                $Geometry(SeatTubeVirtual)
            set newValue                $value
                # set newValue                [set_Value $xpath  $value format]
                # set _updateValue($xpath)    $newValue
            set delta                   [expr $newValue - $oldValue]

            set offsetSeatTube          [vectormath::rotateLine {0 0} $delta [expr 180 - $Geometry(SeatTube_Angle)]]
            set offsetSeatTube_x        [lindex $offsetSeatTube 0]
                # puts "   -> $offsetSeatTube"
        
                # HeadTube Offset - horizontal
                #
            set deltaHeadTube           [expr [lindex $offsetSeatTube 1] / sin($HeadTube(Angle) * $vectormath::CONST_PI / 180) ]
            set offsetHeadTube_x        [expr [lindex $offsetSeatTube 1] / tan($HeadTube(Angle) * $vectormath::CONST_PI / 180) ]

                # HeadTube Offset - horizontal & length
                #
            set xpath                   Personal/HandleBar_Distance
            set newValue                [expr $HandleBar(Distance)    + $offsetHeadTube_x + $offsetSeatTube_x]
            set_Value                   $xpath     $newValue
                #
            set xpath                   FrameTubes/HeadTube/Length
            set newValue                [expr $HeadTube(Length)    + $deltaHeadTube]
            set_Value                   $xpath     $newValue
                #
            # set_Value                   $xpath     $newValue
                #
            return
    } 
            # {Length/HeadTube/ReachLength} 
    proc bikeGeometry::set_Result_HeadTubeReachLength   {_array _name value} {
                # puts "set_resultParameter   -> Length/HeadTube/ReachLength - check \$Geometry(ReachLengthResult) $Geometry(ReachLengthResult)"
                # puts "set_resultParameter   -> Length/HeadTube/ReachLength - check \$HandleBar(Distance) $HandleBar(Distance)"
            set oldValue                $Geometry(ReachLengthResult)
            set newValue                $value
                # set newValue                [set_Value $xpath  $value format]
                # set _updateValue($xpath)    $newValue
            set delta                   [expr $newValue - $oldValue]
                #
            set xpath                   Personal/HandleBar_Distance
            set oldValue                $HandleBar(Distance)
            set newValue                [expr $HandleBar(Distance)    + $delta]
            set_Value                   $xpath     $newValue
            return
    }
            # {Length/HeadTube/StackHeight} 
    proc bikeGeometry::set_Result_HeadTubeStackHeight   {_array _name value} {
                # puts "set_resultParameter   -> Length/HeadTube/StackHeight - check \$Geometry(StackHeightResult) $Geometry(StackHeightResult)"
                # puts "set_resultParameter   -> Length/HeadTube/StackHeight - check \$HeadTube(Angle)   $HeadTube(Angle)"
                # puts "set_resultParameter   -> Length/HeadTube/StackHeight - check \$HandleBar(Height) $HandleBar(Height)"
            set oldValue                $Geometry(StackHeightResult)
            set newValue                $value
                # set newValue                [set_Value $xpath  $value format]
                # set _updateValue($xpath)    $newValue
            set delta                   [expr $newValue - $oldValue]
  
            set deltaHeadTube           [expr $delta / sin($HeadTube(Angle) * $vectormath::CONST_PI / 180) ]
            set offsetHeadTube_x        [expr $delta / tan($HeadTube(Angle) * $vectormath::CONST_PI / 180) ]
  
                # puts "==================="
                # puts "    delta             $delta"
                # puts "    deltaHeadTube     $deltaHeadTube"
                # puts "    offsetHeadTube_x  $offsetHeadTube_x"
          
                #
                # project::remove_tracing ; #because of setting two parameters at once
                #
            set xpath                   Personal/HandleBar_Height
            set oldValue                $HandleBar(Height)
            set newValue                [expr $HandleBar(Height)    + $delta]
            set_Value                   $xpath      $newValue
                #
                # project::add_tracing
                #
            set xpath                   FrameTubes/HeadTube/Length
            set oldValue                $HeadTube(Length)
            set newValue                [expr $HeadTube(Length) + $deltaHeadTube ]
            set_Value                   $xpath     $newValue
                #
            return
    }
            # {Length/TopTube/VirtualLength} 
    proc bikeGeometry::set_Result_TopTubeVirtualLength  {_array _name value} {
                #
                # Length/TopTube/VirtualLength
                # Geometry(TopTubeVirtual)
                #
            variable Geometry
            variable HandleBar
                # puts "  -> Length/TopTube/VirtualLength"
                # puts "               ... [format "%s(%s)" $_array $_name] $xpath"
                # puts "set_resultParameter   -> Length/TopTube/VirtualLength - check \$Geometry(TopTubeVirtual) $Geometry(TopTubeVirtual)"
                #
            puts "    <1> set_Result_TopTubeVirtualLength   ... check $Geometry(FrontWheel_x)  ->  $value"
                #
                # set oldValue                $Geometry(TopTubeVirtual)
                # set oldValue                $Geometry(TopTubeVirtual)
                # set newValue                $value
                # set newValue                [set_Value $xpath  $value format]
                # set _updateValue($xpath)    $newValue
            set delta                   [expr $value - $Geometry(TopTubeVirtual)]
          
                # --- set HandleBar(Distance)
                #
            set HandleBar(Distance)     [ expr $HandleBar(Distance)    + $delta ]
                # set xpath                   Personal/HandleBar_Distance
                # set_Value $xpath            $newValue
                #
            bikeGeometry::update_Parameter
                #
            puts "    <2> set_Result_TopTubeVirtualLength   ... check $Geometry(FrontWheel_x)  ->  $value"
                #
            return $Geometry(TopTubeVirtual)
                #
    }
            # {Length/FrontWheel/horizontal} 
    proc bikeGeometry::set_Result_FrontWheelhorizontal  {_array _name value} {
                #
                # Length/FrontWheel/horizontal
                # Geometry(FrontWheel_x)
                #
            variable Geometry
            variable HandleBar
                #
            # puts "    <1> set_Result_FrontWheelhorizontal   ... check $Geometry(FrontWheel_x)  ->  $value"
                #
                # puts "  -> Length/TopTube/VirtualLength"
                # puts "               ... [format "%s(%s)" $_array $_name] $xpath"
                # puts "set_resultParameter   -> Length/FrontWheel/horizontal - check \$Geometry(FrontWheel_x) $Geometry(FrontWheel_x)"
                # set oldValue                $Geometry(FrontWheel_x)
                # set newValue                $value
                # set newValue                [set_Value $xpath  $value format]
                # set _updateValue($xpath)    $newValue
            set delta                   [expr $value - $Geometry(FrontWheel_x)]
          
                # --- set HandleBar(Distance)
                #
            set HandleBar(Distance)     [ expr $HandleBar(Distance)    + $delta ]
                #set newValue                [ expr $HandleBar(Distance)    + $delta ]
                #set xpath                   Personal/HandleBar_Distance
                #set_Value $xpath            $newValue
                #
            bikeGeometry::update_Parameter
                #
            # puts "    <2> set_Result_FrontWheelhorizontal   ... check $Geometry(FrontWheel_x)  ->  $value"
                #
            return Geometry(FrontWheel_x)
                #
    }
            #
    proc bikeGeometry::set_Result_RearWheelhorizontal   {_array _name value} {
                #
                # Length/RearWheel/horizontal
                # Geometry(RearWheel_X)
                #
            variable Geometry
            variable BottomBracket
            variable RearWheel
                #
            # puts "    <1> set_Result_RearWheelhorizontal   ... check $Geometry(RearWheel_X)  ->  $value"
                #
                # puts "  -> Length/TopTube/VirtualLength"
                # puts "               ... [format "%s(%s)" $_array $_name] $xpath"
                # puts "set_resultParameter   -> Length/FrontWheel/horizontal - check \$Geometry(RearWheel_X) $Geometry(RearWheel_X)"
                # puts "set_resultParameter   -> Length/FrontWheel/horizontal - check \$BottomBracket(depth)  $BottomBracket(depth)"
                # set newValue                $value
                # set newValue                [set_Value $xpath  $value format]
                # set _updateValue($xpath)    $newValue
                # set bbDepth                 $BottomBracket(Depth)
          
                # --- set HandleBar(Distance)
                #
                # set newValue                [ expr { sqrt( $value * $value + $bbDepth * $bbDepth ) } ]
            set RearWheel(DistanceBB)   [ expr { sqrt( $value * $value + $BottomBracket(Depth) * $BottomBracket(Depth) ) } ]
                # set xpath                   Custom/WheelPosition/Rear
                # set_Value                   $xpath     $Geometry(RearWheel_X)
                #
            bikeGeometry::update_Parameter
                #
            # puts "    <2> set_Result_RearWheelhorizontal   ... check $Geometry(RearWheel_X)  ->  $value"
                #
            return $Geometry(RearWheel_X)
                #
    }
            #
    proc bikeGeometry::set_Result_FrontWheeldiagonal    {_array _name value} {
                #
                # Length/FrontWheel/diagonal
                # Geometry(FrontWheel_xy)
                #
            variable Geometry
            variable Fork
            variable FrontWheel
            variable HandleBar
            variable HeadTube
            variable Stem
                #
            # puts "    <1> set_Result_FrontWheeldiagonal   ... check $Geometry(FrontWheel_xy)  ->  $value"
                #
                # puts "               ... [format "%s(%s)" $_array $_name] $xpath"
                # puts "set_resultParameter   -> Length/FrontWheel/diagonal - check \$Geometry(FrontWheel_xy) $Geometry(FrontWheel_xy)"
                # set oldValue                $Geometry(FrontWheel_xy)
                # set newValue                $value
                # set newValue                [set_Value $xpath  $value format]
                # set _updateValue($xpath)    $newValue
                # puts "                 <D> ... $oldValue $newValue"
  
                # --- set HandleBar(Angle)
                #
            set vect_01     [ expr $Stem(Length) * cos($Stem(Angle) * $vectormath::CONST_PI / 180) ]
            set vect_02     [ expr $vect_01 - $Fork(Rake) ]
                #
            set FW_Distance_X_tmp  [ expr { sqrt( $value * $value - $FrontWheel(Distance_Y) * $FrontWheel(Distance_Y) ) } ]
            set FW_Position_tmp    [ list $FW_Distance_X_tmp $FrontWheel(Distance_Y)]
                #
            set help_03   [ vectormath::cathetusPoint   $HandleBar(Position)    $FW_Position_tmp    $vect_02  close ]
            set vect_HT   [ vectormath::parallel        $help_03                $FW_Position_tmp    $Fork(Rake) ]
                # puts "                 <D> ... $vect_HT"
                #
            set help_01  [ lindex $vect_HT 0]
            set help_02  [ lindex $vect_HT 1]
            set help_03  [list -200 [ lindex $help_02 1] ]
                #
            set HeadTube(Angle)         [vectormath::angle    $help_01 $help_02 $help_03 ]
                # set newValue                [vectormath::angle    $help_01 $help_02 $help_03 ]
                # set xpath                   Custom/HeadTube/Angle
                # set_Value                   $xpath     $newValue
                #
            bikeGeometry::update_Parameter
                #
            # puts "    <2> set_Result_FrontWheeldiagonal   ... check $Geometry(FrontWheel_xy)  ->  $value"
                #
            return $Geometry(FrontWheel_xy)
                #
    }
            #
    proc bikeGeometry::set_Result_SaddleOffset_HB       {_array _name value} {
                #
                # Length/Saddle/Offset_HB
                # Geometry(Saddle_HB_y)
                #
            variable Geometry
            variable HandleBar
                #
            # puts "    <1> set_Result_SaddleOffset_HB   ... check $Geometry(Saddle_HB_y)  ->  $value"
                #
                # puts "               ... [format "%s(%s)" $_array $_name] $xpath"
                # puts "set_resultParameter   -> Length/Saddle/Offset_HB - check \$Geometry(Saddle_HB_y) $Geometry(Saddle_HB_y)"
                # set oldValue                $Geometry(Saddle_HB_y)
                # set newValue                $value
                # set newValue                [set_Value $xpath  $value format ]
                # set _updateValue($xpath)    $newValue
    
            set delta                   [expr $Geometry(Saddle_HB_y) - $value ]
                # puts "          $newValue - $oldValue = $delta"
    
                # --- set HandleBar(Distance)
                #
            set HandleBar(Height)       [expr $HandleBar(Height)    + $delta ]
                # set newValue                [expr $HandleBar(Height)    + $delta ]
                # set xpath                   Personal/HandleBar_Height
                # set_Value                   $xpath     $newValue
                #
            bikeGeometry::update_Parameter
                #
            # puts "    <2> set_Result_SaddleOffset_HB   ... check $Geometry(Saddle_HB_y)  ->  $value"
                #
            return $Geometry(Saddle_HB_y)
                #
    }
            #
    proc bikeGeometry::set_Result_SaddleOffset_BB_ST    {_array _name value} {
                #
                # Length/Saddle/Offset_BB_ST
                # Geometry(Saddle_Offset_BB_ST)
                #
            variable Geometry
            variable Saddle
                #
            # puts "    <1> set_Result_SaddleOffset_BB_ST   ... check $Geometry(SaddleNose_BB_X)  ->  $value"
                #
                # puts "               ... [format "%s(%s)" $_array $_name] $xpath"
                # set newValue                $value
                # set newValue                [set_Value $xpath  $value format ]
                # puts "set_resultParameter   -> Length/Saddle/Offset_BB_ST - check \$Saddle(SaddleHeight)  $Saddle(SaddleHeight) "
                # set height                  $Saddle(Height)
            set angle                   [vectormath::dirAngle {0 0} [list $value $Saddle(Height)] ]
                #
            bikeGeometry::set_Result_SeatTubeDirection Result Angle/SeatTube/Direction $angle
                # set_resultParameter Result Angle/SeatTube/Direction $angle
                # puts "   $newValue / $height -> $angle"
            # ... done by set_Result_SeatTubeDirection
            # bikeGeometry::update_Parameter
                #
            # puts "    <2> set_Result_SaddleOffset_BB_ST   ... check $Geometry(SaddleNose_BB_X)  ->  $value"
                #
            return $Geometry(Saddle_Offset_BB_ST)
                #
    }
            #
    proc bikeGeometry::set_Result_SaddleOffset_BB_Nose  {_array _name value} {
                #
                # Length/Saddle/Offset_BB_Nose
                # Geometry(SaddleNose_BB_X)
                #
            variable Geometry     
            variable Saddle     
                #
            # puts "    <1> set_Result_SaddleOffset_BB_Nose   ... check $Geometry(SaddleNose_BB_X)  ->  $value"
                #
                # puts "               ... [format "%s(%s)" $_array $_name] $xpath"
                # puts "set_resultParameter   -> Length/Saddle/Offset_BB_Nose - check \$Geometry(SaddleNose_BB_X) $Geometry(SaddleNose_BB_X)"
                # set newValue                $value
                # set oldValue                $Geometry(SaddleNose_BB_X)
                # set newValue                [set_Value $xpath  $value format ]
            set delta                       [expr -1.0 * ($value - $Geometry(SaddleNose_BB_X)) ]
    
                
                # --- set Component(Saddle/LengthNose)
                #
                # puts "set_resultParameter   -> Length/Saddle/Offset_BB_Nose - check \$Rendering(SaddleOffset_X) $Rendering(SaddleOffset_X)"
                # set newValue                [expr $Saddle(Offset_X) + $delta ]
            set Saddle(Offset_X)            [expr $Saddle(Offset_X) + $delta ]
                # set xpath                   Rendering/Saddle/Offset_X
                # set_Value                   $xpath     $Saddle(Offset_X)                        
                #
            bikeGeometry::update_Parameter
                #
            # puts "    <2> set_Result_SaddleOffset_BB_Nose   ... check $Geometry(SaddleNose_BB_X)  ->  $value"
                #
            return $Geometry(SaddleNose_BB_X)
                #
    }
            #
    proc bikeGeometry::set_Result_SaddleSeatTube_BB     {_array _name value} {
                #
                # Length/Saddle/SeatTube_BB
                # Geometry(Saddle_BB)
                #
            variable Geometry
            variable Saddle
                #
            puts "    <1> set_Result_SaddleSeatTube_BB   ... check $Geometry(Saddle_BB)  ->  $value"
                # 
                # set newValue                $value
                # set newValue                [set_Value $xpath  $value format ]
                # set oldValue                $Geometry(Saddle_BB)
            set angle_SeatTube          $Geometry(SeatTube_Angle)
            set pos_SeatTube_old        $Geometry(SeatTubeSaddle)
            set pos_Saddle_old          $Saddle(Position)
                #
            set pos_SeatTube_x          [expr $value * cos([vectormath::rad $Geometry(SeatTube_Angle)])]
            set pos_SeatTube_y          [expr $value * sin([vectormath::rad $Geometry(SeatTube_Angle)])]
                #
            set delta_Saddle_ST         [expr [lindex $Saddle(Position) 0] - [lindex $Geometry(SeatTubeSaddle) 0]]
                #
            set pos_Saddle_x            [expr $pos_SeatTube_x - $delta_Saddle_ST]
            set pos_Saddle_y            $pos_SeatTube_y
                #
                # puts "  -> \$pos_SeatTube_old     $pos_SeatTube_old"
                # puts "  -> \$pos_Saddle_old       $pos_Saddle_old"
                # puts "  -> \$delta_Saddle_ST      $delta_Saddle_ST"
                # puts "  -> \$pos_Saddle_x     $pos_Saddle_x"
                # puts "  -> \$pos_Saddle_y     $pos_Saddle_y"
                #
            set Saddle(Distance)  [format "%.3f" $pos_Saddle_x]
            set Saddle(Height)    [format "%.3f" $pos_Saddle_y]
                # set xpath                   Personal/Saddle_Distance
                # set_Value                   $xpath     $Saddle(Distance) 
                #
            bikeGeometry::update_Parameter
                #                    
                # set xpath                   Personal/Saddle_Height
                # set_Value                   $xpath     $Saddle(Height)
                #
            puts "    <2> set_Result_SaddleSeatTube_BB   ... check $Geometry(Saddle_BB)  ->  $value"
                # 
            return $Geometry(Saddle_BB)                    
    }
            #  
    proc bikeGeometry::set_Result_PersonalSaddleNose_HB {_array _name value} {
                #
                # Length/Personal/SaddleNose_HB
                # Geometry(SaddleNose_HB
                #
            variable Geometry
            variable HandleBar      
                #
            # puts "    <1> set_Result_SaddleSeatTube_BB   ... check $Geometry(SaddleNose_HB)  ->  $value"
                #
                # puts "set_resultParameter   -> Length/Personal/SaddleNose_HB - check \$Geometry(SaddleNose_HB)  $Geometry(SaddleNose_HB)"
                # puts "set_resultParameter   -> Length/Personal/SaddleNose_HB - check \$HandleBar(Distance)  $HandleBar(Distance)"
                # set newValue                $value
                # set oldValue                $Geometry(SaddleNose_HB)
                # set newValue                [set_Value $xpath  $value format ]
            set delta                   [expr $value - $Geometry(SaddleNose_HB) ]
                
                # --- set Personal(HandleBar_Distance)
                #
            set HandleBar(Distance)     [expr $HandleBar(Distance) + $delta ]
                # set newValue                [expr $HandleBar(Distance) + $delta ]
                # set xpath                   Personal/HandleBar_Distance
                # set_Value                   $xpath     $newValue
                #
            bikeGeometry::update_Parameter
                #
            # puts "    <2> set_Result_SaddleSeatTube_BB   ... check $Geometry(SaddleNose_HB)  ->  $value"
                #
            return $Geometry(SaddleNose_HB)
                #            
    } 
            #
    proc bikeGeometry::set_Result_RearWheelRadius       {_array _name value} {
                #
                # ... unused ?
                #
                # Length/RearWheel/Radius
                # RearWheel(TyreHeight)
                #
            variable RearWheel
                #
                # puts "set_resultParameter   -> Length/RearWheel/Radius - check \$RearWheel(RimDiameter)  $RearWheel(RimDiameter)"
                # puts "set_resultParameter   -> Length/RearWheel/Radius - check \$RearWheel(TyreHeight)   $RearWheel(TyreHeight)"
                # set rimDiameter       $RearWheel(RimDiameter)
                # set tyreHeight        $RearWheel(TyreHeight)
            set RearWheel(TyreHeight)   [ expr $value - 0.5 * $RearWheel(RimDiameter)]
                # set xpath             Component/Wheel/Rear/TyreHeight
                # set_Value             $xpath     $newValue
                #
            bikeGeometry::update_Parameter
                #
            return $RearWheel(TyreHeight) 
                #
    }
            #
    proc bikeGeometry::set_Result_RearWheelTyreShoulder {_array _name value} {
                #
                # Length/RearWheel/TyreShoulder
                # RearWheel(TyreShoulder)
                #
            variable RearWheel
                #
            # puts "    <1> set_Result_RearWheelTyreShoulder   ... check $RearWheel(TyreShoulder)  ->  $value"
                #
                # puts "set_resultParameter   -> Length/RearWheel/TyreShoulder - check \$RearWheel(Radius)  $RearWheel(Radius)"
                # set wheelRadius   $RearWheel(Radius)
                # set xpath         Component/Wheel/Rear/TyreWidthRadius
            set RearWheel(TyreWidthRadius)  [ expr $RearWheel(Radius) - abs($value)]
                # set_Value         $xpath     $newValue
                #
            bikeGeometry::update_Parameter
                #
            # puts "    <2> set_Result_RearWheelTyreShoulder   ... check $RearWheel(TyreShoulder)  ->  $value"
                #
            return $RearWheel(TyreShoulder)
                #
    }
            #
    proc bikeGeometry::set_Result_FrontWheelRadius      {_array _name value} {
                #
                # ... unused ?
                #
                # Length/FrontWheel/Radius
                # FrontWheel(TyreHeight)
                #
            variable FrontWheel
                #
                # puts "set_resultParameter   -> Length/FrontWheel/Radius - check \$FrontWheel(RimDiameter)  $FrontWheel(RimDiameter)"
                # puts "set_resultParameter   -> Length/FrontWheel/Radius - check \$FrontWheel(TyreHeight)   $FrontWheel(TyreHeight)"
                # set rimDiameter   $FrontWheel(RimDiameter)
                # set tyreHeight    $FrontWheel(TyreHeight)
            set FrontWheel(TyreHeight)  [ expr $value - 0.5 * $FrontWheel(RimDiameter)]
                # set xpath         Component/Wheel/Front/TyreHeight
                # set_Value         $xpath     $newValue
                #
            bikeGeometry::update_Parameter
                #
            return $FrontWheel(TyreHeight) 
                #
    }
            #  
    proc bikeGeometry::set_Result_ReferenceHeigth_SN_HB {_array _name value} {
                #
                # Length/Reference/Heigth_SN_HB
                # Reference(SaddleNose_HB_y)
                #
            variable Reference
                #
            # puts "    <1> set_Result_ReferenceHeigth_SN_HB   ... check $Reference(SaddleNose_HB_y)  ->  $value"
                # puts "   -> $_name"
                # puts "set_resultParameter   -> Length/Reference/Heigth_SN_HB - check \$Reference(SaddleNose_HB_y)   $Reference(SaddleNose_HB_y)"
                # puts "set_resultParameter   -> Length/Reference/Heigth_SN_HB - check \$Reference(HandleBar_Height)  $Reference(HandleBar_Height)"
                # puts "set_resultParameter   -> Length/Reference/Heigth_SN_HB - check \$Reference(HandleBar_Height)  $Reference(HandleBar_Height)"
                # set newValue                    $value
                # set oldValue                    $Reference(SaddleNose_HB_y)
                # set newValue                [set_Value [format "%s(%s)" $_array $_name]  $value format ]
            set deltaValue                  [expr $value - $Reference(SaddleNose_HB_y)]
                # set xpath                   Reference/HandleBar_Height
                # set HandleBar_Height        $Reference(HandleBar_Height)                              
            set Reference(HandleBar_Height) [expr $Reference(HandleBar_Height) - $deltaValue]  
                # set_Value         $xpath    $HandleBar_Height
                #
            bikeGeometry::update_Parameter
                #
            # puts "    <2> set_Result_ReferenceHeigth_SN_HB   ... check $Reference(SaddleNose_HB_y)  ->  $value"
                #
            return $Reference(SaddleNose_HB_y)
                #
    } 
            #
    proc bikeGeometry::set_Result_ReferenceSaddleNose_HB {_array _name value} {
                #
                # Length/Reference/SaddleNose_HB
                # Reference(SaddleNose_HB)
                #
            variable Reference 
                #
            # puts "    <1> set_Result_ReferenceSaddleNose_HB   ... check $Reference(SaddleNose_HB)  ->  $value "
                # 
                # set newValue                    $value
                # set SaddleHeight                    $Reference(SaddleNose_HB_y)
                # set newValue                [set_Value [format "%s(%s)" $_array $_name]  $value format ]
            set Reference(HandleBar_Distance)   [ expr {sqrt( $value*$value - $Reference(SaddleNose_HB_y)*$Reference(SaddleNose_HB_y) )} ]
                # set Distance_HB             [ expr { sqrt( $newValue * $newValue - $SaddleHeight * $SaddleHeight ) } ]
                # set xpath                   Reference/HandleBar_Distance
                # set_Value         $xpath    $Distance_HB
                #
            bikeGeometry::update_Parameter
                #
            # puts "    <2> set_Result_ReferenceSaddleNose_HB   ... check $Reference(SaddleNose_HB)  ->  $value "
                #
            return $Reference(SaddleNose_HB)
                #
    }
  
    
    
    