# -*- coding:utf-8 -*-

require 'natto'

module Negapoji

  def pointing(sentence)
    @sentence_chomped = sentence.gsub(/(\r\n|\r|\n|\f)/, "")
    @point = self.simple_voting(self.create_word_point_list(@sentence_chomped))
  end

  protected
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
      return {kanji: @kanji, kana: @kana, hinshi: @hinshi, point: @point}
    end

    def create_word_point_list(sentence)
      mecab = Natto::MeCab.new
      @word_point_list = Array.new
      dictionary = self.create_dictionary
      hinshi_collected = ['名詞', '形容詞', '副詞', '動詞']
      mecab.parse(sentence) do |sentence_parsed|
        feature = sentence_parsed.feature.split(',')
        if hinshi_collected.include?(feature[0])
          index = dictionary[:kanji].index(sentence_parsed.surface)
          unless index.nil? then
            @word_point_list.push({word: sentence_parsed.surface, point: dictionary[:point][index]})
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
end
