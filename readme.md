# Basic Fault Checker (BFC)
> Crawl through a domain and check every page for errors

## Installation
This tool is a Ruby-application that you run from the command-line. You can
customize the installation depending on your needs, but the following process
is usually the fastest way to get started:

1. Install [homebrew](https://brew.sh/) if you are not using it already.
1. Use homebrew to install a recent version of [Ruby](https://www.ruby-lang.org/en/)
and [wget](https://www.gnu.org/software/wget/) by running `brew install ruby`
and `brew install wget`.
1. Clone this repository to a convenient location on your PC. I use
`/Users/{name}/tools/bfc` on my PC.
1. Add the location in which you've installed to your PATH.
1. Install bundler (the Ruby package manager) by running `gem install bundler`.
1. Install the dependencies by running `bundle install` in the installed directory.
1. Verify your installation by running `bfc -v` or `bfc -h` in any terminal on
your device. If this returns no error, your installation has succeeded.

## Usage
```bash
bfc [url] [options]
```

`url` should be the base URL of the website you're going to test, e.g. [http://www.website.com](http://www.website.com). This URL acts as a scope. For
example, if you use [http://www.website.com/planning/](http://www.website.com/planning/) as the base URL
[http://www.website.com/planning/phase-one](http://www.website.com/planning/phase-one) would be included, but
[http://www.website.com/about-us](http://www.website.com/about-us) and [http://instagram.com](http://instagram.com) won't
be included.

Valid `options` are:

| Option | Effect |
| ------ | ------ |
| --errors-only | Only show pages with errors in the final output |
| --silent | Suppress all output, returning only an exit code |
| --debug | Verbose action output, no visual effects |
| --fast | Will skip all checks marked as slow |
| --username | HTTP Basic Authentication username |
| --password | HTTP Basic Authentication password |
| -h, --help | Print usage instructions |
| -v, --version | Print version number |

Note: `--debug` and `--silent` cannot be combined, but passing both will **not**
print an error message (because the program is silent). The exit code will be 1
(invalid parameters given), and the program will not continue.

### Checks
BFC executes the following tests on every run. Slow tests are skipped when bfc
is run with the --fast option.

| Checker | Speed | Purpose |
| ------- | ----- | ------- |
| LogAnalyzer | fast | Check the log of downloaded pages for failures. This catches problems with pages on your site  |
| Broken images | slow | Check \<img\> tags for broken src attributes |
| Broken links | slow | Check \<a\> tags for broken href attributes. Used in addition to LogAnlyzer, this catches problems with external links too. See known problems below. |
| Broken scripts | fast | Check \<script\> tags with src attributes for broken references  |
| Broken stylesheets | fast | Check \<link\> tags with href attributes for broken references  |
| Error output | fast | Check the page for keywords such as "error", "exception" and "warning" that often indicate server-side problems  |

### Known problems
Linking to any Linkedin-profile generally results in a 999 HTTP status code
due to automated bot detection. This program ignores robot.txt files, but generally
makes no attempt to appear as a legitimate user.

### Exit codes
The program returns an appropriate exit code based on its results:

| Code | Situation |
| ---- | --------- |
|    0 | No errors or warnings |
|    1 | Invalid parameters given |
|    2 | Website triggered errors and/or warnings |
|    3 | Website triggered warnings |

## Technology
Written in Ruby, this program uses wget to download all pages in scope. Files are
parsed as strings, and than fed to various Checker-classes which have their own
dependencies to do various things. For example, we use nokogiri to parse all \<a\>
tags in a page and OpenURI to check their responses, in order to find all broken
links on every page.

## Development
[Jakob Buis](http://www.jakobbuis.nl)
