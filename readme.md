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

## Technology
* Ruby
* wget

## Development
Jakob.
