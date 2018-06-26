require 'paypro'

RSpec.describe Paypro do

  SOURCE_TYPE = :yaml
  SOURCE_ID = "data/test1.yml"

  let(:klas) { described_class }
  subject    { klas.new(SOURCE_TYPE, SOURCE_ID) }

  describe "Attributes" do
    it { should respond_to(:type) }
    it { should respond_to(:source) }
    it { should respond_to(:source_id) }
  end

  describe "Methods" do
    it { should respond_to(:issue) }
    it { should respond_to(:issues) }
  end

  describe "Construction" do
    it 'builds an object' do
      expect(subject).to_not be_nil
      expect(subject).to be_a(Paypro)
    end

    it 'has proper attributes' do
      expect(subject.type).to eq(SOURCE_TYPE)
      expect(subject.source_id).to eq(SOURCE_ID)
    end

    it 'constructs a repo' do
      expect(subject.source).to_not be_nil
      expect(subject.source).to be_a(Svc::Yaml)
    end

    it 'raises error on invalid type' do
      expect { klas.new(:bing, "bong") }.to raise_exception(PayproError::InvalidSvcType)
    end
  end

  describe ".hexid_for" do
    it "gets the hexid with spaces" do
      result = klas.hexid_for({"body" => "asdf qwer /abc123"})
      expect(result).to eq("abc123")
    end

    it "gets the hexid with newlines" do
      result = klas.hexid_for({"body" => "asdf qwer\n/def123\nqwer"})
      expect(result).to eq("def123")
    end

    it "gets the hexid with tags" do
      result = klas.hexid_for({"body" => "asdf qwer<br/>/bbb333<p>"})
      expect(result).to eq("bbb333")
    end
  end

end
