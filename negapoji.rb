# -*- coding:utf-8 -*-

require 'natto'
require 'json'

class Negapoji

  attr_reader :item
  attr_reader :macab
  attr_reader :data

  def initialize(item, data)
    @item = item
    @mecab = Natto::MeCab.new
    @data = data
  end

  def create_dictionary
    File.open('./pn_ja.dic', 'r:utf-8') do |f|
      @kanji, @kana, @hinshi, @point = Array.new, Array.new, Array.new, Array.new
      while line = f.gets
        content = line.split(':')
        @kanji.push(content[0])
        @kana.push(content[1])
        @hinshi.push(content[2])
        @point.push(content[3].chomp)
      end
    end
    return Hash[:kanji, @kanji,
                :kana, @kana,
                :hinshi, @hinshi,
                :point, @point]
  end

  def set_today_events
    @today_events = JSON.load(open(@data).read)
    @sentence_list = Array.new
    @today_events.each do |t|
      @content = Hash[:date, t['date'], :item, t[@item]]
      @sentence_list.push(@content)
    end
  end

  def create_word_point_list(sentence)
    @word_point_list = Array.new
    dictionary = self.create_dictionary
    hinshi_collected = ['名詞', '形容詞', '副詞', '動詞']
    @mecab.parse(sentence) do |sentence_parsed|
      feature = sentence_parsed.feature.split(',')
      if hinshi_collected.include?(feature[0])
        index = dictionary[:kanji].index(sentence_parsed.surface)
        unless index.nil? then
          @word_point_list.push(Hash[:word, sentence_parsed.surface,
                                     :point, dictionary[:point][index]])
        end
      end
    end
    return @word_point_list
  end

  def caluculate(word_point_list)
    the_day_point = 0
    word_point_list.each do |word_point|
      the_day_point += word_point[:point].to_f
    end
    @result = the_day_point / word_point_list.count.to_i if the_day_point != 0
  end

  def analysis_sentence
    @today_events = self.set_today_events
    @analysis_result = Array.new
    @today_events.each do |sentence|
      @sentence_chomped = sentence[@item].gsub(/(\r\n|\r|\n|\f)/,"")
      @word_point_list = self.create_word_point_list(@sentence_chomped)
      @point = self.caluculate(@word_point_list)
      @analysis_result.push([sentence['date'], @sentence_chomped, @point]) unless @point.nil?
    end
    return @analysis_result
  end
end
