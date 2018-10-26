require_relative './mytask.rb'

# An example of testing a task using the helper

describe 'MyTask' do
  it 'runs my task' do
    allow(STDIN).to receive(:read).and_return('{"name": "Lucy"}')
    expect(MyTask).to receive(:run).and_return('{greeting:
                                                 "Hi, my name is Lucy"}')
    MyTask.run
  end
end
