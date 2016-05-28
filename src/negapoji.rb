# -*- coding:utf-8 -*-

require 'natto'
require './dictionary.rb'
require './sentence.rb'

module Negapoji

  include Sentence

  def pointing(sentence)
    sentence_chomped = self.remove_kaigyo(sentence)
    @point = self.simple_voting(self.create_word_point_list(sentence_chomped))
  end

  protected
    def set_dictionary
      dictionary = Dictionary.instance
      dictionary.dictionary
    end

    def create_word_point_list(sentence)
      dictionary = self.set_dictionary
      @word_point_list = Array.new
      mecab = Natto::MeCab.new
      hinshi_collected = ['名詞', '形容詞', '副詞', '動詞']
      mecab.parse(sentence) do |sentence_parsed|
        feature = sentence_parsed.feature.split(',')
        if hinshi_collected.include?(feature[0])
          kanji = dictionary[:kanji].index(feature[6])
          kana = dictionary[:kana].index(feature[6])
          index = kanji.nil? ? kana : kanji
          unless index.nil? then
            @word_point_list.push({word: feature[6], point: dictionary[:point][index]})
          end
        end
      end
      return @word_point_list
    end

    def simple_voting(word_point_list)
      the_day_point = 0
      word_point_list.each do |word_point|
        the_day_point += word_point[:point].to_f
      end
      @result = the_day_point / word_point_list.count.to_i if the_day_point != 0
    end

    def negation_voting(word_point_list)

    end
end
