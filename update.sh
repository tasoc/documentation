#!/bin/bash -e
set -e

MOCKPACKAGES="^numpy|^tensorflow|^xgboost|^mpi4py"

# Update all the dependencies:
for SUBPACKAGE in "photometry" "dataval" "corrections" "starclass"; do
	echo "****************************************************"
	echo "Processing sub-package: $SUBPACKAGE"
	if [[ ! -d "../$SUBPACKAGE" ]]; then
		echo "DOES NOT EXIST"
		exit 2
	fi

	# Pull latest Git repo:
	cd "../$SUBPACKAGE"
	git status
	git pull -f

	# Ensure numpy is the first thing to be installed:
	if [ "$SUBPACKAGE" = "photometry" ]; then
		grep "numpy" requirements.txt | xargs -I {} pip install "{}" --disable-pip-version-check
	fi

	# Install requirements for sub-package:
	grep -v -E "$MOCKPACKAGES" requirements.txt > requirements.tmp.txt
	pip install -q -r requirements.tmp.txt --disable-pip-version-check
	rm requirements.tmp.txt

	cd ../documentation
done

# Update documentation code:
echo "****************************************************"
pip install --upgrade -r requirements.txt -q --disable-pip-version-check

# Delete old builds:
rm -rf _build/

# Run Sphinx:
echo "Creating HTML documentation..."
sphinx-build -a -W --no-color -b html -d _build/doctrees . _build/html

#echo "Creating LaTeX documentation..."
#sphinx-build -a -W --no-color -b latexpdf -d _build/doctrees . _build/latexpdf
#make latexpdf SPHINXOPTS="-q" LATEXMKOPTS="-silent -quiet" LATEXOPTS="-interaction=nonstopmode"
