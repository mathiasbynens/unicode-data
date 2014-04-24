#!/usr/bin/python

from utils import *
import sys

def format(scriptName, scriptRange, version):
	return '// Regular expression that matches all symbols in the `' + scriptName + '` script as per Unicode v' + version + ':\n/' + scriptRange + '/;'

def main(sourceFile, version):
	dictionary = parseScriptsOrProps(sourceFile)
	for item in sorted(dictionary.items()):
		script = item[0]
		result = format(script, createRange(item[1]), version)
		writeFile(version + '/scripts/' + script + '-regex.js', result)

if __name__ == '__main__':
	main(sys.argv[1], sys.argv[2])
