require 'minitest_helper'
require 'actn/api/template'
require 'minitest_helper'
require 'goliath/test_helper'
require 'apis/render'

module Actn
  module Api
    class TestTemplates < Minitest::Test
    
      include Goliath::TestHelper
    
      def setup
        @template = Actn::Api::Template.create({filename: "home.erb", body: "HOME!"})
        @api_options = { :verbose => true, :log_stdout => true, config: "#{Actn::Api.gem_root}/config/common.rb" }
        @err = Proc.new { assert false, "API request failed" }
      end
    
      def teardown
        Actn::Api::Template.delete_all
      end
      
      def test_db_backend_templates
        with_api(Render,@api_options) do
          get_request({path: '/home' }, @err) do |c|
            assert_equal 200, c.response_header.status
            assert_equal "HOME!", c.response
          end
        end
      end  

    end
  end
end