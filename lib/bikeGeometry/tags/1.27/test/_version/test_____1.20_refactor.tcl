#!/bin/sh
# test_bikeGoemetry_1.0.tcl \
exec tclsh "$0" ${1+"$@"}



puts "\n\n ====== I N I T ============================ \n\n"

    # -- ::APPL_Config(BASE_Dir)  ------
    set BASE_Dir  [file normalize [file join [file dirname [file normalize $::argv0]] ..]]
        puts "   -> \$BASE_Dir:   $BASE_Dir\n"

        # -- Libraries  ---------------
    lappend auto_path           [file join $BASE_Dir lib]
    lappend auto_path           [file join $BASE_Dir ..]
        # puts "   -> \$auto_path:  $auto_path"

        # -- Packages  ---------------
    package require   bikeGeometry  1.20
    package require   appUtil

        # -- Directories  ------------
    set TEST_Dir    [file join $BASE_Dir test]
    set SAMPLE_Dir  [file join $TEST_Dir sample]
        # puts "   -> SAMPLE_Dir: $SAMPLE_Dir"
        
        # -- FAILED - Queries --------
    variable failedQueries; array set failedQueries {}

        # -- sampleFile  -----------
    set sampleFile  [file join $SAMPLE_Dir template_road_3.4.xml]
    set sampleFile  [file join $SAMPLE_Dir __debug_3.4.01.74__01__simplon_phasic_56_sramRed.xml]
    set sampleFile  [file join $SAMPLE_Dir __test_3.4.01_74.xml]
        # puts "   -> sampleFile: $sampleFile"

         # -- Content  --------------
    puts "\n   -> getContent: $sampleFile:"
    set fp [open $sampleFile]
    fconfigure    $fp -encoding utf-8
    set xml [read $fp]
    close         $fp
    set sampleDOC   [dom parse  $xml]
    set sampleDOM   [$sampleDOC documentElement]
        #
    bikeGeometry::set_newProject $sampleDOM
        #
        #
    variable projectDict
    set projectDict [bikeGeometry::get_projectDICT]
        #
    proc compareValues {procName argList {compValue {}}} {
        variable failedQueries
        variable projectDict
            #
        switch -exact $procName {           
            get_Component   {set dictRootName Component}
            get_Config      {set dictRootName Config}
            get_Scalar      {set dictRootName Scalar}
            get_ListValue   {set dictRootName ListValue}
        }
        
        
        switch -exact [llength $argList] {
            1   {   set key_1 [lindex $argList 0]
                    set getterValue [bikeGeometry::$procName $key_1]
                    set dictValue   [appUtil::get_dictValue $projectDict $dictRootName/$key_1]
                    set keyString   "$dictRootName/$key_1"
                }
            2   {   set key_1 [lindex $argList 0]
                    set key_2 [lindex $argList 1]
                    set getterValue [bikeGeometry::$procName $key_1 $key_2 ]
                    set dictValue   [appUtil::get_dictValue $projectDict $dictRootName/$key_1/$key_2]
                    set keyString   "$dictRootName/$key_1/$key_2"
                }
            3   {   set key_1 [lindex $argList 0]
                    set key_2 [lindex $argList 1]
                    set key_3 [lindex $argList 2]
                    set getterValue [bikeGeometry::$procName $key_1 $key_2 $key_3 ]
                    set dictValue   [appUtil::get_dictValue $projectDict $dictRootName/$key_1/$key_2/$key_3]
                    set keyString   "$dictRootName/$key_1/$key_2/$key_3"
               }
        }
        
        puts     "    ... $keyString"
            puts "                       ... $compValue"
        if {$compValue == $getterValue} {
            puts "                       ... $getterValue"
        } else {
            puts "            ... failed ... $getterValue"
            # set keyString "$procName@$keyString@getter"
            set failedQueries($keyString) [list $getterValue]
            #exit
        }
        if {$compValue == $dictValue} {
            puts "                       ... $dictValue"
        } else {
            puts "            ... failed ... $dictValue"
            # set keyString "$procName@$keyString@dictionary"
            set failedQueries($keyString) [list $dictValue]
            #exit
        }
    }
    
    proc reportComparison {{mode {}}} {
            #
        variable failedQueries
            #
        if {$mode == {}} {
            puts "    -----------------------------------------"
        } else {
            puts "\n"
            puts "-- reportComparison ---------------------------------"
            if {[array size failedQueries] > 0} {
                parray failedQueries
            } else {
                puts "\n      ... seems to be OK!\n"
            }
            puts "-- reportComparison ---------------------------------"
            puts "\n"
            exit
        }
    }
        #
        #
    set BB_Position         {0 0}
    set FrontHub_Position   {-400 50}
    set RearHub_Position    {600 50}
        #
        #
    puts "\n"
        #
        #
    #compareValues    get_Scalar     {BottleCage DownTube        }  checkFailed_01
    #compareValues    get_Component  {HandleBar                  }  checkFailed_02
        #
    reportComparison
        #
    compareValues    get_Component  {CrankSet         }   $::bikeGeometry::Component(CrankSet)                  ;# set _lastValue(Component/CrankSet/File)                                                                              
    compareValues    get_Component  {ForkCrown        }   $::bikeGeometry::Component(ForkCrown)                 ;# set _lastValue(Component/Fork/Crown/File)                               
    compareValues    get_Component  {ForkDropout      }   $::bikeGeometry::Component(ForkDropout)               ;# set _lastValue(Component/Fork/DropOut/File)                             
    compareValues    get_Component  {FrontBrake       }   $::bikeGeometry::Component(FrontBrake)                ;# set _lastValue(Component/Brake/Front/File)                              
    compareValues    get_Component  {FrontCarrier     }   $::bikeGeometry::Component(FrontCarrier)              ;# set _lastValue(Component/Carrier/Front/File)                            
    compareValues    get_Component  {FrontDerailleur  }   $::bikeGeometry::Component(FrontDerailleur)           ;# set _lastValue(Component/Derailleur/Front/File)                         
    compareValues    get_Component  {HandleBar        }   $::bikeGeometry::Component(HandleBar)                 ;# set _lastValue(Component/HandleBar/File)                                
    compareValues    get_Component  {Logo             }   $::bikeGeometry::Component(Logo)                      ;# set _lastValue(Component/Logo/File)                                     
    compareValues    get_Component  {RearBrake        }   $::bikeGeometry::Component(RearBrake)                 ;# set _lastValue(Component/Brake/Rear/File)                               
    compareValues    get_Component  {RearCarrier      }   $::bikeGeometry::Component(RearCarrier)               ;# set _lastValue(Component/Carrier/Rear/File)                             
    compareValues    get_Component  {RearDerailleur   }   $::bikeGeometry::Component(RearDerailleur)            ;# set _lastValue(Component/Derailleur/Rear/File)                          
    compareValues    get_Component  {RearDropout      }   $::bikeGeometry::Component(RearDropout)               ;# set _lastValue(Lugs/RearDropOut/File)                                   
    compareValues    get_Component  {Saddle           }   $::bikeGeometry::Component(Saddle)                    ;# set _lastValue(Component/Saddle/File)                                   
        # -- new --
    compareValues    get_Component  {BottleCage_DownTube}       $::bikeGeometry::Component(BottleCage_DownTube)       ;# set _lastValue(Component/Fork/DropOut/File)                             
    compareValues    get_Component  {BottleCage_DownTube_Lower} $::bikeGeometry::Component(BottleCage_DownTube_Lower) ;# set _lastValue(Component/Fork/DropOut/File)                             
    compareValues    get_Component  {BottleCage_SeatTube}       $::bikeGeometry::Component(BottleCage_SeatTube)       ;# set _lastValue(Component/Fork/DropOut/File)                             
        #
    reportComparison 
        #
    compareValues    get_Config     {BottleCage_DT    }   $::bikeGeometry::Config(BottleCage_DT)                ;# set _lastValue(Rendering/BottleCage/DownTube)                           
    compareValues    get_Config     {BottleCage_DT_L  }   $::bikeGeometry::Config(BottleCage_DT_L)              ;# set _lastValue(Rendering/BottleCage/DownTube_Lower)                     
    compareValues    get_Config     {BottleCage_ST    }   $::bikeGeometry::Config(BottleCage_ST)                ;# set _lastValue(Rendering/BottleCage/SeatTube)                           
    compareValues    get_Config     {ChainStay        }   $::bikeGeometry::Config(ChainStay)                    ;# set _lastValue(Rendering/ChainStay)                                     
    compareValues    get_Config     {Fork             }   $::bikeGeometry::Config(Fork)                         ;# set _lastValue(Rendering/Fork)                                          
    compareValues    get_Config     {ForkBlade        }   $::bikeGeometry::Config(ForkBlade)                    ;# set _lastValue(Rendering/ForkBlade)                                     
    compareValues    get_Config     {ForkDropout      }   $::bikeGeometry::Config(ForkDropout)                  ;# set _lastValue(Rendering/ForkDropOut)                                   
    compareValues    get_Config     {FrontBrake       }   $::bikeGeometry::Config(FrontBrake)                   ;# set _lastValue(Rendering/Brake/Front)                                   
    compareValues    get_Config     {FrontFender      }   $::bikeGeometry::Config(FrontFender)                  ;# set _lastValue(Rendering/Fender/Front)                                  
    compareValues    get_Config     {RearBrake        }   $::bikeGeometry::Config(RearBrake)                    ;# set _lastValue(Rendering/Brake/Rear)                                    
    compareValues    get_Config     {RearDropout      }   $::bikeGeometry::Config(RearDropout)                  ;# set _lastValue(Rendering/RearDropOut)                                   
    compareValues    get_Config     {RearDropoutOrient}   $::bikeGeometry::Config(RearDropoutOrient)            ;# set _lastValue(Lugs/RearDropOut/Direction)                              
    compareValues    get_Config     {RearFender       }   $::bikeGeometry::Config(RearFender)                   ;# set _lastValue(Rendering/Fender/Rear)                                   
        #
    reportComparison final
        #
    compareValues    get_ListValue  {CrankSetChainRings}  $::bikeGeometry::ListValue(CrankSetChainRings)        ;# set _lastValue(Component/CrankSet/ChainRings)                           
        #
    reportComparison
        #
    compareValues    get_Scalar     {BottleCage DownTube           }  $::bikeGeometry::BottleCage(DownTube)             ;# set _lastValue(Component/BottleCage/DownTube/OffsetBB)                  
    compareValues    get_Scalar     {BottleCage DownTube_Lower     }  $::bikeGeometry::BottleCage(DownTube_Lower)       ;# set _lastValue(Component/BottleCage/DownTube_Lower/OffsetBB)            
    compareValues    get_Scalar     {BottleCage SeatTube           }  $::bikeGeometry::BottleCage(SeatTube)             ;# set _lastValue(Component/BottleCage/SeatTube/OffsetBB)                  
    compareValues    get_Scalar     {BottomBracket InsideDiameter  }  $::bikeGeometry::BottomBracket(InsideDiameter)    ;# set _lastValue(Lugs/BottomBracket/Diameter/inside)                      
    compareValues    get_Scalar     {BottomBracket OffsetCS_TopView}  $::bikeGeometry::BottomBracket(OffsetCS_TopView)  ;# set _lastValue(Lugs/BottomBracket/ChainStay/Offset_TopView)             
    compareValues    get_Scalar     {BottomBracket OutsideDiameter }  $::bikeGeometry::BottomBracket(OutsideDiameter)   ;# set _lastValue(Lugs/BottomBracket/Diameter/outside)                     
    compareValues    get_Scalar     {BottomBracket Width           }  $::bikeGeometry::BottomBracket(Width)             ;# set _lastValue(Lugs/BottomBracket/Width)                                
        #
    reportComparison
        #
    compareValues    get_Scalar     {ChainStay DiameterSS      }    $::bikeGeometry::ChainStay(DiameterSS)          ;# set _lastValue(FrameTubes/ChainStay/DiameterSS)                         
    compareValues    get_Scalar     {ChainStay Height          }    $::bikeGeometry::ChainStay(Height)              ;# set _lastValue(FrameTubes/ChainStay/Height)                             
    compareValues    get_Scalar     {ChainStay HeigthBB        }    $::bikeGeometry::ChainStay(HeigthBB)            ;# set _lastValue(FrameTubes/ChainStay/HeightBB)                           
    compareValues    get_Scalar     {ChainStay TaperLength     }    $::bikeGeometry::ChainStay(TaperLength)         ;# set _lastValue(FrameTubes/ChainStay/TaperLength)                        
    compareValues    get_Scalar     {ChainStay WidthBB         }    $::bikeGeometry::ChainStay(WidthBB)     
        #            get_Scalar     {ChainStay profile_y03     }    $::bikeGeometry::ChainStay(profile_y03)         ;# set _lastValue(FrameTubes/ChainStay/Profile/width_03)                   
    compareValues    get_Scalar     {ChainStay completeLength  }    $::bikeGeometry::ChainStay(completeLength)      ;# set _lastValue(FrameTubes/ChainStay/Profile/completeLength)             
    compareValues    get_Scalar     {ChainStay cuttingLeft     }    $::bikeGeometry::ChainStay(cuttingLeft)         ;# set _lastValue(FrameTubes/ChainStay/Profile/cuttingLeft)                
    compareValues    get_Scalar     {ChainStay cuttingLength   }    $::bikeGeometry::ChainStay(cuttingLength)       ;# set _lastValue(FrameTubes/ChainStay/Profile/cuttingLength)              
    compareValues    get_Scalar     {ChainStay profile_x01     }    $::bikeGeometry::ChainStay(profile_x01)         ;# set _lastValue(FrameTubes/ChainStay/Profile/length_01)                  
    compareValues    get_Scalar     {ChainStay profile_x02     }    $::bikeGeometry::ChainStay(profile_x02)         ;# set _lastValue(FrameTubes/ChainStay/Profile/length_02)                  
    compareValues    get_Scalar     {ChainStay profile_x03     }    $::bikeGeometry::ChainStay(profile_x03)         ;# set _lastValue(FrameTubes/ChainStay/Profile/length_03)                  
    compareValues    get_Scalar     {ChainStay profile_y00     }    $::bikeGeometry::ChainStay(profile_y00)         ;# set _lastValue(FrameTubes/ChainStay/Profile/width_00)                   
    compareValues    get_Scalar     {ChainStay profile_y01     }    $::bikeGeometry::ChainStay(profile_y01)         ;# set _lastValue(FrameTubes/ChainStay/Profile/width_01)                   
    compareValues    get_Scalar     {ChainStay profile_y02     }    $::bikeGeometry::ChainStay(profile_y02)         ;# set _lastValue(FrameTubes/ChainStay/Profile/width_02)                   
        #
    reportComparison
        #
    compareValues    get_Scalar     {ChainStay segmentAngle_01 }    $::bikeGeometry::ChainStay(segmentAngle_01)     ;# set _lastValue(FrameTubes/ChainStay/CenterLine/angle_01)                
    compareValues    get_Scalar     {ChainStay segmentAngle_02 }    $::bikeGeometry::ChainStay(segmentAngle_02)     ;# set _lastValue(FrameTubes/ChainStay/CenterLine/angle_02)                
    compareValues    get_Scalar     {ChainStay segmentAngle_03 }    $::bikeGeometry::ChainStay(segmentAngle_03)     ;# set _lastValue(FrameTubes/ChainStay/CenterLine/angle_03)                
    compareValues    get_Scalar     {ChainStay segmentAngle_04 }    $::bikeGeometry::ChainStay(segmentAngle_04)     ;# set _lastValue(FrameTubes/ChainStay/CenterLine/angle_04)                
    compareValues    get_Scalar     {ChainStay segmentLength_01}    $::bikeGeometry::ChainStay(segmentLength_01)    ;# set _lastValue(FrameTubes/ChainStay/CenterLine/length_01)               
    compareValues    get_Scalar     {ChainStay segmentLength_02}    $::bikeGeometry::ChainStay(segmentLength_02)    ;# set _lastValue(FrameTubes/ChainStay/CenterLine/length_02)               
    compareValues    get_Scalar     {ChainStay segmentLength_03}    $::bikeGeometry::ChainStay(segmentLength_03)    ;# set _lastValue(FrameTubes/ChainStay/CenterLine/length_03)               
    compareValues    get_Scalar     {ChainStay segmentLength_04}    $::bikeGeometry::ChainStay(segmentLength_04)    ;# set _lastValue(FrameTubes/ChainStay/CenterLine/length_04)               
    compareValues    get_Scalar     {ChainStay segmentRadius_01}    $::bikeGeometry::ChainStay(segmentRadius_01)    ;# set _lastValue(FrameTubes/ChainStay/CenterLine/radius_01)               
    compareValues    get_Scalar     {ChainStay segmentRadius_02}    $::bikeGeometry::ChainStay(segmentRadius_02)    ;# set _lastValue(FrameTubes/ChainStay/CenterLine/radius_02)               
    compareValues    get_Scalar     {ChainStay segmentRadius_03}    $::bikeGeometry::ChainStay(segmentRadius_03)    ;# set _lastValue(FrameTubes/ChainStay/CenterLine/radius_03)               
    compareValues    get_Scalar     {ChainStay segmentRadius_04}    $::bikeGeometry::ChainStay(segmentRadius_04)    ;# set _lastValue(FrameTubes/ChainStay/CenterLine/radius_04)               
        #
    reportComparison
        #                                                         
    compareValues    get_Scalar     {CrankSet ArmWidth   }          $::bikeGeometry::CrankSet(ArmWidth)             ;# set _lastValue(Component/CrankSet/ArmWidth)                             
    compareValues    get_Scalar     {CrankSet ChainLine  }          $::bikeGeometry::CrankSet(ChainLine)            ;# set _lastValue(Component/CrankSet/ChainLine)                            
    compareValues    get_Scalar     {CrankSet Length     }          $::bikeGeometry::CrankSet(Length)               ;# set _lastValue(Component/CrankSet/Length)                               
    compareValues    get_Scalar     {CrankSet PedalEye   }          $::bikeGeometry::CrankSet(PedalEye)             ;# set _lastValue(Component/CrankSet/PedalEye)                             
    compareValues    get_Scalar     {CrankSet Q-Factor   }          $::bikeGeometry::CrankSet(Q-Factor)             ;# set _lastValue(Component/CrankSet/Q-Factor)                             
    compareValues    get_Scalar     {DownTube DiameterBB }          $::bikeGeometry::DownTube(DiameterBB)           ;# set _lastValue(FrameTubes/DownTube/DiameterBB)                          
    compareValues    get_Scalar     {DownTube DiameterHT }          $::bikeGeometry::DownTube(DiameterHT)           ;# set _lastValue(FrameTubes/DownTube/DiameterHT)                          
    compareValues    get_Scalar     {DownTube OffsetBB   }          $::bikeGeometry::DownTube(OffsetBB)             ;# set _lastValue(Custom/DownTube/OffsetBB)                                
    compareValues    get_Scalar     {DownTube OffsetHT   }          $::bikeGeometry::DownTube(OffsetHT)             ;# set _lastValue(Custom/DownTube/OffsetHT)                                
    compareValues    get_Scalar     {DownTube TaperLength}          $::bikeGeometry::DownTube(TaperLength)          ;# set _lastValue(FrameTubes/DownTube/TaperLength)                         
        #
    reportComparison
        #
    compareValues    get_Scalar     {Fork BladeBendRadius       }   $::bikeGeometry::Fork(BladeBendRadius)          ;# set _lastValue(Component/Fork/Blade/BendRadius)                         
    compareValues    get_Scalar     {Fork BladeDiameterDO       }   $::bikeGeometry::Fork(BladeDiameterDO)          ;# set _lastValue(Component/Fork/Blade/DiameterDO)                         
    compareValues    get_Scalar     {Fork BladeEndLength        }   $::bikeGeometry::Fork(BladeEndLength)           ;# set _lastValue(Component/Fork/Blade/EndLength)                          
    compareValues    get_Scalar     {Fork BladeOffsetCrown      }   $::bikeGeometry::Fork(BladeOffsetCrown)         ;# set _lastValue(Component/Fork/Crown/Blade/Offset)                       
    compareValues    get_Scalar     {Fork BladeOffsetCrownPerp  }   $::bikeGeometry::Fork(BladeOffsetCrownPerp)     ;# set _lastValue(Component/Fork/Crown/Blade/OffsetPerp)                   
    compareValues    get_Scalar     {Fork BladeOffsetDO         }   $::bikeGeometry::Fork(BladeOffsetDO)            ;# set _lastValue(Component/Fork/DropOut/Offset)                           
    compareValues    get_Scalar     {Fork BladeOffsetDOPerp     }   $::bikeGeometry::Fork(BladeOffsetDOPerp)        ;# set _lastValue(Component/Fork/DropOut/OffsetPerp)                       
    compareValues    get_Scalar     {Fork BladeTaperLength      }   $::bikeGeometry::Fork(BladeTaperLength)         ;# set _lastValue(Component/Fork/Blade/TaperLength)                        
    compareValues    get_Scalar     {Fork BladeWidth            }   $::bikeGeometry::Fork(BladeWidth)               ;# set _lastValue(Component/Fork/Blade/Width)                              
    compareValues    get_Scalar     {Fork BrakeAngle            }   $::bikeGeometry::Fork(BrakeAngle)               ;# set _lastValue(Component/Fork/Crown/Brake/Angle)                        
    compareValues    get_Scalar     {Fork BrakeOffset           }   $::bikeGeometry::Fork(BrakeOffset)              ;# set _lastValue(Component/Fork/Crown/Brake/Offset)                       
    compareValues    get_Scalar     {Fork Height                }   $::bikeGeometry::Fork(Height)                   ;# set _lastValue(Component/Fork/Height)                                   
    compareValues    get_Scalar     {Fork Rake                  }   $::bikeGeometry::Fork(Rake)                     ;# set _lastValue(Component/Fork/Rake)                                     
        #   
    reportComparison
        #
    compareValues    get_Scalar     {FrontBrake LeverLength      }  $::bikeGeometry::FrontBrake(LeverLength)        ;# set _lastValue(Component/Brake/Front/LeverLength)                       
    compareValues    get_Scalar     {FrontBrake Offset           }  $::bikeGeometry::FrontBrake(Offset)             ;# set _lastValue(Component/Brake/Front/Offset)                            
    compareValues    get_Scalar     {FrontCarrier x              }  $::bikeGeometry::FrontCarrier(x)                ;# set _lastValue(Component/Carrier/Front/x)                               
    compareValues    get_Scalar     {FrontCarrier y              }  $::bikeGeometry::FrontCarrier(y)                ;# set _lastValue(Component/Carrier/Front/y)                               
    compareValues    get_Scalar     {FrontDerailleur Distance    }  $::bikeGeometry::FrontDerailleur(Distance)      ;# set _lastValue(Component/Derailleur/Front/Distance)                     
    compareValues    get_Scalar     {FrontDerailleur Offset      }  $::bikeGeometry::FrontDerailleur(Offset)        ;# set _lastValue(Component/Derailleur/Front/Offset)                       
    compareValues    get_Scalar     {FrontFender Height          }  $::bikeGeometry::FrontFender(Height)            ;# set _lastValue(Component/Fender/Front/Height)                           
    compareValues    get_Scalar     {FrontFender OffsetAngle     }  $::bikeGeometry::FrontFender(OffsetAngle)       ;# set _lastValue(Component/Fender/Front/OffsetAngle)                      
    compareValues    get_Scalar     {FrontFender OffsetAngleFront}  $::bikeGeometry::FrontFender(OffsetAngleFront)  ;# set _lastValue(Component/Fender/Front/OffsetAngleFront)                 
    compareValues    get_Scalar     {FrontFender Radius          }  $::bikeGeometry::FrontFender(Radius)            ;# set _lastValue(Component/Fender/Front/Radius)                           
    compareValues    get_Scalar     {FrontWheel RimDiameter      }  $::bikeGeometry::FrontWheel(RimDiameter)        ;# set _lastValue(Component/Wheel/Front/RimDiameter)                       
    compareValues    get_Scalar     {FrontWheel RimHeight        }  $::bikeGeometry::FrontWheel(RimHeight)          ;# set _lastValue(Component/Wheel/Front/RimHeight)                         
    compareValues    get_Scalar     {FrontWheel TyreHeight       }  $::bikeGeometry::FrontWheel(TyreHeight)         ;# set _lastValue(Component/Wheel/Front/TyreHeight)                        
        #
    reportComparison
        #
    compareValues    get_Scalar     {Geometry BottomBracket_Depth } $::bikeGeometry::Geometry(BottomBracket_Depth)  ;# set _lastValue(Custom/BottomBracket/Depth)                              
    compareValues    get_Scalar     {Geometry BottomBracket_Height} $::bikeGeometry::Geometry(BottomBracket_Height) ;# set _lastValue(Result/Length/BottomBracket/Height)                      
    compareValues    get_Scalar     {Geometry ChainStay_Length    } $::bikeGeometry::Geometry(ChainStay_Length)     ;# set _lastValue(Custom/WheelPosition/Rear)                               
    compareValues    get_Scalar     {Geometry FrontWheel_Radius   } $::bikeGeometry::Geometry(FrontWheel_Radius)    ;# set _lastValue(Result/Length/FrontWheel/Radius)                         
    compareValues    get_Scalar     {Geometry FrontWheel_x        } $::bikeGeometry::Geometry(FrontWheel_x)         ;# set _lastValue(Result/Length/FrontWheel/horizontal)                     
    compareValues    get_Scalar     {Geometry FrontWheel_xy       } $::bikeGeometry::Geometry(FrontWheel_xy)        ;# set _lastValue(Result/Length/FrontWheel/diagonal)                       
    compareValues    get_Scalar     {Geometry HandleBar_Distance  } $::bikeGeometry::Geometry(HandleBar_Distance)   ;# set _lastValue(Personal/HandleBar_Distance)                             
    compareValues    get_Scalar     {Geometry HandleBar_Height    } $::bikeGeometry::Geometry(HandleBar_Height)     ;# set _lastValue(Personal/HandleBar_Height)                               
    compareValues    get_Scalar     {Geometry HeadTube_Angle      } $::bikeGeometry::Geometry(HeadTube_Angle)       ;# set _lastValue(Custom/HeadTube/Angle)                                   
    compareValues    get_Scalar     {Geometry Inseam_Length       } $::bikeGeometry::Geometry(Inseam_Length)        ;# set _lastValue(Personal/InnerLeg_Length)                                
    compareValues    get_Scalar     {Geometry ReachLengthResult   } $::bikeGeometry::Geometry(ReachLengthResult)    ;# set _lastValue(Result/Length/HeadTube/ReachLength)                      
    compareValues    get_Scalar     {Geometry RearWheel_Radius    } $::bikeGeometry::Geometry(RearWheel_Radius)     ;# set _lastValue(Result/Length/RearWheel/Radius)                          
    compareValues    get_Scalar     {Geometry RearWheel_x         } $::bikeGeometry::Geometry(RearWheel_x)          ;# set _lastValue(Result/Length/RearWheel/horizontal)                      
        #
    reportComparison
        #
    compareValues    get_Scalar     {Geometry SaddleNose_BB_x     } $::bikeGeometry::Geometry(SaddleNose_BB_x)      ;# set _lastValue(Result/Length/Saddle/Offset_BB_Nose)                     
    compareValues    get_Scalar     {Geometry SaddleNose_HB       } $::bikeGeometry::Geometry(SaddleNose_HB)        ;# set _lastValue(Result/Length/Personal/SaddleNose_HB)                    
    compareValues    get_Scalar     {Geometry Saddle_BB           } $::bikeGeometry::Geometry(Saddle_BB)            ;# set _lastValue(Result/Length/Saddle/SeatTube_BB)                        
    compareValues    get_Scalar     {Geometry Saddle_Distance     } $::bikeGeometry::Geometry(Saddle_Distance)      ;# set _lastValue(Personal/Saddle_Distance)                                
    compareValues    get_Scalar     {Geometry Saddle_HB_y         } $::bikeGeometry::Geometry(Saddle_HB_y)          ;# set _lastValue(Result/Length/Saddle/Offset_HB)                          
    compareValues    get_Scalar     {Geometry Saddle_Offset_BB_ST } $::bikeGeometry::Geometry(Saddle_Offset_BB_ST)  ;# set _lastValue(Result/Length/Saddle/Offset_BB_ST)                       
    compareValues    get_Scalar     {Geometry SeatTubeVirtual     } $::bikeGeometry::Geometry(SeatTubeVirtual)      ;# set _lastValue(Result/Length/SeatTube/VirtualLength)                    
    compareValues    get_Scalar     {Geometry StackHeightResult   } $::bikeGeometry::Geometry(StackHeightResult)    ;# set _lastValue(Result/Length/HeadTube/StackHeight)                      
    compareValues    get_Scalar     {Geometry Stem_Angle          } $::bikeGeometry::Geometry(Stem_Angle)           ;# set _lastValue(Component/Stem/Angle)                                    
    compareValues    get_Scalar     {Geometry Stem_Length         } $::bikeGeometry::Geometry(Stem_Length)          ;# set _lastValue(Component/Stem/Length)                                   
    compareValues    get_Scalar     {Geometry TopTubeVirtual      } $::bikeGeometry::Geometry(TopTubeVirtual)       ;# set _lastValue(Result/Length/TopTube/VirtualLength)                     
    compareValues    get_Scalar     {Geometry TopTube_Angle       } $::bikeGeometry::Geometry(TopTube_Angle)        ;# set _lastValue(Custom/TopTube/Angle)                                    
        #
    reportComparison
        #
    compareValues    get_Scalar     {HandleBar PivotAngle                  }    $::bikeGeometry::HandleBar(PivotAngle)                      ;# set _lastValue(Component/HandleBar/PivotAngle)                          
    compareValues    get_Scalar     {HeadSet Diameter                      }    $::bikeGeometry::HeadSet(Diameter)                          ;# set _lastValue(Component/HeadSet/Diameter)                              
    compareValues    get_Scalar     {HeadSet Height_Bottom                 }    $::bikeGeometry::HeadSet(Height_Bottom)                     ;# set _lastValue(Component/HeadSet/Height/Bottom)                         
    compareValues    get_Scalar     {HeadSet Height_Top                    }    $::bikeGeometry::HeadSet(Height_Top)                        ;# set _lastValue(Component/HeadSet/Height/Top)                            
    compareValues    get_Scalar     {HeadTube Diameter                     }    $::bikeGeometry::HeadTube(Diameter)                         ;# set _lastValue(FrameTubes/HeadTube/Diameter)                            
    compareValues    get_Scalar     {HeadTube Length                       }    $::bikeGeometry::HeadTube(Length)                           ;# set _lastValue(FrameTubes/HeadTube/Length)                              
        #
    reportComparison
        #
    compareValues    get_Scalar     {Lugs BottomBracket_ChainStay_Angle    }    $::bikeGeometry::Lugs(BottomBracket_ChainStay_Angle)        ;# set _lastValue(Lugs/BottomBracket/ChainStay/Angle/value)                
    compareValues    get_Scalar     {Lugs BottomBracket_ChainStay_Tolerance}    $::bikeGeometry::Lugs(BottomBracket_ChainStay_Tolerance)    ;# set _lastValue(Lugs/BottomBracket/ChainStay/Angle/plus_minus)           
    compareValues    get_Scalar     {Lugs BottomBracket_DownTube_Angle     }    $::bikeGeometry::Lugs(BottomBracket_DownTube_Angle)         ;# set _lastValue(Lugs/BottomBracket/DownTube/Angle/value)                 
    compareValues    get_Scalar     {Lugs BottomBracket_DownTube_Tolerance }    $::bikeGeometry::Lugs(BottomBracket_DownTube_Tolerance)     ;# set _lastValue(Lugs/BottomBracket/DownTube/Angle/plus_minus)            
    compareValues    get_Scalar     {Lugs HeadLug_Bottom_Angle             }    $::bikeGeometry::Lugs(HeadLug_Bottom_Angle)                 ;# set _lastValue(Lugs/HeadTube/DownTube/Angle/value)                      
    compareValues    get_Scalar     {Lugs HeadLug_Bottom_Tolerance         }    $::bikeGeometry::Lugs(HeadLug_Bottom_Tolerance)             ;# set _lastValue(Lugs/HeadTube/DownTube/Angle/plus_minus)                 
    compareValues    get_Scalar     {Lugs HeadLug_Top_Angle                }    $::bikeGeometry::Lugs(HeadLug_Top_Angle)                    ;# set _lastValue(Lugs/HeadTube/TopTube/Angle/value)                       
    compareValues    get_Scalar     {Lugs HeadLug_Top_Tolerance            }    $::bikeGeometry::Lugs(HeadLug_Top_Tolerance)                ;# set _lastValue(Lugs/HeadTube/TopTube/Angle/plus_minus)                  
    compareValues    get_Scalar     {Lugs RearDropOut_Angle                }    $::bikeGeometry::Lugs(RearDropOut_Angle)                    ;# set _lastValue(Lugs/RearDropOut/Angle/value)                            
    compareValues    get_Scalar     {Lugs RearDropOut_Tolerance            }    $::bikeGeometry::Lugs(RearDropOut_Tolerance)                ;# set _lastValue(Lugs/RearDropOut/Angle/plus_minus)                       
    compareValues    get_Scalar     {Lugs SeatLug_SeatStay_Angle           }    $::bikeGeometry::Lugs(SeatLug_SeatStay_Angle)               ;# set _lastValue(Lugs/SeatTube/SeatStay/Angle/value)                      
    compareValues    get_Scalar     {Lugs SeatLug_SeatStay_Tolerance       }    $::bikeGeometry::Lugs(SeatLug_SeatStay_Tolerance)           ;# set _lastValue(Lugs/SeatTube/SeatStay/Angle/plus_minus)                 
    compareValues    get_Scalar     {Lugs SeatLug_TopTube_Angle            }    $::bikeGeometry::Lugs(SeatLug_TopTube_Angle)                ;# set _lastValue(Lugs/SeatTube/TopTube/Angle/value)                       
    compareValues    get_Scalar     {Lugs SeatLug_TopTube_Tolerance        }    $::bikeGeometry::Lugs(SeatLug_TopTube_Tolerance)            ;# set _lastValue(Lugs/SeatTube/TopTube/Angle/plus_minus)                  
        #
    reportComparison
        #
    compareValues    get_Scalar     {RearBrake LeverLength       }    $::bikeGeometry::RearBrake(LeverLength)           ;# set _lastValue(Component/Brake/Rear/LeverLength)                        
    compareValues    get_Scalar     {RearBrake Offset            }    $::bikeGeometry::RearBrake(Offset)                ;# set _lastValue(Component/Brake/Rear/Offset)                             
    compareValues    get_Scalar     {RearCarrier x               }    $::bikeGeometry::RearCarrier(x)                   ;# set _lastValue(Component/Carrier/Rear/x)                                
    compareValues    get_Scalar     {RearCarrier y               }    $::bikeGeometry::RearCarrier(y)                   ;# set _lastValue(Component/Carrier/Rear/y)                                
    compareValues    get_Scalar     {RearDerailleur Pulley_teeth }    $::bikeGeometry::RearDerailleur(Pulley_teeth)     ;# set _lastValue(Component/Derailleur/Rear/Pulley/teeth)                  
    compareValues    get_Scalar     {RearDerailleur Pulley_x     }    $::bikeGeometry::RearDerailleur(Pulley_x)         ;# set _lastValue(Component/Derailleur/Rear/Pulley/x)                      
    compareValues    get_Scalar     {RearDerailleur Pulley_y     }    $::bikeGeometry::RearDerailleur(Pulley_y)         ;# set _lastValue(Component/Derailleur/Rear/Pulley/y)                      
    compareValues    get_Scalar     {RearDropout Derailleur_x    }    $::bikeGeometry::RearDropout(Derailleur_x)        ;# set _lastValue(Lugs/RearDropOut/Derailleur/x)                           
    compareValues    get_Scalar     {RearDropout Derailleur_y    }    $::bikeGeometry::RearDropout(Derailleur_y)        ;# set _lastValue(Lugs/RearDropOut/Derailleur/y)                           
    compareValues    get_Scalar     {RearDropout OffsetCS        }    $::bikeGeometry::RearDropout(OffsetCS)            ;# set _lastValue(Lugs/RearDropOut/ChainStay/Offset)                       
    compareValues    get_Scalar     {RearDropout OffsetCSPerp    }    $::bikeGeometry::RearDropout(OffsetCSPerp)        ;# set _lastValue(Lugs/RearDropOut/ChainStay/OffsetPerp)                   
    compareValues    get_Scalar     {RearDropout OffsetCS_TopView}    $::bikeGeometry::RearDropout(OffsetCS_TopView)    ;# set _lastValue(Lugs/RearDropOut/ChainStay/Offset_TopView)               
    compareValues    get_Scalar     {RearDropout OffsetSS        }    $::bikeGeometry::RearDropout(OffsetSS)            ;# set _lastValue(Lugs/RearDropOut/SeatStay/Offset)                        
    compareValues    get_Scalar     {RearDropout OffsetSSPerp    }    $::bikeGeometry::RearDropout(OffsetSSPerp)        ;# set _lastValue(Lugs/RearDropOut/SeatStay/OffsetPerp)                    
    compareValues    get_Scalar     {RearDropout RotationOffset  }    $::bikeGeometry::RearDropout(RotationOffset)      ;# set _lastValue(Lugs/RearDropOut/RotationOffset)                         
        #
    reportComparison
        #
    compareValues    get_Scalar     {RearFender Height             }  $::bikeGeometry::RearFender(Height)                 ;# set _lastValue(Component/Fender/Rear/Height)                            
    compareValues    get_Scalar     {RearFender OffsetAngle        }  $::bikeGeometry::RearFender(OffsetAngle)            ;# set _lastValue(Component/Fender/Rear/OffsetAngle)                       
    compareValues    get_Scalar     {RearFender Radius             }  $::bikeGeometry::RearFender(Radius)                 ;# set _lastValue(Component/Fender/Rear/Radius)                            
    compareValues    get_Scalar     {RearMockup CassetteClearance  }  $::bikeGeometry::RearMockup(CassetteClearance)      ;# set _lastValue(Rendering/RearMockup/CassetteClearance)                  
    compareValues    get_Scalar     {RearMockup ChainWheelClearance}  $::bikeGeometry::RearMockup(ChainWheelClearance)    ;# set _lastValue(Rendering/RearMockup/ChainWheelClearance)                
    compareValues    get_Scalar     {RearMockup CrankClearance     }  $::bikeGeometry::RearMockup(CrankClearance)         ;# set _lastValue(Rendering/RearMockup/CrankClearance)                     
    compareValues    get_Scalar     {RearMockup DiscClearance      }  $::bikeGeometry::RearMockup(DiscClearance)          ;# set _lastValue(Rendering/RearMockup/DiscClearance)                      
    compareValues    get_Scalar     {RearMockup DiscDiameter       }  $::bikeGeometry::RearMockup(DiscDiameter)           ;# set _lastValue(Rendering/RearMockup/DiscDiameter)                       
    compareValues    get_Scalar     {RearMockup DiscOffset         }  $::bikeGeometry::RearMockup(DiscOffset)             ;# set _lastValue(Rendering/RearMockup/DiscOffset)                         
    compareValues    get_Scalar     {RearMockup DiscWidth          }  $::bikeGeometry::RearMockup(DiscWidth)              ;# set _lastValue(Rendering/RearMockup/DiscWidth)                          
    compareValues    get_Scalar     {RearMockup TyreClearance      }  $::bikeGeometry::RearMockup(TyreClearance)          ;# set _lastValue(Rendering/RearMockup/TyreClearance)                      
        #
    reportComparison
        #
    compareValues    get_Scalar     {RearWheel FirstSprocket       }  $::bikeGeometry::RearWheel(FirstSprocket)           ;# set _lastValue(Component/Wheel/Rear/FirstSprocket)                      
    compareValues    get_Scalar     {RearWheel HubWidth            }  $::bikeGeometry::RearWheel(HubWidth)                ;# set _lastValue(Component/Wheel/Rear/HubWidth)                           
    compareValues    get_Scalar     {RearWheel RimDiameter         }  $::bikeGeometry::RearWheel(RimDiameter)             ;# set _lastValue(Component/Wheel/Rear/RimDiameter)                        
    compareValues    get_Scalar     {RearWheel RimHeight           }  $::bikeGeometry::RearWheel(RimHeight)               ;# set _lastValue(Component/Wheel/Rear/RimHeight)                          
    compareValues    get_Scalar     {RearWheel TyreHeight          }  $::bikeGeometry::RearWheel(TyreHeight)              ;# set _lastValue(Component/Wheel/Rear/TyreHeight)                         
    compareValues    get_Scalar     {RearWheel TyreShoulder        }  $::bikeGeometry::RearWheel(TyreShoulder)            ;# set _lastValue(Result/Length/RearWheel/TyreShoulder)                    
    compareValues    get_Scalar     {RearWheel TyreWidth           }  $::bikeGeometry::RearWheel(TyreWidth)               ;# set _lastValue(Component/Wheel/Rear/TyreWidth)                          
    compareValues    get_Scalar     {RearWheel TyreWidthRadius     }  $::bikeGeometry::RearWheel(TyreWidthRadius)         ;# set _lastValue(Component/Wheel/Rear/TyreWidthRadius)                    
        #
    reportComparison
        #
    compareValues    get_Scalar     {Reference HandleBar_Distance  }  $::bikeGeometry::Reference(HandleBar_Distance)      ;# set _lastValue(Reference/HandleBar_Distance)                            
    compareValues    get_Scalar     {Reference HandleBar_Height    }  $::bikeGeometry::Reference(HandleBar_Height)        ;# set _lastValue(Reference/HandleBar_Height)                              
    compareValues    get_Scalar     {Reference SaddleNose_Distance }  $::bikeGeometry::Reference(SaddleNose_Distance)     ;# set _lastValue(Reference/SaddleNose_Distance)                           
    compareValues    get_Scalar     {Reference SaddleNose_HB       }  $::bikeGeometry::Reference(SaddleNose_HB)           ;# set _lastValue(Result/Length/Reference/SaddleNose_HB)                   
    compareValues    get_Scalar     {Reference SaddleNose_HB_y     }  $::bikeGeometry::Reference(SaddleNose_HB_y)         ;# set _lastValue(Result/Length/Reference/Heigth_SN_HB)                    
    compareValues    get_Scalar     {Reference SaddleNose_Height   }  $::bikeGeometry::Reference(SaddleNose_Height)       ;# set _lastValue(Reference/SaddleNose_Height)                             
        #
    reportComparison
        #
    compareValues    get_Scalar     {Result Angle_HeadTubeTopTube  }  $::bikeGeometry::Result(Angle_HeadTubeTopTube)      ;# set _lastValue(Result/Angle/HeadTube/TopTube)                           
    compareValues    get_Scalar     {Saddle Height                 }  $::bikeGeometry::Saddle(Height)                     ;# set _lastValue(Personal/Saddle_Height)                                  
    compareValues    get_Scalar     {Saddle NoseLength             }  $::bikeGeometry::Saddle(NoseLength)                 ;# set _lastValue(Component/Saddle/LengthNose)                             
    compareValues    get_Scalar     {Saddle Offset_x               }  $::bikeGeometry::Saddle(Offset_x)                   ;# set _lastValue(Rendering/Saddle/Offset_X)                               
    compareValues    get_Scalar     {Saddle Offset_y               }  $::bikeGeometry::Saddle(Offset_y)                   ;# set _lastValue(Rendering/Saddle/Offset_Y)                               
        #
    reportComparison
        #
    compareValues    get_Scalar     {SeatPost Diameter             }  $::bikeGeometry::SeatPost(Diameter)                 ;# set _lastValue(Component/SeatPost/Diameter)                             
    compareValues    get_Scalar     {SeatPost PivotOffset          }  $::bikeGeometry::SeatPost(PivotOffset)              ;# set _lastValue(Component/SeatPost/PivotOffset)                          
    compareValues    get_Scalar     {SeatPost Setback              }  $::bikeGeometry::SeatPost(Setback)                  ;# set _lastValue(Component/SeatPost/Setback)                              
    compareValues    get_Scalar     {SeatStay DiameterCS           }  $::bikeGeometry::SeatStay(DiameterCS)               ;# set _lastValue(FrameTubes/SeatStay/DiameterCS)                          
    compareValues    get_Scalar     {SeatStay DiameterST           }  $::bikeGeometry::SeatStay(DiameterST)               ;# set _lastValue(FrameTubes/SeatStay/DiameterST)                          
    compareValues    get_Scalar     {SeatStay OffsetTT             }  $::bikeGeometry::SeatStay(OffsetTT)                 ;# set _lastValue(Custom/SeatStay/OffsetTT)                                
    compareValues    get_Scalar     {SeatStay SeatTubeMiterDiameter}  $::bikeGeometry::SeatStay(SeatTubeMiterDiameter)    ;# set _lastValue(Lugs/SeatTube/SeatStay/MiterDiameter)                    
    compareValues    get_Scalar     {SeatStay TaperLength          }  $::bikeGeometry::SeatStay(TaperLength)              ;# set _lastValue(FrameTubes/SeatStay/TaperLength)                         
        #
    reportComparison
        #
    compareValues    get_Scalar     {SeatTube Angle                }  $::bikeGeometry::SeatTube(Angle)                    ;# set _lastValue(Result/Angle/SeatTube/Direction)                         
    compareValues    get_Scalar     {SeatTube DiameterBB           }  $::bikeGeometry::SeatTube(DiameterBB)               ;# set _lastValue(FrameTubes/SeatTube/DiameterBB)                          
    compareValues    get_Scalar     {SeatTube DiameterTT           }  $::bikeGeometry::SeatTube(DiameterTT)               ;# set _lastValue(FrameTubes/SeatTube/DiameterTT)                          
    compareValues    get_Scalar     {SeatTube Extension            }  $::bikeGeometry::SeatTube(Extension)                ;# set _lastValue(Custom/SeatTube/Extension)                               
    compareValues    get_Scalar     {SeatTube OffsetBB             }  $::bikeGeometry::SeatTube(OffsetBB)                 ;# set _lastValue(Custom/SeatTube/OffsetBB)                                
    compareValues    get_Scalar     {SeatTube TaperLength          }  $::bikeGeometry::SeatTube(TaperLength)              ;# set _lastValue(FrameTubes/SeatTube/TaperLength)                         
        #
    reportComparison
        #
    compareValues    get_Scalar     {TopTube DiameterHT            }  $::bikeGeometry::TopTube(DiameterHT)                ;# set _lastValue(FrameTubes/TopTube/DiameterHT)                           
    compareValues    get_Scalar     {TopTube DiameterST            }  $::bikeGeometry::TopTube(DiameterST)                                                        
    compareValues    get_Scalar     {TopTube OffsetHT              }  $::bikeGeometry::TopTube(OffsetHT)               
    compareValues    get_Scalar     {TopTube PivotPosition         }  $::bikeGeometry::TopTube(PivotPosition)             ;# set _lastValue(Custom/TopTube/PivotPosition)
        #
    reportComparison 
        #
    # compareValues    get_Scalar     {BottleCage DownTube_Lower     }  checkFailed_03
    # compareValues    get_Component  {Saddle                        }  checkFailed_04
        #
    reportComparison final
        #
    
        
            # set MathValue(TopTube/DiameterST)                      [bikeGeometry::get_Scalar           TopTube  DiameterST               ]                ;# set _lastValue(FrameTubes/TopTube/DiameterST)                           
            # set MathValue(TopTube/TaperLength)                     [bikeGeometry::get_Scalar           TopTube  TaperLength              ]                ;# set _lastValue(FrameTubes/TopTube/TaperLength)                          
            # set MathValue(TopTube/OffsetHT)                        [bikeGeometry::get_Scalar           TopTube OffsetHT                  ]                ;# set _lastValue(Custom/TopTube/OffsetHT)                                 
        #

