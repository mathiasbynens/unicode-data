#!/usr/bin/python

from utils import *
import sys

def format(categoryName, categoryRange, version):
	return '// Regular expression that matches all symbols in the `' + categoryName + '` category as per Unicode v' + version + ':\n/' + categoryRange + '/;'

def main(sourceFile, version):
	dictionary = parseDatabase(sourceFile)
	for item in sorted(dictionary.items()):
		category = item[0]
		result = format(category, createRange(item[1]), version)
		writeFile(version + '/categories/' + category + '-regex.js', result)

if __name__ == '__main__':
	main(sys.argv[1], sys.argv[2])