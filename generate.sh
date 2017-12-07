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
	"3.2.0@http://unicode.org/Public/3.2-Update/UnicodeData-3.2.0.txt@http://unicode.org/Public/3.2-Update/Scripts-3.2.0.txt@http://unicode.org/Public/3.2-Update/Blocks-3.2.0.txt@http://unicode.org/Public/3.2-Update/PropList-3.2.0.txt@http://unicode.org/Public/3.2-Update/DerivedCoreProperties-3.2.0.txt"
	"4.0.1@http://unicode.org/Public/4.0-Update1/UnicodeData-4.0.1.txt@http://unicode.org/Public/4.0-Update1/Scripts-4.0.1.txt@http://unicode.org/Public/4.0-Update1/Blocks-4.0.1.txt@http://unicode.org/Public/4.0-Update1/PropList-4.0.1.txt@http://unicode.org/Public/4.0-Update1/DerivedCoreProperties-4.0.1.txt"
	"4.1.0@http://unicode.org/Public/4.1.0/ucd/UnicodeData.txt@http://unicode.org/Public/4.1.0/ucd/Scripts.txt@http://unicode.org/Public/4.1.0/ucd/Blocks.txt@http://unicode.org/Public/4.1.0/ucd/PropList.txt@http://unicode.org/Public/4.1.0/ucd/DerivedCoreProperties.txt"
	"5.0.0@http://unicode.org/Public/5.0.0/ucd/UnicodeData.txt@http://unicode.org/Public/5.0.0/ucd/Scripts.txt@http://unicode.org/Public/5.0.0/ucd/Blocks.txt@http://unicode.org/Public/5.0.0/ucd/PropList.txt@http://unicode.org/Public/5.0.0/ucd/DerivedCoreProperties.txt"
	"5.1.0@http://unicode.org/Public/5.1.0/ucd/UnicodeData.txt@http://unicode.org/Public/5.1.0/ucd/Scripts.txt@http://unicode.org/Public/5.1.0/ucd/Blocks.txt@http://unicode.org/Public/5.1.0/ucd/PropList.txt@http://unicode.org/Public/5.1.0/ucd/DerivedCoreProperties.txt"
	"5.2.0@http://unicode.org/Public/5.2.0/ucd/UnicodeData.txt@http://unicode.org/Public/5.2.0/ucd/Scripts.txt@http://unicode.org/Public/5.2.0/ucd/Blocks.txt@http://unicode.org/Public/5.2.0/ucd/PropList.txt@http://unicode.org/Public/5.2.0/ucd/DerivedCoreProperties.txt"
	"6.0.0@http://unicode.org/Public/6.0.0/ucd/UnicodeData.txt@http://unicode.org/Public/6.0.0/ucd/Scripts.txt@http://unicode.org/Public/6.0.0/ucd/Blocks.txt@http://unicode.org/Public/6.0.0/ucd/PropList.txt@http://unicode.org/Public/6.0.0/ucd/DerivedCoreProperties.txt"
	"6.1.0@http://unicode.org/Public/6.1.0/ucd/UnicodeData.txt@http://unicode.org/Public/6.1.0/ucd/Scripts.txt@http://unicode.org/Public/6.1.0/ucd/Blocks.txt@http://unicode.org/Public/6.1.0/ucd/PropList.txt@http://unicode.org/Public/6.1.0/ucd/DerivedCoreProperties.txt"
	"6.2.0@http://unicode.org/Public/6.2.0/ucd/UnicodeData.txt@http://unicode.org/Public/6.2.0/ucd/Scripts.txt@http://unicode.org/Public/6.2.0/ucd/Blocks.txt@http://unicode.org/Public/6.2.0/ucd/PropList.txt@http://unicode.org/Public/6.2.0/ucd/DerivedCoreProperties.txt"
	"6.3.0@http://unicode.org/Public/6.3.0/ucd/UnicodeData.txt@http://unicode.org/Public/6.3.0/ucd/Scripts.txt@http://unicode.org/Public/6.3.0/ucd/Blocks.txt@http://unicode.org/Public/6.3.0/ucd/PropList.txt@http://unicode.org/Public/6.3.0/ucd/DerivedCoreProperties.txt"
	"7.0.0@http://unicode.org/Public/7.0.0/ucd/UnicodeData.txt@http://unicode.org/Public/7.0.0/ucd/Scripts.txt@http://unicode.org/Public/7.0.0/ucd/Blocks.txt@http://unicode.org/Public/7.0.0/ucd/PropList.txt@http://unicode.org/Public/7.0.0/ucd/DerivedCoreProperties.txt"
	"8.0.0@http://unicode.org/Public/8.0.0/ucd/UnicodeData.txt@http://unicode.org/Public/8.0.0/ucd/Scripts.txt@http://unicode.org/Public/8.0.0/ucd/Blocks.txt@http://unicode.org/Public/8.0.0/ucd/PropList.txt@http://unicode.org/Public/8.0.0/ucd/DerivedCoreProperties.txt"
	"9.0.0@http://unicode.org/Public/9.0.0/ucd/UnicodeData.txt@http://unicode.org/Public/9.0.0/ucd/Scripts.txt@http://unicode.org/Public/9.0.0/ucd/Blocks.txt@http://unicode.org/Public/9.0.0/ucd/PropList.txt@http://unicode.org/Public/9.0.0/ucd/DerivedCoreProperties.txt"
	"10.0.0@http://unicode.org/Public/10.0.0/ucd/UnicodeData.txt@http://unicode.org/Public/10.0.0/ucd/Scripts.txt@http://unicode.org/Public/10.0.0/ucd/Blocks.txt@http://unicode.org/Public/10.0.0/ucd/PropList.txt@http://unicode.org/Public/10.0.0/ucd/DerivedCoreProperties.txt"
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
	derivedPropsURL="$6"
	download "$dbURL" "data/${version}-database.txt"
	[ "$scriptsURL" != "" ] && download "$scriptsURL" "data/${version}-scripts.txt"
	[ "$blocksURL" != "" ] && download "$blocksURL" "data/${version}-blocks.txt"
	[ "$propsURL" != "" ] && download "$propsURL" "data/${version}-properties.txt"
	[ "$derivedPropsURL" != "" ] && download "$derivedPropsURL" "data/${version}-derivedcoreproperties.txt"
done

# Generate the category output data for each available Unicode version
for file in data/*-database.txt; do
	file="${file##*/}"
	version="${file%-*}"
	mkdir -p "${version}/categories"
	# Some files generated by the category script will be moved to the `properties` directory
	mkdir -p "${version}/properties"
	echo "Parsing Unicode v${version} categories..."
	python scripts/category-code-points.py "data/${version}-database.txt" "${version}" &
	python scripts/category-symbols.py "data/${version}-database.txt" "${version}" &
	python scripts/category-regex.py "data/${version}-database.txt" "${version}" &
	wait
done

# Move data for `Any`, `ASCII`, and `Assigned` to the `properties` folder
for file in */categories/{Any,ASCII,Assigned}*; do
	echo "mv ${file}" "${file/categories/properties}"
	mv "${file}" "${file/categories/properties}"
done

# Generate the properties output data for each available Unicode version
for file in data/*-properties.txt; do
	file="${file##*/}"
	version="${file%-*}"
	# Already created above
	#mkdir -p "${version}/properties"
	echo "Parsing Unicode v${version} properties..."
	python scripts/property-code-points.py "data/${version}-properties.txt" "${version}" &
	python scripts/property-symbols.py "data/${version}-properties.txt" "${version}" &
	python scripts/property-regex.py "data/${version}-properties.txt" "${version}" &
	wait
done

# Generate the derived core properties output data for each available Unicode version
for file in data/*-derivedcoreproperties.txt; do
	file="${file##*/}"
	version="${file%-*}"
	# Already created above
	#mkdir -p "${version}/properties"
	echo "Parsing Unicode v${version} derived core properties..."
	python scripts/derived-core-property-code-points.py "data/${version}-derivedcoreproperties.txt" "${version}" &
	python scripts/derived-core-property-symbols.py "data/${version}-derivedcoreproperties.txt" "${version}" &
	python scripts/derived-core-property-regex.py "data/${version}-derivedcoreproperties.txt" "${version}" &
	wait
done

# Generate the scripts output data for each available Unicode version
for file in data/*-scripts.txt; do
	file="${file##*/}"
	version="${file%-*}"
	mkdir -p "${version}/scripts"
	echo "Parsing Unicode v${version} scripts..."
	python scripts/script-code-points.py "data/${version}-scripts.txt" "${version}" &
	python scripts/script-symbols.py "data/${version}-scripts.txt" "${version}" &
	python scripts/script-regex.py "data/${version}-scripts.txt" "${version}" &
	wait
done

# Generate the blocks output data for each available Unicode version
for file in data/*-blocks.txt; do
	file="${file##*/}"
	version="${file%-*}"
	mkdir -p "${version}/blocks"
	echo "Parsing Unicode v${version} blocks..."
	python scripts/block-code-points.py "data/${version}-blocks.txt" "${version}" &
	python scripts/block-symbols.py "data/${version}-blocks.txt" "${version}" &
	python scripts/block-regex.py "data/${version}-blocks.txt" "${version}" &
	wait
done

echo "Done."
