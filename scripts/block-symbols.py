#!/usr/bin/python

from utils import *
import sys

def format(blockName, blockList, version):
	return '// All symbols in the ' + blockName + ' block as per Unicode v' + version + ':\n[\n\t\'' + '\',\n\t\''.join(blockList) + '\'\n];'

def main(sourceFile, version):
	dictionary = parseBlocks(sourceFile, True)
	for item in sorted(dictionary.items()):
		block = item[0].replace('_', ' ')
		result = format(block, item[1], version)
		writeFile(version + '/blocks/' + block.replace(' ', '-') + '-symbols.js', result)

if __name__ == '__main__':
	main(sys.argv[1], sys.argv[2])