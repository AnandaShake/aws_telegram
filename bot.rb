# encoding: utf-8
require 'telegram/bot'
require 'metainspector'
require 'rubygems'
require 'dotenv'
Dotenv.load 'data.env'
require 'aws-sdk'
require 'byebug'
require 'open-uri'
client = Aws::Rekognition::Client.new

Telegram::Bot::Client.run(ENV['TELEGRAM_BOT_TOKEN']) do |bot|
  bot.listen do |message|
    if message.photo.length != 0
      bot.api.send_message(chat_id: message.chat.id, text: 'Your image is processing, please wait. P.S Send nudes')
      photo_id = message.photo.last.file_id
      file = bot.api.get_file(file_id: photo_id)['result']['file_path']
      File.write 'image.jpg', open('https://api.telegram.org/file/bot456920436:AAF-pcW8UT9n-jHWvi8R7IU-Rx9-5P4-4_w/' + file).read
      resp = client.detect_labels(image: { bytes: File.read('image.jpg') })
      File.delete('image.jpg')
      result = ''
      resp.labels.each do |label|
        result.concat('#').concat("#{label.name.downcase.delete(' ')}").concat(' ')
      end
      bot.api.send_message(chat_id: message.chat.id, text: result)
    end
  end
end
