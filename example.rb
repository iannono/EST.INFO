require 'net/http'
http = Net::HTTP.new('www.macx.cn', 443)
http.use_ssl = true
path1 = '/forum-10001-1.html'
path2 = '/forum.php?mod=forumdisplay&fid=10001&filter=author&orderby=dateline&sortid=3'

# make a request to get the server's cookies
resp = http.get(path1)
if (resp.code == '200')
    puts "ok"
    all_cookies = resp.get_fields('set-cookie')
    cookies_array = Array.new
    all_cookies.each { | cookie |
        cookies_array.push(cookie.split('; ')[0])
    }
    cookies = cookies_array.join('; ')

    # now make a request using the cookies
    resp = http.get(path2, { 'Cookie' => cookies })
    puts resp
end
