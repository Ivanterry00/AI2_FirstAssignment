(define (domain coffe-bar)

(:requirements :strips :adl :fluents :timed-initial-literals :typing :conditional-effects :negative-preconditions :duration-inequalities :equality :time )
 
(:types 
    drink tray robot - object
    cold warm - drink
    biscuit - food
    barista waiter - robot
    bar table - location
)
 
(:predicates 
    (ready ?d-drink)    ;Predicate to indicate if the drink is ready.
    (preparing ?d-drink)    ;Predicate to indicate if the drink is being prepared.
    (drink_served ?d)   ;Predicate to indicate if the drink was served.
    (carrying_drink ?d-drink)   ;Predicate to indicate if the drink is being brought.

    (at_drink ?l-location ?d-drink) ;Predicate to indicate the location of the drink.
 
    (free_barista ?b-barista)   ;Predicate to indicate if the barista if free.
    (at_barista ?l-location )   ;Predicate to indicate the location of the barista.
    
    (at_drink_tray ?d-drink ?t-tray)    ;Predicate ot indicate the location of the drink on the tray.
    (drink_on_tray ?d - drink ?t - tray)    ;Predicate to indicate if the drink is on the tray.
    
    (at_tray ?l-location )  ;Predicate to indicate the location of the tray.
    (carrying_tray ?w-waiter ?t-tray)   ;Predicate to indicate if the waiter is carring the tray.
    (moving_with_tray ?w - waiter ?t - tray)    ;Predicate to indicate if the waiter is moving with the tray.
 
    (at_waiter ?l-location )    ;Predicate to indicate the location of the waiter.
    (free_waiter ?w-waiter) ;Predicate to indicate if the waiter is free.
    (moving ?w-waiter)  ;Predicate to indicate if waiter is moving.
    
    (connected ?l1-location ?l2-location) ;Predicate to indicate if the locations are connected.
 
    (cleaning ?l - table )  ;Predicate to indicate if table is being cleaned.
    (cleaned ?l - table)    ;Predicate to indicate if the table has been cleaned.
    
 
    (at_biscuit ?l-location ?c-food) ;Predicate to indicate the location of the biscuit.
    (carrying_biscuit ?c-food) ;Predicate to indicate if the biscuit is being brought.
    (biscuit_on_tray ?c - food ?t - tray)    ;Predicate to indicate if the biscuit is on the tray.
    (biscuit_served ?c - food)  ;Predicate to indicate if the biscuit was served.
    (together ?c - food ?d - cold) ;Predicate to indicate if the drink and the biscuit are together.
    (drinking ?d - drink)   ;Predicate to indicate if the drink is being drunk.
    (finished ?d - drink)   ;Predicate to indicate if the drink was finished.
    (dirty ?l - table)  ;Predicate to indicate if the table is dirty.
    (unvaible ?d - drink)   ;Predicate to indicate if the drink is unvaible.
    (unavailable ?d - drink)    ;Predicate to indicate if the drink is unavailable.
    (unavailable_biscuit ?c - food) ;Predicate to indicate if the biscuit is unavailable.
    (start_cooling_down ?d - warm)  ;Predicate to indicate if the drink is cooling down.
    (servable ?d - drink)   ;Predicate to indicate if the drink is servable.
)
 
(:functions 
    (duration_drink ?d - drink) ;Function to define the durantion of the preparation of drink.
 
    (distance ?l1-location ?l2-location)    ;Function to define the durantion of the preparation of drink.
    (cleaning_duration ?l - table)  ;Function to define the durantion of the cleaning table.
    (table_dimension ?l - table)    ;Function to define the dimension of table.
    (tray_capacity ?t - tray)   ;Function to define the capacity of the tray.
    
    (tray_capacity_biscuit ?t-tray) ;Function to define the capacity of the tray.
 
    (real_distance ?w - waiter) ;Function to define the real distance traveled by the waiter.
    (distance_covered ?w - waiter)  ;Function to define the distance covered by the waiter.
    (finishing_drink ?d - drink)    ;Function to define the time to finish the drink.
    (counter_client ?l - table) ;Function to define the number of clients at the counter.
    (counter ?d - drink)    ;Function to define the number of drinks at the counter.
    (duration_cool_down ?d - warm)  ;Function to define the duration of the cooling down of the drink.
)
 
(:action prepare-drink
    :parameters (?d - drink ?b - barista ?l - bar)
    :precondition (and (free_barista ?b) (at_barista ?l) (not (ready ?d)) (not (preparing ?d)))
    :effect (and (not (free_barista ?b)) (preparing ?d))
)
 
(:process preparing-drink
    :parameters (?d - drink)
    :precondition (and
        (preparing ?d)
    )
    :effect (and
        (decrease (duration_drink ?d) (* #t 1.0 ))
    )
)
 
(:event ready-drink 
    :parameters (?d - drink ?b - barista ?l - bar)
    :precondition (and
        (preparing ?d)
        (= (duration_drink ?d) 0.0)
    )
    :effect (and
        (ready ?d)
        (free_barista ?b)
        (at_drink ?l ?d)
        (not (preparing ?d))
    )
)

; (:action start-cool-down
;     :parameters (?d - warm)
;     :precondition (and (ready ?d))
;     :effect (and (start_cooling_down ?d)) 
; )

; (:process cooling-down
;     :parameters (?d - warm)
;     :precondition (and
;         (start_cooling_down ?d)
;     )
;     :effect (and
;         (decrease (duration_cool_down ?d) (* #t 1.0))
;     )
; )
; (:event cooled-down
;     :parameters (?d - warm)
;     :precondition (and
;         (start_cooling_down ?d)
;         (= (duration_cool_down ?d) 0.0)
;     )
;     :effect (and
;         (not (start_cooling_down ?d))
;         (not(servable ?d))
;     )
; )
 
(:action pick-drink
    :parameters (?w - waiter ?d - drink  ?l - bar)
    :precondition (and (at_drink ?l ?d) (free_waiter ?w) (at_waiter ?l) (ready ?d) (not (moving ?w))) ;(servable ?d))
    :effect (and (carrying_drink ?d) (not (at_drink ?l ?d)) (not (free_waiter ?w)))
)
 
(:action serve-drink
    :parameters (?w - waiter ?d - drink ?l - table)
    :precondition (and (at_waiter ?l) (carrying_drink ?d) (not (free_waiter ?w)) (not (moving ?w)))
    :effect (and (not (carrying_drink ?d)) (free_waiter ?w) (at_drink ?l ?d) (drink_served ?d))
)
 
(:action pick-biscuit
    :parameters (?w - waiter ?c - food ?d - cold ?l - bar)
    :precondition (and (together ?c ?d)(drink_served ?d)(at_biscuit ?l ?c) (free_waiter ?w) (at_waiter ?l) (not (moving ?w)))
    :effect (and (carrying_biscuit ?c) (not (at_biscuit ?l ?c)) (not (free_waiter ?w)))
)
 
(:action serve-biscuit
    :parameters ( ?w - waiter ?l - table ?d - cold ?c - food)
    :precondition (and (together ?c ?d)(at_waiter ?l) (drink_served ?d) (carrying_biscuit ?c)(not (free_waiter ?w)) (not (moving ?w)))
    :effect (and (not (carrying_biscuit ?c)) (free_waiter ?w) (at_biscuit ?l ?c)(biscuit_served ?c))
)

(:action start-drinking-cold
    :parameters (?d -  cold ?l - table ?c - food)
    :precondition (and  (at_drink ?l ?d)(at_biscuit ?l ?c) (drink_served ?d) (biscuit_served ?c) (not (drinking ?d)) (not (finished ?d)) (>(counter_client ?l) 0.0)(not (unavailable_biscuit ?c)))
    :effect (and (drinking ?d) (unavailable_biscuit ?c))
)

(:action start-drinking-warm
    :parameters (?d -  warm ?l - table )
    :precondition (and  (at_drink ?l ?d) (drink_served ?d)(not (drinking ?d)) (not (finished ?d)) (>(counter_client ?l) 0.0))
    :effect (and (drinking ?d))
)

(:process drinking
    :parameters ( ?d - drink)
    :precondition (and
        (drinking ?d)
    )
    :effect (and
        (decrease (finishing_drink ?d) (* #t 1.0 ))
    )
)

(:event finish-drink
    :parameters ( ?d - drink  )
    :precondition (and
        (drinking ?d)
        (= (finishing_drink ?d) 0.0)
    )
    
    :effect (and
        (not (drinking ?d))
        (finished ?d)
    )
)

(:action finished-drink
    :parameters ( ?d - drink ?l - table)
    :precondition (and (finished ?d) (at_drink ?l ?d) (not (drinking ?d)) (>(counter_client ?l) 0.0) (not(unavailable ?d)))
    :effect (and (decrease (counter_client ?l) 1.0)(unavailable ?d))
)


(:action can-clean
    :parameters ( ?l - table  ) 
    :precondition (and (=(counter_client ?l ) 0.0 ) )
    :effect (and  (dirty ?l)  (not(cleaned ?l)) (not (cleaning ?l )))
)
 
(:action start-move
    :parameters (?w - waiter  ?from - location ?to - location)
    :precondition (and (at_waiter ?from) (connected ?from ?to) (not (moving ?w)))
    :effect (and (moving ?w) (not (at_waiter ?from)) (at_waiter ?to) (assign (real_distance ?w) (distance ?from ?to)))
)
 
(:process MOVE-WAITER
    :parameters (?w - waiter)
    :precondition (and
        (moving ?w)    
    )
    :effect (and
        (increase (distance_covered ?w) (* #t 2.0)) 
    )
)
 
(:event arrive-waiter
    :parameters (?w - waiter)
    :precondition (and
        (moving ?w)
        (= (distance_covered ?w) (real_distance ?w))
    )
    :effect (and
        (not (moving ?w))
        (assign (distance_covered ?w) 0.0)
    )
)
 
(:action start-clean
    :parameters (?w - waiter ?l - table)
    :precondition (and (at_waiter ?l) (free_waiter ?w) (not (cleaned ?l)) (not (cleaning ?l)) (not (moving ?w)) (dirty ?l))
    :effect (and (cleaning ?l))
)
 
(:process CLEANING
    :parameters (?l - table ?w - waiter)
    :precondition (and
        (cleaning ?l)
        (not (moving ?w))
    )
    :effect (and
        (decrease (table_dimension ?l) (* #t 2.0))
    )
)
 
(:event clean-table-done
    :parameters (?l - table ?w - waiter)
    :precondition (and
        (cleaning ?l)
        (= (table_dimension ?l) 0.0)
        (not (moving ?w))
    )
    :effect (and
        (assign (cleaning_duration ?l) 0.0)
        (not (cleaning ?l))
        (cleaned ?l)
    )
)
 
(:action load-tray-biscuit
    :parameters (?w - waiter ?t - tray ?d - cold ?c - food ?l - bar)
    :precondition (and (together ?c ?d)(at_biscuit ?l ?c) (at_waiter ?l) (at_tray ?l) (free_waiter ?w)
                       (not (moving ?w))(=(tray_capacity ?t)0.0)(< (tray_capacity_biscuit ?t) 3.0) (not(drink_on_tray ?d ?t))(drink_served ?d))
    :effect (and (biscuit_on_tray ?c ?t) (not (at_biscuit ?l ?c)) (increase (tray_capacity_biscuit ?t) 1.0))
)
 
(:action load-tray-drink
    :parameters (?w - waiter ?t - tray ?d - drink  ?c - food ?l - bar)
    :precondition (and (at_drink ?l ?d) (at_waiter ?l) (at_tray ?l) (free_waiter ?w)
                       (not (moving ?w)) (=(tray_capacity_biscuit ?t)0.0)(< (tray_capacity ?t) 3.0) (not(biscuit_on_tray ?c ?t)) (ready ?d))
    :effect (and (drink_on_tray ?d ?t) (not (at_drink ?l ?d)) (increase (tray_capacity ?t) 1.0))
)
 
(:action pick-tray-drink
    :parameters (?w - waiter ?t - tray  ?l - bar)
    :precondition (and  (at_tray ?l) (free_waiter ?w) (at_waiter ?l) (> (tray_capacity ?t) 1.0))
    :effect (and (carrying_tray ?w ?t) (not (free_waiter ?w)))
)
 
(:action pick-tray-biscuit
    :parameters (?w - waiter ?t - tray  ?l - bar)
    :precondition (and  (at_tray ?l) (free_waiter ?w) (at_waiter ?l) (> (tray_capacity_biscuit ?t) 1.0))
    :effect (and (carrying_tray ?w ?t) (not (free_waiter ?w)))
)
 
(:action serve-drink-tray
    :parameters (?w - waiter ?d - drink  ?l - table ?t - tray)
    :precondition (and (at_waiter ?l) (at_tray ?l) (carrying_tray ?w ?t) (not (free_waiter ?w)) 
                       (not (moving ?w)) (not (moving_with_tray ?w ?t)) (drink_on_tray ?d ?t) (> (tray_capacity ?t) 0.0))
    :effect (and (not (drink_on_tray ?d ?t)) (at_drink ?l ?d) (drink_served ?d) (decrease (tray_capacity ?t) 1.0))
)
 
(:action serve-biscuit-tray
    :parameters (?w - waiter ?c - food ?d - cold ?l - table ?t - tray)
    :precondition (and (together ?c ?d)(drink_served ?d)(at_waiter ?l) (at_tray ?l) (carrying_tray ?w ?t) (not (free_waiter ?w)) 
                       (not (moving ?w)) (not (moving_with_tray ?w ?t)) (biscuit_on_tray ?c ?t) (> (tray_capacity_biscuit ?t) 0.0))
    :effect (and (not (biscuit_on_tray ?c ?t)) (at_biscuit ?l ?c) (biscuit_served ?c) (decrease (tray_capacity_biscuit ?t) 1.0))
)
 
(:action unload-tray
    :parameters (?w - waiter ?t - tray ?l - bar)
    :precondition (and (at_tray ?l) (at_waiter ?l) (carrying_tray ?w ?t) (not (free_waiter ?w)) 
                       (not (moving_with_tray ?w ?t)) (= (tray_capacity_biscuit ?t) 0.0)(= (tray_capacity ?t) 0.0))
    :effect (and  (not (carrying_tray ?w ?t)) (free_waiter ?w) (at_tray ?l))
)
 
(:action start-move-tray
    :parameters (?w - waiter ?t - tray ?from - location ?to - location)
    :precondition (and (at_waiter ?from) (connected ?from ?to) (not (moving ?w)) (not (moving_with_tray ?w ?t))
                       (carrying_tray ?w ?t) (at_tray ?from)) 
    :effect (and (moving_with_tray ?w ?t) (not (at_waiter ?from)) (at_waiter ?to) (at_tray ?to) (not (at_tray ?from))
                 (assign (real_distance ?w) (distance ?from ?to)))
)
 
(:process MOVE-WAITER-TRAY
    :parameters (?w - waiter ?t - tray)
    :precondition (and 
        (moving_with_tray ?w ?t) (not (moving ?w)) (carrying_tray ?w ?t)
    )    
    :effect (and
        (increase (distance_covered ?w) (* #t 1.0))
    )
)
 
(:event arrive-waiter-tray
    :parameters (?w - waiter ?t - tray)
    :precondition (and
        (not (moving ?w))
        (moving_with_tray ?w ?t)
        (= (distance_covered ?w) (real_distance ?w))
        (carrying_tray ?w ?t)
    )
    :effect (and
        (not (moving_with_tray ?w ?t))
        (assign (distance_covered ?w) 0.0)
    )
)
)
 
 
 
