#!/bin/bash

# Allow running this script from another directory
cd "$(dirname "$0")"

versions=(
	# 1.1.5 has a different format, so disable it for now
	# "1.1.5@http://www.unicode.org/Public/1.1-Update/UnicodeData-1.1.5.txt"
	"2.0.14@http://www.unicode.org/Public/2.0-Update/UnicodeData-2.0.14.txt"
	"2.1.9@http://www.unicode.org/Public/2.1-Update4/UnicodeData-2.1.9.txt"
	"3.0.1@http://www.unicode.org/Public/3.0-Update1/UnicodeData-3.0.1.txt"
	"3.2.0@http://www.unicode.org/Public/3.2-Update/UnicodeData-3.2.0.txt"
	"4.0.1@http://www.unicode.org/Public/4.0-Update1/UnicodeData-4.0.1.txt"
	"4.1.0@http://www.unicode.org/Public/4.1.0/ucd/UnicodeData.txt"
	"5.0.0@http://www.unicode.org/Public/5.0.0/ucd/UnicodeData.txt"
	"5.1.0@http://www.unicode.org/Public/5.1.0/ucd/UnicodeData.txt"
	"5.2.0@http://www.unicode.org/Public/5.2.0/ucd/UnicodeData.txt"
	"6.0.0@http://www.unicode.org/Public/6.0.0/ucd/UnicodeData.txt"
	"6.1.0@http://www.unicode.org/Public/6.1.0/ucd/UnicodeData.txt"
)

# Download Unicode database for each version
mkdir -p "data"
echo "Fetching Unicode databases..."
for item in ${versions[@]}; do
	version="${item%%@*}"
	url="${item##*@}"
	if [ -s "data/${version}.txt" ]; then
		echo "Skipping v${version}, as it has already been downloaded."
	else
		echo "Downloading v${version} from ${url}..."
		curl -# "$url" > "data/${version}.txt"
	fi
done

# Generate the output data for each available Unicode version
for file in data/*.txt; do
	file="${file##*/}"
	version="${file%.*}"
	mkdir -p "$version"
	echo "Parsing Unicode v${version}..."
	python category-symbols.py "data/${version}.txt" "${version}"
	python category-regex.py "data/${version}.txt" "${version}"
done

echo "Done."