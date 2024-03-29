 ##+##########################################################################
 #
 # package: rattleCAD    ->    lib_frame_geometry_custom.tcl
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
 #    namespace:  rattleCAD::frame_geometry_custom
 # ---------------------------------------------------------------------------
 #
 #

 
     
    
    #-------------------------------------------------------------------------
        #  compute all values of the project 
        #
        #    <T> ... should be renamed to compute_Project
        #
    proc bikeGeometry::set_base_Parameters {} {
            
            variable Project
            variable Geometry
            variable Reference
            variable Rendering
            
            variable BottomBracket
            variable RearWheel
            variable FrontWheel
            variable HandleBar
            variable Saddle
            variable SeatPost
            variable LegClearance
            
            variable HeadTube
            variable SeatTube
            variable DownTube
            variable TopTube
            variable ChainStay
            variable SeatStay
            variable Steerer
            variable ForkBlade

            variable Fork
            variable HeadSet
            variable Stem
            variable RearDrop

            variable RearBrake
            variable FrontBrake
            variable FrontDerailleur
            variable RearFender
            variable FrontFender
            variable RearCarrier
            variable FrontCarrier

            variable BottleCage
            variable FrameJig
            variable TubeMiter

            variable DEBUG_Geometry

              # appUtil::get_procHierarchy
              
            set DEBUG_Geometry(Base)        {0 0}


            get_from_project
                #
                #
                # --- set basePoints Attributes
                #
                # get_basePoints ... replaced ... 0.69 ... 2014.10.20
                #
            get_RearWheel
            get_FrontWheel
                #
            get_GeometryRear
            get_GeometryCenter
            get_GeometryFront
            get_BoundingBox
                #
            
                #
                # --- compute tubing geometry
                #
            check_Values
            
                #
            get_ChainStay
            get_ChainStay_RearMockup

                #
            get_HeadTube

                #
            get_DownTube_SeatTube
            
                #
            get_TopTube_SeatTube

                #
            get_SeatStay

                #
            get_Fork

                #
            get_Steerer

                #
            get_SeatPost

                #
            get_HeadSet

                #
            get_Stem
            
                #
            fill_resultValues
            
                #
                # --- compute components
                #
            get_DerailleurMountFront
            
                #
            get_CarrierMountRear

                #
            get_CarrierMountFront

                #
            get_BrakePositionRear

                #
            get_BrakePositionFront

                #
            get_BottleCageMount

                #
            get_FenderRear

                #
            get_FenderFront
            
                #
            get_FrameJig

                #
            get_TubeMiter
            
            
            # ----------------------------------
                # finally update projectDOM
            set_to_project
                #
			project::runTime_2_dom
            
    }


    proc bikeGeometry::get_from_project {} {
            
            variable Project
            variable Geometry
            variable Reference
            variable Rendering
            variable Result

            variable BottomBracket
            variable RearWheel
            variable FrontWheel
            variable HandleBar
            variable Saddle
            variable SeatPost
            variable LegClearance
            
            variable HeadTube
            variable SeatTube
            variable DownTube
            variable TopTube
            variable ChainStay
            variable SeatStay
            variable Steerer
            variable ForkBlade
            variable Lugs

            variable Fork
            variable HeadSet
            variable Stem
            variable RearDrop

            variable RearBrake
            variable FrontBrake
            variable FrontDerailleur
            variable RearFender
            variable FrontFender
            variable RearCarrier
            variable FrontCarrier

            variable BottleCage
            variable FrameJig
            variable TubeMiter

              # appUtil::get_procHierarchy


                #
                # --- get BottomBracket (1)
            set BottomBracket(depth)            $project::Custom(BottomBracket/Depth)
            set BottomBracket(outside)          $project::Lugs(BottomBracket/Diameter/outside)
            set BottomBracket(inside)           $project::Lugs(BottomBracket/Diameter/inside)
            set BottomBracket(width)            $project::Lugs(BottomBracket/Width)
            set BottomBracket(OffsetCS_TopView) $project::Lugs(BottomBracket/ChainStay/Offset_TopView)
                # check-Value-procedure
            if {[expr $BottomBracket(outside) -2.0] < $BottomBracket(inside)} {
                set BottomBracket(inside)       [expr $BottomBracket(outside) -2.0]
                set project::Lugs(BottomBracket/Diameter/inside) $BottomBracket(inside)
            }

                #
                # --- get RearWheel
            set RearWheel(RimDiameter)          $project::Component(Wheel/Rear/RimDiameter)
            set RearWheel(RimHeight)            $project::Component(Wheel/Rear/RimHeight)
            set RearWheel(TyreHeight)           $project::Component(Wheel/Rear/TyreHeight)
            set RearWheel(TyreWidthRadius)      $project::Component(Wheel/Rear/TyreWidthRadius)
            set RearWheel(DistanceBB)           $project::Custom(WheelPosition/Rear)
            set RearWheel(HubWidth)             $project::Component(Wheel/Rear/HubWidth)
            

                #
                # --- get FrontWheel
            set FrontWheel(RimDiameter)         $project::Component(Wheel/Front/RimDiameter)
            set FrontWheel(RimHeight)           $project::Component(Wheel/Front/RimHeight)
            set FrontWheel(TyreHeight)          $project::Component(Wheel/Front/TyreHeight)

                #
                # --- get HandleBarMount - Position
            set HandleBar(Distance)             $project::Personal(HandleBar_Distance)
            set HandleBar(Height)               $project::Personal(HandleBar_Height)


                #
                # --- get Fork -----------------------------
            set Fork(Height)                    $project::Component(Fork/Height)
            set Fork(Rake)                      $project::Component(Fork/Rake)
            set Fork(Rendering)                 $project::Rendering(Fork)
            set Fork(BladeRendering)            $project::Rendering(ForkBlade)
            set Fork(BladeWith)                 $project::Component(Fork/Blade/Width)
            set Fork(BladeDiameterDO)           $project::Component(Fork/Blade/DiameterDO)
            set Fork(BladeTaperLength)          $project::Component(Fork/Blade/TaperLength)
            set Fork(BladeBendRadius)           $project::Component(Fork/Blade/BendRadius)
            set Fork(BladeEndLength)            $project::Component(Fork/Blade/EndLength)
            set Fork(BladeOffsetCrown)          $project::Component(Fork/Crown/Blade/Offset)
            set Fork(BladeOffsetCrownPerp)      $project::Component(Fork/Crown/Blade/OffsetPerp)
            set Fork(BrakeAngle)                $project::Component(Fork/Crown/Brake/Angle)
            set Fork(BrakeOffset)               $project::Component(Fork/Crown/Brake/Offset)
            set Fork(CrownFile)                 $project::Component(Fork/Crown/File)                                     
            set Fork(CrownBrakeOffset)          $project::Component(Fork/Crown/Brake/Offset) 
            set Fork(CrownBrakeAngle)           $project::Component(Fork/Crown/Brake/Angle)
            set Fork(BladeOffsetDO)             $project::Component(Fork/DropOut/Offset)
            set Fork(BladeOffsetDOPerp)         $project::Component(Fork/DropOut/OffsetPerp)
            set Fork(DropOutFile)               $project::Component(Fork/DropOut/File)
                        
                #
                # --- get Stem -----------------------------
            set Stem(Angle)                     $project::Component(Stem/Angle)
            set Stem(Length)                    $project::Component(Stem/Length)

                #
                # --- get HeadTube -------------------------
            set HeadTube(ForkRake)              $Fork(Rake)
            set HeadTube(ForkHeight)            $Fork(Height)
            set HeadTube(ForkRake)              $project::Component(Fork/Rake)
            set HeadTube(ForkHeight)            $project::Component(Fork/Height)
            set HeadTube(Diameter)              $project::FrameTubes(HeadTube/Diameter)
            set HeadTube(Length)                $project::FrameTubes(HeadTube/Length)
            set HeadTube(Angle)                 $project::Custom(HeadTube/Angle)

                #
                # --- get SeatTube -------------------------
            set SeatTube(DiameterBB)            $project::FrameTubes(SeatTube/DiameterBB)
            set SeatTube(DiameterTT)            $project::FrameTubes(SeatTube/DiameterTT)
            set SeatTube(TaperLength)           $project::FrameTubes(SeatTube/TaperLength)
            set SeatTube(Extension)             $project::Custom(SeatTube/Extension)
            set SeatTube(OffsetBB)              $project::Custom(SeatTube/OffsetBB)

                #
                # --- get DownTube -------------------------
            set DownTube(DiameterBB)            $project::FrameTubes(DownTube/DiameterBB)
            set DownTube(DiameterHT)            $project::FrameTubes(DownTube/DiameterHT)
            set DownTube(TaperLength)           $project::FrameTubes(DownTube/TaperLength)
            set DownTube(OffsetHT)              $project::Custom(DownTube/OffsetHT)
            set DownTube(OffsetBB)              $project::Custom(DownTube/OffsetBB)

                #
                # --- get TopTube --------------------------
            set TopTube(DiameterHT)             $project::FrameTubes(TopTube/DiameterHT)
            set TopTube(DiameterST)             $project::FrameTubes(TopTube/DiameterST)
            set TopTube(TaperLength)            $project::FrameTubes(TopTube/TaperLength)
            set TopTube(PivotPosition)          $project::Custom(TopTube/PivotPosition)
            set TopTube(OffsetHT)               $project::Custom(TopTube/OffsetHT)
            set TopTube(Angle)                  $project::Custom(TopTube/Angle)

                #
                # --- get ChainStay ------------------------
            set ChainStay(HeigthBB)             $project::FrameTubes(ChainStay/HeightBB)
            set ChainStay(DiameterSS)           $project::FrameTubes(ChainStay/DiameterSS)
            set ChainStay(Height)               $project::FrameTubes(ChainStay/Height)
            set ChainStay(TaperLength)          $project::FrameTubes(ChainStay/TaperLength)
            set ChainStay(WidthBB)              $project::FrameTubes(ChainStay/WidthBB)
            set ChainStay(Rendering)            $project::Rendering(ChainStay)
            set ChainStay(profile_y00)          $project::FrameTubes(ChainStay/Profile/width_00)
            set ChainStay(profile_x01)          $project::FrameTubes(ChainStay/Profile/length_01)
            set ChainStay(profile_y01)          $project::FrameTubes(ChainStay/Profile/width_01)
            set ChainStay(profile_x02)          $project::FrameTubes(ChainStay/Profile/length_02)
            set ChainStay(profile_y02)          $project::FrameTubes(ChainStay/Profile/width_02)
            set ChainStay(profile_x03)          $project::FrameTubes(ChainStay/Profile/length_03)
            set ChainStay(profile_y03)          $project::FrameTubes(ChainStay/Profile/width_03)
            set ChainStay(completeLength)       $project::FrameTubes(ChainStay/Profile/completeLength) 
            set ChainStay(cuttingLength)        $project::FrameTubes(ChainStay/Profile/cuttingLength)            
            set ChainStay(segmentLength_01)     $project::FrameTubes(ChainStay/CenterLine/length_01)      
            set ChainStay(segmentLength_02)     $project::FrameTubes(ChainStay/CenterLine/length_02)      
            set ChainStay(segmentLength_03)     $project::FrameTubes(ChainStay/CenterLine/length_03)      
            set ChainStay(segmentLength_04)     $project::FrameTubes(ChainStay/CenterLine/length_04)  
                          
                          
            set ChainStay(segmentAngle_01)      $project::FrameTubes(ChainStay/CenterLine/angle_01)
            set ChainStay(segmentAngle_02)      $project::FrameTubes(ChainStay/CenterLine/angle_02)
            set ChainStay(segmentAngle_03)      $project::FrameTubes(ChainStay/CenterLine/angle_03)
            set ChainStay(segmentAngle_04)      $project::FrameTubes(ChainStay/CenterLine/angle_04)
            set ChainStay(segmentRadius_01)     $project::FrameTubes(ChainStay/CenterLine/radius_01)
            set ChainStay(segmentRadius_02)     $project::FrameTubes(ChainStay/CenterLine/radius_02)
            set ChainStay(segmentRadius_03)     $project::FrameTubes(ChainStay/CenterLine/radius_03)
            set ChainStay(segmentRadius_04)     $project::FrameTubes(ChainStay/CenterLine/radius_04)
            
                #
                # --- get SeatStay -------------------------
            set SeatStay(DiameterST)            $project::FrameTubes(SeatStay/DiameterST)
            set SeatStay(DiameterCS)            $project::FrameTubes(SeatStay/DiameterCS)
            set SeatStay(TaperLength)           $project::FrameTubes(SeatStay/TaperLength)
            set SeatStay(OffsetTT)              $project::Custom(SeatStay/OffsetTT)

                #
                # --- get RearDropOut ----------------------
            set RearDrop(Direction)             $project::Lugs(RearDropOut/Direction)
            set RearDrop(RotationOffset)        $project::Lugs(RearDropOut/RotationOffset)
            set RearDrop(OffsetCS)              $project::Lugs(RearDropOut/ChainStay/Offset)
            set RearDrop(OffsetCSPerp)          $project::Lugs(RearDropOut/ChainStay/OffsetPerp)
            set RearDrop(OffsetSS)              $project::Lugs(RearDropOut/SeatStay/Offset)
            set RearDrop(OffsetSSPerp)          $project::Lugs(RearDropOut/SeatStay/OffsetPerp)
            set RearDrop(Derailleur_x)          $project::Lugs(RearDropOut/Derailleur/x)
            set RearDrop(Derailleur_y)          $project::Lugs(RearDropOut/Derailleur/y)
            set RearDrop(OffsetCS_TopView)      $project::Lugs(RearDropOut/ChainStay/Offset_TopView)

                #
                # --- get Saddle ---------------------------
            set Saddle(Distance)                $project::Personal(Saddle_Distance)
            set Saddle(Height)                  $project::Personal(Saddle_Height)
            set Saddle(Saddle_Height)           $project::Component(Saddle/Height)
            set Saddle(Nose_Length)             $project::Component(Saddle/LengthNose)
                # check-Value-procedure
            if {$Saddle(Saddle_Height) < 0} {
                set Saddle(Saddle_Height) 0
                # set project::Component(Saddle/Height) $Saddle(Saddle_Height)
            }
            set Saddle(Position)                [ list [expr -1.0*$Saddle(Distance)]  $Saddle(Height) ]

                #
                # --- get SaddleMount - Position
            set SeatPost(Diameter)              $project::Component(SeatPost/Diameter)
            set SeatPost(Setback)               $project::Component(SeatPost/Setback)
            set SeatPost(PivotOffset)           $project::Component(SeatPost/PivotOffset)

                #
                # --- get LegClearance - Position
            set LegClearance(Length)            $project::Personal(InnerLeg_Length)

                #
                # --- get Saddle ---------------------------
 
                #
                # --- get HeadSet --------------------------
            set HeadSet(Diameter)               $project::Component(HeadSet/Diameter)
            set HeadSet(Height_Top)             $project::Component(HeadSet/Height/Top)
            set HeadSet(Height_Bottom)          $project::Component(HeadSet/Height/Bottom)
            set HeadSet(ShimDiameter)           36

                #
                # --- get Front/Rear Brake PadLever --------------
            set RearBrake(LeverLength)          $project::Component(Brake/Rear/LeverLength)
            set RearBrake(Offset)               $project::Component(Brake/Rear/Offset)
            set FrontBrake(LeverLength)         $project::Component(Brake/Front/LeverLength)
            set FrontBrake(Offset)              $project::Component(Brake/Front/Offset)

                #
                # --- get BottleCage Offset ----------------------
            set BottleCage(SeatTube)            $project::Component(BottleCage/SeatTube/OffsetBB)
            set BottleCage(DownTube)            $project::Component(BottleCage/DownTube/OffsetBB)
            set BottleCage(DownTube_Lower)      $project::Component(BottleCage/DownTube_Lower/OffsetBB)

                #
                # --- get FrontDerailleur  ----------------------
            set FrontDerailleur(Distance)       $project::Component(Derailleur/Front/Distance)
            set FrontDerailleur(Offset)         $project::Component(Derailleur/Front/Offset)

                #
                # --- get Fender  -------------------------------
            set RearFender(Radius)              $project::Component(Fender/Rear/Radius)
            set RearFender(OffsetAngle)         $project::Component(Fender/Rear/OffsetAngle)
            set RearFender(Height)              $project::Component(Fender/Rear/Height)
            set FrontFender(Radius)             $project::Component(Fender/Front/Radius)
            set FrontFender(OffsetAngleFront)   $project::Component(Fender/Front/OffsetAngleFront)
            set FrontFender(OffsetAngle)        $project::Component(Fender/Front/OffsetAngle)
            set FrontFender(Height)             $project::Component(Fender/Front/Height)
            
                #
                # --- get Carrier  ------------------------------
            set RearCarrier(x)                  $project::Component(Carrier/Rear/x)
            set RearCarrier(y)                  $project::Component(Carrier/Rear/y)
            set FrontCarrier(x)                 $project::Component(Carrier/Front/x)
            set FrontCarrier(y)                 $project::Component(Carrier/Front/y)
            
                #
            set Rendering(SaddleOffset_x)       $project::Rendering(Saddle/Offset_X)    
                
                #
            set Reference(SaddleNose_Distance)  $project::Reference(SaddleNose_Distance)
            set Reference(SaddleNose_Height)    $project::Reference(SaddleNose_Height)
            set Reference(HandleBar_Distance)   $project::Reference(HandleBar_Distance)
            set Reference(HandleBar_Height)     $project::Reference(HandleBar_Height)
            
                #
                # --- set DEBUG_Geometry  ----------------------
            set DEBUG_Geometry(Base)        {0 0}
               
    }


    proc bikeGeometry::set_to_project {} {
            
            variable Project
            variable Geometry 
            variable Rendering
            variable Reference

            variable BottomBracket
            variable RearWheel
            variable FrontWheel
            variable HandleBar
            variable Saddle
            variable SeatPost
            variable LegClearance
            
            variable HeadTube
            variable SeatTube
            variable DownTube
            variable TopTube
            variable ChainStay
            variable SeatStay
            variable Steerer
            variable ForkBlade
            variable Lugs

            variable Fork
            variable HeadSet
            variable Stem
            variable RearDrop

            variable RearBrake
            variable FrontBrake
            variable FrontDerailleur
            variable RearFender
            variable FrontFender
            variable RearCarrier
            variable FrontCarrier

            variable BottleCage
            variable FrameJig
            variable TubeMiter
            
            variable Result
    

    
                # -- Re3sult Values
            
            project::setValue Result(Angle/BottomBracket/ChainStay)                 value       $Result(Angle/BottomBracket/ChainStay)
            project::setValue Result(Angle/BottomBracket/DownTube)                  value       $Result(Angle/BottomBracket/DownTube)
            project::setValue Result(Angle/HeadTube/DownTube)                       value       $Result(Angle/HeadTube/DownTube)
            project::setValue Result(Angle/HeadTube/TopTube)                        value       $Result(Angle/HeadTube/TopTube)
            project::setValue Result(Angle/SeatStay/ChainStay)                      value       $Result(Angle/SeatStay/ChainStay)
            project::setValue Result(Angle/SeatTube/Direction)                      value       $Geometry(SeatTube_Angle)
            # project::setValue Result(Angle/SeatTube/Direction)                      value       $Result(Angle/SeatTube/Direction)
            project::setValue Result(Angle/SeatTube/SeatStay)                       value       $Result(Angle/SeatTube/SeatStay)
            project::setValue Result(Angle/SeatTube/TopTube)                        value       $Result(Angle/SeatTube/TopTube)
            project::setValue Result(Length/BottomBracket/Height)                   value       $BottomBracket(height)
            # project::setValue Result(Length/BottomBracket/Height)                   value       $Result(Length/BottomBracket/Height)
            project::setValue Result(Length/FrontWheel/Diameter)                    value       $FrontWheel(Diameter)
            # project::setValue Result(Length/FrontWheel/Diameter)                    value       $Result(Length/FrontWheel/Diameter)
            project::setValue Result(Length/FrontWheel/Radius)                      value       $FrontWheel(Radius)
            # project::setValue Result(Length/FrontWheel/Radius)                      value       $Result(Length/FrontWheel/Radius)
            project::setValue Result(Length/FrontWheel/diagonal)                    value       $Geometry(FrontWheel_xy)
            # project::setValue Result(Length/FrontWheel/diagonal)                    value       $Result(Length/FrontWheel/diagonal)
            project::setValue Result(Length/FrontWheel/horizontal)                  value       $Geometry(FrontWheel_x)
            # project::setValue Result(Length/FrontWheel/horizontal)                  value       $Result(Length/FrontWheel/horizontal)
            project::setValue Result(Length/HeadTube/ReachLength)                   value       $Geometry(ReachLengthResult)
            # project::setValue Result(Length/HeadTube/ReachLength)                   value       $Result(Length/HeadTube/ReachLength)
            project::setValue Result(Length/HeadTube/StackHeight)                   value       $Geometry(StackHeightResult)
            # project::setValue Result(Length/HeadTube/StackHeight)                   value       $Result(Length/HeadTube/StackHeight)
            project::setValue Result(Length/Personal/SaddleNose_HB)                 value       $Geometry(SaddleNose_HB)
            # project::setValue Result(Length/Personal/SaddleNose_HB)                 value       $Result(Length/Personal/SaddleNose_HB)
            project::setValue Result(Length/RearWheel/Diameter)                     value       $RearWheel(Diameter)                                  
            # project::setValue Result(Length/RearWheel/Diameter)                     value       $Result(Length/RearWheel/Diameter)                                  
            project::setValue Result(Length/RearWheel/Radius)                       value       $RearWheel(Radius)                                    
            # project::setValue Result(Length/RearWheel/Radius)                       value       $Result(Length/RearWheel/Radius)                                    
            project::setValue Result(Length/RearWheel/TyreShoulder)                 value       $RearWheel(TyreShoulder)                             
            # project::setValue Result(Length/RearWheel/TyreShoulder)                 value       $Result(Length/RearWheel/TyreShoulder)                             
            project::setValue Result(Length/RearWheel/horizontal)                   value       $Geometry(RearWheel_x)                               
            # project::setValue Result(Length/RearWheel/horizontal)                   value       $Result(Length/RearWheel/horizontal)                               
            project::setValue Result(Length/Reference/HandleBar_BB)                 value       $Result(Length/Reference/HandleBar_BB)                             
            project::setValue Result(Length/Reference/HandleBar_FW)                 value       $Result(Length/Reference/HandleBar_FW)                             
            project::setValue Result(Length/Reference/Heigth_SN_HB)                 value       $Result(Length/Reference/Heigth_SN_HB)                             
            project::setValue Result(Length/Reference/SaddleNose_BB)                value       $Result(Length/Reference/SaddleNose_BB)                            
            project::setValue Result(Length/Reference/SaddleNose_HB)                value       $Result(Length/Reference/SaddleNose_HB)                            
            project::setValue Result(Length/Saddle/Offset_BB)                       value       $Result(Length/Saddle/Offset_BB)                                   
            project::setValue Result(Length/Saddle/Offset_BB_Nose)                  value       $Geometry(SaddleNose_BB_x)                              
            # project::setValue Result(Length/Saddle/Offset_BB_Nose)                  value       $Result(Length/Saddle/Offset_BB_Nose)                              
            project::setValue Result(Length/Saddle/Offset_BB_ST)                    value       $Result(Length/Saddle/Offset_BB_ST)                                
            project::setValue Result(Length/Saddle/Offset_HB)                       value       $Geometry(Saddle_HB_y)                                   
            # project::setValue Result(Length/Saddle/Offset_HB)                       value       $Result(Length/Saddle/Offset_HB)                                   
            project::setValue Result(Length/Saddle/SeatTube_BB)                     value       $Geometry(Saddle_BB)                                 
            # project::setValue Result(Length/Saddle/SeatTube_BB)                     value       $Result(Length/Saddle/SeatTube_BB)                                 
            project::setValue Result(Length/SeatTube/TubeHeight)                    value       $Result(Length/SeatTube/TubeHeight)                                
            project::setValue Result(Length/SeatTube/TubeLength)                    value       $Result(Length/SeatTube/TubeLength)                                
            project::setValue Result(Length/SeatTube/VirtualLength)                 value       $Geometry(SeatTube_VirtualLength)                            
            # project::setValue Result(Length/SeatTube/VirtualLength)                 value       $Result(Length/SeatTube/VirtualLength)                             
            project::setValue Result(Length/TopTube/VirtualLength)                  value       $Geometry(TopTube_VirtualLength)                              
            # project::setValue Result(Length/TopTube/VirtualLength)                  value       $TopTube(VirtualLength)                              
            # project::setValue Result(Length/TopTube/VirtualLength)                  value       $Result(Length/TopTube/VirtualLength)                              
            project::setValue Result(Tubes/ChainStay/CenterLine)                    value       $ChainStay(CenterLine)                                
            # project::setValue Result(Tubes/ChainStay/CenterLine)                    value       $Result(Tubes/ChainStay/CenterLine)                                
            project::setValue Result(Tubes/ChainStay/Profile/xy)                    value       $ChainStay(Polygon_zx)                                 
            # project::setValue Result(Tubes/ChainStay/Profile/xz)                    value       $Result(Tubes/ChainStay/Profile/xz)                                 
            project::setValue Result(Tubes/ChainStay/RearMockup/CenterLine)         value       $Result(Tubes/ChainStay/RearMockup/CenterLine)                     
            project::setValue Result(Tubes/ChainStay/RearMockup/CenterLineUnCut)    value       $Result(Tubes/ChainStay/RearMockup/CenterLineUnCut)                
            project::setValue Result(Tubes/ChainStay/RearMockup/CtrLines)           value       $Result(Tubes/ChainStay/RearMockup/CtrLines)                       
            project::setValue Result(Tubes/ChainStay/RearMockup/Start)              value       $Result(Tubes/ChainStay/RearMockup/Start)                          
            project::setValue Result(Tubes/DownTube/CenterLine)                     value       $Result(Tubes/DownTube/CenterLine)                                                
            project::setValue Result(Tubes/DownTube/Profile/xy)                     value       $Result(Tubes/DownTube/Profile/xy)                                   
            project::setValue Result(Tubes/DownTube/Profile/xz)                     value       $Result(Tubes/DownTube/Profile/xz)                                   
            project::setValue Result(Tubes/ForkBlade/CenterLine)                    value       $Result(Tubes/ForkBlade/CenterLine)                                
            project::setValue Result(Tubes/HeadTube/CenterLine)                     value       $Result(Tubes/HeadTube/CenterLine)                                   
            project::setValue Result(Tubes/HeadTube/Profile/xy)                     value       $Result(Tubes/HeadTube/Profile/xy)                                   
            project::setValue Result(Tubes/HeadTube/Profile/xz)                     value       $Result(Tubes/HeadTube/Profile/xz)                                   
            project::setValue Result(Tubes/SeatStay/CenterLine)                     value       $Result(Tubes/SeatStay/CenterLine)                                   
            project::setValue Result(Tubes/SeatStay/Profile/xy)                     value       $Result(Tubes/SeatStay/Profile/xy)                                   
            project::setValue Result(Tubes/SeatStay/Profile/xz)                     value       $Result(Tubes/SeatStay/Profile/xz)                                   
            project::setValue Result(Tubes/SeatTube/CenterLine)                     value       $Result(Tubes/SeatTube/CenterLine)                                   
            project::setValue Result(Tubes/SeatTube/Profile/xy)                     value       $Result(Tubes/SeatTube/Profile/xy)
            project::setValue Result(Tubes/SeatTube/Profile/xz)                     value       $Result(Tubes/SeatTube/Profile/xz)
            project::setValue Result(Tubes/Steerer/CenterLine)                      value       $Steerer(CenterLine)
            # project::setValue Result(Tubes/Steerer/CenterLine)                      value       $Result(Tubes/Steerer/CenterLine)
            project::setValue Result(Tubes/TopTube/CenterLine)                      value       $Result(Tubes/TopTube/CenterLine)                                    
            project::setValue Result(Tubes/TopTube/Profile/xy)                      value       $Result(Tubes/TopTube/Profile/xy)                                     
            project::setValue Result(Tubes/TopTube/Profile/xz)                      value       $Result(Tubes/TopTube/Profile/xz)                                     
                #
                #
            project::setValue Result(Lugs/Dropout/Front/Direction)                  direction   $Fork(DropoutDirection)                              
            # project::setValue Result(Lugs/Dropout/Front/Direction)                  direction   $Result(Lugs/Dropout/Front/Direction)                              
            project::setValue Result(Lugs/ForkCrown/Direction)                      direction   $Fork(CrownDirection)                                  
            # project::setValue Result(Lugs/ForkCrown/Direction)                      direction   $Result(Lugs/ForkCrown/Direction)                                  
            project::setValue Result(Tubes/ChainStay/Direction)                     direction   $ChainStay(Direction)                                 
            # project::setValue Result(Tubes/ChainStay/Direction)                     direction   $Result(Tubes/ChainStay/Direction)                                 
            project::setValue Result(Tubes/DownTube/Direction)                      direction   $DownTube(Direction)                                     
            # project::setValue Result(Tubes/DownTube/Direction)                      direction   $Result(Tubes/DownTube/Direction)                                     
            project::setValue Result(Tubes/HeadTube/Direction)                      direction   $HeadTube(Direction)                                     
            # project::setValue Result(Tubes/HeadTube/Direction)                      direction   $Result(Tubes/HeadTube/Direction)                                     
            project::setValue Result(Tubes/SeatStay/Direction)                      direction   $SeatStay(Direction)                                     
            # project::setValue Result(Tubes/SeatStay/Direction)                      direction   $Result(Tubes/SeatStay/Direction)                                     
            project::setValue Result(Tubes/SeatTube/Direction)                      direction   $SeatTube(Direction)                                  
            # project::setValue Result(Tubes/SeatTube/Direction)                      direction   $Result(Tubes/SeatTube/Direction)                                  
            project::setValue Result(Tubes/Steerer/Direction)                       direction   $HeadTube(Direction)
            # project::setValue Result(Tubes/Steerer/Direction)                       direction   $Result(Tubes/Steerer/Direction)
            project::setValue Result(Tubes/TopTube/Direction)                       direction   $TopTube(Direction)                                     
            # project::setValue Result(Tubes/TopTube/Direction)                       direction   $Result(Tubes/TopTube/Direction)                                     
                #
                #
            project::setValue Result(Components/Fender/Front/Polygon)               polygon     $FrontFender(Polygon)
            # project::setValue Result(Components/Fender/Front/Polygon)               polygon     $Result(Components/Fender/Front/Polygon)
            project::setValue Result(Components/Fender/Rear/Polygon)                polygon     $RearFender(Polygon)
            # project::setValue Result(Components/Fender/Rear/Polygon)                polygon     $Result(Components/Fender/Rear/Polygon)
            project::setValue Result(Components/HeadSet/Bottom/Polygon)             polygon     $HeadSet(PolygonBottom)
            # project::setValue Result(Components/HeadSet/Bottom/Polygon)             polygon     $Result(Components/HeadSet/Bottom/Polygon)
            project::setValue Result(Components/HeadSet/Top/Polygon)                polygon     $HeadSet(PolygonTop)
            # project::setValue Result(Components/HeadSet/Top/Polygon)                polygon     $Result(Components/HeadSet/Top/Polygon)
            project::setValue Result(Components/SeatPost/Polygon)                   polygon     $SeatPost(Polygon)
            # project::setValue Result(Components/SeatPost/Polygon)                   polygon     $Result(Components/SeatPost/Polygon)
            project::setValue Result(Components/Stem/Polygon)                       polygon     $Stem(Polygon)
            # project::setValue Result(Components/Stem/Polygon)                       polygon     $Result(Components/Stem/Polygon)
            project::setValue Result(TubeMiter/DownTube_BB_in/Polygon)              polygon     $TubeMiter(DownTube_BB_in)                                  
            # project::setValue Result(TubeMiter/DownTube_BB_in/Polygon)              polygon     $Result(TubeMiter/DownTube_BB_in/Polygon)                                  
            project::setValue Result(TubeMiter/DownTube_BB_out/Polygon)             polygon     $TubeMiter(DownTube_BB_out)                                 
            # project::setValue Result(TubeMiter/DownTube_BB_out/Polygon)             polygon     $Result(TubeMiter/DownTube_BB_out/Polygon)                                 
            project::setValue Result(TubeMiter/DownTube_Head/Polygon)               polygon     $TubeMiter(DownTube_Head)                                   
            # project::setValue Result(TubeMiter/DownTube_Head/Polygon)               polygon     $Result(TubeMiter/DownTube_Head/Polygon)                                   
            project::setValue Result(TubeMiter/DownTube_Seat/Polygon)               polygon     $TubeMiter(DownTube_Seat)                                   
            # project::setValue Result(TubeMiter/DownTube_Seat/Polygon)               polygon     $Result(TubeMiter/DownTube_Seat/Polygon)                                   
            project::setValue Result(TubeMiter/Reference/Polygon)                   polygon     $TubeMiter(Reference)                                       
            # project::setValue Result(TubeMiter/Reference/Polygon)                   polygon     $Result(TubeMiter/Reference/Polygon)                                       
            project::setValue Result(TubeMiter/SeatStay_01/Polygon)                 polygon     $TubeMiter(SeatStay_01)                                     
            # project::setValue Result(TubeMiter/SeatStay_01/Polygon)                 polygon     $Result(TubeMiter/SeatStay_01/Polygon)                                     
            project::setValue Result(TubeMiter/SeatStay_02/Polygon)                 polygon     $TubeMiter(SeatStay_02)             
            # project::setValue Result(TubeMiter/SeatStay_02/Polygon)                 polygon     $Result(TubeMiter/SeatStay_02/Polygon)                                     
            project::setValue Result(TubeMiter/SeatTube_BB_in/Polygon)              polygon     $TubeMiter(SeatTube_BB_in)                                  
            # project::setValue Result(TubeMiter/SeatTube_BB_in/Polygon)              polygon     $Result(TubeMiter/SeatTube_BB_in/Polygon)                                  
            project::setValue Result(TubeMiter/SeatTube_BB_out/Polygon)             polygon     $TubeMiter(SeatTube_BB_out)                                
            # project::setValue Result(TubeMiter/SeatTube_BB_out/Polygon)             polygon     $Result(TubeMiter/SeatTube_BB_out/Polygon)                                 
            project::setValue Result(TubeMiter/SeatTube_Down/Polygon)               polygon     $TubeMiter(SeatTube_Down)                                   
            # project::setValue Result(TubeMiter/SeatTube_Down/Polygon)               polygon     $Result(TubeMiter/SeatTube_Down/Polygon)                                   
            project::setValue Result(TubeMiter/TopTube_Head/Polygon)                polygon     $TubeMiter(TopTube_Head)                                    
            # project::setValue Result(TubeMiter/TopTube_Head/Polygon)                polygon     $Result(TubeMiter/TopTube_Head/Polygon)                                    
            project::setValue Result(TubeMiter/TopTube_Seat/Polygon)                polygon     $TubeMiter(TopTube_Seat)                                    
            # project::setValue Result(TubeMiter/TopTube_Seat/Polygon)                polygon     $Result(TubeMiter/TopTube_Seat/Polygon)                                    
            project::setValue Result(Tubes/ChainStay/Polygon)                       polygon     $ChainStay(Polygon)                                                    
            # project::setValue Result(Tubes/ChainStay/Polygon)                       polygon     $Result(Tubes/ChainStay/Polygon)                                                    
            project::setValue Result(Tubes/ChainStay/RearMockup/Polygon)            polygon     $ChainStay(Polygon_RearMockup)                                
            # project::setValue Result(Tubes/ChainStay/RearMockup/Polygon)            polygon     $Result(Tubes/ChainStay/RearMockup/Polygon)                                
            project::setValue Result(Tubes/DownTube/Polygon)                        polygon     $DownTube(Polygon)                                             
            # project::setValue Result(Tubes/DownTube/Polygon)                        polygon     $Result(Tubes/DownTube/Polygon)                                             
            project::setValue Result(Tubes/ForkBlade/Polygon)                       polygon     $ForkBlade(Polygon)                                           
            # project::setValue Result(Tubes/ForkBlade/Polygon)                       polygon     $Result(Tubes/ForkBlade/Polygon)                                                
            project::setValue Result(Tubes/HeadTube/Polygon)                        polygon     $HeadTube(Polygon)                                             
            # project::setValue Result(Tubes/HeadTube/Polygon)                        polygon     $Result(Tubes/HeadTube/Polygon)                                             
            project::setValue Result(Tubes/SeatStay/Polygon)                        polygon     $SeatStay(Polygon)                                               
            # project::setValue Result(Tubes/SeatStay/Polygon)                        polygon     $Result(Tubes/SeatStay/Polygon)                                               
            project::setValue Result(Tubes/SeatTube/Polygon)                        polygon     $SeatTube(Polygon)
            # project::setValue Result(Tubes/SeatTube/Polygon)                        polygon     $Result(Tubes/SeatTube/Polygon)
            project::setValue Result(Tubes/Steerer/Polygon)                         polygon     $Steerer(Polygon)
            # project::setValue Result(Tubes/Steerer/Polygon)                         polygon     $Result(Tubes/Steerer/Polygon)                                               
            project::setValue Result(Tubes/TopTube/Polygon)                         polygon     $TopTube(Polygon)                                             
            # project::setValue Result(Tubes/TopTube/Polygon)                         polygon     $Result(Tubes/TopTube/Polygon)                                             
                #
                #
            project::setValue Result(Lugs/Dropout/Front/Position)                   position    $Fork(Dropout)
            project::setValue Result(Lugs/Dropout/Rear/Derailleur)                  position    $Lugs(RearDropout_Derailleur)                              
            # project::setValue Result(Lugs/Dropout/Rear/Derailleur)                  position    $Result(Lugs/Dropout/Rear/Derailleur)                              
            project::setValue Result(Lugs/Dropout/Rear/Position)                    position    $Lugs(RearDropout)                                
            # project::setValue Result(Lugs/Dropout/Rear/Position)                    position    $Result(Lugs/Dropout/Rear/Position)                                
            project::setValue Result(Lugs/ForkCrown/Position)                       position    $Steerer(Fork)
            project::setValue Result(Position/BottomBracketGround)                  position    $BottomBracket(Ground)                              
            # project::setValue Result(Position/BottomBracketGround)                  position    $Result(Position/BottomBracketGround)                              
            project::setValue Result(Position/Brake/Front/Definition)               position    $FrontBrake(Definition)                           
            project::setValue Result(Position/Brake/Front/Help)                     position    $FrontBrake(Help)                                 
            project::setValue Result(Position/Brake/Front/Mount)                    position    $FrontBrake(Mount)                                
            project::setValue Result(Position/Brake/Front/Shoe)                     position    $FrontBrake(Shoe)                                 
            # project::setValue Result(Position/Brake/Front/Definition)               position    $Result(Position/Brake/Front/Definition)                           
            # project::setValue Result(Position/Brake/Front/Help)                     position    $Result(Position/Brake/Front/Help)                                 
            # project::setValue Result(Position/Brake/Front/Mount)                    position    $Result(Position/Brake/Front/Mount)                                
            # project::setValue Result(Position/Brake/Front/Shoe)                     position    $Result(Position/Brake/Front/Shoe)                                 
            project::setValue Result(Position/Brake/Rear/Definition)                position    $RearBrake(Definition)                            
            project::setValue Result(Position/Brake/Rear/Help)                      position    $RearBrake(Help)                                  
            project::setValue Result(Position/Brake/Rear/Mount)                     position    $RearBrake(Mount)                                 
            project::setValue Result(Position/Brake/Rear/Shoe)                      position    $RearBrake(Shoe)                                  
            # project::setValue Result(Position/Brake/Rear/Definition)                position    $Result(Position/Brake/Rear/Definition)                            
            # project::setValue Result(Position/Brake/Rear/Help)                      position    $Result(Position/Brake/Rear/Help)                                  
            # project::setValue Result(Position/Brake/Rear/Mount)                     position    $Result(Position/Brake/Rear/Mount)                                 
            # project::setValue Result(Position/Brake/Rear/Shoe)                      position    $Result(Position/Brake/Rear/Shoe)                                  
            project::setValue Result(Position/BrakeFront)                           position    $FrontBrake(Shoe)                                            
            # project::setValue Result(Position/BrakeFront)                           position    $Result(Position/BrakeFront)                                            
            project::setValue Result(Position/BrakeRear)                            position    $RearBrake(Shoe)                                               
            # project::setValue Result(Position/BrakeRear)                            position    $Result(Position/BrakeRear)                                               
            project::setValue Result(Position/CarrierMountFront)                    position    $FrontCarrier(Mount)                                
            # project::setValue Result(Position/CarrierMountFront)                    position    $Result(Position/CarrierMountFront)                                
            project::setValue Result(Position/CarrierMountRear)                     position    $RearCarrier(Mount)                                
            # project::setValue Result(Position/CarrierMountRear)                     position    $Result(Position/CarrierMountRear)                                 
            project::setValue Result(Position/DerailleurMountFront)                 position    $FrontDerailleur(Mount)                             
            # project::setValue Result(Position/DerailleurMountFront)                 position    $Result(Position/DerailleurMountFront)                             
            project::setValue Result(Position/FrontWheel)                           position    $FrontWheel(Position)
            project::setValue Result(Position/HandleBar)                            position    $HandleBar(Position)
            project::setValue Result(Position/LegClearance)                         position    $Geometry(LegClearance)                                     
            # project::setValue Result(Position/LegClearance)                         position    $Result(Position/LegClearance)                                     
            project::setValue Result(Position/RearWheel)                            position    $RearWheel(Position)                                        
            # project::setValue Result(Position/RearWheel)                            position    $Result(Position/RearWheel)                                        
            project::setValue Result(Position/Reference_HB)                         position    $Reference(HandleBar)                                       
            project::setValue Result(Position/Reference_SN)                         position    $Reference(SaddleNose)                                       
            # project::setValue Result(Position/Reference_HB)                         position    $Result(Position/Reference_HB)                                       
            # project::setValue Result(Position/Reference_SN)                         position    $Result(Position/Reference_SN)                                       
            project::setValue Result(Position/Saddle)                               position    $Saddle(Position)                                           
            project::setValue Result(Position/SaddleNose)                           position    $Saddle(Nose)                                       
            project::setValue Result(Position/SaddleProposal)                       position    $Saddle(Proposal)                                   
            # project::setValue Result(Position/Saddle)                               position    $Result(Position/Saddle)                                           
            # project::setValue Result(Position/SaddleNose)                           position    $Result(Position/SaddleNose)                                       
            # project::setValue Result(Position/SaddleProposal)                       position    $Result(Position/SaddleProposal)                                   
            project::setValue Result(Position/SeatPostPivot)                        position    $SeatPost(PivotPosition)                                    
            project::setValue Result(Position/SeatPostSaddle)                       position    $SeatPost(Saddle)                                   
            project::setValue Result(Position/SeatPostSeatTube)                     position    $SeatPost(SeatTube)                                 
            # project::setValue Result(Position/SeatPostPivot)                        position    $Result(Position/SeatPostPivot)                                    
            # project::setValue Result(Position/SeatPostSaddle)                       position    $Result(Position/SeatPostSaddle)                                   
            # project::setValue Result(Position/SeatPostSeatTube)                     position    $Result(Position/SeatPostSeatTube)                                 
            project::setValue Result(Position/SeatTubeGround)                       position    $SeatTube(Ground)                                   
            project::setValue Result(Position/SeatTubeSaddle)                       position    $Geometry(SeatTubeSaddle)                                   
            # project::setValue Result(Position/SeatTubeGround)                       position    $Result(Position/SeatTubeGround)                                   
            # project::setValue Result(Position/SeatTubeSaddle)                       position    $Result(Position/SeatTubeSaddle)                                   
            project::setValue Result(Position/SeatTubeVirtualTopTube)               position    $SeatTube(VirtualTopTube)                           
            # project::setValue Result(Position/SeatTubeVirtualTopTube)               position    $Result(Position/SeatTubeVirtualTopTube)                           
            project::setValue Result(Position/SteererGround)                        position    $Steerer(Ground)      
            project::setValue Result(Tubes/ChainStay/End)                           position    $ChainStay(BottomBracket)                                       
            # project::setValue Result(Tubes/ChainStay/End)                           position    $Result(Tubes/ChainStay/End)                                       
            project::setValue Result(Tubes/ChainStay/SeatStay_IS)                   position    $ChainStay(SeatStay_IS)                               
            # project::setValue Result(Tubes/ChainStay/SeatStay_IS)                   position    $Result(Tubes/ChainStay/SeatStay_IS)                               
            project::setValue Result(Tubes/ChainStay/Start)                         position    $ChainStay(RearWheel)                                     
            # project::setValue Result(Tubes/ChainStay/Start)                         position    $Result(Tubes/ChainStay/Start)                                     
            project::setValue Result(Tubes/DownTube/BottleCage/Base)                position    $DownTube(BottleCage_Base)                            
            project::setValue Result(Tubes/DownTube/BottleCage/Offset)              position    $DownTube(BottleCage_Offset)                          
            project::setValue Result(Tubes/DownTube/BottleCage_Lower/Base)          position    $DownTube(BottleCage_Lower_Base)                      
            project::setValue Result(Tubes/DownTube/BottleCage_Lower/Offset)        position    $DownTube(BottleCage_Lower_Offset)                    
            # project::setValue Result(Tubes/DownTube/BottleCage/Base)                position    $Result(Tubes/DownTube/BottleCage/Base)                            
            # project::setValue Result(Tubes/DownTube/BottleCage/Offset)              position    $Result(Tubes/DownTube/BottleCage/Offset)                          
            # project::setValue Result(Tubes/DownTube/BottleCage_Lower/Base)          position    $Result(Tubes/DownTube/BottleCage_Lower/Base)                      
            # project::setValue Result(Tubes/DownTube/BottleCage_Lower/Offset)        position    $Result(Tubes/DownTube/BottleCage_Lower/Offset)                    
            project::setValue Result(Tubes/DownTube/End)                            position    $DownTube(HeadTube)                                           
            # project::setValue Result(Tubes/DownTube/End)                            position    $Result(Tubes/DownTube/End)                                           
            project::setValue Result(Tubes/DownTube/Start)                          position    $DownTube(BottomBracket)                                         
            # project::setValue Result(Tubes/DownTube/Start)                          position    $Result(Tubes/DownTube/Start)                                         
            project::setValue Result(Tubes/HeadTube/End)                            position    $HeadTube(Stem)                                           
            # project::setValue Result(Tubes/HeadTube/End)                            position    $Result(Tubes/HeadTube/End)                                           
            project::setValue Result(Tubes/HeadTube/Start)                          position    $HeadTube(Fork)                                         
            # project::setValue Result(Tubes/HeadTube/Start)                          position    $Result(Tubes/HeadTube/Start)                                         
            project::setValue Result(Tubes/SeatStay/End)                            position    $SeatStay(SeatTube)                                           
            # project::setValue Result(Tubes/SeatStay/End)                            position    $Result(Tubes/SeatStay/End)                                           
            project::setValue Result(Tubes/SeatStay/Start)                          position    $SeatStay(RearWheel)                                         
            # project::setValue Result(Tubes/SeatStay/Start)                          position    $Result(Tubes/SeatStay/Start)                                         
            project::setValue Result(Tubes/SeatTube/BottleCage/Base)                position    $SeatTube(BottleCage_Base)                     
            project::setValue Result(Tubes/SeatTube/BottleCage/Offset)              position    $SeatTube(BottleCage_Offset)                   
            # project::setValue Result(Tubes/SeatTube/BottleCage/Base)                position    $Result(Tubes/SeatTube/BottleCage/Base)                     
            # project::setValue Result(Tubes/SeatTube/BottleCage/Offset)              position    $Result(Tubes/SeatTube/BottleCage/Offset)                   
            project::setValue Result(Tubes/SeatTube/End)                            position    $SeatTube(TopTube)
            # project::setValue Result(Tubes/SeatTube/End)                            position    $Result(Tubes/SeatTube/End)
            project::setValue Result(Tubes/SeatTube/Start)                          position    $SeatTube(BottomBracket)
            # project::setValue Result(Tubes/SeatTube/Start)                          position    $Result(Tubes/SeatTube/Start)
            project::setValue Result(Tubes/Steerer/End)                             position    $Steerer(Stem)
            project::setValue Result(Tubes/Steerer/Start)                           position    $Steerer(Fork)
            project::setValue Result(Tubes/TopTube/End)                             position    $TopTube(HeadTube)                                         
            # project::setValue Result(Tubes/TopTube/End)                             position    $Result(Tubes/TopTube/End)                                         
            project::setValue Result(Tubes/TopTube/Start)                           position    $TopTube(SeatTube)
            # project::setValue Result(Tubes/TopTube/Start)                           position    $Result(Tubes/TopTube/Start)
                #
            project::setValue Result(Tubes/ForkBlade/End)                           position    $ForkBlade(End)                                       
            # project::setValue Result(Tubes/ForkBlade/End)                           value       $Result(Tubes/ForkBlade/End)                                       
            project::setValue Result(Tubes/ForkBlade/Start)                         position    $ForkBlade(Start)                                     
            # project::setValue Result(Tubes/ForkBlade/Start)                         value       $Result(Tubes/ForkBlade/Start)                                     
                #
                #
            project::setValue Result(Position/SummarySize)                          position    $Geometry(SummarySize)                                         
            # project::setValue Result(Position/SummarySize)                          position    $Result(Position/SummarySize)                                         
                #
                #
            
            
                #
            return    
                #
        
        }

        #
        #
        # --- check Values before compute details
        #
    proc bikeGeometry::check_Values {} {
            variable Saddle
            variable SeatPost
            variable SeatTube
            variable HandleBar
            variable HeadTube
            variable Steerer
            variable Stem
            variable Fork
            variable RearWheel
            variable FrontWheel
            variable RearFender
            variable FrontFender
            variable BottomBracket
              #
              # -- Component(Wheel/Rear/TyreWidthRadius) <-> RearWheel(TyreWidthRadius)   
              # -- handle values like done in bikeGeometry::set_base_Parameters 
            if {$RearWheel(TyreWidthRadius) > $RearWheel(Radius)} {
                set project::Component(Wheel/Rear/TyreWidthRadius) [expr $RearWheel(Radius) - 5.0]
                set RearWheel(TyreWidthRadius)                     $project::Component(Wheel/Rear/TyreWidthRadius)
                puts "\n                     -> <i> \$project::Component(Wheel/Rear/TyreWidthRadius) ... $project::Component(Wheel/Rear/TyreWidthRadius)"
            }
            if {1 == 2} {
                      #
                      # -- Component(Fender/Rear/Radius) <-> $RearFender(Radius)
                      #       handle values like done in bikeGeometry::get_FenderRear 
                    if {$RearFender(Radius) < $RearWheel(Radius)} {
                        set RearFender(Radius)                     [expr $RearWheel(Radius) + 5.0]
                        project::setValue Component(Fender/Rear/Radius) value $RearFender(Radius)
                        puts "\n                     -> <i> \$RearFender(Radius) ........... $RearFender(Radius)"
                    }  


                      #
                      # -- Component(Fender/Front/Radius) <-> $RearFender(Radius)
                      #       handle values like done in bikeGeometry::get_FenderFront 
                    if {$FrontFender(Radius) < $FrontWheel(Radius)} {
                        set FrontFender(Radius)                     [expr $FrontWheel(Radius) + 5.0]
                        project::setValue Component(Fender/Front/Radius) value $FrontFender(Radius)
                        puts "\n                     -> <i> \$FrontFender(Radius) .......... $FrontFender(Radius)"
                    }
            }
              #
            puts ""
              #
    }      
