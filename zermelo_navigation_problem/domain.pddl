;; Zermelo's Navigation problem
;; Modeled by Miquel Ramirez (miquel.ramirez@gmail.com)

;; Enrico Scala Comment: this becomes feasible only with very high delta. Tried with 100 units of time
(define
    (domain zermelo_navigation_problem)

    (:types
        ship region mode -object

    )
    (:predicates
	(starboard ?s -ship)
	(port ?s -ship)
	(ahead ?s -ship) 
    )

    (:functions

        (x ?s -ship) -number
        (y ?s -ship) -number

        (theta ?s -ship) -number
        (turn_rate ?s -ship) -number
        (velocity ?s -ship) -number

        (wind_x ?r -region) -number
        (wind_y ?r -region) -number
        (min_x ?r -region) -number
        (max_x ?r -region) -number
        (min_y ?r -region) -number
        (max_y ?r -region) -number

        (min_x_global) -number
        (max_x_global) -number
        (min_y_global) -number
        (max_y_global) -number
    )

    ;; AO bounds
    (:constraint area_ops_bounds
        :parameters (?s -ship)
        :condition (and     (> (x ?s) (min_x_global))
                            (< (x ?s) (max_x_global))
                            (> (y ?s) (min_y_global))
                            (< (y ?s) (max_y_global))
                    )
    )

    ;; ship position, depends on the local conditions of the region
    ;; it is in
    (:process displacement
        :parameters (?s -ship ?r -region)
        :precondition (and
                            (> (x ?s) (min_x ?r))
                            (<= (x ?s) (max_x ?r))
                            (> (y ?s) (min_y ?r))
                            (<= (y ?s) (max_y ?r))
                        )
        :effect (and
                        (increase (x ?s) (* #t (+ (* (cos (theta ?s)) (velocity ?s)) (wind_x ?r) )))
                        (increase (y ?s) (* #t (+ (* (sin (theta ?s)) (velocity ?s)) (wind_y ?r) )))
                )
    )

    ;; ship maneuvering
    (:process tacking_to_starboard
        :parameters (?s -ship)
        :precondition (starboard ?s)
        :effect (and
                        (increase (theta ?s) (* #t (turn_rate ?s)))
        )
    )

    (:process tacking_to_port
        :parameters (?s -ship)
        :precondition (port ?s)
        :effect (and
                        (decrease (theta ?s) (* #t (turn_rate ?s)))
        )
    )

    (:action wheel_to_starboard
        :parameters (?s -ship)
        :precondition (ahead ?s)
        :effect (and
            (starboard ?s)
            (not (ahead ?s))
        )
    )

    (:action wheel_to_port
        :parameters (?s -ship)
        :precondition (ahead ?s)
        :effect (and
            (port ?s)
            (not (ahead ?s))
        )
    )

    (:action full_sail_ahead
        :parameters (?s -ship)
        :precondition ()
        :effect (and
            (ahead ?s)
	    (not (port ?s))
	    (not (starboard ?s))
        )
    )

)
