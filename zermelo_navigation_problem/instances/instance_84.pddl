(define
    (problem zermelo_random_84)

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
        (= (x the_boat) 7321.0)
        (= (y the_boat) 4974.0)
        (= (velocity the_boat) 5.144) ;; speed is 10 knots or 5.144 m/s
        (= (theta the_boat) 2.11184839491) ;; initial heading is 121.0 deg, measured wrt to the boat's prow
        (= (turn_rate the_boat) 0.0174533) ;; turn rate is 1 degree / second
        (ahead) ;; boat starts going steady

        ;; Region properties
        ;; Region 0, wind velocity is (-2.9,0.68) about 5.9 knots, direction 167.0 degrees
        (= (wind_x r0) -2.9)
        (= (wind_y r0) 0.68)
        (= (min_x r0) 0.0)
        (= (min_y r0) 5000.0)
        (= (max_x r0) 5000.0)
        (= (max_y r0) 10000.0)

        ;; Region 1, wind velocity is (-2.9,-0.41) about 5.8 knots, direction 188.0 degrees
        (= (wind_x r1) -2.9)
        (= (wind_y r1) -0.41)
        (= (min_x r1) 5000.0)
        (= (min_y r1) 5000.0)
        (= (max_x r1) 10000.0)
        (= (max_y r1) 10000.0)

        ;; Region 2, wind velocity is (-0.85,1.1) about 2.7 knots, direction 127.0 degrees
        (= (wind_x r2) -0.85)
        (= (wind_y r2) 1.1)
        (= (min_x r2) 0.0)
        (= (min_y r2) 0.0)
        (= (max_x r2) 5000.0)
        (= (max_y r2) 5000.0)

        ;; Region 3, wind velocity is (0.23,-1.9) about 3.7 knots, direction 277.0 degrees
        (= (wind_x r3) 0.23)
        (= (wind_y r3) -1.9)
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

