require './negapoji.rb'
require './file_maker.rb'

module Mimamo_type
  NINCHI = 'ninchi'
  DEPRESSION = 'depression'
end

INPUTS_NINCHI_PATH = './files/inputs/ninchi/'
OUTPUTS_NINCHI_PATH = './files/outputs/ninchi/'
INPUTS_DEPRESSION_PATH = './files/inputs/depression/'
OUTPUTS_DEPRESSION_PATH = './files/outputs/depression/'

case ARGV[0]
  when Mimamo_type::NINCHI
    input = INPUTS_NINCHI_PATH
    output = OUTPUTS_NINCHI_PATH
  when Mimamo_type::DEPRESSION
    input = INPUTS_DEPRESSION_PATH
    output = OUTPUTS_DEPRESSION_PATH
  else
    p 'error:その引数は対応していません'
    exit 0
end


files = Dir::entries(input)
files.delete_if{|f| f == '.' || f == '..' || f == '.DS_Store'}

files.each do |file|
  username = file.split('_')[2].split('.')[0]

  negapoji_good = Negapoji.new('good', input+file)
  negapoji_bad = Negapoji.new('bad', input+file)
  negapoji_reference = Negapoji.new('reference', input+file)

  good_sentence = negapoji_good.analysis_sentence
  bad_sentence = negapoji_bad.analysis_sentence
  reference_sentence = negapoji_reference.analysis_sentence
  
  file_maker_good = File_maker.new(good_sentence, username, 'good', output)
  file_maker_bad = File_maker.new(bad_sentence, username, 'bad', output)
  file_maker_reference = File_maker.new(reference_sentence, username, 'reference', output)

  file_maker_good.csv
  file_maker_bad.csv
  file_maker_reference.csv
end
