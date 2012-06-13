#!/usr/bin/python

from utils import *
import sys

def format(propName, propList, version):
	return '// All symbols with the `' + propName + '` property as per Unicode v' + version + ':\n[\n\t\'' + '\',\n\t\''.join(propList) + '\'\n];'

def main(sourceFile, version):
	dictionary = parseScriptsOrProps(sourceFile, True)
	for item in sorted(dictionary.items()):
		prop = item[0]
		result = format(prop, item[1], version)
		writeFile(version + '/properties/' + prop + '-symbols.js', result)

if __name__ == '__main__':
	main(sys.argv[1], sys.argv[2])