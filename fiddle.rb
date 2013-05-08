#!/usr/bin/env ruby

require 'fiddle'
include Fiddle

libm = DL.dlopen('/usr/lib/libm.dylib')
f = libm['sqrt']
args = [TYPE_DOUBLE]
ret = TYPE_DOUBLE
sqrt = Function(f, args, ret)
puts sqrt.call(81)
