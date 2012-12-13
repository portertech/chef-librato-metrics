## Description

Provides LWRPs to manage [Librato Metrics](https://metrics.librato.com).

## Requirements

[Librato Metrics](https://metrics.librato.com) account credentials.

## Attributes

`default.librato_metrics.email` - Librato Metrics account email

`default.librato_metrics.token` - Librato Metrics account API token

## Usage

### Instrument

#### Create

An instrument with a single metric stream:

``` ruby
librato_metrics_instrument "example" do
  metric "foo"
  source "*"
  group_function "average"
end
```

An instrument with multiple metric streams:

``` ruby
librato_metrics_instrument "example" do
  streams([
    {
      "metric" => "foo",
      "source" => "*",
      "group_function" => "sum"
    },
    {
      "metric" => "bar",
      "source" => "i-*",
      "group_function" => "breakout"
    }
  ])
end
```

#### Update

Keep an instrument updated (Chef search results etc.):

``` ruby
librato_metrics_instrument "example" do
  streams([
    {
      "metric" => "foo",
      "source" => "*",
      "group_function" => "average"
    },
    {
      "metric" => "bar",
      "source" => "*.domain.com",
      "group_function" => "sum"
    }
  ])
  action :update
end
```

It's common to create an instrument and ensure it stays up-to-date:

``` ruby
action [:create, :update]
```

#### Add

Add a metric stream to an existing instrument:

``` ruby
librato_metrics_instrument "example" do
  metric "super"
  source "*.sub.domain.com"
  group_function "sum"
  action :add
end
```

### Dashboard

#### Create

A dashboard with a single instrument:

``` ruby
librato_metrics_dashboard "example" do
  instrument "example"
end
```

A dashboard with multiple instruments:

``` ruby
librato_metrics_dashboard "example" do
  instruments([
    "example",
    "foo",
    "bar"
  ])
end
```

#### Update

Keep a dashboard updated (Chef search results etc.):

``` ruby
librato_metrics_dashboard "example" do
  instruments([
    "example",
    "foo",
    "bar",
    "baz"
  ])
  action :update
end
```

It's common to create a dashboard and ensure it stays up-to-date:

``` ruby
action [:create, :update]
```

#### Add

Add an instrument to an existing dashboard:

``` ruby
librato_metrics_dashboard "example" do
  instrument "qux"
  action :add
end
```

### Metric

#### Update

Customize a metric:

``` ruby
librato_metrics_metric "example" do
  display_name "example metric"
  description "example metric for readme"
  attributes("display_units_long" => "count")
end
```

#### Delete

Delete a metric:

``` ruby
librato_metrics_metric "example" do
  action :delete
end
```

## Todo

- Instrument listing pagination
- Delete an instrument

## License and Authors

* Author:: Sean Porter <portertech@gmail.com>

* Copyright:: 2012, Sean Porter Consulting

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

```
http://www.apache.org/licenses/LICENSE-2.0
```

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
