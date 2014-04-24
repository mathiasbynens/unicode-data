#!/usr/bin/python

from utils import *
import sys

def format(scriptName, scriptList, version):
	return '// All symbols in the `' + scriptName + '` script as per Unicode v' + version + ':\n[\n\t\'' + '\',\n\t\''.join(scriptList) + '\'\n];'

def main(sourceFile, version):
	dictionary = parseScriptsOrProps(sourceFile, True)
	for item in sorted(dictionary.items()):
		script = item[0]
		result = format(script, item[1], version)
		writeFile(version + '/scripts/' + script + '-symbols.js', result)

if __name__ == '__main__':
	main(sys.argv[1], sys.argv[2])
