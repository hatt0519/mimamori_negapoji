# -*- coding:utf-8 -*-

require './negapoji.rb'
require './mimamo_type.rb'
require 'json'

class Negapoji_mimamori

  include Negapoji
  include Mimamo_type

  attr_reader :item
  attr_reader :data

  def initialize(item, data)
    @item = item
    @data = data
  end

  def set_target_sentences
    today_events = JSON.load(open(@data).read)
    @sentence_list = Array.new
    today_events.each do |t|
      feeling = t.include?('feeling') ? t['feeling'] : ''
      content = {date: t['date'], item: t[@item], feeling: feeling}
      @sentence_list.push(content)
    end
    return @sentence_list
  end

  def create_correspondence_table_row(mimamori_type, sentence, point)
    case mimamori_type
    when Mimamo_type::NINCHI
      @row = [sentence[:date], @sentence_chomped, point]
    when Mimamo_type::DEPRESSION
      @row = [sentence[:date], @sentence_chomped, sentence[:feeling], point]
    end
  end

  def create_correspondence_table(mimamori_type)
    @correspondence_table = Array.new
    today_events = self.set_target_sentences
    today_events.each do |t|
      point = self.pointing(t[:item])
      @correspondence_table.push(self.create_correspondence_table_row(mimamori_type, t, point))
    end
    return @correspondence_table
  end
end