#!/usr/bin/python3
import random
import numpy as np
import matplotlib
import math
import sys
import os
import string
import shutil
import scipy.constants

def mps_to_knots(a):
    """ Converts metres per second to knots """
    knot = scipy.constants.knot
    return a/knot

def parse_arguments(cmd_line_tokens) :
    import argparse

    parser = argparse.ArgumentParser(description='Zermelo Navigation Problem - Random Situation Generator')
    parser.add_argument('--tag', required=True, help='Descriptive tag for the generated instances, will be stored in directory with the same name')
    parser.add_argument('--num_instances', required=False, help='Number of instances to be generated', default=100)

    args = parser.parse_args(cmd_line_tokens)
    print("Creating folder for tag '{}'".format(args.tag))
    if os.path.exists(args.tag) :
        print("\tFolder '{}' already exists, deleting".format(args.tag))
        #for the_file in os.listdir(folder):
        #    file_path = os.path.join(folder, the_file)
        #    try:
        #        if os.path.isfile(file_path):
        #            os.unlink(file_path)
        #       elif os.path.isdir(file_path): shutil.rmtree(file_path)
        #    except Exception as e:
        #        print(e)
        #os.removedirs(args.tag)
        shutil.rmtree(args.tag)
    os.makedirs(args.tag)
    return args

class Boat :

    def __init__(self) :
        self.x = 0.0
        self.y = 1.0
        self.theta = 0.0

class Region :

    def __init__(self) :
        self.u = 0.0
        self.v = 0.0
        self.wind_speed = 0.0
        self.wind_direction = 0.0

def determine_position( boat ) :
    while True :
        boat.x = np.floor(random.uniform(500.0, 10000.0))
        boat.y = np.floor(random.uniform(500.0, 10000.0))
        if boat.y < 5000.0 or boat.x < 5000.0 : break
    boat.theta = np.radians(random.randrange(0.0, 359.0, 1.0))

def determine_wind_velocity( region ) :
    max_wind_velocity = 0.75 * 5.144 # 7.5 knots maximum
    min_wind_velocity = 0.25 * 5.144 # 2.5 knots minimum
    region.wind_speed = random.uniform( min_wind_velocity, max_wind_velocity )
    region.wind_direction = np.radians(np.floor(random.uniform(0.0, 359.0)))
    region.u = region.wind_speed * np.cos(region.wind_direction)
    if np.fabs(region.u) < 1e-3 : region.u = 0.0
    region.v = region.wind_speed * np.sin(region.wind_direction)
    if np.fabs(region.v) < 1e-3 : region.v = 0.0

def Main(args) :

    if not os.path.exists('template') :
        raise SystemExit("Could not find instance template!")

    template_text = None
    with open( 'template') as instream :
        template_text = instream.read()

    print("Copying domain into '{}'".format(args.tag))
    shutil.copy('domain.pddl',os.path.join(args.tag,'domain.pddl'))

    random.seed(args.tag)

    for i in range(args.num_instances) :
        print("Generating instance #{}".format(i))
        instance_filename = os.path.join( args.tag, 'instance_{}.pddl'.format( i ) )

        the_boat = Boat()
        r0 = Region()
        r1 = Region()
        r2 = Region()
        r3 = Region()

        # generate problem
        determine_position(the_boat)
        determine_wind_velocity(r0)
        determine_wind_velocity(r1)
        determine_wind_velocity(r2)
        determine_wind_velocity(r3)

        # We're all set then

        # load template
        instance_text = string.Template( template_text )
        # replace values
        mappings = {}
        mappings['index'] = i
        mappings['x0_boat'] = the_boat.x
        mappings['y0_boat'] = the_boat.y
        mappings['theta0_boat'] = the_boat.theta
        mappings['theta0_boat_degrees'] = np.degrees(the_boat.theta)

        mappings['r0_u_wind'] = '{:.2}'.format(r0.u)
        mappings['r0_v_wind'] = '{:.2}'.format(r0.v)
        mappings['r0_wind_speed_knots'] = '{:.2}'.format(mps_to_knots( r0.wind_speed ))
        mappings['r0_wind_direction'] = np.floor(np.degrees(r0.wind_direction))

        mappings['r1_u_wind'] = '{:.2}'.format(r1.u)
        mappings['r1_v_wind'] = '{:.2}'.format(r1.v)
        mappings['r1_wind_speed_knots'] = '{:.2}'.format(mps_to_knots( r1.wind_speed ))
        mappings['r1_wind_direction'] = np.floor(np.degrees(r1.wind_direction))

        mappings['r2_u_wind'] = '{:.2}'.format(r2.u)
        mappings['r2_v_wind'] = '{:.2}'.format(r2.v)
        mappings['r2_wind_speed_knots'] = '{:.2}'.format(mps_to_knots( r2.wind_speed ))
        mappings['r2_wind_direction'] = np.floor(np.degrees(r2.wind_direction))

        mappings['r3_u_wind'] = '{:.2}'.format(r3.u)
        mappings['r3_v_wind'] = '{:.2}'.format(r3.v)
        mappings['r3_wind_speed_knots'] = '{:.2}'.format(mps_to_knots( r3.wind_speed ))
        mappings['r3_wind_direction'] = np.floor(np.degrees(r3.wind_direction))


        with open( instance_filename, 'w') as output :
            print( instance_text.substitute(mappings), file=output )


if __name__ == '__main__' :
    Main(parse_arguments(sys.argv[1:]))
