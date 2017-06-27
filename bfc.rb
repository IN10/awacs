require 'rubygems'
require 'nokogiri'
require 'open-uri'

def get page
    Nokogiri::HTML(open(page))
end

def has_error? page

end

def get_links page
end

initial_url = ARGV[0]

initial_url
    puts "Usage: ruby bfc.rb http://website.com"
    exit 1
end

processed_links = []
pages = {}

# Add the start point as processed
processed_links << initial_url
page = get initial_url
pages[initial_url] = has_error? page

get_links(page).each do |page|

end





# start with initial url
# open in nokogiri
# search for error
# log result
# add url to output
# for each link in page
    # repeat
