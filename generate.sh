#!/bin/bash

# Allow running this script from another directory
cd "$(dirname "$0")"

versions=(
	# 1.1.5 has a different format, so disable it for now
	# "1.1.5@http://unicode.org/Public/1.1-Update/UnicodeData-1.1.5.txt"
	"2.0.14@http://unicode.org/Public/2.0-Update/UnicodeData-2.0.14.txt"
	"2.1.9@http://unicode.org/Public/2.1-Update4/UnicodeData-2.1.9.txt"
	"3.0.1@http://unicode.org/Public/3.0-Update1/UnicodeData-3.0.1.txt"
	# 3.2.0 and newer have separate files for Scripts and Blocks
	"3.2.0@http://unicode.org/Public/3.2-Update/UnicodeData-3.2.0.txt@http://unicode.org/Public/3.2-Update/Scripts-3.2.0.txt@http://unicode.org/Public/3.2-Update/Blocks-3.2.0.txt@http://unicode.org/Public/3.2-Update/PropList-3.2.0.txt"
	"4.0.1@http://unicode.org/Public/4.0-Update1/UnicodeData-4.0.1.txt@http://unicode.org/Public/4.0-Update1/Scripts-4.0.1.txt@http://unicode.org/Public/4.0-Update1/Blocks-4.0.1.txt@http://unicode.org/Public/4.0-Update1/PropList-4.0.1.txt"
	"4.1.0@http://unicode.org/Public/4.1.0/ucd/UnicodeData.txt@http://unicode.org/Public/4.1.0/ucd/Scripts.txt@http://unicode.org/Public/4.1.0/ucd/Blocks.txt@http://unicode.org/Public/4.1.0/ucd/PropList.txt"
	"5.0.0@http://unicode.org/Public/5.0.0/ucd/UnicodeData.txt@http://unicode.org/Public/5.0.0/ucd/Scripts.txt@http://unicode.org/Public/5.0.0/ucd/Blocks.txt@http://unicode.org/Public/5.0.0/ucd/PropList.txt"
	"5.1.0@http://unicode.org/Public/5.1.0/ucd/UnicodeData.txt@http://unicode.org/Public/5.1.0/ucd/Scripts.txt@http://unicode.org/Public/5.1.0/ucd/Blocks.txt@http://unicode.org/Public/5.1.0/ucd/PropList.txt"
	"5.2.0@http://unicode.org/Public/5.2.0/ucd/UnicodeData.txt@http://unicode.org/Public/5.2.0/ucd/Scripts.txt@http://unicode.org/Public/5.2.0/ucd/Blocks.txt@http://unicode.org/Public/5.2.0/ucd/PropList.txt"
	"6.0.0@http://unicode.org/Public/6.0.0/ucd/UnicodeData.txt@http://unicode.org/Public/6.0.0/ucd/Scripts.txt@http://unicode.org/Public/6.0.0/ucd/Blocks.txt@http://unicode.org/Public/6.0.0/ucd/PropList.txt"
	"6.1.0@http://unicode.org/Public/6.1.0/ucd/UnicodeData.txt@http://unicode.org/Public/6.1.0/ucd/Scripts.txt@http://unicode.org/Public/6.1.0/ucd/Blocks.txt@http://unicode.org/Public/6.1.0/ucd/PropList.txt"
)

function download() {
	url="$1"
	filename="$2"
	if [ -s "$filename" ]; then
		echo "Skipping ${filename}, as it has already been downloaded."
	else
		echo "Downloading ${url}..."
		curl -# "$url" > "$filename"
	fi
}

# Download Unicode database for each version
mkdir -p "data"
echo "Fetching Unicode databases..."
for item in ${versions[@]}; do
	IFS="@"; set -- $item
	version="$1"
	dbURL="$2"
	scriptsURL="$3"
	blocksURL="$4"
	propsURL="$5"
	download "$dbURL" "data/${version}-database.txt"
	[ "$scriptsURL" != "" ] && download "$scriptsURL" "data/${version}-scripts.txt"
	[ "$blocksURL" != "" ] && download "$blocksURL" "data/${version}-blocks.txt"
	[ "$propsURL" != "" ] && download "$propsURL" "data/${version}-properties.txt"
done

# Generate the category output data for each available Unicode version
for file in data/*-database.txt; do
	file="${file##*/}"
	version="${file%-*}"
	mkdir -p "${version}/categories"
	echo "Parsing Unicode v${version} categories..."
	python scripts/category-code-points.py "data/${version}-database.txt" "${version}"
	python scripts/category-symbols.py "data/${version}-database.txt" "${version}"
	python scripts/category-regex.py "data/${version}-database.txt" "${version}"
done

# Generate the scripts output data for each available Unicode version
for file in data/*-scripts.txt; do
	file="${file##*/}"
	version="${file%-*}"
	mkdir -p "${version}/scripts"
	echo "Parsing Unicode v${version} scripts..."
	python scripts/script-code-points.py "data/${version}-scripts.txt" "${version}"
	python scripts/script-symbols.py "data/${version}-scripts.txt" "${version}"
	python scripts/script-regex.py "data/${version}-scripts.txt" "${version}"
done

# Generate the blocks output data for each available Unicode version
for file in data/*-blocks.txt; do
	file="${file##*/}"
	version="${file%-*}"
	mkdir -p "${version}/blocks"
	echo "Parsing Unicode v${version} blocks..."
	python scripts/block-code-points.py "data/${version}-scripts.txt" "${version}"
	python scripts/block-symbols.py "data/${version}-blocks.txt" "${version}"
	python scripts/block-regex.py "data/${version}-blocks.txt" "${version}"
done

# Generate the properties output data for each available Unicode version
for file in data/*-properties.txt; do
	file="${file##*/}"
	version="${file%-*}"
	mkdir -p "${version}/properties"
	echo "Parsing Unicode v${version} properties..."
	python scripts/property-code-points.py "data/${version}-properties.txt" "${version}"
	python scripts/property-symbols.py "data/${version}-properties.txt" "${version}"
	python scripts/property-regex.py "data/${version}-properties.txt" "${version}"
done

echo "Done."