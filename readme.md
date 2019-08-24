# About
This is a script to automatically cleanup and organize my `Downloads` folder.
It comes with a flexible and dynamic config file so you can create your own rules.


# Installation
________________________________________________________________________________

1. Download / fork this repository

```bash
git clone https://github.com/aapit/download-organizer.git
```

________________________________________________________________________________

2. Create a config file
```bash
cd download-organizer
cp scans.template.config scans.config
```
________________________________________________________________________________

3. Edit your config file

- Every line in the config file is a scan rule.
- Every line is divided into three columns, separated by tabs or spaces.

## First column: pattern
- The first column is the glob pattern to search for.
- You can use wildcards in the glob pattern, like `*_foo.bar`.

## Second column: scan directory
- The second column is the scan dir, where we search for the pattern.
- You can use env vars like `$HOME` in the scan dir.

## Third column: target
- The third column is the target. This could be a dir or a filename.
- You can use `%FILENAME%` in the target value.
- You can use env vars like `$HOME` in the target.

## Examples
Move `foobar.txt` from `Downloads` to directory `FooStuff`:
```sh
foobar.txt    $HOME/Downloads $HOME/Documents/FooStuff/
```

Move `something-invoice-2019.xls` and `invoice.zip` to directory `Invoices`:
```sh
*invoice*.*   $HOME/Downloads $HOME/Downloads/Invoices/
```

Move `SPAM_222_NO.pdf` from `Downloads` to `crap/delete-me-SPAM_222_NO.pdf`:
```sh
SPAM_*_*.pdf  $HOME/Downloads $HOME/Downloads/crap/delete-me-%FILENAME%
NICE_*_*.pdf  $HOME/Downloads $HOME/Downloads/save-me-%FILENAME%
```

________________________________________________________________________________

4. Run the script from cron to set and forget it
```bash
crontab -e
```
In the editor that opens up, create a crontab entry something like this to make it run every hour:
```bash
0 */1 * * * $HOME/Scripts/download-organizer/organize.sh
```
