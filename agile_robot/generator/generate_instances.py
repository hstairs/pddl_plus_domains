#!/usr/bin/python3
import os
import sys
import string
import csv

def Main() :

    if not os.path.exists('template') :
        raise SystemExit("Could not find instance template!")

    template_text = None
    with open( 'template') as instream :
        template_text = instream.read()

    instance_data = 'instance_data.csv'

    if not os.path.exists(instance_data) :
        raise SystemExit( "Could not find instances data")

    with open( instance_data ) as instream :
        reader = csv.reader( instream, delimiter=' ')
        for index, x0, y0, vx0, vy0 in reader :
            print("Generating instance #{}".format(index))
            instance_filename = 'instance_{}.pddl'.format( index )
            # load template
            instance_text = string.Template( template_text )
            # replace values
            mappings = { 'instance_index' : index, 'initial_v_x' : vx0, 'initial_v_y' : vy0 }
            with open( instance_filename, 'w') as output :
                print( instance_text.substitute(mappings), file=output )

if __name__ == '__main__' :
    Main()
