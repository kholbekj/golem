require 'openai'
require 'httparty'
require 'pry'
require 'nokogiri'

##
# Golem is a simple wrapper around the OpenAI API with convenience methods
class Golem
  def initialize(api_key:)
    @api_key = api_key
  end

  def ask(question:)
    client = OpenAI::Client.new(access_token: @api_key)
    response = client.chat(
      parameters: {
        model: 'gpt-3.5-turbo',
        messages: [{ role: 'user', content: question }]
      }
    )
    result = response.dig('choices', 0, 'message', 'content')
    result = response unless result && !result.empty?
    puts result
  end

  def summarize_article(url:)
    page = HTTParty.get(url).body
    content = Nokogiri::HTML(page).text
    question = <<~QUESTION
      Can you please summarize this html arcitle for me?

      #{content}
    QUESTION

    ask(question: question)
  end
end
