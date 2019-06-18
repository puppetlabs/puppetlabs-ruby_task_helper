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

``` ruby
mod 'puppetlabs-ruby_task_helper'
```

Add it to your [task metadata](https://puppet.com/docs/bolt/latest/writing_tasks.html#concept-677)

``` json
{
  "files": ["ruby_task_helper/files/task_helper.rb"],
  "input_method": "stdin"
}
```

## Usage

When writing your task include the library in your script, extend the `TaskHelper` module, and write the `task()` function. The `task()` function should accept its parameters as symbols, and should return a hash. The following is an example of a task that uses the library. All parameters will be symbolized including nested hash keys and hashes contained in arrays.

`mymodule/tasks/task.rb`

``` ruby
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

``` console
bolt task run mymodule::task -n target.example.com name="Robert'); DROP TABLE Students;--"
```

You can additionally provide detailed errors by raising a `TaskError`, such as

``` ruby
class MyTask < TaskHelper
  def task(**kwargs)
    raise TaskHelper::Error.new("my task error message",
                               "mytask/error-kind",
                               "Additional details")
```

### With Remote Transports

When writing a task for a module which supports a [remote transport](https://github.com/puppetlabs/puppet-resource_api#remote-resources), `TaskHelper` will provide access to the transport via the `context` object.

`context` returns a `RemoteContext` which provides:

* `transport`: Your remote transport object
* `target`: The connection information passed to the task.

These are both provided to the task through [inventory.yaml](https://puppet.com/docs/bolt/latest/inventory_file.html#remote-targets). An existing example can be found in the [Cisco_IOS module](https://github.com/puppetlabs/cisco_ios#tasks)

`myremotemodule/tasks/some_remote_task.rb`

``` ruby
#!/usr/bin/env ruby

require_relative "../../ruby_task_helper/files/task_helper.rb"

class SomeRemoteTask < TaskHelper
  def task(_params, **_kwargs)
    unless Puppet.settings.global_defaults_initialized?
      Puppet.initialize_settings
    end

    rtn = context.transport.some_remote_operation
    {
      status: 'success',
      results: "#{rtn}",
    }
  end
end

if $PROGRAM_NAME == __FILE__
  SomeRemoteTask.run
end
```

Your transport method can throw an exception as this will be caught and handled by the `TaskHelper`.
