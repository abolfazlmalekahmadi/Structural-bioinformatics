proc calculateSecondaryStructures {id} {
    set secondaryStructures {C T G B E H}
    set totalFrames [molinfo $id get numframes]
    set structureNames {
        C "coil or loop region"
        T "turn or bend region"
        G "alpha-helix"
        B "beta-strand"
        E "beta-strand"
        H "alpha-helix"
    }
    
    puts "Secondary structures:"
    puts "C: Representing a coil or loop region."
    puts "T: Representing a turn or bend region."
    puts "G or H: Representing an alpha-helix."
    puts "B or E: Representing a beta-strand."
    
    for {set frame 0} {$frame < $totalFrames} {incr frame} {
        puts "Frame: $frame"
        set selection [atomselect $id all frame $frame]
        set totalResidues [$selection num]

        foreach secStruct $secondaryStructures {
            set structSelection [atomselect $id "protein and structure $secStruct" frame $frame]
            set count [expr {[$structSelection num] * 100}]
            set proportion [expr {double($count) / $totalResidues}]
            set structName [dict get $structureNames $secStruct]
            
            puts "Number of $structName: $proportion%"
        }

        puts "=========================================="
    }
}


 