# -*- coding:utf-8 -*-

require './negapoji.rb'
require './mimamo_type.rb'
require 'json'

class Negapoji_mimamori

  include Negapoji
  include Mimamo_type

  TOKUNINASHI = /(特になし.?|特に無し.?|とくになし.?|とくに無し.?|とくにありません.?)/

  def initialize(item, data)
    @item = item
    @data = data
    super()
  end

  attr_reader :item
  attr_reader :data

  def set_target_sentences
    sentences = JSON.load(open(@data).read)
    @sentence_list = Array.new
    sentences.each do |s|
      feeling = s.include?('feeling') ? s['feeling'] : ''
      content = {date: s['date'], item: s[@item], feeling: feeling}
      @sentence_list.push(content)
    end
    return @sentence_list
  end

  def create_correspondence_table_row(mimamori_type, sentence, point_takamura, point_inui_okazaki)
    sentence_chomped = self.remove_kaigyo(sentence[:item])
    case mimamori_type
    when Mimamo_type::NINCHI
      @row = [sentence[:date], sentence_chomped, point_takamura, point_inui_okazaki]
    when Mimamo_type::DEPRESSION
      @row = [sentence[:date], sentence_chomped, sentence[:feeling], point_takamura, point_inui_okazaki]
    end
  end

  def create_correspondence_table(mimamori_type)
    @correspondence_table = Array.new
    sentence_list = self.set_target_sentences
    sentence_list.each do |s|
      point = TOKUNINASHI =~ s[:item] ? [-0.3, 0] : self.pointing(s[:item])
      @correspondence_table.push(self.create_correspondence_table_row(mimamori_type, s, point[0], point[1]))
    end
    return @correspondence_table
  end
end
