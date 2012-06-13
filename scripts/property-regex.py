#!/usr/bin/python

from utils import *
import sys

def format(propName, propRange, version):
	return '// Regular expression that matches all symbols with the `' + propName + '` property as per Unicode v' + version + ':\n/' + propRange + '/;'

def main(sourceFile, version):
	dictionary = parseScriptsOrProps(sourceFile)
	for item in sorted(dictionary.items()):
		prop = item[0]
		result = format(prop, createRange(item[1]), version)
		writeFile(version + '/properties/' + prop + '-regex.js', result)

if __name__ == '__main__':
	main(sys.argv[1], sys.argv[2])