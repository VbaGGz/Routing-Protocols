# ========================================================================================
#                      Wireless Ad-hoc Routing Protocol DSDV
#=========================================================================================
 
proc rand_range {min max} { 
    return [expr int(rand()*($max-$min+1)) + $min] 
}


# Protocol options
set val(chan)           Channel/WirelessChannel    ;# channel type
set val(prop)           Propagation/TwoRayGround   ;# radio-propagation model
set val(netif)          Phy/WirelessPhy            ;# network interface type
set val(mac)            Mac/802_11                 ;# MAC type
set val(ifq)            Queue/DropTail/PriQueue    ;# interface queue type
set val(ll)             LL                         ;# link layer type
set val(ant)            Antenna/OmniAntenna        ;# antenna model
set val(ifqlen)         50                         ;# max packet in ifq
set val(nn)             10                         ;# number of mobilenodes 
set val(rp)             DSDV                       ;# routing protocol
set val(steps)          1000                       ;#* Number of steps to simulate
set val(x)              1000                       ;# X dimension of topography
set val(y)              1000                       ;# Y dimension of topography  
set val(stop)           15                         ;# time of simulation end
set Val(opmode)         0                          ;#* if 0 Random Walk From Center if 1  weighted walk From Sides
 
#Creat Simulator object
set ns [new Simulator]
 
 
#set up trace files
set tracefd [open simple.tr w]
$ns trace-all $tracefd
set namtrace [open simwrls.nam w]   
$ns namtrace-all-wireless $namtrace $val(x) $val(y) 
set windowVsTime2 [open win.tr w] 
 
 
 
#Set up Topgraphy
set topo       [new Topography]
 
 
#Topgraphy border
$topo load_flatgrid $val(x) $val(y)
 
#General Operations Director.store global information 
#state of the environment, network or nodes 
set god_ [create-god $val(nn)]
 
#Congifure wireless nodes
        $ns node-config -adhocRouting $val(rp) \
                                     -llType $val(ll) \
                                     -macType $val(mac) \
                                     -ifqType $val(ifq) \
                                     -ifqLen $val(ifqlen) \
                                     -antType $val(ant) \
                                     -propType $val(prop) \
                                     -phyType $val(netif) \
                                     -channelType $val(chan) \
                                     -topoInstance $topo \
                                     -agentTrace ON \
                                     -routerTrace ON \
                                     -macTrace OFF \
                                     -movementTrace ON
 
#Create the nodes                                  
for {set i 0} {$i < $val(nn) } { incr i } {
                        set node_($i) [$ns node] 
            }

if { $Val(opmode) == 0 } {
    set time 0.00
# Provide initial location of mobilenodes Center
    for {set i 0} {$i < $val(nn) } { incr i } {
        $node_($i) set X_ 499
        $node_($i) random-motion 0
    	$node_($i) set Y_ 499
    	$node_($i) set Z_ 499
        for {set j 0} {$j < 2 } { incr j } {
        set CL($i,$j) 499
        }
    }
    
    # 1 = North
    # 2 = South
    # 3 = East 
    # 4 = West

    # * nested for Loop for a thousand steps and running random numbers for all 10 nodes
    for {set i 0} {$i < 20 } { incr i } {
        for {set h 0} {$h < $val(nn) } { incr h } {
            set random_num [rand_range 1 4]
            if { $random_num == 1 } {
                set CL($h,1) [ expr $CL($h,1) + 1 ]
                puts $h 
                puts $random_num 
                puts $time 
                puts $CL($h,0) 
                puts $CL($h,1)
                $ns at $time "$node_($h) setdest $CL($h,0) $CL($h,1) 499"
            } elseif { $random_num == 2 } {
                set CL($h,1) [ expr $CL($h,1) - 1 ]
                puts $h 
                puts $random_num 
                puts $time 
                puts $CL($h,0) 
                puts $CL($h,1)
                $ns at $time "$node_($h) setdest $CL($h,0) $CL($h,1) 499"
            } elseif { $random_num == 3 } {
                set CL($h,0) [ expr $CL($h,0) + 1 ]
                puts $h 
                puts $random_num 
                puts $time 
                puts $CL($h,0) 
                puts $CL($h,1)
                $ns at $time "$node_($h) setdest $CL($h,0) $CL($h,1) 499"
            } elseif { $random_num == 4 } {
                set CL($h,0) [ expr $CL($h,0) - 1 ]
                puts $h 
                puts $random_num 
                puts $time 
                puts $CL($h,0) 
                puts $CL($h,1)
                $ns at $time "$node_($h) setdest $CL($h,0) $CL($h,1) 499"
            } 
        } 
        set time [ expr $time + .01 ]
    }

    
    
    # puts $CL(0,2)
    # set time 1
    # set time [ expr $time + .01 ]
    # puts $time
    # Generation of movements
    # $ns at $time "$node_(0) setdest 500.0 500.0 499.0" 
    # puts $time
 
} elseif { $Val(opmode) == 1 } {
    set time 1
    puts $time
# Provide initial location of mobilenodes Sides
    for {set i 0} {$i < $val(nn) } { incr i } {
        for {set j 0} {$j < 2 } { incr j } {
    	if { $i < 5 } {
            $node_($i) set X_ 0
            $node_($i) set Y_ 499
            $node_($i) set Z_ 499
                if { $j == 0 } {
                    set CL($i,$j) 0
                } elseif { $j == 1 } { 
                    set CL($i,$j) 499 
                } elseif { $j == 2 } { 
                    set CL($i,$j) 499 }
        } elseif { $i >= 5 && $i < 10 } {
            $node_($i) set X_ 999
            $node_($i) set Y_ 499
            $node_($i) set Z_ 499 
                if { $j == 0 } {
                    set CL($i,$j) 999
                } elseif { $j == 1 } { 
                    set CL($i,$j) 499
                } elseif { $j == 2 } { 
                    set CL($i,$j) 499 }
            }
        }
    }
    # puts $CL(0,2)
    # Generation of movements
    $ns at $time "$node_(0) setdest 500.0 500.0 499.0" 
    puts $time
} else {
   puts "Please Run again with a Proper opmode (Line 24) :" 
   exit 1
}




#udp connection
set udp [new Agent/UDP]
#$udp set class_2
set null0 [new Agent/Null]
$ns attach-agent $node_(0) $udp
$ns attach-agent $node_(9) $null0

 
#generate cbr traffic
set cbr0 [new Application/Traffic/CBR]
$cbr0 set packetSize_ 500
$cbr0 set interval .005
$cbr0 attach-agent $udp
$ns connect $udp $null0
$ns at 0.1 "$cbr0 start"
 
 
 
# Define node initial position in nam
for {set i 0} {$i < $val(nn)} { incr i } {
# 90 defines the node size for nam
$ns initial_node_pos $node_($i) 30
}
 
# Telling nodes when the simulation ends
for {set i 0} {$i < $val(nn) } { incr i } {
    $ns at $val(stop) "$node_($i) reset";
}
 
# ending nam and the simulation 
$ns at $val(stop) "$ns nam-end-wireless $val(stop)"
$ns at $val(stop) "stop"
$ns at $val(stop) "puts \"END OF DSDV SIMULATION\" ; $ns halt"
proc stop {} {
    global ns tracefd namtrace
    $ns flush-trace
    close $tracefd
    close $namtrace
    exec nam simwrls.nam &
    exit 0
}
 
$ns run