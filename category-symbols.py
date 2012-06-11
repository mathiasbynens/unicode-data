#!/usr/bin/python

import math#ias bynens
import sys
import string
import re
from collections import defaultdict

def parseUnicodeDatabase(source):
	charDict = {}

	with open(source) as uni:
		flag = False
		first = 0
		for line in uni:
			d = string.split(line.strip(), ';')
			val = int(d[0], 16)
			if flag:
				if re.compile('<.+, Last>').match(d[1]):
					# print '%s: u%X' % (d[1], val)
					flag = False
					for t in range(first, val + 1):
						charDict[t] = str(d[2])
				else:
					raise 'Database exception'
			else:
				if re.compile('<.+, First>').match(d[1]):
					# print '%s: u%X' % (d[1], val)
					flag = True
					first = val
				else:
					charDict[val] = str(d[2])

	#categories = []
	categoryDict = defaultdict(list)
	for i in range(0x10FFFF + 1):
		if charDict.get(i) == None:
			category = 'Cn'
		else:
			category = charDict[i]
		#if category not in categories:
			#categories.append(category)
		categoryDict[category].append(handleCodePoint(i))

	#categories.sort()
	#print categories
	return categoryDict

def handleCodePoint(codePoint):
	if codePoint >= 0x20 and codePoint <= 0x7E and codePoint is not 0x22 and codePoint is not 0x27 and codePoint is not 0x5C: # printable ASCII minus single quote, double quote, and backslash
		string = chr(codePoint)
	elif codePoint <= 0xFF: # hexadecimal escapes
		string = '\\x' + '%02X' % codePoint
	elif codePoint <= 0xFFFF: # Unicode escapes
		string = '\\u' + '%04X' % codePoint
	else: # surrogate pairs
		tmp = codePoint - 0x10000
		highSurrogate = math.floor(tmp / 0x400) + 0xD800
		lowSurrogate = tmp % 0x400 + 0xDC00
		string = '\\u' + '%04X' % highSurrogate + '\\u' + '%04X' % lowSurrogate
	return string

def parseList(categoryName, categoryList, version):
	return '// All symbols in the ' + categoryName + ' category as per Unicode v' + version + ':\n[\n\t\'' + '\',\n\t\''.join(categoryList) + '\'\n];'

def main(sourceFile, destinationDir):
	dictionary = parseUnicodeDatabase(sourceFile)

	for item in sorted(dictionary.items()):
		category = item[0]
		result = parseList(category, item[1], destinationDir)
		filename = destinationDir + '/' + category + '-symbols.js'
		print filename
		with open(filename, 'w') as f:
			f.write(result)

if __name__ == '__main__':
	main(sys.argv[1], sys.argv[2])