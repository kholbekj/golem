require 'openai'
require 'httparty'
require 'pry'
require 'nokogiri'
require 'tiktoken_ruby'

##
# Golem is a simple wrapper around the OpenAI API with convenience methods
class Golem
  attr_reader :client

  def initialize(api_key:)
    @api_key = api_key
    @client = OpenAI::Client.new(access_token: @api_key)
  end

  def ask(question:)
    model = 'gpt-3.5-turbo'

    enc = Tiktoken.encoding_for_model(model)
    enc.encode(question).length
    raise "Body too long: #{enc.encode(question).length} tokens" if enc.encode(question).length > 4097

    response = @client.chat(
      parameters: {
        model: model,
        messages: [{ role: 'user', content: question }]
      }
    )
    result = response.dig('choices', 0, 'message', 'content')
    result = response unless result && !result.empty?
    puts result&.gsub('"',"\\\"")
  end

  def summarize_article(url:)
    page = HTTParty.get(url).body
    content = Nokogiri::HTML(page).text
    question = <<~QUESTION
      Can you please summarize this html arcitle for me?
      Start by saying the name of the source, then the title of the article, then the author if available.
      Explain key points, in one flowing paragraph.

      Source: #{url}

      Article: 

      #{content}
    QUESTION

    ask(question: question)
  end
end
