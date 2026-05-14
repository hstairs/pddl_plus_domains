(define
    (problem zermelo_random_21)

    (:domain zermelo_navigation_problem)
    (:objects
        r0 r1 r2 r3 - region
        the_boat - ship
    )

    (:init
        ;; extent of the "map"
        (= (min_x_global) 0.0)
        (= (max_x_global) 10000.0)
        (= (min_y_global) 0.0)
        (= (max_y_global) 10000.0)

        ;; Initial boat location, heading and velocity
        (= (x the_boat) 813.0)
        (= (y the_boat) 5275.0)
        (= (velocity the_boat) 5.144) ;; speed is 10 knots or 5.144 m/s
        (= (theta the_boat) 4.18879020479) ;; initial heading is 240.0 deg, measured wrt to the boat's prow
        (= (turn_rate the_boat) 0.0174533) ;; turn rate is 1 degree / second
        (ahead) ;; boat starts going steady

        ;; Region properties
        ;; Region 0, wind velocity is (1.9,1.5) about 4.7 knots, direction 37.0 degrees
        (= (wind_x r0) 1.9)
        (= (wind_y r0) 1.5)
        (= (min_x r0) 0.0)
        (= (min_y r0) 5000.0)
        (= (max_x r0) 5000.0)
        (= (max_y r0) 10000.0)

        ;; Region 1, wind velocity is (3.1,1.2) about 6.5 knots, direction 22.0 degrees
        (= (wind_x r1) 3.1)
        (= (wind_y r1) 1.2)
        (= (min_x r1) 5000.0)
        (= (min_y r1) 5000.0)
        (= (max_x r1) 10000.0)
        (= (max_y r1) 10000.0)

        ;; Region 2, wind velocity is (2.3,2.7) about 6.8 knots, direction 49.0 degrees
        (= (wind_x r2) 2.3)
        (= (wind_y r2) 2.7)
        (= (min_x r2) 0.0)
        (= (min_y r2) 0.0)
        (= (max_x r2) 5000.0)
        (= (max_y r2) 5000.0)

        ;; Region 3, wind velocity is (0.36,-1.8) about 3.6 knots, direction 281.0 degrees
        (= (wind_x r3) 0.36)
        (= (wind_y r3) -1.8)
        (= (min_x r3) 5000.0)
        (= (min_y r3) 0.0)
        (= (max_x r3) 10000.0)
        (= (max_y r3) 5000.0)


    )

    (:goal
        (and
            (>= (x the_boat) 8000.0)
            (>= (y the_boat) 8000.0)
            (<= (x the_boat) 9000.0)
            (<= (y the_boat) 9000.0)
        )

    )

)

