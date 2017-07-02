require 'rubygems'
require 'tty-table'
require 'tty-spinner'
require 'pastel'
require 'tmpdir'

# Parse command line arguments
scope = ARGV[0]
errorsOnly = ARGV.include? '--errors-only'

# Show usage instructions when no start url is given
unless scope
    puts "Usage: ruby bfc.rb [scope]"
    puts "Scope should be a website directory, e.g. http://in10.nl/nieuws"
    exit 1
end

# Output variable scoped to program
pages = []

# Determine if a string contains traces of errors
def contains_error? html
    ['error', 'warning', 'Exception'].each do |oracle|
        return true if html.include? oracle
    end
    false
end

# Create a temporary directory for us to use
Dir.mktmpdir do |directory|
    puts directory
    # Download the website with wget
    `(cd #{directory}; wget --quiet --recursive --no-parent --follow-tags=a --random-wait --no-directories -erobots=off #{scope})`

    files = Dir.entries(directory).select {|f| !File.directory? f}
    pages = files.map do |filename|
        contents = File.open("#{directory}/#{filename}", "r").read
        [filename, contains_error?(contents)]
    end
end

# Remove succesful results when not required
pages.select! { |page| page[1] } if errorsOnly

# Output results
pages = pages.map do |page|
    result = page[1] ? 'yes' : 'no'
    if page[1]
        result = Pastel.new.white.on_red 'yes'
    else
        result = Pastel.new.green 'no'
    end
    [page[0], result]
end
table = TTY::Table.new ['Path', 'Contains errors'],  pages
puts "Results"
puts table.render :ascii
