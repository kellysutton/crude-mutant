# frozen_string_literal: true

RSpec.describe 'exe specs' do
  it 'keeps cm and crude-mutant exes the same' do
    expect(File.read('./exe/cm')).to eq(File.read('./exe/crude-mutant'))
  end
end
