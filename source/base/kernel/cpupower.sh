#!/bin/sh

source /etc/sysconfig/cpupower

_add_option()
{
	if test -z "$_options"; then
		_options="$1"
	else
		_options="$_options $1"
	fi
}

if test -n "$governor"; then
	_add_option "--governor $governor"
fi

if test -n "$min_freq"; then
	_add_option "--min $min_freq"
fi

if test -n "$max_freq"; then
	_add_option "--max $max_freq"
fi

if test -n "$freq"; then
	_add_option "--freq $freq"
fi

if test -n "$_options"; then
	/usr/bin/cpupower frequency-set $_options
fi

_options=""

if test -n "$perf_bias"; then
	_add_option "--perf-bias $perf_bias"
fi

if test -n "$_options"; then
	/usr/bin/cpupower set $_options
fi
