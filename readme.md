# Basic Fault Checker (BFC)
> Crawl through a domain and check every page for errors

## Installation
1. Install Ruby and wget.
1. Install the dependencies by running `bundle install`.

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
| --user | HTTP Basic Authentication username |
| --password | HTTP Basic Authentication password |
| -h, --help | Print usage instructions |
| -v, --version | Print version number |

Note: `--debug` and `--silent` cannot be combined, but passing both will **not**
print an error message (because the program is silent). The exit code will be 1
(invalid parameters given), and the program will not continue.

## Exit codes
The program returns an appropriate exit code based on its results:

| Code | Situation |
| ---- | --------- |
|    0 | No errors or warnings |
|    1 | Invalid parameters given |
|    2 | Website triggered errors and/or warnings |
|    3 | Website triggered warnings |

## Technology
* Ruby
* wget

## Development
Jakob.
