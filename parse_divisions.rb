#!/usr/bin/ruby 
# encoding: utf-8

require 'nokogiri'
require 'json'

file = ARGV.first || 'dyn_divisions.xml'
doc = Nokogiri::XML(open(file))

@div = {}

doc.xpath('//table_data[@name="pw_dyn_wiki_motion"]/row').each do |row|
  text = row.at_xpath('field[@name="text_body"]').text.strip

  record = {
    edate: row.at_xpath('field[@name="edit_date"]').text.strip,
    date: row.at_xpath('field[@name="division_date"]').text.strip,
    number: row.at_xpath('field[@name="division_number"]').text.strip.to_i,
    house: row.at_xpath('field[@name="house"]').text.strip,
    title: (text[/--- DIVISION TITLE ---(.*?)---/m, 1] || '').strip,
    aye: (text[/@\s?MP voted aye (.*)/i, 1] || '').strip,
    nay: (text[/@\s?MP voted no (.*)/i, 1] || '').strip,
    # text: text,
  }
  key = "#{record[:date]}:#{record[:number]}"
  (@div[key] ||= []) << record
end

motions = @div.sort_by { |id, is| id }.reverse.map do |id, infos|
  latest = infos.sort_by { |i| i['edate'] }.last
  latest[:url] = "http://www.publicwhip.org.uk/division.php?date=#{latest[:date]}&number=#{latest[:number]}&house=#{latest[:house]}"
  latest.delete :edate
  latest
end

puts JSON.pretty_generate motions

