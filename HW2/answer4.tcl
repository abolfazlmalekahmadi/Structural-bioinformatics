        proc print_rmsd_through_time {{mol top}} {

                set reference [atomselect $mol "protein" frame 0]
                set compare [atomselect $mol "protein"]

                set num_steps [molinfo $mol get numframes]
                for {set frame 0} {$frame < $num_steps} {incr frame} {
                        $compare frame $frame

                        set trans_mat [measure fit $compare $reference]
                        $compare move $trans_mat
                        set rmsd [measure rmsd $compare $reference]
                        puts "RMSD of $frame is $rmsd"
                }
        }
