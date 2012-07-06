#! /usr/bin/env ruby

require 'nokogiri'

def processHTML(file_path)
  f = File.open(file_path)
  html_doc = Nokogiri::HTML(f)
  f.close
end

def generate_id
  o =  [('a'..'z'),('A'..'Z')].map{|i| i.to_a}.flatten;  
  string  =  (0..8).map{ o[rand(o.length)]  }.join;
  return string
end


xml = '<?xml version="1.0" encoding="UTF-8"?>'

xml += '<add>'

Dir['*.html'].each do |file|

  xml += "<doc>"
  basename = File.basename(file, '.html')
  #puts "Processing #{basename}..."

  f = File.open(file)
  html = Nokogiri::HTML(f)
  f.close

  id = generate_id
  xml += "<field name='id'>#{id}</field>"
  xml += "<field name='project_s'>Attributions of Authorship in the 
European Magazine</field>"
xml += "<field name='slug_s'>/bsuva/euromag/</field>"

  title = html.title
  xml += "<field name='title_s'>#{title}</field>"

  project = "European Magazine"
  xml += "<field name='project_s'>#{project}</field>"

  file = basename
  xml += "<field name='file_s'>#{file}</field>"

  body = html.xpath('//text()').remove
  #body.text.gsub('&nbsp;', '')
  #body = Nokogiri::XML::DocumentFragment.parse(html.css('body'))
  
  xml += "<field name='fulltext_t'>#{body.to_xml}</field>"

  xml += '</doc>'

end

xml += '</add>'

puts xml


