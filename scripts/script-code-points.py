#!/usr/bin/python

from utils import *
import sys

def format(scriptName, scriptList, version):
	return '// All code points in the `' + scriptName + '` script as per Unicode v' + version + ':\n[\n\t' + ',\n\t'.join(scriptList) + '\n];'

def main(sourceFile, version):
	dictionary = parseScriptsOrProps(sourceFile)
	for item in sorted(dictionary.items()):
		script = item[0]
		codePoints = map(hexify, item[1])
		result = format(script, codePoints, version)
		writeFile(version + '/scripts/' + script + '-code-points.js', result)

if __name__ == '__main__':
	main(sys.argv[1], sys.argv[2])