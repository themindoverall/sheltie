#!/usr/bin/env python
# encoding: utf-8
"""
resourcer.py

Created by Chris Serino on 2011-02-28.
Copyright (c) 2011 serino.me. All rights reserved.
"""

import sys
import os
from os import path
import string


def main():
	layout = """// ActionScript file

package sheltie {
	internal class Resources extends ResourceBundle {
%s
	}
}"""
	resource = \
"""		[Embed(source = '%s'%s)]
			public const %s:Class;"""
	curpath = 'src/sheltie/resources'
	rscs = get_resources(curpath)
	
	inner = []
	for k in rscs:
		for f in rscs[k]:
			if k == 'levels' or k == 'objects':
				mim = ', mimeType="application/octet-stream"'
			else:
				mim = ''
			inner.append(resource % (path.join('resources', k, f), mim, string.replace(f, '.', '_')))
		 	
	fw = open('src/sheltie/Resources.as', 'w')
	fw.write(layout % ('\n\n'.join(inner)))
	
	
def get_resources(cpath, flat = False):
	files = os.listdir(cpath)
	if flat:
		rscs = []
	else:
		rscs = {}
	
	for f in files:
		cp = path.join(cpath, f)
		if path.isdir(cp):
			rscs[f] = get_resources(cp, True)
		elif flat:
			rscs.append(f)
	return rscs

if __name__ == '__main__':
	main()

