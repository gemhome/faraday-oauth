# frozen_string_literal: true

RSpec.describe Faraday::OAuth::Request, type: :request do
  let(:middleware) do
    described_class.new(lambda { |env|
      Faraday::Response.new(env)
    }, encoder_options: {
      indent: 0
    })
  end

  it 'has tests'
end
