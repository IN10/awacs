# AWACS
> Crawl through a domain and check every page for errors

Named after the [Airborne Warning and Control System](https://en.wikipedia.org/wiki/Boeing_E-3_Sentry),
this program provides early warnings for potential problems in your website. It
doesn't provide a complete overview, but detects signals that you may want to
investigate further.

## Contents
- [AWACS](#awacs)
  * [Contents](#contents)
  * [Installation](#installation)
  * [Usage](#usage)
    + [Output formats](#output-formats)
    + [Filtering results](#filtering-results)
    + [Exit codes](#exit-codes)
  * [Checks](#checks)
  * [Known problems](#known-problems)
  * [Technology](#technology)
  * [Development](#development)
  * [License](#license)

## Installation
This tool is a Ruby-application that you run from the command-line. You can
customize the installation depending on your needs, but the following process
is usually the fastest way to get started:

1. Install [homebrew](https://brew.sh/) if you are not using it already.
1. Use homebrew to install a recent version of [Ruby](https://www.ruby-lang.org/en/)
and [wget](https://www.gnu.org/software/wget/) by running `brew install ruby`
and `brew install wget`.
1. Install bundler (the Ruby package manager) by running `gem install bundler`.
1. Clone this repository to a convenient location on your PC. I use
`/Users/{name}/tools/awacs` on my PC.
1. Add the location to your PATH.
1. Install the dependencies by running `bundle install`.
1. Verify your installation by running `awacs -v` or `awacs -h`.

## Usage
```bash
awacs [url] [options]
```

`url` should be the base URL of the website you're going to test, e.g. [http://www.website.com](http://www.website.com). You must specify the full URL, including the protocol (http://, https://). Also note that if your website is configured to redirect to all traffic to www.website.com, or website.com, you *must* use the correct form in the scope, or you'll get zero results.

This URL acts as a scope: AWACS uses it to determine whether a page is on your website, or not. You could also use it to check only a subset of the website. For example, if you use [http://www.website.com/planning/](http://www.website.com/planning/) as the base URL
[http://www.website.com/planning/phase-one](http://www.website.com/planning/phase-one) would be included, but
[http://www.website.com/about-us](http://www.website.com/about-us) and [http://instagram.com](http://instagram.com) won't
be included.

Valid `options` are:

| Short | Long | Effect |
| ----- | ---- | ------ |
| -e | --errors | Only show pages with errors in the final output. Can be combined with --warnings. |
| -f | --fast | Will skip all checks marked as slow |
|    | --folder | Dump all tested pages to this folder, allowing for manual inspection |
| -h | --help | Print usage instructions |
|    | --output | Set the output format of results. Default is "human" |
|    | --password | HTTP Basic Authentication password |
|    | --username | HTTP Basic Authentication username |
| -v | --version | Print version number |
| -w | --warnings | Only show pages with warnings in the final output. Can be combined with --errors. |

### Output formats
The `--output` parameter determines what the program prints to stdout. You can choose from:
* human: displays a progress spinner, and formats a nice, readable ASCII-table of results
* csv: output comma-separated results, ready for import in Excel, etc. Note that the data will be
printed to stdout. You probably want to redirect it to a file like so:
`$ awacs http://www.jakobbuis.nl --output-csv > results.csv`.
* debug: output verbose statements what AWACS is doing
* silent: output nothing (not even errors). The [exit codes](#exit-codes) can be
 used to determine the result of analysis.

### Filtering results
`--errors` and `--warnings` (or `-e` and `-w`) can be combined. If both options
are *not* passed, the default is to list every page.
Passing these options does not affect the [exit codes](#exit-codes).

| Settings | Pages with no problems | Pages with errors | Pages with warnings |
| -------- | ---------------------- | ----------------- | ------------------- |
| _none given_ | &#10004; | &#10004; | &#10004; |
| --errors --warnings | | &#10004; | &#10004; |
| --errors    | | &#10004; | |
| --warnings    | | | &#10004; |

### Exit codes
The program returns an appropriate exit code based on its results:

| Code | Situation |
| ---- | --------- |
|    0 | No errors or warnings |
|    1 | Invalid parameters given |
|    2 | Website triggered errors and/or warnings |
|    3 | Website triggered warnings |
|    4 | Selected folder (--folder) does not exist, or is not writeable |
|    5 | Selected folder (--folder) is not empty |

## Checks
awacs executes the following tests on every run. Slow tests are skipped when awacs
is run with the --fast option.

| Checker | Speed | Purpose |
| ------- | ----- | ------- |
| Images | slow | Check \<img\> tags for broken src attributes |
| Invalid HTML | fast | Check for parsing errors in HTML |
| Links | slow | Check \<a\> tags for broken href attributes. |
| Page failures | fast | Check the log of downloaded pages for failures.|
| Scripts | fast | Check \<script\> tags with src attributes for broken references  |
| Stylesheets | fast | Check \<link\> tags with href attributes for broken references  |
| Trigger words | fast | Check the page for keywords such as "error" and "exception" that often indicate server-side problems  |
| Dummy content | fast | Check the page for keywords that indicate dummy text such as "lorem ipsum"  |

## Known problems
Linking to any Linkedin-profile generally results in a 999 HTTP status code
due to automated bot detection. This program ignores the robots.txt file on your
own website, but makes no attempt to appear as a legitimate user.

## Technology
Written in Ruby, this program uses wget to download all pages in scope. Files are
parsed as strings, and than fed to various Checker-classes which have their own
dependencies to do various things. For example, we use nokogiri to parse all \<a\>
tags in a page and OpenURI to check their responses, in order to find all broken
links on every page.

## Development
[Jakob Buis](http://www.jakobbuis.nl)

## License
Copyright 2017 IN10. This project is distributed under the MIT-license. It is subject to the license terms in the LICENSE file found in the top-level directory of this distribution and at [https://opensource.org/licenses/MIT](https://opensource.org/licenses/MIT). No part of AWACS, including this file, may be copied, modified, propagated, or distributed except according to the terms contained in the LICENSE file.
