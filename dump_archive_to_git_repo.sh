#!/bin/bash

# Usage: ./$0 <папка с бэкапами>

set -eux

parse_dump_xml() {
	# gsed needs to work on OS X
	SED=sed
	if [ -x /usr/local/bin/gsed ]; then
		SED=/usr/local/bin/gsed
	fi
	LANG= $SED -e 's/></>\n</g' "${1:-$DUMPXML}" | iconv -f cp1251
}

init() {
	rm -rf git
	mkdir -p git
	( cd git; git init )
}

make_git() {
	for i in "${1:-.}"/*.tar.gz; do
		tar xfz $i usr/local/Reductor/reductor_container/gost-ssl/php/dump.xml
		parse_dump_xml usr/local/Reductor/reductor_container/gost-ssl/php/dump.xml > git/dump.xml
		( cd git; git add .; git commit -m "$i" )
	done
}

main() {
	init
	make_git "$@"
}

main "$@"
