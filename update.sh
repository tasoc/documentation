#!/bin/bash -e
set -e

# Start virtual env:
#source venv/bin/activate

MOCKPACKAGES="^tensorflow|^xgboost|^mpi4py"

# Update all the dependencies:
for SUBPACKAGE in "photometry" "dataval" "corrections" "starclass"; do
	echo "Processing sub-package: $SUBPACKAGE"
	if [[ ! -d "$SUBPACKAGE" ]]; then
		echo "DOES NOT EXIST"
		exit 2
	fi
	if [[ ! -L "$SUBPACKAGE" ]]; then
		echo "GIT PULL $SUBPACKAGE"
		git pull -f --allow-unrelated-histories $SUBPACKAGE
	fi
	cat $SUBPACKAGE/requirements.txt | grep -v -E "$MOCKPACKAGES"  > requirements.tmp.txt
	pip install -r requirements.tmp.txt --disable-pip-version-check
	rm requirements.tmp.txt
done

# Update documentation code:
pwd
git pull --allow-unrelated-histories -f
pip install --upgrade -r requirements.txt -q --disable-pip-version-check

# Delete old builds:
rm -rf _build/

# Run Sphinx:
echo "Creating HTML documentation..."
sphinx-build -a -W --no-color -b html -d _build/doctrees . _build/html

#echo "Creating LaTeX documentation..."
#make latexpdf SPHINXOPTS="-q" LATEXMKOPTS="-silent -quiet" LATEXOPTS="-interaction=nonstopmode"

# Make sure generated files have correct permissions:
chgrp -R kasoc _build/html
chmod -R 0750 _build/html
#chgrp kasoc _build/latex/*.pdf
#chmod 0640 _build/latex/*.pdf
