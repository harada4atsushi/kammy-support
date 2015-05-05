# ホットペッパービューティーAPIを叩いてkammy-miniで使用するJSONデータを生成するスクリプト

require 'http'
require "rexml/document"
require 'dotenv'
Dotenv.load

endpoint = 'http://webservice.recruit.co.jp/beauty/salon/v1/'
params = {
  key: ENV['APIKEY'],
  feature: 'SP06',  # 特集: ヘアスタイル
  start: 1,  # 1件目から
  count: 100,  # 100件取得(MAX100)
}

xml = HTTP.get(endpoint, params: params)

xml_doc = REXML::Document.new(xml)

arr = []
idx = 0

xml_doc.each_element("//results/salon") do |salon|

	#".//"だと、その要素の先頭から
  salon.each_element(".//feature") do |feature|
    idx += 1
    arr << {
      url: feature.elements['photo/l'].text,
      id: "images/hairstyles/#{idx}.jpg",
    }
  end
end

puts "#{arr.count} 件取得"
puts arr.to_json
