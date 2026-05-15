(define
    ;; domain file for describing the dynamics of HAPS in a 2D world
    ;; The local 2D Cartesian coordinate system take the initial position of the HAPS as origin with
    ;; the x-axis pointing to the East while the y-axis to the North.
    (domain haps_2dim)

    ;; moving obstacles assumed rectangular in the current problem
    (:types moving_obstacle static_obstacle -object)

    (:predicates
	(motor_running) ;; Electric motors of the HAPS are both started and stopped by one boolean.
	(motor_stopped)
    )

    (:functions
        (time_step) ;; time in [s] with the first instant equal 0s
	(previous_time_step)
	(relative_position_north) ;; relative position [m] w.r.t. the origin in North direction
	(relative_position_east) ;; relative position [m] w.r.t. the origin in North direction
        (v) ;; airspeed in [m/s] of the HAPS (considered constant to the optimal airspeed in the current problem)
	(heading) ;; angle [radian] measured clockwise from the North direction
	(heading_rate) ;; variation of heading over time  [rad/s]
        (wind_velocity_north) ;; North-component of the wind field [m/s]; wind field is assumed homogeneous 
        (wind_velocity_east) ;; East-component of the wind field [m/s]; wind field is assumed homogeneous
        (max_heading_rate) ;; Max turn rate [rad/s] of HAPS 
        (min_heading_rate) ;; Min turn rate [rad/s] of HAPS 
	(limit_space_north) ;; boundary [m] of the planning space in the North-direction
	(limit_space_south) ;; boundary [m] of the planning space in the South-direction
	(limit_space_east) ;; boundary [m] of the planning space in the East-direction
	(limit_space_west) ;; boundary [m] of the planning space in the West-direction
	(bound_south ?static_obs -static_obstacle) ;; southern boundary [m] of the rectangular static obstacle
	(bound_north ?static_obs -static_obstacle) ;; northern limit [m] of the rectangular static obstacle
	(bound_east ?static_obs -static_obstacle) ;; eastern limit [m] of the rectangular static obstacle
	(bound_west ?static_obs -static_obstacle) ;; western limit [m] of the rectangular static obstacle
	(bound_south ?moving_obs -moving_obstacle) ;; southern boundary [m] of the rectangular moving obstacle
	(bound_north ?moving_obs -moving_obstacle) ;; northern limit [m] of the rectangular moving obstacle
	(bound_east ?moving_obs -moving_obstacle) ;; eastern limit [m] of the rectangular moving obstacle
	(bound_west ?moving_obs -moving_obstacle) ;; western limit [m] of the rectangular moving obstacle
    )

    ;; constraint on the turning rate 
    (:constraint heading_rate_limit
        :parameters ()
        :condition (or  
			(and
				(> (heading_rate) (min_heading_rate)) 
				(< (heading_rate) (max_heading_rate))
			)
                )
    )

    ;; set boundaries to the planning space
    (:constraint go_area
     :parameters ()
     :condition (not 
                    	(or  
				(< relative_position_north (limit_space_south)) 
				(> relative_position_north (limit_space_north)) 
				(< relative_position_east (limit_space_west)) 
				(> relative_position_east (limit_space_east)) 
			)
                )
    )

    ;; no entry to the areas occupied by moving obstacles
    (:constraint static_obstacles
     :parameters (?static_obs -static_obstacle)
     :condition (not 
                    	(or  
				(and
					(< relative_position_north (bound_north ?static_obs))
					(> relative_position_north (bound_south ?static_obs))
					(< relative_position_east (bound_east ?static_obs))
					(> relative_position_east (bound_west ?static_obs))					
				) 
			)
                )
    )

    ;; no entry to the areas occupied by moving obstacles
    (:constraint moving_obstacles
     :parameters (?moving_obs -moving_obstacle)
     :condition (not 
                    	(or  
				(and
					(< relative_position_north (bound_north ?moving_obs))
					(> relative_position_north (bound_south ?moving_obs))
					(< relative_position_east (bound_east ?moving_obs))
					(> relative_position_east (bound_west ?moving_obs))					
				) 
			)
                )
    )

    ;; increase time step
    (:process increase_time_step
	:parameters  ()
	:precondition (and (motor_running))
	:effect (
		increase (time_step) (#t)
	)
    )

    ;; displacement of the HAPS due to the motors (only airspeed is accounted for) 
    (:process displacement_motor
        :parameters ()
        :precondition (and (motor_running) (> (v) 0))
        :effect (and 
			(increase (relative_position_north) (* #t (* v (cos heading))))  
			(increase (relative_position_east) (* #t (* v (sin heading)))) 
	)
    )

    ;; displacement of the HAPS due to windspeed and wind direction
    (:process displacement_wind
        :parameters ()
        :precondition (motor_running)
        :effect (and  
			(increase (relative_position_north) (* #t (wind_velocity_north)))
			(increase (relative_position_east) (* #t (wind_velocity_east)))
	)
    )

   ;; update heading with heading rate
   (:process vary_heading
       :parameters ()
       :precondition (and 
			(motor_running) 
			(>(v) 0)
      	)
        :effect (and
                    (increase (heading)  (* #t (heading_rate)) )   
        )
    )

   ;; displacement of the moving obstacles, e.g. clouds, along with the wind (the movement is assumed deterministic) 
   (:process obstacles_shift
       :parameters (?moving_obs -moving_obstacle)
       :precondition ()
       :effect (and
                   (increase (bound_east ?moving_obs)  (* #t (wind_velocity_east)) )   
                   (increase (bound_west ?moving_obs)  (* #t (wind_velocity_east)) )   
                   (increase (bound_north ?moving_obs)  (* #t (wind_velocity_north)) )
                   (increase (bound_south ?moving_obs)  (* #t (wind_velocity_north)) )
       )
    ) 

    ;; to simplify, heading rate can be increased by a step of 0.018 per time step
    (:action increase_heading_rate
        :parameters ()
        :precondition (and	
			(motor_running)
			(< previous_time_step time_step)
	)
        :effect (and
			(increase (heading_rate) 0.018)
			(assign previous_time_step time_step)
	)  
    )


    ;; similarly, to simplify, heading rate can be decreased by a step of 0.018 per time step
    (:action decrease_heading_rate
        :parameters ()
        :precondition (and 
			(motor_running)
			(< previous_time_step time_step)
	)
        :effect (and
			(decrease (heading_rate) 0.018)
			(assign previous_time_step time_step)
	)  
    )
    
    ;; start HAPS motor: assumption that HAPS can only operate when the motor is running
    (:action start_haps
        :parameters ()
        :precondition (motor_stopped)
        :effect (and
		    (assign (v) 9.0)
                    (motor_running)
                    (not (motor_stopped))
                )
    )
)
