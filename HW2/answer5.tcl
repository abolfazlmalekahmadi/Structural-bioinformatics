mol new 1a13.pdb

proc calculate_dihedral_angles {sel atom1 atom2 atom3 atom4} {
    set sel_copy [atomselect top "all"]
    $sel_copy set {beta} 0
    set angles [measure dihed [list $atom1 $atom2 $atom3 $atom4]]
    $sel_copy delete
    return $angles
}

set file [open "answer5.txt" w]

set sel [atomselect top "all"]
set num_residues [$sel num]

for {set i 3} {$i < $num_residues-3} {incr i} {
    $sel frame 0
    
    
    set phi [calculate_dihedral_angles $sel [expr {$i-1}] [expr {$i+1}] [expr {$i+2}] [expr {$i+3}]]
    set psi [calculate_dihedral_angles $sel [expr {$i-2}] [expr {$i-1}] [expr {$i+1}] [expr {$i+2}]]
    set omega [calculate_dihedral_angles $sel [expr {$i-3}] [expr {$i-2}] [expr {$i-1}] $i]
    
    set rg [measure rgyr $sel]
    
    puts $outfile "Residue ID: $i"
    puts $outfile "Phi: $phi"
    puts $outfile "Psi: $psi"
    puts $outfile "Omega: $omega"
    puts $outfile "Radius of Gyration: $rg"
    puts $outfile ""
}
close $file
