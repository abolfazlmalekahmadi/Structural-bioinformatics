mol new 1a48.pdb
proc find_ssbonds {{dist 2000}} {
    puts "Detecting S-S bonds based on distance < ${dist} Å"
    set ssbonds [list]
    set sel [atomselect top "resname CYS and name SG"]

    foreach sg [$sel get {index segid segname chain resid}] {
        foreach {index segid segname chain resid} $sg {break}
        set segkey [lindex [list seg $segname chain $chain segid $segid] [expr {[llength $segname] == 0 ? 2 : 0}]]
        set segment [lindex [list $segname $chain $segid] [expr {[llength $segname] == 0 ? 2 : 0}]]

        set sel2 [atomselect top "(not resid $resid) and resname CYS and name SG and index > $index and within $dist of index $index"]

        if {[$sel2 num]} {
            set sg2 [$sel2 get {segid segname chain resid}]
            set segid2 [lindex $sg2 0]
            set segname2 [lindex $sg2 1]
            set chain2 [lindex $sg2 2]
            set resid2 [lindex $sg2 3]

            set segkey2 [lindex [list seg $segname2 chain $chain2 segid $segid2] [expr {[llength $segname2] == 0 ? 2 : 0}]]
            set segment2 [lindex [list $segname2 $chain2 $segid2] [expr {[llength $segname2] == 0 ? 2 : 0}]]

            lappend ssbonds [list $segkey $segment $resid $segkey2 $segment2 $resid2]
        }
    }

    $sel delete
    return $ssbonds
}

# Call the find_ssbonds procedure on the loaded molecule
set ssbonds_list [find_ssbonds]

# Print the detected S-S bonds
puts "Detected S-S bonds:"
foreach ssbond $ssbonds_list {
    puts [join $ssbond " - "]
}