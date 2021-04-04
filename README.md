# combotools
A collection of tools to work on username:password combo lists

Many of the tools listed here were taken from CompilationOfManyBreaches (COMB) project and further adapted and developed on, credits go to the rightfull owners whoever they may be.

I like the simplicity of them, they are easy to read, understand and rely solely on the highly efficient linux standard binaries.
   
## Quick Start
To use this on mac osx I recommend installing homebrew and doing first:
   ```
   brew install coreutils
   ```
Then get started
   ```
   pip install -r requirements.txt
   python combocrawler.py
   ./import.sh
   ```
Then count your combos
   ```
   ./count_total.sh
   ```
And query away
   ```
   ./query.sh mega
   ```
   
## Tools
### import.sh
Imports files from the `inputbreach` folder and organizes into the `data` folder
### sort.sh
Sorts files in `data` folder and removes duplicates
### count_total.sh
Counts how many username:password combos we have imported in the `data`
### combocrawler.py
Python script to scrape after new combos in anonfiles using google search, it also downloads and extracts them into `inputbreach` folder

## Disclamer
Use this only for threat analysis and educational purposes, please.
