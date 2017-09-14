# Call a URL to verify its status code
# includes caching
class URLTester

    def initialize username = nil, password = nil
        @cache = {}
        @username = username
        @password = password
    end

    # Get a cached or fresh response status
    def status? uri
        fetchStatus(uri) unless @cache.include? uri
        @cache[uri]
    end

    private

    def fetchStatus uri
        options = {read_timeout: 2}
        options[:http_basic_authentication] = [@username, @password] if @username || @password

        # Get the page
        begin
            open(uri, options) { |response| @cache[uri] = response.status[0] }
        rescue OpenURI::HTTPError => error
            @cache[uri] = error.io.status[0]
        rescue Net::ReadTimeout
            @cache[uri] = 'read_timeout'
        rescue SocketError
            @cache[uri] = 'socket_error'
        rescue
            @cache[uri] = 'unknown'
        end
    end
end
