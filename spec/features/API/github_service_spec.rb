require 'rails_helper'

RSpec.describe "GithubService" do
  before :each do
    @path = 'https://api.github.com/repos/GrayMyers/little-esty-shop'
    @github = GithubService.new(@path)
  end
  it "is a service class" do
    expect(@github).to be_a GithubService
  end

  describe "instance methods" do
    it "get_data" do
      expect(@github.get_data).to be_a Hash
    end

    it "get_body" do
      expect(@github.get_body(@path)).to be_a Hash
      expect(@github.get_body(@path)).to have_key :full_name
    end

    it "repo_name" do
      expect(@github.repo_name).to be_a Hash
      expect(@github.repo_name).to have_key :full_name
    end

    it "contributors" do
      expect(@github.contributors).to be_a Array
      expect(@github.contributors.first).to have_key :login
      expect(@github.contributors.count).to eq(7)
    end

    it "merged_pull_request" do
      expect(@github.merged_pull_request).to be_a Array
      expect(@github.merged_pull_request.first).to have_key :merged_at
    end
  end
end
