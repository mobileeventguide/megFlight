require 'cgi'
require 'tmpdir'
require 'open-uri'

class MegFlight
  attr_reader :image57, :image512

  def initialize(options)
    @image57 = 'http://lorempixel.com/g/57/57/technics/'
    @image512 = 'http://lorempixel.com/g/512/512/technics/'
    if options.has_key?(:image57)
      begin
        open(options[:image57])
        @image57 = options[:image57]
      rescue
        @image57 = 'http://lorempixel.com/g/57/57/technics/'
      end
    end
    if options.has_key?(:image512)
      begin
        open(options[:image512])
        @image512 = options[:image512]
      rescue
        @image512 = 'http://lorempixel.com/g/512/512/technics/'
      end
    end  
    @ipa = options[:ipa]
    @identifier = options[:identifier]
    @title = options[:title]
    @subtitle = options[:subtitle]
    @host_url = options[:host_url]
  end 

  def create_package
    return unless File.exist? @ipa
    dir = Dir.mktmpdir
    File.open(File.join([dir, 'index.html']), 'w:utf-8') {|f| f.puts html_content}
    File.open(File.join([dir, '57.png']), 'w:utf-8') {|f| f.puts open(@image57, 'r:utf-8').read}
    File.open(File.join([dir, '512.png']), 'w:utf-8') {|f| f.puts open(@image512, 'r:utf-8').read}
    File.open(File.join([dir, 'manifest.plist']), 'w:utf-8') {|f| f.puts manifest_content}
    File.open(File.join([dir, 'enterprise.ipa']), 'w:utf-8') {|f| f.puts open(@ipa, 'r:utf-8').read}
    return dir
  end

  private

  def html_content
    %Q{
<html>
  <head>
    <title>#{@title}</title>
    <meta name="viewport" content="width=device-width">
    <style type="text/css">
      h1,h2,h3,h4,h5,h6 {font-weight: normal;}
      @media only screen and (max-device-width: 480px) { .iphone_width { width: 300px !important; } } 
    </style>
  </head>
  <body style="margin:0;padding:0;background:#ffffff; padding: 0px;">

    <div class="iphone_width" style="display: block; padding: 10px 10px 15px 10px; background: #f2f2f2; border-bottom:1px solid #dddddd;">
      <img src="57.png" style="width:57px;height:57px;margin: 0px 7px 0px 0px;" align="left">
      <h2 style="font: normal 18px/22px Helvetica, Arial, sans-serif; color: #000000; padding: 8px 0px 0 px 5px; margin:0px;">#{@title}</h2>
      <h3 style="font: normal 12px/15px Helvetica, Arial, sans-serif; color: #444444; padding: 0px 0px 0px 5px; margin:0 px;">#{@subtitle}</h3>
    </div> 

    <div class="iphone_width" style="display: block; padding: 10px 10px 15px 10px;">
      <a href="itms-services://?action=download-manifest&url=#{@host_url}/manifest.plist"
        class="green_button" style="display: block;color: #FFFFFF;font: bold 16px/20px Helvetica, arial, sans-serif;width: 280px;height: 25px;margin: 10px 0px 5px 0px;text-align: center;padding: 15px 0px 10px 0px;text-decoration: none;border-radius: 5px;-webkit-border-radius: 5px;-moz-border-radius: 5px;-webkit-box-shadow: 0 0 10px rgba(0, 0, 0, 0.3);-moz-box-shadow: 0 0 10px rgba(0, 0, 0, 0.3);box-shadow: 0 0 10px rgba(0, 0, 0, 0.3);background: #006600;">Install App</a> 
    </div>

    <!-- QR-Code
    <div class="iphone_width" style="display: block; padding: 10px 10px 15px 10px; background: #f2f2f2; border-bottom:1px solid #dddddd;">
      <img src="http://chart.apis.google.com/chart?cht=qr&chs=150x150&chl=#{CGI.escapeHTML(@host_url)}/index.html&chld=H|0" />
    </div>
    -->
  </body>
</html> 
    }
  end

  def manifest_content
    %Q{
    <?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>items</key>
  <array>
    <dict>
      <key>assets</key>
      <array>
        <dict>
          <key>kind</key>
          <string>software-package</string>
          <key>url</key>
          <string>#{@host_url}/enterprise.ipa</string>
        </dict>
        <dict>
          <key>kind</key>
          <string>full-size-image</string>
          <key>needs-shine</key>
          <false/>
          <key>url</key>
          <string>#{@host_url}/512.png</string>
        </dict>
        <dict>
          <key>kind</key>
          <string>display-image</string>
          <key>needs-shine</key>
          <false/>
          <key>url</key>
          <string>#{@host_url}/57.png</string>
        </dict>
      </array>
      <key>metadata</key>
      <dict>
        <key>bundle-identifier</key>
        <string>#{@identifier}</string>
        <key>kind</key>
        <string>software</string>
        <key>subtitle</key>
        <string>#{@subtitle}</string>
        <key>title</key>
        <string>#{@title}</string>
      </dict>
    </dict>
  </array>
</dict>
</plist>
    }
  end
end
