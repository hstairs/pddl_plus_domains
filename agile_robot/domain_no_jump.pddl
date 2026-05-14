;; Enrico Scala (enricos83@gmail.com) and Miquel Ramirez (miquel.ramirez@gmail.com)
(define
    (domain agile_robot_world_simple)

    (:predicates
        (steering_left)
        (steering_right)
        (can_steer_left)
        (can_steer_right)
        (stepping)
        (jumping)
        (accelerating)
        (decelerating)
    )

    (:functions
        ;; Positions
        (x)
        (y)
        ;; Velocities
        (v_x)
        (v_y)
        ;; Bounds
        (min_x)
        (max_x)
        (min_y)
        (max_y)
        ;; Acceleration, deceleration and steering constants
        (k_acc)
        (k_dec)
        (k_steer)
    )

    ;; Surface bounds
    (:constraint surface_bounds
        :parameters ()
        :condition (and (>= (x) (min_x)) (<= (x) (max_x)) (>= (y) (min_y)) (<= (y) (max_y)) )
    )

    ;; robot position determined by velocities along each axis, this is always
    ;; active, equations
    ;; \dot{x} = v_x
    ;; \dot{y} = v_y
    (:process displacement
        :parameters ()
        :precondition ()
        :effect (and
                        (increase (x) (* #t (v_x)))
                        (increase (y) (* #t (v_y)))
                )
    )

    ;; stepping and jumping have the same dynamics, yet when jumping "state constraints"
    ;; are "turned off" by being trivially true. Dynamics are given as a "simple double
    ;; integrator" i.e. "velocities remain constant"

    (:process stepping_dynamics
    :parameters ()
    :precondition (and (stepping) )
    :effect (and
                    (increase (v_x) (* #t 0.0))
                    (increase (v_y) (* #t 0.0))
            )
    )

    (:process jumping_dynamics
        :parameters ()
        :precondition (and (jumping))
        :effect (and
                        (increase (v_x) (* #t 0.0))
                        (increase (v_y) (* #t 0.0))
                )
    )

    ;; As per equation 3.21 in page 36
    (:process accelerating_dynamics
        :parameters ()
        :precondition (and (accelerating))
        :effect (and
                    (increase (v_x) (* #t (* (k_acc) (v_x))))
                    (increase (v_y) (* #t (* (k_acc) (v_y))))
                )
    )

    ;; As per equation 3.22 in page 36
    (:process decelerating_dynamics
        :parameters ()
        :precondition (and (decelerating))
        :effect (and
                    (decrease (v_x) (* #t (* (k_dec) (v_x))))
                    (decrease (v_y) (* #t (* (k_dec) (v_y))))
                )
    )

    ;; As per equation 3.23 in page 36
    (:process steering_right_dynamics
        :parameters ()
        :precondition (and (steering_right))
        :effect (and
                    (increase (v_x) (* #t (* (k_steer) (v_y))))
                    (decrease (v_y) (* #t (* (k_steer) (v_x))))
                )
    )

    ;; As per equation 3.24 in page 36
    (:process steering_left_dynamics
        :parameters ()
        :precondition (and (steering_left))
        :effect (and
                    (decrease (v_x) (* #t (* (k_steer) (v_y))))
                    (increase (v_y) (* #t (* (k_steer) (v_x))))

                )
    )

    ;; Instantaneous actions, follow from Table 3.1

    (:action step
        :parameters ()
        :precondition ()
        :effect (and
                    (stepping)
                    (can_steer_left)
                    (can_steer_right)
                    (not (jumping))
                    (not (accelerating))
                    (not (decelerating))
                    (not (steering_right))
                    (not (steering_left))

                )
    )

    (:action accelerate
        :parameters ()
        :precondition ()
        :effect (and
                    (accelerating)
                    (can_steer_left)
                    (can_steer_right)
                    (not (jumping))
                    (not (stepping))
                    (not (decelerating))
                    (not (steering_right))
                    (not (steering_left))
                )
    )

    (:action decelerate
        :parameters ()
        :precondition ()
        :effect (and
            (decelerating)
            (can_steer_left)
            (can_steer_right)
            (not (jumping))
            (not (stepping))
            (not (accelerating))
            (not (steering_right))
            (not (steering_left))
        )
    )



    (:action steer_right
        :parameters ()
        :precondition (and (can_steer_right))
        :effect (and
            (steering_right)
            (not (can_steer_left))
            (can_steer_right)
            (not (decelerating))
            (not (stepping))
            (not (accelerating))
            (not (jumping))
            (not (steering_left))
        )
    )

    (:action steer_left
        :parameters ()
        :precondition (and (can_steer_left))
        :effect (and
            (steering_left)
            (not (can_steer_right))
            (can_steer_left)
            (not (decelerating))
            (not (stepping))
            (not (accelerating))
            (not (jumping))
            (not (steering_right))

        )
    )


)
