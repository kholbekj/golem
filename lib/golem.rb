require 'openai'
require 'httparty'
require 'pry'
require 'nokogiri'
require 'tiktoken_ruby'

##
# Golem is a simple wrapper around the OpenAI API with convenience methods
class Golem
  class TooLongException < StandardError; end
  attr_reader :client

  def initialize(api_key:, uri_base: nil)
    @api_key = api_key
    @client = OpenAI::Client.new(uri_base: uri_base, access_token: @api_key)
  end

  def ask(question:, model: 'gpt-3.5-turbo')
    check_length(question: question, model: model)

    response = @client.chat(
      parameters: {
        model: model,
        messages: [{ role: 'user', content: question }]
      }
    )
    result = response.dig('choices', 0, 'message', 'content')
    result = response unless result && !result.empty?
    result = result&.gsub('"', '\"')
    puts result
    result
  end

  def summarize_article(url:)
    page = HTTParty.get(url).body
    content = Nokogiri::HTML(page).text
    question = <<~QUESTION
      Can you please summarize this article for me?
      Start by saying the name of the source, then the title of the article, then the author if available.
      Explain key points, in one flowing paragraph.

      Source: #{url}

      Article:

      #{content}
    QUESTION

    ask(question: question)
  end

  def image_url(prompt, model: 'dall-e-3')
    if model == 'dall-e-3'
      size = "1024x1792"
    else
      size = "1024x1024"
    end
    size = "1024x1024"
    response = @client.images.generate(
      parameters: {
        model: model,
        prompt: prompt,
        size: size
      }
    )
    if response.dig('data', 0, 'url').nil?
      puts response
      raise "No image generated"
    end

    [
      response.dig('data', 0, 'url'),
      response.dig('data', 0, 'revised_prompt')
    ]
  end
      


  def translate(text:)
    question = <<~QUESTION
      Can you please translate this text for me?
      if it's english, to german, if german to english.

      Slang is fine!
      Don't explain anything.
      For example:

      "Hello, how are you?"

      "Hallo, wie geht es dir?"

      or another example:
      "Ich bin ein Berliner"

      "I am a Berliner"

      #{text}
    QUESTION

    ask(question: question)
  end

  def check_length(question:, model:)
    length = length(question)
    raise TooLongException, "Body too long: #{length} tokens" if length > 4097
  end

  def length(text)
    enc = Tiktoken.encoding_for_model('gpt-3.5-turbo')
    enc.encode(text).length
  end
end
