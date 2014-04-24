#!/usr/bin/python

from utils import *
import sys

def format(categoryName, categoryList, version):
	return '// All symbols in the `' + categoryName + '` category as per Unicode v' + version + ':\n[\n\t\'' + '\',\n\t\''.join(categoryList) + '\'\n];'

def main(sourceFile, version):
	dictionary = parseDatabase(sourceFile, True)
	for item in sorted(dictionary.items()):
		category = item[0]
		result = format(category, item[1], version)
		writeFile(version + '/categories/' + category + '-symbols.js', result)

if __name__ == '__main__':
	main(sys.argv[1], sys.argv[2])
