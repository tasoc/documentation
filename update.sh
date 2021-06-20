#!/bin/bash -e
set -e

# Start virtual env:
#source venv/bin/activate

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

#git pull -f
pip install --upgrade -r requirements.txt -q --disable-pip-version-check

# Delete old builds:
rm -rf _build/

# Run Sphinx:
echo "Creating HTML documentation..."
sphinx-build -a -W --no-color -b html -d _build/doctrees . _build/html

#echo "Creating LaTeX documentation..."
#make latexpdf SPHINXOPTS="-q" LATEXMKOPTS="-silent -quiet" LATEXOPTS="-interaction=nonstopmode"

# Make sure generated files have correct permissions:
#chgrp -R kasoc _build/html
#chmod -R 0750 _build/html
#chgrp kasoc _build/latex/*.pdf
#chmod 0640 _build/latex/*.pdf
