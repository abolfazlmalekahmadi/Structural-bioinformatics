proc convertAminoAcid {threeLetterCode} {
    switch -exact -- $threeLetterCode {
        ALA {return "A"}
        ARG {return "R"}
        ASN {return "N"}
        ASP {return "D"}
        CYS {return "C"}
        GLN {return "Q"}
        GLU {return "E"}
        GLY {return "G"}
        HIS {return "H"}
        ILE {return "I"}
        LEU {return "L"}
        LYS {return "K"}
        MET {return "M"}
        PHE {return "F"}
        PRO {return "P"}
        SER {return "S"}
        THR {return "T"}
        TRP {return "W"}
        TYR {return "Y"}
        VAL {return "V"}
        default {return ""}
    }
}

# Get the amino acid sequence
set sel [atomselect top "protein"]
set sequence [$sel get {resname}]
$sel delete

# Convert three-letter code to one-letter code
set oneLetterSequence ""
foreach aa $sequence {
    set oneLetterCode [convertAminoAcid $aa]
    if {$oneLetterCode ne ""} {
        append oneLetterSequence $oneLetterCode
    }
}

# Print the one-letter amino acid sequence
puts "One-Letter Sequence: $oneLetterSequence"

# Define the amino acid groups
set hydrophobic {A G C F I L M P V W }
set polar {N Q S T Y}
set charged {D E H K R}

# Initialize counters
set hydrophobic_count 0
set polar_count 0
set charged_count 0
set neutral_polar_count 0

foreach aa [split $oneLetterSequence ""] {
    # Check which group the amino acid belongs to
    if {$aa in $hydrophobic} {
        incr hydrophobic_count
    } elseif {$aa in $polar} {
        incr polar_count
        if {$aa eq "N" || $aa eq "Q"} {
            incr neutral_polar_count
        }
    } elseif {$aa in $charged} {
        incr charged_count
    } else {
        incr neutral_polar_count
    }
}

set total [expr {$hydrophobic_count + $polar_count + $charged_count + $neutral_polar_count}]
set hydrophobic_percent [expr {100.0 * $hydrophobic_count / $total}]
set polar_percent [expr {100.0 * $polar_count / $total}]
set charged_percent [expr {100.0 * $charged_count / $total}]
set neutral_polar_percent [expr {100.0 * $neutral_polar_count / $total}]

# Print the results
puts "Amino acid sequence: $sequence"
puts "Hydrophobic amino acids: $hydrophobic_count ($hydrophobic_percent%)"
puts "Polar amino acids: $polar_count ($polar_percent%)"
puts "Charged amino acids: $charged_count ($charged_percent%)"
puts "Neutral polar amino acids: $neutral_polar_count ($neutral_polar_percent%)"