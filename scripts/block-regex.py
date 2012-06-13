#!/usr/bin/python

from utils import *
import sys

def format(blockName, blockRange, version):
	return '// Regular expression that matches all symbols in the ' + blockName + ' block as per Unicode v' + version + ':\n/' + blockRange + '/;'

def main(sourceFile, version):
	dictionary = parseBlocks(sourceFile)
	for item in sorted(dictionary.items()):
		block = item[0].replace('_', ' ')
		result = format(block, createRange(item[1]), version)
		writeFile(version + '/blocks/' + block.replace(' ', '-') + '-regex.js', result)

if __name__ == '__main__':
	main(sys.argv[1], sys.argv[2])