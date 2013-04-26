#!/bin/sh

q='"'
name="${PWD##*/}"

revlist=$(git rev-list --reverse HEAD)
(
	echo '<?xml version="1.0"?>'
	echo "<git name=$q$name$q>"
	declare -i id=0
	for rev in $revlist
	do
		sid=$id
		echo "<commit id=$q$sid$q>"

		files=$(git log -1 --pretty="format:" --name-only $rev)
		for file in $files
		do
			echo "	<file>$file</file>"
		done

		echo '</commit>'
		id+=1
	done

	echo '</git>'
) > data/commits.xml

