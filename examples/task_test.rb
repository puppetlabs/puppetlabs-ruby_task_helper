require 'json'
require_relative './mytask.rb'

# An example of testing a task using the helper

describe 'MyTask' do
  it 'runs my task' do
    allow(STDIN).to receive(:read).and_return('{"name": "Lucy"}')
    out = JSON.dump('greeting' => 'Hi, my name is Lucy')
    expect(STDOUT).to receive(:print).with(out)
    MyTask.run
  end
end
