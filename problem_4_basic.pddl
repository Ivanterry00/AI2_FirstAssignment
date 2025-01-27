; Problem 4: There are 2 customers at table 4 and 2 customers at table 1:
; they all ordered cold drinks. There are also 4 customers at table 3: they all ordered warm drinks. Table 4 needs to be cleaned.

(define(problem istance)

    (:domain coffe-bar)
    (:objects
        barista - barista

        drink1_warm - warm
        drink2_warm - warm
        drink3_warm - warm
        drink4_warm - warm
        drink5_cold - cold
        drink6_cold - cold
        drink7_cold - cold
        drink8_cold - cold


        bar_counter - bar
        table1 - table
        table2 - table
        table3 - table
        table4 - table

        waiter - waiter
            
        tray - tray
    )

    (:init
        

        (free_barista barista)
        (free_waiter waiter)

        (at_barista bar_counter)
        (at_waiter bar_counter)
        (at_tray bar_counter)

    
        (cleaned table4)
        (cleaned table1)
        (cleaned table3)

        (connected bar_counter table1)
        (connected bar_counter table2)
        (connected table2 bar_counter)
        (connected table1 bar_counter)
        (connected table1 table3)
        (connected table3 table1)
        (connected table2 table3)
        (connected table3 table2)
        (connected table2 table4)
        (connected table4 table2)
        (connected table1 table4)
        (connected table4 table1)
        (connected table3 table4)
        (connected table4 table3)
        (connected table1 table2)
        (connected table2 table1)

        (=(distance bar_counter table1) 2.0)
        (=(distance bar_counter table2) 2.0)
        (=(distance table1 bar_counter) 2.0)
        (=(distance table2 bar_counter) 2.0)
        (=(distance table3 table1) 1.0)
        (=(distance table2 table3) 1.0)
        (=(distance table1 table3) 1.0)
        (=(distance table3 table2) 1.0)
        (=(distance table2 table4) 1.0)
        (=(distance table4 table2) 1.0)
        (=(distance table1 table4) 1.0)
        (=(distance table4 table1) 1.0)
        (=(distance table3 table4) 1.0)
        (=(distance table4 table3) 1.0)
        (=(distance table1 table2) 1.0)
        (=(distance table2 table1) 1.0)

        (=(distance_covered waiter) 0.0)
        (=(real_distance waiter)0.0)

        (= (duration_drink drink1_warm) 5.0)
        (= (duration_drink drink2_warm) 5.0)
        (= (duration_drink drink3_warm) 5.0)
        (= (duration_drink drink4_warm) 5.0)
        (= (duration_drink drink5_cold) 3.0)
        (= (duration_drink drink6_cold) 3.0)
        (= (duration_drink drink7_cold) 3.0)
        (= (duration_drink drink8_cold) 3.0)

        (=(table_dimension table1) 1.0)
        (=(table_dimension table2) 1.0)
        (=(table_dimension table3) 2.0)
        (=(table_dimension table4) 1.0)

        (=(tray_capacity tray) 0.0)
    )
    
    (:goal
        (and
            (at_drink table3 drink1_warm)
            (at_drink table3 drink2_warm)
            (at_drink table3 drink3_warm)
            (at_drink table3 drink4_warm)

            (at_drink table4 drink5_cold)
            (at_drink table4 drink6_cold)
            (at_drink table1 drink7_cold)
            (at_drink table1 drink8_cold)

            (cleaned table2)
        )
    )

    (:metric minimize(total-time))
)