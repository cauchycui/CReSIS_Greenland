# -*- coding: utf-8 -*-
from scipy import *

from variopy import vario

def pond_along_track(data, rad, step, var_step, var_nres, min_pnts=5, residual=False):
    pond = []
    gamma = 'm3' if residual else 'm2'

    def dist(X,Y):
        '''Compute dist of two vectors'''
        return sqrt(reduce(add, [(x-y)**2 for x,y in zip(X,Y)]))

    def mean(X):
        sum = 0
        for x in X:
            sum += x
        return sum/float(len(X))

    data_set = []
    for pnt in data:
        if len(data_set)>0:
            group_center = [mean([el[0] for el in data_set]), mean([el[1] for el in data_set])]
            dist_from_center = dist(group_center, pnt[:2])
        else:
            dist_from_center = 0

        if dist_from_center < rad:
            data_set += [pnt]
        elif len(data_set) > min_pnts:
            var, = vario(data_set, step=var_step, nres=var_nres)
            pond.append([pnt[0], pnt[1], max(var[gamma])])
            data_set = data_set[step:]
        else:
            data_set = data_set[step:]+[pnt]

    return pond

def pond_along_track_cnt(data, win, step, var_step, var_nres, gap_tol=4, residual=False, debug=False):
    pond = []
    gamma = 'm3' if residual else 'm2'

    def dist(X,Y):
        '''Compute dist of two vectors'''
        return sqrt(reduce(add, [(x-y)**2 for x,y in zip(X,Y)]))

    def mean(X):
        sum = 0
        for x in X:
            sum += x
        return sum/float(len(X))

    last, lastest = None, None
    data_set = []
    for pnt in data:
        if last is None or lastest is None:
            gap = 0
        else:
            gap = dist(pnt, last)/dist(last, lastest)

        if gap > gap_tol:
            data_set = []

        data_set += [pnt]

        if len(data_set) > win:
            centroid = mean([el[0] for el in data_set]), mean([el[1] for el in data_set])
            var, = vario(data_set, step=var_step, nres=var_nres, debug=debug)
            if len(var[gamma])>0:
                pond.append([centroid[0], centroid[1], max(var[gamma])])
            data_set = data_set[step:]

        lastest = last
        last = pnt

    return pond
