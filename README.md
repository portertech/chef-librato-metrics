# Librato Metrics

## Description

Provides a LWRP to manage [Librato Metrics](https://metrics.librato.com) instruments.

## Requirements

[Librato Metrics](https://metrics.librato.com) account credentials.

## Attributes

`default.librato_metrics.email` - Librato Metrics account email

`default.librato_metrics.token` - Librato Metrics account API token

## Usage

### Create

An instrument with a single metric stream:

``` ruby
librato_metrics_instrument "example" do
  metric "foo"
  source "*"
  group_function "average"
end
```

An instrument with a many metric streams:

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

### Update

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

It's common to create an instrument and ensure it keeps up-to-date:

``` ruby
action [:create, update]
```

### Add

Add a metric stream to an existing instrument:

``` ruby
librato_metrics_instrument "example" do
  metric "super"
  source "*"
  group_function "sum"
  action :add
end
```
