;; This is an instance file for finding a feasible path for a HAPS
;; in a 2D space without obstacle
;; Start: center, heading-north
;; Target: north-east
(define (problem instance)
  (:domain haps_2dim)
  (:objects
	static_obs1 -static_obstacle
	moving_obs1 -moving_obstacle
  )

  (:init
	(= (time_step) 0.0)
	(= (previous_time_step) 0.0)
	(= (total-cost) 0)
	(= (cost_static_obstacle) 10.0)
	(= (cost_moving_obstacle) 10.0)
	(motor_stopped)
	(= (relative_position_north) 0.0)
	(= (relative_position_east) 0.0)
        (= (v) 0.0)
	(= (heading) 0.0)
	(= (heading_rate) 0.0)
        (= (wind_velocity_north) 4.0)
        (= (wind_velocity_east) -2.0)
        (= (max_heading_rate) 0.1)
	(= (min_heading_rate) -0.1)
	(= (limit_space_north) 10000.0)
	(= (limit_space_south) -10000.0)
	(= (limit_space_east) 10000.0)
	(= (limit_space_west) -10000.0)
	(= (bound_north static_obs1) 500.0)
	(= (bound_south static_obs1) 450.0)
	(= (bound_east static_obs1) 50.0)
	(= (bound_west static_obs1) 10.0)
	(= (bound_north moving_obs1) 5700.0)
	(= (bound_south moving_obs1) 5500.0)
	(= (bound_east moving_obs1) 4800.0)
	(= (bound_west moving_obs1) 4000.0)
  )

  (:goal
    (and 
	(>= (relative_position_north) 9500.0 )
	(<= (relative_position_north) 9900.0 )
	(>= (relative_position_east) 9500.0 )
	(<= (relative_position_east) 9900.0 )
    )
  )
)
