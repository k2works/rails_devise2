# -*- coding: utf-8 -*-
require 'spec_helper'

describe HomeController do

  describe "GET 'index'" do
    it "成功する" do
      get 'index'
      response.should be_success
    end
  end

end
