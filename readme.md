# Basic Fault Checker (BFC)
> Crawl through a domain and check every page for errors

## Usage
```bash
bfc [url]
```

`url` should be the base URL of the website you're going to test, e.g. "http://delft.com". Do not use the homepage URL: this URL is used too for comparison which pages are to be included in the search. For example, if you specify "http://delft.com", "http://delft.com/page" will be included, but "http://instagram.com" won't be. 

Valid `options` are included in the following table:

| Option | Effect |
| ------ | ------ |
| --errors-only | Only show pages with errors in the final output |

## Technology
* Ruby
* wget

## Development
Jakob.
