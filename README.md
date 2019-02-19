# Ruby Task Helper

A Ruby helper library for writing [Puppet tasks](https://puppet.com/docs/bolt/latest/writing_tasks.html). It provides a class that handles error generation, simplifies JSON input and output, and makes testing your task easier. It requires Bolt >= 1.1 or Puppet Enterprise >= 2019.0.

#### Table of Contents

1. [Description](#description)
1. [Requirements](#requirements)
1. [Setup](#setup)
1. [Usage](#usage)

## Description

This library handles parsing JSON input, serializing the result as JSON output, and producing a formatted error message for errors.

## Requirements

This library works with Ruby 2.3 and later.

## Setup

To use this library, include this module in a [Puppetfile](https://puppet.com/docs/pe/2019.0/puppetfile.html):

```
mod 'puppetlabs-ruby_task_helper'
```

Add it to your [task metadata](https://puppet.com/docs/bolt/latest/writing_tasks.html#concept-677)
```
{
  "files": ["ruby_task_helper/files/task_helper.rb"],
  "input_method": "stdin"
}
```

## Usage

When writing your task include the library in your script, extend the `TaskHelper` module, and write the `task()` function. The `task()` function should accept its parameters as symbols, and should return a hash. The following is an example of a task that uses the library. All parameters will be symbolized including nested hash keys and hashes contained in arrays.

`mymodule/tasks/task.rb`
```
#!/usr/bin/env ruby

require_relative "../../ruby_task_helper/files/task_helper.rb"

class MyClass < TaskHelper
  def task(name: nil, **kwargs) 
    {greeting: "Hi, my name is #{name}"}
  end 
end

if __FILE__ == $0
  MyClass.run
end
```

You can then run the task like any other Bolt task:
```
bolt task run mymodule::task -n target.example.com name="Robert'); DROP TABLE Students;--"
```

You can additionally provide detailed errors by raising a `TaskError`, such as
```
class MyTask < TaskHelper
  def task(**kwargs)
    raise TaskHelper::Error.new("my task error message",
                               "mytask/error-kind",
                               "Additional details")
```
