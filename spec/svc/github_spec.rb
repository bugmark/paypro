require 'spec_helper'
require 'source/github'

RSpec.describe Svc::Github do

  # REPO_NAME = "bugmark/paypro"
  REPO_NAME = "andyl/test1"

  let(:klas) { described_class }
  subject    { klas.new(REPO_NAME) }

  describe "Attributes", USE_VCR do
    it { should respond_to(:repo_name) }
    it { should respond_to(:repo_issues) }
    it { should respond_to(:repo_comments) }
  end

  describe "Methods", USE_VCR do
    it { should respond_to(:issues) }
    it { should respond_to(:issue) }
    it { should respond_to(:create) }
    it { should respond_to(:update) }
    it { should respond_to(:open) }
    it { should respond_to(:close) }
    it { should respond_to(:create_comment) }
    it { should respond_to(:update_comment) }
  end

  describe "Construction", USE_VCR do
    it 'builds an object' do
      expect(subject).to_not be_nil
      expect(subject).to be_a(klas)
    end

    it 'has proper attributes' do
      expect(subject.repo_name).to be_a(String)
      expect(subject.repo_issues).to_not be_nil
      expect(subject.repo_issues).to be_an(Array)
    end
  end

  describe "#issues", USE_VCR do
    it 'returns proper data' do
      expect(subject).to_not be_nil
      expect(subject.issues).to be_an(Array)
    end
  end

  describe "#create", USE_VCR do
    it 'generates an issue' do
      subject.create("bing", "bing bing")
      expect(1).to eq(1)
    end
  end

  describe "#update", USE_VCR do
    it "updates and issue" do
      subject.update(1, {body: "UPDATED AT #{Time.now}"})
      expect(1).to eq(1)
    end
  end

  describe "#create_comment", USE_VCR do
    it "creates a comment" do
      subject.create_comment(1, "NEW COMMENT AT #{Time.now}")
    end
  end

  describe "#update_comment", USE_VCR do
    it "updates a comment" do
      cid = subject.issues.last["stm_comments"].first["exid"]
      subject.update_comment(cid, "UPDATED COMMENT AT #{Time.now}")
    end
  end
end
