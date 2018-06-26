require 'paypro/config'

RSpec.describe Paypro::Config do

  VALID_ATTRS = [:test]

  let(:klas) { described_class }
  subject    { klas.new(*VALID_ATTRS) }

  describe "Attributes" do
    it { should respond_to(:type) }
    it { should respond_to(:data) }
  end

  describe "Construction" do
    it 'builds an object' do
      expect(subject).to_not be_nil
      expect(subject).to be_a(klas)
    end

    it 'has proper attributes' do
      expect(subject.type).to be_a(String)
      expect(subject.data).to_not be_nil
      expect(subject.data).to be_a(Hash)
    end
  end
end
