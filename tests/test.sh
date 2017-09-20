set -e

R CMD install .

# Case 1. write using default CSV writer
R --silent --vanilla -f tests/write_csv.R > /dev/null
diff tests/received.csv.tmp tests/write_csv_expected.csv
echo "OK"

# Case 2. write using default CSV writer
R --silent --vanilla -f tests/write_csv2.R > /dev/null
diff tests/received.csv.tmp tests/write_csv2_expected.csv
echo "OK"
