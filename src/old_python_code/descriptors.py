#!/usr/bin/env python

import sys
import re
import parser

# Calculates the time (duration + possible modificators) of a note [e].
def time_value(e):
    (p,t) = e
    return t
    
# Returns the total time of a sequence [seq].
def time_seq(seq):
    time = 0.0
    for e in seq:
        time += time_value(e)
    return time

# Returns the sequence, cut by time unit periods.
def regroup_by_time_unit(seq, period):
    time_accumulator = 0.0
    newseq = []
    group = []
    nb_cut = 0
    for e in seq:
        time = time_value(e)
        if time_accumulator+time > period:
            if time_accumulator < period:
                nb_cut+=1
            newseq.append(group)
            group = []
            time_accumulator = time
        else:
            time_accumulator += time
        group.append(e)
    newseq.append(group)
    if time_accumulator < period:
        nb_cut += 1
    return newseq,nb_cut

# Group by consecutive blocks of [num] notes.
def regroup_by_number_of_symbol(seq, num):
    group = []
    newseq = []
    count = 0
    for e in seq:
        if count == num:
            newseq.append(group)
            group = []
            count = 1
        else:
            count +=1
        group.append(e)
    return newseq

# Keep only the pitch
def projection_pitch(seq):
    return [p for (p,_) in seq]

# Keep only the time
def projection_time(seq):
    return [t for (_,t) in seq]

# Project the sequence on one octave
def projection_modulopitch_time(seq):
    return [((1+((p-1)%12) if p > 0 else 0),t) for (p,t) in seq]

def main(argv):
    if len(argv) == 1:
        path = 'music/implicita/bach/bach00.imp'
    else:
        path = argv[1]
    l = parser.parse(path)
    modulol = projection_modulopitch_time(l)
    newl,nb_cut = regroup_by_time_unit(l,4.0)
    newl2 = regroup_by_number_of_symbol(l,4)
    print('Main')
    print('seq')
    print(time_seq(l),l)
    print('modulo pitch')
    print(time_seq(modulol), modulol)
    print('Group by time unit')
    print('Number of cut:', nb_cut)
    for (i,s) in enumerate(newl):
        print(i,time_seq(s),s)
    print('Group by number of symbol')
    for (i,s) in enumerate(newl2):
        print(i,time_seq(s),s)

if __name__ == "__main__":
    main(sys.argv)  
