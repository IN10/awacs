require 'rubygems'
require 'watir'
require 'tty-table'
require 'tty-spinner'
require 'pastel'
require 'addressable/uri'

# initialize globals for state
$processed_links = []
$pages = []

# show usage instructions when no start url is given
$initial_url = ARGV[0]
unless $initial_url
    puts "Usage: ruby bfc.rb http://website.com"
    exit 1
end

def has_error? browser
    ['error', 'warning', 'php', 'Exception'].each do |oracle|
        return true if browser.html.include? oracle
    end
    false
end

def internal_urls browser
    tags = browser.links.select { |link| link.href.start_with? $initial_url } 
    urls = tags.map { |tag| normalize(tag.href) }
    urls.uniq
end

def normalize url
    url = Addressable::URI.parse(url).normalize
    url.fragment = nil
    url.to_s
end

# Process an url for errors and all its linked pages too
def process url
    url = normalize url
    $spinner.update operation: "Processing #{url}"

    # Guard: do not process the entire internet
    return unless url.start_with? $initial_url

    # Guard: do not process the same link twice
    return if $processed_links.include? url
    $processed_links << url

    $browser.goto url
    $pages << [url, has_error?($browser)]

    # Proceed with all links
    internal_urls($browser).each do |url|
        process url
    end
end

# start the spinner
$spinner = TTY::Spinner.new "[:spinner] :operation"
$spinner.update operation: 'Starting browser'
$spinner.auto_spin

# execute
$browser = Watir::Browser.new :chrome
$browser.driver.manage.timeouts.implicit_wait = 1
process $initial_url
$browser.close

# report
$spinner.update(operation: 'All done')
$spinner.success

$pages = $pages.map do |page|
    result = page[1] ? 'yes' : 'no'
    if page[1]
        result = Pastel.new.white.on_red 'yes'
    else
        result = Pastel.new.green 'no'
    end
    [page[0], result]
end
table = TTY::Table.new ['URL', 'Contains errors'],  $pages
puts "\nResults"
puts table.render :ascii
